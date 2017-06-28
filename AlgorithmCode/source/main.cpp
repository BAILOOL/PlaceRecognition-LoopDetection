#include <fstream>
#include <sstream>
#include <stdio.h>
#include <iostream>
#include <utility>
#include <vector>
#include <cmath>

using namespace std;

unsigned int windowSize; //search window size parameter
int timeConstraint = 30; //time constraint in term of image index
int distConstraint = 2; //distance constrain in meters

class PointExtra{
public:
    int imIdx;
    float x,y,z;
    string label;
    PointExtra(int _imIdx, float _x, float _y, float _z, string _label):
        imIdx(_imIdx), x(_x), y(_y), z(_z), label(_label) {}
};

class Point{
public:
    float x,y,z;
    Point(float _x, float _y, float _z):
        x(_x), y(_y), z(_z) {}
};

class Sequence{
public:
    vector<int> imIdx;
    vector<string> labels;
    vector<float> distances;
    vector<Point> points;
};

float getDist(Point p1, Point p2){
    float term1 = (p1.x-p2.x)*(p1.x-p2.x);
    float term2 = (p1.y-p2.y)*(p1.y-p2.y);
    float term3 = (p1.z-p2.z)*(p1.z-p2.z);
    float distance = sqrt(term1+term2+term3);
    return distance;
}

//function to identify loops
vector<pair<Sequence*,Sequence*>> checkLoop(vector<Sequence*> allSeq){
    vector<pair<Sequence*,Sequence*>>results;
    for (unsigned int i=0; i<allSeq.size()-1; ++i){
        Sequence* s1 = allSeq[i];
        for (unsigned int j=i+1; j<allSeq.size();++j){
            bool matchFound = true;
            Sequence* s2 = allSeq[j];
            if (s1->imIdx.size()==s2->distances.size() && s1->imIdx.size()==windowSize){ //check window constraint
               for (unsigned int k=0; k<s1->imIdx.size();++k){
                    if (s1->labels[k]!=s2->labels[k] || (abs(s1->imIdx[k]-s2->imIdx[k])<100*timeConstraint ||
                                                         abs(s1->distances[k]-s2->distances[k])>distConstraint)){
                        matchFound = false;
                        break;
                    }
               }
            }
            else{
                matchFound = false;
            }
            if (matchFound){ //if loop is found
                pair<Sequence*,Sequence*> temp;
                temp = make_pair(s1,s2);
                results.push_back(temp);
            }
        }
    }
    return results;
}

//function to check possibility to current road marking to a certain sequence
bool isGoodToAdd(PointExtra p, Sequence* s){
    bool add = true;
    for (unsigned int i=0; i<s->imIdx.size();++i){
        if (abs(p.imIdx-s->imIdx[s->imIdx.size()-1])<timeConstraint){
            add = false;
        }
    }

    return add;
}


int main(int argc, char *argv[])
{

    clock_t startTimeMain = clock();

    if (argc < 2) { // We expect 2 arguments: the program name and the source path
        std::cerr << "Usage: " << argv[0] << "Please provide a path to a file which contains required paths" << std::endl;
        return 1;
    }

    ifstream inputFile(argv[1]);

    string pathTo3DPoints = "";
    string pathToListMatches = "";
    inputFile >> windowSize;
    inputFile >> pathTo3DPoints;
    inputFile >> pathToListMatches;
    inputFile.close();
    cout << "Input file path:" <<  pathTo3DPoints << endl;
    cout << "Output file path:" << pathToListMatches << endl;

    // reading input 3D points
    ifstream inputPointsFile(pathTo3DPoints);
    int nPoints;
    inputPointsFile >> nPoints;
    cout << "Number of input points: " << nPoints << endl;
    vector<PointExtra> pointVec;
    for (int i=0; i<nPoints; ++i){
        int imIdx;
        float x,y,z;
        string label;
        inputPointsFile >> imIdx >> x >> y >> z >> label;
        PointExtra tempClass = PointExtra(imIdx,x,y,z,label);
        pointVec.push_back(tempClass);
    }
    inputPointsFile.close();

    //prepare sequences
    vector<Sequence*> allSequences;
    vector<pair<Sequence*,Sequence*>> loopCandiates;
    for (unsigned int i=0; i<pointVec.size();++i){
        PointExtra curPoint = pointVec[i]; //get current point

        if (allSequences.size()==0){ //add very fist sequence
            //add new sequence with only current point
            Sequence* curSeq = new Sequence();
            curSeq->imIdx.push_back(curPoint.imIdx);
            curSeq->labels.push_back(curPoint.label);
            curSeq->distances.push_back(0);
            Point curPoints = Point(curPoint.x, curPoint.y, curPoint.z);
            curSeq->points.push_back(curPoints);
            allSequences.push_back(curSeq);
        }

        //create remaining sequences
        for (unsigned int j=0; j<allSequences.size();++j){
            Sequence* pushedSeq = allSequences[j];
            bool added = false;
            if (pushedSeq->imIdx.size()<windowSize && pushedSeq->imIdx.size()!=0 && isGoodToAdd(curPoint,pushedSeq)){ //if window constraint is satisfied
                pushedSeq->imIdx.push_back(curPoint.imIdx);
                pushedSeq->labels.push_back(curPoint.label);
                Point tempPoints = Point(curPoint.x, curPoint.y, curPoint.z);
                pushedSeq->distances.push_back(getDist(tempPoints,pushedSeq->points[pushedSeq->points.size()-1]));
                pushedSeq->points.push_back(tempPoints);
                added = true;
            }

            //add new sequence with only current point
            if (j==allSequences.size()-1 && added){
                Sequence* curSeq = new Sequence();
                curSeq->imIdx.push_back(curPoint.imIdx);
                curSeq->labels.push_back(curPoint.label);
                curSeq->distances.push_back(0);
                Point curPoints = Point(curPoint.x, curPoint.y, curPoint.z);
                curSeq->points.push_back(curPoints);
                allSequences.push_back(curSeq);
            }
        }
    }

    //check for recognized places/loops
    vector<pair<Sequence*,Sequence*>> loopCandPairs = checkLoop(allSequences);
    if (loopCandPairs.size()!=0){
        for (unsigned int z = 0; z<loopCandPairs.size();++z){
            loopCandiates.push_back(loopCandPairs[z]);
        }
    }

    clock_t totalTime = 1000*double( clock() - startTimeMain)/((double)CLOCKS_PER_SEC);
    cout << "Time to identify loops: " << totalTime << "miliseconds"<< endl;
    cout << "Number of loop candidates: " << loopCandiates.size() << endl;
    cout << "Reached the end of the program" << endl;


    //save matched image indexes
    ofstream outFile;
    outFile.open (pathToListMatches);
    for (unsigned int i=0; i<loopCandiates.size();++i){
        Sequence* s1 = loopCandiates[i].first;
        Sequence* s2 = loopCandiates[i].second;
        for (unsigned int j=0; j<s1->imIdx.size();++j){
            outFile << s1->imIdx[j] << " ";
        }
        outFile << endl;
        for (unsigned int j=0; j<s2->imIdx.size();++j){
            outFile << s2->imIdx[j] << " ";
        }
        outFile << endl;
    }

    outFile.close();

    return 0;
}
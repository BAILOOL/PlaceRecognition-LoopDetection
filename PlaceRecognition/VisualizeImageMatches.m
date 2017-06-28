%% retreive images to visualize matched regions
close all;
clear all;

%this parameter has to be the same as for place recognition code in input_path.txt
searchWindow = 4; 
fmt4 = '%d';

% path to folde storing images
% put a path to PlaceRecognition/Sequence/Left/
pathToImages1 = '/pathTo/PlaceRecognition&LoopDetectionData/PlaceRecognition/Sequence1/Left/';
pathToImages2 = '/pathTo/PlaceRecognition&LoopDetectionData/PlaceRecognition/Sequence2/Left/';

% read image_matches.txt to retrive matched image pairs
fileID = fopen('/pathTo/image_matches.txt','r');
C = fscanf(fileID,fmt4);
fclose(fileID);

allPairs = [];
for i=1:2*searchWindow:(size(C,1)-searchWindow)
    pair1 = C(i:i+searchWindow-1)';
    pair2 = C(i+searchWindow:i+2*searchWindow-1)';
    allPairs = [allPairs; pair1, pair2];
end

% read available image names from pathToImages1
list = dir(strcat(pathToImages1,'*png'));
numData = size(list,1);
nameList1 = {};
for i=1:numData %get list of image files
    nameList1{i,1} = list(i).name;
end

% read available image names from pathToImages2
list = dir(strcat(pathToImages2,'*png'));
numData = size(list,1);
nameList2 = {};
for i=1:numData %get list of image files
    nameList2{i,1} = list(i).name;
end

% visualize matches
for i=1:size(allPairs,1);
    figure;
    for j=1:size(allPairs,2)
        imIdx = allPairs(i,j);
        if (imIdx>20000)
            name = nameList2(imIdx-20000);
            I = imread(strcat(pathToImages2,nameList2{imIdx-20000,1}));
        else
            name = nameList1(imIdx);
            I = imread(strcat(pathToImages1,nameList1{imIdx,1}));
        end
        subplot(2,searchWindow,j); 
        imshow(I);
        title(int2str(imIdx));
    end
end
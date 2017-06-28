%% retreive images to visualize matched regions
close all;
clear all;

%this parameter has to be the same as for place recognition code in input_path.txt
searchWindow = 4; 
fmt4 = '%d';

% path to folde storing images
% put a path to LoopDetection/Sequence/Left/
pathToImages = '/pathTo/PlaceRecognition&LoopDetectionData/LoopDetection/Sequence/Left/';

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

% read available image names
list = dir(strcat(pathToImages,'*png'));
numData = size(list,1);
nameList = {};
for i=1:numData %get list of image files
    nameList{i,1} = list(i).name;
end

% visualize matches
for i=1:size(allPairs,1);
    figure;
    for j=1:size(allPairs,2)
        imIdx = allPairs(i,j);
        name = nameList(imIdx);
        I = imread(strcat(pathToImages,nameList{imIdx,1}));
        subplot(2,searchWindow,j); 
        imshow(I);
        title(int2str(imIdx));
    end
end
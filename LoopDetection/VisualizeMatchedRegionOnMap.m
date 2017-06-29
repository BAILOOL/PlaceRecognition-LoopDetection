%% Visualize poses, road marking detection, and matches 
close all;
clear all;

% path to file storing road marking 3D positions
% put a path to LoopDetection/road_marking_centroids_3Dposition.txt
path_road_marking_3D = '/pathTo/PlaceRecognition&LoopDetectionData/LoopDetection/road_marking_centroids_3Dposition.txt'

% path to file storing obtain poses
% put a path to LoopDetection/SLAM_Poses_Sequence.txt
path_poses = '/pathTo/PlaceRecognition&LoopDetectionData/LoopDetection/SLAM_Poses_Sequence.txt';

% reading and preparation of relevant data
file_road_marking_3D = fopen(path_road_marking_3D);
C = textscan(file_road_marking_3D,'%d %f %f %f %s');
fclose(file_road_marking_3D);
dataSize = size(C{1,1},1);
Point_temp = zeros(dataSize,3);
Point_temp(:,1) = C{1,2};
Point_temp(:,2) = C{1,3};
Point_temp(:,3) = C{1,4}; 
Point = Point_temp(2:end,:);

Poses = dlmread(path_poses);

% ploting road markings
plot3(Point(:,1),Point(:,2), Point(:,3), '.r', 'MarkerSize', 15);

% ploting poses
hold on;
for i=1:(length(Poses))
    TRes(i,:) = [Poses(i,4) Poses(i,8) Poses(i,12)];
end
plot3(TRes(:,1),TRes(:,2),TRes(:,3),'b.');

%this parameter has to be the same as for place recognition code in input_path.txt
searchWindow = 4;
fmt4 = '%d';
fileID = fopen('/pathTo/image_matches.txt','r');
C = fscanf(fileID,fmt4);
fclose(fileID);
allPairs = [];
for i=1:2*searchWindow:(size(C,1)-searchWindow)
    pair1 = C(i:i+searchWindow-1)';
    pair2 = C(i+searchWindow:i+2*searchWindow-1)';
    allPairs = [allPairs; pair1, pair2];
end

% draw lines between pairs
hold on;
for i=1:size(allPairs,1)
    for j=1:searchWindow
        ind1 = allPairs(i,j);
        ind2 = allPairs(i,searchWindow+j);
            pts = [TRes(ind1,:);TRes(ind2,:)];
            plot3(pts(:,1),pts(:,2),pts(:,3),'.','Color',[0 0.8 0],'MarkerSize', 30);
            hold on;
            line(pts(:,1), pts(:,2), pts(:,3), 'Color',[0 0.8 0]);
    end
end
axis equal
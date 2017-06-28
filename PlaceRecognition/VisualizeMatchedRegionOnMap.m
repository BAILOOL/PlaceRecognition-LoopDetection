%% Visualize poses and road marking detection
close all;
clear all;

% path to file storing road marking 3D positions
% put a path to PlaceRecognition/road_marking_centroids_3Dposition.txt
path_road_marking_3D = '/pathTo/PlaceRecognition&LoopDetectionData/PlaceRecognition/road_marking_centroids_3Dposition.txt'

% path to file storing obtain poses
% put a path to PlaceRecognition/SLAM_Poses_Sequence1.txt
% put a path to PlaceRecognition/SLAM_Poses_Sequence2.txt
path_poses1 = '/pathTo/PlaceRecognition&LoopDetectionData/PlaceRecognition/SLAM_Poses_Sequence1.txt';
path_poses2 = '/pathTo/PlaceRecognition&LoopDetectionData/PlaceRecognition/SLAM_Poses_Sequence2.txt';

% reading and preparation of relevant data
file_road_marking_3D = fopen(path_road_marking_3D);
C = textscan(file_road_marking_3D,'%d %f %f %f %s');
fclose(file_road_marking_3D);
dataSize = size(C{1,1},1);
Point_temp = zeros(dataSize,3);
Point_temp(:,1) = C{1,2};
Point_temp(:,2) = C{1,3};
Point_temp(:,3) = C{1,4}; 
Point = Point_temp(2:end,:)';

Poses1 = dlmread(path_poses1);
Poses2 = dlmread(path_poses2);

% ploting road markings
plot3(Point(1,1:166),Point(2,1:166), Point(3,1:166), '.r', 'MarkerSize', 15);
hold on;
plot3(Point(1,167:end)+3000,Point(2,167:end), Point(3,167:end), '.r', 'MarkerSize', 15);
hold on;
% ploting poses
hold on;
for i=1:(length(Poses1))
    TRes(i,:) = [Poses1(i,4) Poses1(i,8) Poses1(i,12)];
end
hold on;
for i=1:(length(Poses2))
    TRes2(i,:) = [Poses2(i,4) Poses2(i,8) Poses2(i,12)];
end
plot3(TRes(:,1),TRes(:,2),TRes(:,3),'b.');

TRes2(:,1) = TRes2(:,1) + 3000;
plot3(TRes2(:,1),TRes2(:,2),TRes2(:,3),'k.'); axis equal

%%  visualize matched regions
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
        if (ind2>20000 && ind1<20000)
            pts = [TRes(ind1,:);TRes2(ind2-20000,:)];
            plot3(pts(:,1),pts(:,2),pts(:,3),'.','Color',[0 0.8 0],'MarkerSize', 30);
            hold on;
            line(pts(:,1), pts(:,2), pts(:,3), 'Color',[0 0.8 0]);
        end
    end
end
axis off
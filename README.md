# Light-weight place recognition and loop detection using road markings

In order to reproduce results presented in the [paper](https://www.researchgate.net/publication/320557008_Light-weight_place_recognition_and_loop_detection_using_road_markings), follow the procedure below:
1. Download the [PlaceRecognition](http://143.248.39.254/PlaceRecognition.zip) and [LoopDetection](http://143.248.39.254/LoopDetection.zip) datasets.
The datasets structure are the following:
```
PlaceRecognition
│   stereo_params_sequence1.txt                 #stereo parameters for SLAM for Sequence1
|   stereo_params_sequence2.txt                 #stereo parameters for SLAM for Sequence2
|   SLAM_Poses_Sequence1.txt                    #poses of Sequence1 obtained by SLAM
|   SLAM_Poses_Sequence2.txt                    #poses of Sequence2 obtained by SLAM
│   road_marking_centroids_sequence1.txt        #road markings centroids&label of Sequence1 images  (not used for provided codes)
|   road_marking_centroids_sequence2.txt        #road markings centroids&label of Sequence2 images  (not used for provided codes)
|   road_marking_centroids_combined.txt         #road markings centroids&label of Sequence1 and Sequence2 images  (not used for provided codes)
|   road_marking_centroids_3Dposition.txt       #road markings centroids&label 3D position of both sequences (give path to this to run the codes)
└───Sequence1                                   #stores rectified images from Left and Right cameras 
│   └───Left
│   |       000000.png
│   |       000001.png
│   |       ...
│   └───Right
│           000000.png
│           000001.png
│           ...
│   
└───Sequence2                                   #stores rectified images from Left and Right cameras 
│   └───Left
│   |       000000.png
│   |       000001.png
│   |       ...
│   └───Right
│           000000.png
│           000001.png
│           ...
```

```
LoopDetection
│   stereo_params_sequence.txt                 #stereo parameters for SLAM for Sequence
|   SLAM_Poses_Sequence.txt                    #poses of Sequence obtained by SLAM
│   road_marking_centroids.txt                 #road markings centroids&label of Sequence images 
|   road_marking_centroids_3Dposition.txt      #road markings centroids&label 3D position of both sequences (give path to this to run the codes)
└───Sequence                                   #stores rectified images from Left and Right cameras 
│   └───Left
│   |       000000.png
│   |       000001.png
│   |       ...
│   └───Right
│           000000.png
│           000001.png
│           ...
```
2. Provide paths to appropriate files:
* set the following in *AlgorithmCode/input_info.txt* file ( make sure you do not have spaces in your path!):
  - search window size
  - path to *road_marking_centroids_3Dposition.txt*
  - path to *image_matches.txt* (the code creates this file by itself)
* Matlab codes (*LoopDetectionDrawPoses.m*, *VisualizeImageMatches.m*, *VisualizeMatchedRegionOnMap.m*) in both *PlaceRecognition* and *LoopDetection* folders contain path parameters that have to be set appropriately.

3. Compile main code code (written in cpp) in *AlgorithmCode* directory using cmake:
```
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release .. #for Release mode
cmake -DCMAKE_BUILD_TYPE=Debug .. #for Debug mode
make
```
To run the code ``` ./Place_Recognition ../input_info.txt ```.
Run Matlab codes from appropriate foldes (*PlaceRecognition* or *LoopDetection*) to visualize results.

# Light-weight place recognition and loop detection using road markings

In order to reproduce results presented in the [paper](), follow the procedure below:
1. Download the dataset from [here]().
2. Provide paths to appropriate files:
* set the following in *input_info.txt* file:
  - search window size
  - path to *road_marking_centroids_3Dposition.txt*
  - path to *image_matches.txt*
* Matlab codes (*LoopDetectionDrawPoses.m*, *VisualizeImageMatches.m*, *VisualizeMatchedRegionOnMap.m*) in both *PlaceRecognition* and *LoopDetection* folders contain path parameters that have to be set appropriately.

3. Compile main code code using cmake:
```
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release .. #for Release mode
cmake -DCMAKE_BUILD_TYPE=Debug .. #for Debug mode
make
```
To run the code ``` ./Place_Recognition ../input_info.txt ```.
Run Matlab codes from appropriate foldes (*PlaceRecognition* or *LoopDetection*) to visualize results.

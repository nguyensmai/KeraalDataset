Readme: Organization and format of Vicon, Kinect, video, alphapose openpose and Poppy control files

Authors: Maxime Devanne (maxime.devanne@uha.fr)
         Sao Mai Nguyen (nguyensmai@gmail.com)


*************************************************
The recordings are organized into 5 folders for each participant subgroup, the subfolders correspond to each recording modality, and sub-subfolders correspond to each of the 3 exercise types.

Groups : 1A= labelled patient coached by Poppy, 1B= unlabelled patient coached by Poppy, 2A= labelled healthy adults coached by Poppy, 2B= unlabelled healthy adults coached by Poppy, 3= labelled healthy participants simulating errors.

 In the case of groups 1a, 1b, 2a and 2b, each recording is given a unique number, which is the same for all recording modalities (The nomenclature of the files in the data set includes the following information: groupID/Modality/GroupId-Modality-ExerciseName-SubjectId-RecordingId.extension). In the case of group 3, the name of the file indicates the label of the error and the recording id. The nomenclature of the files in this case is : group3/Modality/G3_Modality_ExerciseName_ParticipantIdTrialId_label_RecordingId.extension. 
************************************************

The directories are:
group1A --- annotatorA
        |-- annotatorB
        |-- alphapose
        |-- blazepose
        |-- kinect	
        |-- openpose
        |-- videos

group1B --- kinect
        |-- alphapose
        |-- blazepose
        |-- openpose
        |-- videos


group2A --- annotatorA
        |-- annotatorB
        |-- alphapose
        |-- blazepose
        |-- kinect
        |-- openpose
        |-- videos


group2B --- kinect
        |-- alphapose
        |-- blazepose
        |-- openpose
        |-- videos

`
group3 --- kinect
        |-- alphapose
        |-- blazepose
        |-- openpose
        |-- videos
        |-- vicon

************************************************

1. Vicon System

1.1 Vicon skeleton
The Vicon files are acquired using Vicon Motion Capture System. 17 targets from ART were placed on the human body. The full list of target names and associated ids is:
0. Right Forearm
1. Left Forearm
2. Right Arm
3. Left Arm
4. Chest
5. Right Thigh
6. Left Thigh
7. Right Shoulder
8. Left Shoulder
9. Right Hand
10. Left Hand
11. Right Foot
12. Left Foot
13. Hips
14. Head
15. Right Tibia
16. Left Tibia

1.2 Vicon files
Each Vicon file corresponds to a motion sequence. Within the file, each row represents a frame and includes 119 floating values corresponding to the 3D global position and the global orientation (Quaternion) of each target:
x_pos y_pos z_pos x_quat y_quat z_quat w_quat
Each target's position and quaternion is concatenated according to the order described in 1.1


2. Kinect System

2.1 Kinect skeleton
The Kinect skeleton includes 25 joints:
0. SpineBase
1. SpineMid
2. Neck
3. Head
4. ShoulderLeft
5. ElbowLeft
6. WristLeft
7. HandLeft
8. ShoulderRight
9. ElbowRight
10. WristRight
11. HandRight
12. HipLeft
13. KneeLeft
14. AnkleLeft
15. FootLeft
16. HipRight
17. KneeRight
18. AnkleRight
19. FootRight
20. SpineShoulder
21. HandTipLeft
22. ThumbLeft
23. HandTipRight
24. ThumbRight

2.2 Kinect files
Each Kinect file corresponds to a motion sequence. Within the file, each row represents a frame and includes 175 floating values corresponding to the 3D position and the orientation (Quaternion) of each joint:
x_pos y_pos z_pos x_quat y_quat z_quat w_quat
Each joint's position and quaternion is concatenated according to the order described in 2.2


3. OpenPose 

3.1. Coco_18 Model for OpenPose
The OpenPose skeleton used is the COCO_18 model as in https://github.com/CMU-Perceptual-Computing-Lab/openpose/blob/5e57c2d0181dca49095b0853a2421fa310b77f03/src/openpose/pose/poseParameters.cpp, from which we have recorded the following joints:
0. Nose 
1. Neck 
2. rShoulder
3. rElbow
4. rWrist
5. lShoulder
6. lElbow
7. lWrist
8. rHip
9. rKnee
10. rAnkle
11. lHip
12. lKnee
13. lAnkle
14. rEye
15. lEye
16. rEar
17. lEar

3.2. OpenPose joints
Each file corresponds to a motion sequence. within the file, is a dictionary of positions. The second level of dictionary is the video frame number. The third level of the dictionary is the joint name. For each joint is a 2D position :
x_pos, y_pos


4. BlazePose 

4.1. The 33 human body keypoints for BlazePose
The BlazePose skeleton used is a new topology of 33 human body keypoints, which is a superset of COCO, 
BlazeFace and BlazePalm topologies, from which we have recorded the following joints:
 Nose 
 Left_eye_inner 
 Left_eye 
 Left_eye_outer 
 Right_eye_inner 
 Right_eye 
 Right_eye_outer 
 Left_ear 
 Right_ear 
 Mouth_left 
 Mouth_right 
 Left_shoulder 
 Right_shoulder 
 Left_elbow 
 Right_elbow 
 Left_wrist 
 Right_wrist 
 Left_pinky 
 Right_pinky 
 Left_index 
 Right_index 
 Left_thumb 
 Right_thumb 
 Left_hip 
 Right_hip 
 Left_knee 
 Right_knee 
 Left_ankle 
 Right_ankle 
 Left_heel 
 Right_heel 
 Left_foot_index 
 Right_foot_index 

4.2. BlazePose joints
Each file corresponds to a motion sequence. within the file, is a dictionary of positions. The second level of dictionary is the video frame number. The third level of the dictionary is the joint name. For each joint is a 3D position :
x_pos, y_pos, z_pos
Where z_pos represents the depth with respect to the video plane.


5. AlphaPose 

3.1. Coco Model 
The AlphaPose skeleton used is the COCO model (17 body parts as in https://github.com/MVIG-SJTU/AlphaPose/blob/c60106d19afb443e964df6f06ed1842962f5f1f7/docs/output.md), from which we have recorded the following joints:
0.  Nose
1.  LEye
2.  REye
3.  LEar
4.  REar
5.  LShoulder
6.  RShoulder
7.  LElbow
8.  RElbow
9.  LWrist
10. RWrist
11. LHip
12. RHip
13. LKnee
14. Rknee
15. LAnkle
16. RAnkle


5.2. AphaPose joints
Each file corresponds to a motion sequence. within the file, is a dictionary of positions. The second level of dictionary is the video frame number. The third level of the dictionary is the joint name. For each joint is a 2D position :
x_pos, y_pos

6. Control command files of the robot Poppy to demonstrate the three exercises.

They are json files that use the syntax commonly used by the library pypot as described in its documentation (https://docs.poppy-project.org/en/programming/python.html) and can be used with the web-interface developed by the project Keraal (https://github.com/GRLab/Poppy_GRR) to execute on Poppy. They can be used with the physical robot Poppy or its simulation. 

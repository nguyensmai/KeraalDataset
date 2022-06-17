import cv2
import mediapipe as mp
import os
import numpy as np
import json
mp_pose = mp.solutions.pose

#Process all Video, note the position x,y,z
total_path = "../keraal_medical_mvt_dataset_original_reordered_anonymised"

for group_name in os.listdir(total_path):
    group_path = os.path.join(total_path, group_name)
    video_path = os.path.join(group_path,"videosOriginal")
    blazepose_path = os.path.join(group_path,"blazepose")
    # print(video_path)

    if not os.path.exists(blazepose_path):
        os.mkdir(blazepose_path)
    video_dir = os.listdir(video_path)

    for video in video_dir:
        file_path_read = os.path.join(video_path,video)
        file_path_write = os.path.join(blazepose_path,video.split('.')[0]+'.json')
        if os.path.exists(file_path_write):
            print("already exist")
            continue
        frame_len = 1.0
        dic = {'positions':{}}
        print(file_path_read)
        print(file_path_write)
        # file_to_write=open(file_path_write,"w+")
        cap = cv2.VideoCapture(file_path_read)
        with mp_pose.Pose(
            min_detection_confidence=0.5,
            min_tracking_confidence=0.5) as pose:
            while cap.isOpened():
                success, image = cap.read()
                if not success:
                    print("Ignoring empty camera frame.")
                    # If loading a video, use 'break' instead of 'continue'.
                    break
                # Flip the image horizontally for a later selfie-view display, and convert
            # the BGR image to RGB.
                image = cv2.cvtColor(cv2.flip(image, 1), cv2.COLOR_BGR2RGB)
            # To improve performance, optionally mark the image as not writeable to
            # pass by reference.
                image.flags.writeable = False
                results = pose.process(image)

                if not results.pose_landmarks:
                    continue
                # keypoints = [0 for i in range(33*3)] 
                # print(results.pose_landmarks.landmark)
                len_fin = 3 #we stoke the x,y,z dimension.
                frame = {
                        "Nose":[0 for i in range(len_fin)],
                        "Left_eye_inner":[0 for i in range(len_fin)],"Left_eye":[0 for i in range(len_fin)],"Left_eye_outer":[0 for i in range(len_fin)],
                        "Right_eye_inner":[0 for i in range(len_fin)],"Right_eye":[0 for i in range(len_fin)],"Right_eye_outer":[0 for i in range(len_fin)],
                        "Left_ear":[0 for i in range(len_fin)],"Right_ear":[0 for i in range(len_fin)],"Mouth_left":[0 for i in range(len_fin)],"Mouth_right":[0 for i in range(len_fin)],
                        "Left_shoulder":[0 for i in range(len_fin)],"Right_shoulder":[0 for i in range(len_fin)],"Left_elbow":[0 for i in range(len_fin)],"Right_elbow":[0 for i in range(len_fin)],
                        "Left_wrist":[0 for i in range(len_fin)],"Right_wrist":[0 for i in range(len_fin)],"Left_pinky":[0 for i in range(len_fin)],"Right_pinky":[0 for i in range(len_fin)],
                        "Left_index":[0 for i in range(len_fin)],"Right_index":[0 for i in range(len_fin)],"Left_thumb":[0 for i in range(len_fin)],"Right_thumb":[0 for i in range(len_fin)],
                        "Left_hip":[0 for i in range(len_fin)],"Right_hip":[0 for i in range(len_fin)],"Left_knee":[0 for i in range(len_fin)],"Right_knee":[0 for i in range(len_fin)],
                        "Left_ankle":[0 for i in range(len_fin)],"Right_ankle":[0 for i in range(len_fin)],"Left_heel":[0 for i in range(len_fin)],"Right_heel":[0 for i in range(len_fin)],
                        "Left_foot_index":[0 for i in range(len_fin)],"Right_foot_index":[0 for i in range(len_fin)]
                    }
                j = 0 #Avoid appends
                skeleton = list(frame.keys())
                # print(skeleton)
                for data_point in results.pose_landmarks.landmark: #Keypoints contain all of the landmarks
                    frame[skeleton[j]][0]=data_point.x 
                    frame[skeleton[j]][1]=data_point.y
                    frame[skeleton[j]][2]=data_point.z
                    j += 1
                dic["positions"][str(frame_len)] = frame
                frame_len += 1
            # print(dic)
            with open(file_path_write, 'w') as json_file:
                json.dump(dic, json_file)
            
            
            cap.release()
            
            json_file.close()

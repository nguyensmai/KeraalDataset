# Code for Keraal Dataset

The Keraal dataset is a medical database of clinical patients carrying out low back-pain rehabilitation exercises.
This repository  includes the accompagnying code and the documentation for the Keraal Dataset.


# Dataset files

The dataset includes RGB video and skeleton files : from the kinect, the vicon, open-pose and blazepose. It also includes annotation files from 5 annotators.  
The files constituting the dataset are described in readme_files_description.txt.

Our dataset is composed of :

* Control command files of the robot Poppy to demonstrate the three exercises. They are json files that use the syntax commonly used by the library pypot as described in its documentation and can be used with the web-interface developed by the project Keraal to execute on Poppy. They can be used with the physical robot Poppy or its simulation.
* the therapist's annotation in a xml anvil format. They indicate  whether the execution is correct, the label of the error, the body-part causing the error and the temporal description of the beginning and ending timestamps of the error.
* anonymised RGB videos. The videos are of avi and resolution 960x544 for Group3. They are of mp4  and resolution 480x360 for groups 1a, 1b, 2a and 2b. The resolution was kept low during the coaching sessions with the robot to allow for real-time coaching. 
* the positions and orientations of each joint of the Microsoft Kinect skeleton.  The txt files display in a table, a line per timestamp. The data are presented in ASCII txt format, with space delimiter used for separating the values of positions and orientations of each joint in the order of the skeleton numbering.
* the 2D positions of each joint of the OpenPose skeleton in the COCO pose output format. The txt files give the x and y positions on each video frame in the format of a dictionary of video frame numbers and joint names.
* the positions and orientations of each joint of the Vicon skeleton.  The txt files display in a table,  a line per timestamp.
    
#Draw Skeleton Code

The draw_skeleton code includes a python notebook to visualise the skeleton data, and the library code.
Please download the pretrained open_pose model pose_model.pth beforehand.

#Analyse Skeleton Code

The analyse_skeleton code includes python code to use open_pose on the RGB videos to extract the open_pose skeletons.
Please download the pretrained open_pose model pose_model.pth beforehand.


# Citation

Please cite this dataset with the following citation :

    @article{cite-key,
	author = {de Mauroy, Jean C. and Blanchard, Agathe and Nguyen, Sao Mai and Devanne, Maxime and Simonnet, Mathieu and Le Goff-Pronost, Myriam and Remy-Neris, Olivier},
	journal = {BioMed Research International},
	pages = {5667223},
	title = {Technical Feasibility of Supervision of Stretching Exercises by a Humanoid Robot Coach for Chronic Low Back Pain: The R-COOL Randomized Trial},
	volume = {2022},
	year = {2022}}
 

# KinesiothErapy and Rehabilitation for Assisted Ambient Living (KERAAL) Dataset : Folders Content
 

## Doc folder    

The doc folder contains documentation about the contents of each folder and the format used in the data files of Keraal dataset.

## Draw Skeleton folder

The draw_skeleton folder includes :
* keraalDataset_draw_skeleton.ipynb : as a python notebook to visualise the skeleton data, 
* dataSampleKeraal folder:  contains the skeleton data files,
* lib folder : the library code.


## Get Skeletons From Videos Folder

The get_skeletons_from_videos folder includes python code to use open_pose on the RGB videos to extract the open_pose skeletons:

* requirements.txt : required libraries
* get_blazepose_skeleton.py : to process the BlazePose skeleton  from all videos and output json files* get_openpose_skeleton.py : to process the OpenPose skeleton  from all videos and output json files
Please download the pretrained open_pose model pose_model.pth beforehand(available on http://nguyensmai.free.fr/data/pose_model.pth). 

## Annotate Videos folder

The annotate_videos folder has information for the annotation. The folder contains :

* keraalSpec.xml : defines the template of the annotations
* createAnvil.py : a python code to create template annotation files to be edited with Anvil for each video in a given folder
* LabellisationDesVideos_fr.pdf : an explanation in French of the labels used in Keraal Dataset.

## Citation

Please cite this dataset with the following citation :


@article{Blanchard2022BRI,
	author = {Agathe Blanchard and Sao Mai Nguyen and Maxime Devanne and Mathieu Simonnet and Myriam Le Goff-Pronost and Olivier Remy-Neris},
	journal = {BioMed Research International},
	month = {mar},
	pages = {1--10},
	title = {Technical Feasibility of Supervision of Stretching Exercises by a Humanoid Robot Coach for Chronic Low Back Pain: The R-COOL Randomized Trial},
	volume = {2022},
	year = 2022}

 

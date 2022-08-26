Gaussian Mixture Model (GMM) on Riemannian manifold


# Principle
This approach extemds the Gaussian Mixture Model (GMM) to Riemannian manifolds where rotation data such as quaternions are naturally represented. A more theoretical presentation of this can be found in :


    M J A Zeestraten, I Havoutis, J Silvério, S Calinon and D G Caldwell. An Approach for Imitation Learning on Riemannian Manifolds. IEEE Robotics and Automation Letters (RA-L) 2(3):1240–1247, June 2017


In our case, Riemannian manifold proposed is a combination of cartesion spaces (for positions) and Riemannian spaces (for orientations) of each joint of the human body skeleton. For more information. please refer to


    Maxime Devanne, Sao Mai Nguyen. Multi-level Motion Analysis for Physical Exercises Assessment in Kinaesthetic Rehabilitation. IEEE-RAS International Conference on Humanoid Robots 2017, Birmingham, UK.


#Code

This code is in matlab. The two main files are :

- for learning : mainLearning.m that learns a reference movement from demonstrations. First we load the kinect recordings of the correct movements of the exercise. The format is a matrix where each line corresponds to a timestamp, and the columns correpond to the 3D positions and orientations (quaternion) of each joint in the order of hierarchy of the skeleton. In this code, only the upper body joints are analysed. If registration=1 is set, temporal alignment between the recordings is processed. The functions 'segmentSequence' and 'segmentSequenceKeyPose' cut a recordng into different temporal blocks.  xIn and uIn correspond to timestamp data, xOut is the position for each joint and uOut is the projection in the tangent space for each joint angle. The GMM is learned from this data, and the hyperparameter model.nbStates which sets the number of Gaussians in the GMM.

- for testing : mainEvaluation.m that can evaluate a test movement from a learned reference. 'Seuil' is the threshold parameter to compute the scores as percentage. It is a negative number. The closer to 0, the stricter the score computing is.

- learnErrorFeatures.m can learn possible errors for an exercise. The idea is to learn from data labelled as errors. The difference between each error and the reference movement is learned by a SVM.




# Citation

Please cite this code for GMM on Riemannian manifolds with the following citation :


@inproceedings{Devanne2017ICHRH,
	author = {Devanne, Maxime and Nguyen, Sao Mai},
	booktitle = {International Conference on Humanoid Robots (Humanoids)},
	editor = {IEEE},
	title = {Multi-level Motion Analysis for Physical Exercises Assessment in Kinaesthetic Rehabilitation},
	year = {2017}}

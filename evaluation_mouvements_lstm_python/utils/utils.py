import numpy as np
from scipy import signal
import xml.etree.ElementTree as ET
import os, sys
from sklearn.metrics import confusion_matrix
import matplotlib.pyplot as plt
import itertools
import math

def load_dataset(pathTrain, pathTest, exercice, onlyMainJoints=True):
	# train
	x_train_list=[]
	y_train_list=[]	
	for sub in range(0,3):
		for trial in range(0,3):
			for samp in range(0,5):
				direc = 'sub' + '{:0>2}'.format(sub+1) + '_trial' + '{:0>2}'.format(trial+1) + '/processed/'
				pathPC = pathTrain + 'kinect/' + exercice + '/' + direc + 'Position_SkeletonKinect_Correct' + str(samp) + '.txt'
				pathOC = pathTrain + 'kinect/' + exercice + '/' + direc + 'Orientation_SkeletonKinect_Correct' + str(samp) + '.txt'
				dataC = load_skeleton_data_processed(pathPC,pathOC,onlyMainJoints)
				x_train_list.append(dataC)
				y_train_list.append(0)
				#if trial==0:
				#	continue	
				for bp in range(2,3):
					pathPE = pathTrain + 'kinect/' + exercice + '/' + direc + 'Position_SkeletonKinect_Error' + str(trial+1) + 'Bodypart' + str(bp+1) + '_' + str(samp) + '.txt'
					pathOE = pathTrain + 'kinect/' + exercice + '/' + direc + 'Orientation_SkeletonKinect_Error' + str(trial+1) + 'Bodypart' + str(bp+1) + '_' + str(samp) + '.txt'
					dataE = load_skeleton_data_processed(pathPE,pathOE,onlyMainJoints)
					x_train_list.append(dataE)
					y_train_list.append(trial+1) # only for etirementLateraux, otherwise trial+1
	x_train_list = np.asarray(x_train_list)
	y_train_list = np.asarray(y_train_list)

	# test
	x_test_list=[]
	y_test_bin_list=[]
	y_test_multi_list=[]
	numFiles = (int)(len(os.listdir(pathTest + 'skeletons/' + exercice + '/processed/'))/2)
	for i in range(numFiles):
		pathO = pathTest + 'skeletons/' + exercice + '/processed/Orientation_Skeleton' + '{:0>3}'.format(i+1) + '.txt'
		pathP = pathTest + 'skeletons/' + exercice + '/processed/Position_Skeleton' + '{:0>3}'.format(i+1) + '.txt'
		data = load_skeleton_data_processed(pathP,pathO,onlyMainJoints)
		x_test_list.append(data)

		pathA = pathTest + 'annotations_Olivier/' + exercice + '/Vid' + '{:0>3}'.format(i+1) + '.anvil'
		ybin,ymulti = readAnnotationFile(pathA)
		y_test_bin_list.append(ybin)
		y_test_multi_list.append(ymulti)
	x_test_list = np.asarray(x_test_list)
	y_test_bin_list = np.asarray(y_test_bin_list)
	y_test_multi_list = np.asarray(y_test_multi_list)

	return x_train_list,y_train_list,x_test_list,y_test_bin_list,y_test_multi_list

def load_skeleton_data_processed(pathP, pathO, onlyMainJoints):
	dataO = np.loadtxt(pathO, delimiter=',')
	dataP = np.loadtxt(pathP, delimiter=',')
	if onlyMainJoints==True:
		# keep only main joints
		dataO = np.reshape(dataO,(dataO.shape[0],25,4))
		dataO = dataO[:,[1,2,20,4,5,6,8,9,10],:]
		dataO = np.reshape(dataO,(dataO.shape[0],36))
		dataP = np.reshape(dataP,(dataP.shape[0],25,3))
		dataP = dataP[:,[1,2,20,4,5,6,8,9,10],:]
		dataP = np.reshape(dataP,(dataP.shape[0],27))
	data = np.hstack((dataO,dataP))
	return data

def readAnnotationFile(path):
	tree = ET.parse(path)
	root = tree.getroot()
	ybin = -1
	ymulti = -1
	for track in root.iter('track'):
		if track.attrib.get('name')=='Global evaluation':
			if track.find('el').find('attribute').text == 'Correct':
				ybin=0
				ymulti=0
				return ybin,ymulti
			else:
				if track.find('el').find('attribute').text == 'Incomplete':
					ybin=1
					ymulti=4
					return ybin,ymulti
				if track.find('el').find('attribute').text == 'Motionless':
					ybin=1
					ymulti=5
					return ybin,ymulti
		else:
			if track.attrib.get('name') =='Global error':
				for attr in track.find('el').iter('attribute'):
					if attr.get('name') == 'type':
						if attr.text == 'Error1':
							ybin=1
							ymulti=1
							return ybin,ymulti
						else:
							if attr.text == 'Error2':
								ybin=1
								ymulti=2
								return ybin,ymulti
							elif attr.text == 'Error3':
								ybin=1
								ymulti=3
								return ybin,ymulti
	return ybin,ymulti


def plot_confusion_matrix(cm, classes,
                        normalize=True,
                        title='',
                        cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    print(cm)

    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    if title is not None:
    	plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    
    cm_temp = cm
    cm_temp[np.where(np.isnan(cm))]=0
    thresh = cm_temp.max() / 2.
    print(thresh)
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
    	if math.isnan(cm[i,j]):
    		plt.text(j, i, "-",
            horizontalalignment="center",
            color="black")
    	else:
        	plt.text(j, i, "{:.2f}".format(cm[i, j]),
            horizontalalignment="center",
            color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.tight_layout()
    plt.savefig('confmat.png')

def plot_detection_matrix(cm, classes,
                        normalize=True,
                        title='',
                        cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    cm_tmp = cm # to keep absolute values 
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    print(cm)

    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    if title is not None:
    	plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    

    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
    	if math.isnan(cm_tmp[i,j]):
    		plt.text(j, i, "-",
            horizontalalignment="center",
            color="black")
    	else:
    		if i==j:
    			plt.text(j, i, "{:02d}".format(cm_tmp[i, j]),
            	horizontalalignment="center", weight='bold', fontsize=14,
            	color="white" if cm[i, j] > thresh else "black")
    		elif i==1 and j==0: # just to write in red large errors
    			plt.text(j, i, "{:02d}".format(cm_tmp[i, j]),
            	horizontalalignment="center", fontsize=14,
            	color="red")
    		else:
	        	plt.text(j, i, "{:02d}".format(cm_tmp[i, j]),
	            horizontalalignment="center", fontsize=14,
	            color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True')
    plt.xlabel('Predicted')
    plt.tight_layout()
    plt.savefig('confmat.png')

def plot_conf_mat(y_true, y_pred):
	cm = confusion_matrix(y_true=y_true, y_pred=y_pred)
	numClasses = np.max(y_true) +1
	cm_plot_labels = ['Correct']
	for er in range(1,numClasses):
		cm_plot_labels.append('Error' + str(er))
	plot_confusion_matrix(cm=cm, classes=cm_plot_labels)
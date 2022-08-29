import numpy as np 
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from utils.utils import *
import matplotlib.pyplot as plt
from lstm_classifier import LSTM_CLASSIF
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import OneHotEncoder

pathTrain ='./data/train_data/'
pathTest ='./data/test_data/'

# load_skeleton_data_processed(path)
exercice = 'cacheTete'

x_train,y_train,x_test,y_bin,y_multi = load_dataset(pathTrain,pathTest,exercice)
print(x_train.shape, y_train.shape, x_test.shape, y_bin.shape, y_multi.shape)


# keep only test samples that are correct or one of the 3 errors (y<4)
x_test = x_test[np.where(y_multi<4),:,:][0]
y_multi = y_multi[np.where(y_multi<4),][0]

# modidy labels to one-hot vectors
y_train_test = np.concatenate((y_train,y_multi),axis =0)
encoder = LabelEncoder()
new_y_train_test = encoder.fit_transform(y_train_test)
encoder = OneHotEncoder()
new_y_train_test = encoder.fit_transform(new_y_train_test.reshape(-1,1))
new_y_train = new_y_train_test[0:len(y_train)].toarray()
new_y_test = new_y_train_test[len(y_train):].toarray()
print('new_y_train',new_y_train.shape) 
print('new_y_test',new_y_test.shape)

input_shape=x_train.shape[1:]

neurons=512
num_layers=3

model = LSTM_CLASSIF(input_shape, num_layers, neurons=neurons)

batch_size = 32
num_epochs = 1000

hist = model.fit(x_train,new_y_train,batch_size,num_epochs)

loss, acc = model.evaluate(x_test,new_y_test)

print(loss)
print(acc)


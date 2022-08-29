import numpy as np 
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from utils.utils import *
import matplotlib.pyplot as plt
from lstm_ae import LSTM_AE

pathTrain ='./data/train_data/'
pathTest ='./data/test_data/'

# load_skeleton_data_processed(path)
exercice = 'cacheTete'

x_train,y_train,x_test,y_bin,y_multi = load_dataset(pathTrain,pathTest,exercice)
print(x_train.shape, y_train.shape, x_test.shape, y_bin.shape, y_multi.shape)

# keep only correct samples to train the autoencoder (y==0)
train_data = x_train[np.where(y_train==0),:,:][0]
print(train_data.shape)

input_shape=train_data.shape[1:]

neurons=512
num_layers=3

model = LSTM_AE(input_shape, num_layers, neurons=neurons)

batch_size = 32
num_epochs = 200

hist = model.fit(train_data,train_data,batch_size,num_epochs)

errors =[]
y_pred = model.predict(x_test)
for i in range(x_test.shape[0]):
	mse  = np.mean((x_test[i]-y_pred[i]) ** 2)
	errors.append(mse)
plt.plot(errors)
plt.plot(y_bin)
plt.show()

import numpy as np 
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from utils.utils import *

import tensorflow as tf

class LSTM_AE:

    def __init__(self, input_shape, num_layers, neurons, build=True):
        self.neurons = neurons

        if build == True:
            self.model = self.build_model(input_shape, num_layers, neurons)
            self.model.summary()

    def build_model(self, input_shape, num_layers, neurons):
        inputs = tf.keras.layers.Input(input_shape, name='inputs')

        # lstm layers, intermediate layers return sequences of hidden states, last layer returns last hidden state only
        if num_layers>1:
            # first lstm layer
            lstm_enc_output = tf.keras.layers.LSTM(neurons, name='lstm_enc_1', return_sequences=True)(inputs)
            # other lstm layers if num_layers>1
            for l in range(2,num_layers):
                name_layer = 'lstm_enc_' + str(l)
                lstm_enc_output = tf.keras.layers.LSTM(neurons, name=name_layer, return_sequences=True)(lstm_enc_output)
            # last layer (return last hidden state)
            name_layer = 'lstm_enc_' + str(num_layers)
            lstm_enc_output = tf.keras.layers.LSTM(neurons, name=name_layer, return_sequences=False)(lstm_enc_output)
        else:
            lstm_enc_output = tf.keras.layers.LSTM(neurons, name='lstm_enc_1', return_sequences=False)(inputs)

        repeated = tf.keras.layers.RepeatVector(input_shape[0], name='repeated')(lstm_enc_output)

        lstm_dec_output = tf.keras.layers.LSTM(neurons, name='lstm_dec_1', return_sequences=True)(repeated)
        if num_layers>1:
            for l in range(2,num_layers+1):
                name_layer = 'lstm_dec_' + str(l)
                lstm_dec_output = tf.keras.layers.LSTM(neurons, name=name_layer, return_sequences=True)(lstm_dec_output)

        outputs = tf.keras.layers.TimeDistributed(tf.keras.layers.Dense(input_shape[1]))(lstm_dec_output)

        model = tf.keras.models.Model(inputs=inputs, outputs=outputs)

        optimizer = tf.keras.optimizers.Adam(1e-3)

        model.compile(optimizer=optimizer, loss='mse')

        return model
        
    def fit(self, x_train, y_train, batch_size, nb_epochs):
        hist = self.model.fit(x_train,y_train, batch_size=batch_size, epochs=nb_epochs, verbose=True)
        return hist

    def predict(self, x_test):
        y_pred = self.model.predict(x_test)
        return y_pred
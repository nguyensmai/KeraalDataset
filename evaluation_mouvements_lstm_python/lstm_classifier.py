import numpy as np 
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from utils.utils import *

import tensorflow as tf

class LSTM_CLASSIF:

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

        outputs = tf.keras.layers.Dense(4,activation='softmax')(lstm_enc_output)
        
        model = tf.keras.models.Model(inputs=inputs, outputs=outputs)

        optimizer = tf.keras.optimizers.Adam(1e-3)

        model.compile(optimizer=optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

        return model
        
    def fit(self, x_train, y_train, batch_size, nb_epochs):
        hist = self.model.fit(x_train,y_train, batch_size=batch_size, epochs=nb_epochs, verbose=True)
        return hist

    def predict(self, x_test):
        y_pred = self.model.predict(x_test)
        return y_pred

    def evaluate(self, x_test, y_true):
        loss, acc = self.model.evaluate(x_test,y_true)
        return loss, acc

#!/usr/bin/env python
# coding: utf-8

# In[1]:


# python notebook for Make Your Own Neural Network
# code for a 3-layer neural network, and code for learning the MNIST dataset
# (c) Tariq Rashid, 2016
# license is GPLv2


# In[2]:


%%%import numpy
# scipy.special for the sigmoid function expit()
%%%import scipy.special
# library for plotting arrays
%%%import matplotlib.pyplot
# ensure the plots are inside this notebook, not an external window
%%%get_ipython().run_line_magic('matplotlib', 'inline')


# In[3]:


# neural network class definition
%%%class neuralNetwork:
    
global self_inodes = 784;
global self_hnodes = 200;
global self_onodes = 10;
global self_wih = (2*rand(self_hnodes,self_inodes)-1.0)/sqrt(self_inodes); %%%numpy.random.normal(0.0, pow(self.inodes, -0.5), (self.hnodes, self.inodes))
global self_who = (2*rand(self_onodes,self_hnodes)-1.0)/sqrt(self_hnodes); %%%numpy.random.normal(0.0, pow(self.hnodes, -0.5), (self.onodes, self.hnodes))
global self_lr = 0.1;
global self_activation_function = @(x) 1./(1+e.^(-x));   # sigmoid
    
    # initialise the neural network
%    def __init__(self, inputnodes, hiddennodes, outputnodes, learningrate):
%        # set number of nodes in each input, hidden, output layer
%        self.inodes = inputnodes
%        self.hnodes = hiddennodes
%        self.onodes = outputnodes
%        
%        # link weight matrices, wih and who
%        # weights inside the arrays are w_i_j, where link is from node i to node j in the next layer
%        # w11 w21
%        # w12 w22 etc 
%        self.wih = numpy.random.normal(0.0, pow(self.inodes, -0.5), (self.hnodes, self.inodes))
%        self.who = numpy.random.normal(0.0, pow(self.hnodes, -0.5), (self.onodes, self.hnodes))
%
%        # learning rate
%        self.lr = learningrate
%        
%        # activation function is the sigmoid function
%        self.activation_function = lambda x: scipy.special.expit(x)
%        
%        %%%pass

    
    # train the neural network
    %%%def train(self, inputs_list, targets_list):
function train(inputs_list, targets_list)
        global self_wih;
        global self_who;
        global self_lr;
        global self_activation_function;
        
        # convert inputs list to 2d array
        %%%inputs = numpy.array(inputs_list, ndmin=2).T
        inputs = transpose(inputs_list);
        %%%targets = numpy.array(targets_list, ndmin=2).T
        targets = transpose(targets_list);
        
        # calculate signals into hidden layer
        hidden_inputs = self_wih * inputs;    %%%numpy.dot(self.wih, inputs)
        # calculate the signals emerging from hidden layer
        hidden_outputs = self_activation_function(hidden_inputs);
        
        # calculate signals into final output layer
        final_inputs = self_who * hidden_outputs;   %%%numpy.dot(self.who, hidden_outputs)
        # calculate the signals emerging from final output layer
        final_outputs = self_activation_function(final_inputs);
        
        # output layer error is the (target - actual)
        output_errors = targets - final_outputs;
        # hidden layer error is the output_errors, split by weights, recombined at hidden nodes
        hidden_errors = transpose(self_who) * output_errors;      %%%%numpy.dot(self.who.T, output_errors) 
        
        # update the weights for the links between the hidden and output layers
        %%%self.who += self.lr * numpy.dot((output_errors * final_outputs * (1.0 - final_outputs)), numpy.transpose(hidden_outputs))
        self_who += self_lr * (output_errors .* final_outputs .* (1.0 - final_outputs)) * transpose(hidden_outputs);
        
        # update the weights for the links between the input and hidden layers
        %%%self.wih += self.lr * numpy.dot((hidden_errors * hidden_outputs * (1.0 - hidden_outputs)), numpy.transpose(inputs))
        self_wih += self_lr * (hidden_errors .* hidden_outputs .* (1.0 - hidden_outputs)) * transpose(inputs);
        %%%pass
endfunction
    
%    # query the neural network
%    def query(self, inputs_list):
%        # convert inputs list to 2d array
%        inputs = numpy.array(inputs_list, ndmin=2).T
%        
%        # calculate signals into hidden layer
%        hidden_inputs = numpy.dot(self.wih, inputs)
%        # calculate the signals emerging from hidden layer
%        hidden_outputs = self.activation_function(hidden_inputs)
%        
%        # calculate signals into final output layer
%        final_inputs = numpy.dot(self.who, hidden_outputs)
%        # calculate the signals emerging from final output layer
%        final_outputs = self.activation_function(final_inputs)
%        
%        return final_outputs

function final_outputs = query(inputs_list)
        global self_wih;
        global self_who;
        global self_activation_function;
        
%        disp("Wih");
%        disp(self_wih);
%        disp("Who");
%        disp(self_who);
        
        # convert inputs list to 2d array
        inputs = transpose(inputs_list);
        
        # calculate signals into hidden layer
        hidden_inputs = self_wih * inputs; %%%numpy.dot(self_wih, inputs)
        # calculate the signals emerging from hidden layer
        hidden_outputs = self_activation_function(hidden_inputs);
        
        # calculate signals into final output layer
        final_inputs = self_who * hidden_outputs; %%%numpy.dot(self_who, hidden_outputs)
        # calculate the signals emerging from final output layer
        final_outputs = self_activation_function(final_inputs);
endfunction

# In[4]:


%# number of input, hidden and output nodes
%input_nodes = 784
%hidden_nodes = 200
%output_nodes = 10
%
%# learning rate
%learning_rate = 0.1

# create instance of neural network
%%%n = neuralNetwork(input_nodes,hidden_nodes,output_nodes, learning_rate)


# In[5]:


# load the mnist training data CSV file into a list
%%%training_data_file = open("./mnist_dataset/mnist_train_100.csv", 'r')
%%%training_data_list = training_data_file.readlines()
%%%training_data_file.close()

training_data_list = dlmread("./mnist_dataset/mnist_train_100.csv", ",");

# In[6]:


# train the neural network

# epochs is the number of times the training data set is used for training
epochs = 150;

%for e in range(epochs):
%    # go through all records in the training data set
%    for record in training_data_list:
%        # split the record by the ',' commas
%        all_values = record.split(',')
%        # scale and shift the inputs
%        inputs = (numpy.asfarray(all_values[1:]) / 255.0 * 0.99) + 0.01
%        # create the target output values (all 0.01, except the desired label which is 0.99)
%        targets = numpy.zeros(output_nodes) + 0.01
%        # all_values[0] is the target label for this record
%        targets[int(all_values[0])] = 0.99
%        n.train(inputs, targets)
%        pass
%    pass

for i = 1:epochs
    for j = 1:rows(training_data_list)
        inputs = (training_data_list(j,2:end) ./ 255.0 .* 0.99) + 0.01;
        targets = zeros(1,self_onodes) + 0.01;
        targets(training_data_list(j,1)+1) = 0.99;
        train(inputs, targets);
    endfor
endfor
    
# In[7]:


# load the mnist test data CSV file into a list
%test_data_file = open("./mnist_dataset/mnist_test_10.csv", 'r')
%test_data_list = test_data_file.readlines()
%test_data_file.close()

test_data_list = dlmread("./mnist_dataset/mnist_test_10.csv", ",");

# In[8]:


# test the neural network

# scorecard for how well the network performs, initially empty
%%%scorecard = []

# go through all the records in the test data set
%for record in test_data_list:
%    # split the record by the ',' commas
%    all_values = record.split(',')
%    # correct answer is first value
%    correct_label = int(all_values[0])
%    # scale and shift the inputs
%    inputs = (numpy.asfarray(all_values[1:]) / 255.0 * 0.99) + 0.01
%    # query the network
%    outputs = n.query(inputs)
%    # the index of the highest value corresponds to the label
%    label = numpy.argmax(outputs)
%    # append correct or incorrect to list
%    if (label == correct_label):
%        # network's answer matches correct answer, add 1 to scorecard
%        scorecard.append(1)
%    else:
%        # network's answer doesn't match correct answer, add 0 to scorecard
%        scorecard.append(0)
%        pass
%    
%    pass

for j = 1:rows(test_data_list)    
    inputs = (test_data_list(j,2:end) ./ 255.0 .* 0.99) + 0.01;
    label = test_data_list(j,1);
    outputs = query(inputs);
    [v, idx] = max(outputs);
    printf("Target %i Found %i\n", label, idx-1);
    if label == idx-1
        scorecard(j) = 1;
    else
        scorecard(j) = 0;
    endif
endfor    

printf("Scorecard"), disp(scorecard);
printf("Performance %f\n", sum(scorecard)/columns(scorecard));
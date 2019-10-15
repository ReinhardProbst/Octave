#!/usr/bin/env python
# coding: utf-8

# In[1]:


# python notebook for Make Your Own Neural Network
# (c) Tariq Rashid, 2016
# license is GPLv2


# In[2]:


%%%import numpy
# scipy.special for the sigmoid function expit()
%%%import scipy.special


# In[3]:


# neural network class definition
%%%class neuralNetwork:

global self_inodes = 3;
global self_hnodes = 3;
global self_onodes = 3;
global self_wih = [-0.23827287,  0.24475038, -0.74675905;
                    0.49382443, -0.67371615,  0.00610111;
                   -1.18917521, -0.58651774,  0.00938789];
global self_who = [-0.17571258, -0.78167467, -0.56229072;
                    0.27963127,  0.13800698,  0.05526938;
                    0.31953907,  0.60225534, -0.15094372];
global self_lr = 0.3;
global self_activation_function = @(x) 1./(1+e.^(-x));   # sigmoid
    
    # initialise the neural network
%%%    def __init__(self, inputnodes, hiddennodes, outputnodes, learningrate):
%function init(inputnodes, hiddennodes, outputnodes, learningrate)
%        # set number of nodes in each input, hidden, output layer
%        global self_inodes = inputnodes;
%        global self_hnodes = hiddennodes;
%        global self_onodes = outputnodes;
%        
%        # link weight matrices, wih and who
%        # weights inside the arrays are w_i_j, where link is from node i to node j in the next layer
%        # w11 w21
%        # w12 w22 etc 
%        #self_wih = numpy.random.normal(0.0, pow(self_inodes, -0.5), (self_hnodes, self_inodes))
%        #self_who = numpy.random.normal(0.0, pow(self_hnodes, -0.5), (self_onodes, self_hnodes))
%
%        global self_wih = [-0.23827287,  0.24475038, -0.74675905;
%                            0.49382443, -0.67371615,  0.00610111;
%                           -1.18917521, -0.58651774,  0.00938789];
%
%        global self_who = [-0.17571258, -0.78167467, -0.56229072;
%                            0.27963127,  0.13800698,  0.05526938;
%                            0.31953907,  0.60225534, -0.15094372];
%
%        # learning rate
%        global self_lr = learningrate
%        
%        # activation function is the sigmoid function
%        %%%self_activation_function = lambda x: scipy.special.expit(x)
%        global self_activation_function = @(x) sigmoid(1./(1+e.^(-x)));
%        
%        disp("Wih");
%        disp(self_wih)
%        disp("Who");
%        disp(self_who);
%        
%        %%%pass
%endfunction
    
    # train the neural network
    %%%def train(self, inputs_list, targets_list):
function train(self, inputs_list, targets_list)
%        # convert inputs list to 2d array
%        inputs = numpy.array(inputs_list, ndmin=2).T
%        targets = numpy.array(targets_list, ndmin=2).T
%        
%        # calculate signals into hidden layer
%        hidden_inputs = numpy.dot(self_wih, inputs)
%        # calculate the signals emerging from hidden layer
%        hidden_outputs = self_activation_function(hidden_inputs)
%        
%        # calculate signals into final output layer
%        final_inputs = numpy.dot(self_who, hidden_outputs)
%        # calculate the signals emerging from final output layer
%        final_outputs = self_activation_function(final_inputs)
%        
%        # output layer error is the (target - actual)
%        output_errors = targets - final_outputs
%        # hidden layer error is the output_errors, split by weights, recombined at hidden nodes
%        hidden_errors = numpy.dot(self_who.T, output_errors) 
%        
%        # update the weights for the links between the hidden and output layers
%        self_who += self_lr * numpy.dot((output_errors * final_outputs * (1.0 - final_outputs)), numpy.transpose(hidden_outputs))
%        
%        # update the weights for the links between the input and hidden layers
%        self_wih += self_lr * numpy.dot((hidden_errors * hidden_outputs * (1.0 - hidden_outputs)), numpy.transpose(inputs))
        
        %%%pass
endfunction
    
    # query the neural network
    %%%def query(self, inputs_list):
function result = query(inputs_list)
        global self_wih;
        global self_who;
        global self_activation_function;
        
        disp("Wih");
        disp(self_wih);
        disp("Who");
        disp(self_who);
        
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
        
        result = final_outputs;
        %%%return final_outputs
endfunction

# number of input, hidden and output nodes
%%%input_nodes = 3
%%%hidden_nodes = 3
%%%output_nodes = 3

# learning rate is 0.3
%%%learning_rate = 0.3

# create instance of neural network
%%%n = neuralNetwork(input_nodes,hidden_nodes,output_nodes, learning_rate)

# In[5]:

# test query (doesn't mean anything useful yet)
final = query([1.0, 0.5, -1.5]);

disp("Query");
disp([1.0, 0.5, -1.5]);
disp("Final");
disp(final);
disp("Final expected");
disp([3.427322700865892413e-01, 5.717182815508076166e-01, 6.293889327757868912e-01]);

# Based on
# python notebook for Make Your Own Neural Network
# code for a 3-layer neural network, and code for learning the MNIST dataset
# (c) Tariq Rashid, 2016
# license is GPLv2
    
global self_inodes = 784;
global self_hnodes = 200;
global self_onodes = 10;
global self_wih = (2*rand(self_hnodes,self_inodes)-1.0)/sqrt(self_inodes);
global self_who = (2*rand(self_onodes,self_hnodes)-1.0)/sqrt(self_hnodes);
global self_lr = 0.1;
global self_activation_function = @(x) 1./(1+e.^(-x));   # sigmoid
global self_hidden_outputs;
global self_final_outputs;

fig_no = 0;

function train(inputs_list, targets_list)
        global self_wih;
        global self_who;
        global self_lr;
        global self_activation_function;
        
        inputs = transpose(inputs_list);       # Convert row vectors to column vectors
        targets = transpose(targets_list);        
        
        hidden_inputs = self_wih * inputs;                        # Calculate signals into hidden layer
        hidden_outputs = self_activation_function(hidden_inputs); # Calculate the signals emerging from hidden layer
        
        final_inputs = self_who * hidden_outputs;                 # Calculate signals into final output layer
        final_outputs = self_activation_function(final_inputs);   # Calculate the signals emerging from final output layer
        
        output_errors = targets - final_outputs;                  # Output layer error is the (target - actual)
        hidden_errors = transpose(self_who) * output_errors;      # Hidden layer error is the output_errors, split by weights, recombined at hidden nodes
        
        # Update the weights for the links between the hidden and output layers
        self_who += self_lr * (output_errors .* final_outputs .* (1.0 - final_outputs)) * transpose(hidden_outputs);
        
        # Update the weights for the links between the input and hidden layers
        self_wih += self_lr * (hidden_errors .* hidden_outputs .* (1.0 - hidden_outputs)) * transpose(inputs);
endfunction
    
function final_outputs = query(inputs_list)
        global self_wih;
        global self_who;
        global self_activation_function;
        
        inputs = transpose(inputs_list);                          # Convert row vectors to column vectors
        hidden_inputs = self_wih * inputs;                        # Calculate signals into hidden layer
        hidden_outputs = self_activation_function(hidden_inputs); # Calculate the signals emerging from hidden layer
        
        final_inputs = self_who * hidden_outputs;                 # Calculate signals into final output layer
        final_outputs = self_activation_function(final_inputs);   # Calculate the signals emerging from final output layer
endfunction

# Train the neural network
training_data_list = dlmread("./mnist_dataset/mnist_train_100.csv", ","); # Load the mnist training data CSV file into a list
epochs = 5;                                                             # Epochs is the number of times the training data set is used for training

for i = 1:epochs
    for j = 1:rows(training_data_list)
        inputs = (training_data_list(j,2:end) ./ 255.0 .* 0.98) + 0.01;       
        targets = zeros(1,self_onodes) + 0.01;
        targets(training_data_list(j,1)+1) = 0.99;
        train(inputs, targets);
    endfor
endfor
    
# Test the neural network
test_data_list = dlmread("./mnist_dataset/mnist_test_10.csv", ","); # Load the mnist test data CSV file into a list

for j = 1:rows(test_data_list)    
    inputs = (test_data_list(j,2:end) ./ 255.0 .* 0.98) + 0.01;
    label = test_data_list(j,1);
        
    figure(++fig_no);
    input_img = rot90(flip(reshape(inputs, 28, 28)), -1);                 #flip(rot90(reshape(inputs, 28, 28), -1));    
    imshow(input_img);
    title(num2str(label));    

    outputs = query(inputs);
    [llh, idx] = max(outputs);
    printf("Target %i, found %i with likelihood %.2f\n", label, idx-1, llh);
    if label == idx-1
        scorecard(j) = 1;
    else
        scorecard(j) = 0;
    endif
endfor    

printf("Scorecard"), disp(scorecard);
printf("Performance %.2f\n", sum(scorecard)/columns(scorecard));
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
global self_bias_hnodes = zeros(self_hnodes,1);
global self_activation_function = @(x) 1./(1+e.^(-x));          # sigmoid
global self_inverse_activation_function = @(x) log(x ./ (1-x)); # logit
global self_hidden_outputs;
global self_final_outputs;
global self_lr = 0.1;
epochs = 5;   # Epochs is the number of times the training data set is used for training
fig_no = 0;

function next = forward_query(network_matrix, actual, bias)
    global self_activation_function;
    
    inner = network_matrix * actual + bias; # Calculate the signals emerging from actual layer
    next = self_activation_function(inner); # Calculate the next signals applying activation on inner
endfunction

function before = backward_query(network_matrix, actual, bias)
    global self_inverse_activation_function;

    inner = transpose(network_matrix) * self_inverse_activation_function(actual) - bias; # Calculate the input signals
    inner -= min(inner); # Scale them back to 0.01 to .99
    inner /= max(inner);
    inner *= 0.98;
    inner += 0.01;
    
    before = inner;
endfunction

function dw = update_weights(lr, errors, outputs_actual, outputs_before)
    dw = lr * (errors .* outputs_actual .* (1-outputs_actual)) * transpose(outputs_before);
endfunction

function db = update_bias(lr, errors, outputs_actual)
    db = lr * (errors .* outputs_actual .* (1-outputs_actual));
endfunction

function train(inputs_list, targets_list)
    global self_wih;
    global self_who;
    global self_lr;
    global self_bias_hnodes;
        
    inputs = transpose(inputs_list);   # Convert row vectors to column vectors
    targets = transpose(targets_list);        
    
    hidden_outputs = forward_query(self_wih, inputs, self_bias_hnodes); # Run forward towards layers
    final_outputs = forward_query(self_who, hidden_outputs, 0);
    
    output_errors = targets - final_outputs;              # Output layer error is the (target - actual)
    hidden_errors = transpose(self_who) * output_errors;  # Hidden layer error is the output_errors, split by weights, recombined at hidden nodes
    
    self_who += update_weights(self_lr, output_errors, final_outputs, hidden_outputs);
    
    self_wih += update_weights(self_lr, hidden_errors, hidden_outputs, inputs);
    
    ### bias update, comment it if not needed
    self_bias_hnodes += update_bias(self_lr, hidden_errors, hidden_outputs);
endfunction
    
function final_outputs = query(inputs_list)
    global self_wih;
    global self_who;
    global self_bias_hnodes;
    
    inputs = transpose(inputs_list);  # Convert row vector to column vector
    
    hidden_outputs = forward_query(self_wih, inputs, self_bias_hnodes);  # Run forward towards layers
    final_outputs = forward_query(self_who, hidden_outputs, 0);
endfunction

# Backquery the neural network
# We'll use the same termnimology to each item, 
# Eg. target are the values at the right of the network, albeit used as input
# Eg. hidden_output is the signal to the right of the middle nodes
function inputs = backquery(targets_list)
    global self_wih;
    global self_who;
    global self_bias_hnodes;
    global self_inverse_activation_function;
    
    final_outputs = transpose(targets_list); # Convert row vector to column vector

    hidden_outputs = backward_query(self_who, final_outputs, self_bias_hnodes); # Run backward towards layers       
    inputs = backward_query(self_wih, hidden_outputs, 0);
endfunction

##disp("Run neural network backwards before training eg. 0 ..");
##targets = zeros(1,10) + 0.01;
##targets(1) = 0.99;
##inputs = backquery(targets);
##figure(++fig_no);
##input_img = rot90(flip(reshape(inputs, 28, 28)), -1);
##imshow(input_img);
##title("Start value before training eg. 0");

disp("Train the neural network ..");
training_data_list = dlmread("./mnist_dataset/mnist_train_100.csv", ","); # Load the mnist training data CSV file into a list

for i = 1:epochs
    for j = 1:rows(training_data_list)
        inputs = (training_data_list(j,2:end) ./ 255.0 .* 0.98) + 0.01; # At first position of row there is the label      
        targets = zeros(1,self_onodes) + 0.01;
        targets(training_data_list(j,1)+1) = 0.99; # At first position of row there is the label
        train(inputs, targets);
    endfor
endfor

disp("Test the neural network ..");  
test_data_list = dlmread("./mnist_dataset/mnist_test_10.csv", ","); # Load the mnist test data CSV file into a list

for j = 1:rows(test_data_list)    
    inputs = (test_data_list(j,2:end) ./ 255.0 .* 0.98) + 0.01; # At first position of row there is the label
    label = test_data_list(j,1);
        
##    figure(++fig_no);
##    input_img = rot90(flip(reshape(inputs, 28, 28)), -1);    
##    imshow(input_img);
##    title(num2str(label));    

    outputs = query(inputs);
    [likelyhood, idx] = max(outputs);
    printf("Target %i, found %i with likelihood %.2f\n", label, idx-1, likelyhood);
    if label == idx-1
        scorecard(j) = 1;
    else
        scorecard(j) = 0;
    endif
endfor    

printf("Scorecard"), disp(scorecard);
printf("Performance %.2f\n", sum(scorecard)/columns(scorecard));

disp("Run neural network backwards ...");
for i = 1:10
    targets = zeros(1,10) + 0.01;
    targets(i) = 0.99;
    inputs = backquery(targets);
    
    figure(++fig_no);
    input_img = rot90(flip(reshape(inputs, 28, 28)), -1);
    imshow(input_img);
    title(num2str(i-1));
endfor
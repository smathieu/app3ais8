function call_nn_app3
% Entry point of the neural network demonstration.

    close all
    clear all
    clc

    [net, P, T] = nn_app3(16);
    nn_test_app3(net);
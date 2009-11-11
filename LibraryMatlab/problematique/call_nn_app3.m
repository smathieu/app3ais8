function call_nn_app3
    close all
    clear all
    clc

    [net, P, T] = nn_app3(8);

    nn_test_app3(net);
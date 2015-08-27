function [ y_pred ] = predict( x, x_pred, c, K )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    m = size(x, 1);
    mtest = size(x_pred, 1);
    [i, j] = ndgrid(1:mtest,1:m);
    KK_test = arrayfun(@(i, j) (K(x_pred(i), x(j))), i, j);
    y_pred = KK_test * c;

end
function [ c ] = construct_f( x, y, lambda, K )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    m = length(y);
    [i, j] = ndgrid(1:m,1:m);
    KK = arrayfun(@(i, j) (K(x(i), x(j))), i, j);
    
    c = (lambda * m * eye(m) + KK)\ y;
    
end


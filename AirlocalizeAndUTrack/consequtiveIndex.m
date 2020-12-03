function [n,idx]=consequtiveIndex(x)
%Given an index array x, find the length consequtive index
%n is the length of the consequtive index
%idx is the position of the index

[~,n,idx]=RunLength_M(x-(1:length(x)));
end
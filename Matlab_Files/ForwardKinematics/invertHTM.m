function T_inv = invertHTM(T,varargin)
% INVERTHTM inverts the homogenous transformation matrix T
%
%    Author: Nasser Attar
%    Created: 2016-06-10
%    Modified: 2016-06-10
%    Change Log:    Replaced function "zeros" with [0 0 0]. This should speed
%                   the calculation up a little bit because there is no new
%                   function call. 

if ~isequal(size(T),[4 4])
    error('\nT has wrong size\n')
end

R = T(1:3,1:3);
p = T(1:3,4);

T_inv = [R',-R'*p;[0 0 0],1];

% End of function
end
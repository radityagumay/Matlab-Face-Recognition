function Z = scalefn2(Cl,S,level,real_or_cplx)

% Function to retrieve the Scaling Function (LoLo) subimage from the 2-D DT-CWT vector Cl.
% 
% output = scalefn2(Cl,S,level,real_or_cplx)
%     Cl -> The column vector containing the LoLo Subbands only.
%     S  -> The "Bookkeeping" matrix
%     level -> The level which you want to get a subimage from
%
%     real_or_cplx-> 'real' => Return the quad-number subimage as a purely REAL matrix (DEFAULT)
%                    'cplx' => Return the subimage pair as a COMPLEX matrix
%
% Example:     ll = scalefn2(Cl,S,3);
%
% Cian Shaffrey, Nick Kingsbury
% Cambridge University, April 2001

%set the default for real_or_cplx
if nargin < 4, 
   real_or_cplx = 'real';
end 

[a,b] = size(S);

if level > (a); 	%check level is correct
   error('Error - Please Check that you are entering the correct level');
end


ysize = S(a+1-level,:);
row_size = ysize(1);
col_size = ysize(2);
size_seg = row_size*col_size;   							%get the size of the segment
row_pos = find(S(:,1)==[row_size]);	     %the position of the of the row_size in S
col_pos = find(S(:,2)==[col_size]);	 
start_sec = sum(S(1:row_pos-1,1).*S(1:col_pos-1,2)); %Now start is the start of chosen section

start = start_sec + 1;
finish = (start + size_seg - 1); 
Z = reshape(Cl(start:finish),ysize);

if real_or_cplx == 'real'			
elseif real_or_cplx == 'cplx'	
   Z = q2c(Z);
else
   error('Unsupported reference when calling SCALEFN2, relating to REAL or CPLX')
end


return

%==========================================================================================
%						**********  	INTERNAL FUNCTION    **********
%==========================================================================================

function z = q2c(y)

% function z = q2c(y)
% Convert from quads in y to complex numbers in z.

sy = size(y);
t1 = 1:2:sy(1); t2 = 1:2:sy(2);

% Arrange pixels from the corners of the quads into
% 2 subimages of alternate real and imag pixels.
%  a----b
%  |    |
%  |    |
%  c----d
a = y(t1,t2);
b = y(t1,t2+1);
c = y(t1+1,t2);
d = y(t1+1,t2+1);

% Form the real and imag parts of the 2 subbands.
z = [a-d; a+d]*sqrt(0.5) + [b+c; b-c]*sqrt(-0.5);

return

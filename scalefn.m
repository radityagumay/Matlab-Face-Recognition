function y = scalefn(Cl,L,level,real_or_cplx)

% Function to retrieve the Scaling Function (Lo) subband from the DT-CWT vector Cl.
% 
% output = scalefn(Cl,L,levelreal_or_cplx)
%
%     Cl -> The column vector containing the LoLo Subbands only.
%     L  -> The "Bookkeeping" matrix
%     level -> The level which you want to get a subimage from
%
%     real_or_cplx-> 'real' => Return the quad-number subimage as a purely REAL matrix (DEFAULT)
%                    'cplx' => Return the subimage pair as a COMPLEX matrix
%
% Example:     ll = scalefn(Cl,L,3);
%	
% Cian Shaffrey, Nick Kingsbury
% Cambridge University, April 2001

%set the default for real_or_cplx
if nargin < 4	, 
   real_or_cplx = 'real';
end 

[a,b] = size(L);

if level > (a); 	%check level is correct
   error('Error - Please Check that you are entering the correct level');
end

pos_L = a+1-level;
start = sum(prod(L(1:pos_L-1,:).')) + 1; 
finish = start + prod(L(pos_L,:)) - 1;
y = reshape(Cl(start:finish),L(pos_L,:));  

if real_or_cplx == 'cplx'
   t = 1:2:L(pos_L,1);
   y = y(t,:)+j*y(t+1,:);
elseif real_or_cplx == 'real'
else
   error('Please input the correct term for REAL or COMPLEX output');
end

return

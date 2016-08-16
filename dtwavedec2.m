function [C,S,Cl] = dtwavedec2(X,level,biort,qshift);

% Function to perform a n-level DTCWT-2D decompostion on a 2D matrix X
%
% [C,S] = dtwavedec2(X,no_levels,'Names of Biort','Name of q_shift');
% [C,S,Cl] = dtwavedec2(X,no_levels,'Names of Biort','Name of q_shift');
%
%     X -> 2D real matrix/Image
%
%     level -> No. of levels of wavelet decomposition
%
%     biort ->  'antonini'   => Antonini 9,7 tap filters.
%               'legall'     => LeGall 5,3 tap filters.
%               'near_sym_a' => Near-Symmetric 5,7 tap filters.
%               'near_sym_b' => Near-Symmetric 13,19 tap filters.
%
%     qshift -> 'qshift_06' => Quarter Sample Shift Orthogonal (Q-Shift) 10,10 tap filters, 
%                              (with 6,6 active (non-zero) taps).
%               'qshift_a'  =>  Q-shift 10,10 tap filters,
%                              (with 10,10 non-zero taps, unlike qshift_06).
%               'qshift_b'  => Q-Shift 14,14 tap filters.
%               'qshift_c'  => Q-Shift 16,16 tap filters.
%               'qshift_d'  => Q-Shift 18,18 tap filters.
%               
%
%     C  -> The real column vector containing the Subbands.
%     S  -> The "Bookkeeping" matrix containing the size of the appropriate subbands, 
%           where the last row is the orginal size of X.  The number of rows in S
%           equals the number of levels of decomposition.
%     Cl -> This is an optional output argument, that contains the LoLo coefficients
%           at every scale.
% 
% Example: [C,S] = dtwavedec2(X,3,'antonini','qshift_c');
% performs a 3-level transform on the real image X using the Antonini filters 
% for level 1 and the Q-shift 16-tap filters for levels >= 2.
%
% The function CWTBAND2 should be used to extract individual subimages from C
% in real or complex format.
%
% Cian Shaffrey, Nick Kingsbury
% Cambridge University, August 2000


if isstr(biort) & isstr(qshift)		%Check if the inputs are strings
   biort_exist = exist([biort '.mat']);
   qshift_exist = exist([qshift '.mat']);
   if biort_exist == 2 & qshift_exist == 2;        		%Check to see if the inputs exist as .mat files
      load (biort);
      load (qshift);
   else
      error('Please enter the correct names of the Biorthogonal or Q-Shift Filters, see help DTWAVEDEC2 for details.');
   end
else
   error('Please enter the names of the Biorthogonal or Q-Shift Filters as shown in help DTWAVEDEC2.');
end 

orginal_size = size(X);

if ndims(X) >= 3;
   error(sprintf('The entered image is %dx%dx%d, please enter each dimension seperatly.',orginal_size(1),orginal_size(2),orginal_size(3)));
end

%the next few lines of code check to see if the image is odd in size, if so an extra ...
%row/column will be added to the bottom/right of the image
initial_row_extend = 0;  %initialise
initial_col_extend = 0;
if any(rem(orginal_size(1),2)), %if sx(1) is not divisable by 2 then we need to extend X by adding a row at the bottom
   X = [X; X(end,:)];           %Any further extension will be done in due course.
   initial_row_extend = 1;
end
if any(rem(orginal_size(2),2)), 	%if sx(2) is not divisable by 2 then we need to extend X by adding a col to the left
   X = [X X(:,end)];          %Any further extension will be done in due course.
   initial_col_extend = 1;
end
extended_size = size(X);

if level == 0, return; end

C = []; 	%initialise
S = [];
if nargout == 3
   Cl = [];
end
sx = size(X);
if level >= 1,
   
   % Do odd top-level filters on cols.
   Lo = colfilter(X,h0o).';
   Hi = colfilter(X,h1o).';
   
   %When the DTCWT was first created we used row filtering. Therefore, when looking at LoHi the Low pass was done on the ROW and the Hi-pass on the COLS
   %thus extracting the Horizontal features.  Now with the column filtering the 'LoHi' is the other way around!!
   
   % Do odd top-level filters on rows.
   LoLo = colfilter(Lo,h0o).';			% LoLo
   Horz1 = colfilter(Hi,h0o).';			% Horizontal
   Vert1 = colfilter(Lo,h1o).';			% Vertical
   Diag1 = colfilter(Hi,h1o).';	      % Diagonal  
   if nargout == 3
      Cl = [LoLo(:) ; Cl];
   end
   S = [ size(LoLo) ;S];
end

if level >= 2;
   for count = 2:level;
      [row_size col_size] = size(LoLo);
      if any(rem(row_size,4)),		% Extend by 2 rows if no. of rows of LoLo are divisable by 4;
         LoLo = [LoLo(1,:); LoLo; LoLo(end,:)];
      end 
      if any(rem(col_size,4)),		% Extend by 2 cols if no. of cols of LoLo are divisable by 4;
         LoLo = [LoLo(:,1)  LoLo  LoLo(:,end)];
      end 
      
      sx = size(LoLo);
      t1 = 1:sx(1); t2 = 1:sx(2);
      sr = sx/2;
      s1 = 1:sr(1); s2 = 1:sr(2);
      
      % Do even Qshift filters on rows.
      Lo = coldfilt(LoLo,h0b,h0a).';
      Hi = coldfilt(LoLo,h1b,h1a).';
      
      % Do even Qshift filters on columns.
      LoLo = coldfilt(Lo,h0b,h0a).';	% LoLo
      Horz = coldfilt(Hi,h0b,h0a).';	% Horizontal
      Vert = coldfilt(Lo,h1b,h1a).';	% Vertical
      Diag = coldfilt(Hi,h1b,h1a).';	% Diagonal   
      C = [ Horz(:) ; Vert(:); Diag(:); C];
      S = [ size(LoLo) ;S];
      if nargout == 3
         Cl = [LoLo(:) ; Cl];
      end
   end
end

C = [LoLo(:) ; C; Horz1(:) ; Vert1(:); Diag1(:)];  % finally add in LoLo and level 1 subbands.
%C now looks like this: C = [L1 H3 V3 D3 H2 V2 D2 H1 V1 D1];

if initial_row_extend == 1 & initial_col_extend == 1;
   warning(sprintf(' \r\r The image entered is now a %dx%d NOT a %dx%d \r The bottom row and rightmost column have been duplicated, prior to decomposition. \r\r ',...
      extended_size(1),extended_size(2),orginal_size(1),orginal_size(2)));
end

if initial_row_extend == 1 ;
   warning(sprintf(' \r\r The image entered is now a %dx%d NOT a %dx%d \r Row number %d has been duplicated, and added to the bottom of the image, prior to decomposition. \r\r',...
      extended_size(1),extended_size(2),orginal_size(1),orginal_size(2),orginal_size(1)));   
end
if initial_col_extend == 1;
   warning(sprintf(' \r\r The image entered is now a %dx%d NOT a %dx%d \r Col number %d has been duplicated, and added to the right of the image, prior to decomposition. \r\r',...
      extended_size(1),extended_size(2),orginal_size(1),orginal_size(2),orginal_size(2)));   
end


return


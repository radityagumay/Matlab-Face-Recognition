%Dual-Tree Complex Wavelet Transform Pack - version 2.2 - update

%Nick Kingsbury and Cian Shaffrey, Cambridge University, February 2001. 


%The following code relates to the testing of the DTCWT code.  In the 2D case there are two test images: 1) is Lena.mat and 2) wavelet_orien.jpg which illustrates the directionally selective properties of the DTCWT


% To test the 1D case:

X = rand(512,1);
[C,L] = dtwavedec(X,3,'near_sym_b','qshift_b');
Z = dtwaverec(C,L,'near_sym_b','qshift_b');
max(abs(Z(:)-X(:))) % Test for approx zero error.

% And for vectors that are NOT divisable by 4:

X = [zeros(225,1); ones(225,1)];
[C,L] = dtwavedec(X,3,'near_sym_b','qshift_b');
Z = dtwaverec(C,L,'near_sym_b','qshift_b');
max(abs(Z(:)-X(:)))

l = cwtband(C,L,3,'l');
h1 = cwtband(C,L,1,'h');
h2 = cwtband(C,L,2,'h','real');

% To insert some modified subband (eg h1*2) back into C

[cm,V] = icwtband(h1*2,L,1,'h');
C(V) = cm;



% To test the 2D case: using Lena.mat or wavelet_orien.jpg

load lenna   		% This gives X as 256x256

%  OR

X = double(imread('wavelet_orien.jpg'));  % X is 512x512


[C,S] = dtwavedec2(X,4,'antonini','qshift_c');
Z = dtwaverec2(C,S,'antonini','qshift_c');
max(abs(Z(:)-X(:))) % Test for approx zero error.

% Testing non-uniform sections:

[C,S] = dtwavedec2(X(1:120,1:130),4,'antonini','qshift_c');
Z = dtwaverec2(C,S,'antonini','qshift_c');
max(max(abs(Z-X(1:120,1:130))))

% Pick out separate complex subbands, display them using a complex
% colour palette, and reconstruct the image gradually,
% starting with the coarsest levels:

load lenna    %OR      X = double(imread('wavelet_orien.jpg'));    

[C,S] = dtwavedec2(X,4,'antonini','qshift_c');

% Pick out 6 subbands at each level and display them.
b1 = cwtband6(C,S,1);
figure; cimage5([b1(:,:,1) b1(:,:,3) b1(:,:,5);b1(:,:,2) b1(:,:,4) b1(:,:,6)])

b2 = cwtband6(C,S,2);
figure; cimage5([b2(:,:,1) b2(:,:,3) b2(:,:,5);b2(:,:,2) b2(:,:,4) b2(:,:,6)])

b3 = cwtband6(C,S,3);
figure; cimage5([b3(:,:,1) b3(:,:,3) b3(:,:,5);b3(:,:,2) b3(:,:,4) b3(:,:,6)])

b4 = cwtband6(C,S,4);
figure; cimage5([b4(:,:,1) b4(:,:,3) b4(:,:,5);b4(:,:,2) b4(:,:,4) b4(:,:,6)])

l4 = cwtband2(C,S,4,'l','real'); 
figure; draw(l4); drawnow       % Display final 'real' lowpass image in monochrome.

% Now reconstruct in D and display after each new level of subbands is added in.
D = C * 0;
[cm,V] = icwtband2(l4,S,4,'l','real'); D(V)=cm; % Level 4 lo-lo band.
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); drawnow

[cm,V] = icwtband6(b4,S,4);D(V) = cm;
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); drawnow

[cm,V] = icwtband6(b3,S,3);D(V) = cm;
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); drawnow

[cm,V] = icwtband6(b2,S,2);D(V) = cm;
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); drawnow

[cm,V] = icwtband6(b1,S,1);D(V) = cm;
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); drawnow
max(abs(Z(:)-X(:))) % Test for approx zero error.

%Now to extract some Scaling Fucntion information and view:

[C,S,Cl] = dtwavedec2(X,4,'antonini','qshift_c');
D=C*0;
ll = scalefn2(Cl,S,3);

[cm,V] = icwtband2(ll,S(3:end,:),3,'l','real');D(V) = cm;
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); 
Z = dtwaverec2(D,S(2:end,:),'antonini','qshift_c'); figure; draw(Z); 


% There are two routines (added Sept 2001):
%   dtwavexfm2.m combines dtwavedec2 and cwtband6
%   dtwaveifm2.m combines dtwaverec2 and icwtband6
% Both of these use a cell array to store to complex wavelet subbands
% rather than the C vector and are more efficient computationally.
% See the help for each file to determine how to use them.



% ***********************************************************************
% The following code is an older and more complicated way to select and
% insert subbands using just the cwtband2 and icwtband2 functions.

% Pick out separate complex subbands, display them using a complex
% colour palette, and reconstruct the image gradually,
% starting with the coarsest levels:

load lenna
[C,S] = dtwavedec2(X,4,'antonini','qshift_c');

% Pick out subbands.
h1 = cwtband2(C,S,1,'h','cplx');
v1 = cwtband2(C,S,1,'v','cplx');
d1 = cwtband2(C,S,1,'d','cplx');
figure; cimage5([v1 d1 h1]); drawnow   % Display level 1 complex subbands in colour.

h2 = cwtband2(C,S,2,'h','cplx');
v2 = cwtband2(C,S,2,'v','cplx');
d2 = cwtband2(C,S,2,'d','cplx');
figure; cimage5([v2 d2 h2]); drawnow   % Level 2

h3 = cwtband2(C,S,3,'h','cplx');
v3 = cwtband2(C,S,3,'v','cplx');
d3 = cwtband2(C,S,3,'d','cplx');
figure; cimage5([v3 d3 h3]); drawnow   % Level 3

h4 = cwtband2(C,S,4,'h','cplx');
v4 = cwtband2(C,S,4,'v','cplx');
d4 = cwtband2(C,S,4,'d','cplx');
figure; cimage5([v4 d4 h4]); drawnow   % Level 4

l4 = cwtband2(C,S,4,'l','real'); 
figure; draw(l4); drawnow              % Display final 'real' lowpass image in monochrome.

% Now reconstruct in D and display after each new level of subbands is added in.
D = C * 0;
[cm,V] = icwtband2(l4,S,4,'l','real'); D(V)=cm; % Level 4 lo-lo band.
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); drawnow

[cm,V] = icwtband2(h4,S,4,'h','cplx'); D(V)=cm; % Level 4 hi bands.
[cm,V] = icwtband2(v4,S,4,'v','cplx'); D(V)=cm;
[cm,V] = icwtband2(d4,S,4,'d','cplx'); D(V)=cm;
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); drawnow

[cm,V] = icwtband2(h3,S,3,'h','cplx'); D(V)=cm; % Level 3 hi bands.
[cm,V] = icwtband2(v3,S,3,'v','cplx'); D(V)=cm;
[cm,V] = icwtband2(d3,S,3,'d','cplx'); D(V)=cm;
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); drawnow

[cm,V] = icwtband2(h2,S,2,'h','cplx'); D(V)=cm; % Level 2 hi bands.
[cm,V] = icwtband2(v2,S,2,'v','cplx'); D(V)=cm;
[cm,V] = icwtband2(d2,S,2,'d','cplx'); D(V)=cm;
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); drawnow

[cm,V] = icwtband2(h1,S,1,'h','cplx'); D(V)=cm; % Level 1 hi bands.
[cm,V] = icwtband2(v1,S,1,'v','cplx'); D(V)=cm;
[cm,V] = icwtband2(d1,S,1,'d','cplx'); D(V)=cm;
Z = dtwaverec2(D,S,'antonini','qshift_c'); figure; draw(Z); drawnow
max(abs(Z(:)-X(:))) % Test for approx zero error.

%********************************




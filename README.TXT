Dual-Tree Complex Wavelet Transform Pack - version 2.2 - update

Nick Kingsbury and Cian Shaffrey, Cambridge University, February 2001.

Version 2.0 files (dated August 2000) have been optimised for speed
and memory use, principally by performing column filtering with CONV2 
instead of row filtering (which is significantly slower) and by avoiding 
unneccessary copying of matrices within functions.  The ROWFILT functions
have been replaced by COLFILT equivalents, and some lower level functions
have been removed.

Version 2.1 files (dated Sept 2000) contain 2 new functions, CWTBAND6 and
ICWTBAND6, and some bugs in the comments of other files have been corrected.
These new functions provide a more convenient way to handle complete sets
of 6 complex bandpass subbands from a given level of the transform.

Version 2.2 UPDATE: A few bug were identifed and fixed.  These mainly related
to the subband extraction routines and filter design.  An extra Q-shift filter has
been added - qshift_06.  This filter is a 10,10 tap filter with only 6,6 non-zero
taps.  Also included is a JPEG image that helps  demonstrate the orientationly 
selective nature of the DTCWT - The image, called wavelet_orien.jpg, can be used 
instead of lenna.mat. The tests are detailed in Testing.txt.

The main functions:

dtwavedec => 1D DTCWT decomposition
dtwaverec => 1D DTCWT reconstruction
cwtband   => Extracts individual subbands from the result of DTWAVEDEC 
             at specified levels
icwtband  => Allows insertion of individual subbands into the input vector
             for DTWAVEREC.

dtwavedec2 => 2D DTCWT decomposition
dtwaverec2 => 2D DTCWT reconstruction
cwtband2   => Extracts individual subimages from the result of DTWAVEDEC2
              at specified levels
icwtband2  => Allows insertion of individual subimages into the input vector
              for DTWAVEREC2
cwtband6   => Extracts a set of 6 subimages from the result of DTWAVEDEC2
              at specified levels
icwtband6  => Allows insertion of a set of 6 subimages into the input vector
              for DTWAVEREC2.

Lower level functions:

colfilt   => Column filtering of a matrix with symmetric extension 
coldfilt  => Column filtering with decimation by 2.
colifilt  => Column filtering with interpolation (upsampling) by 2.
reflect   => Reflect a vector about max and min limits (used for sym extension).
draw      => Draw an image in a correctly sized figure window.
cimage5   => Draw a complex subimage using a colour palette for the complex numbers.

Various .MAT files contain the complex wavelet filter coefficients.

To test the DTCWT package please read the TESTING.TXT file.


********************************

Further information on the DT CWT can be obtained from papers
downloadable from NGK's website (given below). The best tutorial is in
the 1999 Royal Society Paper. In particular this explains the conversion
between 'real' quad-number subimages and pairs of complex subimages, which
is carried out in CWTBAND2 and ICWTBAND2 if 'cplx' is selected as the
required subimage mode. The Q-shift filters are explained in the ICIP
2000 paper and the paper for the Journal on Applied Computation and
Harmonic Analysis.

Cian Shaffrey and Nick Kingsbury, 
Cambridge University, August 2000

***********************************************************
Dr N G Kingsbury,
  Dept. of Engineering, University of Cambridge,
    Trumpington St., Cambridge CB2 1PZ, UK.
                      or
    Trinity College, Cambridge CB2 1TQ, UK.
Phone: (0 or +44) 1223 338514 / 332647;  Home: 1954 211152;
Fax: 1223 338564 / 332662;  E-mail: ngk@eng.cam.ac.uk
Web home page: http://www.eng.cam.ac.uk/~ngk/
***********************************************************


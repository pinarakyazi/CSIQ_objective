%
% STANDARD V1 MODEL
% (J.Malo & V.Laparra 2010)
% 
% This toolbox implements the V1 model described at the papers:
%
%    V. Laparra, J. Muñoz and J. Malo
%    Divisive Normalization Image Quality Metric Revisited
%    JOSA A, 27(4): 852-864 (2010).
%
%    J. Malo and J. Laparra
%    Psychophysically Tuned Divisive Normalization Approximately Factorizes the PDF of Natural Images
%    Neural Computation, 22(12): 3179-3206 (2010)
%

This toolbox computes the response of achromatic and chromatic sensors at V1
level to color images. It also computes the visibility of a target stimulus
seen on top of a background image. The visibility of the target is computed as
the perceptual difference between the background and the background+target 
images. The perceptual difference is computed by applying an appropriate summation 
model to the diference vector in the V1 representation.

The programs to be used are:

    *  standard_V1_model_general.m
    *  visibility_of_target.m

The V1 model consists of a linear opponent color space, a linear wavelet transform
of each opponent channel and a non-linear gain control applied to each wavelet 
representation. This model and the corresponding summation strategy is optimized
to reproduce subjective image distortion data.

The toolbox uses the publicly available MatlabPyrTools of Eero Simoncelli available at:
http://www.cns.nyu.edu/~eero/software.php

%
% DIVISIVE NORMALIZATION IMAGE QUALITY METRIC
% (V. Laparra, J. Muñoz and J.Malo 2010)

This toolbox computes the perceptual difference between 2 achromatic or chromatic images
according to the Divisive Normalization Metric generalized and tuned as described in the 
papers:

    V. Laparra, J. Muñoz and J. Malo
    Divisive Normalization Image Quality Metric Revisited
    JOSA A, 27(4): 852-864 (2010).

    J. Malo and J. Laparra
    Psychophysically Tuned Divisive Normalization Approximately Factorizes the PDF of Natural Images
    Neural Computation, 22(12): 3179-3206 (2010)

The program to be used is 'div_norm_metric.m'

The toolbox uses the publicly available MatlabPyrTools of Eero Simoncelli available at:
http://www.cns.nyu.edu/~eero/software.php

The distance measure is computed by transforming the original and the distorted image
to the standard V1 image representation (optimized to reproduce the subjective ratings
of the LIVE image distortion dataset) and applying an appropriate summation model to the 
diference vector in that representation.
The subfolder standard_V1_model contains the functions 'standard_V1_model_general.m' and
'summation_model.m' that are used to compute the V1 representation (and may be useful
in vision science applications).

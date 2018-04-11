function [d_fe,DMOS,spatial_dist_map]=div_norm_metric(im1,im2);

% DIV_NORM_METRIC computes the perceptual difference between 2 images
% according to the Teo&Heeger metric fitted as in the paper:
%
%    V. Laparra, J. Muñoz and J. Malo 
%    Divisive Normalization image Quality Metric Revisited
%    JOSA A Vol. 27, Iss. 4, pp. 852–864 (2010)
%
% The metric applies the non-linear divisive normalization (with the 
% optimal parameters) for the two color images and applies the optimal
% summation model to the difference vector.
%
% The distance, d, computed by the metric is linearly translated to DMOS values
% using the fit of the LIVE and TID databases.
% 
% The program returns an intermediate result: the spatial distortion map 
% obtained before pooling accross space. This map gives an idea on how the
% different regions in the distorted image contribute to the global
% distorion.
%
% USE: [d,DMOS,spatial_map]=div_norm_metric(im1,im2);

[im_yuv1,pyr1,r1,ind]=standard_V1_model_general(im1);
[im_yuv2,pyr2,r2,ind]=standard_V1_model_general(im2);

delta_r=abs(r1-r2);

[d_fe,spatial_dist_map]=summation_model_fe(abs(delta_r(1:end-prod(ind(end,:)),:)),ind,4.5,2.18);

%%%% NORMALIZACION AL NUMERO REAL DE PIXELS
d_fe=1000*d_fe*numel(delta_r(1:end-prod(ind(end,:)),:))/(3*numel(im1(:,:,1)));

DMOS=4.864880793450431e+004*d_fe/1000+25.84;
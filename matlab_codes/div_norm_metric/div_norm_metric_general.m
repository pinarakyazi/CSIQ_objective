function [d_ef,d_fe,d2,spatial_dist_map,r1,r2,ind]=div_norm_metric_general(im1,im2);

% DIV_NORM_METRIC_GENERAL computes the perceptual difference between 2 images
% according to the Teo&Heeger metric fitted as in the paper:
%    V. Laparra, J. Muñoz and J. Malo 
%    Divisive Normalization image Quality Metric Revisited
%    JOSA A Vol. 27, Iss. 4, pp. 852–864 (2010)
%
% The metric applies the non-linear divisive normalization (with the 
% optimal parameters) for the two color images and applies the optimal
% summation model to the difference vector.
%
% The distance with optimal summation is d_fe (first summation over
% frequency and then summation over space). Other results with other summation
% schemes are also given (d_ef -first space and then frequency- and d2 -quadratic summation-)
%
% USE: [d_ef,d_fe,d2,map,r1,r2,ind]=div_norm_metric_general(im1,im2);

[im_yuv1,pyr1,r1,ind]=standard_V1_model_general(im1);
[im_yuv2,pyr2,r2,ind]=standard_V1_model_general(im2);

delta_r=abs(r1-r2);

d2=sqrt(sum(sum(abs(delta_r(1:end-prod(ind(end,:)),:)).^2)))/numel(delta_r(1:end-prod(ind(end,:)),:));

[d_ef,d_fe,spatial_dist_map]=summation_model(abs(delta_r(1:end-prod(ind(end,:)),:)),ind,4.5,2.18);

%%%% NORMALIZACION AL NUMERO REAL DE PIXELS
d_fe=1000*d_fe*numel(delta_r(1:end-prod(ind(end,:)),:))/(3*numel(im1(:,:,1)));
d_ef=1000*d_ef*numel(delta_r(1:end-prod(ind(end,:)),:))/(3*numel(im1(:,:,1)));
d2=1000*d2*numel(delta_r(1:end-prod(ind(end,:)),:))/(3*numel(im1(:,:,1)));
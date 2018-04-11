function [d,da,dc,map]=dn_metric(im1,im2);

% DN_METRIC applies the Divisive Normalization to estimate the
% perceptual distance between two images as appear in the paper:
%
%      Divisive Normalization Metric Revisited 
%      by J. Muñoz, V. Laparra and J. Malo, JOSA A 2010
%
% Achromatic and chromatic contributions to this difference are separately 
% considered.
%
%    [d,da,dc,spatial_map]=dn_metric(im1,im2);
%
% d : total distance
% da: achromatic distance
% dc: chromatic distance
% spatial_map: spatial map showing the distances in the YUV channels pooled
%              in the frequency dimension

s=size(im1);
s=prod(s);

[d_ef,d_fe,d2,map,r1,r2,ind]=div_norm_metric_general(im1,im2);

qx=2.18;

da = (sum(sum(map(:,:,1).^qx)).^(1/qx))/s;
dc = (sum(sum(map(:,:,2).^qx+map(:,:,3).^qx)).^(1/qx))/s;
d = (da^qx +dc^qx ).^(1/qx);


function [vifdn_1,vifdn_2,d_ef,d_fe,d2,spatial_dist_map,r1,r2,ind]=div_norm_metric_info(im1,im2,sigma);

% DIV_NORM_METRIC_INFO computes the perceptual difference between 2 images
% according to the Teo&Heeger metric fitted as in the paper:
%    Divisive Normalization image Quality Metric Revisited
%
% The metric applies the non-linear divisive normalization (with the 
% optimal parameters) for the two color images and applies the optimal
% summation model to the difference vector.
%
% The distance with optimal summation is d_fe (first summation over
% frequency and then summation over space). Other results with other summation
% schemes are also given (d_ef -first space and then frequency- and d2 -quadratic summation-)
%
% USE: [vifdn_1,vifdn_2,d_ef,d_fe,d2,map,r1,r2,ind]=div_norm_metric_info(im1,im2,sigma_internal_noise);

[im_yuv1,pyr1,r1,ind]=standard_V1_model_general(im1);
[im_yuv2,pyr2,r2,ind]=standard_V1_model_general(im2);

subbands=1:12; % Pillo todas las subbandas (no como en VIF -posible simplific incluye tomar solo horizontal y vertical oblique effect!-)

sigma_nsq=sigma;

for i=1:length(subbands)
    
    % VIF con MI hard
    subband_org = pyrBand(r1(:,1), ind, i);     
    subband_dist = pyrBand(r2(:,1), ind, i);   
    
    C = subband_org;
    F = subband_dist+sqrt(sigma_nsq)*randn(size(subband_dist));
    E = subband_org+sqrt(sigma_nsq)*randn(size(subband_org));

    Nbins = round(sqrt(length(C(:))));
    
    num2(i) = mutual_information_4(C(:)',F(:)',Nbins);
    den2(i) = mutual_information_4(C(:)',E(:)',Nbins);
    
    % VIF con HSIC hard
    Cd = im2col(C,[8 8],'distinct');
    Fd = im2col(F,[8 8],'distinct');
    Ed = im2col(E,[8 8],'distinct');
    sigx = estimatesigma(Cd',0);
    sigy = estimatesigma(Fd',0);
    [p,HSIC1,prob] = fasthsic(Cd',Fd',sigx,sigy,0);    
    sigy = estimatesigma(Ed',0);
    [p,HSIC2,prob] = fasthsic(Cd',Ed',sigx,sigy,0); 
%     params.sigx = estimatesigma(Cd',0);
%     params.sigy = estimatesigma(Fd',0);
%     [theta,HSIC1,pvalue,K1a,K2a] = hsic(Cd',Fd',0.05,params);
%     params.sigy = estimatesigma(Ed',0);
%     [theta,HSIC2,pvalue,K1a,K2a] = hsic(Cd',Ed',0.05,params);
    num3(i) = HSIC1;
    den3(i) = HSIC2;
end
% compute VIF en DN con MI y HSIC
vifdn_1=sum(num2)./sum(den2);
vifdn_2=sum(num3)./sum(den3);

delta_r=abs(r1-r2);

d2=sqrt(sum(sum(abs(delta_r(1:end-prod(ind(end,:)),:)).^2)))/numel(delta_r(1:end-prod(ind(end,:)),:));

[d_ef,d_fe,spatial_dist_map]=summation_model(abs(delta_r(1:end-prod(ind(end,:)),:)),ind,4.5,2.18);

%%%% NORMALIZACION AL NUMERO REAL DE PIXELS
d_fe=d_fe*numel(delta_r(1:end-prod(ind(end,:)),:))/(3*numel(im1(:,:,1)));
d_ef=d_ef*numel(delta_r(1:end-prod(ind(end,:)),:))/(3*numel(im1(:,:,1)));
d2=d2*numel(delta_r(1:end-prod(ind(end,:)),:))/(3*numel(im1(:,:,1)));
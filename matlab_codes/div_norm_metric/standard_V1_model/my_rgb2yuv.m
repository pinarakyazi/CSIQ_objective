function YUV=my_rgb2yuv(RGB);

% MY_RGB2YUV calcula la imagen true-color YUV a partir de la true-color RGB
% aplicando la matriz:
%
% Mrgb_yuv =
%
%    0.2990    0.5870    0.1140
%   -0.1726   -0.3388    0.5114
%    0.5114   -0.4282   -0.0832
%
% Su inversa MY_YUV2RGB usa la inversa:
%
%   Myuv_rgb =
%
%    1.0000    0.0000    1.3707
%    1.0000   -0.3365   -0.6982
%    1.0000    1.7324    0.0000
%
% USO: YUV=my_rgb2yuv(RGB);

Mrgb_yuv =[0.2990    0.5870    0.1140;-0.1726   -0.3388    0.5114;0.5114   -0.4282   -0.0832];

RGB=double(RGB);
YUV=RGB;

YUV(:,:,1)=Mrgb_yuv(1,1)*RGB(:,:,1)+Mrgb_yuv(1,2)*RGB(:,:,2)+Mrgb_yuv(1,3)*RGB(:,:,3);
YUV(:,:,2)=Mrgb_yuv(2,1)*RGB(:,:,1)+Mrgb_yuv(2,2)*RGB(:,:,2)+Mrgb_yuv(2,3)*RGB(:,:,3);
YUV(:,:,3)=Mrgb_yuv(3,1)*RGB(:,:,1)+Mrgb_yuv(3,2)*RGB(:,:,2)+Mrgb_yuv(3,3)*RGB(:,:,3);
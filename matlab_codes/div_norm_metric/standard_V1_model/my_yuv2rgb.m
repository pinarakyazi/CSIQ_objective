function RGB=my_yuv2rgb(YUV);

% MY_YUV2RGB calcula la imagen true-color RGB a partir de la true-color YUV
% aplicando la matriz:
%
%   Myuv_rgb =
%
%    1.0000    0.0000    1.3707
%    1.0000   -0.3365   -0.6982
%    1.0000    1.7324    0.0000
%
% Su inversa MY_RGB2YUV usa la inversa:
%
% Mrgb_yuv =
%
%    0.2990    0.5870    0.1140
%   -0.1726   -0.3388    0.5114
%    0.5114   -0.4282   -0.0832
%
% USO: RGB=my_yuv2rgb(YUV);

Mrgb_yuv =[0.2990    0.5870    0.1140;-0.1726   -0.3388    0.5114;0.5114   -0.4282   -0.0832];
Myuv_rgb = inv(Mrgb_yuv);

YUV=double(YUV);
RGB=YUV;

RGB(:,:,1)=Myuv_rgb(1,1)*YUV(:,:,1)+Myuv_rgb(1,2)*YUV(:,:,2)+Myuv_rgb(1,3)*YUV(:,:,3);
RGB(:,:,2)=Myuv_rgb(2,1)*YUV(:,:,1)+Myuv_rgb(2,2)*YUV(:,:,2)+Myuv_rgb(2,3)*YUV(:,:,3);
RGB(:,:,3)=Myuv_rgb(3,1)*YUV(:,:,1)+Myuv_rgb(3,2)*YUV(:,:,2)+Myuv_rgb(3,3)*YUV(:,:,3);
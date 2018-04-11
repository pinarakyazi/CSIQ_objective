function [alfas,betas]= alfa_beta_wav(A,s,expon,B,escalas)

% ALFA_BETA_WAV computes the CSF and beta profiles for the Divisive Normalization
% of a E-scale QMF wavelet domain, according to the following parametrizations:
%
%      alfa_eo_c = Ao_c .* exp( - ( (E - e) / s_c ) ^ t )
%
%      beta_eo_c = B*fact_o .* exp( - ( (E - e + 1) / 1.1 ) ^ 1 )
%
% where:
%
% alfa_eo_c -> CSF profile for the orientation 'o' and the chromatic
%              channel 'c'
%
% beta_eo_c -> beta profile for the orientation 'o' and the chromatic
%              channel 'c'
%
% A(o,c)    -> Matrix with the maximum amplitudes of the CSF profiles 
%              for the orientation 'o' and the chromatic channel 'c'.
%              First row horizontal and vertical
%              Second row diagonal
%              First column luminance
%              Second column chromatic channels (same parameter for both)
%              Hint:
%
%                   A=[50 45;35 31];
%
% s_c       -> bandwidth control parameter of the CSF of chromatic channel
%              'c' 
%              We assume all orientations have the same width (the only difference
%              is in the maximum Ao)
%              First column luminance
%              Second column chromatic channels (same parameter for both)
%              Hint:
%
%                   s=[1.5 1];
%
% t         -> Exponent that controls the sharpness of the CSF
%              (we assume all the orientations and chromatic channels have the 
%              same sharpness)
%              Hint:
%
%                   t=6;
%
% B         -> Maximum amplitude of the beta profile for the vertical orientation
%              we assume the horizontal orientation has the same parameter
%              and the diagonal orientation has a parameter multipled by
%              fact_o=0.6.
%              We assume that the color channels behave the same way as the
%              luminance channel
%              Hint:
%
%                   B=6;
%
% E         -> Total number of scales in the wavelet transform
%
% e         -> Scale index
%
% The shape of the beta profile is inspired in the standard deviation of natural images
% in wavelet domains so the only parameter is the maximum amplitude.
%
% USE: 
%
%  [alfa,beta] = alfa_beta_wav([A1_y A1_uv;A3_y A3_uv],[s1_y s1_uv],t,B,E);
%
% The output dimensions of 'alfa' and 'beta' are:
%
% alfa(scale,orientation,chromatic_channel)

alfas = zeros(escalas,3,3);

for capa = 1:3

    if(capa == 1)
        Ao = A(:,1);
        sigmas = [s(1) s(1)];
    else
        Ao = A(:,2);
        sigmas = [s(2) s(2)];
    end
    BB=[B 0.6*B];
    
    for escala = 1:escalas % HF --- LF        

        for orientacion = 1:3 % H V D

            if(orientacion == 3)
                sigma = sigmas(2);
                BBB=BB(2);
                AAA=Ao(2);
            else
                sigma = sigmas(1);
                BBB=BB(1);
                AAA=Ao(1);
            end
            
            alfa_i = AAA .* exp( - ( (escalas - escala) / sigma ) ^ expon );           
            beta_i = BBB .* exp( - ( (escalas - escala +1) / 1.1 ) ^ 1 );                       

            alfas(escala,orientacion,capa) = alfa_i;
            betas(escala,orientacion,capa) = beta_i;
            
        end

    end
    
end
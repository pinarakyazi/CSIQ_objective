function  [distorsion_ef,distorsion_fe,mapa_esp]=summation_model(dists,ind,expfreq,expspat);

% SUMMATION_MODEL pools the differences in the wavelet domain according to
% some Minkowski spatial and frequency summation exponents.
% A 4 scales orthogonal QMF domain is assumed.
% 
% SUMMATON_MODEL applies the pooling in two different ways:
%
%         (1) First spatial pooling in each subband and then frequency
%         pooling (d_ef)
%
%         (2) First frequency pooling across scales and orientations and
%         then spatial pooling (d_fe)
%
% These pooling strategies give rise to the same result when using 2-norm
% exponents.
%
% Syntax:
%
% [d_ef,d_fe,spatial_dist_map]=summation_model(dis,ind,expfreq,expspat);
%
%    Input:
%        dist = distortions in the wavelet domain in the YUV channels
%        expfreq = exponent for the frequency pooling 
%        expspat = exponent for the spatial pooling
%
%    Output:
%        d_ef = distortion pooled across the spatial dimension and then
%               accross the frequency dimension
%        d_fe = distortion pooled across the frequency dimension and then
%               accross the spatial dimension
%        spatial_dist_map = distortion map in the spatial domain (after
%                           frequency pooling and before spatial pooling
%
%

ef=expfreq;
es=expspat;

tam=2*ind(1,:);

[p,ind] = buildWpyr(zeros(tam(1),tam(2)),4);

                
            distorsion_ef = 0;
            distorsion_fe = 0;
 
                
                diso = reshape(dists(:),length(dists(:))/3,3);
                dis_c = zeros(prod(ind(end,:)),3);
                dis = abs([diso;dis_c]);
                
                % Primero sumacion espacial y luego frecuencial

                  dis_e    = dis.^es;
                  dis_frec = zeros(length(ind)-1,3);
                  
                  for capa=1:3
                      for band=1:length(ind)-1;
                          banda=pyrband(dis_e(:,capa),ind,band);
                          dis_frec(band,capa)=sum(sum(banda)).^(1/es);
                      end

                   end
                   distorsion_ef = (sum(sum(  dis_frec.^ef ) ).^(1/ef))/numel(diso);
                
                % Primero sumacion frecuencial y luego espacial

                  dis_f=dis.^ef;
                  mapa_esp=zeros(tam(1),tam(2),3);
                  
                  for capa=1:3               
                      sum_esc=zeros(ind(end,1),ind(end,2));                      
                      for esc=4:-1:1 
                          banda=[];
                          for or=1:3
                              band=(esc-1)*3+or;
                              bb=pyrband(dis_f(:,capa),ind,band)+sum_esc/3;
                              banda(:,:,or)=extrapola_2d(bb)/4;
                          end    
                          sum_esc=[];
                          sum_esc(:,:)=sum(banda,3);
                      end    
                      mapa_esp(:,:,capa)=(sum_esc).^(1/ef);
                  end    
                  distorsion_fe=   (sum(sum(sum(mapa_esp.^es))).^(1/es))/numel(diso);                  
                  
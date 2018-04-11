function r = non_linear_response(pyr,ind,alfas,exp,beta,h_sparse,color)

% NON_LINEAR_RESPONSE computes the divisive normalization for orthogonal wavelets.
%
%                |a.*w|.^g
%       r = --------------------
%             b + H * |a.*w|.^g
%
% Where the columns of the matrix 'w' contain the wavelet transform of each
% chromatic channel (using buildwpyr)
%
% 'a' and 'b' are generated with alfa_beta_wav, and have the following structure:
% Rows            (1) -> Scale             (from fine to coarse)
% Columns         (2) -> Orientation       (horizontal, vertical, diagonal)
% Third dimension (3) -> Chromatic channel (Y, U, V)
%
% And H is a sparse matrix generated with kernel_h_ort_hc
%
% USE:
%
% r   = non_linear_response(pyr,ind,a,g,b,H,color);


% Datos
[escalas orientaciones canales] = size(alfas);
capas = size(pyr,2);
if color==0
   pyr=pyr(:,1);
   capas=1;
end    

% Vector de respuestas
r = pyr;

    for capa = 1:capas % Y, U, V
            
            % Creamos un vector 'a' similar a 'r' sin la componente
            % de continua pero de una capa
            a = zeros(size(pyr,1)-prod(ind(end,:)),1);
            b = ones(size(pyr,1)-prod(ind(end,:)),1);            
            
            for escala = 1:escalas % De mas alta frecuencia a mas baja
                for orientacion = 1:orientaciones % H V D

                    % Calculamos la subbanda a procesar segun la escala y la
                    % orientacion donde nos encontramos
                    banda = orientaciones * (escala - 1) + orientacion;

                    % Calculamos los indices para dicha subbanda
                    indices = pyrBandIndices(ind,banda);

                    % Aplicamos la CSF y la no linealidad a cada subbanda                    
                    a(indices) = (abs(pyr(indices,capa) .* alfas(escala,orientacion,capa))) .^ exp;
                    b(indices) = (b(indices) .* beta(escala,orientacion,capa).^ exp);
                    
                end
            end

            % En cada capa calculamos la Normalizacion Divisiva
            r(1:size(a,1),capa) = a ./ ( b + h_sparse * a );
            r(:,capa) = sign(pyr(:,capa)) .* abs(r(:,capa));

    end
function B=extrapola_2d(A)

%  EXTRAPOLA_2D convierte una matriz A de tamaño n*m en una matriz B de
%  tamaño 2n*2m en la que cada elemento se replica 4 veces
%
%

ii = interp2(A,1,'nearest');B=[[ii(1,1);ii(:,1)] [[ii(1,:)];ii]];

    
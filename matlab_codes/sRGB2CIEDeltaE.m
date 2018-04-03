function deltaE = sRGB2CIEDeltaE(SamplesRGB1,SamplesRGB2,formula)
% function deltaE = sRGB2CIEDeltaE(SamplesRGB1,SamplesRGB2,formula)
%
% Calculates color difference, deltaE, of a set of sRGB data pairs, SamplesRGB1 and
% SamplesRGB2(both within[0 1]).
%
% CIEDE1994, CIEDE2000 and CIELAB are alternative according to user input
% formula, which can be 'cie94', 'cie00' and 'cielab'(case sensitive).
%
% SamplesRGB1 and SamplesRGB2 should have the same size, N*3, with each row
% denoting a sRGB triplet and N for the number of sRGB pairs to be
% compared. Generally, but not always, SamplesRGB1 is regarded as standard
% references
%
% Example1:
% >> sRGB2CIEDeltaE([0.42 0.77 0.37],[0.50 0.83 0.46],'cie00')
% ans = 
%       4.4351
%
% Example2:
% >> sRGBpairs1 = [0.1743,0.0819,0.0541;...
%                  0.5565,0.3047,0.2208;...
%                  0.1091,0.1999,0.3428];
% >> sRGBpairs2 = [0.1225,0.1388,0.1083;...
%                  0.3423,0.3626,0.2826;...
%                  0.1365,0.2390,0.3095];
% >> sRGB2CIEDeltaE(sRGBpairs1,sRGBpairs2,'cie94')
% ans = 
%       11.5193
%       19.4527
%       32.0004
%
%   Copyright(C)  2015  QiuJueqin  All rights reserved
%   Created by QiuJueqin at 23/09/2015 12:59
%   Jqx1991@gmail.com

if (size(SamplesRGB1,2) ~= 3) || (size(SamplesRGB2,2) ~= 3) ||...
        (size(SamplesRGB1,1) ~= size(SamplesRGB2,1))
    error('Two sRGB samples should be same size, e.g. N*3.');
end
Xn = 95.05;Yn = 100;Zn = 108.90;
SamplesXYZ1 = 100*rgb2xyz(SamplesRGB1);
SamplesXYZ2 = 100*rgb2xyz(SamplesRGB2);

SamplesL1 = 116*f(SamplesXYZ1(:,2)/Yn)-16;
SamplesL2 = 116*f(SamplesXYZ2(:,2)/Yn)-16;
Samplesa1 = 500*(f(SamplesXYZ1(:,1)/Xn)-f(SamplesXYZ1(:,2)/Yn));
Samplesa2 = 500*(f(SamplesXYZ2(:,1)/Xn)-f(SamplesXYZ2(:,2)/Yn));
Samplesb1 = 200*(f(SamplesXYZ1(:,2)/Yn)-f(SamplesXYZ1(:,3)/Zn));
Samplesb2 = 200*(f(SamplesXYZ2(:,2)/Yn)-f(SamplesXYZ2(:,3)/Zn));
% SamplesL1 = SamplesRGB1(:,1);
% SamplesL2 = SamplesRGB2(:,1);
% Samplesa1 = SamplesRGB1(:,2);
% Samplesa2 = SamplesRGB2(:,2);
% Samplesb1 = SamplesRGB1(:,3);
% Samplesb2 = SamplesRGB2(:,3);

SamplesC1 = sqrt(Samplesa1.^2+Samplesb1.^2);
SamplesC2 = sqrt(Samplesa2.^2+Samplesb2.^2);
deltaEab = sqrt((SamplesL1 - SamplesL2).^2 + (Samplesa1 - Samplesa2).^2 + (Samplesb1 - Samplesb2).^2);
deltaCab = sqrt((Samplesa1 - Samplesa2).^2 + (Samplesb1 - Samplesb2).^2);
deltaHab = sqrt(deltaEab.^2 - (SamplesL1-SamplesL2).^2 - deltaCab.^2);

if strcmp(formula,'cie00')
    C_bar = (SamplesC1 + SamplesC2)/2;
    G = 0.5*(1-sqrt(C_bar.^7./(C_bar.^7+25^7)));

    Lsp = SamplesL1; % s for standard
    Lbp = SamplesL2; % b for sample
    asp = (1+G).*Samplesa1;
    abp = (1+G).*Samplesa2;
    bsp = Samplesb1;
    bbp = Samplesb2;
    Csp = sqrt(asp.^2+bsp.^2);
    Cbp = sqrt(abp.^2+bbp.^2);
    hsp = f_atan(asp,bsp);
    hbp = f_atan(abp,bbp);

    deltaLp = Lbp - Lsp;
    deltaCp = Cbp - Csp;
    deltahp = f_deltahp(hsp, hbp, Csp, Cbp);
    deltaHp = 2*sqrt(Cbp.*Csp).*sin(deltahp/2);

    Lp_bar = (Lsp + Lbp)/2;
    Cp_bar = (Csp + Cbp)/2;
    hp_bar = hueDiff(hsp, hbp, Csp, Cbp);

    SL = 1 + (0.015*(Lp_bar-50).^2)./sqrt(20+(Lp_bar-50).^2);
    SC = 1 + 0.045*Cp_bar;
    T = 1 - 0.17*cos(hp_bar-pi/6) + 0.24*cos(2*hp_bar) + 0.32*cos(3*hp_bar+pi/30) - 0.20*cos(4*hp_bar-pi/(180/63));
    deltaTheta = (30*exp(-((hp_bar-pi/(180/275))/(25*pi/180)).^2))*pi/180;
    RC = 2*sqrt((Cp_bar.^7)./(Cp_bar.^7 + 25^7));
    RT = -sin(2*deltaTheta).*RC;
    SH = 1 + 0.015*Cp_bar.*T;

    deltaE = sqrt((deltaLp./SL).^2 + (deltaCp./SC).^2 + (deltaHp./SH).^2 + RT.*(deltaCp./SC).*(deltaHp./SH));
elseif strcmp(formula,'cie94')
    Cab = sqrt(SamplesC1.*SamplesC2);
    SL = 1;
    SC = 1 + 0.045*Cab;
    SH = 1 + 0.015*Cab;
    deltaE = sqrt(((SamplesL1-SamplesL2)/SL).^2 + (deltaCab./SC).^2 + (deltaHab./SH).^2);
elseif strcmp(formula,'cielab')
    deltaE = sqrt((1*(SamplesL1-SamplesL2)).^2 + (0.5*deltaCab).^2 + (0.75*deltaHab).^2);
end
end

function y = f_atan(x1,x2)
for i = 1:size(x1,1)
    if x1(i)==x2(i)
        y(i,:) = 0;
    elseif x1(i)>=0 && x2(i)<0
        y(i,:) = atan(x2(i)/x1(i))+2*pi;
    elseif x1(i)<0
        y(i,:) = atan(x2(i)/x1(i))+pi;
    elseif x1(i)>=0 && x2(i)>0
        y(i,:) = atan(x2(i)/x1(i));
    end
end
end

function y = f_deltahp(x1,x2,x3,x4)
for i = 1:size(x1,1)
    if x3(i)+x4(i) == 0
        y(i,:) = 0;
    elseif abs(x2(i)-x1(i)) <= pi
        y(i,:) = x2(i)-x1(i);
    elseif x2(i)-x1(i)>pi
        y(i,:) = x2(i)-x1(i)-2*pi;
    elseif x2(i)-x1(i)<(-pi)
        y(i,:) = x2(i)-x1(i)+2*pi;
    end
end
end

function y = f(x)
if x>0.008856
    y = x.^(1/3);
else
    y = 7.787*x+16/116;
end
end

function y = hueDiff(x1,x2,x3,x4)
for i = 1:size(x1,1)
    if x3(i)*x4(i) == 0
        y(i,:) = x1(i)+x2(i);
    elseif abs(x1(i)-x2(i)) <= pi
        y(i,:) = (x1(i)+x2(i))/2;
    elseif (abs(x1(i)-x2(i)) > pi) && ((x1(i)+x2(i)) < 2*pi)
        y(i,:) = (x1(i)+x2(i)+2*pi)/2;
    elseif (abs(x1(i)-x2(i)) > pi) && ((x1(i)+x2(i)) >= 2*pi)
        y(i,:) = (x1(i)+x2(i)-2*pi)/2;
    end
end
end
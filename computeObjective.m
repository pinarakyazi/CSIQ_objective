% computeObjective  
%
%   1- Computes the quality of distorted images in CSIQ database using
%   the following metrics: MSE, SNR, PSNR, PSNR-HVS, PSNR-HVS-M, UQI, SSIM,
%   MS-SSIM, M-SVD, QILV, IFC, VIF, VIFp, FSIM, IW-MSE, IW-PSNR, IW-SSIM, 
%   WSNR, VSNR.
%   
%   2- Plots 1-DMOS vs. result for each image in CSIQ database, for each 
%   metric.
%
%   3- Computes the Pearson Correlation Coefficient between objective
%   metric results and subjective ratings for all images in CSIQ database.

%% Reading reference and distorted images.

srcFolder = '/Users/pinar/Desktop/MMSPG/DigitalEye/objective_metrics/src_imgs'; % path of reference files
cd(srcFolder) % go to reference images folder

allPngFiles = dir('*.png');
N = length(allPngFiles);

% keep names of reference files
for n=1:N
    file = allPngFiles(n).name;
    [filepath,name,ext] = fileparts(file);
    names{n} = name;
end

dstAllFolder = '/Users/pinar/Desktop/MMSPG/DigitalEye/objective_metrics/dst_imgs';
cd(dstAllFolder)

allPngFiles = dir('*.png');
numDist = length(allPngFiles);
distortions = {'AWGN','BLUR','contrast','dst_all','fnoise','JPEG','jpeg2000'};

metricsFolder = '/Users/pinar/Desktop/MMSPG/DigitalEye/objective_metrics/matlab_files';
addpath(genpath(metricsFolder));


%% MSE

MSEvec_R = zeros(numDist,1);
MSEvec_G = zeros(numDist,1);
MSEvec_B = zeros(numDist,1);
MSEvec_avg = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    MSE = MeanSquareError(srcFile, dstFile);    
    MSEvec_R(i) = MSE(1,1,1);
    MSEvec_G(i) = MSE(1,1,2);
    MSEvec_B(i) = MSE(1,1,3);
    MSEvec_avg(i) = mean([MSE(1,1,1), MSE(1,1,2), MSE(1,1,3)]);
end

%% SNR

SNRvec_R = zeros(numDist,1);
SNRvec_G = zeros(numDist,1);
SNRvec_B = zeros(numDist,1);
SNRvec_avg = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    SNRvec_R(i) = 20*log(norm(double(srcFile(:,:,1)))/norm(double(srcFile(:,:,1)-dstFile(:,:,1))));    
    SNRvec_G(i) = 20*log(norm(double(srcFile(:,:,2)))/norm(double(srcFile(:,:,2)-dstFile(:,:,2))));    
    SNRvec_B(i) = 20*log(norm(double(srcFile(:,:,3)))/norm(double(srcFile(:,:,3)-dstFile(:,:,3))));    
    SNRvec_avg(i) = mean([SNRvec_R(i), SNRvec_G(i), SNRvec_B(i)]);
end

%% PSNR

PSNRvec_R = zeros(numDist,1);
PSNRvec_G = zeros(numDist,1);
PSNRvec_B = zeros(numDist,1);
PSNRvec_avg = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    PSNR = PeakSignaltoNoiseRatio(srcFile, dstFile);    
    PSNRvec_R(i) = PSNR(1,1,1);
    PSNRvec_G(i) = PSNR(1,1,2);
    PSNRvec_B(i) = PSNR(1,1,3);
    PSNRvec_avg(i) = mean([PSNR(1,1,1), PSNR(1,1,2), PSNR(1,1,3)]);
end

%% UQI

UQIVec = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    [UQIVec(i), ~] = UQI_FR(srcFile, dstFile);    
end

%% SSIM

SSIMVec = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    [SSIMVec(i), ~] = SSIM_FR(srcFile, dstFile);    
end

%% MS-SSIM

MSSSIMVec = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    [MSSSIMVec(i)] = MS_SSIM_FR(srcFile, dstFile);    
end

MSSSIMVec = real(MSSSIMVec);
MSSSIMVec(MSSSIMVec>1)=1;
MSSSIMVec(MSSSIMVec<0)=0;
MSSSIMVec(MSSSIMVec==0)=NaN;

%% M-SVD

MSVDvec_R = zeros(numDist,1);
MSVDvec_G = zeros(numDist,1);
MSVDvec_B = zeros(numDist,1);
MSVDvec_avg = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    [MSVDvec_R(i), ~] = SVD_FR(srcFile(:,:,1), dstFile(:,:,1));    
    [MSVDvec_G(i), ~] = SVD_FR(srcFile(:,:,2), dstFile(:,:,2));
    [MSVDvec_B(i), ~] = SVD_FR(srcFile(:,:,3), dstFile(:,:,3));
    MSVDvec_avg(i) = mean([MSVDvec_R(i), MSVDvec_G(i), MSVDvec_B(i)]);
end

%% QILV

QILVvec = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    [QILVvec(i)] = qilv(srcFile, dstFile, 0);    
end

%% IFC

IFCvec_R = zeros(numDist,1);
IFCvec_G = zeros(numDist,1);
IFCvec_B = zeros(numDist,1);
IFCvec_avg = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    IFCvec_R(i) = ifcvec(srcFile(:,:,1), dstFile(:,:,1));    
    IFCvec_G(i) = ifcvec(srcFile(:,:,2), dstFile(:,:,2));
    IFCvec_B(i) = ifcvec(srcFile(:,:,3), dstFile(:,:,3));
    IFCvec_avg(i) = mean([IFCvec_R(i), IFCvec_G(i), IFCvec_B(i)]);
end

%% VIF

VIFvec_R = zeros(numDist,1);
VIFvec_G = zeros(numDist,1);
VIFvec_B = zeros(numDist,1);
VIFvec_avg = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    VIFvec_R(i) = VIF_FR(srcFile(:,:,1), dstFile(:,:,1));    
    VIFvec_G(i) = VIF_FR(srcFile(:,:,2), dstFile(:,:,2));
    VIFvec_B(i) = VIF_FR(srcFile(:,:,3), dstFile(:,:,3));
    VIFvec_avg(i) = mean([VIFvec_R(i), VIFvec_G(i), VIFvec_B(i)]);
end

%% FSIM

FSIMcVec = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    [~, FSIMcVec(i)] = FeatureSIM(srcFile, dstFile);    
end

%% IW

IWSSIMVec_R = zeros(numDist,1);
IWMSEVec_R = zeros(numDist,1);
IWPSNRVec_R = zeros(numDist,1); 

IWSSIMVec_G = zeros(numDist,1);
IWMSEVec_G = zeros(numDist,1);
IWPSNRVec_G = zeros(numDist,1); 

IWSSIMVec_B = zeros(numDist,1);
IWMSEVec_B = zeros(numDist,1);
IWPSNRVec_B = zeros(numDist,1);

IWSSIMVec_avg = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    [IWSSIMVec_R(i), IWMSEVec_R(i), IWPSNRVec_R(i)] = iwssim(srcFile(:,:,1), dstFile(:,:,1));
    [IWSSIMVec_G(i), IWMSEVec_G(i), IWPSNRVec_G(i)] = iwssim(srcFile(:,:,2), dstFile(:,:,2));
    [IWSSIMVec_B(i), IWMSEVec_B(i), IWPSNRVec_B(i)] = iwssim(srcFile(:,:,3), dstFile(:,:,3));
    IWSSIMVec_avg(i) = mean([IWSSIMVec_R(i), IWSSIMVec_G(i), IWSSIMVec_B(i)]);
end

%% WSNR

WSNRvec_R = zeros(numDist,1);
WSNRvec_G = zeros(numDist,1);
WSNRvec_B = zeros(numDist,1);
WSNRvec_avg = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    WSNRvec_R(i) = wsnr(srcFile(:,:,1), dstFile(:,:,1));    
    WSNRvec_G(i) = wsnr(srcFile(:,:,2), dstFile(:,:,2));
    WSNRvec_B(i) = wsnr(srcFile(:,:,3), dstFile(:,:,3));
    WSNRvec_avg(i) = mean([WSNRvec_R(i), WSNRvec_G(i), WSNRvec_B(i)]);
end

%% VSNR

VSNRVec = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    VSNRVec(i) = vsnr_modified(srcFile, dstFile, -1, -1);    
end

%% Read results of VQMT software to vectors

CSIQFolder = '/Users/pinar/Desktop/MMSPG/DigitalEye/objective_metrics'; % path of computation directory
cd(CSIQFolder)

VIFpVec = csvread('result_vifp.csv', 1,1, [1, 1, length(allPngFiles), 1]);
PSNRHVSVec = csvread('result_psnrhvs.csv', 1,1, [1, 1, length(allPngFiles), 1]);
PSNRHVSVMec = csvread('result_psnrhvsm.csv', 1,1, [1, 1, length(allPngFiles), 1]);

%% Write all results in a matrix and save

metricNames = {'MSE', 'SNR', 'PSNR', 'PSNR-HVS', 'PSNR-HVS-M', 'UQI', 'SSIM', 'MS-SSIM', 'M-SVD', 'QILV', 'IFC', 'VIF', 'VIFp', 'FSIM', 'IW-MSE', 'IW-PSNR', 'IW-SSIM', 'WSNR', 'VSNR'};
numfeatures = length(metricNames);
featuremat = zeros(length(allPngFiles),numfeatures);

featuremat(:,1) = MSEvec_avg;
featuremat(:,2) = SNRvec_avg;
featuremat(:,3) = PSNRvec_avg;
featuremat(:,4) = PSNRHVSVec;
featuremat(:,5) = PSNRHVSMVec;
featuremat(:,6) = UQIVec;
featuremat(:,7) = SSIMVec;
featuremat(:,8) = MSSSIMVec;
featuremat(:,9) = MSVDvec_avg;
featuremat(:,10) = QILVvec;
featuremat(:,11) = IFCvec_avg;
featuremat(:,12) = VIFvec_avg;
featuremat(:,13) = VIFpVec;
featuremat(:,14) = FSIMc;
featuremat(:,15) = IWMSEVec_avg;
featuremat(:,16) = IWPSNRVec_avg;
featuremat(:,17) = IWSSIMVec_avg;
featuremat(:,18) = WSNRvec_avg;
featuremat(:,19) = VSNRVec_avg;

csvwrite('CSIQfeaturemat.csv',featuremat);

%% Plot results - 1-DMOS vs. objective metric result

dmos_sorted = csvread('CSIQdmos_sorted.csv');
dmos_to_mos = 1-dmos_sorted;
[dmos_ascending, ascending_indices] = sort(dmos_to_mos, 'ascend');
LUT_level_sorted_asc = LUT_level(ascending_indices);
LUT_type_sorted_asc = LUT_type(ascending_indices);
colors = prism(length(distortions));
alphas = LUT_level_sorted_asc/5;
metricNames = {'MSE', 'SNR', 'PSNR', 'PSNR-HVS', 'PSNR-HVS-M', 'UQI', 'SSIM', 'MS-SSIM', 'M-SVD', 'QILV', 'IFC', 'VIF', 'VIFp', 'FSIM', 'IW-MSE', 'IW-PSNR', 'IW-SSIM', 'WSNR', 'VSNR'};
for i = 1:size(featuremat,2)
    h = figure; hold on; set(gca,'FontSize',12)
    for j = 1:length(dmos_sorted)
        level_j = LUT_level_sorted_asc(j);
        color_j = colors(LUT_type_sorted_asc(j),:);
        s = scatter(featuremat(ascending_indices(j),i), dmos_ascending(j), 'MarkerEdgeColor', 'None', 'MarkerFaceColor', color_j, 'LineWidth', 5);
        s.MarkerFaceAlpha = alphas(j);
    end
    xlabel(metricNames{i});
    ylabel('1-DMOS');
    title(sprintf('Subjective scores vs. %s', metricNames{i}));
    % Uncomment following lines if you want to display the legend
    %lbl = {'AWGN','Blur','Contrast','Fnoise','JPEG','JPEG2000'};
    %for ii = 1:size(colors,1)
        %p(ii) = patch(NaN, NaN, colors(ii,:));
    %end
    %legend(p, lbl);
    saveas(h, sprintf('DMOS_vs_%s.png',metricNames{i}));
    close(h);
end

%% PCC computations

for i = 1:size(featuremat,2)
    currFeat = featuremat(:,i);
    if find(isnan(currFeat))
        currFeat(isnan(featuremat(:,i)))=[];
        dmosCopy = dmos_sorted;
        dmosCopy(isnan(featuremat(:,i)))=[];
        [pcorr(i), pval(i)] = corr(currFeat, 1-dmosCopy, 'type', 'pearson');
    else    
        [pcorr(i), pval(i)] = corr(featuremat(:,i), 1-dmos_sorted, 'type', 'pearson');
    end        
end

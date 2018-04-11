load loadNarpix.mat;
addpath(genpath('/Users/pinar/Desktop/MMSPG/Databases/CSIQ/dst_imgs/dst_all'));
addpath(genpath('/Users/pinar/Desktop/MMSPG/Databases/CSIQ/src_imgs'));
addpath(genpath('/Users/pinar/Downloads/div_norm_metric/standard_V1_model'));
addpath(genpath('/Users/pinar/Desktop/MMSPG/Metrics/image-quality-tools-master/metrix_mux/utilities/matlabPyrTools'));

DNvec = zeros(numDist,1);

for i = 1:numDist
    file = allPngFiles(i).name;
    [filepath,name,ext] = fileparts(file);
    parseName = strsplit(file,'.');
    srcName = parseName{1};
    dstName = parseName{2};
    level = parseName{3};
    dstFile = imread(file);
    srcFile = imread(strcat(srcName,'.png'));
    %MSE = MeanSquareError(srcFile, dstFile);    
    [~,DNvec(i),~]=div_norm_metric(srcFile, dstFile);
end

%%
featuremat(:,1) = DNvec;

dmos_sorted = csvread('CSIQdmos_sorted.csv');
dmos_to_mos = 1-dmos_sorted;
[dmos_ascending, ascending_indices] = sort(dmos_to_mos, 'ascend');
LUT_level_sorted_asc = LUT_level(ascending_indices);
LUT_type_sorted_asc = LUT_type(ascending_indices);
colors = prism(length(distortions));
alphas = LUT_level_sorted_asc/5;
metricNames = {'DN'};
for i = 1%1:size(featuremat,2)
    h = figure; hold on; set(gca,'FontSize',12)
    for j = 1:length(dmos_sorted)
        if (LUT_type_sorted_asc(j)==5 || LUT_type_sorted_asc(j)==6)
            level_j = LUT_level_sorted_asc(j);
            color_j = colors(LUT_type_sorted_asc(j),:);
            s = scatter(featuremat(ascending_indices(j),i), dmos_ascending(j), 'MarkerEdgeColor', 'None', 'MarkerFaceColor', color_j, 'LineWidth', 5);
            s.MarkerFaceAlpha = alphas(j);
        end
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
    %saveas(h, sprintf('DMOS_vs_%s.png',metricNames{i}));
    %close(h);
end

%% PCC only for JPEG & JPEG2000

%% PCC only for HEVC & AVC
dnSorted = featuremat(ascending_indices);
mosSorted = dmos_ascending;
dnReduced = dnSorted(LUT_type_sorted_asc==5 | LUT_type_sorted_asc==1 | LUT_type_sorted_asc==6);
mosReduced = mosSorted(LUT_type_sorted_asc==5 | LUT_type_sorted_asc==1 | LUT_type_sorted_asc==6);

%for i = 1:size(featuremat,2)
i = 1;
    currFeat = dnReduced(:,i);
    if find(isnan(currFeat))
        currFeat(isnan(dnReduced(:,i)))=[];
        mosCopy = mosReduced;
        mosCopy(isnan(mosReduced(:,i)))=[];
        [pcorrReduced(i), pvalReduced(i)] = corr(currFeat, mosCopy, 'type', 'pearson');
    else    
        [pcorrReduced(i), pvalReduced(i)] = corr(dnReduced(:,i), mosReduced, 'type', 'pearson');
    end        
%end


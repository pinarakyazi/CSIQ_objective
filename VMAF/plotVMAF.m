fileID = fopen('CSIQVideo_DMOS.txt');
formatSpec = '%s %f %f';
CSIQVideo_DMOSread = textscan(fileID,formatSpec);
fclose(fileID);
numSeq = length(CSIQVideo_DMOSread{1});

fileID = fopen('vmafResults.txt');
formatSpec = '%f';
CSIQVideo_VMAFresults = textscan(fileID,formatSpec);
fclose(fileID);

seqNames = CSIQVideo_DMOSread{1};
dmosVec = CSIQVideo_DMOSread{2};
vmafVec = CSIQVideo_VMAFresults{1};
mosVec = 1-dmosVec/100;
[mosSorted, ind] = sort(mosVec, 'ascend');
vmafSorted = vmafVec(ind);

numDistortions = 6;
numLevels = 3;

%% Plot results - 1-DMOS vs. objective metric result

%dmos_sorted = csvread('CSIQdmos_sorted.csv');
%dmos_to_mos = 1-dmos_sorted;
%[dmos_ascending, ascending_indices] = sort(dmos_to_mos, 'ascend');

levels = [1:numLevels]';
LUT_level = repmat(levels, numSeq/numLevels, 1);
types = 1:numDistortions;
LUT_type = repmat(reshape(repmat(types, numLevels, 1), numLevels*numDistortions, 1), numSeq/(numDistortions*numLevels), 1);
LUT_level_sorted_asc = LUT_level(ind);
LUT_type_sorted_asc = LUT_type(ind);
colors = prism(numDistortions);
alphas = LUT_level_sorted_asc/numLevels;
metricNames = {'VMAF'};
%for i = 1:size(featuremat,2)
i = 1;
    h = figure; hold on; set(gca,'FontSize',12)
    for j = 1:length(mosSorted)
        if (LUT_type_sorted_asc(j)==1 || LUT_type_sorted_asc(j)==6)
            level_j = LUT_level_sorted_asc(j);
            color_j = colors(LUT_type_sorted_asc(j),:);
            s = scatter(vmafSorted(j), mosSorted(j), 'MarkerEdgeColor', 'None', 'MarkerFaceColor', color_j, 'LineWidth', 5);
            %s.MarkerFaceAlpha = alphas(j);
        end
    end
    xlabel(metricNames{i});
    ylabel('1-DMOS');
    title(sprintf('Subjective scores vs. %s', metricNames{i}));
    % Uncomment following lines if you want to display the legend
    % lbl = {'H.264/AVC','WIRELESS','MJPEG','SNOW','AWGN','HEVC/H.265'};
    % for ii = 1:size(colors,1)
    %     p(ii) = patch(NaN, NaN, colors(ii,:));
    % end
    % legend(p, lbl);
    saveas(h, sprintf('DMOS_vs_%s.png',metricNames{i}));
    close(h);
%end

%% PCC computations

%for i = 1:size(featuremat,2)
i = 1;
    currFeat = vmafSorted(:,i);
    if find(isnan(currFeat))
        currFeat(isnan(vmafSorted(:,i)))=[];
        mosCopy = mosSorted;
        mosCopy(isnan(mosSorted(:,i)))=[];
        [pcorr(i), pval(i)] = corr(currFeat, mosCopy, 'type', 'pearson');
    else    
        [pcorr(i), pval(i)] = corr(vmafSorted(:,i), mosSorted, 'type', 'pearson');
    end        
%end

%% PCC only for HEVC & AVC

vmafReduced = vmafSorted(LUT_type_sorted_asc==1 | LUT_type_sorted_asc==6);
mosReduced = mosSorted(LUT_type_sorted_asc==1 | LUT_type_sorted_asc==6);

%for i = 1:size(featuremat,2)
i = 1;
    currFeat = vmafReduced(:,i);
    if find(isnan(currFeat))
        currFeat(isnan(vmafReduced(:,i)))=[];
        mosCopy = mosReduced;
        mosCopy(isnan(mosReduced(:,i)))=[];
        [pcorrReduced(i), pvalReduced(i)] = corr(currFeat, mosCopy, 'type', 'pearson');
    else    
        [pcorrReduced(i), pvalReduced(i)] = corr(vmafReduced(:,i), mosReduced, 'type', 'pearson');
    end        
%end

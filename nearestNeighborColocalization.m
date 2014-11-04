
gfpPath = 'R:\Data\140211_Plaque2.0_fig\13_Plaques_23Sep2014\gfp-result\gfp.mat';
tritcPath = 'R:\Data\140211_Plaque2.0_fig\13_Plaques_23Sep2014\tritc-result\tritc.mat';

% get gfp data

dataArray = load(gfpPath);
gfpTable = struct2table(dataArray.ObjectDataArray);

% get tritc data

dataArray = load(tritcPath);
tritcTable = struct2table(dataArray.ObjectDataArray);

hrv16Only_tritcIdx = find(...
    uint8(strcmp(tritcTable.wellRow, 'D')).*uint8(strcmp(tritcTable.wellCollumn, '06')) + ...
    uint8(strcmp(tritcTable.wellRow, 'E')).*uint8(strcmp(tritcTable.wellCollumn, '04')) + ...
    uint8(strcmp(tritcTable.wellRow, 'E')).*uint8(strcmp(tritcTable.wellCollumn, '08')));
both_tritcIdx = find(...
    uint8(strcmp(tritcTable.wellRow, 'D')).*uint8(strcmp(tritcTable.wellCollumn, '07')) + ...
    uint8(strcmp(tritcTable.wellRow, 'E')).*uint8(strcmp(tritcTable.wellCollumn, '05')) + ...
    uint8(strcmp(tritcTable.wellRow, 'E')).*uint8(strcmp(tritcTable.wellCollumn, '09')));
hrv1aOnly_gfpIdx = find(...
    uint8(strcmp(gfpTable.wellRow, 'D')).*uint8(strcmp(gfpTable.wellCollumn, '05')) + ...
    uint8(strcmp(gfpTable.wellRow, 'D')).*uint8(strcmp(gfpTable.wellCollumn, '09')) + ...
    uint8(strcmp(gfpTable.wellRow, 'E')).*uint8(strcmp(gfpTable.wellCollumn, '07')));
both_gfpIdx = find(...
    uint8(strcmp(gfpTable.wellRow, 'D')).*uint8(strcmp(gfpTable.wellCollumn, '07')) + ...
    uint8(strcmp(gfpTable.wellRow, 'E')).*uint8(strcmp(gfpTable.wellCollumn, '05')) + ...
    uint8(strcmp(gfpTable.wellRow, 'E')).*uint8(strcmp(gfpTable.wellCollumn, '09')));


% get vectors of distances to the nearest neighbor from a different channel

both_nearesetEuclidianDistances = distanceToNearestNeighbor(gfpTable.Centroid(both_gfpIdx,1), gfpTable.Centroid(both_gfpIdx,2), tritcTable.Centroid(both_tritcIdx,1), tritcTable.Centroid(both_tritcIdx,2));

self_hrv1a_nearesetEuclidianDistances = distanceToNearestNeighbor(gfpTable.Centroid(hrv1aOnly_gfpIdx,1), gfpTable.Centroid(hrv1aOnly_gfpIdx,2), gfpTable.Centroid(hrv1aOnly_gfpIdx,1), gfpTable.Centroid(hrv1aOnly_gfpIdx,2));

self_hrv16_nearesetEuclidianDistances = distanceToNearestNeighbor(tritcTable.Centroid(hrv16Only_tritcIdx,1), tritcTable.Centroid(hrv16Only_tritcIdx,2), tritcTable.Centroid(hrv16Only_tritcIdx,1), tritcTable.Centroid(hrv16Only_tritcIdx,2));

random_overlap_hrv1a_hrv16_nearesetEuclidianDistances = distanceToNearestNeighbor(gfpTable.Centroid(hrv1aOnly_gfpIdx,1), gfpTable.Centroid(hrv1aOnly_gfpIdx,2), tritcTable.Centroid(hrv16Only_tritcIdx,1), tritcTable.Centroid(hrv16Only_tritcIdx,2));

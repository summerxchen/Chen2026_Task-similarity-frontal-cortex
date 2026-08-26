function CellId = func_LiteCellFilter(Units, CellFilter)

% Filtering cells and get id of valid cells for TA task.
% Xia Chen (2025)

CellTag = nan(size(Units));

for iUnit = 1:length(Units)
    unit = Units{iUnit};
    if unit.RecordingDepthD > CellFilter.DepthRange(2) || unit.RecordingDepthD < CellFilter.DepthRange(1) ||...
            unit.MetricsDuration > CellFilter.MetricsDur(2)  || unit.MetricsDuration < CellFilter.MetricsDur(1) ||...
            unit.MetricsFiring_Rate < CellFilter.MetricsFRthr
        CellTag(iUnit) = 0;
        continue;
    end

    CellTag(iUnit)=1;
end
CellId = find(CellTag);

end
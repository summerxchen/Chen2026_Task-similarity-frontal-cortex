function lmx = SglUnit_Regress_3way_TSC_catgorical(PSTHs, Trials, TimeA, time_win, TaskTag)

% For single-unit NMS analyses.
% Fit time-averaged single-trial activity with task variables: task, stimuli, and choice.

% INPUT: 
%       PSTHs: units × time × trials
%      Trials: trial information
%       TimeA: time information used to calcualte PSTHs
%    time_win: [start end], time window for averaging PSTHs
%     TaskTag: 'TAs' or 'TAr', used to assign the appropriate definition of the 'stimulus' term in LMlabel 

% OUTPUT:
%    lmx: fitted linear model

% This is a simplified version. Xia Chen (2026)

%% ====== Variables ======
% TrialOrder	     slow temporal drift (necessary when only one transition happended)
% Task	      (T)    task context (tactile or auditory)
% Stimuli     (S)	 sensory salience/intensity (weak or strong)
% Choice      (C)    behavioral output (lick left or right)
% Firing Rate (FR)   response variable

LMVarNames= {'TrialOrder','Task','Stimuli','Choice','FR'};

% get variable table, same order as TrialType
switch TaskTag
    case 'TAs'
        LMlabel = {
            'T1' 'S1' 'C1'; % TLC
            'T1' 'S1' 'C2'; % TLE
            'T1' 'S2' 'C2'; % TRC
            'T1' 'S2' 'C1'; % TRE
            'T2' 'S1' 'C1'; % ALC
            'T2' 'S1' 'C2'; % ALE
            'T2' 'S2' 'C2'; % ARC
            'T2' 'S2' 'C1'};% ARE
    case 'TAr'
        LMlabel = {
            'T1' 'S1' 'C1'; % TLC
            'T1' 'S1' 'C2'; % TLE
            'T1' 'S2' 'C2'; % TRC
            'T1' 'S2' 'C1'; % TRE
            'T2' 'S2' 'C1'; % ALC
            'T2' 'S2' 'C2'; % ALE
            'T2' 'S1' 'C2'; % ARC
            'T2' 'S1' 'C1'};% ARE
end

%% ====== Get stable trials ====== 
TrialType = {'TLC', 'TLE', 'TRC', 'TRE', 'ALC', 'ALE', 'ARC', 'ARE'};
BalanceTrial = 0;
[TrialId, Ntrial] = fun_GetTrialPool(Trials, TrialType, BalanceTrial);

% trial order
TrialOrder = transpose(cell2mat(TrialId));

%% ====== Get FR ====== 
% get PSTH of stable trials
timeid = find(TimeA.time>=time_win(1) & TimeA.time<time_win(2));
% catenate trial types to get the 'Predictor Data'      {TrialType,1} trials*units
FR = cellfun(@(x) squeeze(mean(PSTHs(:,timeid,x),2))', TrialId', 'UniformOutput', false);  
MeanFR = cell2mat(cellfun(@mean,FR, 'UniformOutput', false)); 
StdFR =  cell2mat(cellfun(@std,FR, 'UniformOutput', false)); 
FR = cell2mat(FR); 

%% ====== Build design ====== 
LMVarMatrix = arrayfun(@(x) repmat(LMlabel(x,:),Ntrial(x),1), (1:8)', 'UniformOutput', false); 
LMVarMatrix = vertcat(LMVarMatrix{:});
Task    = categorical(LMVarMatrix(:,1));
Stimuli = categorical(LMVarMatrix(:,2));
Choice  = categorical(LMVarMatrix(:,3));

nUnit = size(PSTHs,1);
lmx = cell(nUnit,1); % initialize

for iU = 1:nUnit
    LinearTbl = table(TrialOrder, Task, Stimuli, Choice, FR(:,iU), ...
        'VariableNames', LMVarNames);

    % fit full 3-way model(ANOVA equivalent). 
    % Add one additional variable: TrialOrder (2026)
    lmx{iU} = fitlm(LinearTbl,'FR ~ TrialOrder + Task*Stimuli*Choice');

end

end
function lmx = SglUnit_Regress_3way_TCO_catgorical(PSTHs, Trials, TimeA, time_win)

% For single-unit NMS analyses.
% Fit time-averaged single-trial activity with task variables.

% INPUT: 
%       PSTHs: units × time × trials
%      Trials: trial information
%       TimeA: time information used to calcualte PSTHs
%    time_win: [start end], time window for averaging PSTHs

% OUTPUT:
%    lmx: fitted linear model

% This is a simplified version. Xia Chen (2026)

%% ====== Variables ======
% TrialOrder       	 slow temporal drift (necessary when only one transition happended)
% Task        (T)    task context (tactile or auditory)
% Choice      (C)    behavioral output (lick left or right)
% Outcome     (O)    correct or error
% Firing Rate (FR)	 response variable

LMVarNames= {'TrialOrder','Task','Choice','Outcome','FR'};

% get variable table, same order as TrialType
LMlabel = {
    'T1' 'C1' 'O1'; % TLC
    'T1' 'C2' 'O2'; % TLE
    'T1' 'C2' 'O1'; % TRC
    'T1' 'C1' 'O2'; % TRE
    'T2' 'C1' 'O1'; % ALC
    'T2' 'C2' 'O2'; % ALE
    'T2' 'C2' 'O1'; % ARC
    'T2' 'C1' 'O2'};% ARE

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
Choice  = categorical(LMVarMatrix(:,2));
Outcome = categorical(LMVarMatrix(:,3));

nUnit = size(PSTHs,1);
lmx = cell(nUnit,1); % initialize

for iU = 1:nUnit
    LinearTbl = table(TrialOrder, Task, Choice, Outcome, FR(:,iU), ...
        'VariableNames', LMVarNames);

    % fit full 3-way model(ANOVA equivalent). 
    % Add one additional variable: TrialOrder (2026)
    lmx{iU} = fitlm(LinearTbl,'FR ~ TrialOrder + Task*Choice*Outcome');

end

end
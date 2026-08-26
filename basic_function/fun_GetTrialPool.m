function [TrialsId, Ntrial] = fun_GetTrialPool(Trials, TrialType, BalanceTrial)

% Select trials for each trial type

% INPUT:
%         Trials:  PSTHs' trial id of each trial type
%      TrialType:  {'TLC','TRC','ALC','ARC'}, arrange trials based on this sequence
%   BalanceTrial:  true or false, if true, # of trials for each trial type is the same

% OUTPUT: 
%       TrialsId: cell(numel(TrialType),1)
%         Ntrial: number of trials in each trial type

% Xia Chen (2026)

TrialsId = cellfun(@(x) intersect(Trials.(x), Trials.StableTrials), TrialType, 'UniformOutput', false);

% compute # of trials from each trial type
Ntrial = cellfun(@numel,TrialsId);

if BalanceTrial % randsample and sort with ascending order
    TrialsId = cellfun(@(x) sort(randsample(x,min(Ntrial))),TrialsId, 'UniformOutput', false);
end


end
function continueTag = func_check_Ntrial(Trials,TrialsThr,TrialType)

[~, Ntrial] = fun_GetTrialPool(Trials, TrialType, 0);
if any(Ntrial<TrialsThr)
    continueTag = 1;
    Typeid = find(Ntrial<TrialsThr);
    disp(['Trial in type ' TrialType{Typeid} '<' num2str(TrialsThr)])
else
    continueTag = 0;
end
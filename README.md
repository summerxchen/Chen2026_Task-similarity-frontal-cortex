# Chen2026_Task-similarity-frontal-cortex
Matlab code used for population activity analyses in the manuscript "Task-similarity dependent reconfiguration of compositional modules and geometry in frontal cortex" by Xia Chen, Xiao Yao, Xinxin Yin, and Zengcai V. Guo (2026).

## Data structure

All the Matlab code in this repository follows the data structure described below.

Each '.mat' file contains the following variables:

- PSTHs: Peri-stimulus time histograms with dimensions units × time × trials.

- TimeA: Time used to calculate the PSTHs. 
TimeA.binsize: binsize to calcualte PSTHs (ms).
TimeA.time: time points aligned to sample onset (s).

- Trials: Trial information and trial-type labels.

- Units: Cell array containing information for each unit (one cell corresponds to one unit). 

function [] = runrapidminer(pathToRapidminer, pathToProcess, processName)
% call rapidminer from matlab, automagically - e.g.: 

% e.g.
%pathToRapidminer = 'C:\Program Files\RapidMiner\RapidMiner Studio\scripts\';
%pathToProcess = 'E:\Dropbox\University\Bachelor_7_2014-SS_BA\01_Bachelorarbeit\06_Parser\testing\';

% some variables
disk = pathToRapidminer(1:2);
rapidminer = 'rapidminer-batch.bat -f';

% system call
call =  ['cd', ' ', '"', pathToRapidminer, '"', ' ', '&&', ' ', disk, rapidminer, ' ', '"', pathToProcess, processName, '"'];
system(call)

end
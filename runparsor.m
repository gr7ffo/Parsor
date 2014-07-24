function [] = runparsor(parsorExe, method, filename, predictionLabel, firstChar, functionName)
% call Parsor from matlab, automagically - e.g.: runparsor('v09_parsor.exe','LR','lr.txt','','X','testfunc')
% for inputs, see inputs.md

% open)
configFile = fopen('input.txt', 'w+');
runFile = fopen('run.bat', 'w+');

% method to use
if strcmp(method, 'LR')
    % method
    fprintf(configFile, '%s\n', '1');
    % filename
    fprintf(configFile, '%s\n', filename);
    % first char of variable
    fprintf(configFile, '%s\n', firstChar);
    % functionname
    fprintf(configFile, '%s\n', functionName);
    % clean
    fprintf(configFile, '%s\n', 'y');
elseif strcmp(method, 'M5P')
    % method
    fprintf(configFile, '%s\n', '2');
    % filename
    fprintf(configFile, '%s\n', filename);
    % first char of variable
    fprintf(configFile, '%s\n', firstChar);
    % prediciton label
    fprintf(configFile, '%s\n', predictionLabel);
    % functionname
    fprintf(configFile, '%s\n', functionName);
    % clean
    fprintf(configFile, '%s\n', 'y');
elseif strcmp(method, 'M5R')
    % method
    fprintf(configFile, '%s\n', '3');
    % filename
    fprintf(configFile, '%s\n', filename);
    % first char of variable
    fprintf(configFile, '%s\n', firstChar);
    % prediciton label
    fprintf(configFile, '%s\n', predictionLabel);
    % functionname
    fprintf(configFile, '%s\n', functionName);
    % clean
    fprintf(configFile, '%s\n', 'y');
else
    % method
    fprintf(configFile, '%s\n', '4');
    % filename
    fprintf(configFile, '%s\n', filename);
    % first char of variable
    fprintf(configFile, '%s\n', firstChar);
    % functionname
    fprintf(configFile, '%s\n', functionName);
    % clean
    fprintf(configFile, '%s\n', 'y');
end

% close
fclose(configFile);

% write runFile
fprintf(runFile, parsorExe);
fprintf(runFile, '<input.txt');
fclose(runFile);

% run system
system 'run.bat'

% delete runfiles
fclose('all');
delete('input.txt');
delete('run.bat');

end

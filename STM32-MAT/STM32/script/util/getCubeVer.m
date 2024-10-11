function CubeVer = getCubeVer()
% getCubeVer to get the version of the STM32CubeMX

try
    %% Prepare script for STM32CubeMX
    scriptFileName = '.getVersionScript';
    scriptFileId = fopen(scriptFileName, 'w');
    fprintf(scriptFileId,'get version\n');
    fprintf(scriptFileId,'exit wait\n');
    fclose(scriptFileId);

    %% Call STM32CubeMX to get its version
    try
        stm32CubeMxPath = getSTM32CubeMxPath();
        stm32CubeMxExe = ['"',char(fullfile(stm32CubeMxPath, 'STM32CubeMX.exe')),'"'];
        clear stm32CubeMxPath;
    catch
        disp('Error (0): default is: 4.20');
        CubeVer = 4.20;
        return;
    end

    [~,result] = startStm32CubeMx([' -q ', scriptFileName], 1);

    %Removing possible [DEBUG], [INFO], [WARN], [TRACE], [ERROR] output of system call
    result = splitlines(result);
    result = regexp(result, '^(?!.*\[(DEBUG|INFO|WARN|TRACE|ERROR)\]).*$', 'match');
    result = result(~cellfun(@isempty, result));
    [numberOfLines, ~] = size(result);

    %% Look for version value
    versionText = '0.0';
    for i = 1 : numberOfLines
        if contains(result{i, 1}, 'get version')
            versionText = result{i + 1, 1};
            break
        end
    end

    %% Compute version as a double with 2 digits
    versionText = regexp(versionText, '\.', 'split');
    versionH = versionText{1,1}(1);
    versionL = versionText{1,1}(2);
    CubeVer = str2double(strcat(versionH, '.', versionL));

    if isempty(CubeVer)
        disp('Error (1): default is: 4.20');
        CubeVer = 4.20;
    end

catch
    disp('Error (2): default is: 4.20');
    CubeVer = 4.20;
end

%% Start STM32CubeMx with command and running mode.
    function [status,result] = startStm32CubeMx(cmd, blockingCaller)
        if(blockingCaller)
            %% Command string to start STM32CubeMx in blocking mode
            startStm32CubeMx_str = ['java -jar ', [stm32CubeMxExe,' ',cmd]];
        else
            %% Background running mode for STM32CubeMX.
            startStm32CubeMx_str = [stm32CubeMxExe,' ',cmd,'&'];
        end
        %disp(['startStm32CubeMx() : ',startStm32CubeMx_str]);
        [status, result] = system(startStm32CubeMx_str);
    end
end

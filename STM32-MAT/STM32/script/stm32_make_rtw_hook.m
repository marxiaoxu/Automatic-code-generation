function stm32_make_rtw_hook(hookMethod,modelName,rtwroot,templateMakefile,buildOpts,buildArgs) %#ok

% stm32_make_rtw_hook to supports build process.


% ERT_MAKE_RTW_HOOK - This is the standard ERT hook file for the RTW build
% process (make_rtw), and implements automatic configuration of the
% models configuration parameters.  When the buildArgs option is specified
% as 'optimized_fixed_point=1' or 'optimized_floating_point=1', the model
% is configured automatically for optimized code generation.
%
% This hook file (i.e., file that implements various RTW callbacks) is
% called by RTW for system target file ert.tlc.  The file leverages
% strategic points of the RTW process. A brief synopsis of the callback
% API is as follows:
%
% ert_make_rtw_hook(hookMethod, modelName, rtwroot, templateMakefile,
%                   buildOpts, buildArgs)
%
% hookMethod:
%   Specifies the stage of the RTW build process.  Possible values are
%   entry, before_tlc, after_tlc, before_make, after_make and exit, etc.
%
% modelName:
%   Name of model.  Valid for all stages.
%
% rtwroot:
%   Reserved.
%
% templateMakefile:
%   Name of template makefile.  Valid for stages 'before_make' and 'exit'.
%
% buildOpts:
%   Valid for stages 'before_make' and 'exit', a MATLAB structure
%   containing fields
%
%   modules:
%     Char array specifying list of generated C files: model.c, model_data.c,
%     etc.
%
%   codeFormat:
%     Char array containing code format: 'RealTime', 'RealTimeMalloc',
%     'Embedded-C', and 'S-Function'
%
%   noninlinedSFcns:
%     Cell array specifying list of non-inlined S-Functions.
%
% buildArgs:
%   Char array containing the argument to make_rtw.  When pressing the build
%   button through the Configuration Parameter Dialog, buildArgs is taken
%   verbatim from whatever follows make_rtw in the make command edit field.
%   From MATLAB, it's whatever is passed into make_rtw.  For example, its
%   'optimized_fixed_point=1' for make_rtw('optimized_fixed_point=1').
%
%   This file implements these buildArgs:
%     optimized_fixed_point=1
%     optimized_floating_point=1
%
% You are encouraged to add other configuration options, and extend the
% various callbacks to fully integrate ERT into your environment.

% Copyright 1996-2018 The MathWorks, Inc.

fprintf('\n### Real-Time Workshop build procedure for method: ''%s''\n',hookMethod);
%fprintf('### modelName: ''%s''\n',modelName);
%fprintf('### gcs      : ''%s''\n',gcs);
%fprintf('### bdroot   : ''%s''\n',bdroot);


persistent SIMULATION_MODE;
% Variable to know if we generate final project by the STM32CubeMX tool.
% Do not download reference, only top model
persistent isToBeDoneByStm32CubeMx;
persistent STM32_ROOT_PATH;
persistent STM32_FULL_ROOT_PATH;
persistent STM32_CUBE_MX_EXE;
persistent IS_VERBOSE;

persistent IOC_INFOS;

verboseMe(['SIMULATION_MODE         : ''',num2str(SIMULATION_MODE),''''],'Discard');
verboseMe(['isToBeDoneByStm32CubeMx : ''',num2str(isToBeDoneByStm32CubeMx),''''],'Discard');
verboseMe(['STM32_ROOT_PATH         : ''',STM32_ROOT_PATH,''''],'Discard');
verboseMe(['STM32_FULL_ROOT_PATH    : ''',STM32_FULL_ROOT_PATH,''''],'Discard');
verboseMe(['IS_VERBOSE              : ''',IS_VERBOSE,''''],'Discard');

switch hookMethod

    case 'error'
        %%
        fprintf('### Real-Time Workshop build procedure for model: ''%s'' aborted due to an error.\n',modelName);

    case 'entry'
        %% Called at start of code generation process (before anything happens.)
        fprintf('\n### Starting Real-Time Workshop build procedure for model: ''%s''\n',modelName);

        if(isempty(STM32_CUBE_MX_EXE))
            try
                stm32CubeMxPath = getSTM32CubeMxPath();
                STM32_CUBE_MX_EXE = ['"',char(fullfile(stm32CubeMxPath, 'STM32CubeMX.exe')),'"'];
                %% Add STM32CubeMx version verification
                cubeVer = getCubeVer();
                updatePrefs('set','stm32CubeMxVersion',cubeVer);
                fprintf('\n### STM32CubeMx version in usage is: %d\n',cubeVer);
                clear cubeVer
                clear stm32CubeMxPath;
            catch ME_stm32CubeMxPath
                STM32_CUBE_MX_EXE = [];
                updatePrefs('set','stm32CubeMxVersion',0);
                throw(ME_stm32CubeMxPath);
            end
        else
            verboseMe(['Using ''',STM32_CUBE_MX_EXE,'''']);
        end

        %% Do not do by default. See before_tlc case
        isToBeDoneByStm32CubeMx = 0;

        %% Verify that product has been installed (i.e: added to Matlab path)
        STM32_ROOT_PATH = updatePrefs('get','stm32RootPath');
        STM32_FULL_ROOT_PATH = updatePrefs('get','stm32FullRootPath');

        %If path has not been added to preferences. Product has not been installed
        if(isempty(STM32_ROOT_PATH) || isempty(STM32_FULL_ROOT_PATH))
            h = errordlg('Add STM32 toolkit repository to Matlab default path.','STM32');
            close(h);
            clear h
            error('Product has not been installed. i.e: Not in Matlab path')
        end

        %% Set environment variable to know windows version 32/64 bits
        ext = mexext();
        if (isempty(getenv('MATLAB_WIN_VER')))
            switch ext
                case 'mexw32'
                    setenv('MATLAB_WIN_VER','win32');
                case 'mexw64'
                    setenv('MATLAB_WIN_VER','win64');
            end
        end
        clear ext
        fprintf('### Windows version: ''%s''\n',getenv('MATLAB_WIN_VER'));

        %% Obtain the model's active configuration set.
        cset = getActiveConfigSet(modelName);

        %% If path of product is not good.
        % Certainly example has been copied from system where product has not been installed at same location.
        productInfo = what(STM32_ROOT_PATH);
        if (isempty(productInfo))
            toolchain = cset.get_param('ToolChain');
            downloadApplication = cset.get_param('DownloadApplication');
            cset.set_param('SystemTargetFile', 'ert.tlc');   % System target file
            switchTarget(cset,'ert.tlc',[]);
            pause(1);
            switchTarget(cset,'stm32.tlc',[]);
            cset.set_param('ToolChain', toolchain);
            cset.set_param('DownloadApplication', downloadApplication);
            clear toolchain
            clear downloadApplication
            h = warndlg(sprintf(['Configuration Parameters > Code Generation > STM32 Options >', ...
                'Installed path is not valid.\n', ...
                'Possible reason: Model has been copied from system where product was not installed at same location.\n', ...
                'Solution: Set Configuration parameters > code Generation >System target file to ert.tlc and click OK button. ', ...
                'Then select stm32.tlc again, click OK button and verify that Installed path is STM32 repository installation path on your system.\n', ...
                'Then save the model.']) ...
                ,modelName,'modal');

            uiwait(h);
            clear h
        end
        clear productInfo;

        %%
        IS_VERBOSE = cset.get_param('RTWVerbose');
        verboseMe(['''RTWVerbose'' is: ''',IS_VERBOSE,'''']);

        %%
        SIMULATION_MODE = cset.get_param('SimulationMode');
        verboseMe(['''SimulationMode'' is: ''',SIMULATION_MODE,'''']);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        isPIL = get_param(modelName,'ModelReferenceXILType');
        if(contains(isPIL,'PIL'))
            SIMULATION_MODE = 'processor-in-the-loop';
            fprintf('### Forcing simulation mode with ''%s'' due to ModelReferenceXILType set to ''%s''\n', SIMULATION_MODE, isPIL);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        fprintf('### Model connectivity is: ''%s''\n', SIMULATION_MODE);
        %%
        if (contains(SIMULATION_MODE,'processor-in-the-loop'))
            %% Reset configuration parameters 'external mode'
            cset.set_param('ExtMode','off');
            %% PIL requested mode
            set_param(modelName,'CreateSILPILBlock','PIL');
            pause(1);
            fprintf('### Create verification block: PIL\n');

        elseif (contains(SIMULATION_MODE,'external'))
            %% External mode requested
            cset.set_param('CreateSILPILBlock','None');
            fprintf('### Create verification block: None (External mode)\n');
            %% Set configuration parameters to external mode
            cset.set_param('ExtMode','on');
            cset.set_param('ExtModeTransport',0);

            %% The name of a MEX-file that implements host-target communication.
            cset.set_param('ExtModeMexFile','ext_serial_win32_comm');


            %% Default com parameters
            verbose = '0'; comPort = '1'; baudRate = '115200'; timeOut = '10';
            extModeParameters = cset.get_param('ExtModeMexArgs');
            params = regexp(extModeParameters,'[, ]*','split');
            if(~isempty(params))
                v = 0;
                c = 0;
                b = 0;
                t = 0;
                [~,nbParams] = size(params);
                for k = 1:nbParams
                    if (~isempty(params{1,k}))
                        if(v == 0)
                            verbose = params{1,k};
                            v = 1;
                        elseif(c == 0)
                            comPort = params{1,k};
                            c = 1;
                        elseif(b == 0)
                            baudRate = params{1,k};
                            b = 1;
                        elseif(t == 0)
                            timeOut = params{1,k};
                            t = 1;
                        end
                    end
                end
            end
            [comPort,baudRate,timeOut] = getExtCOM(comPort, baudRate,timeOut);
            extModeParameters = char([verbose,',',comPort,',',baudRate,',',timeOut]);
            cset.set_param('ExtModeMexArgs',extModeParameters);

            fprintf('### External mode parameters: %s\n',extModeParameters);
            fprintf('### Verbose      : %s\n', verbose);
            fprintf('### Port         : %s\n', comPort);
            fprintf('### Speed        : %s\n', baudRate);
            fprintf('### Data length  : %s\n', '8');
            fprintf('### Parity       : %s\n', 'none');
            fprintf('### Stop bit     : %s\n', '1');
            fprintf('### Flow control : %s\n', 'none');
            fprintf('### Time out     : %s\n', timeOut);

            updatePrefs('set','COMSpeed',baudRate);
            %Tunable parameters
            cset.set_param('DefaultParameterBehavior','Tunable');

        else
            %% Reset configuration parameters 'external mode'
            cset.set_param('ExtMode','off');
            %Inlined function
            cset.set_param('DefaultParameterBehavior','Inlined');
            %NORMAL/SIL (Not PIL) requested mode

            if (contains(SIMULATION_MODE,'Software-in-the-loop'))
                %SIL requested mode
                cset.set_param('CreateSILPILBlock','SIL');
                cset.set_param('GenerateErtSFunction','on');
                fprintf('### Create verification block: SIL\n');
            else
                %other requested mode
                cset.set_param('CreateSILPILBlock','None');
                fprintf('### Create verification block: None\n');
            end
        end
        clear cset;

        %% Register ioc informations in memory if ioc file exists.
        iocFullFileName = ioc_getIocPath();
        if (exist(iocFullFileName,'file') == 2)
            verboseMe(['Found ''',iocFullFileName,''' from Simulink model']);
            IOC_INFOS = ioc_parse(iocFullFileName);
            %% Analyse what Time base source is for SYS
            sysTimer = ioc_isSysUsingTimer(IOC_INFOS);
            if(sysTimer)
                updatePrefs('set','stm32_SYS_Timebase_Source','TIMx');
            else
                updatePrefs('set','stm32_SYS_Timebase_Source','SysTick');
            end
        else
            verboseMe(['The full path of the top-level model of current system: ''',iocFullFileName,'''']);
            verboseMe(['WARNING: No IOC file selected for model: ''',modelName,'''']);
            IOC_INFOS = struct([]);
            updatePrefs('set','stm32_SYS_Timebase_Source','SysTick');
        end

    case 'before_tlc'
        %% Called just prior to invoking TLC Compiler (actual code generation.)

        % Download for topModel only, not for referenced model!
        % Check if this is a referenced model
        mdlReferenceTargetType = get_param(modelName,'ModelReferenceTargetType');
        verboseMe(['''',modelName,'''',' has ModelReferenceTargetType set to: ','''',mdlReferenceTargetType,'''']);

        isTopModel = strcmp(mdlReferenceTargetType,'NONE');

        if (isTopModel)
            % Code that is specific to the top model
            isToBeDoneByStm32CubeMx = 1;
        else
            % Code that is specific to the referenced model
            % In case of PIL, Launcher will handle this.
            isToBeDoneByStm32CubeMx = 0;
        end

        updateTlcCustomizationOfMain(modelName,isTopModel,SIMULATION_MODE)


    case 'after_tlc'
        %% Called just after to invoking TLC Compiler (actual code generation.)

    case 'before_makefilebuilder_make'
        %% Called after code generation is complete for PIL processing

    case 'before_make'
        %% Called after code generation is complete, and just prior to kicking
        % off make process (assuming code generation only is not selected.)

    case 'after_make'
        %%

    case 'exit'
        %%
        fprintf('### Successful completion of Real-Time Workshop build procedure for model: ''%s''\n',modelName);

        %% Simulink
        SIMULINK_INCLUDE_FULL_PATH = fullfile(matlabroot,'simulink','include');

        %% Get current repository
        currentPath = pwd;
        verboseMe(['working in: ',currentPath]);

        % In case the user enabled the checkbox 'Download Application' the
        % project is opened and the application gets downloaded.
        % When PIL request, Launcher do that.

        %%
        mdlOptionDownloadApplication = get_param(modelName,'DownloadApplication');
        mdlOptionGenCodeOnly = get_param(modelName,'GenCodeOnly');

        %% Files that are generated by Simulink, we want to skip since customizing the main() by ourselves.
        RT_MAIN_BASE_FILE_NAMES = {'rt_main','rt_malloc_main','ert_main'};

        %%
        CMSIS_DSP_C_FILE_NAMES = {'arm_cos_f32.c','arm_sin_f32.c'};

        %% By default, nothing is known about ioc file in top model configuration.
        iocBaseName = [];
        mdlIocFileExt = [];
        iocFileName = [];
        cubeMxPrjRoot = [];

        if (...
                strcmp(mdlOptionDownloadApplication,'on') && ...
                strcmp(mdlOptionGenCodeOnly,'off') && ...
                (contains(SIMULATION_MODE,'normal') || contains(SIMULATION_MODE,'external')) && ...
                isToBeDoneByStm32CubeMx == 1)

            %Get ioc file path and name of the Simulink project.
            %Will set the folder where to generate the STM32CubeMx code.It is the created project path.
            mdlIocConf = ioc_getIocPath();
            if (exist(mdlIocConf,'file') == 2)
                iocFullFileName = mdlIocConf;
                verboseMe(['Found ''',iocFullFileName,''' from Simulink model']);
                fprintf('### Parse STM32CubeMX ioc configuration file: ''%s''\n',iocFullFileName);
                %% Set the top path for the project to fill to STM32CubeMX tool
                [cubeMxPrjRoot,iocBaseName,mdlIocFileExt] = fileparts(iocFullFileName);
                iocFileName = strcat(iocBaseName,mdlIocFileExt);

            elseif (exist(mdlIocConf,'dir') == 7)

            end

            %%
            cubeMxPrj = struct(...
                'root',[],...
                'inc',[],...
                'src',[],...
                'mdlInc',[],...
                'mdlSrc',[],...
                'stm32',[],...
                'IDE',[],...
                'iocFileName',[],...
                'iocFullFileName',[],...
                'extSettings',[],...
                'fullFileScript',[]);

            %%
            if (contains(SIMULATION_MODE,'normal'))
                if (isempty(IOC_INFOS))
                    fprintf('### normal mode exit without doing STM32CubeMX project.\n');

                else

                    %%
                    cubeMxPrj.root = cubeMxPrjRoot;
                    cubeMxPrj.mdlSrc = fullfile(cubeMxPrjRoot,modelName,'Src');
                    cubeMxPrj.mdlInc = fullfile(cubeMxPrjRoot,modelName,'Inc');
                    cubeMxPrj.src = fullfile(cubeMxPrjRoot,'Src');
                    cubeMxPrj.inc = fullfile(cubeMxPrjRoot,'Inc');
                    cubeMxPrj.stm32 = lower(char(getpref('STM32','STM32Fam')));
                    cubeMxPrj.IDE = [];
                    cubeMxPrj.iocFileName = [iocBaseName,mdlIocFileExt];
                    cubeMxPrj.iocFullFileName = iocFullFileName;
                    cubeMxPrj.extSettings = fullfile(cubeMxPrjRoot,'.extSettings');
                    cubeMxPrj.fullFileScript = fullfile(cubeMxPrjRoot,'.script');

                    fprintf('### Copy generated files to STM32CubeMX working repository (%s).\n', cubeMxPrj.root);

                    %%
                    try
                        armMathDef = getSTM32CoreType(IOC_INFOS);
                    catch ME_getSTM32CoreType
                        error('stm32_make_rtw_hook(): error with getSTM32CoreType()');
                    end

                    %%
                    try
                        %fprintf('### Copy generated files into STM32CubeMX working repository.\n');
                        %% Copy model files to feed the final STM32CubeMX project.
                        copyModelFiles(modelName,armMathDef,pwd,cubeMxPrj)
                    catch ME_copyModelFiles
                        error('stm32_make_rtw_hook(): error with copyModelFiles()');
                    end

                    %%
                    openProject = updatePrefs('get','openProject');
                    if(isempty(openProject))
                        updatePrefs('set','openProject',1);
                        openProject = 1;
                    end

                    try
                        %% Compute and write script for the STM32CubeMx project.
                        % openProject argument must be 0 or 1 but not empty at all.
                        writeScript([],cubeMxPrj.fullFileScript,cubeMxPrj.iocFullFileName,cubeMxPrj.IDE,[],[],openProject,[]);

                    catch ME_writeScript
                        error('stm32_make_rtw_hook(): error with writeScript()');
                    end


                    %% Start STM32CubeMx
                    fprintf('\n### Open STM32CubeMX for project code generation.\n');

                    %% Start STM32CubeMx in silent mode and in blocking mode
                    status = startStm32CubeMx([' -q ',['"',cubeMxPrj.fullFileScript,'"']],"blockingCaller");

                    %% Go back to current path
                    cd(currentPath);
                    clear currentPath;
                    if status == 0
                        fprintf('### Code generation completed.\n');
                    end

                    STM32_CUBE_MX_EXE = [];
                end

            elseif (contains(SIMULATION_MODE,'external'))
                %Get ioc file path and name, it is the created project path.
                try
                    % The IDE for the STM32CubeMX project.
                    % No IDE to change by default.
                    ide = [];
                    % No CPU frequency to change by default.
                    frequency = [];

                    %STM32CubeMx not opened by default
                    updatePrefs('set','hideIDE',1);

                    %%
                    if(isempty(mdlIocFileExt))
                        fprintf('### WARNING: No IOC file selected for model: ''%s''\n',modelName);
                        iocFileName = [modelName,'.ioc'];
                        %Create ioc file beside model file
                        [cubeMxPrjRoot,~,~] = fileparts(which(bdroot));
                        iocFullFileName = fullfile(cubeMxPrjRoot,iocFileName);

                        %test if ioc file has already been created
                        if(exist(iocFullFileName,'file')~= 2)
                            %Create ioc file with all necessary parameters
                            %Select STM32 process for model (that name is also ioc file name!)
                            STM32MCU_selection(modelName);

                            frequency = updatePrefs('get','ticksPerSecond');

                            %% Select USART + Rx + Tx for external mode
                            getUsartExtMode('');

                            %% Prepare USART features.
                            %Usart = struct('name',[],'speed',[],'data',[],'parity',[],'stop',[],'pinRx',[],'pinTx',[]);
                            usart.name   = char(updatePrefs('get','PIL_USARTName'));
                            usart.speed  = char(updatePrefs('get','COMSpeed'));
                            usart.data   = 'WORDLENGTH_8B';
                            usart.parity = 'PARITY_NONE';
                            usart.stop   = 'STOPBITS_1';
                            usart.pinRx  = char(updatePrefs('get','PIL_USART_Rx'));
                            usart.pinTx  = char(updatePrefs('get','PIL_USART_Tx'));
                            if(usart.name(2) == 'S')
                                usart.mode = 'VM_ASYNC';
                            else
                                usart.mode = 'Asynchronous';
                            end

                            %% toolChain selection
                            hideIDE = getToolchain();
                            %Show IDE?
                            updatePrefs('set','hideIDE',hideIDE);

                            %%
                            ide = computeStm32CubeMxIde();

                            %% Prepare MCU features.
                            mcu.family = char(updatePrefs('get','STM32Fam'));
                            mcu.name = char(updatePrefs('get','STM32FileName'));
                            mcu.userName = char(updatePrefs('get','STM32Name'));
                            mcu.freq = char(updatePrefs('get','ticksPerSecond'));

                            %% Create .ioc init in memory
                            [IOC_INFOS,sIdx,mcuIPNbIdx,mcuPinsNbIdx] = ioc_createDefault(modelName,mcu);

                            %% Add USART
                            [IOC_INFOS,~,~,~] = ioc_addUsart(IOC_INFOS,sIdx,mcuIPNbIdx,mcuPinsNbIdx,usart);

                            %% Write ioc configuration file including project info
                            ioc_write(iocFullFileName,IOC_INFOS);

                        else
                            %Use ioc created file
                            %Select USART + Rx + Tx from ioc created file
                            getUsartExtModeFromIoc(iocFullFileName,modelName);
                            IOC_INFOS = ioc_parse(iocFullFileName);
                        end
                    else
                        % Rename ioc for External Mode usage
                        iocExtModeFileName = [iocBaseName,'_extMode',mdlIocFileExt];
                        iocExtModeFullFileName = fullfile(cubeMxPrjRoot,iocExtModeFileName);
                        if(exist(iocExtModeFullFileName,'file') ~= 2)
                            copyfile(iocFullFileName,iocExtModeFullFileName,'f');
                            verboseMe([iocFullFileName,' -> ',iocExtModeFullFileName,' done']);
                        end
                        %Select USART + Rx + Tx for external mode from ioc or from STM32 capabilities
                        getUsartExtModeFromIoc(iocExtModeFullFileName,modelName);

                        iocFullFileName = iocExtModeFullFileName;
                        verboseMe(['Working on ''',iocFullFileName,'''']);

                        IOC_INFOS = ioc_parse(iocFullFileName);
                    end

                    %% Prepare files for STM32CubeMx generation to come
                    cubeMxPrj.root = cubeMxPrjRoot;
                    cubeMxPrj.mdlSrc = fullfile(cubeMxPrjRoot,modelName,'Src');
                    cubeMxPrj.mdlInc = fullfile(cubeMxPrjRoot,modelName,'Inc');
                    cubeMxPrj.src = fullfile(cubeMxPrjRoot,'Src');
                    cubeMxPrj.inc = fullfile(cubeMxPrjRoot,'Inc');
                    cubeMxPrj.stm32 = lower(char(updatePrefs('get','STM32Fam')));
                    cubeMxPrj.IDE = ide;
                    cubeMxPrj.extSettings = fullfile(cubeMxPrjRoot,'.extSettings');
                    cubeMxPrj.iocFullFileName = iocFullFileName;
                    cubeMxPrj.extSettings = fullfile(cubeMxPrjRoot,'.extSettings');
                    cubeMxPrj.fullFileScript1 = fullfile(cubeMxPrjRoot,'.script1');
                    cubeMxPrj.fullFileScript2 = [];
                    cubeMxPrj.fullFileScript3 = fullfile(cubeMxPrjRoot,'.script3');

                catch ME_createIocForExternalMode
                    error('stm32_make_rtw_hook(): error with External mode settings for STM32CubeMx project');
                end

                try
                    armMathDef = getSTM32CoreType(IOC_INFOS);
                catch ME_armMathDef
                    error('stm32_make_rtw_hook(): error with getSTM32CoreType()');
                end

                try
                    fprintf('### Copy generated files into STM32CubeMX working repository.\n');
                    copyModelFiles2(modelName,armMathDef,pwd,cubeMxPrj)
                catch ME_copyModelFiles2
                    error('stm32_make_rtw_hook(): error with copyModelFiles2()');
                end

                %%
                fprintf('### Parse STM32CubeMX ioc configuration file: ''%s''\n',iocFullFileName);
                ioc_write_toDo = 0;

                %%iocInfos = ioc_parse(iocFullFileName);
                [~,iocInfosIdx] = size(IOC_INFOS);
                projectFileName = ioc_getInfo(IOC_INFOS,'ProjectManager','ProjectFileName','');

                if(isempty(projectFileName))
                    ioc_write_toDo = 1;
                    iocInfosIdx = iocInfosIdx + 1;
                    IOC_INFOS(iocInfosIdx).name{1,1} = 'ProjectManager';
                    IOC_INFOS(iocInfosIdx).field{1} = 'ProjectFileName';
                    IOC_INFOS(iocInfosIdx).value{1,1} = iocFileName;
                    IOC_INFOS(iocInfosIdx).nbField = 1;

                elseif(~strcmp(char(projectFileName.value),char(iocFileName)))
                    ioc_write_toDo = 1;
                    projectFileName.value = iocFileName;
                end

                %Write ioc configuration file including project info
                if(ioc_write_toDo == 1)
                    ioc_write(iocFullFileName,IOC_INFOS);
                end


                %%
                heapSize = ioc_getInfo(IOC_INFOS,'ProjectManager','HeapSize','');

                if(~isempty(heapSize))
                    heapSizeValue = char(heapSize.value);
                    if (contains(heapSizeValue,'0x') || contains(heapSizeValue,'0X'))
                        heapSizeValue = heapSizeValue(3:end);
                        setpref('STM32','heapSize',hex2dec(char(heapSizeValue)));
                    else
                        setpref('STM32','heapSize',str2double(char(heapSizeValue)));
                    end
                end

                %% Create .script file in same repository as ioc file.
                openProject = updatePrefs('get','openProject');
                if(isempty(openProject))
                    updatePrefs('set','openProject',1);
                end

                try
                    heapSize = updatePrefs('get','heapSize');
                    writeScript(modelName,cubeMxPrj.fullFileScript1,cubeMxPrj.iocFullFileName,cubeMxPrj.IDE,[],heapSize,[],"saveProject");
                    if(~isempty(cubeMxPrj.IDE))
                        fprintf('### The toolchain for the target: ''%s''\n',cubeMxPrj.IDE);
                    end

                    if(~isempty(frequency))
                        cubeMxPrj.fullFileScript2 = fullfile(cubeMxPrjRoot,'.script2');
                        writeScript([],cubeMxPrj.fullFileScript2,cubeMxPrj.iocFullFileName,[],frequency,[],[],"saveProject");
                    end

                    hideIDE = updatePrefs('get','hideIDE');
                    writeScript([],cubeMxPrj.fullFileScript3,cubeMxPrj.iocFullFileName,[],[],[],hideIDE,[]);

                catch ME_writeScript
                    error(['stm32_make_rtw_hook(): Can not create file : ',to.fullFileScript]);
                end

                % Run first script for setting name of project, the toolchain, the heapsize
                startStm32CubeMx([' -q ',['"',cubeMxPrj.fullFileScript1,'"']],"blockingCaller");

                % Run second script for setting CPU frequency (if changed)
                if(~isempty(cubeMxPrj.fullFileScript2))
                    startStm32CubeMx([' -q ',['"',cubeMxPrj.fullFileScript2,'"']],"blockingCaller");
                end

                %% Start STM32CubeMX IDE in blocking mode
                fprintf('\n### Open STM32CubeMX for configuration and project code generation.\n');
                if(hideIDE)
                    status = startStm32CubeMx([' -q ',['"',cubeMxPrj.fullFileScript3,'"']],"blockingCaller");
                else
                    status = startStm32CubeMx([' -s ',['"',cubeMxPrj.fullFileScript3,'"']],"blockingCaller");
                end

                %% Go back to current path
                cd(currentPath);
                clear currentPath
                if status == 0
                    fprintf('### External mode downloaded command successfully fired.\n');
                end
                STM32_CUBE_MX_EXE = [];
            end

        else
            if strcmp(mdlOptionDownloadApplication,'off')
                fprintf('\n### WARNING STM32 Options with Download Application set to ''%s''\n', mdlOptionDownloadApplication);
            end
            if strcmp(mdlOptionGenCodeOnly,'on')
                fprintf('\n### WARNING Build process with Generate code only set to ''%s''\n', mdlOptionGenCodeOnly);
            end
            %%verboseMe(['isToBeDoneByStm32CubeMx is set to: ''',num2str(isToBeDoneByStm32CubeMx),'''']);
        end
end




%% Compute and write extSettings file for STM32CubeMx
% Load buildInfo and extract list of .c/.h files and includes path
    function copyModelFiles(modelName,armMathDef,from,to)
        verboseMe(['copyModelFiles(',modelName,',',armMathDef,',',from,',',to.root,')']);
        %% Find all buildInfo.mat files
        try
            nBuildInfoMatFullFileName = which('buildInfo.mat');
            [nBuildInfoMatPath, ~, ~] = fileparts(nBuildInfoMatFullFileName);
            verboseMe(['copyModelFiles(): Loading build informations from: ',nBuildInfoMatFullFileName]);
            %Get informations of the model that has been generated.
            load(nBuildInfoMatFullFileName, 'buildInfo');

        catch ME_buildInfo
            throw(ME_buildInfo);
        end
        clear nBuildInfoMatFullFileName;

        mkdir(to.mdlSrc);
        mkdir(to.mdlInc);
        %Also build dir Src and Inc beside ioc file to copy main.c and stm32xxxx_it.c into Src
        mkdir(to.src);
        mkdir(to.inc);

        nBuildInfoCFiles = getFullFileList(buildInfo,'source');
        nBuildInfoHFiles = getFullFileList(buildInfo,'include');
        nBuildInfoPaths  = getIncludePaths(buildInfo,'true');


        %% Do unique in list
        nBuildInfoCFiles = uniqueOnCells(nBuildInfoCFiles);
        nBuildInfoHFiles = uniqueOnCells(nBuildInfoHFiles);
        nBuildInfoPaths  = uniqueOnCells(nBuildInfoPaths);

        %% Include external functions
        nMdlIncPaths = getIncPathListForProject(modelName,0); %Full path for include files

        nMdlExtFunctionFullFileName = fullfile(to.mdlInc,[modelName,'_External_Functions.h']);
        [nMdlExtFunctionFileId,nErrMsg] = fopen(nMdlExtFunctionFullFileName, 'w');
        if ~isempty(nErrMsg)
            error([nMdlExtFunctionFullFileName,' : --->',nErrMsg]);
        end

        fprintf(nMdlExtFunctionFileId,'/***** External Imported Functions *****/\n');
        if ~isempty(nMdlIncPaths)
            for nHFile = nMdlIncPaths
                [~,nFileBaseName,~] = fileparts(char(nHFile));
                fprintf(nMdlExtFunctionFileId,'#include "%s.h"\n',char(nFileBaseName));
            end
        end
        fclose(nMdlExtFunctionFileId);

        %% Create .extSettings file in same repository as ioc file.
        try
            verboseMe(['copyModelFiles(): Trying: ', to.extSettings]);
            [nExtSettingsFileId,nErrMsg] = fopen(to.extSettings, 'w');
            if ~isempty(nErrMsg)
                error([to.extSettings,' : --->',nErrMsg]);
            end
            fprintf(nExtSettingsFileId,'[ProjectFiles]\n');

            %% Process H include paths
            nArmCoreIncludeFullPathName = fullfile(to.root,'Drivers','CMSIS','Core','Include');
            nArmDSPIncludeFullPathName  = fullfile(to.root,'Drivers','CMSIS','DSP','Include');

            fprintf(nExtSettingsFileId,'HeaderPath=%s;',nArmCoreIncludeFullPathName);
            fprintf(nExtSettingsFileId,'%s;',nArmDSPIncludeFullPathName);
            fprintf(nExtSettingsFileId,'%s;',to.mdlInc);
            fprintf(nExtSettingsFileId,'%s;',SIMULINK_INCLUDE_FULL_PATH);

            nMdlIncPaths = getIncPathListForProject(modelName,0);
            if ~isempty(nMdlIncPaths)
                for nHFile = nMdlIncPaths
                    [nFilePath,~,~] = fileparts(char(nHFile));
                    fprintf(nExtSettingsFileId,'%s;',char(nFilePath));
                    verboseMe(['copyModelFiles(): ',char(nFilePath),' added to ',to.extSettings,' done']);
                end
            end

            %% Process C source files : copy to src and add to project!
            fprintf(nExtSettingsFileId,'\n[Groups]');
            fprintf(nExtSettingsFileId,'\nMATLAB=');

            %% Add selected source files
            nMdlCFiles = getCfileListForProject(modelName,0); %Full path for external c files
            if ~isempty(nMdlCFiles)
                for nCFile = nMdlCFiles
                    [nFilePath,nFileBaseName,nFileExt] = fileparts(char(nCFile));
                    fprintf(nExtSettingsFileId,'%s;',char(fullfile(nFilePath,[nFileBaseName,nFileExt])));
                    verboseMe(['copyModelFiles(): ',char(nCFile),' added to ',to.extSettings,' done']);
                end
            end

            for nCFile = nBuildInfoCFiles
                [nFilePath,nFileBaseName,nFileExt] = fileparts(char(nCFile));
                if(isempty(nFilePath))
                    if(any(strcmp(char(nCFile),CMSIS_DSP_C_FILE_NAMES)))
                        %Do not copy this file => extFile = '.dummy'
                        nFileExt = '.dummy';
                        %File has to be included to project
                        nCFullFileName = fullfile(to.root,'Drivers','CMSIS','DSP','Source','FastMathFunctions',char(nCFile));
                        fprintf(nExtSettingsFileId,'%s;',nCFullFileName);
                        verboseMe(['copyModelFiles(): ',char(nCFile),' added to ',to.extSettings,' done']);
                        nCFullFileName = fullfile(to.root,'Drivers','CMSIS','DSP','Source','CommonTables','arm_common_tables.c');
                        fprintf(nExtSettingsFileId,'%s;',nCFullFileName);
                        verboseMe(['copyModelFiles(): ','arm_common_tables.c',' added to ',to.extSettings,' done']);
                        nPrjCFile = '';
                    else
                        nListOfFiles = which(char(nCFile),'-all');
                        %First file found is default result
                        [nFilePath, nFileBaseName, nFileExt] = fileparts(char(nListOfFiles(1)));
                        nPrjCFile = fullfile(nFilePath,nCFile);
                        nNbFiles = size(nListOfFiles);
                        if nNbFiles(1) > 1
                            %But file provided by toolbox is preferred
                            for nFileFoundIndex = 1:nNbFiles(1)
                                [nFilePath, nFileBaseName, nFileExt] = fileparts(char(nListOfFiles(nFileFoundIndex)));
                                if contains(nFilePath,STM32_FULL_ROOT_PATH)
                                    nPrjCFile = fullfile(nFilePath,nCFile);
                                    break;
                                end
                            end
                        end
                    end
                else
                    nPrjCFile = nCFile;
                end

                if(strcmp(nFileExt,'.c'))
                    if(any(strcmp(nFileBaseName,RT_MAIN_BASE_FILE_NAMES)))
                        %skip this file
                        verboseMe(['copyModelFiles(): Skipping ',nFileBaseName,nFileExt]);

                    elseif(strcmp(nFileBaseName,'stm32xxxx_it'))
                        %Check if stm32xxxx_it.c file exists and needs to be copied for the family in usage
                        if(strcmp(nBuildInfoMatPath,nFilePath))
                            %Compute file name of possible interrupt file for the family in usage
                            nStm32xxxx_it_file = strcat(to.stm32,'xx_it');
                            nCFullFileName = fullfile(to.src,[nStm32xxxx_it_file,nFileExt]);
                            copyfile(char(nPrjCFile),nCFullFileName,'f');
                            verboseMe(['copyModelFiles(): ',char(nPrjCFile),' -> ',nCFullFileName,' done']);
                        end

                    elseif(~strcmp(nFileBaseName,'main'))
                        % Relocated the file in the .extSettings accordingly
                        nCFullFileName = fullfile(to.mdlSrc,[nFileBaseName,nFileExt]);
                        fprintf(nExtSettingsFileId,'%s;',nCFullFileName);
                        %Copy source files
                        copyfile(char(nPrjCFile),nCFullFileName,'f');
                        verboseMe(['copyModelFiles(): ',char(nPrjCFile),' -> ',nCFullFileName,' done']);

                    elseif(strcmp(nFileBaseName,'main'))
                        if strcmp(nBuildInfoMatPath,nFilePath)
                            nCFullFileName = fullfile(to.src,[nFileBaseName,nFileExt]);
                            %main.c is copied into Src if it doesn't exist or overwriteMain preference is set to 1
                            nOverwriteMain = updatePrefs('get','overwriteMain');
                            nMainExist = exist(nCFullFileName,'file');

                            if(nMainExist == 0)
                                %main.c doesn't exist ---> copy it
                                copyfile(char(nPrjCFile),nCFullFileName,'f');
                                verboseMe(['copyModelFiles(): ',char(nPrjCFile),' -> ',nCFullFileName,' done (that did not exist)']);

                            elseif(nOverwriteMain == 1)
                                %overwriteMain preference is set ---> overwrite main.c
                                copyfile(char(nPrjCFile),nCFullFileName,'f');
                                verboseMe(['copyModelFiles(): ',char(nPrjCFile),' -> ',nCFullFileName,' done']);

                            elseif(nOverwriteMain == 0)
                                fprintf(['### overwriteMain preference is 0. Simulink will not provide main.c file. (no overwritten) ',...
                                    'Enter updatePrefs(', '''' , 'set', ''',', '''', 'overwriteMain', ''',', '1); ' ...
                                    'in MATLAB command window to enable use of main.c file coming from Simulink.\n']);

                            elseif(isempty(nOverwriteMain))
                                updatePrefs('set','overwriteMain',1);
                                nH = warndlg(sprintf(['%s\\main.c\n', ...
                                    'will be overwritten.\n', ...
                                    'If you have modified it and do not want to use Simulink provided one.\n', ...
                                    'You must save it before to click OK.\n', ...
                                    'Enter updatePrefs(''set'' , ''overwriteMain'' , 0); in MATLAB command window to disable use of main.c file coming from Simulink.'] ...
                                    ,to.src) ...
                                    ,modelName,'modal');
                                uiwait(nH);
                                clear nH;
                                nOverwriteMain = updatePrefs('get','overwriteMain');
                                if(nOverwriteMain == 1)
                                    %overwriteMain preference is set ---> overwrite main.c
                                    copyfile(char(nPrjCFile),nCFullFileName,'f');
                                    verboseMe(['copyModelFiles(): ',char(nPrjCFile),' -> ',nCFullFileName,' done']);
                                end
                            end
                        end
                    end
                end
            end


            %% Define section
            fprintf(nExtSettingsFileId,'\n[Others]\n');
            nOthersContent='Define=MEM_UNIT_BYTES;%s;MemUnit_T:uint8_T;MATLAB_PROJECT;\n';
            fprintf(nExtSettingsFileId,nOthersContent,char(armMathDef));
            fclose(nExtSettingsFileId);
            clear extSettingsFileId;

        catch ME_extSettings
            fclose(nExtSettingsFileId);
            error(['copyModelFiles(): Can not create file : ',to.extSettings]);
        end


        %Copy .h file included in _sharedutils repository
        for nPathName = nBuildInfoPaths
            if(contains(char(nPathName),'_sharedutils'))
                nFoundPath = regexp(char(nPathName),'_sharedutils','split');
                nHFullFileName = fullfile(char(nFoundPath(1)),'_sharedutils','*.h');
                copyfile(nHFullFileName,to.mdlInc,'f');
                verboseMe(['copyModelFiles(): ',nHFullFileName,' -> ',to.mdlInc,' done']);
                break;
            end
        end

        %Copy .h included files
        for nHFile = nBuildInfoHFiles
            [nFilePath,nFileBaseName,nFileExt] = fileparts(char(nHFile));
            if(isempty(nFilePath))
                if(exist(fullfile(to.mdlInc,char(nHFile)),'file') == 0)
                    %Files not already copied
                    for nPathName = nBuildInfoPaths
                        nFileH2Found = fullfile(char(nPathName),char(nHFile));
                        if(exist(nFileH2Found,'file') == 2)
                            nHFullFileName = fullfile(to.mdlInc,char(nHFile));
                            copyfile(nFileH2Found,nHFullFileName,'f');
                            verboseMe(['copyModelFiles(): ',nFileH2Found,' -> ',nHFullFileName,' done']);
                            break;
                        else
                            if (contains(char(nHFile),'arm_math'))
                                nStm32FirmwarePackage = updatePrefs('get','CustomerFirmwarePackage');
                                verboseMe(['copyModelFiles(): using ''',nStm32FirmwarePackage,'''',' from STM32 preferences']);

                                % If arm_math.h file => library modification to add include of STM32_Config.h
                                if(isempty(nStm32FirmwarePackage))
                                    fprintf('### Sources of STM32 Firmware package is not defined.\n');
                                else
                                    nArmMathHFullFileName = fullfile(nStm32FirmwarePackage,'Drivers','CMSIS','DSP','Include','arm_math.h');
                                    [nArmMathFilePath,nArmMathBaseName,nArmMathFileExt] = fileparts(char(nArmMathHFullFileName));
                                    nArmMath_REF_HFullFileName = fullfile(nArmMathFilePath,[nArmMathBaseName,'_REF',nArmMathFileExt]);
                                    % Process to do if arm_math_REF.h
                                    % doesn't exist
                                    if(exist(nArmMath_REF_HFullFileName,'file') == 0)
                                        % Save arm_math.h to arm_math_REF.h
                                        copyfile(nArmMathHFullFileName,nArmMath_REF_HFullFileName);
                                        nArmMathHFileId = fopen(nArmMathHFullFileName,'w+');
                                        if nArmMathHFileId == -1
                                            fprintf('### Unable to open file %s file to include STM32_Config.h\n', char(nArmMathHFullFileName));
                                        else
                                            % arm_math.h will be modified
                                            nArmMath_REF_H_FileId = fopen(nArmMath_REF_HFullFileName, 'r');
                                            if nArmMath_REF_H_FileId == -1
                                                fprintf('### Unable to open file %s file to read\n',char(nArmMath_REF_HFullFileName));
                                                fclose(nArmMathHFileId);
                                            else
                                                nTline = fgets(nArmMath_REF_H_FileId);
                                                while ischar(nTline)
                                                    if contains(nTline,'#define __CMSIS_GENERIC')
                                                        fwrite(nArmMathHFileId, ...
                                                            ['#if defined(MATLAB_PROJECT)',newline(), ...
                                                            '#include "STM32_Config.h"',newline(), ...
                                                            '#endif',newline()]);
                                                    end
                                                    fwrite(nArmMathHFileId,nTline);
                                                    nTline = fgets(nArmMath_REF_H_FileId);
                                                end
                                                fclose(nArmMathHFileId);
                                                fclose(nArmMath_REF_H_FileId);
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                nHFullFileName = fullfile(to.mdlInc,[nFileBaseName,nFileExt]);
                %Copy Header files
                copyfile(char(nHFile),nHFullFileName,'f');
                verboseMe(['copyModelFiles(): ',char(nHFile),' -> ',nHFullFileName,' done']);
            end
        end
    end



%% Compute and write extSettings file for STM32CubeMx
% Load build info and extract list of c/h files and includes path
% Load all buildInfo found and extract .c/.h files
    function copyModelFiles2(modelName,armMathDef,from,to)
        verboseMe(['copyModelFiles2(',modelName,',',armMathDef,',',from,',',to.root,')']);

        try
            nBuildInfoMatFullFileName = which('buildInfo.mat');
            [nBuildInfoMatPath,~,~] = fileparts(nBuildInfoMatFullFileName);
            verboseMe(['copyModelFiles2(): Loading build informations from: ',nBuildInfoMatFullFileName]);
            %Get informations of the model that has been generated.
            load(nBuildInfoMatFullFileName,'buildInfo');

        catch ME_buildInfo
            throw(ME_buildInfo);
        end
        clear nBuildInfoMatFullFileName;

        mkdir(to.mdlSrc);
        mkdir(to.mdlInc);
        %Also build dir Src and Inc beside ioc file to copy main.c and stm32xxxx_it.c into Src
        mkdir(to.src);
        mkdir(to.inc);

        %% Create RTIOSTREAM for External Mode
        %Add rtiostream files to build information
        nRtiostreamSrcFullPath = fullfile(STM32_ROOT_PATH,'ext','stm32SerialRtiostream');
        buildInfo.addIncludePaths(nRtiostreamSrcFullPath);
        buildInfo.addSourcePaths(nRtiostreamSrcFullPath);
        buildInfo.addSourceFiles('STM32SerialRtiostream.c',nRtiostreamSrcFullPath);
        buildInfo.addIncludeFiles('STM32SerialRtiostream.h',nRtiostreamSrcFullPath);

        %% Add path to MATLAB needed files
        nIncExtModePaths = [ ...
            fullfile(matlabroot,'extern','include'),';', ...
            SIMULINK_INCLUDE_FULL_PATH,';', ...
            fullfile(matlabroot,'rtw','c','src'),';', ...
            fullfile(matlabroot,'rtw','c','src','ext_mode','common'),';', ...
            fullfile(matlabroot,'rtw','c','ert'),';', ...
            fullfile(matlabroot,'toolbox','coder','rtiostream','src'),';', ...
            fullfile(matlabroot,'toolbox','coder','rtiostream','src','utils'),';', ...
            fullfile(matlabroot,'rtw','c','src','ext_mode','serial'),';'];

        %% Extract source files name and path information from build
        nBuildInfoCFiles = getFullFileList(buildInfo,'source');
        %Create SRC and INC repository
        nBuildInfoPaths = getIncludePaths(buildInfo,'true');
        nBuildInfoHFiles = getFullFileList(buildInfo,'include');

        %% Do unique in list
        nBuildInfoCFiles = uniqueOnCells(nBuildInfoCFiles);
        nBuildInfoHFiles = uniqueOnCells(nBuildInfoHFiles);
        nBuildInfoPaths  = uniqueOnCells(nBuildInfoPaths);

        %% include external functions
        nMdlIncPaths = getIncPathListForProject(modelName,0); %Full path for include files
        if ~isempty(nMdlIncPaths)
            nMdlExtFunctionFileName = fullfile(to.mdlInc,[modelName,'_External_Functions.h']);
            [nMdlExtFunctionFileId,nErrMsg] = fopen(nMdlExtFunctionFileName,'w');
            if ~isempty(nErrMsg)
                error([nMdlExtFunctionFileName,' : --->',nErrMsg]);
            end
            fprintf(nMdlExtFunctionFileId,'/***** External Imported Functions *****/\n');
            for nCFile = nMdlIncPaths
                [~, nFileBaseName, ~] = fileparts(char(nCFile));
                fprintf(nMdlExtFunctionFileId,'#include "%s.h"\n',char(nFileBaseName));
            end
            fclose(nMdlExtFunctionFileId);
        end

        %% Build .h file with chosen USART parameters.
        PIL_USARTName = char(updatePrefs('get','PIL_USARTName'));
        writeStm32SerialRtiostreamConfigHFile(modelName,to.mdlInc,to.stm32,PIL_USARTName);

        %% Create .extSettings file in same repository as ioc file.
        try
            verboseMe(['copyModelFiles2(): Trying: ',to.extSettings]);

            [nExtSettingsFileId,nErrMsg] = fopen(to.extSettings,'w');
            if ~isempty(nErrMsg)
                error([to.extSettings,' : --->',nErrMsg]);
            end
            fprintf(nExtSettingsFileId,'[ProjectFiles]\n');
            %All include files will be copied to IncPath
            fprintf(nExtSettingsFileId,'HeaderPath=%s;%s',to.mdlInc,nIncExtModePaths);
            nMdlIncPaths = getIncPathListForProject(modelName,0);
            if ~isempty(nMdlIncPaths)
                for nCFile = nMdlIncPaths
                    [nFilePath,~,~] = fileparts(char(nCFile));
                    fprintf(nExtSettingsFileId,'%s;',char(nFilePath));
                    verboseMe(['copyModelFiles2(): ',char(nFilePath),' added to ',to.extSettings,' done']);
                end
            end
            fprintf(nExtSettingsFileId,'\n[Groups]');
            fprintf(nExtSettingsFileId,'\nMATLAB=');

            nMdlCFiles = getCfileListForProject(modelName,0); %Full path for external c files
            if ~isempty(nMdlCFiles)
                for nCFile = nMdlCFiles
                    [nFilePath,nFileBaseName,nFileExt] = fileparts(char(nCFile));
                    fprintf(nExtSettingsFileId,'%s/%s%s;',char(nFilePath),char(nFileBaseName),char(nFileExt));
                    verboseMe(['copyModelFiles2(): ',char(nFilePath),char(nFileBaseName),char(nFileExt),' added to ',to.extSettings,' done']);
                end
            end

            %% Process C files
            for nCFile = nBuildInfoCFiles
                [nFilePath,nFileBaseName,nFileExt] = fileparts(char(nCFile));
                if(isempty(nFilePath))
                    if(any(strcmp(char(nCFile),CMSIS_DSP_C_FILE_NAMES)))
                        %Do not copy this file => extFile = '.dummy'
                        nFileExt = '.dummy';
                        %File has to be included to project
                        nCFullFileName = fullfile(to.root,'Drivers','CMSIS','DSP','Source','FastMathFunctions',char(nCFile));
                        fprintf(nExtSettingsFileId,'%s;',nCFullFileName);
                        verboseMe(['copyModelFiles2(): ',char(nCFile),' added to ',to.extSettings,' done']);
                        nCFullFileName = fullfile(to.root,'Drivers','CMSIS','DSP','Source','CommonTables','arm_common_tables.c');
                        fprintf(nExtSettingsFileId,'%s;',nCFullFileName);
                        verboseMe(['copyModelFiles2(): ','arm_common_tables.c',' added to ',to.extSettings,' done']);
                        nPrjCFile = '';
                    else
                        nListOfFiles = which(char(nCFile),'-all');
                        %First file found is default result
                        [nFilePath,nFileBaseName,nFileExt] = fileparts(char(nListOfFiles(1)));
                        nPrjCFile = fullfile(nFilePath,nCFile);
                        nNbFiles = size(nListOfFiles);
                        if nNbFiles(1) > 1
                            %But file provided by toolbox is preferred
                            for nFileFoundIndex = 1:nNbFiles(1)
                                [nFilePath,nFileBaseName,nFileExt] = fileparts(char(nListOfFiles(nFileFoundIndex)));
                                if contains(nFilePath,STM32_FULL_ROOT_PATH)
                                    nPrjCFile = fullfile(nFilePath,nCFile);
                                    break;
                                end
                            end
                        end
                    end
                else
                    nPrjCFile = nCFile;
                end

                %%
                if(strcmp(nFileExt,'.c'))
                    if(any(strcmp(nFileBaseName,RT_MAIN_BASE_FILE_NAMES)))
                        %skip this file
                        verboseMe(['copyModelFiles2(): Skipping ',nFileBaseName,nFileExt]);

                    elseif(strcmp(nFileBaseName,'stm32xxxx_it'))
                        %Check if stm32xxxx_it.c file exists and needs to be copied for the family in usage
                        if(strcmp(nBuildInfoMatPath,nFilePath))
                            %Compute file name of possible interrupt file for the family in usage
                            nStm32xxxx_it_file = strcat(to.stm32,'xx_it');
                            nCFullFileName = fullfile(to.src,[nStm32xxxx_it_file,nFileExt]);
                            copyfile(char(nPrjCFile),nCFullFileName,'f');
                            verboseMe(['copyModelFiles2(): ',char(nPrjCFile),' -> ',nCFullFileName,' done']);
                        end

                    elseif(isequal(strcmp(nFileBaseName,'main'),0))
                        % Relocated the file in the .extSettings accordingly
                        nCFullFileName = fullfile(to.mdlSrc,[nFileBaseName,nFileExt]);
                        fprintf(nExtSettingsFileId,'%s;',nCFullFileName);
                        %Copy source files
                        copyfile(char(nPrjCFile),nCFullFileName,'f');
                        verboseMe(['copyModelFiles2(): ',char(nPrjCFile),' -> ',nCFullFileName,' done']);

                    elseif(strcmp(nFileBaseName,'main'))
                        if(strcmp(nBuildInfoMatPath,nFilePath))
                            nCFullFileName = fullfile(to.src,[nFileBaseName,nFileExt]);
                            %main.c is copied into Src if it doesn't exist or overwriteMain preference is set to 1
                            nOverwriteMain = updatePrefs('get','overwriteMain');
                            nMainExist = exist(nCFullFileName,'file');

                            if(nMainExist == 0)
                                %main.c doesn't exist ---> copy it
                                copyfile(char(nPrjCFile),nCFullFileName,'f');
                                verboseMe(['copyModelFiles2(): ',char(nPrjCFile),' -> ',nCFullFileName,' done']);

                            elseif(nOverwriteMain == 1)
                                %overwriteMain preference is set ---> overwrite main.c
                                copyfile(char(nPrjCFile),nCFullFileName,'f');
                                verboseMe(['copyModelFiles2(): ',char(nPrjCFile),' -> ',nCFullFileName,' done']);

                            elseif(nOverwriteMain == 0)
                                fprintf(['### overwriteMain preference is 0. Simulink will not provide main.c file. (no overwritten) ',...
                                    'Enter updatePrefs(', '''' , 'set', ''',', '''', 'overwriteMain', ''',', '1); ' ...
                                    'in MATLAB command window to enable use of main.c file coming from Simulink.\n']);

                            elseif(isempty(nOverwriteMain))
                                updatePrefs('set','overwriteMain',1);
                                nH = warndlg(sprintf(['%s\\main.c\n', ...
                                    'will be overwritten.\n', ...
                                    'If you have modified it and do not want to use Simulink provided one.\n', ...
                                    'You must save it before to click OK.\n', ...
                                    'Enter updatePrefs(''set'' , ''overwriteMain'' , 0); in MATLAB command window to disable use of main.c file coming from Simulink.'] ...
                                    ,to.src)...
                                    ,modelName,'modal');
                                uiwait(nH);
                                clear nH
                                nOverwriteMain = updatePrefs('get','overwriteMain');
                                if(nOverwriteMain == 1)
                                    %overwriteMain preference is set ---> overwrite main.c
                                    copyfile(char(nPrjCFile),nCFullFileName,'f');
                                    verboseMe(['copyModelFiles2(): ',char(nPrjCFile),' -> ',nCFullFileName,' done']);
                                end
                            end
                        end
                    end
                end
            end

            %Add to sources files for External Mode only
            nPrjCFile = fullfile(matlabroot,'rtw','c','src','ext_mode','serial','ext_serial_pkt.c');
            [~, nFileBaseName, nFileExt] = fileparts(nPrjCFile);
            nCFullFileName = fullfile(to.mdlSrc,[nFileBaseName,nFileExt]);
            copyfile(char(nPrjCFile),nCFullFileName,'f');
            fprintf(nExtSettingsFileId,'%s;',nCFullFileName);

            nPrjCFile = fullfile(matlabroot,'rtw','c','src','ext_mode','serial','rtiostream_serial_interface.c');
            [~, nFileBaseName, nFileExt] = fileparts(nPrjCFile);
            nCFullFileName = fullfile(to.mdlSrc,[nFileBaseName,nFileExt]);
            copyfile(char(nPrjCFile),nCFullFileName,'f');
            fprintf(nExtSettingsFileId,'%s;',nCFullFileName);

            nPrjCFile = fullfile(matlabroot,'rtw','c','src','ext_mode','serial','ext_svr_serial_transport.c');
            [~, nFileBaseName, nFileExt] = fileparts(nPrjCFile);
            nCFullFileName = fullfile(to.mdlSrc,[nFileBaseName,nFileExt]);
            copyfile(char(nPrjCFile),nCFullFileName,'f');
            fprintf(nExtSettingsFileId,'%s;',nCFullFileName);

            %Define section
            fprintf(nExtSettingsFileId,'\n[Others]\n');
            fprintf(nExtSettingsFileId,'Define=MEM_UNIT_BYTES;%s;MemUnit_T:uint8_T;MATLAB_PROJECT;EXT_MODE:1;EXTMODE_DISABLEPRINTF;EXTMODE_DISABLETESTING;EXTMODE_DISABLE_ARGS_PROCESSING:1\n',char(armMathDef));
            %Close files description project file
            fclose(nExtSettingsFileId);

        catch ME_extSettings
            fclose(nExtSettingsFileId);
            error(['copyModelFiles2(): Can not create file : ',to.extSettings]);
        end


        %% Process H files : Copy to Inc path
        %Copy .h file included in _sharedutils repository
        for nPathName = nBuildInfoPaths
            if(contains(char(nPathName), '_sharedutils'))
                nFoundPath = regexp(char(nPathName),'_sharedutils','split');
                nFile2copy = fullfile(char(nFoundPath(1)),'_sharedutils','*.h');
                copyfile(char(nFile2copy),char(to.mdlInc),'f');
                break;
            end
        end
        %Copy .h included files
        for nHFile = nBuildInfoHFiles
            [nFilePath,nFileBaseName,nFileExt] = fileparts(char(nHFile));
            if(isempty(nFilePath))
                if(exist(fullfile(to.mdlInc,char(nHFile)),'file') == 0)
                    %Files not already copied
                    for nPathIndex = nBuildInfoPaths
                        fileH2Found = fullfile(char(nPathIndex),char(nHFile));
                        if(exist(fileH2Found,'file') == 2)
                            nHFullFileName = fullfile(to.mdlInc,nHFile);
                            copyfile(fileH2Found,nHFullFileName,'f');
                            verboseMe(['copyModelFiles2(): ',fileH2Found,' -> ',nHFullFileName,' done']);
                            break;
                        end
                    end
                end
            else
                nHFullFileName = fullfile(to.mdlInc,[nFileBaseName,nFileExt]);
                copyfile(char(nHFile),nHFullFileName,'f');
                verboseMe(['copyModelFiles2(): ',char(nHFile),' -> ',nHFullFileName,' done']);
            end
        end

    end



    function writeScript(modelName,scriptFullFileName,iocFullFileName,toolchain,frequency,heapSize,openProject,saveProject)
        % Write script for STM32CubeMX on file system

        verboseMe(['writeScript(',scriptFullFileName,',',iocFullFileName,')']);

        try
            [nScriptFileId,nErrMsg] = fopen(scriptFullFileName, 'w');
            if ~isempty(nErrMsg)
                error([scriptFullFileName,' : --->',nErrMsg]);
            end
            fprintf(nScriptFileId,'config load "%s"\n',iocFullFileName);

            if(~isempty(modelName))
                %% Set project name
                fprintf(nScriptFileId,'project name %s\n',modelName);
            end

            if(~isempty(toolchain))
                %% Set toolchain name
                fprintf(nScriptFileId,'project toolchain %s\n',toolchain);
            end

            if(~isempty(frequency))
                %Sysclock src is PLL
                fprintf(nScriptFileId,'clock set SysClkSource 2\n');
                %PLL src is HSI
                fprintf(nScriptFileId,'clock set PLLSource 0\n');
                %APB divider
                fprintf(nScriptFileId,'clock set APB1CLKDivider 4\n');
                fprintf(nScriptFileId,'clock set APB2CLKDivider 2\n');
                %Set frequency value
                fprintf(nScriptFileId,'clock set hclk %d\n',str2double(frequency) / 1e6);
            end

            if(~isempty(heapSize))
                fprintf(nScriptFileId,'project set heapsize 0x%x\n',heapSize);
            end

            if(~isempty(saveProject))
                fprintf(nScriptFileId,'config save "%s"\n',iocFullFileName);
            end

            if(~isempty(openProject))
                if(openProject == 0)
                    fprintf('### Open Project popup window will not appear. Set openProject preference to 1 if you want to see it.\n');
                    fprintf(nScriptFileId,'project generate\n');
                else
                    fprintf('### Open Project popup window will appear. Set openProject preference to 0 if you do not want to see it.\n');
                    fprintf(nScriptFileId,'project generate ui\n');
                end
            end

            fprintf(nScriptFileId,'exit wait\n');
            fclose(nScriptFileId);

        catch nME_writeScript
            fclose(nScriptFileId);
            error(['writeScript(): Can not create file : ',scriptFullFileName]);
        end
        verboseMe('writeScript()<');
    end

%% Update preference for the customization to the main()
    function updateTlcCustomizationOfMain(modelName,isTopModel,simulationMode)
        verboseMe(['updateTlcCustomizationOfMain(',modelName,',',num2str(isTopModel),',',simulationMode,')']);

        %% Bypass customization of main() by default.
        nMainCustomization = 0;

        if (isTopModel)
            % Code that is specific to the top model
            if (contains(simulationMode,'normal'))
                nMainCustomization = 1;
            elseif (contains(simulationMode,'external'))
                nMainCustomization = 3;
            elseif (contains(simulationMode,'Software-in-the-loop'))
                nMainCustomization = 0;
            else
                nMainCustomization = 0;
            end
        end

        %% Referenced or not this model with PIL mode must have main() customization.
        if (contains(simulationMode,'processor-in-the-loop'))
            nMainCustomization = 2;
        end

        updatePrefs('set','mainCustomizationMode',nMainCustomization);

        nTlcOptionValueSet = [0,1,2,3];
        nTlcOptionStringSet = {'SKIPPING','RTW','PIL','EXT'};
        nTlcOptions = containers.Map(nTlcOptionValueSet,nTlcOptionStringSet);

        verboseMe(['updateTlcCustomizationOfMain(): -> ','''',nTlcOptions(nMainCustomization),'''']);
    end

    function ide = computeStm32CubeMxIde()
        nToolchainName = char(updatePrefs('get','toolChainName'));
        nToolchainVersion = char(strtrim(updatePrefs('get','toolChainVersion')));

        if(strcmp(nToolchainName,'Other'))
            ide = nToolchainVersion;
        elseif ~isempty(nToolchainVersion)
            ide = [nToolchainName,' ',nToolchainVersion];
        else
            ide = nToolchainName;
        end
        verboseMe(['computeStm32CubeMxIde(): ''',ide,'''']);
    end


    function result = startStm32CubeMx(cmd, blockingCaller)
        % Start the STM32CubeMx tool with command and running mode.

        if(~isempty(blockingCaller))
            %% Command string to start STM32CubeMx in blocking mode
            nStr = ['java -jar ', [STM32_CUBE_MX_EXE,' ',cmd]];
        else
            %% Background running mode for STM32CubeMX.
            nStr = [STM32_CUBE_MX_EXE,' ',cmd,'&'];
        end
        verboseMe(['startStm32CubeMx(): ',nStr]);
        [result, ~] = system(nStr);
    end


%% Remove duplicates in array of cell
    function Au = uniqueOnCells(A)
        %% Decide to make path according to filesep()
        nA1 = cellfun(@(x) strrep(x,'/',filesep()),A,'UniformOutput',false);
        [~,nIdx] = unique(nA1,'sorted');
        Au = nA1(nIdx);
    end

%%
    function verboseMe(msg,varargin)
        nIsVerbose = IS_VERBOSE;

        if (nargin > 1)
            switch varargin{1}
                case 'Discard'
                    nIsVerbose = 'off';
            end
        end
        if(strcmp(nIsVerbose,'on'))
            fprintf('*** stm32_make_rtw_hook(): %s\n',msg);
        end
    end
end
function makeInfo = rtwmakecfg()
% RTWMAKECFG adds include and source directories to the RTW makefiles.
% makeInfo = RTWMAKECFG returns a structured array containing following fields:

% makeInfo.includePath - cell array containing additional include directories.
% Those directories will be expanded into include instructions of rtw generated makefiles.
%
% makeInfo.sourcePath - cell array containing additional source directories.
% Those directories will be expanded into rules of rtw generated makefiles.
%
% makeInfo.library - structure containing additional runtime library names and module objects.
% This information will be expanded into rules of rtw generated makefiles.
%
% ... .library(1).Name - name of runtime library
% ... .library(1).Modules - cell array containing source file names for the runtime library
% ... .library(2).Name
% ... .library(2).Modules
% ...
% This RTWMAKECFG file must be located in the same directory as the related
% S-function MEX-DLL(s). If one or more S-functions of the directory are referenced
% by a model Real-Time Workshop will evaluate RTWMAKECFG to obtain the additional
% include and source directories.
% To examine more RTWMAKECFG files in your installation issue at the MATLAB prompt:
% >> which RTWMAKECFG -all

% Issue a message.
separatorLine = char(ones(1,70) * '~');
fprintf('\n%s\n', separatorLine);
fprintf(' Adding source and include directories to make process.\n')

stm32RootPath =  getpref('STM32', 'stm32RootPath');
fprintf('STM32 package install path: %s\n', stm32RootPath);

% Setting up the return structure with
% - source directories:
makeInfo.sourcePath = { ...
    fullfile(stm32RootPath,'addSrc','src') ...
    };

% - include directories
makeInfo.includePath = { ...
    fullfile(stm32RootPath,'addSrc','inc') ...
    };

% Display contents.
fprintf(' - additional source directories:\n');
fprintf(' %s\n', makeInfo.sourcePath{:});
fprintf(' - additional include directories:\n');
fprintf(' %s\n', makeInfo.includePath{:});
fprintf('%s\n', separatorLine);
% [EOF] rtwmakecfg.m
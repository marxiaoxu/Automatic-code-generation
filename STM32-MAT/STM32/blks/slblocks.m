 function blkStruct = slblocks
% SLBLOCKS adds the STM32 library to the Library Browser
% 
% $ slblocks.m 2009-05-14 dlange $
%

blkStruct.Name = sprintf('STM32 LIBRARY');
blkStruct.OpenFcn = 'STM32_Library';
blkStruct.MaskInitialization = '';
blkStruct.MaskDisplay = 'disp(''STM32 LIBRARY'')';

% Information for Simulink Library Browser
Browser(1).Library = 'STM32_Library';
Browser(1).Name    = 'Target Support Package - STM32 Adapter';
Browser(1).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?
%Browser(2).Library = 'Peripheral_Drivers';
%Browser(2).Name    = 'Peripheral Drivers';
%Browser(2).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?
blkStruct.Browser = Browser;

% Define information for model updater
blkStruct.ModelUpdaterMethods.fhSeparatedChecks = @ecblksUpdateModel;
 
% [EOF]: slblocks.m

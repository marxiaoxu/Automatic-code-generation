function valid = isHex(inputValue)
%
%  Mask Helper Function to check whether input value is a valid Hexadecimal value.
%
% $RCSfile: isHex.m,v $
% $Revision: 1.1.6.2 $ $Date: 2009/09/03 05:36:46 $
% Copyright 2005-2008 The MathWorks, Inc.

valid = 1;

expr = '^0\x[0-9a-f]*';
[outputHex] = regexpi(inputValue, expr, 'match');


% Catch the case when inputValue doesn't start with prefix '0x' and output
% of regexpi() would be a NULL array.
if (length(outputHex)==0)
    valid = 0;
    return;
end

% If user enter valid hex value, we expect the output of
% the regular expression to be same as output.
if (~strcmp(outputHex, inputValue))
    valid = 0;
    return;
end


return
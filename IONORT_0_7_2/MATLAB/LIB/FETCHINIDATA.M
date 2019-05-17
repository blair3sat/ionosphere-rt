function result = fetchIniData(fileName, varargin)
%==========================================================================
% DESCRIPTION : This function reads ini file and returns the parameter value 
%               pair of the specified parameters & section. Parameters are 
%               grouped under a section. This function allows the flexibility 
%               to have parameters with duplicate names under different 
%               sections but not under the same section.
%               A sample INI file looks like the following :
%
%               [Software]                   -----> section
%               Product=MATLAB
%               Company=MATHWORKS
%
%               # used for comments          ------> line starting with '#'
%                                                    considered comments
%               [Database]
%               dbname=oracle
%               username=scott
%               Passwd=tiger
% USAGE : There are multiple ways to call this function :
%
% 1) Fetching specific parameters under a section 
%    result = fetchIniData('c:\work\sample.ini','section','Database','params',
%                       {'dbname', 'username'},'section','Software'
%                       'params', {'Product'})
%
% 2) Fetching all parameters under a section (2 ways to do this) :
%    result = fetchIniData('c:\work\sample.ini','section','Database','params',
%                       {},'section','Software','params', {})
%                       or
%    result = fetchIniData('c:\work\sample.ini','section','Database',
%                                           'section','Software')
%
% 3) Fetching all parameters under a section and specific parameters under
%    another section :
%    result = fetchIniData('c:\work\sample.ini','section','Database','params',
%                       {'dbname', 'username'},'section','Software')
% 4) Fetching everything in the file :
%    result = fetchIniData('c:\work\sample.ini')
%
% INPUT : 1) Full path to the ini file along with file name and extension as 
%            indicated in the usage. A valid ini file is mandatory.
%         2) Name value pair of section followed by actual sectionName ,
%            parmas followed by cell array of parameters
%
%         NOTE: when parameters are passed to the function it has to be
%         preceded with the section and sectionName. Failing to pass then\m
%         will result in an error.
%
% OUTPUT: Structure of structures
%         Example: result.Database
%                  ans =
%                        dbname: 'oracle'
%                        username: 'scott'
%                        Passwd: 'tiger'
% 
%==========================================================================
result = [];
if nargin < 1
    error('Not enough arguments. Valid .ini file is required');
end
% read the entire .ini file
iniResult = iniread(fileName);
j = 1;
% check if any specific section or any params under a section is requestes
% by cheking if varargin is empty or not. if varargin is empty then pass
% back iniResult
if ~isempty(varargin)
    i = 1;
    % parse the inputs
    while i < length(varargin)
        if strcmpi(varargin{i}, 'section')
            inputStruct(j).(varargin{i}) = varargin{i+1};
            i = i + 2;
        else
            error('Not a valid input format');
        end
        inputStruct(j).params = '';
        if (i < length(varargin)) && strcmpi(varargin{i}, 'params')
            inputStruct(j).(varargin{i}) =  varargin{i+1};
            i = i + 2;
        end

        j = j + 1;
    end % while 
    for i = 1:length(inputStruct)
        section = inputStruct(i).section;
        params = inputStruct(i).params;
        if isfield(iniResult, section)
            sectionResult = iniResult.(section);
            % check if params is empty or if it exist. if not then pass the all
            % the params under the section back
            if ~isempty(params)
                for k = 1:length(params)
                    result.(section).(params{k})  = sectionResult.(params{k});
                end% for
            else
                result.(section) = sectionResult;
            end % if
        else
            result.(section) = 'Section not found';
        end % if
    end % for
else
    result = iniResult;
end
end % function

function iniResult = iniread(fileName)
%=========================================================================
% NAME  : Reads the entire .ini file and passes back a structure to the 
%         above function
%
% INPUT : Full path to the ini file along with file name and extension as 
%         indicated in the usage
%
% OUTPUT: Structure of structures.Structure of section names which in turn 
%         contains array of structures with param and value as fields
%==========================================================================
iniResult = []; 

try
    fid = fopen(fileName);
catch
    rethrow(lasterr);
end
MATCH_SECTION = false;
CURR_SECTION = '';
paramAndValueArray = [];
j = 1;
while ~feof(fid)
    tline = strtrim(fgets(fid));
    if ~isempty(tline) && ~strcmp('#',tline(1))
        section = regexp(tline, {'\[*\w+\]'}, 'match');
        if ~isempty(section{1})
            section = section{1}{1};
            section = regexprep(section,{'\[','\]'},'');
            MATCH_SECTION = true;
            if ~isempty(CURR_SECTION)
                iniResult.(CURR_SECTION) = paramAndValueArray;
                j = 1;
                paramAndValueArray = [];
            end
            CURR_SECTION = section;
        else
            MATCH_SECTION = false;
        end
        if ~MATCH_SECTION
            parameter = regexp(tline, {'\w+\s*=+\s*.*'},'match');
            if ~isempty(parameter{1})
                parameter = parameter{1}{1};
                [parameter, value] = strtok (parameter,'=');
                paramAndValueArray.(strtrim(parameter)) = strtrim(strrep(value,'=',''));
%                 paramAndValueArray(j).param = strtrim(parameter);
%                 paramAndValueArray(j).value = strtrim(strrep(value,'=',''));
                j=j+1;
            end
        end
    end
end
iniResult.(CURR_SECTION) = paramAndValueArray;
fclose(fid);
end % END iniread

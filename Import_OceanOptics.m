%Import data from the Ocean Optics spectrometer. Files are in a .txt format.

if exist('pathname','var') == 0
    [filename,pathname] = uigetfile('*.txt','Select OceanOptics data file(s) to import.','MultiSelect', 'on');
else
    [filename,pathname] = uigetfile([pathname '*.txt'],'Select OceanOptics data file(s) to import.','MultiSelect', 'on');
end



if ischar(filename) == 1
    filename = cellstr(filename);
end
numfile = length(filename);

spectra = cell(1,numfile);        % Preallocate/Initialize cell arrays
Xdata = cell(1,numfile);
Ydata = cell(1,numfile);

for k=1:numfile
    spectra{k} = importdata(filename{k});
    Xdata{k} = spectra{k}.data(:,1);
    Ydata{k} = spectra{k}.data(:,2);
end

%spectra{n}.textdata calls the text data (including name) of the nth file
%spectra{n}.data calls the actual numerical data of the nth file
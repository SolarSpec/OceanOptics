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
openfile = cell(1,numfile);

for k=1:numfile
     openfile{k} = append(pathname, filename{k});
     spectra{k} = importdata(openfile{k});
     Xdata{k} = spectra{k}.data(:,1);
     Ydata{k} = spectra{k}.data(:,2);
end

%spectra{n}.textdata calls the text data (including name) of the nth file
%spectra{n}.data calls the actual numerical data of the nth file




%Determine Datatype of each file through Commant Prompts
datatype = zeros(1,numfile); %Results will be in this vector

set = [1, 2, 3, 4];
for k=1:numfile
    datatype(k)=input(['Select the datatype for: ',filename{k},'\n1-Emission 2-Absorbance 3-Reflection 4-Kubelka-Munk \nSelect 1, 2, 3, or 4: \n']);
    while (~(ismember(datatype(1), set)) || (datatype(k) > 4))
        datatype(k) = input('Please enter a valid value \n1-Emission 2-Absorbance 3-Reflection 4-Kubelka-Munk \nSelect 1, 2, 3, or 4: \n');
    end
end

%Create data tables
fig2 = figure("Name","OceanOptics");
tabgp = uitabgroup(fig2);                   %Each data type will have a tab
if ismember(1, datatype)                    %Emission
    Em = uitab(tabgp,"Title","Emission");
    Emmatrix = [];                          %Create matrix of all Emmission data
    labels = {};
    for k = find(datatype==1)
        Emmatrix = [Emmatrix, Xdata{k}, Ydata{k}];
        labels = [labels, 'Wavelength', filename{k}];
    end
    Emtables = {};
    uit1 = {};
    idx = 1;                                %Signifies Each Table: index in Emtables cell
    while size(Emmatrix) > 0
        %Create new table
        Wavelength = Emmatrix(:, 1);
        Emtables{idx} = table(Wavelength);
        j=1;
        while j <= size(Emmatrix,2)
            if (Emmatrix(:,j) == Wavelength)
                Emtables{idx}.(labels{j+1}) = Emmatrix(:,j+1);
                Emmatrix(:,(j:j+1))=[];
                labels(:,(j:j+1))=[];
            else
                j = j+2;
            end
        end
        idx = idx + 1;
    end
    pos = [20, 20, 248, 350];
    for k = 1:(idx-1)
        uit1{k}=uitable(Em,"Data",table2array(Emtables{k}), 'ColumnName', Emtables{k}.Properties.VariableNames, 'RowName',[], 'Position',pos);
        pos = pos + [272, 0, 0, 0];
    end
    disp('See Emtables cell array for Absorbtion data tables');
    clear Emmatrix;
end
if ismember(2, datatype)                    %Absorbance
    abs = uitab(tabgp,"Title","Absorption");
    Abmatrix = [];                          %Matrix of all Absorption data
    labels = {};
    for k = find(datatype==2)
       Abmatrix = [Abmatrix, Xdata{k}, Ydata{k}];
       labels = [labels, 'Wavelength', filename{k}];
    end
    Abtables = {};
    uit2 = {};
    idx = 1;
    while size(Abmatrix) > 0
        %Create new table
        Wavelength = Abmatrix(:, 1);
        Abtables{idx} = table(Wavelength);
        j=1;
        while j <= size(Abmatrix,2)
            if (Abmatrix(:,j) == Wavelength)
                Abtables{idx}.(labels{j+1}) = Abmatrix(:,j+1);
                Abmatrix(:,(j:j+1))=[];
                labels(:,(j:j+1))=[];
            else
                j = j+2;
            end
        end
        idx = idx+1;
    end
    pos = [20, 20, 248, 350];
    for k=1:(idx-1)
        uit2=uitable(abs,"Data",table2array(Abtables{k}), 'ColumnName', Abtables{k}.Properties.VariableNames, 'RowName',[], 'Position',pos);
        pos = pos + [252, 0, 0, 0];  
    end
    disp('See Abtables cell array for Absorption data tables');
    clear Abmatrix;
end
if ismember(3, datatype)                    %Reflection
    Ref = uitab(tabgp,"Title","Reflection");
    Refmatrix = [];
    labels = {};
    for k = find(datatype==3)
       Refmatrix = [Refmatrix, Xdata{k}, Ydata{k}];
       labels = [labels, 'Wavelength', filename{k}];
    end
    Reftables = {};
    uit3 = {};
    idx = 1;
    while size(Refmatrix) > 0
        %Create new table
        Wavelength = Refmatrix(:, 1);
        Reftables{idx} = table(Wavelength);
        j=1;
        while true
            if j > size(Refmatrix,2)
                break
            elseif (Refmatrix(:,j) == Wavelength)
                Reftables{idx}.(labels{j+1}) = Refmatrix(:,j+1);
                Refmatrix(:,(j:j+1))=[];
                labels(:,(j:j+1))=[];
            else
                j = j+2;
            end
        end
        idx = idx+1;
    end
    pos = [20, 20, 248, 350];
    for k = 1:(idx-1)
        uit3=uitable(Ref,"Data",table2array(Reftables{k}), 'ColumnName', Reftables{k}.Properties.VariableNames, 'RowName',[], 'Position',pos);
        pos = pos + [252, 0, 0, 0];
    end
    disp('See Reftables cell array for Reflection data tables');
    clear Refmatrix;
end
if ismember(4, datatype)                    %Kubelka-Munk
    KM = uitab(tabgp,"Title","Kubelka-Munk");
    KMmatrix = [];
    labels = {};
    for k = find(datatype==4)
       KMmatrix = [KMmatrix, Xdata{k}, Ydata{k}];
       labels = [labels 'Wavelength' filename{k}];
    end
    KMtables = {};
    uit4 = {};
    idx = 1;
    while size(KMmatrix) > 0
        %Create new table
        Wavelength = KMmatrix(:, 1);
        KMtables{idx} = table(Wavelength);
        j=1;
        while true
            if j > size(KMmatrix,2)
                break
            elseif (KMmatrix(:,j) == Wavelength)
                KMtables{idx}.(labels{j+1}) = KMmatrix(:,j+1);
                KMmatrix(:,(j:j+1))=[];
                labels(:,(j:j+1))=[];
            else
                j = j+2;
            end
        end
        idx = idx+1;
    end
    pos = [20, 20, 248, 350];
    for k = 1:(idx-1)
        uit4=uitable(KM,"Data",table2array(KMtables{k}), 'ColumnName', KMtables{k}.Properties.VariableNames, 'RowName',[], 'Position',pos);
        pos = pos + [252, 0, 0, 0];
    end
    disp('See KMtables cell array for Kubelka-Munk data tables');
    clear KMmatrix;
end

%Clear Extra Data
clear datatype idx j k labels numfile openfile pathname pos set Wavelength Xdata Ydata
clear fig2 tabgp uit3
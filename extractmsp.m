function [mz] = extractmsp(filename)

%(c) Michael Sorochan Armstrong, 2021
%Converts .MSP mass spectral files from Chromatof and NIST Mass Spectral Library to a
%readable matlab format.
%First row: m/z ratios. 
%Second row: intensities, relative or absolute.
%

%Assuming there are 20 columns in the data. If it's not working you may
%want to check this.
fid = fopen(filename);
data = textscan(fid,'%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d','HeaderLines',2,'Delimiter',{' ',';'},'MultipleDelimsAsOne',1);
fclose(fid);

%Convert to double precision matrix
for ii = 1:20
    rawMS(:,ii) = double(data{1,ii}); %#ok no large computational savings here
end

%linearise the matrix
rawMS = rawMS';
lineMS = rawMS(:);

%Make sure it's a row
if size(lineMS,2) < size(lineMS,1)
    lineMS = lineMS';
end

mzs = lineMS(1:2:end);
ints = lineMS(2:2:end);

mz(1,:) = mzs;
mz(2,:) = ints;

%sometimes there are empty columns are artefacts. If any columns are zero,
%fuck 'em.
mz(:,~any(mz)) = [];

end
% run every files in the same extendion in a directory.
% input: folder directory and the extension of the files in this folder
% output: filename of every file; filename is a cell
function filename = batchfolder(folder,extension)

% folder  = 'D:\1PhD_working\dataset\Jiajie\ISMIR_2015_Tonynotes_csv';
% extension = '*.csv';
list = dir(fullfile(folder, extension));
nFile   = length(list);
filename = cell(nFile,1);
for k = 1:nFile
  filename{k} = list(k).name;
end
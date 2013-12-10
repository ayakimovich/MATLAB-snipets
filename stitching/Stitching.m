% Stitching Version 2 - Artur Yakimovich (c) 2011
% Arguments:
% DataFolder    the folder that contains the images to be stitched
%               eg: 'G:\MDC\MDC_Images\ME091002_NT\Plate_1\';
%
% SaveFolder    the folder in which all output is saved
%               eg: 'G:\MDC\MDC_Images\ME091002_NT\Plate_1_Output\';
%
% X_Images      the number of images in the stitching grid in x direction
%
% Y_Images      the number of images in the stitching grid in y direction
%
% FileNameCommon the part of the filename do all images to be stitched have
%               in common?
%               eg: '*w1.TIF'
% to add: name files with numbers starting with 01, 02 etc..
clear all;
display 'Start';
%testing purposes
DataFolder = 'R:\Data\121030-Drugtest4x-scan-LMB-test_Plate_44\TimePoint_1\';
SaveFolder = 'R:\Data\121030-Drugtest4x-scan-LMB-test_Plate_44\Stitched\';
X_Images = 2;
Y_Images = 2;


mkdir(SaveFolder)
for iChan=1:2
    if iChan==1
        FileNameCommon = '*w1.TIF';
    elseif iChan==2
        FileNameCommon = '*w2.TIF';
    end



% find all the images
AllImagesUnsorted = dir(fullfile(DataFolder,FileNameCommon));
%put them into the natural ordering (ie. s1, s2, ... s10, s11...)
AllImagesCellArry = sort_nat(extractfield(AllImagesUnsorted, 'name'));
AllImages = cell2struct(AllImagesCellArry, 'name', 1);

ImagesPerWell = X_Images*Y_Images;
RowNames = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H'};
ColNames = {'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12'};
ImgCounter = 1;
for iRow = 1:length(RowNames)
    for iCol = 1:length(ColNames)
          for y = 1:Y_Images
                for x =  1:X_Images
                    %if findstr(strcat(RowNames(iRow), ColNames(iCol)), AllImages(ImgCounter).name)
                        StitchedCell{y,x} = imread([DataFolder, AllImages(ImgCounter).name]);
                    ImgCounter = ImgCounter +1;
                end
          end
    StitchedImage = cell2mat(StitchedCell(:,:));      
    

    if iChan==1
        ImageName = [SaveFolder, char(RowNames(iRow)), char(ColNames(iCol)), '_w1.TIF'];
    elseif iChan==2
        ImageName = [SaveFolder, char(RowNames(iRow)), char(ColNames(iCol)), '_w2.TIF'];
    end
    display (ImageName);
    imwrite(StitchedImage,ImageName);
    clear StitchedImage ImageName StitchedCell
    end
end

end
disp('finished')
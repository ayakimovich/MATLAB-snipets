% Automatic crops ROI defined by user through the whole time course.
% Artur Yakimovich (c)2009. University of Zurich
% last change: 100204
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

clear all;
%--Input Vars--
CropTheImage = false;
SaveRDFs = 'Yes';
GraphOutput = 'No';
RadialStepsNumber = 360;
GFPChannelMask = 'w2';
%
Path = 'D:\AY-Data\101202-AY-E11Stc_Plate_21\LastTP_Stitched\E06\ROI3\';
SaveTo = 'D:\AY-Data\101202-AY-E11Stc_Plate_21\LastTP_Stitched\E06\ROI3\';
FileNameCommon = '*.TIF';
NmbOfChan = 3;
XCrop = 1600;
YCrop = 1600;
%----
mkdir(SaveTo);
% find all the images
AllImagesUnsorted = dir(fullfile(Path,FileNameCommon));
%put them into the natural ordering (ie. s1, s2, ... s10, s11...)
AllImagesCellArry = sort_nat(extractfield(AllImagesUnsorted, 'name'));
AllImages = cell2struct(AllImagesCellArry, 'name', 1);

%-- Get Position from the last time point
if NmbOfChan == 2 || NmbOfChan == 1;
  LastIm = size(AllImages,1);
elseif NmbOfChan == 3;
  LastIm = size(AllImages,1) -1 
  %- 1;
end

I = imread([Path, AllImages(LastIm).name]);
ImInfo = imfinfo([Path, AllImages(LastIm).name]);

%msgbox('Click on the center of the plaque')
%pause(2);
imshow(I, [min(I(:)) max(I(:))/8]);
[x, y] = ginput(1);
close all;
%disp ([round(x), round(y)]);
%disp (ImInfo.Width);
%disp (ImInfo.Height);
xmin = round(x) - XCrop/2;
ymin = round(y) - YCrop/2;

%Move the ROI if too close to the edge, so that ROI dimension stay the same

if (ImInfo.Width - round(x)) < XCrop/2
    %xmin = xmin - ((round(x)+XCrop/2) - ImInfo.Width);
    xmin = ImInfo.Width - XCrop
end
if (ImInfo.Height - round(y)) < YCrop/2
    %ymin = ymin - ((round(y)+YCrop/2) - ImInfo.Height);
    ymin = ImInfo.Height - YCrop
end
if (round(x) - XCrop/2) < 0
    xmin = 0;
end
if (round(y) - YCrop/2) < 0
    ymin = 0;
end
%%%
I2 = imcrop(I,[xmin ymin XCrop YCrop]);
%get the new coordinates of the center for the RDF computing
x1 = round(x) - xmin;
y1 = round(y) - ymin;
% check your result
imshow(I, [min(I(:)) max(I(:))]), figure, imshow(I2, [min(I2(:)) max(I2(:))]);
%disp (['Start: ', datestr(now)]);
button1 = questdlg('Are the ROI coordinates alright? Press "No" to try again.','Proceed?','default');
if strcmp('Yes', button1) == 1;
    %disp (['Stop: ', datestr(now)]);
%--Loop starts
%disp(['Start: ', datestr(now)]);
for i = 1:size(AllImages,1);
h = waitbar(0,'Please wait...');
waitbar(i/size(AllImages,1))

disp ('Cropping:');

%disp ([Path, AllImages(i).name]);
Img = imread([Path, AllImages(i).name]);
if CropTheImage
    ImgCrpd = imcrop(Img,[xmin ymin XCrop YCrop]);
    imwrite(ImgCrpd, [SaveTo, AllImages(i).name], 'tif');
else
    ImgCrpd = Img; 
end
disp(['Step done',  datestr(now)]);
close(h)
        if strcmp('Yes', SaveRDFs) == 1 &&  isempty(strfind(AllImages(i).name, GFPChannelMask)) == 0;
                    % get RDF here and save it to a .mat file
        clear rdf;
        rdf = getRDF(ImgCrpd, [x1,y1], 1, RadialStepsNumber);
                             % ^^^ - needs to be fixed
            
        RDFs(i-1, :) = rdf(:);
            
        disp('RDFs where saved as set by the user');
        else
                disp('No RDFs where saved as set by the user or no GFP channel detected');
        end
end

%now save the .mat file

        if strcmp('Yes', SaveRDFs) == 1;
        mkdir([SaveTo, 'RDF\']);
        save([SaveTo, 'RDF\RDFs.mat'], 'RDFs');    
            
        else
                disp('No RDFs where saved as set by the user');
        end
% plot here for debugging        
        if strcmp('Yes', GraphOutput) == 1;
        close all;    
            ColorSet = varycolor(24);
            set(gca, 'ColorOrder', ColorSet);
            hold all;
            
            
            

            % How many points to skip while plotting, 1 - plot every point
            PlotingStep = 1;

            % First dimension of the RDF array is the number of image.  The second
            % dimension contains the RDF points 1 to the length of the rdf
            [NumberOfImages,RDFValuesPntsNumber] = size(RDFs);

            %microns per pixel vlaue
            umPerPx = 0.645;
            for i = 1:NumberOfImages
            factorlength = umPerPx*RDFValuesPntsNumber;
            plot(umPerPx:umPerPx:factorlength, RDFs(i, 1:RDFValuesPntsNumber));
 end
            % hold on
            xlabel('um')
            ylabel('average intensity')
            legend off


            %plot(1:lengthOfRDF, RDFs(i,:))
           
            set(gcf, 'Colormap', ColorSet);
            colorbar
            hold off
        else
                disp('No Graph Output was generated as set by the user');
        end
    
disp(['End: ', datestr(now)]);
elseif strcmp('No', button1) == 1;
    AutoCropROI100204()
else
     error('Program interrupted by user')
end
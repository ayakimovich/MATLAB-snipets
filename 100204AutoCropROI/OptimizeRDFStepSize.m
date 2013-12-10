filePath = 'D:\AY-Data\101202-AY-E11Stc_Plate_21\LastTP_Stitched\F09\ROI1\';
%Common name mask for the GFP channel imaes
fileNameCommon_GFP = '*w2.TIF';
fileNameCommon_PI = '*w2.TIF';

NmbOfChan = 3;

Step = 9; 
% find all the images

AllImagesUnsorted_PI = dir(fullfile(filePath,fileNameCommon_PI));
AllImagesUnsorted_GFP = dir(fullfile(filePath,fileNameCommon_GFP));

%put them into the natural ordering (ie. s1, s2, ... s10, s11...)

AllImagesCellArry_PI = sort_nat(extractfield(AllImagesUnsorted_PI, 'name'));
AllImagesCellArry_GFP = sort_nat(extractfield(AllImagesUnsorted_GFP, 'name'));

AllImages_PI = cell2struct(AllImagesCellArry_PI, 'name', 1);
AllImages_GFP = cell2struct(AllImagesCellArry_GFP, 'name', 1);

AllImages = AllImages_GFP;
 

%-- Get Position from the last time point
LastIm_GFP = size(AllImages_GFP, 1);
 
% Want to show the PI image
%R = imread([filePath, AllImages_PI(1).name]);
G = imread([filePath, AllImages_GFP(1).name]);
%B = zeros (size(R));
% Read last GFP image
%I = imread([filePath, AllImages_GFP(LastIm_GFP).name]);

%Make RGB
%RGB(:,:,1) = R;
%RGB(:,:,2) = G;
%RGB(:,:,3) = B;

ImInfo = imfinfo([filePath, AllImages_GFP(LastIm_GFP).name]);

% maxRDFLength = 100;
 maxRDFLength = min(ImInfo.Width, ImInfo.Height)/2;

%msgbox('Please click on the center of the plaque.')

%pause(2);
%imshow(RGB, [min(G(:)) max(G(:))]);%/8]);
imshow(G, [min(G(:)) max(G(:))]);%/8]);

[x, y] = ginput(1)
%x = 610;
%y = 680;
%[x, y] = [620, 652];

 

 swap = x;
 x = y;
 y = swap;

close all;

 



%%%

%I2 = imcrop(I,[xmin ymin XCrop YCrop]);

%imshow(I, [min(I(:)) max(I(:))]), figure, imshow(I2, [min(I2(:)) max(I2(:))]);

%disp (['Start: ', datestr(now)]);

%button1 = questdlg('Are the spreading phenotype centre coordinates alright? Press "No" to try again.','Proceed?','default');

%if strcmp('Yes', button1) == 1;

    %disp (['Stop: ', datestr(now)]);

    %--Loop starts

    %disp(['Start: ', datestr(now)]);
    
    RDFs = zeros(size(AllImages_GFP,1), maxRDFLength);

    for i = 1:size(AllImages,1);

        %h = waitbar(0,'Please wait...');

        %waitbar(i/size(AllImages,1))

 

        %disp ('Determining RDF:');

 

        %disp ([filePath, AllImages(i).name]);

        Img = imread([filePath, AllImages(i).name]);

        %ImgCrpd = imcrop(Img,[xmin ymin XCrop YCrop]);

 

        %imwrite(ImgCrpd, [SaveTo, AllImages(i).name], 'tif');
        
        %call my RDF function
   for RadialStepsNumber = Step:Step:360
    RDFs = 0;
       rdf = getRDF(Img, [x,y], 1, RadialStepsNumber);

        for l = 1:length(rdf)
            RDFs(i, l) = rdf(l);
        end
        
        AllRDFs(RadialStepsNumber/Step,:) = RDFs
   end
        %plot(1:length(rdf), rdf);
        
        

        %disp(['Step done',  datestr(now)]);

        %close(h)

    end

 
ColorSet = varycolor(39);
set(gca, 'ColorOrder', ColorSet);
hold all;

    disp(['Done: ', datestr(now)]);
for i = 1:RadialStepsNumber/Step
    clear RDFs;
    RDFs = AllRDFs(i,:);
% How many points to skip while plotting, 1 - plot every point
PlotingStep = 1;

% First dimension of the RDF array is the number of image.  The second
% dimension contains the RDF points 1 to the length of the rdf
[NumberOfImages,RDFValuesPntsNumber] = size(RDFs);
%l = length(rdf);
%l = 430;
%microns per pixel vlaue
umPerPx = 0.645;

factorlength = round(umPerPx*RDFValuesPntsNumber);
%factorlength =
%set(0,'DefaultAxesColorOrder',[0 1 0;0 1 0;0 0 1]);

plot(umPerPx:umPerPx:factorlength, RDFs(1:PlotingStep:NumberOfImages, 1:RDFValuesPntsNumber)./2^16);

% hold on
xlabel('um')
ylabel('average intensity')
legend off


%plot(1:lengthOfRDF, RDFs(i,:))
end
set(gcf, 'Colormap', ColorSet);
colorbar
hold off

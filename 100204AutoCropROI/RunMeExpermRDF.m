%=====================================================================
%        RunMe script to get an RDF of an image series and plot it 
%
%                            ****OOOOOO****     
%  2010 (copyright) Artur Yakimovich, University of Zurich, Switzerland
%                                 ****
%======================================================================
ImFolder = 'D:\AY-Data\101202-AY-E11Stc_Plate_21\LastTP_Stitched\C03\ROI1\';
%Common name mask for the GFP channel imaes
CommonNameGFP = '*w2.TIF';
CommonNamePI = '*w2.TIF';
% produces RDFs as an output
RDFs = experimentalImagesRDF(ImFolder,CommonNameGFP,CommonNamePI);
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
hold on
xlabel('um')
ylabel('average intensity')
h = legend('Location','EastOutside');
hold off
%plot(1:lengthOfRDF, RDFs(i,:))
%% clear
clc; clear all; close all;

%% path
addpath('./lib');      

%% Parameters
d = [11.58, 3.87, 32];                                                      % pixels to microns scaling
x= 25; y = 30; z = 25; r = 7;                                               % seed initial and radius
sigma = 4;                                                                   
nu = 39;                                                                    % length term (smoothness)
s = 3;                                                                      % multi-scale parameters
nx = s;                                                                     % multi-scale parameters at x
ny = s;                                                                     % multi-scale parameters at y
nz = 1;                                                                     % multi-scale parameters at z
radius = 30;                            

%% load image
im = imread3d('./im/mh.tif');

%% normalize
im = (im-min(im(:)))/(max(im(:))-min(im(:)));

%% scaling factors
[sx,sy,sz] = scalingfactor(s,nx,ny,nz);

%% segmentation
phi = mslevelset3d(im,x,y,z,r,...
                            nu,sigma,s,sx,sy,sz);                           % 3d level set

%% filter
imth = phi<=0; clear phi;
cc = bwconncomp(imth);
imth = bwareaopen(imth, max(cellfun(@length, cc.PixelIdxList)));
cc = bwconncomp(~imth);
imth = ~bwareaopen(~imth, max(cellfun(@length, cc.PixelIdxList)));

%% rescale
scale = d(:)/d(2);                                                          

%% curvatures
[imcurv,imneg] = curv3d(imth,radius,1,scale(1),scale(2),scale(3));

%% surface cut
immh = slice3d(imth,imneg,scale(1),scale(2),scale(3));

%% resize
resize = d/10;
immhs = resize3d(immh,resize);

%% measure
[xl,ry,rz,volume,surfacearea,height,basearea,basediameter,toparea, ... 
topdiameter, minimumdiameter] = measurement3d(immhs);

%% same metrics with published paper
table(:) = [volume./10^3, surfacearea./10^4, basearea./10^4,...
                basediameter./10^2, toparea./10^4, topdiameter./10^2,...
                height./10^2, minimumdiameter./10^2];

%% plot
figure, plotim3d(im,immh,26);
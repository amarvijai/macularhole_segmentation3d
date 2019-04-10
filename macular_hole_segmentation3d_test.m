%% clear
clc; clear; close all;

%% path
addpath('./lib');
addpath(genpath('./3rdParty'));

%% Parameters
d = [3.87, 5.77, 31];                                                      % pixels to microns scaling
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
scale = d/d(1);
immhs = resize3d(immh,scale);

%% measure
[rx,ry,rz,xmdbs,ymdbs,zmdbs,height,basetomld,minimumdiametermajor,minimumdiameterminor,...
    basediametermajor,basediameterminor,bs,mld,lengthbase1,lengthbase2,sloppyangle1,sloppyangle2,baseangle,meridianangle,...
    locbs,locmld,baseplane,mldplane,startx,starty,endx,endy,base,mldelevationangle1,mldelevationangle2,...
    topplane,tp,topdiametermajor,topdiameterminor,topangle] = measurement3d(immhs);

%% same metrics with published paper
c = d(1);
s = d(1)/10;
minormldangle = meridianangle + 90;
minorbsangle = baseangle + 90;
minortpangle = topangle + 90;
[volume,surfacearea,MLD_area,BD_area,TP_area] = volarea(immhs,mld,bs,tp,s);
table = [height.*c,basetomld.*c,minimumdiametermajor.*c,minimumdiameterminor.*c,...
    basediametermajor.*c,basediameterminor.*c,lengthbase1.*c,sloppyangle1,lengthbase2.*c,sloppyangle2,...
    meridianangle,minormldangle,mldelevationangle1,mldelevationangle2,baseangle,minorbsangle,topdiametermajor.*c,...
    topdiameterminor.*c,topangle,minortpangle,volume./10^3,surfacearea./10^4,MLD_area./10^4,BD_area./10^4,TP_area./10^4];

%% plot
figure, plotim3d(im,immh,26);

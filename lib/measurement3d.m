function [rx,ry,rz,xmdbs,ymdbs,zmdbs,height,basetomld,minimumdiametermajor,minimumdiameterminor,...
    basediametermajor,basediameterminor,bs,mld,lengthbase1,lengthbase2,sloppyangle1,sloppyangle2,baseangle,meridianangle,...
    locbs,locmld,baseplane,mldplane,startx,starty,endx,endy,base,mldelevationangle1,mldelevationangle2,...
    topplane,tp,topdiametermajor,topdiameterminor,topangle] = measurement3d(im)
%%  This is Various volumetric measurement of the hole
%   INPUT:
%       im     - 3D image segmented after cutting surface
%
%   OUTPUT:
%       Various volumetric measurement of the hole
%      
%   USAGE:
%       Volumetric measurement
%
%   AUTHOR:
%       Amar V Nasrulloh
%
%% volume, surface area, lenght
%% volume, surface area, lenght
[x,y,z] = ind2sub(size(im),find(im==1));
[iml,xl,yl,zl] = imcentreline3d(im);
%% smoothing line
rx = xl;
lengths = length(rx);
ry = smoothdata(yl,'movmedian',lengths);
rz = smoothdata(zl,'movmedian',lengths);
ry = smoothdata(ry,'movmedian',lengths);
rz = smoothdata(rz,'movmedian',lengths);
ry = smooth(ry, 0.9, 'rloess');
rz = smooth(rz, 0.9, 'rloess');
locstart = min(rx(:));
locend = max(rx(:));
%% length
for i = 1:(length(rx)-1)
    l(i) = sqrt((rx(i)-rx(i+1))^2+(ry(i)-ry(i+1))^2+(rz(i)-rz(i+1))^2);
end
height = sum(l(:));
%% plane base area and diameter
j = round(lengths/2);
i = max(lengths);
thickness = round(0.2*lengths);
j1 = 1;
j2 = 0;
d = [rx(j-j1),ry(j-j1),rz(j-j1)]-[rx(j+j2),ry(j+j2),rz(j+j2)];
baseplane = imperp3d(im,[rx(i),ry(i),rz(i)],d,x,y,z,thickness);
bs1 = squeeze(max(baseplane,[],1));
cc = bwconncomp(bs1);
bs1 = bwareaopen(bs1, max(cellfun(@length, cc.PixelIdxList)));
bs = imrotate(bs1,90,'bilinear');
stats = regionprops('table',bs,'Centroid', 'MajorAxisLength','MinorAxisLength','Orientation');
basediametermajor = stats.MajorAxisLength;
basediameterminor = stats.MinorAxisLength;
baseangle = stats.Orientation;
[startx,starty,endx,endy,lengthbase1,lengthbase2,base,baseangle,sloppyangle1,sloppyangle2] = baselengthplaneall(im,baseplane);
%% plane top area and diameter
topplane = imperp3d(im,[rx(1),ry(1),rz(1)],d,x,y,z,round(lengths*0.20));
tp1 = squeeze(max(topplane,[],1));
cc = bwconncomp(tp1);
tp1 = bwareaopen(tp1, max(cellfun(@length, cc.PixelIdxList)));
tp = imrotate(tp1,90,'bilinear');
statstp = regionprops('table',tp,'Centroid', 'MajorAxisLength','MinorAxisLength','Orientation');
topdiametermajor = statstp.MajorAxisLength;
topdiameterminor = statstp.MinorAxisLength;
topangle = statstp.Orientation;
%% minimum diameters
m = round(lengths*0.15);
n = round(lengths*0.80);
[minimumdiametermajor, minimumdiameterminor,meridianangle,locmlds] = slicediameter3d(m,n,rx,ry,rz,im,x,y,z);
mldplane = imperp3d(im,[rx(locmlds),ry(locmlds),rz(locmlds)],d,x,y,z,1);
mld1 = squeeze(max(mldplane,[],1));
cc = bwconncomp(mld1);
mld1 = bwareaopen(mld1, max(cellfun(@length, cc.PixelIdxList)));
mld = imrotate(mld1,90,'bilinear');
[mldelevationangle1,mldelevationangle2] = mldangleplane(mldplane);
locmld = locstart + locmlds - 1;
%% smooth line intersection with base plane
bottomplane = imperp3d(im,[rx(i),ry(i),rz(i)],d,x,y,z,thickness);
imline = zeros(size(im));
idx = sub2ind(size(imline),rx(:),round(ry(:)),round(rz(:)));
imline(idx) = 1;
imline = (imline==1);
lineplane = immultiply(imline,logical(bottomplane));
[xb,yb,zb] = ind2sub(size(lineplane),find(lineplane==1));
locbs = max(xb(:));
%% line from base area to minimum liniear diameter
ll = length(rx);
lbs = locend - locbs;
lmd = locend - locmld;
lm = ll - lmd;
lb = ll - lbs;
xmdbs = rx(lm:lb);
ymdbs = ry(lm:lb);
zmdbs = rz(lm:lb);
%% height from base area to minimum liniear diameter
for i = 1:(length(xmdbs)-1)
    mdbs(i) = sqrt((xmdbs(i)-xmdbs(i+1))^2+(ymdbs(i)-ymdbs(i+1))^2+(zmdbs(i)-zmdbs(i+1))^2);
end
basetomld = sum(mdbs(:));
end
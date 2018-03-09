function [xl,ry,rz,volume,surfacearea,length,basearea,basediameter,...
            toparea,topdiameter,minimumdiameter] = measurement3d(im)
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
volume = sum(im(:));
surfacearea = imSurface(im);
[x,y,z] = ind2sub(size(im),find(im==1));
[iml,xl,yl,zl] = imlinecm3d(im); 
length = sum(iml(:));
%% smoothing line
ry = smooth(yl, 0.9, 'rloess');
rz = smooth(zl, 0.9, 'rloess');
%% plane base area and diameter
j = round(length/2);
i = max(length);
d = [xl(j-1),ry(j-1),rz(j-1)]-[xl(j),ry(j),rz(j)];
baseplane = imperp3d(im,[xl(i),ry(i),rz(i)],d,x,y,z,round(0.2*length));
vb = squeeze(max(baseplane,[],1));
basearea = sum(vb(:));
stats = regionprops('table',vb,'Centroid', 'MajorAxisLength','MinorAxisLength');
basediameter = stats.MajorAxisLength;
%% plane top area and diameter
i = 1;
topplane = imperp3d(im,[xl(i),ry(i),rz(i)],d,x,y,z,round(0.2*length));
vt = squeeze(max(topplane,[],1));
toparea = sum(vt(:));
stats = regionprops('table',vt,'Centroid', 'MajorAxisLength','MinorAxisLength');
topdiameter = stats.MajorAxisLength;
%% minimum diameters
m = round(length*0.2); %?
n = round(length*0.8);
diameters = slicediameter3d(m,n,xl,ry,rz,im,x,y,z,d);
[value, idx] = min(diameters(m:n));
minimumdiameter = value;
end


function imths = slice3d(imth,imneg,dx,dy,dz)
%%  This is cutting surface based on negative curvature
%   INPUT:
%       imth     - 3D image segmented
%       imneg    - 3D negative curvature
%       dx,dy,dz - scale resolution for each axis to microns
%
%   OUTPUT:
%       imths   - 3D hole segmented image after cutting surface
%      
%   USAGE:
%       Cutting surface from negative curvature of 3D segmentation
%
%   AUTHOR:
%       Amar V Nasrulloh, Boguslaw Obara
%
%% fit surface
iso3 = isosurface(imneg,0);
v = iso3.vertices;
x = v(:,1); z = v(:,2); y = v(:,3);
sf = poly22(x,y,z);
%% surface
[xi,zi] = meshgrid(1:size(imth,2),1:size(imth,3));
[ci,yi] = predint(sf,[xi(:),zi(:)],0.7);
yi = round(yi);
yi(yi>size(imth,1)) = size(imth,1); 
yi(yi<1) = 1;
%% surface image
imsurf = zeros(size(imth));
idx = sub2ind(size(imsurf),yi(:),xi(:),zi(:));
imsurf(idx) = 1;
imsurf = (imsurf==1);
%% surface image - dilate
imd = bwdistsc(imsurf,[dx,dy,dz]);
imsurf = imd<36;
%% box
imsurf(1:end,1:end,1) = 1;
imsurf(1:end,1:end,end) = 1;
imsurf(1,1:end,1:end) = 1;
imsurf(end,1:end,1:end) = 1;
imsurf(1:end,1,1:end) = 1;
imsurf(1:end,end,1:end) = 1;
%% mask
imlabelb = bwlabeln(~imsurf);
for i=1:max(imlabelb(:))
    stats = regionprops(imlabelb==i,'Centroid');
    cent = stats(1).Centroid;
    x(i) = round(cent(1));
    y(i) = round(cent(2));
    z(i) = round(cent(3));
end
%% masking
idx = find(y==max(y));
immask = imlabelb==idx;
imths = immultiply(immask,imth);
%% grow
grow = bwdistsc(imths,[dx,dy,dz]) < 28;
imths = grow .* imth;
%% filter
cc = bwconncomp(imths);
imths = bwareaopen(imths, max(cellfun(@length, cc.PixelIdxList)));
return

function [diametersmax,diametersmin,meridianangle,location] = slicediameter3d(m,n,rx,ry,rz,im,x,y,z)
%%  This is calculating diameter each slice
%% lopp
diametermax = zeros(1,length(m:n));
diametermin = zeros(1,length(m:n));
angle = zeros(1,length(m:n));
for j=m:n
    d = [rx(j-1),ry(j-1),rz(j-1)]-[rx(j),ry(j),rz(j)]; 
    impm = imageplaneperpline3d(im,[rx(j),ry(j),rz(j)],d,x,y,z,1);
    %% 
    v1 = squeeze(max(impm,[],1));
%     v1 = bwmorph(v1,'bridge');
    cc = bwconncomp(v1);
    v1 = bwareaopen(v1, max(cellfun(@length, cc.PixelIdxList)));
    v = imrotate(v1,90,'bilinear');
    v = flipdim(v,1);
    stats = regionprops('table',v,'Centroid', 'MajorAxisLength','MinorAxisLength','Orientation');
    diametermax(j) = stats.MajorAxisLength;
    diametermin(j) = stats.MinorAxisLength;
    angle(j) = stats.Orientation;
end
[value, idx] = min(diametermax(m:n));
diametersmax = value;
diametersmin = diametermin(m+idx-1);
meridianangle = angle(m+idx-1);
location = (m+idx-1);
end
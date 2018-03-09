function diameters = slicediameter3d(m,n,xl,ry,rz,im,x,y,z,d)
%%  This is calculating diameter each slice
%% lopp
diameters = zeros(1,length(m:n));
for j=m:n
    impm = imageplaneperpline3d(im,[xl(j),ry(j),rz(j)],d,x,y,z,1);
    v = squeeze(max(impm,[],1));
    stats = regionprops('table',v,'Centroid', 'MajorAxisLength','MinorAxisLength');
    diameters(j) = stats.MajorAxisLength;
end
end
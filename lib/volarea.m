function [volume,surfacearea,MLD_area,BD_area,TP_area] = volarea(immhs,mld,bs,tp,s)
scales = [s s s];
im = resize3d(logical(immhs),scales);
volume = sum(im(:));
surfacearea = imSurface(im);
scale2d = [s s];
mld = resize2d(mld,scale2d);
mld = imfillmh(mld);
MLD_area = sum(mld(:));
bs = resize2d(bs,scale2d);
bs = imfillmh(bs);
BD_area = sum(bs(:));
tp = resize2d(tp,scale2d);
tp = imfillmh(tp);
TP_area = sum(tp(:));
end


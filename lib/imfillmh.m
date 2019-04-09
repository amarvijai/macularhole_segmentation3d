function im = imfillmh(im)
%% filter
    cc = bwconncomp(im);
    im = bwareaopen(im, max(cellfun(@length, cc.PixelIdxList)));
    cc = bwconncomp(~im);
    im = ~bwareaopen(~im, max(cellfun(@length, cc.PixelIdxList)));
end


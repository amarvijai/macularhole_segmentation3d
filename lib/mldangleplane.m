function [mldelevationangle1,mldelevationangle2] = mldangleplane(mldplane)
    bsxy = squeeze(max(mldplane,[],3));
    bsxy = bwmorph(bsxy,'bridge');
    [mldelevationangle1] = mldelevation(bsxy);
    bszy = squeeze(max(mldplane,[],2));
    bszy = bwmorph(bszy,'bridge');
    [mldelevationangle2] = mldelevation(bszy);
end


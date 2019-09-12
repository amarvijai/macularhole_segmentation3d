function [mldelevationangle] = mldelevation(im)
%% mld start
    [x,y] = ind2sub(size(im),find(im==1));
    loc1 = min(y);
    thiscolbs1 = im(:, loc1);
    startcolbs1 = find(thiscolbs1, 1, 'first');
    endcolbs1 = find(thiscolbs1, 1, 'last');
    startx = loc1;
    starty = endcolbs1;
%% mld end
    loc2 = max(y);
    thiscolbs2 = im(:, loc2);
    startcolbs2 = find(thiscolbs2, 1, 'first');
    endcolbs2 = find(thiscolbs2, 1, 'last');
    endx = loc2;
    endy = endcolbs2;
%% length
    lengthx = loc2 - loc1 + 1;
    lengthy = endcolbs2 - endcolbs1 + 1;
%% angle
    mldelevationangle = atan2d(-lengthy,lengthx);
end


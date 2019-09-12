function [startx,starty,endx,endy,lengthbase,lengthbase1,lengthbase2,base,baseposition,sloppyangle1,sloppyangle2] = baselengthplaneall(immhs,baseplane)
    bsxy = squeeze(max(baseplane,[],3));
    bsxy = bwmorph(bsxy,'bridge');
    [startx1,starty1,endx1,endy1,lengthbase1,sloppyangle1] = baselength(bsxy);
    bszy = squeeze(max(baseplane,[],2));
    bszy = bwmorph(bszy,'bridge');
    [startx2,starty2,endx2,endy2,lengthbase2,sloppyangle2] = baselength(bszy);
    if lengthbase1 > lengthbase2
        lengthbase = lengthbase1;
        startx = startx1;
        starty = starty1;
        endx = endx1;
        endy = endy1;
        base = squeeze(max(immhs,[],3));
        baseposition = 0;
        sloppyangle = sloppyangle1;
    else
        lengthbase = lengthbase2;
        startx = startx2;
        starty = starty2;
        endx = endx2;
        endy = endy2;
        base = squeeze(max(immhs,[],2));
        baseposition = 90;
        sloppyangle = sloppyangle2;
    end
end


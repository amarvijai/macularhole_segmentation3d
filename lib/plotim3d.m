function plotim3d(im,phi,z)
%%  This is 3d plotting for 3d image result
%   INPUT:
%       im      - 3D gray image
%       phi     - 3D image segmented
%       z       - slice position
%
%   OUTPUT:
%       3D image segmented plot with selected image as a background
%      
%   USAGE:
%      Plotting of 3D segmentation
%
%
c = isosurface(phi, 0);
imshow(im(:,:,z),'InitialMagnification','fit'); 
patch(c,'FaceColor', [0.45 0.75 0.45], 'EdgeColor', 'none'); 
view(3); daspect([1 1 1]); axis('vis3d');
lightangle(150,50); lighting gouraud;
end


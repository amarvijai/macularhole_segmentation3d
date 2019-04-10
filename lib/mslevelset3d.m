function [phi] = mslevelset3d(I,x,y,z,r,nu,sigma,n,sx,sy,sz)
%% This is the Multi-Scale of Level Set 3D Segmentation
%   
%   INPUT:
%       I       - 3D gray image
%       x, y, z - voxel point position with radius (r)
%       nu      - lengterm Constant
%       sigma   - pixel size of the kernel
%       s       - number of 3D image scale down, default is 3 (1/2^(n-1))
%       sx,sy,sz- scaling factor
%
%   OUTPUT:
%       phi  - 3D image segmented 
%      
%   USAGE:
%      3D Multi-Scale of Level set segmentation
%
%   AUTHOR:
%       Amar V Nasrulloh
%
%   VERSION:
%       1.0 - 16/05/2016 First implementation
%
%   Example:
%       ims = zeros(200,200,49);
%       ims(:,:,:) = 0;
%       ims(71:200,:,:)=1;
%       ims(71:160,71:130,15:35)=0;
%       im = double(uint8(255 * ims));
%       im = imnoise(im, 'gaussian', 0, 0.001);
%       im = imnoise(im,'speckle');
%       im = (im - min(im(:))) / (max(im(:)) - min(im(:))); % normalize 
%       x= 25; y = 30; z = 25; r = 7;
%       sigma = 4;                                                          
%       nu = 39;                                                            
%       s = 3;                                                              
%       nx = s;                                                             
%       ny = s;                                                              
%       nz = 1;
%       phi = mslevelset3d(im,x,y,z,r,nu,sigma,s,sx,sy,sz);
%
%   Requirement:
%     1. mslevelset3d.m
%     2. levelset3d.m
%     3. bm4d.m from:
%       [1] M. Maggioni, V. Katkovnik, K. Egiazarian, A. Foi, "A Nonlocal
%           Transform-Domain Filter for Volumetric Data Denoising and
%           Reconstruction", IEEE Trans. Image Process., vol. 22, no. 1, 
%           pp. 119-133, January 2013.  doi:10.1109/TIP.2012.2210725
%
%       [2] M. Maggioni, A. Foi, "Nonlocal Transform-Domain Denoising of 
%           Volumetric Data With Groupwise Adaptive Variance Estimation", 
%           Proc. SPIE Electronic Imaging 2012, San Francisco, CA, USA, Jase Diameter newan. 2012.

%%
for i=1:n
    if i == 1 
        sigmai = (i+1) * sigma/(n + 1);
        nui = (i+3) * nu/(n + 3);
        s = [sx(i),sy(i),sz(i)];
        In = resize3d(I,s);
        In = (In - min(In(:))) / (max(In(:)) - min(In(:))); % normalize
        I_w = bm4d(In, 'Gauss');
        %% phi init
        [height, wide, depth] = size(In);
        [XX, YY, ZZ] = meshgrid(1:wide,1:height, 1:depth);
        phi = (sqrt(((XX - x).^2 + (YY - y).^2 + (ZZ - z).^2 )) - r);
        phi = sign(phi).*2;
        %% levelset
        phi = levelset3d(I_w,phi,nui,sigmai,0);
    else
        sigmai = (i+1) * sigma/(n+1);
        nui = (i+3) * nu/(n+3);
        s = [sx(i),sy(i),sz(i)];
        Ii = resize3d(I,s);
        rs = [2,2,1];
        phi = resize3d(phi,rs);
        %% levelset
        phi = levelset3d(Ii,phi,nui,sigmai,1);
    end
end
end


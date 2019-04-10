function phi = levelset3d(I,phi,nu,sigma,init)
%%  This is 3d levelset segmentation
%   INPUT:
%       I       - 3D gray image
%       x, y, z - voxel point position with radius (r)
%       nu      - Lengterm Constant
%       sigma   - pixel size of the kernel
%       
%   OUTPUT:
%       phi  - 3D image segmented 
%       C    - Curvature of phi == 0
%
%   USAGE:
%      3D Level set segmentation
%
%   AUTHOR:
%       Amar V Nasrulloh, Chris Wilcocks, Phil Jackson
%
%   VERSION:
%       1.0 - 16/05/2016 First implementation
%
%   REFERENCE:
%       Li Wang, Lei He, Arabinda Mishra, Chunming Li. 
%       Active Contours Driven by Local Gaussian Distribution Fitting Energy.
%       Signal Processing, 89(12), 2009,p. 2435-2447
% 
%   Requirement:
%       gauss3filter.m
%       Max W. K. Law and Albert C. S. Chung, "Efficient Implementation for Spherical Flux Computation and Its Application to Vascular Segmentation",
%       IEEE Transactions on Image Processing, 2009, Volume 18(3), 596�V612

%% 
epsilon = 1;
lambda1 = 1.0;
lambda2 = 1.04;
mu = 1;
ONE = ones(size(I));
KONE = gauss3filter(ONE, sigma);  
KI = gauss3filter(I,sigma);  
KI2 = gauss3filter(I.^2,sigma); 
c = 1;
%% loop
n = 1;
while c > 0
    if init==0
        if mod(n,10)==1
            phi1 = phi;
        end
    else
        phi1 = phi;
    end

    [nrow,ncol,nlayer] = size(phi);
    coords = (1:numel(phi))';
    [II, JJ, KK] = ind2sub(size(phi), coords);
    coords = [II, JJ, KK];

    coords(coords(:,1)==1, 1) = coords(coords(:,1)==1, 1) + 2;
    coords(coords(:,1)==nrow, 1) = coords(coords(:,1)==nrow, 1) - 2;
    coords(coords(:,2)==1, 2) = coords(coords(:,2)==1, 2) + 2;
    coords(coords(:,2)==ncol, 2) = coords(coords(:,2)==ncol, 2) - 2;
    coords(coords(:,3)==1, 3) = coords(coords(:,3)==1, 3) + 2;
    coords(coords(:,3)==nlayer, 3) = coords(coords(:,3)==nlayer, 3) - 2;

    coords = sub2ind(size(phi), coords(:,1), coords(:,2), coords(:,3));
    phi = reshape(phi(coords), [nrow, ncol, nlayer]);

    [bdx,bdy,bdz]=gradient(phi);
    mag_bg=sqrt(bdx.^2+bdy.^2+bdz.^2)+1e-10;
    nx = bdx./mag_bg;
    ny = bdy./mag_bg;
    nz = bdz./mag_bg;
    [nxx,nxy,nxz]=gradient(nx);
    [nyx,nyy,nyz]=gradient(ny);
    [nzx,nzy,nzz]=gradient(nz);
    K = nxx+nyy+nzz;

    H=0.5*(1+(2/pi)*atan(phi./epsilon));

    Delta =(epsilon/pi)./(epsilon^2.+phi.^2);

    KIH = gauss3filter((H.*I),sigma);
    KH = gauss3filter(H,sigma);
    u1 = KIH./(KH);
    u2 = (KI - KIH)./(KONE - KH);

    KI2H = gauss3filter(I.^2.*H,sigma);

    sigma1 = (u1.^2.*KH - 2.*u1.*KIH + KI2H)./(KH);
    sigma2 = (u2.^2.*KONE - u2.^2.*KH - 2.*u2.*KI + 2.*u2.*KIH + KI2 - KI2H)./(KONE-KH);

    sigma1 = sigma1 + eps;
    sigma2 = sigma2 + eps;


    localForce = (lambda1 - lambda2).*KONE.*log(sqrt(2*pi)) ...
        + gauss3filter(lambda1.*log(sqrt(sigma1)) - lambda2.*log(sqrt(sigma2)) ...
        +lambda1.*u1.^2./(2.*sigma1) - lambda2.*u2.^2./(2.*sigma2) ,sigma)...
        + I.*gauss3filter(lambda2.*u2./sigma2 - lambda1.*u1./sigma1,sigma)...
        + I.^2.*gauss3filter(lambda1.*1./(2.*sigma1) - lambda2.*1./(2.*sigma2) ,sigma);

    A = -20.*Delta.*localForce;
    P = mu*(4*del2(phi) - K);
    L = nu.*Delta.*K;
    phi = phi+0.1*(L+P+A);
    
    if init==0
        if mod(n,10)==0
            c = abs(sum(phi1(:)> 0) - sum(phi(:)> 0));
        end
    else
        c = abs(sum(phi1(:)> 0) - sum(phi(:)> 0));
    end
    n = n + 1;
end
end


function imp = imageplaneperpline3d(im,p,d,x,y,z,t)
%% plane perpendicular to the line
s1 = -0.5; s2 = 0.5;
p1 = [p(1) + s1*d(1), p(2) + s1*d(2), p(3) + s1*d(3)];
p2 = [p(1) + s2*d(1), p(2) + s2*d(2), p(3) + s2*d(3)];
plane = medianPlane(p1,p2);
%% plane-Point distance
pd = zeros(length(x),1);
for i=1:length(x)
    pd(i) = distancePointPlane([x(i),y(i),z(i)],plane);
end
idx = abs(pd)<t;
imp = zeros(size(im));
imp(sub2ind(size(imp),x(idx),y(idx),z(idx))) = 1;
end
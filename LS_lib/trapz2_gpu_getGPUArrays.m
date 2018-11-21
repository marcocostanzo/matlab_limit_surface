function [ X , Y , xspacing, yspacing ] = trapz2_gpu_getGPUArrays( xmin, xmax, ymin, ymax, N )
%UNTITLED Get inputs for GPU integration

xvals = gpuArray.linspace(xmin, xmax, N);
yvals = gpuArray.linspace(ymin, ymax, N);
[X, Y] = meshgrid(xvals, yvals);
xspacing = (xmax - xmin)/N;
yspacing = (ymax - ymin)/N;


end


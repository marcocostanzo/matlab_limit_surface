function [ X , Y , xspacing, yspacing ] = trapz2_gpu_getGPUArrays( xmin, xmax, ymin, ymax, N )
%TRAPEZ2_GPU_GETGPUARRAYS internal function to generate integrals domains
%[X,Y,xspacing,yspacing] = trapz2_gpu_getGPUArrays(xmin,xmax,ymin,ymax,N)

% Copyright 2018 Università della Campania Luigi Vanvitelli
% Author: Marco Costanzo <marco.costanzo@unicampania.it>
%
% This file is part of matlab_limit_surface by Marco Costanzo
% https://github.com/marcocostanzo/matlab_limit_surface
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% https://github.com/marcocostanzo

xvals = gpuArray.linspace(xmin, xmax, N);
yvals = gpuArray.linspace(ymin, ymax, N);
[X, Y] = meshgrid(xvals, yvals);
xspacing = (xmax - xmin)/N;
yspacing = (ymax - ymin)/N;


end


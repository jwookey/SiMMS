% SIS_CREATE_VRAYS
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
% [Rays] = SiS_create_VRays(Model, RList, dz)
%
%  Create a set of vertical rays from a list of receiver locations.
%  (3-col matrix, rx, ry, rz)
%  rx, and ry should be within the model. rz may (or may not) be. 
%  dz is the stepsize in the ray.
%  Source is assumed to be the bottom of the model.

% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

function [Rays] = SiS_create_VRays(Model, RList, dz)
%  Create a set of vertical rays from a list of receiver locations 
%  (3-col matrix, rx, ry, rz)
%  rx, and ry should be within the model. rz may (or may not) be. 
%  dz is the stepsize in the ray

xmin = min(Model(:,1)); xmax = max(Model(:,1)) ;   
ymin = min(Model(:,2)); ymax = max(Model(:,2)) ;   
zmin = min(Model(:,3)); zmax = max(Model(:,3)) ;   

[nRay,ndum] = size(RList) ;

%  Build rays to go from the maximum depth of the model

ii = 0 ;

for iRay = 1:nRay
   if RList(iRay,1)>xmin & RList(iRay,1)<xmax & ...
      RList(iRay,2)>ymin & RList(iRay,2)<ymax 
      
      ii = ii+1 ;
      npts = length([zmin:dz:RList(iRay,3)]) ;
      Rays(ii).z = [zmin:dz:RList(iRay,3)] ;
      Rays(ii).x = zeros(1,npts)+RList(iRay,1) ;
      Rays(ii).y = zeros(1,npts)+RList(iRay,2) ;
   else
      warning('Receiver outside the model - ignored.')
   end   
end   
     
return

%-------------------------------------------------------------------------------
%
%  This software is distributed under the term of the BSD free software license.
%
%  Copyright:
%     (c) 2003-2012, James Wookey, University of Bristol
%
%  All rights reserved.
%
%   Redistribution and use in source and binary forms, with or without
%   modification, are permitted provided that the following conditions are met:
%        
%   * Redistributions of source code must retain the above copyright notice,
%     this list of conditions and the following disclaimer.
%        
%   * Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in the
%     documentation and/or other materials provided with the distribution.
%     
%   * Neither the name of the copyright holder nor the names of its
%     contributors may be used to endorse or promote products derived from
%     this software without specific prior written permission.
%
%
%   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
%   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
%   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
%   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
%   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
%   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
%-------------------------------------------------------------------------------

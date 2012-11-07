% SIS_CREATE_RAYS
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
% [Rays] = SiS_create_Rays(Model, RList, SList, ds)
%
%  Create a set of straight rays from a list of source locations, to a list of receiver
%  locations.
%
%  Receivers: (3-col matrix, rx, ry, rz)
%     rx, and ry should be within the model. rz may (or may not) be. 
%  Sources:   (3-col matrix, rx, ry, rz)
%  sx, sy and sz should be within the model.
%  dz is the stepsize in the ray
%

% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

function [Rays] = SiS_create_Rays(Model, RList, SList, dz)

xmin = min(Model(:,1)); xmax = max(Model(:,1)) ;   
ymin = min(Model(:,2)); ymax = max(Model(:,2)) ;   
zmin = min(Model(:,3)); zmax = max(Model(:,3)) ;   

[nRec,~] = size(RList) ;
[nSrc,~] = size(SList) ;

nRay = nRec * nSrc ;

%  Build rays to go from the source to the receiver.

ii = 0 ;

for iRec = 1:nRec 
      if RList(iRec,1)>xmin & RList(iRec,1)<xmax & ...
         RList(iRec,2)>ymin & RList(iRec,2)<ymax 
         for iSrc = 1:nSrc
            if SList(iSrc,1)>xmin & SList(iSrc,1)<xmax & ...
               SList(iSrc,2)>ymin & SList(iSrc,2)<ymax & ...
               SList(iSrc,3)>zmin & SList(iSrc,3)<zmax
         
               ii = ii+1 ;
               %% DO A RAY HERE.

               Rays(ii).xRec = RList(iRec,1) ;
               Rays(ii).yRec = RList(iRec,2) ;
               Rays(ii).zRec = RList(iRec,3) ;

               Rays(ii).xSrc = SList(iSrc,1) ;
               Rays(ii).ySrc = SList(iSrc,2) ;
               Rays(ii).zSrc = SList(iSrc,3) ;

               % calculate number of points (from Z distance travelled)
               
               % assign x,y,z arrays (using linspace)

               npts = length([SList(iSrc,3):dz:RList(iRec,3)]) ;
               
               Rays(ii).x = linspace(SList(iSrc,1),RList(iRec,1),npts) ;
               Rays(ii).y = linspace(SList(iSrc,2),RList(iRec,2),npts) ;
               Rays(ii).z = linspace(SList(iSrc,3),RList(iRec,3),npts) ;
               
               %% calculate receiver backazimuth
               
               
               Rays(ii).baz = -SiS_unwind_pm_180( ...
                  atan2((SList(iSrc,2)-RList(iRec,2)), ... % dY
                        (SList(iSrc,1)-RList(iRec,1))) ... % dX
                  .*180/pi) ;
                  
               %% calculate angle from vertical   
               Rays(ii).afv = abs(atan(sqrt( ...
                                   (SList(iSrc,1)-RList(iRec,1)).^2  + ... %dX
                                   (SList(iSrc,2)-RList(iRec,2)).^2)./ ... %dY
                                   (SList(iSrc,3)-RList(iRec,3)) ... %dZ
                              ).*180/pi) ;
                  
            else
               warning('Source outside the model - ignored.')
            end   
         end   
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

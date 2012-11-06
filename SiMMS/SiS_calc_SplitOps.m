% SIS_CALC_SPLITOPS
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
% Calculate Splitting Operators for a set of rays through an elastic model.  
%
% [SplitOps] = SiS_calc_SplitOps(InterpF, Elastic, Rays, MinAniZ, isoClass)
% Inputs:
%    InterpF  : interpolator structure to access the grid (see SiS_create_InterpF.m) 
%    Elastic  : table of elastic constants (matrix)
%    Rays     : structure containing a set of raypaths through the model (see, e.g, 
%               SiS_create_VRays).
%    MinAniZ  : cut-off anisotropy Z (anisotropy is suppressed below here) (float)
%    isoClass : index of class representing isotropy (integer)
%

% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

function [SplitOps] = SiS_calc_SplitOps(InterpF, Elastic, Rays, MinAniZ, isoClass)
%
%    
%
   nRay = length(Rays)
   for iRay = 1:length(Rays)

%     Loop over points in the raypath, calculate the splitting operator
      iRay
      iPtC = 0 ;
      nPts = length(Rays(iRay).x) ;
      
      SplitOps(iRay).x = Rays(iRay).x(end) ;
      SplitOps(iRay).y = Rays(iRay).y(end) ;      

      SplitOps(iRay).tlag = [] ;
      SplitOps(iRay).fast = [] ;
      
      for iPt = 1:length(Rays(iRay).x)-1
      
%     ** extract geometrical information      
         x1 = Rays(iRay).x(iPt) ;  x2 = Rays(iRay).x(iPt+1) ;
         y1 = Rays(iRay).y(iPt) ;  y2 = Rays(iRay).y(iPt+1) ;
         z1 = Rays(iRay).z(iPt) ;  z2 = Rays(iRay).z(iPt+1) ;

%     ** segment details
         dist = sqrt((x2-x1).^2+(y2-y1).^2+(z2-z1).^2) ;

         mx = x1+(x2-x1)./2 ;  
         my = y1+(y2-y1)./2 ; 
         mz = z1+(z2-z1)./2 ; 
         
         if mz >= MinAniZ
            azi = atan2((x2-x1),(y2-y1)).*180/pi ;
      	   inc = atan((z2-z1)./sqrt((x2-x1).^2+(y2-y1).^2)).*180/pi ;      
      
%        ** interpolate elastic constants to the midpoint
            CC = zeros(6,6) ;
            icc = InterpF(mx,my,mz) ;
            
            if icc~=isoClass
               ind_icc = find(Elastic(:,1)==icc) ;
               
               if ~isnan(icc) & ~isempty(ind_icc) ;
                  iPtC = iPtC + 1; 
                  iec = 0;
                  for ii=1:6
                     for jj=ii:6
                        iec = iec+1 ;
                        CC(ii,jj) = Elastic(ind_icc,iec+1) ;
                        if ii~=jj, CC(jj,ii) = CC(ii,jj);, end ;
                     end
                  end
                  rho = Elastic(ind_icc,23) ;

                  [pol,avs,vs1,vs2,vp] = MS_phasevels(CC,rho,inc,azi) ;
                  
%              ** calculate the splitting   
                  ts1 = dist./vs1 ;
                  ts2 = dist./vs2 ;
                  tlag = abs(ts1-ts2) ;
                  
                  SplitOps(iRay).tlag(iPtC) = tlag ;
                  SplitOps(iRay).fast(iPtC) = pol ;
               else
%                 ignore this segment            
               end
            end   
         else
%           ignore this segment            
         end
         
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

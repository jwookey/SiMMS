% SIS_PLOT_SPLITTING_MAP
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
%  Plot splitting operators in map view.
%
%  [] = SiS_plot_splitting_map(Model, SplitOps, Rays, ...)
%
%  Inputs:
%     SplitOps : Structure containing the splitting operators 
%                (see SiS_calc_SplitOps). Fast directions are assumed to be 
%                geographical. 
%     Rays     : Structure containing the raypaths
%                (see SiS_calc_Rays).
%  (Optional)
%     'receiver' or 'rec' : (default) plot at receiver.
%     'source' or 'src'   : plot at source. 
%     'midpoint' or 'mid' : plot at midpoint (by depth).
% 

% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

function [] = SiS_plot_splitting_map(Model, SplitOps, Rays, varargin)

   xmin = min(Model(:,1)); xmax = max(Model(:,1)) ;   
   ymin = min(Model(:,2)); ymax = max(Model(:,2)) ;   
   zmin = min(Model(:,3)); zmax = max(Model(:,3)) ;   
   
%   SplitOpsOut = SplitOps ;
%   nRay = length(SplitOps) ;
%   for iRay = 1:nRay
%      SplitOpsOut(iRay).fast = Rays(iRay).baz - SplitOps(iRay).fast ;
%      SplitOpsOut(iRay).fast = SiS_unwind_pm_90(SplitOpsOut(iRay).fast) ;
%      
%   end
   

      pmode = 0  ;
%  ** process the optional arguments
      iarg = 1 ;
      while iarg <= (length(varargin))
         switch lower(varargin{iarg})
            case {'receiver','rec'}  
               pmode = 0 ;
               iarg = iarg + 1 ;
            case {'source','src'} 
               pmode = 1 ;
               iarg = iarg + 1 ;
            case {'midpoint','mid'}
               pmode = 2 ;
               iarg = iarg + 1 ;
            otherwise 
               error(['Unknown option: ' varargin{iarg}]) ;   
         end   
      end 

%  ** generate location vectors
      if pmode==0
         xx = [Rays.xRec] ;
         yy = [Rays.yRec] ;
      elseif pmode==1
         xx = [Rays.xSrc] ;
         yy = [Rays.ySrc] ;
      else    
         xx = [Rays.xSrc]+([Rays.xRec]-[Rays.xSrc])/2 ;
         yy = [Rays.ySrc]+([Rays.yRec]-[Rays.ySrc])/2 ;
      end

%  ** generate splitting vectors
      scalef = 20.0 ;
      q = scalef.*[SplitOps.tlag].*cosd([SplitOps.fast]) ;
      r = -scalef.*[SplitOps.tlag].*sind([SplitOps.fast]) ;

%  ** make the figure
      figure
      plot(xx,yy,'ko','MarkerFaceColor','k') ; hold on
      quiver(xx,yy,q,r,0,'k.','LineWidth',1.5) ; 
      quiver(xx,yy,-q,-r,0,'k.','LineWidth',1.5) ;

%  ** draw model boundaries
      plot([xmin xmin xmax xmax xmin],[ymin ymax ymax ymin ymin],'r--') 

      daspect([1 1 1]) ;
      xlabel('X (km)') ;
      ylabel('Y (km)') ;
end 

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
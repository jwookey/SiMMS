% SIS_PLOT_SPLITTING_MAP
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
%  Plot splitting operators in map view. Fast directions are relative to
%  the x-axis by default. 
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
%     SiS_plot_splitting_map(...,'rec')  
%        (default) plot splitting at receiver.
%
%     SiS_plot_splitting_map(...,'src')  
%        plot splitting at source.
%
%     SiS_plot_splitting_map(...,'mid')  
%        plot splitting at midpoint (by depth).
%
%     SiS_plot_splitting_map(...,'scale',MpS)  
%        set the tlag plotting scale (km per second
%        of splitting). This defaults to 10% of the maximum
%        X extent of the model at the reference splitting time.
%
%     SiS_plot_splitting_map(...,'NoScaleBar')  
%        Suppress the tlag scalebar.
%
%     SiS_plot_splitting_map(...,'FDRefAxis',AxisStr)  
%        Set the reference axis for fast directions. Must be 'x' or 'y',
%        default is 'x'.
%

% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

function [] = SiS_plot_splitting_map(Model, SplitOps, Rays, varargin)

   xmin = min(Model(:,1)); xmax = max(Model(:,1)) ;   
   ymin = min(Model(:,2)); ymax = max(Model(:,2)) ;   
   zmin = min(Model(:,3)); zmax = max(Model(:,3)) ;   
   
      pmode = 0  ;
      ScaleBar = 1 ;
      scalef = NaN ;
      AxisStr = 'X' ;

%  ** process the optional arguments
      iarg = 1 ;
      while iarg <= (length(varargin))
         switch lower(varargin{iarg})
            case {'noscalebar'}
               ScaleBar = 0 ;
               iarg = iarg + 1 ;  
            case {'receiver','rec'}  
               pmode = 0 ;
               iarg = iarg + 1 ;
            case {'source','src'} 
               pmode = 1 ;
               iarg = iarg + 1 ;
            case {'midpoint','mid'}
               pmode = 2 ;
               iarg = iarg + 1 ;
            case {'scale'}
               scalef = varargin{iarg+1} ;
               iarg = iarg + 2 ;
            case {'fdrefaxis'}
               AxisStr = varargin{iarg+1} ;
               iarg = iarg + 2 ;
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
         
%     calculate an appropriate reference splitting time
      [ref_tlag,ref_str] = timescale([SplitOps.tlag]) ;

      if isnan(scalef)
         %scalef=0.1*(xmax-xmin) ; % note, this is for half the vector.

         scalef=0.1*(xmax-xmin)./ref_tlag ;

      end   

%  ** shift fast directions if necessary 
      switch lower(AxisStr)
      case 'x'  
         q = 0.5*scalef.*[SplitOps.tlag].*cosd([SplitOps.fast]) ;
         r = -0.5*scalef.*[SplitOps.tlag].*sind([SplitOps.fast]) ;
      
      case 'y'
         q = 0.5*scalef.*[SplitOps.tlag].*sind([SplitOps.fast]) ;
         r = 0.5*scalef.*[SplitOps.tlag].*cosd([SplitOps.fast]) ;
      otherwise
         error('FDRefAxis AxisStr argument must be ''x'' or ''y''') ;   
      end   

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
      

%  ** if necessary, plot a scale bar.
      if ScaleBar
         
         xSB = xmin + 2.* ref_tlag*0.5*scalef ;
         ySB = ymin + (ymax-ymin)*0.1  ;
         
         xf1 = xmin + 0.5* ref_tlag*0.5*scalef ;
         xf2 = xmin + 3.5* ref_tlag*0.5*scalef ;
         yf1 = ymin + (ymax-ymin)*0.05  ;
         yf2 = ymin + (ymax-ymin)*0.2  ;
         
         plot([xf1 xf2 xf2 xf1 xf1],[yf1 yf1 yf2 yf2 yf1],'k-')
         
         plot(xSB,ySB,'ko','MarkerFaceColor','k') ; hold on
         quiver(xSB,ySB,ref_tlag*0.5*scalef,0,0,'k.','LineWidth',1.5) ;
         quiver(xSB,ySB,-ref_tlag*0.5*scalef,0,0,'k.','LineWidth',1.5) ;
         
         text(xSB,ySB+(ymax-ymin)*0.02,ref_str,...
         'HorizontalAlignment','Center','VerticalAlignment','Bottom') ;
      end 
      
end 

function [refScale,refScaleStr] = timescale(Values) 

   % use the mean value as the initial reference
   
   mv = mean(Values) ;
   
   refs=[0.1e-6,0.2e-6,0.5e-6,1.0e-6,2.0e-6,5.0e-6,10.0e-6,20.0e-6,50.0e-6,0.1e-3,...
         0.2e-3,0.5e-3,1e-3,2e-3,5e-3,1e-2,2e-2,5e-2,1e-1,2e-1,5e-1,1e-0,2e-0,...
         5e-0,10,20,50,100,200,500,1000,2000,5000,10000,20000,50000,100000,200000,...
         500000,1000000,2000000,5000000] ;
   
   [~,i2] = min(abs(refs-mv)) ;
   
   refScale = refs(i2) ;
   
   refStrings = {'0.1\mus','0.2\mus','0.5\mus','1.0\mus','2\mus','5\mus',...
                 '10\mus','20\mus','50\mus','0.1ms','0.2ms','0.5ms',...
                 '1ms','2ms','5ms','10ms','20ms','50ms','0.1s',...
                 '0.2s','0.5s','1s','2s','5s','10s','20s','50s',...
                 '100s','200s','500s','1000s','2000s','5000s',...
                 '10000s','20000s','50000s','100000s','200000s',...
                 '500000s','1000000s','2000000s','5000000s'};
               
   refScaleStr = refStrings{i2} ;
   
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
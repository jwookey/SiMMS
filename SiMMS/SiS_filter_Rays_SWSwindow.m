% SIS_FILTER_RAYS_SWSWINDOW
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
% [Rays_out] = SiS_filter_Rays_SWSwindow(Rays_in ...)
%
%  Remove any Rays from list where the angle from the vertical at the 
%  recever is too large for SWS analysis.
%
%  Usage:
%      [Rays_out] = SiS_filter_Rays_SWSwindow(Rays_in)
%          Filter the input rays based on the default value for the 
%          window (45 degrees from vertical).
% 
%      [Rays_out] = SiS_filter_Rays_SWSwindow(Rays_in, 'SWSwindow', value)
%          Filter the input rays based on a non-default value for the 
%          window (value degrees from vertical).
%

% Copyright (c) 2012, Andrew Walker
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

function [Rays_out] = SiS_filter_Rays_SWSwindow(Rays_in, varargin)

  SWS_window = 45 ; % Degrees from vert - default

  % ** process the optional arguments
      iarg = 1 ;
      while iarg<=(length(varargin))
         switch lower(varargin{iarg})
            case 'swswindow'
               SWS_window = varargin{iarg+1};
               iarg = iarg + 2 ;
            otherwise
               error('Unknown optional argument') ;
         end
      end 
  
  i = 0;
  
  for iRay = 1:length(Rays_in)
     if (Rays_in(iRay).afv < SWS_window)
         i = i + 1;
         Rays_out(i) = Rays_in(iRay);
     end
  end
  
  if (i == 0)
      warning('All rays were outside the SWS window')
  end
end

%-------------------------------------------------------------------------------
%
%  This software is distributed under the term of the BSD free software license.
%
%  Copyright:
%     (c) 2003-2012, Andrew Walker, University of Bristol
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
%--------------------------------------------------------------------------
%-----
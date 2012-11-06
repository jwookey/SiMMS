% SIS_UNWIND_PM_90 - Unwind an angle until it is between -90 and 90 degrees
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
%  Unwind a (vector of) angles to be +/- 90 degrees. 
%  
%  [angle] = unwind_pm_90(angle_in)
%
%  This (obviously) assumes a 180 degree periodicity. Angle can be a scalar
%  or a vector. 

% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

%

%
%  Created by James Wookey on 2007-05-08.
%

function [angle] = SiS_unwind_pm_90(angle_in)
   angle = angle_in ;
   for i=1:1000 % should never reach this
      
%  ** check for completion
      ind = find(angle <= -90.0 | angle > 90.0) ;
      if isempty(ind), return, end % done

%     else refine: too small
      ind = find(angle<=-90);
      if ~isempty(ind), angle(ind) = angle(ind) + 180 ; , end    

%     and too large      
      ind = find(angle>90); 
      if ~isempty(ind), angle(ind) = angle(ind) - 180 ; , end 
   end

%  if we got to here something is probably wrong:
error('SIS_UNWIND_PM_90 completed 1000 iterations without angle reaching +/-90 deg')   
   
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

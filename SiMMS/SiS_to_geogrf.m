% SIS_TO_GEOGRF
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
%  Convert Splitting Operators to a geographical reference frame. 
%
%  [SplitOpsOut] = SiS_combine_SplitOps(SplitOps, InitPol, DFreq)
%
%  Inputs:
%     SplitOps : Structure containing the splitting operators 
%                (see SiS_calc_SplitOps)
%     InitPol  : Initial wave polarisation (in the same reference frame as the
%                fast direction in the splitting operators) (scalar, degrees)
%     DFreq    : Dominant frequency (scalar, Hz)

% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

function [SplitOpsOut] = SiS_to_geogrf(SplitOps, Rays)
   
   SplitOpsOut = SplitOps ;
   nRay = length(SplitOps) ;
   for iRay = 1:nRay
      SplitOpsOut(iRay).fast = Rays(iRay).baz - SplitOps(iRay).fast ;
      SplitOpsOut(iRay).fast = SiS_unwind_pm_90(SplitOpsOut(iRay).fast) ;
      
   end
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
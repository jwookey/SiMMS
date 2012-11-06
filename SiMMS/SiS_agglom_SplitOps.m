%-------------------------------------------------------------------------------
%
%  This software is distributed under the term of the BSD free software license.
%
%  Copyright:
%     (c) 2003-2011, James Wookey, University of Bristol 
%
%  All rights reserved. See end of file for full license terms. 
%
%-------------------------------------------------------------------------------

% AGGLOM_SPLITOPS
function [SplitOpsOut] = agglom_SplitOps(SplitOps, fast_thresh)
%
%  Agglomerate splitting operators by summing sequential tlags where the fast  
%  direction differs by less than fast_thresh
%
   nRay = length(SplitOps)
   for iRay = 1:length(SplitOps)
      nOp2 = 0 ;
      SplitOpsOut(iRay).x = SplitOps(iRay).x ;
      SplitOpsOut(iRay).y = SplitOps(iRay).y ;
      SplitOpsOut(iRay).tlag = [] ;
      SplitOpsOut(iRay).fast = [] ;
      
%  ** Loop over the splitting operators, gathering the ones which are the same
      for iOp = 1:length(SplitOps(iRay).tlag)
         if iOp==1
            fastc = SplitOps(iRay).fast(iOp) ;
            nOp2 = 1 ;
            SplitOpsOut(iRay).tlag(nOp2) = SplitOps(iRay).tlag(iOp) ;
            SplitOpsOut(iRay).fast(nOp2) = fastc ;
         else
%        ** calculate angle difference
            df = SplitOps(iRay).fast(iOp) - fastc ;
            df = unwind_pm_90(df) ;
%        ** test to see if we can agglomerate
            if (df < fast_thresh) % we can agglomerate this one
               SplitOpsOut(iRay).tlag(nOp2) = ...
                  SplitOpsOut(iRay).tlag(nOp2) + SplitOps(iRay).tlag(iOp) ;
            else % need to start a new Operator   
               nOp2 = nOp2 + 1;
               SplitOpsOut(iRay).tlag(nOp2) = SplitOps(iRay).tlag(iOp) ;
               SplitOpsOut(iRay).fast(nOp2) = SplitOps(iRay).fast(iOp) ;
               fastc = SplitOps(iRay).fast(iOp) ;
            end   
         end   
      end
   end
return

%-------------------------------------------------------------------------------
%
%  This software is distributed under the term of the BSD free software license.
%
%  Copyright:
%     (c) 2003-2011, James Wookey, University of Bristol 
%
%  All rights reserved.
%
%   * Redistribution and use in source and binary forms, with or without
%     modification, are permitted provided that the following conditions are
%     met:
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


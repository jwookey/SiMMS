% SIS_AGGLOM_SPLITOPS
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
%  Agglomerate splitting operators by summing sequential tlags where the fast  
%  direction differs by less than fast_thresh.
%
%  [SplitOpsOut] = SiS_agglom_SplitOps(SplitOps, fast_thresh)

% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

function [SplitOpsOut] = SiS_agglom_SplitOps(SplitOps, fast_thresh)
%  loop over the rays.
   for iRay = 1:length(SplitOps)
      nOp2 = 0 ;
      SplitOpsOut(iRay).x = SplitOps(iRay).x ;
      SplitOpsOut(iRay).y = SplitOps(iRay).y ;

%  ** call the mighty agglomerator.       
      [SplitOpsOut(iRay).fast,SplitOpsOut(iRay).tlag] = ...
         agglom_SplitOps(SplitOps(iRay).fast, SplitOps(iRay).tlag, fast_thresh);
      
   end
end

function [afast,atlag] = agglom_SplitOps(fast,tlag,thresh)
      atlag = [] ;
      afast = [] ;
      
%  ** Loop over the splitting operators, gathering the ones which are the same
      for iOp = 1:length(tlag)
         if iOp==1
            fastc = fast(iOp) ;
            nOp2 = 1 ;
            atlag(nOp2) = tlag(iOp) ;
            afast(nOp2) = fastc ;
         else
%        ** calculate angle difference
            df = fast(iOp) - fastc ;
            df = SiS_unwind_pm_90(df) ;
%        ** test to see if we can agglomerate
            if (abs(df) < thresh) % we can agglomerate this one
               atlag(nOp2) = atlag(nOp2) + tlag(iOp) ;
            else % need to start a new Operator   
               nOp2 = nOp2 + 1;
               atlag(nOp2) = tlag(iOp) ;
               afast(nOp2) = fast(iOp) ;
               fastc = fast(iOp) ;
            end   
         end   
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


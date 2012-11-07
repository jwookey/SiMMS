% SIS_CREATE_SYNTHETICS
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
%  Create synthetic data for (for example) SHEBA processing. Also create a handy  
%   macro to run the analysis in sheba. 
%
% SiS_create_Synthetics(SRCWav, SRCPol, SplitOps, NoiseAmp, DDir)
% Inputs:
%    SRCWav   : SAC trace structure containing the source wavelet.
%    SRCPol   : vector of source polarisations. 
%    SplitOps : structure containing a set of splitting operators to apply to the
%               data (see SiS_calc_SplitOps)
%    NoiseAmp : amplitude of noise to apply to the trace. 
%    DDir     : (pre-existing) directory to deliver the synthetic data to. 
%

% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

%FIXME: Check reference frame (need to put SRCPol into ray frame).

function SiS_create_Synthetics(SRCWav, SRCPol, SplitOps, NoiseAmp, DDir)
%   
%  Create the synthetic data for SHEBA processing. Also create a handy  
%   macro to run the analysis in sheba. 
%

   fid = fopen(sprintf('%s/run_sheba_for_all.m',DDir),'wt') ;
  
   nRays = length(SplitOps) ;
   for iRay = 1:nRays
      for iPol = 1:length(SRCPol)
      
%     ** set some header values
         STr = SRCWav ;
         STr.evdp = -500 ;
         
         STr.stla = SplitOps(iRay).x ./ 111.16e3 ;
         STr.stlo = SplitOps(iRay).y ./ 111.16e3 ;
  
         STr.evla = SplitOps(iRay).x ./ 111.16e3 ;
         STr.evlo = SplitOps(iRay).y ./ 111.16e3 ;

         STr.kstnm = sprintf('%4.4i%4.4i', ...
            round(SplitOps(iRay).x./1e3),...
            round(SplitOps(iRay).y./1e3));
      
%     ** make the initial wavelet
         [NTr,ETr,ZTr] = SiS_initSWave(STr,SRCPol(iPol),NoiseAmp) ;

         NTr.kcmpnm = 'N/X' ;
         ETr.kcmpnm = 'E/Y' ;
         ZTr.kcmpnm = 'Z/Z' ;

%     ** loop over and apply the splitting operators
         for iOp = 1:length(SplitOps(iRay).tlag)
%            fprintf('%i %f %f\n',iRay,SplitOps(iRay).fast(iOp), ...
%               SplitOps(iRay).tlag(iOp))   
            [NTr,ETr] = msac_desplit(NTr,ETr, ...
                  SplitOps(iRay).fast(iOp), -SplitOps(iRay).tlag(iOp),'fd') ;
         end

%     ** write out the files
         msac_write(sprintf('%s/Syn.%3.3i.%3.3i.BHN',...
            DDir,iRay,round(SRCPol(iPol))),NTr) ;
         msac_write(sprintf('%s/Syn.%3.3i.%3.3i.BHE',...
            DDir,iRay,round(SRCPol(iPol))),ETr) ;
         msac_write(sprintf('%s/Syn.%3.3i.%3.3i.BHZ',...
            DDir,iRay,round(SRCPol(iPol))),ZTr) ;
         
         fprintf(fid, ... 
            'm sheba pick no plot yes batch yes file Syn.%3.3i.%3.3i\n', ...
            iRay,round(SRCPol(iPol))) ;
         
      end
   end
   
   fclose(fid) 

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
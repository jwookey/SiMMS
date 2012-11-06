% SIS_INITSWAVE
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
% Create a 3-component seismic record containing the initial shear-wave pulse. 
%
% [NTr,ETr,ZTr] = SiS_initSWave(SRCWav,SRCPol,NoiseAmp)
%

% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

function [NTr,ETr,ZTr] = SiS_initSWave(SRCWav,SRCPol,NoiseAmp)
   
   if ~isscalar(SRCPol)
      error('A scalar is required for SRCPol') 
   end   

   if ~isscalar(NoiseAmp)
      error('A scalar is required for NoiseAmp') 
   end   

   
%  Initialise traces
   NTr = SRCWav ; NTr.cmpaz = 0; NTr.cmpinc = 90 ;
   ETr = SRCWav ; ETr.cmpaz = 90; ETr.cmpinc = 90 ;
   ZTr = SRCWav ; ZTr.cmpaz = 0; ZTr.cmpinc = 0 ;
   
%  Add the wavelet
   NTr.x1 = SRCWav.x1 .* cosd(SRCPol) ; 
   ETr.x1 = SRCWav.x1 .* sind(SRCPol) ; 
   ZTr.x1 = zeros(size(ZTr.x1)) ;
   
%  add noise   
   MaxAmp = max(abs(SRCWav.x1)) ;
   
   NTr.x1 = NTr.x1 + rand(size(NTr.x1)).*MaxAmp.*NoiseAmp ;
   ETr.x1 = ETr.x1 + rand(size(ETr.x1)).*MaxAmp.*NoiseAmp ;
   ZTr.x1 = ZTr.x1 + rand(size(ZTr.x1)).*MaxAmp.*NoiseAmp ;

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

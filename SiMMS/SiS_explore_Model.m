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

function explore_Model(Model, Elastic, InterpF)
%  explore the uploaded model

% basics first

fprintf('Model has %i nodes.\n',length(Model)) ;   
fprintf('X direction: %f to %f.\n',min(Model(:,1)),max(Model(:,1))) ;   
fprintf('Y direction: %f to %f.\n',min(Model(:,2)),max(Model(:,2))) ;   
fprintf('Z direction: %f to %f.\n',min(Model(:,3)),max(Model(:,3))) ;   
   

%plot3(Model(1:100:end,1),Model(1:100:end,2),Model(1:100:end,3),'k.') ;

mx = 100e3
my = 10e3
mz = -100e3


%  ** interpolate elastic constants to the midpoint
      CC = zeros(6,6) ;
      icc = InterpF(mx,my,mz) ;
      
      ind_icc = find(Elastic(:,1)==icc) ;
      
      if ~isnan(icc) & ~isempty(ind_icc) ;
         iec = 0;
         for ii=1:6
            for jj=ii:6
               iec = iec+1 ;
               CC(ii,jj) = Elastic(ind_icc,iec+1) ;
               if ii~=jj, CC(jj,ii) = CC(ii,jj);, end ;
            end
         end
         rho = Elastic(ind_icc,23) * 1e3 ;
         CC = CC.*1e8./(rho./1e3) ;

         CC
         rho

      else
         fprintf('Isotropic\n') ;
      end

return

%-------------------------------------------------------------------------------
%
%  This software is distributed under the term of the BSD free software license.
%
%  Copyright:
%     (c) 2003-2011, James Wookey
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

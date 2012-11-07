% BUILD_SIMPLE_MODEL
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
% This script builds description files needed for SiMMS for a simple 
% anisotropic model.
%
% The model (side view) looks like:
%
%                             X
%        -100                 0                 100
%        0 |-------------------------------------|
%          |                 (0)                 |
%     -100 |-------------------------------------|     X3
%          |                  |                  |     ^
%   Z -200 |                  |                  |     | 
%          |        (1)       |        (2)       |     O-->X1
%     -300 |                  |                  |
%          |                  |                  |
%     -400 |-------------------------------------|
%
% Top view:
%
%                Y
%         50     0    -50
%      100 |-----------|
%          |           |
%          |           |
%       50 |           |          X1
%          |           |          ^
%          |           |          | 
%     X  0 |    (0)    |     X2<--O
%          |           |
%          |           |
%      -50 |           |
%          |           |
%          |           |
%     -100 |-----------|
%
%
%  X, Y and Z axes coincide with the X1,X2 and X3 elastic tensor principle
%  axes. Distances are in km. 
%
%  Region (0) is isotropic. This doesn't need specification in the model. 
%  Region (1) is 10% single crystal olivine with A-axis aligned in the 
%             X-direction
%  Region (2) is 10% single crystal olivine with A-axis aligned in the 
%             Y-direction
%
% Copyright (c) 2003-2012, James Wookey, University of Bristol
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

function build_simple_model()

   % setup the grid
   X = [-100:10:100] ; nX = length(X) ;
   Y = [ -50:10:50]  ; nY = length(Y) ;
   Z = [-400:10:0]   ; nZ = length(Z) ;
   
   % output the grid description file
   fprintf('Creating %u node model file\n',nX*nY*nZ)
   fid=fopen('SM_table.dat','wt') ;
   aclass = 0 ;
   for iZ=1:nZ
      for iY=1:nY
         for iX=1:nX
            if Z(iZ)>-100
               % isotropic class
               aclass = 0 ;   
            else
               if X(iX)<0 
                  % 2 X-parallel olivine
                  aclass = 1 ;
               else
                  % 3 X-perpendicular olivine
                  aclass = 2 ;
               end
               % output
            end % if Z(iZ)>-100
            fprintf(fid,'%8.2f %8.2f %8.2f %2.2u\n',X(iX),Y(iY),Z(iZ),aclass) ;
         end % for iX=1:nX
      end % iY=1:nY
   end % for iZ=1:nZ
   fclose(fid) ;

%  generate the elastic tensors
   [Craw,rh] = MS_elasticDB('Ol') ;

%  dilute (10% single crystal).
   [Ciso] = MS_decomp(MS_axes(Craw)) ;
   [C0,~] = MS_VRH([0.1 0.9],Craw,rh,Ciso,rh) ; 
   
   C0 = MS_rot3(C0,90,0,0) ; % orientation for dry upper mantle
   C1 = C0 ; % class 1
   C2 = MS_rot3(C0,0,0,90) ; % class 2 (A-axis parallel to Y)
   
   fprintf('Creating 2 class Cij file\n')
   
   fid=fopen('SM_Cij.dat','wt') ;
   
   % output C1
   fprintf(fid,'1 ') ;
   for i=1:6
      for j=i:6
         fprintf(fid,'%9.4f ',C1(i,j)) ;
      end
   end      
   fprintf(fid,'%8.3f\n',rh) ;

   % output C2
   fprintf(fid,'2 ') ;
   for i=1:6
      for j=i:6
         fprintf(fid,'%9.4f ',C2(i,j)) ;
      end
   end      
   fprintf(fid,'%8.3f\n',rh) ;
   fclose(fid) ;

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
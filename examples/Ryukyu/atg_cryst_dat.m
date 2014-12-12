%  Reference: 
%      Bezacier, L., Reynard, B., Bass, J. B., Sanchez-Valle, C. and Van de Moortele, B. 2010 "Elasticity of antigorite, seismic detection of serpentinites, and anisotropy in subduction zones" 
%      Earth and Planetary Science Letters, v289 pp 198-208.  

% Copyright (c) 2012-2014, James Wookey, Andrew Walker and Takayoshi Nagaya
% Copyright (c) 2011-2012, James Wookey and Andrew Walker
% Copyright (c) 2005-2011, James Wookey
% All rights reserved.
% 
% Redistribution and use in source and binary forms, 
% with or without modification, are permitted provided 
% that the following conditions are met:
% 
%    * Redistributions of source code must retain the 
%      above copyright notice, this list of conditions 
%      and the following disclaimer.
%    * Redistributions in binary form must reproduce 
%      the above copyright notice, this list of conditions 
%      and the following disclaimer in the documentation 
%      and/or other materials provided with the distribution.
%    * Neither the name of the University of Bristol nor the names 
%      of its contributors may be used to endorse or promote 
%      products derived from this software without specific 
%      prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS 
% AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
% WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
% THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF 
% USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
% OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function [atg_a, atg_b, atg_c, C, CS, rho] = atg_cryst_dat()
    
C = [208.10   66.40    16.00    0.0    5.50   0.0 ; ...
      66.4   201.60     4.90    0.0   -3.10   0.0 ; ...
      16.00    4.90    96.90    0.0    1.60   0.0 ; ...
       0.0     0.0      0.0    16.90   0.0  -12.10 ; ...
       5.50   -3.10     1.60    0.0   18.40   0.0 ; ...
       0.0     0.0      0.0   -12.10   0.0   65.50];

atg_a = 43.5852;
atg_b = 9.2624;
atg_c = 7.2460; 
 
%M-tex?function(symmetry)
CS = symmetry('m', [atg_a, atg_b, atg_c],[90.0, 91.160, 90.0]);

rho = 2620 ;

end
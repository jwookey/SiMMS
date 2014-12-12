% RUN_SIMPLE_MODEL
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
% This script runs all the steps necessary to generate synthetic data. 
%
% Copyright (c) 2012-2014, James Wookey, Andrew Walker and Takayoshi Nagaya
% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.
% Build the model
Example_build_ryukyu_model_natural_antigorite_CPO() ;

% load the model and elastic class list.
Model = load('./SM_table.dat') ;
Elastic = load('./SM_Cij.dat') ;

%RAY PATH============================================================================

% create the interpolator function
InterpF = SiS_create_InterpF(Model) ;

% save these to a file for later use.
%save SM_Model Model Elastic InterpF

% make a list of receivers from rx, ry, rz vectors
RList = SiS_create_List([70],[0],[0]) ;

% make a list of sources from rx, ry, rz vectors
SList = SiS_create_List([42],[-3],[-63]) ;

% generate non-vertical rays (one per source-receiver pair)
%(dz : the stepsize in the ray, default=10)
Rays = SiS_create_Rays(Model, RList, SList, 1) ;

% remove any Rays from Ray lists where the angle from the vertical at the
% recever is too large for SWS analysis. (default = 45 degree)
Rays = SiS_filter_Rays_SWSwindow(Rays);

% interpolate the anisotropic parameters
[SplitOpsRaw] = SiS_calc_SplitOps(InterpF, Elastic, Rays, -400, 0) ;

%% NOTE: Fast directions are in ray frame at this point.

% agglomerate the splitting operators
[SplitOps] = SiS_agglom_SplitOps(SplitOpsRaw, 1.0) ;

% combine the splitting operators
[EffSplitOps] = SiS_combine_SplitOps(SplitOps, 79.83122363, 0.10) ;

% convert to geographical reference frame
[EffSplitOpsGRF] = SiS_to_geogrf(EffSplitOps, Rays) ;
SPLITTING = EffSplitOpsGRF

% plot a splitting map
SiS_plot_splitting_map(Model, EffSplitOpsGRF, Rays, 'src')
SiS_plot_splitting_map(Model, EffSplitOpsGRF, Rays, 'rec')
%save SM_SplitOps.mat SplitOpsRaw SplitOps EffSplitOps ;

%=================================================================================
%
%  This software is distributed under the term of the BSD free software license.
%
%  Copyright:
%     (c) 2012-2014, James Wookey, Andrew Walker and Takayoshi Nagaya
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
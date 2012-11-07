% RUN_SIMPLE_MODEL
%
% // Part of SiMMS - Simple Matlab Modelling of Splitting //
%
% This script runs all the steps necessary to generate synthetic data. 
%
% Copyright (c) 2003-2012, James Wookey 
% All rights reserved.
% This software is distributed under the term of the BSD free software license.
% See end of file for full license terms.

% See build_simple_model.m for model geometry

% load the model and elastic class list.
Model = load('SM_table.dat') ;
Elastic = load('SM_Cij.dat') ;

% create the interpolator function
InterpF = SiS_create_InterpF(Model) ;

% save these to a file for later use.
%save SM_Model Model Elastic InterpF

% make a list of receivers from rx, ry, rz vectors
RList = SiS_create_List([0],[0],[0]) ;

% make a list of sources from rx, ry, rz vectors
SList = SiS_create_List([-40 40],[-40 0 40],[-300]) ;

% generate non-vertical rays (one per source-receiver pair)
Rays = SiS_create_Rays(Model, RList, SList, 10) ;

figure
plot3([Rays.x],[Rays.y],[Rays.z]);
xlabel('x')
ylabel('y')
zlabel('z')

daspect([1 1 1])

% interpolate the anisotropic parameters
[SplitOpsRaw] = SiS_calc_SplitOps(InterpF, Elastic, Rays, -400, 0) ;

%% NOTE: Fast directions are in ray frame.

% agglomerate the splitting operators
[SplitOps] = SiS_agglom_SplitOps(SplitOpsRaw, 1.0) ;

% combine the splitting operators
[EffSplitOps] = SiS_combine_SplitOps(SplitOps, 0, 0.125) ;

% convert to geographical reference frame
[EffSplitOpsGRF] = SiS_to_geogrf(EffSplitOps, Rays) ;

%FIXME: add plotting here.

%save SM_SplitOps.mat SplitOpsRaw SplitOps EffSplitOps ;


%% generate the synthetic data
%load SWavelet
%mkdir SM_synthetics('SM_synthetics') ;
%SiS_create_Synthetics(SWavelet,[30 45 60],SplitOps,0.01,'SM_synthetics') ;

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
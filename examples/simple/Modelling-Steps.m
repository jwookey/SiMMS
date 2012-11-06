% load the model and elastic class list
Model = load('SynMod-table-matlab') ;
Elastic = load('SynMod-cijkl-matlab') ;

% create the interpolator function
InterpF = SiS_create_InterpF(Model) ;

% save these to a file
save MB2_Model Model Elastic InterpF

% make a list of receivers from rx, ry, rz vectors
RList = SiS_create_RList([0:25:75 80:5:120 125:25:200].*1e3,[10e3],[0]) ;

% generate vertical rays
Rays = SiS_create_VRays(Model, RList, 10e3)

% interpolate the anisotropic parameters
% [SplitOps] = SiS_calc_SplitOps(InterpF, Elastic, Rays, MinAniZ, isoClass)
[SplitOps] = SiS_calc_SplitOps(InterpF, Elastic, Rays, -400.e3, 43)

% agglomerate the splitting operators
SplitOpsRaw = SplitOps ;
[SplitOps] = SiS_agglom_SplitOps(SplitOpsRaw, 1.0) ;
save MB2_SplitOps.mat SplitOpsRaw SplitOps ;

% generate the synthetic data
load SWavelet
SiS_create_synthetics(SWavelet,[0 30 60 90],SplitOps,0.01,'MB2_synthetics')

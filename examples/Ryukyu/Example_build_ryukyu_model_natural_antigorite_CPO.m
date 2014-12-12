%Build subduction zone
%
% Antigorite CPO is derived from 
% T. Nagaya, S.R. Wallis, H. Kobayashi, K. Michibayashi, T. Mizukami, 
% Y. Seto, A. Miyake, M. Matsumoto, EPSL, 2014, 387:67-76.
%
% Copyright (c) 2012-2014, James Wookey, Andrew Walker and Takayoshi Nagaya
% Copyright (c) 2003-2012, James Wookey
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

function Example_build_ryukyu_model_natural_antigorite_CPO

   % setup the grid
   X = [   0:2:200] ; nX = length(X) ;
   Y = [ -200:2:200] ; nY = length(Y) ;
   Z = [-213:2:0  ] ; nZ = length(Z) ;
   slab_dip_angle= 43.5;
   crust_thickness = 23;
      
   % output the grid description file
   fprintf('Creating %u node model file\n',nX*nY*nZ)
   fid=fopen('./SM_table.dat','wt') ;
   for iZ=1:nZ
      for iY=1:nY
         for iX=1:nX
            if Z(iZ)> -crust_thickness
               % isotropic class - crust
               aclass = 0 ;
            else
               if Z(iZ)>((X(iX)*tand(slab_dip_angle)*-1) - crust_thickness)
                   if Z(iZ)>((X(iX)*tand(slab_dip_angle/4)*-1) - crust_thickness)
                            % crust_atg
                              aclass = 1;
                   elseif Z(iZ)>((X(iX)*tand(2*slab_dip_angle/4)*-1) - crust_thickness)
                            % corner_atg_1
                              aclass = 2;                          
                   elseif Z(iZ)>((X(iX)*tand(3*slab_dip_angle/4)*-1) - crust_thickness)
                            % corner_atg_2
                              aclass = 3;                
                   else
                            % slab_atg
                              aclass = 4;
                   end
               else
                            % Isotropic below top of slab
                              aclass = 0 ;
               end
               % output
            end % if Z(iZ)>-194
            fprintf(fid,'%8.2f %8.2f %8.2f %2.2u\n',X(iX),Y(iY),Z(iZ),aclass) ;
         end % for iX=1:nX
      end % iY=1:nY
   end % for iZ=1:nZ
   fclose(fid) ;
   
    
    %Antigorite elastic constants
    [atg_a, atg_b, atg_c, Catg, CS_atg, rh_atg] = atg_cryst_dat();
 
%CRUST Antigorite ==========================================================================================================
    filename1 = '???/Atg_CPO_EUL.txt';
%??? = insert the location of .txt file in your PC

    % Read texture from VPSC file
    % ===========================

    tic; fprintf('Loading Euler angles from %s ...', filename1);
        % specimen symmetry
        SS = symmetry('-1');
        % load data and count the input arguments
        eulers = euler_from_VPSC(filename1, CS_atg, SS);
        n_xtals = size(eulers,2);
        % n_xtals = 1;
    telap = toc; fprintf('... done (%4.2f secs)\n',telap);
    
    
    % Generate a texture file(atg)
    
    fid = fopen('read.TEX2.atg.for.crust.atg','wt');
        
    chooser = zeros([n_xtals,1]);
    for i = 1:n_xtals
        if (chooser(i) < 0.5)
            g = rot_from_Euler(eulers(1,i), eulers(2,i), eulers(3,i));
            g = MS_Vrot3(g, 180,-90,0);
            g = MS_Vrot3(g, 0,0,-90);
            g = MS_Vrot3(g, 0,-90,0);
            [phi1, Phi, phi2] = mktex_R2Euler(g);
        end
        
        fprintf(fid,'%6.2f  %6.2f  %6.2f \n',...
            phi1, Phi, phi2);
    end
    
    fclose(fid);
    
    filename2 = '???/read.TEX2.atg.for.crust.atg';
%??? = insert the location of above file in your PC
    
    % Read texture from VPSC file
    % ===========================

    tic; fprintf('Loading Euler angles from %s ...', filename2);
        % specimen symmetry
        SS = symmetry('-1');
        % load data and count the input arguments
        eulers = euler_from_VPSC(filename2, CS_atg, SS);
        n_xtals = size(eulers,2);
        % n_xtals = 1;
    telap = toc; fprintf('... done (%4.2f secs)\n',telap);
    
    
    % Generate a texture file(Crust atg)
    
    fid = fopen('CPO.crust.atg','wt');
        
    C_crust_atg = zeros(6,6,n_xtals);
    chooser = zeros([n_xtals,1]);
    for i = 1:n_xtals
        if (chooser(i) < 0.5)
            g = rot_from_Euler(eulers(1,i), eulers(2,i), eulers(3,i));
            C_crust_atg(:,:,i) = MS_rotR(Catg,g');
            [phi1, Phi, phi2] = mktex_R2Euler(g);
        end
        fprintf(fid,'%6.2f  %6.2f  %6.2f  %12.4f\n',...
            phi1, Phi, phi2, (1/n_xtals));
            
    end
    
    fclose(fid);  

    figure;
    pole_from_VPSC('./CPO.crust.atg', symmetry('m', [43.5852, 9.2624, 7.2460],[90.0, 91.160, 90.0]), symmetry('-1'))
    
    saveas(gcf,'odf(atg)','fig')
    
    % Check the elastic constants agree with what we calculated above...
    rh_crust_atg = ones(n_xtals,1)*rh_atg;
    vfs_crust_atg = ones(n_xtals,1);
    [C_crust_atg_av, rh_crust_atg] = MS_VRH(vfs_crust_atg, C_crust_atg, rh_crust_atg);
    
   %  dilute (100% single crystal).
   [Ciso_crust_atg] = MS_decomp(MS_axes(C_crust_atg_av)) ;
   [C_crust_atg, rh_crust_atg] = MS_VRH([1.0 0.0], C_crust_atg_av, rh_crust_atg, Ciso_crust_atg, rh_crust_atg) ; 
    

   MS_plot(C_crust_atg, rh_crust_atg);

   MS_sphere(C_crust_atg, rh_crust_atg, 'P');
   MS_sphere(C_crust_atg, rh_crust_atg, 'S');   
    
%======================================================================  


%CORNER Antigorite (1)==========================================================================================================
    
    filename3 = '???/R-near.vein.Atg_EUL.txt';
%??? = insert the location of above file in your PC

    % Read texture from VPSC file
    % ===========================

    tic; fprintf('Loading Euler angles from %s ...', filename3);
        % specimen symmetry
        SS = symmetry('-1');
        % load data and count the input arguments
        eulers = euler_from_VPSC(filename3, CS_atg, SS);
        n_xtals = size(eulers,2);
        % n_xtals = 1;
    telap = toc; fprintf('... done (%4.2f secs)\n',telap);
    
    
    % Generate a texture file(atg)
    
    fid = fopen('read.TEX1.atg.for.corner.atg','wt');
        
    chooser = zeros([n_xtals,1]);
    for i = 1:n_xtals
        if (chooser(i) < 0.5)
            g = rot_from_Euler(eulers(1,i), eulers(2,i), eulers(3,i));
            g = MS_Vrot3(g, 180,-90,0);
            g = MS_Vrot3(g, 0,0,-90);
            g = MS_Vrot3(g, 0,-90,0);
            g = MS_Vrot3(g, 0,45.5,0);
            [phi1, Phi, phi2] = mktex_R2Euler(g);
        end
        
        fprintf(fid,'%6.2f  %6.2f  %6.2f \n',...
            phi1, Phi, phi2);
    end
    
    fclose(fid);
    
    filename4 = '???/read.TEX1.atg.for.corner.atg';
%??? = insert the location of above file in your PC
    
    % Read texture from VPSC file
    % ===========================

    tic; fprintf('Loading Euler angles from %s ...', filename4);
        % specimen symmetry
        SS = symmetry('-1');
        % load data and count the input arguments
        eulers = euler_from_VPSC(filename4, CS_atg, SS);
        n_xtals = size(eulers,2);
        % n_xtals = 1;
    telap = toc; fprintf('... done (%4.2f secs)\n',telap);
    
    
    % Generate a texture file(Corner atg)
    
    fid = fopen('CPO.corner.atg_1','wt');
        
    C_corner_atg_1 = zeros(6,6,n_xtals);
    chooser = zeros([n_xtals,1]);
    for i = 1:n_xtals
        if (chooser(i) < 0.5)
            g = rot_from_Euler(eulers(1,i), eulers(2,i), eulers(3,i));
            C_corner_atg_1(:,:,i) = MS_rotR(Catg,g');
            [phi1, Phi, phi2] = mktex_R2Euler(g);
        end
        fprintf(fid,'%6.2f  %6.2f  %6.2f  %12.4f\n',...
            phi1, Phi, phi2, (1/n_xtals));
            
    end
    
    fclose(fid);  

    figure;
    pole_from_VPSC('./CPO.corner.atg_1', symmetry('m', [43.5852, 9.2624, 7.2460],[90.0, 91.160, 90.0]), symmetry('-1'))
    
    saveas(gcf,'odf(atg)','fig')
    
    % Check the elastic constants agree with what we calculated above...
    rh_corner_atg_1 = ones(n_xtals,1)*rh_atg;
    vfs_corner_atg_1 = ones(n_xtals,1);
    [C_corner_atg_av_1, rh_corner_atg_1] = MS_VRH(vfs_corner_atg_1, C_corner_atg_1, rh_corner_atg_1);
    
   %  dilute (100% single crystal).
   [Ciso_corner_atg_1] = MS_decomp(MS_axes(C_corner_atg_av_1)) ;
   [C_corner_atg_1, rh_corner_atg_1] = MS_VRH([1.0 0.0], C_corner_atg_av_1, rh_corner_atg_1, Ciso_corner_atg_1, rh_corner_atg_1) ; 
    

   MS_plot(C_corner_atg_1, rh_corner_atg_1);

   MS_sphere(C_corner_atg_1, rh_corner_atg_1, 'P');
   MS_sphere(C_corner_atg_1, rh_corner_atg_1, 'S');   
      
%======================================================================  


%CORNER Antigorite (2)==========================================================================================================
    
    filename5 = '???/R-near.vein.Atg_EUL.txt';
%??? = insert the location of above file in your PC

    % Read texture from VPSC file
    % ===========================

    tic; fprintf('Loading Euler angles from %s ...', filename5);
        % specimen symmetry
        SS = symmetry('-1');
        % load data and count the input arguments
        eulers = euler_from_VPSC(filename5, CS_atg, SS);
        n_xtals = size(eulers,2);
        % n_xtals = 1;
    telap = toc; fprintf('... done (%4.2f secs)\n',telap);
    
    
    % Generate a texture file(atg)
    
    fid = fopen('read.TEX1.atg.for.corner.atg','wt');
        
    chooser = zeros([n_xtals,1]);
    for i = 1:n_xtals
        if (chooser(i) < 0.5)
            g = rot_from_Euler(eulers(1,i), eulers(2,i), eulers(3,i));
            g = MS_Vrot3(g, 180,-90,0);
            g = MS_Vrot3(g, 0,0,-90);
            g = MS_Vrot3(g, 0,-90,0);
            g = MS_Vrot3(g, 0,91.0,0);
            [phi1, Phi, phi2] = mktex_R2Euler(g);
        end
        
        fprintf(fid,'%6.2f  %6.2f  %6.2f \n',...
            phi1, Phi, phi2);
    end
    
    fclose(fid);
    
    filename6 = '???/read.TEX1.atg.for.corner.atg';
%??? = insert the location of above file in your PC
    
    % Read texture from VPSC file
    % ===========================

    tic; fprintf('Loading Euler angles from %s ...', filename6);
        % specimen symmetry
        SS = symmetry('-1');
        % load data and count the input arguments
        eulers = euler_from_VPSC(filename6, CS_atg, SS);
        n_xtals = size(eulers,2);
        % n_xtals = 1;
    telap = toc; fprintf('... done (%4.2f secs)\n',telap);
    
    
    % Generate a texture file(Corner atg)
    
    fid = fopen('CPO.corner.atg_2','wt');
        
    C_corner_atg_2 = zeros(6,6,n_xtals);
    chooser = zeros([n_xtals,1]);
    for i = 1:n_xtals
        if (chooser(i) < 0.5)
            g = rot_from_Euler(eulers(1,i), eulers(2,i), eulers(3,i));
            C_corner_atg_2(:,:,i) = MS_rotR(Catg,g');
            [phi1, Phi, phi2] = mktex_R2Euler(g);
        end
        fprintf(fid,'%6.2f  %6.2f  %6.2f  %12.4f\n',...
            phi1, Phi, phi2, (1/n_xtals));
            
    end
    
    fclose(fid);  

    figure;
    pole_from_VPSC('./CPO.corner.atg_2', symmetry('m', [43.5852, 9.2624, 7.2460],[90.0, 91.160, 90.0]), symmetry('-1'))
    
    saveas(gcf,'odf(atg)','fig')
    
    % Check the elastic constants agree with what we calculated above...
    rh_corner_atg_2 = ones(n_xtals,1)*rh_atg;
    vfs_corner_atg_2 = ones(n_xtals,1);
    [C_corner_atg_av_2, rh_corner_atg_2] = MS_VRH(vfs_corner_atg_2, C_corner_atg_2, rh_corner_atg_2);
    
   %  dilute (100% single crystal).
   [Ciso_corner_atg_2] = MS_decomp(MS_axes(C_corner_atg_av_2)) ;
   [C_corner_atg_2, rh_corner_atg_2] = MS_VRH([1.0 0.0], C_corner_atg_av_2, rh_corner_atg_2, Ciso_corner_atg_2, rh_corner_atg_2) ; 
    

   MS_plot(C_corner_atg_2, rh_corner_atg_2);

   MS_sphere(C_corner_atg_2, rh_corner_atg_2, 'P');
   MS_sphere(C_corner_atg_2, rh_corner_atg_2, 'S');   
      
%======================================================================  


%SLAB Antigorite ==========================================================================================================
    
    filename7 = '???/R-near.vein.Atg_EUL.txt';
%??? = insert the location of above file in your PC
    
    % Read texture from VPSC file
    % ===========================

    tic; fprintf('Loading Euler angles from %s ...', filename7);
        % specimen symmetry
        SS = symmetry('-1');
        % load data and count the input arguments
        eulers = euler_from_VPSC(filename7, CS_atg, SS);
        n_xtals = size(eulers,2);
        % n_xtals = 1;
    telap = toc; fprintf('... done (%4.2f secs)\n',telap);
    
    
    % Generate a texture file(atg)
    
    fid = fopen('read.TEX3.atg.for.slab.atg','wt');
        
    chooser = zeros([n_xtals,1]);
    for i = 1:n_xtals
        if (chooser(i) < 0.5)
            g = rot_from_Euler(eulers(1,i), eulers(2,i), eulers(3,i));
            g = MS_Vrot3(g, 180,-90,0);
            g = MS_Vrot3(g, 0,0,-90);
            g = MS_Vrot3(g, 0,-90,0);
            g = MS_Vrot3(g, 0,180,0);
            g = MS_Vrot3(g, 0,136.5,0); %slab dip angle
            [phi1, Phi, phi2] = mktex_R2Euler(g);
        end
        
        fprintf(fid,'%6.2f  %6.2f  %6.2f \n',...
            phi1, Phi, phi2);
    end
    
    fclose(fid);
    
    
     filename8 = '???/read.TEX3.atg.for.slab.atg';
    %??? = insert the location of above file in your PC
     
        % Read texture from VPSC file
    % ===========================

    tic; fprintf('Loading Euler angles from %s ...', filename8);
        % specimen symmetry
        SS = symmetry('-1');
        % load data and count the input arguments
        eulers = euler_from_VPSC(filename8, CS_atg, SS);
        n_xtals = size(eulers,2);
        % n_xtals = 1;
    telap = toc; fprintf('... done (%4.2f secs)\n',telap);
    
             
    % Generate a texture file(Slab atg)
    
    fid = fopen('CPO.slab.atg','wt');
          
    C_slab_atg = zeros(6,6,n_xtals);
    chooser = zeros([n_xtals,1]);
    for i = 1:n_xtals
        if (chooser(i) < 0.5)
            g = rot_from_Euler(eulers(1,i), eulers(2,i), eulers(3,i));
            C_slab_atg(:,:,i) = MS_rotR(Catg,g');
            [phi1, Phi, phi2] = mktex_R2Euler(g);
        end
        
        fprintf(fid,'%6.2f  %6.2f  %6.2f  %12.4f\n',...
            phi1, Phi, phi2, (1/n_xtals));
            
    end
    fclose(fid);
    
    figure;
    pole_from_VPSC('./CPO.slab.atg', symmetry('m', [43.5852, 9.2624, 7.2460],[90.0, 91.160, 90.0]), symmetry('-1'))
    
    saveas(gcf,'odf(atg)','fig')
    
    % Check the elastic constants agree with what we calculated above...
    rh_slab_atg = ones(n_xtals,1)*rh_atg;
    vfs_slab_atg = ones(n_xtals,1);
    [C_slab_atg_av, rh_slab_atg] = MS_VRH(vfs_slab_atg, C_slab_atg, rh_slab_atg);


   %  dilute (100% single crystal).
   [Ciso_slab_atg] = MS_decomp(MS_axes(C_slab_atg_av)) ;
   [C_slab_atg, rh_slab_atg] = MS_VRH([1.0 0.0], C_slab_atg_av, rh_slab_atg, Ciso_slab_atg, rh_slab_atg) ; 
   
   MS_plot(C_slab_atg, rh_slab_atg);
    
   MS_sphere(C_slab_atg, rh_slab_atg, 'P');
   MS_sphere(C_slab_atg, rh_slab_atg, 'S');   
   
%======================================================================  


    %Create  Classes Cij Files
%======================================================================================================
   
   
   fprintf('Creating 4 class Cij file\n')
   
   fid=fopen('./SM_Cij.dat','wt') ;
   
   % output C_crust_atg
   fprintf(fid,'1 ') ;
   for i=1:6
      for j=i:6
         fprintf(fid,'%9.4f ',C_crust_atg(i,j)) ;
      end
   end      
   fprintf(fid,'%8.3f\n',rh_crust_atg) ;

   % output C_corner_atg_1
   fprintf(fid,'2 ') ;
   for i=1:6
      for j=i:6
         fprintf(fid,'%9.4f ',C_corner_atg_1(i,j)) ;
      end
   end      
   fprintf(fid,'%8.3f\n',rh_corner_atg_1) ;
   
   % output C_corner_atg_2
   fprintf(fid,'3 ') ;
   for i=1:6
      for j=i:6
         fprintf(fid,'%9.4f ',C_corner_atg_2(i,j)) ;
      end
   end      
   fprintf(fid,'%8.3f\n',rh_corner_atg_2) ;
   
   % output C_slab_atg
   fprintf(fid,'4 ') ;
   for i=1:6
      for j=i:6
         fprintf(fid,'%9.4f ',C_slab_atg(i,j)) ;
      end
   end      
   fprintf(fid,'%8.3f\n',rh_slab_atg) ;
   
   fclose(fid) ;

end
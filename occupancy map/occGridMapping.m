function myMap = occGridMapping(ranges, scanAngles, pose, param)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Parameters 
% 
% % the number of grids for 1 meter.
r = param.resol;
%  the initial map size in pixels
myMap = zeros(param.size);
% % the origin of the map in pixels
myorigin = param.origin; 

% % Log-odd parameters 
lo_occ = param.lo_occ;
lo_free = param.lo_free; 
lo_max = param.lo_max;
lo_min = param.lo_min;

N = size(pose,2);
n = size(scanAngles,1);

% j -- pose index
% i -- angle index
for j = 1:N 
    for i = 1:n
      % Update Robot information
      x = pose(1, j);
      y = pose(2, j);
      theta = pose(3, j);

      % car position (cells)
      car = [ceil(x * r) + myorigin(1), ceil(y * r) + myorigin(2)];

      % Find grids hit by the rays (in the gird map coordinate)
      x_occ = ranges(i,j) * cos(scanAngles(i,1) + theta) + x;
      y_occ = -ranges(i,j) * sin(scanAngles(i,1) + theta) + y;
     
      % Find occupied-measurement cells and free-measurement cells
      ix_occ = ceil(x_occ * r) + myorigin(1);
      iy_occ = ceil(y_occ * r) + myorigin(2);
      [freex,freey]  = bresenham(car(1),car(2),ix_occ,iy_occ);
        
      % occ
      if (iy_occ>0) && (ix_occ>0) && (ix_occ < param.size(1)+1) && (iy_occ < param.size(2)+1)
         occ = sub2ind(size(myMap), iy_occ, ix_occ);
      end

      % free
      del_index = (freex < 1) | (freex > param.size(2)) | (freey < 1) | (freey > param.size(1)); % bool vector for whether in the gird map range
      freex(del_index') = [];
      freey(del_index') = [];
      free = sub2ind(size(myMap),freey,freex);
      
      % update the map
      myMap(occ) = myMap(occ) + lo_occ;
      myMap(free) = myMap(free) - lo_free;

    end

    myMap = min(myMap,lo_max);
    myMap = max(myMap,lo_min);

    % visualization   
    imagesc(myMap); 
    hold on;
    plot(car(1), car(2), 'rx', 'LineWidth', 3); % indicate robot location
    pause(0.01);
end

end



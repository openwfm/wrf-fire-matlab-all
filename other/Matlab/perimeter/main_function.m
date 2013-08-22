wrfout='wrfout_d01_0001-01-01_00:00:00_fuel3';
interval=10;      % time step in wrfout in seconds
count=1;          % update the wind every count time steps
time=31;          % the number of the time step in wrfout closest to the perimeter time from above
time_now=300.25;  % the perimeter time (s)

format long

% read burning/not burning map from wrfout, should not set A or tign_g
% can be replaced by any other data acquisition routine

% read the fire map at perimeter time

[long,lat,tign_g]=read_file_perimeter(wrfout,time);

% Can I call an inside function from another script
% read long, lat from wrfout
% interpolate/resample to the wrf fire grid

% now have data: long, lat, fire_area - burning or not burning (between 0 and 1, 0-1 OK)
% wrfout - has ros

tign=perimeter_in(long,lat,tign_g,wrfout,time_now,time,interval,count);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The information below is not beig used for the current problem
%data='data_perim.txt';
%data='';            % contained the coordinates of the fire perimeter from the shapefile
%wrfout='wrfout_d05_2012-09-12_21:15:01';
%wrfout='wrfout_d05_2012-09-09_00:00:00'; - for the earlies Baker's fire
%time=281;
% time =49 for Witch fire;
% time=100; for Baker's fire;








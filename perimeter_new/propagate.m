function [t,d]=propagate(t,d,dir,fire_area,distance,ros,time_end,print)
% [t,d]=propagate(t,d,dir,fire_area,distance,ros,time_end,print)
%   t(i,j,2,2)  fire arrival time location (i,j)
%   t(i,j,a,b)  fire arrival time at a point on the line connecting (i,j) and (i+a-1,j+b-1)
%   t(i,j,:,:) =fire arrival time given at (i,j) at start
%   d(i,j,a,b)  distance remaining to (i+a-1,j+b-1), in proper units
%   dir  - 1 time forward, -1 backward
%   fire_area - 1 what can burn, 0 what not
%   distance(m,n,a,b) - distance on (i,j) and (i+a-1,j+b-1)
%   ros(m,n,a,b) - rate of spread 
%   time_end - the latest time to propagate to (earliest if dir=-1)
%   print  1 for tracing steps, 2 for detailed

if abs(dir) ~= 1, error('dir must be +-1'),end 
if print>0,step=0,tign=t(:,:,2,2),end
m=size(t,1);n=size(t,2);
if ~exist('print','var'),
    print=0;
end
active=squeeze(dir*(time_end-t(:,:,2,2))>0);
for step=1:100,
    t_old=t;
    for i=1:m, for j=1:n,
        if active(i,j),
            for a=1:3, for b=1:3, if a ~=2 | b~=2,
                if print>1,fprintf('step %i point %i %i direction %i %i time %g ',step,i,j,a-2,b-2,t(i,j,a,b));end
                dt = max(dir*(time_end-t(i,j,a,b)),0);    % time available to propagate
                if dt>0,
                    dd = dt.*ros(i,j,a,b);        % distance traveled to tnow
                    if d(i,j,a,b)> dd,              % positive distance remains
                        t(i,j,a,b)=time_end;        % the end of the segment traveled is at time_now
                        d(i,j,a,b)= d(i,j,a,b)-dd;  % decrease the distances remaining
                        if print>1,fprintf('distance remaining %g time %g',d(i,j,a,b),t(i,j,a,b));end
                    elseif d(i,j,a,b)>0,
                        t_end=t(i,j,a,b)+dir*d(i,j,a,b)./ros(i,j,a,b); % time at the end point
                        if print>1,fprintf('time at end %g ',t_end);end
                        ii=i+a-2; % the grid point this end point coincides with 
                        jj=j+b-2;
                        if ii>=1 & ii<=m,if jj>=1 & jj<=n & fire_area(ii,jj)
                            val=dir*min(dir*t(ii,jj,2,2),dir*t_end);
                            if print>1,fprintf('setting %i %i from %g to %g',ii,jj,t(ii,jj,2,2),val);end
                            t(ii,jj,:,:)=val;               % reinitialize the point ii, jj
                            d(ii,jj,:,:)=distance(ii,jj,:,:); % no distance traveled 
                            active(ii,jj)=true;             % can propagate from this
                        end, end
                        t(i,j,a,b)=t_end;
                        d(i,j,a,b)=0;
                    end
                end
                if print>1,fprintf('\n');end
            end, end, end
        end
    end, end
    if print>0,step,tign=t(:,:,2,2),end
    done=~any(t(:)-t_old(:));
    if done,
        break
    end
end
tign=t(:,:,2,2);


function dir = findDirection(x,y)

%% check length of x and y
% assert(length(x) == 201 && length(y) == 201)
t = 0:length(x)-1;
%% find range of values
x = x-x(1);
xrange50s = range(x(1:50));
xrange = range(x);
xrange50f = range(x(end-49:end));

y = y-y(1);
yrange50s = range(y(1:50));
yrange = range(y);
yrange50f = range(y(end-49:end));

%% detect stability and direction
if(any(isnan([x;y])) | (xrange50s>1) | (yrange50s>1) | ...
        (xrange50f>1) | (yrange50f>1) | ((xrange < 3) && (yrange < 3)))
    dir = nan;
elseif (x(end) > 3) && (yrange < 1)
    dir = 1;
elseif (xrange < 1) && (y(end) > 3)
    dir = 2;
elseif (x(end) < -3) && (yrange < 1)
    dir = 3;
elseif (xrange < 1) && (y(end) < -3)
    dir = 4;
else
    dir = nan;
end

%% plot
% 
% plot(t,x,t,y)
% grid minor
% ylim([-25,25])
% title(num2str(dir))

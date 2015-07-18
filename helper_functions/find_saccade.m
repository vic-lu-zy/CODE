function T = find_saccade(timerange,x)

% Credit: Victor Lu 2014
% Find saccade onset by fitting to a piecewise linear function
f = fit(timerange,double(x),'myPiecewise(x,t1,t2)','startpoint',[-10 0]);
T = f.t1;
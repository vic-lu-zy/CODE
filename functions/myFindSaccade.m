function saccadetimes=myFindSaccade(eyeX,eyeY,t)

%made by Greg, August 7 2011.
% Calculates the start and finish of the first major saccade occuring after
% time 't'. Eyeye data and t are in ms, t counts from the beginning
% of eye data (first data point is 1 ms).
% Relies on two assumptions: 1. saccades move faster than 100deg/s, and 2.
% saccades last longer than 10ms. Therefore, look for sequences of
% velocities where 8/10 (wiggle room) datapoints are >.1deg/ms.

saccadetimes=nan;
if isnan(t)
  return
end

t=t+1000; %analog eye starts at -1000

eyeX = eyeX(:);
eyeY = eyeY(:);

speed = sqrt((smooth(diff(eyeX(t:end)),5)).^2 + (smooth(diff(eyeY(t:end)),5)).^2);

saccadetimes = findSequential(find(speed>.08),10,2);

saccadetimes = saccadetimes+t*ones(size(saccadetimes))-1000;



function ind = findSequential(inp,N,wiggle)
%In input 'inp' find N sequential points (i.e. separated by 1 index),
%allowing for 'wiggle' points to be out. 'inp' is integer indices. Returns
%the first index in the found series.
%For example, inp=[1 2 3 4 6 7 9], N=9, wiggle=2 -> ind=1.
%Finds all series in 'inp' separated by 100 indices. This post-saccadic
%refractory period might need refinement.
c=1;
ind=[];
twait=0;
for i=1:length(inp)
  r=min(i,N+1)-1;
  if length(find(diff(inp(i-r:i))==1 & sum(diff(inp(i-r:i)))<=N))>=N-wiggle*2-1 && ~twait
    ind(c)=inp(i-r+1);
    c=c+1;
    %now wait 100ms until you can start the next saccade
    twait=inp(i)+100;
  end
  if twait-inp(i)<0
    twait=0;
  end
end

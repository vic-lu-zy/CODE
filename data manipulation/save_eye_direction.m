load eyeDir
%%
load T65sac

cl65 = eyeDir(~isnan(T65sac),:);

for ii = 1:length(cl65)
    if isequal(cl65(ii,:),[10 1])
        cl65(ii,1)=1; %right
    elseif isequal(cl65(ii,:),[0 11])
        cl65(ii,1)=2; %up
    elseif isequal(cl65(ii,:),[-10 1])
        cl65(ii,1)=3; %left
    elseif isequal(cl65(ii,:),[0 -9])
        cl65(ii,1)=4; %down
    end
end

cl65 = cl65(:,1);

%%
load T66on

cl66 = eyeDir(~isnan(T66on),:);

for ii = 1:length(cl66)
    if isequal(cl66(ii,:),[10 1])
        cl66(ii,1)=1; %right
    elseif isequal(cl66(ii,:),[0 11])
        cl66(ii,1)=2; %up
    elseif isequal(cl66(ii,:),[-10 1])
        cl66(ii,1)=3; %left
    elseif isequal(cl66(ii,:),[0 -9])
        cl66(ii,1)=4; %down
    end
end

cl66 = cl66(:,1);

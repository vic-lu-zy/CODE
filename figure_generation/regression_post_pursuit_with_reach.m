ccc

load Eye_traces
load T66on
load cl66
load cl_reach
load SPECT_ALL_IN_ONE

% h = h(~isnan(T66on));
Axis{3}.time = Axis{3}.time(1:80); % clip the time axis to -.5 ~ 2 s

T = minmax(Axis{3}.time)*1000; T = T(1):T(end);
Eye_x = extract_time_range(Eye.x,T66on+1000,T);
Eye_y = extract_time_range(Eye.y,T66on+1000,T);
% z = abs(Eye_x+1i*Eye_y);
% Eye_x = Eye_x - repmat(mean(Eye_x(1:400,:)),size(Eye_x,1),1);
% Eye_y = Eye_y - repmat(mean(Eye_y(1:400,:)),size(Eye_y,1),1);
% z = z./repmat(mean(z(end-600:end-100,:)),size(z,1),1);
%%
date = '20100412';
path_out = ['C:/Users/vic/Dropbox/thesis/figures/' date '/Regression/'];

fig1 = figure(1);
set(fig1,'Position',[1 41 1920 964]);

fig2 = figure(2);
set(fig2,'Position',[1 41 1920 964]);

c = zeros(80);

TT = T(1:30:end);

conf_matrix = zeros(48,4);

for chan = 1:48
    
    %%
    figure(1)
    clf
    figure(2)
    clf
    
    for ii = 1:4
        figure(1)
        
        t = linspace(Axis{3}.time(1),Axis{3}.time(end),length(Eye_x));
        subplot(2,4,ii)
        ex = Eye_x(:,cl==ii);
        ey = Eye_y(:,cl==ii);
        
        ez = mean(abs(ex+1i*ey),2);
        x = ez(1:30:end);
        
        line([0 0],minmax([ex(:); ey(:)]'),'color','k','linewidth',2)
        rectangle('Position',[1 min([ex(:);ey(:)]) .2 range([ex(:);ey(:)])],'facecolor','y');
        hold on
        plot(t,ex,'b',t,ey,'r')
        %       line([1.1 1.1],minmax([ex(:); ey(:)]'),'color','k','linewidth',2)
        axis tight
        subplot(2,4,ii+4)
        S = squeeze(mean(mean(Spect{3}(chan,cl==ii,1:80,12:17),4)));
        line([0 0],minmax(S(:)'),'color','k','linewidth',2)
        rectangle('Position',[1 min(S(:)) .2 range(S(:))],'facecolor','y');
        hold on
        plot(Axis{3}.time,S,'linewidth',3)
        axis tight
        
        figure(2)
        
        for iii = 1:79
            for jjj = iii+1:80
                c(iii,jjj) = corr(x(iii:jjj),S(iii:jjj))*log(jjj-iii);
            end
        end
        [I,J] = find(c==max(c(:)));
        conf_matrix(chan,ii)=max(c(:))/log(J-I);
        
        subplot(2,4,ii)
        imagesc(TT,TT,c')
        rectangle('Position',[TT(I),TT(J),1,1],'linewidth',4)
        axis image xy
        grid
        subplot(2,4,ii+4)
        rectangle('Position',[TT(I),0,TT(J),1],'facecolor','y')
        hold on
        plot(TT,x/max(x),TT,S/max(S));
        axis square
        grid
    end
    figure(1)
    subplot 241
    title('right')
    subplot 242
    title('up')
    subplot 243
    title('left')
    subplot 244
    title('down')
    
    subplot 241
    ylabel('Eye traces')
    subplot 245
    ylabel('Average Power (20~30) Hz')
    
    subplot 245
    xlabel('time (s)')
    subplot 246
    xlabel('time (s)')
    subplot 247
    xlabel('time (s)')
    subplot 248
    xlabel('time (s)')
    %%
    hgexport(fig1,sprintf([path_out '%02i'],chan),hgexport('factorystyle'),'Format','png')
    hgexport(fig2,sprintf([path_out '%02i_corr'],chan),hgexport('factorystyle'),'Format','png')
end
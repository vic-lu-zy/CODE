% % load Axis
% % load T66on
% % trials = find(~isnan(T66on));
% 
% %%
% % Spect = zeros(length(trials),floor(length(Axis.frequency)/5),length(Axis.time));
% %
% % %%
% % for i = 1:length(trials)
% %
% %     load(sprintf('psd_trial_%03i',trials(i)))
% %     S = squeeze(median(S(1:32,:,:)))';
% %     Spect(i,:,:) = S(2:ceil(end/5),:).* ...
% %         repmat((2:ceil(size(S,1)/5))',1,size(S,2));
% %
% % end
% 
% %%
% % load ind
% % for i = 1:4
% %     subplot(2,2,i)
% %     plot(squeeze(mean(Spect(ind{i},:,:),2))');
% %
% % end
% 
% % %%
% % for i = 1:32
% %     subplot(4,8,i)
% %     imagesc(squeeze(S(i,:,1:ceil(end/5)))');
% %     axis xy
% % end
% 
% %%
% %
% % Spect_all_in_one = zeros(length(trials),48,length(Axis.time),floor(length(Axis.frequency)/5),'single');
% % m = repmat(reshape(2:52,[1,1,51]),48,488,1);
% % parfor i = 1:length(trials)
% %     %%
% %     D = load(sprintf('psd_trial_%03i',trials(i)))
% %     Spect_all_in_one(i,:,:,:) = D.S(:,:,2:ceil(end/5)).*m;
% % end
% 
% % %%
% % k = randsample( find(~isnan(T65sac)), 1)
% % t_int = (-100:200);
% % T = T65sac(k)+1000+t_int;
% %
% % load(sprintf('LFP_trial_%03i',k))
% % x = LFP(10,T);
% %
% % %%
% % subplot 211
% % plotyy(t_int,[Eye.x(k,T); Eye.y(k,T)],t_int,x)
% %
% % subplot 212
% % [S,F,T] = lfp_spect_pmtm(x,32,1,512);
% % imagesc(T-100,F,(S.*repmat(1:size(S,2),size(S,1),1))'), axis xy
% 
% % %%
% % f = figure(1);
% %
% % for i = 1:48
% %     x = LFP(i,T65sac(65)+1000+(-100:500));
% %     sig = struct('val',x,'period',1/1000);
% %     cwtS1 = cwtft(sig);
% %
% %     %%
% %     scales = cwtS1.scales;
% %     % MorletFourierFactor = 4*pi/(6+sqrt(2+6^2));
% %     freq = 1./scales;
% %
% %     figure(f)
% %     subplot 211
% %     plot(t,x)
% %     subplot 212
% %     contour(t,freq,real(cwtS1.cfs));
% %     xlabel('Seconds'); ylabel('Pseudo-frequency');
% %     ylim([0 100])
% %     print(f,sprintf('C:/Users/vic/Google Drive/Thesis/Saccade_Spectrum_Morlet/Channel_%02i',i),'-dpng')
% %
% % end
% 
% % T65sac = zeros(length(Events.strobes),1);
% % 
% xx = Eye.x;%./10;
% % yy = Eye.y;%./10;
% for i = 1:length(Events.strobes)
%    if any(Events.strobes(i,:)==66)
%        T66on(i) = Events.strobeTimes(i,find(Events.strobes(i,:)==66,1));
% %        T66on{i} = myFindSaccade(xx(i,:),yy(i,:),time);
%    else
%        T66on(i) = nan;
%    end
% end

% for i = 1:4
%     f = figure(i);
%     set(gcf,'paperunits','inches', ...
%          'PaperPosition',[0 0 11 8.5]);
%      
%     for j = 1:40
%         %         if ~isnan(T66on(j))
%         subplot(5,8,j)
%         n = (i-1)*40+j;
%         x = extract_time_range(Eye.x(ind(n),:),...
%             T66on(ind(n))+1000,-500:2000);
%         y = extract_time_range(Eye.y(ind(n),:),...
%             T66on(ind(n))+1000,-500:2000);
%         plot(-500:2000,x-mean(x(1:500)),-500:2000,y-mean(y(1:500)))
%         line([0 0],[-5 5],'linewidth',4,'color','k')
% %         ylim([-15 15])
%         axis off
%         title(sprintf('%03i',ind(n)),'fontsize',18)
%         %         end
%     end
%     print(f,sprintf('C:/Users/vic/Google Drive/Thesis/figures/20100407/%1i',i),'-dpng')
% end

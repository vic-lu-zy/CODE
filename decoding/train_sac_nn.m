% X = [];
% Y = [];

load T65sac
load T66on
load T67

t = -50:199;

% for ii = 1:10
T = T65sac;% + randi(100,size(T65sac))-50;
[eyex65, eyey65] = extract_time_range(Eye,T+1000,t);

T = T66on;% + randi(100,size(T66on))-50;
[eyex66, eyey66] = extract_time_range(Eye,T+1000,t);

% T = T67; % + randi(100,size(T67))-50;
% [eyex67, eyey67] = extract_time_range(Eye,T+1000,t);

X = [eyex65 eyex66];
Y = [eyey65 eyey66];
% end

% X = [X eyex67(:,sel)];
% Y = [Y eyey67(:,sel)];

%%
load('cl65')
cl65 = cl;
load('cl66')
cl66 = cl;
clx = [cl65; cl66];
cly = [cl65; cl66];
%%
% orthogonal => 9

% i.e. 2,6,4,8
isVert = clx==2 | clx==4;
isHori = clx==1 | clx==3;

X(:,isVert) = [];
Y(:,isHori) = [];

clx(isVert)=[];
cly(isHori)=[];

% move up horizontals
% i.e. 1->1, 3->2, 5->3, 7->4
clx(clx==3)=2;
% i.e. 2->1, 4->2, 6->3, 8->4
cly(cly==2)=1;
cly(cly==4)=2;

clx = label2array(clx)';
cly = label2array(cly)';


% move 9->5
% clx(clx==9)=5;
% cly(cly==9)=5;

% clx = label2array(repmat(clx,10,1))';
% cly = label2array(repmat(cly,10,1))';
% clx = label2array([repmat(clx,10,1); 5*ones(length(sel),1)])';
% cly = label2array([repmat(cly,10,1); 5*ones(length(sel),1)])';


%%
% netX = feedforwardnet(100);
% netX = train(netX,X,clx);
% 
% netY = feedforwardnet(100);
% netY = train(netY,Y,cly);
% 

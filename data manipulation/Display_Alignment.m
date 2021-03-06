ccc
load Eye_traces
load T65sac

x = extract_time_range(Eye.x,T65sac+1000,-200:500);
y = extract_time_range(Eye.y,T65sac+1000,-200:500);

z = abs(x+1i*y);

pre = mean(z(100:200,:));
post = mean(z(300:400,:));

z = z-repmat(pre,size(z,1),1);
z = z./repmat(post,size(z,1),1);

plot(-200:500,z)


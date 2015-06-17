function header = headerFields

load RecordingVariables
header.success=Events.header(:,1);
header.FPEyeX=Events.header(:,2);
header.FPEyeY=Events.header(:,3);
header.FPHandX=Events.header(:,4);
header.FPHandY=Events.header(:,5);
header.TgtEyeX=Events.header(:,6);
header.TgtEyeY=Events.header(:,7);
header.TgtHandX=Events.header(:,8);
header.TgtHandY=Events.header(:,9);
header.FPHoldTime=Events.header(:,10);
header.FPEyeWind=Events.header(:,11);
header.FPHndWind=Events.header(:,12);
header.TgtEyeWind=Events.header(:,13);
header.TgtHndWind=Events.header(:,14);
header.CueDuration=Events.header(:,15);
header.TgtHoldInvisible=Events.header(:,16);
header.TgtHoldVisible=Events.header(:,17);
header.MemDuration=Events.header(:,18);
header.Effector=Events.header(:,19);
header.WindowConstraintFix=Events.header(:,20);
header.Sensor=Events.header(:,21);
header.RewardDuration=Events.header(:,22);
header.Trialtype=Events.header(:,23);  %90=mem, 91=delay, 92=direct, 93=suppress, 99 default
header.HEyeGain=Events.header(:,24);
header.HEyeOffset=Events.header(:,25);
header.VEyeOffset=Events.header(:,26);
header.VEyeGain=Events.header(:,27);
header.HHandOffset=Events.header(:,28);
header.VHandOffset=Events.header(:,29);
header.HandGainUP=Events.header(:,30);
header.HandGainDown=Events.header(:,31);
header.HandGainLeft=Events.header(:,32);
header.HandGainRight=Events.header(:,33);
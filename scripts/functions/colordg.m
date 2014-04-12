% 0002 %COLORDG - Provides a choice of 15 colors for a line plot
% 0003 %The first seven colors are the same as Matlab's predefined
% 0004 %values for the PLOT command, i.e.
% 0005 %
% 0006 %  'b','g','r','c','m','y','k'
% 0007 %
% 0008 %Syntax:  linecolor = colordg(n);
% 0009 %
% 0010 %Input: N , integer between 1 and 15, giving the following colors
% 0011 %
% 0012 % 1 BLUE
% 0013 % 2 GREEN (pale)
% 0014 % 3 RED
% 0015 % 4 CYAN
% 0016 % 5 MAGENTA (pale)
% 0017 % 6 YELLOW (pale)
% 0018 % 7 BLACK
% 0019 % 8 TURQUOISE
% 0020 % 9 GREEN (dark)
% 0021 % 10 YELLOW (dark)
% 0022 % 11 ORANGE
% 0023 % 12 MAGENTA (dark)
% 0024 % 13 GREY
% 0025 % 14 BROWN (pale)
% 0026 % 15 BROWN (dark)
% 0027 %
% 0028 %Output: LINECOLOR  (1 x 3 RGB vector)
% 0029 %
% 0030 %Examples:
% 0031 %  1)   h = line(x,y,'Color',colordg(11)); %Picks the orange color
% 0032 %  2)   colordg demo  %Creates a figure displaying the 15 colors
% 0033 %  3)   axes;  set(gca,'ColorOrder',(colordg(1:15)));
% 0034 %       Overrides the default ColorOrder for the current axes only
% 0035 %  4)   figure; set(gcf,'DefaultAxesColorOrder',(colordg(1:15)));
% 0036 %       Overrides the default ColorOrder for all axes of the current
% 0037 %      figure
% 0038 %  5)   set(0,'DefaultAxesColorOrder',(colordg(1:15)));
% 0039 %       Sets the default ColorOrder for all axes to be created during
% 0040 %       the current matlab session. You may wish to insert this
% 0041 %       command into your startup.m file.
% 0042 %
% 0043 %See also: PLOT, LINE, AXES
% 0044 
% 0045 %Author: Denis Gilbert, Ph.D., physical oceanography
% 0046 %Maurice Lamontagne Institute, Dept. of Fisheries and Oceans Canada
% 0047 %Web: http://www.qc.dfo-mpo.gc.ca/iml/
% 0048 %August 2000; Last revision: 26-Sep-2003
% 0049 
function linecolor = colordg(n);

if nargin == 0
    error('Must provide an input argument to COLORDG')
end

colorOrder = ...
    [  0            0            1       % 1 BLUE
    0            1            0       % 2 GREEN (pale)
    1            0            0       % 3 RED
    0            1            1       % 4 CYAN
    1            0            1       % 5 MAGENTA (pale)
    1            1            0       % 6 YELLOW (pale)
    0            0            0       % 7 BLACK
    0            0.75         0.75    % 8 TURQUOISE
    0            0.5          0       % 9 GREEN (dark)
    0.75         0.75         .2       % 10 YELLOW (dark)
    1            0.50         0.25    % 11 ORANGE
    0.75         0            0.75    % 12 MAGENTA (dark)
    0.7          0.7          0.7     % 13 GREY
    0.8          0.7          0.6     % 14 BROWN (pale)
    0.6          0.5          0.4 ];  % 15 BROWN (dark)

if isnumeric(n) & n >= 1 & n <= 15
    linecolor = colorOrder(n,:);
elseif strcmp(n,'demo')
    %GENERATE PLOT to display a sample of the line colors
    figure, axes;
    %PLOT N horizontal lines
    for n=1:length(colorOrder)
        h(n) = line([0 1],[n n],'Color',colorOrder(n,:));
    end
    set(h,'LineWidth',5)
    set(gca,'YLim',[0 n+1],'YTick',[1:n],'XTick',[])
    ylabel('Color Number');
else
    error('Invalid input to colordg');
end

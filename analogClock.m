function analogClock(startTime)

% Get Time
%Obtain hours from input
[hour, rest] = strtok(startTime, ':'); 
if length(hour) == 2 & hour(1) == '0'
    hour = hour(2);
end
hour = str2num(hour);
if hour >= 12
    hour = mod(hour, 24);  %keeping hours in 24-hour scale
end
%Obtain minutes from input
[min, rest] = strtok(rest, ':');
if length(min) == 2 & min(1) == '0'
    min = min(2);
end
min = str2num(min);
if min >= 60 %prevent error inputs that include minutes greater than 60
    min = mod(min, 60);
end
%Obtain seconds from input
[sec, ~] = strtok(rest, ':');
if length(sec) == 2 & sec(1) == '0'
    sec = sec(2);
end
sec = str2num(sec);
if sec >= 12 %prevent error inputs that include seconds greater than 60
    sec = mod(sec, 60);
end

% Create the Face and Body of Clock
%Clock Face
 [x1, y1, z1] = sphere(100); 
 z1 = z1.*0; %flattens sphere into disk
 disk1 = surf(20.*x1, 20.*y1, 20.*z1); %disk has radius 20
 rotate(disk1, [0, 1, 1], 180); %rotate disk so its horizontal and facing towards you
 shading interp
 freezeColors
 hold on
 %Body of clock
 [x2, y2, z2] = cylinder(20, 100); %cylinder with radius 20
 cyl = surf(x2, y2, 5.*z2); %make height of cylinder 5
 rotate(cyl, [0, 1, 1], 180); %rotate cylinder in same way as clock face
 hold on
 disk2 = surf(20.*x1, 20.*y1, 20.*z1 + 5); %second disk that is the back of clock
 rotate(disk2, [0, 1, 1], 180); 
 colormap([0 0 0]); %body of clock made black
 freezeColors

% Second Hand
hold on
[xx1, yy1, zz1] = cylinder(linspace(1, 1, 20)); %creates cylinder as second hand
xx1 = xx1.*0.25; %make hand 1/4 as thick
yy1 = yy1.*0; %flattens hand along y-axis
zz1 = zz1.*20; %makes hand length 20
scyl = surf(xx1, yy1, zz1);
colormap([1 0 0]); %second hand is red
shading interp
freezeColors

% Minute Hand
hold on
[xx2, yy2, zz2] = cylinder(linspace(1, 1, 20)); %creates cylinder as minute hand
xx2 = xx2.*0.5; %make hand 1/2 as thick
yy2 = yy2.*0; %flatten along y-axis
zz2 = zz2.*18; %make hand length 18
mcyl = surf(xx2, yy2, zz2);
colormap([0 0 0]); %minute hand is black
freezeColors

% Hour Hand
hold on
[xx3, yy3, zz3] = cylinder(linspace(1, 1, 20)); %creates cylinder as hour hand
yy3 = yy3.*0; %flattens hand along y-axis
zz3 = zz3.*10;
hcyl = surf(xx3, yy3, zz3);
colormap([0 0 0]); %hour hand is black
freezeColors

% Plot current time by rotating clock hands
axis([-25, 25, -25, 25, -25, 25]); %set axis
view(3); %set default view to 3D
hold on
secDeg = sec.*6; %determine angle second hand needs to be rotated by
rotate(scyl, [0 1 0], secDeg); 

hold on
minDeg = min.*6 + sec.*(6./60);
rotate(mcyl, [0 1 0], minDeg);

hold on
newHour = mod(hour, 12);
hourDeg = newHour.*30 + min.*(30./60) + sec.*(30./3600);
rotate(hcyl, [0 1 0], hourDeg);
hold off
axis off

%Tick Marks
for t = 0:11 %12 values of t representing 12 tick marks
    hold on
    [xx3, yy3, zz3] = cylinder(linspace(1, 1, 20)); %create a tick mark
    xx3 = xx3.*0.4;
    yy3 = yy3.*0;
    zz3 = zz3.*2;
    tick = surf(xx3, yy3, zz3+18); %each mark is 18 units away from origin, touching the edge of clock face
    rotate(tick, [0 1 0], t.*30); %each tick mark is 30 degrees apart
    colormap([0 0 0])
    freezeColors
end
%Clock Tick Sound
[y, Fs] = audioread('clock-ticking-2.mp3'); %read audio file
y1 = y(1:Fs); %select only first tick sound (first second of audio file) to play

% Animation- Rotate clock hands to simulate time
go = true;
direction = [0 1 0];
currFigure = gcf; %get current figure
while go
    %change background color based on hour
    helpBackground(currFigure, hour);
    %rotate clock hands
    rotate(scyl, direction, 6);
    sound(y1, Fs); %play ticking sound
    sec = sec + 1;
    rotate(mcyl, direction, 6./60);
    rotate(hcyl, direction, 6./3600);
    %increment minutes and seconds 
    if sec == 60
        min = min + 1;
        sec = 0; %reset 60 seconds to 0
    end
    if min == 60
        hour = hour + 1;
        min = 0; %reset minutes to 0
    end
    if hour == 24
        hour = 0; %reset 24 hours to 0
    end
    pause(1); %pause each second
    go = true; %go always equal to true so while loop is infinite
end
end
function helpBackground(currFigure, hour)
if ishandle(currFigure) %checks if figure hand still exists
    if hour == 6 %sunrise at 6 am
        set(gcf, 'Color', [1, 1, 0]); %yellow background
    elseif hour == 18 %sunset at 6 pm
        set(gcf, 'Color', [1, 1, 0]); %yellow background
    elseif (hour >= 0 & hour < 6) | (hour > 18 & hour <= 24) %nightime
        set(gcf, 'Color', [0, 0, 0]); %black
    elseif hour > 6 & hour < 18 %daytime
        set(gcf, 'Color', [0, 0, 1]); %blue
    end
end
end

% Extra-credit Additions (if any)
% Added a clock ticking noise for the second hand
% Changed the background color based on time of day
% Added tick marks to clock

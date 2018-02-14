%Set parameters to build screen (on Peter's advice)
%Skips the 'Welcome to psychtoolbox message' 
Screen('Preference', 'VisualDebuglevel', 1);

%At the beginning of each script matlab does synctests. Level 1 and 2
%prevent those tests. What does 0 do?
Screen('Preference', 'SkipSyncTests', 0);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = 255;
black = 0;
yellow=[255 255 0];
green = [0 255 0];
red = [255 0 0];

% Open an on screen window
[window, ~] = Screen('OpenWindow',screenNumber,black);

%Hide mouse
HideCursor;

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
windowRect = [0,0,screenXpixels, screenYpixels];

%Other applications compete with windows for resources. These lines make
%sure matlab wins.
prioritylevel=MaxPriority(window); 
Priority(prioritylevel);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
[wth, hth] = Screen('WindowSize', window);

%Textstuff
penWidthPixels = 4;
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, 32);
Screen('TextStyle', window, 0);
KbName('UnifyKeyNames');


   


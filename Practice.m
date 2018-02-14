%Instructions and practice for the multiplayer game

rng shuffle

%% Scanerstuff

SCANNER = {'Skyra','Dummy','Debugging','Keyboard','buttonbox'}; SCANNER = SCANNER{4};

% setup bitsi stuff for button responses
setup_bits;

%WD for instructions
instruct_dir = [cd '\instructions\instructionslab\'];

try  
    %%                     Screen stuff                                 %%   

    %Set parameters to build screen (on Peter's advice)
    %Skips the 'Welcome to psychtoolbox message' 
    Screen('Preference', 'VisualDebuglevel', 0);

    %At the beginning of each script matlab does synctests. Level 1 and 2
    %prevent those tests. What does 0 do?
    Screen('Preference', 'SkipSyncTests', 1);

    % Get the screen numbers
    screens = Screen('Screens');

    % Draw to the external screen if avaliable
    screenNumber = max(screens);

    % Open an on screen window
    white = 255;
    black = 0;
    [window, ~] = Screen('OpenWindow',screenNumber,white );

    % Hide mouse
    HideCursor;

    % Text settings
    Screen('TextFont', window, 'Ariel');
    Screen('TextSize', window, 32);
    Screen('TextStyle', window, 0);
    KbName('UnifyKeyNames');

    %% New PPNR

    ppnr_str = openended(window, 'Participant Nr:', black);
    initials = openended(window, 'Initials:', black);
    ppnr = str2double(ppnr_str);

    %initials = 'ih';
    initials = sprintf('%s',upper(initials));
    %ppnr = 999;

    % Get counterbalancing variables
    c = counterbalance(ppnr);    
    wp = 1.90;
    wo = 30;
    offer = 1;
    c.trials = [ppnr, 1, 1, 1, wp, wo, offer, 3,3,3,68,68,1];

    trial = 0;
catch me
    me.message
    close_bitsi
    Screen('CloseAll')
end

practice = 'Practice_';
%% Instructions
nextkey = 'rightarrow';
backkey = 'leftarrow';

instructions(window, instruct_dir, 1:21, nextkey, backkey);
UGR(window, ppnr, c, trial, initials, SCANNER, practice);
instructions(window, instruct_dir, 22:23, nextkey, backkey);
Screen('CloseAll');


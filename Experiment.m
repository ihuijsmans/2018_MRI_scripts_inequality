
function Experiment(ppnr, trial, initials)
% Eperiment part 2 UG receivers for MRI
%
% Inge Huijsmans

% 2017/11/07

    if IsWin
        wd = '';
    else
        wd = '/home_local/meduser/Desktop/experiment_MRI/';
    end
    
    %Setup wd
    SCANNER = {'Skyra','Dummy','Debugging','Keyboard','buttonbox'}; SCANNER = SCANNER{1};
     %setup_bits;

     

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
        [window, ~] = Screen('OpenWindow',screenNumber,white);

        % Hide mouse
        HideCursor;

        % Text settings
        Screen('TextFont', window, 'Ariel');
        Screen('TextSize', window, 32);
        Screen('TextStyle', window, 0);
        KbName('UnifyKeyNames');


        %%                     Set ppnr

        if nargin == 0
            %% New PPNR

            ppnr_str = openended(window, 'Participant Nr:', black);
            initials = openended(window, 'Initials:', black);
            ppnr = str2double(ppnr_str);

            initials = sprintf('%s',upper(initials));

            % Get counterbalancing variables
            c = counterbalance(ppnr);       

            listing = dir([wd, '/results/']);

            for i = 1:length(listing)
                if strcmp(listing(i).name, sprintf('%i.txt', ppnr))
                    fprintf('Ppnr exists, abort file');
                    break
                end
            end

            save([wd, '/results/', sprintf('c_%i.mat', ppnr)], 'c')

            trial = 0;

        else
            %% PPNR already exists

            % Load counterbalancing variables
            load([wd, '/results/', sprintf('c_%i', ppnr)]);
            initials = upper(initials);

        end


        %% Start task
        practice = '';
        UGR_NEW(window, ppnr, c, trial, initials, SCANNER, practice);

    %     if escape ~= 0
    %         fprintf(escape);
    %     end

        Screen('CloseAll');    
    catch me

        me.message
        me.stack.line
        Screen('CloseAll');    
    end
end

 
function escape = UGR(window, ppnr, c, trial, initials, SCANNER, practice)

    % Ultimatum game receivers, inequality
    % Inge
    % 2017-11-07
    

    % Different seeds per participant
    rng shuffle

    try 
        %%                    Timings <3 

        %Timing
        mainstart=tic;
        waitResponse = 3;
        wealthTime = 3;
        offerTime = 6;

        %%                  Set directories

        % setup bitsi stuff for button responses
        setup_bits;

        %Set results directory
        results_dir = [pwd '/results/'];
        %instruct_dir = [pwd '/instructions/'];

        
        %%                Get screen info
        
        % Define colors
        black = 0;
        purple = [138,43,226];
        red = [204,0,0];

        % Get the size of the screen window
        [screenXpixels, screenYpixels] = Screen('WindowSize', window);
        windowRect = [0,0,screenXpixels, screenYpixels];
        
        %Other applications compete with windows for resources. These lines make
        %sure matlab wins.
        prioritylevel=MaxPriority(window); 
        Priority(prioritylevel);

        % Get the centre coordinate of the window
        [xCenter, yCenter] = RectCenter(windowRect);

        %Textstuff
        KbName('UnifyKeyNames');

        %%                       Finger tapping imload                           %%     
        
        %Load some instuctions
        instruct_Finger_Tap_dir = [cd '/instructions/Finger Tapping/'];
        
        %Read images                                                                     
        listing = dir(instruct_Finger_Tap_dir);                                          
        filenames = char(listing.name);                                                  

        %Preallocate images                                                              
        images_FT = zeros(720, 960, 3, length(filenames)-3, 'uint8');

        %Read images       
        for i = 3:length(filenames)
            if strcmp(strtrim(filenames(i,:)), 'Thumbs.db')
                continue
            end
            images_FT(:,:,:,i-2) = imread(strtrim([instruct_Finger_Tap_dir filenames(i,:)]), 'JPG');
        end
        

        %%                       Prepare saving data  

        time = datestr(now, 'mm-DD-HH-MM');
        filename = [results_dir,  sprintf('%sUGR_ppnr_%i_time_%s_data.txt',practice, ppnr, time)];
        fid = fopen(filename,'a+t');
        fprintf(fid, '%s\t%s\t%s\t%s\t%s\t%s\t %s\t%s\t%s\t%s\t%s\t%s\t%s\t %s\t%s\t%s\t%s\t%s\t%s\t%s\t\n',...
            'ppnr','trial','block', 'screen','onset_first_pulse',...
            'mainstart', 'flip_onset', 'VBLTimestamp', 'lastFlipTimestamp', 'FlipTimestamp', 'MissedFlip','presenttime',...
            'wealthPP','wealthOther', 'offer','choiceSide','LR', 'choice','RT', 'HR', 'trigger');
       
        %Prepare data logging timings
        filename = [results_dir,  sprintf('%sUGR_Timing_ppnr_%i_time_%s_data.txt',practice, ppnr, time)];
        fid_timing = fopen(filename,'a+t');
        fprintf(fid_timing, '%s\t%s\t%s\t%s\n', 'mainstart','onset_dummy_pulses', 'onset_first_pulse', 'block');
        
        %Prepare data logging timings2
        filename = [results_dir,  sprintf('%sUGR_Timing2_ppnr_%i_time_%s_data.txt',practice, ppnr, time)];
        fid_timing2 = fopen(filename,'a+t');
        fprintf(fid_timing2, '%s\t%s\t%s\t%s\n', 'tocmainstart','nEvent', 'timing', 'block');
        
        
        %Prep saving Finger Tapping                       
        if strcmp(SCANNER, 'Skyra')
            filename = [results_dir,  sprintf('Finger_Tapping_ppnr_%i_time_%s.txt', ppnr, time)];
            fid_FT = fopen(filename,'a+t');
            fprintf(fid_FT, '%s\t%s\t%s\t%s\t%s\t%s\n', 'ppnr', 'screenID', 'onset_first_pulse', 'fliptimestamp','whenflip','toc(mainstart)');
        end
        
        %% Start game
        screen = 'scannerStart';
        run = 1;
        tooslow = 0;
        escape = 0;

        
        %Start loop
        while run 
            
            if (~ tooslow) && strcmp(screen, 'choice')
                %next trial
                trial = trial +1;
                
                if trial ~= 1
                    if (c.trials(trial,5) ~= c.trials(trial-1,5))
                        screen = 'break';
                    end 
                    
                end
                
            end
            
            if trial ~= 0
                %Set left right accept reject
                if c.trials(trial,13)
                    buttons = {'  Reject   ','  Accept   '};
                else 
                    buttons = {'  Accept   ','  Reject   '};
                end
            end
            
            %Reset trackers for each trial
            getresponse = 0;
            choice = '';
            LR = '';
            RT = 0;
            timeout = waitResponse;
            
            
            switch screen
                
                case 'break'
                    
                    Screen('DrawText',window, 'break', xCenter, yCenter, black);
                    getresponse = 0;
                    presenttime = 0;
                    timeout = 0;
                    trigger = 100;
                    
                    %Continue with enter, nothing else.
                    response = 1;
                    while response
                        [~, response] = KbWait();
                        if find(response) == 37
                            response = 0;
                        else
                            continue
                        end
                    end
                
                case 'scannerStart'
                    %% Wait for scanner pulses & give bonus

                    if strcmp(SCANNER,'Debugging')
                        onset_dummy_pulses = wait_for_scanner_start(3,bitsiboxScanner,scannertrigger,true);
                        onset_first_pulse =  wait_for_scanner_start(1 ,bitsiboxScanner,scannertrigger,false);
                    elseif strcmp(SCANNER,'Keyboard')
                        % do nothing
                        % still, do get some timestamps so we don't need to worry about that case further down...
                        onset_dummy_pulses = GetSecs;
                        onset_first_pulse = GetSecs;
                    else % some kind of scanner -- wait for it
                        onset_dummy_pulses = wait_for_scanner_test(30,bitsiboxScanner,scannertrigger,fid_timing2, mainstart, c.trials(trial+1,4), true);% this might be change to 31
                        onset_first_pulse =  wait_for_scanner_test(1 ,bitsiboxScanner,scannertrigger,fid_timing2, mainstart, c.trials(trial+1,4), false);
                    end
                    
                    %Save timings
                    fprintf(fid_timing, '%s\t%s\t%s\t%i\n', mainstart,onset_dummy_pulses, onset_first_pulse, c.trials(trial+1,4));
        
                    presenttime = 0.5;
                    
                    if trial < 10
                        screen = 'FT';
                    else 
                        screen = 'countdown';
                    end
                    % trigger
                    trigger = 101;
                    
                    
                case 'FT'
                    
                    Finger_Tapping(window, images_FT, fid_FT, ppnr, mainstart);
                    screen = 'countdown';
                    presenttime = 0;
                    choice = '';
                    LR = '';
                    RT = 0;
                    trigger = 102;
                    
                case 'countdown'
                    
                    showBonus(window, unique(c.trials(:,5)));
                    presenttime = 3;
                    screen = 'bonus';
                    % trigger
                    trigger = 103;
                    
                    if trial == 0
                        trial = 1;
                    end
                    
                case 'bonus'
                    
                    showBonus(window, unique(c.trials(:,5)), c.trials(trial,5));
                    presenttime = 3;
                    screen = 'bonusSelect';
                    % trigger
                    trigger = 104;
                    
                case {'choice','bonusSelect'}
                    %% Fixation cross 1
                    
                    %Fixation cross
                    Screen('DrawText',window, '+', xCenter, yCenter, black);

                    %Presenttime fixation cross 1
                    presenttime=c.trials(trial,8);
                          
                    %This screen
                    screen = 'fix1';
                    
                    % trigger
                    trigger = 105;
                    
                    %Option to break with esc
                    wait_until = GetSecs + presenttime;
                    response = 0;
                    [event_time, response] = KbWait([],0,wait_until);
                    if find(response) == 10
                        Screen('CloseAll');
                        break
                    else
                        WaitSecs(wait_until-event_time);
                    end
                    
                    presenttime = 0;

                case 'fix1'
                    %% Wealth screen
                    
                    offer = 0;
                    
                    %Draw wealth image
                    drawInequality(window, c, trial, initials, offer);
                    
                    %Presenttime fixation cross
                    presenttime=wealthTime;       

                    %This screen
                    screen = 'wealth';
                    
                    % trigger
                    trigger = 106;

                case 'wealth'
                    %% Fixation cross 2
                    Screen('DrawText',window, '+', xCenter, yCenter, black);

                    %Presenttime fixation cross 2
                    presenttime=c.trials(trial,9);      

                    %This screen
                    screen = 'fix2';
                    
                    % trigger
                    trigger = 107;
                    
                    %Option to break with esc
                    wait_until = GetSecs + presenttime;
                    response = 0;
                    [event_time, response] = KbWait([],0,wait_until);
                    if find(response) == 10
                        Screen('CloseAll');
                        break
                    else
                        WaitSecs(wait_until-event_time);
                    end
  
                case 'fix2'
                    %% Offer screen
                                        
                    offer = 1;
                    drawInequality(window, c, trial, initials, offer);
                    
                    color = {black, black};
                    buttonpenwidth = [3,3];
                    presenttime = offerTime;
                    
                    % trigger
                    trigger = 108;
                    
                    screen = 'offer';
                    
                    %Reset trackers for each trial
                    RT = 0;   
                    
                case 'offer'
                    %% Fixation cross 3
                    Screen('DrawText',window, '+', xCenter, yCenter, black);

                    %Presenttime fixation cross 3
                    presenttime=c.trials(trial,10);      

                    %This screen
                    screen = 'fix3';
                    
                    % trigger
                    trigger = 109;
                    
                    %Option to break with esc
                    wait_until = GetSecs + presenttime;
                    response = 0;
                    [event_time, response] = KbWait([],0,wait_until);
                    if find(response) == 10
                        Screen('CloseAll');
                        break
                    else
                        WaitSecs(wait_until-event_time);
                    end
                 
                case 'fix3'
                    
                    getresponse = 1;
                    offer = 1;
                    drawInequality(window, c, trial, initials, offer);
                    presenttime = 0;
                    setchoice = 1;
                    
                    if response
                        %Reset getresponse logical
                        getresponse = 0;
                        
                        switch response
                            case ButtonA
                                LR = 'left';
                                choice = buttons{1};
                                color = {purple, black};
                                buttonpenwidth = [9,3];
                            case ButtonB
                                LR = 'right';
                                choice = buttons{2};
                                color = {black, purple};
                                buttonpenwidth = [3,9];
                        end

                        %Presentation times
                        presenttime = timeout-RT;

                        %This screen
                        screen = 'choice';
                        
                    end
                    
                    % trigger
                    trigger = 110;
                    
                    drawButtons(window, buttons, setchoice, color, buttonpenwidth);
                                    
                case 'tooslow'
                    
                    Screen('TextSize', window, 60);
                    tooslowTxt = Screen('TextBounds', window , 'Too slow!');
                    Screen('DrawText', window, 'Too slow!', screenXpixels/2 - (tooslowTxt(3)/2),...
                        screenYpixels/2, red);
                    Screen('TextSize', window, 32);
                    presenttime = 1;
                    % trigger
                    trigger = 111;
                    screen = 'choice';
                    
            end

            %% Flip it
            [VBLTimestamp, lastFlipTimestamp, FlipTimestamp, MissedFlip] = Screen('Flip', window);
            flip_onset=toc(mainstart);

            %Send trigger to  signal for each event
            bitsiboxButtons.sendTrigger(trigger);
            
            response = 0;
            
            while getresponse

                %Clear keyboard                
                [response, keyDownTimestamp] = bitsiboxButtons.getResponse(0.001, true);
                while response %%>>>>>>>>>>>>>>>>>> DO SOMETHING WITH SCANNER PULSE<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%%
                    [response, keyDownTimestamp] = bitsiboxButtons.getResponse(0.001, true);
                end

                %Ask for response
                while (response == 0 || response == 15) && ((GetSecs - lastFlipTimestamp )<= timeout) 
                    [response, keyDownTimestamp] = bitsiboxButtons.getResponse(0.001, true);
                end

                RT=(keyDownTimestamp-lastFlipTimestamp);
                
                if response == 0                                           %No answer: Too slow
                    tooslow = 1;
                    screen = 'tooslow';
                    getresponse = 0;
                elseif response == ButtonA || response == ButtonB     %Answer
                    screen = 'fix3';
                    getresponse = 0;
                    tooslow = 0;
                else 
                    continue
                end

            end 

            WaitSecs(presenttime);


            if trial ~= 0
            %Save everything all the time
             fprintf(fid, '%i\t%i\t%i\t%s\t%.6f\t %.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t %i\t%i\t%i\t%i\t%s\t%s\t%.6f\t%i\t\n',...
                ppnr, trial, c.trials(trial,4), screen, onset_first_pulse,...
                mainstart, flip_onset, VBLTimestamp, lastFlipTimestamp, FlipTimestamp, MissedFlip,presenttime,...
                c.trials(trial,5), c.trials(trial,6), c.trials(trial,7), c.trials(trial,13), LR, choice, RT, trigger);
%              fprintf(fid, '%s\t%s\t%s\t%s\t%s\t%s\t %s\t%s\t%s\t%s\t%s\t%s\t%s\t %s\t%s\t%s\t%s\t%s\t\n',...
%             'ppnr','trial','block', 'screen','onset_first_pulse',...
%             'mainstart', 'flip_onset', 'VBLTimestamp', 'lastFlipTimestamp', 'FlipTimestamp', 'MissedFlip','presenttime',...
%             'wealthPP','wealthOther', 'offer','choiceSide','choice','RT', 'trigger');
            end
             
        end

    catch me
        me.message
        me.stack.line
        fprintf('\n\nUGR problems: %i\n%s', me.stack.line, me.message)
        Screen('CloseAll');
        close_bitsi;
        return
    end
end
































function drawInequality(window, c, trial, initials, offer)
%
%   draw inequality screen
%   Inge Huijsmans

    % wealth PP:    c.trials(trial,5)
    % wealth Other: c.trials(trial,6)
    % offer:        c.trials(trial,7)
    
    try
        white = 255;
        black = 0;
        lightgrey = 200;
        YO = {initials, sprintf('%s%s', c.trials(trial,11:12))};

        % Get the size of the screen window
        [screenXpixels, screenYpixels] = Screen('WindowSize', window);
        sqX = (screenXpixels - screenYpixels)/2;
        
        textRectY = Screen('TextBounds', window , YO{1});
        textRectO = Screen('TextBounds', window , YO{2});
        
        if ispc
            euro = '�';
        else
            euro = '€';
            initialsY = (screenYpixels/20)*4 + textRectY(4)/2;
        end
        
        textRectWY = Screen('TextBounds', window , sprintf('%s  %.2f', euro, c.trials(trial,5)));
        textRectWO = Screen('TextBounds', window , sprintf('%s  %.2f', euro, c.trials(trial,6)));
        
        %Draw frame
        Screen('FillRect', window, lightgrey, [sqX + ((screenYpixels/10)*1),...
            (screenYpixels/10)*2, sqX + ((screenYpixels/10)*9), (screenYpixels/20)*11] );
        Screen('FillRect', window, white, [sqX + ((screenYpixels/20)*3),...
            (screenYpixels/20)*5, sqX + ((screenYpixels/20)*17), (screenYpixels/20)*10] );

        %Draw wealth info PP
        Screen('DrawText',window, YO{1}, (sqX + ((screenYpixels/20)*6) - (textRectY(3)/2)),...
            initialsY, black);
        Screen('FrameOval',window, black,[sqX + ((screenYpixels/20)*4), (screenYpixels/40)*11,...
            sqX + (screenYpixels/20)*8, (screenYpixels/40)*19], 3) 
        %Screen('FillOval',window, lightgrey,[sqX + ((screenYpixels/20)*4), (screenYpixels/40)*11,...
        %    sqX + (screenYpixels/20)*8, (screenYpixels/40)*19], 3) 
        
        Screen('TextSize', window, 40);
        
        Screen('DrawText',window, sprintf('%s%.2f', euro, c.trials(trial,5)), (sqX +(screenYpixels/20)*6)-(textRectWY(3)/2),...
            ((screenYpixels/40)*15)-(textRectWY(4)/2), black);
        %Screen('FrameOval',window, white,[sqX + ((screenYpixels/20)*3), (screenYpixels/4),...
        %    sqX + (screenYpixels/20)*7, (screenYpixels/20)*9], 3) 
        
        Screen('TextSize', window, 32);
        %Draw wealth info other
        Screen('DrawText',window, YO{2},(((screenYpixels/20)*14) + sqX) - (textRectO(3)/2),...
            initialsY, black);
        Screen('FrameOval',window, black,[((screenYpixels/20)*12) + sqX, (screenYpixels/40)*11,...
            ((screenYpixels/20)*16) + sqX, (screenYpixels/40)*19], 3) 
        %Screen('FillOval',window, lightgrey,[((screenYpixels/20)*12) + sqX, (screenYpixels/40)*11,...
        %    ((screenYpixels/20)*16) + sqX, (screenYpixels/40)*19], 3) 
        Screen('TextSize', window, 40);
        Screen('DrawText',window, sprintf('%s%.2f', euro, c.trials(trial,6)), sqX +((screenYpixels/20)*14)-(textRectWO(3)/2),...
            ((screenYpixels/40)*15)-(textRectWO(4)/2), black);                    
        %Screen('FrameOval',window, white,[((screenYpixels/20)*13) + sqX, (screenYpixels/4),...
        %    ((screenYpixels/20)*17) + sqX, (screenYpixels/20)*9], 3) 

        
        %Draw offer
        if offer
            Screen('TextSize', window, 32);   
            textRectOfferYou = Screen('TextBounds', window , 'You:');
            textRectOfferOther = Screen('TextBounds', window , sprintf('%s:',(c.trials(trial,11:12))));
            Screen('DrawText',window, 'You:',...
                sqX + ((screenYpixels/20)*6)-(textRectOfferYou(3)/2),...
                (screenYpixels/40)*23, black);
            Screen('DrawText',window, sprintf('%s:',YO{2}),...
                (((screenYpixels/20)*14) + sqX)-(textRectOfferOther(3)/2),...
                (screenYpixels/40)*23, black);
            
            Screen('TextSize', window, 50); 
            textRectOfferYouNr = Screen('TextBounds', window , sprintf('%s%.0f',euro, (c.trials(trial,7)*10)));
            textRectOfferOtherNr = Screen('TextBounds', window , sprintf('%s%.0f',euro, 10-(c.trials(trial,7)*10)));
            Screen('DrawText',window, sprintf('%s%.0f',euro,(c.trials(trial,7))*10),...
                sqX + ((screenYpixels/20)*6)-(textRectOfferYouNr(3)/2),...
                (screenYpixels/40)*25, black);
            Screen('DrawText',window, sprintf('%s%.0f',euro, 10 - (c.trials(trial,7))*10),...
                (((screenYpixels/20)*14) + sqX)-(textRectOfferOtherNr(3)/2),...
                (screenYpixels/40)*25, black);
        end
        
        Screen('TextSize', window, 32);   
    catch me
        Screen('CloseAll');
        me.message
        me.stack.line
        disp('drawInequality problems')
        return
    end
end
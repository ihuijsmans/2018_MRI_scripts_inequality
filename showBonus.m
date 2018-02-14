function showBonus(window, wealth, wealthPP)
%
%  Show new bonus of the participant.
%

    try
        black = 0;
        
        if nargin == 3
            indexPP = find(wealth == wealthPP);
        else
            indexPP = 0;
        end

        % Get the size of the screen window
        [screenXpixels, screenYpixels] = Screen('WindowSize', window);
        sqX = (screenXpixels - screenYpixels)/2;
        circleheightY = screenYpixels/3;

        %Position of circles, whitespace = radius
        x = screenYpixels/((length(wealth)*2)-1);
        positions = zeros(1,(length(wealth)*2)+1);

        count = 0;
        for i = 1:length(positions)
            positions(i) = count;
            count = count + x*(abs(mod(i,2)-2)/2);  % abs(mod(0,2)-2)/2, 0.5 for odd and 1 for even
        end
        
        %
        bonusRct = Screen('TextBounds', window , 'Your bonus next block:');
                
        posIndexPP = indexPP*2;
                
        %Draw wealth circles
        Screen('DrawText',window, sprintf('%s','Your bonus next block:'),...
                (screenYpixels/2) - (bonusRct(3)*0.5) +sqX,...
                        screenYpixels/5, black);

        for i = 1:length(positions)
            %When not whitespace (= even positions)
            if ~mod(i,2)
                if (i == posIndexPP)

                    Screen('FrameRect', window, [204,0,0],... 
                    [sqX + positions(i)-(x/5), circleheightY-(x/5),...
                        sqX + positions(i+1) + (x/5), circleheightY+x + (x/5)],10 );

                end

                textRect = Screen('TextBounds', window , sprintf('%.2f',wealth(i/2)));
                Screen('FrameOval',window, black,[positions(i)+ sqX, circleheightY,...
                    positions(i+1) + sqX, circleheightY+x], 3); 
                Screen('DrawText',window, sprintf('%.2f',wealth(i/2)), positions(i)+ (x/2) - (textRect(3)*0.5) +sqX,...
                    circleheightY+(x/2)-(textRect(4)/2), black);
            end
        end

                
    catch me
        fprintf('Problems showBonos.m: %i', me.stack.line);
    end
end






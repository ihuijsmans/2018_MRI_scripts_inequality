function drawButtons(window, buttons, getresponse, color, buttonpenwidth)
% Draw accept/reject buttons

    black = 0;
    lightgrey = 200;
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
      
    %Make buttons
    textRect1 = Screen('TextBounds', window , buttons{1});
    textRect2 = Screen('TextBounds', window , buttons{2});

    %Double height
    textRect2(4) = textRect2(4)*2;
    textRect1(4) = textRect1(4)*2;

    %X location buttion 
    button1_accept_xloc = screenXpixels/3;
    button2_reject_xloc = (screenXpixels/3)*2;

    %Y location buttons
    buttony = (screenYpixels/5)*4;

    %Rectangles on exact location
    button1_accept_loc = CenterRectOnPointd(textRect1,button1_accept_xloc, buttony);
    button2_reject_loc = CenterRectOnPointd(textRect2,button2_reject_xloc, buttony);

    
    %Draw Button rects
    Screen('FillRect', window, lightgrey, button1_accept_loc);
    Screen('FillRect', window, lightgrey, button2_reject_loc);
    
    if getresponse
        Screen('FrameRect', window, color{1}, button1_accept_loc, buttonpenwidth(1));
        Screen('FrameRect', window, color{2}, button2_reject_loc, buttonpenwidth(2));
    end
    
    %Draw button text
    Screen('DrawText', window, buttons{1}, button1_accept_loc(1),...
        buttony - (textRect2(4)/3)+(textRect2(4)/10), black);
    Screen('DrawText', window, buttons{2}, button2_reject_loc(1),...
        buttony - (textRect2(4)/3)+(textRect2(4)/10), black);

end
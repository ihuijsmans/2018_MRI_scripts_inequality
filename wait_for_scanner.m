function [ onset_first_trigger] = wait_for_scanner( nScans, bitsiScanner, trigger, fid, mainstart,block, PTB)
%wait_for_scanner Wait for specified number of Scanner-trigger events
%
% Input:
% nScans number of scan-trigger events to wait for
% bitsiScanner bitsibox object, which to listen to for triggers
% trigger ASCI code of trigger (aka scanner-trigger) to wait for
% PTB boolean, indicating whether to show count-down on
% screen. This assumes PsychToolBox is already running, and
% only drawing/flipping is necessary.
%
% Output:
% onset_first_trigger onset time of first trigger-event
%
% adapted by: Peter Vavra
% version: 2014/05/19
%

% remove all previous codes from Bitsibox
bitsiScanner.clearResponses();

nEvents = 0;
txt = 'Waiting for Scanner';

% get PTB-window pointer
if PTB
    windowpointers=Screen('Windows');
    window = windowpointers(1);
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    textRect = Screen('TextBounds', window , txt);
    Screen('DrawText',window, txt, (screenXpixels/2)-(textRect(3)/2), (screenYpixels/2), 0);
    Screen('DrawText',window, int2str(nScans-nEvents), 500,680, 255);
    Screen(window,'Flip');
end

% wait for trigger-events
while nEvents < nScans;
    [response, timestamp] = bitsiScanner.getResponse(1, true);
    if response == trigger;
        nEvents = nEvents + 1;
        if nEvents == 1
            onset_first_trigger=timestamp;
        end
        
        % clear response from buffer
        bitsiScanner.clearResponses();
        
        % show countdown on screen
        if PTB
            Screen('DrawText',window, txt, (screenXpixels/2)-(textRect(3)/2), (screenYpixels/2), 0);
            if nScans-nEvents > 0 % don't show zero
                Screen('DrawText',window, int2str(nScans-nEvents), 500,680, 0);
            end
            Screen(window,'Flip');
        end
        
        fprintf(fid, '%f\t%i\t%f\t%i\n', toc(mainstart), nEvents, timestamp, block);
        
        % log status to console
        fprintf('trigger nr: %i -- timestamp: %f\n',nEvents, timestamp);
    end
end
end
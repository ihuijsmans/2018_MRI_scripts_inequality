function [c] = counterbalance(ppnr)
% Inequality UG
% Inge
% 2017-11-07
%
% Counterbalancing
%
% 3 (wealth participant) x 3 (wealth other) x 6 (offer: 0, 25, 50, 75, 100)
% within subjects design, all possible combinations are repeated six
% times. 
%
% wealth participant blocked and counterbalanced between participants
 
    try
        % Set different seed for every participant
        rng shuffle

        %%                          Set parameters

        wealth = [1.9,7.5,30];
        offer = 0.1:0.1:0.6;
        offerRep = [5,4,3,3,5,2];
        wealthO = [1,2,3];
        wealthPP_order = [[1,2,3];[1,3,2];[2,1,3];[2,3,1];[3,1,2];[3,2,1]];
        wealthPP = wealthPP_order(mod(ppnr,6)+1,:);       
        
        %%                         Create all trials

        offers = zeros(sum(offerRep)*length(wealthO),2);
        count = 1;
        for k = 1:length(wealthO)
            for i = 1:length(offer)
                for j = 1:offerRep(i)
                    offers(count,:) = [wealth(k), offer(i)];
                    count = count +1;
                end
            end
        end

        %%  make randomisation

        nbtrials = (sum(offerRep)*length(wealthPP));

        trials = zeros(sum(offerRep)*length(wealthO)*length(wealthPP),10);
        trials(:,1) = repmat(ppnr,1,nbtrials*length(wealthPP));
        trials(:,2) = 1:size(trials,1);
        trials(:,3) = repmat(1:nbtrials,1,length(wealthPP));
        

        for k = 1:length(wealthPP)

            randCheck = 1;
            cycle = 1;
            while randCheck

                offersS = offers(shuffle(1:size(offers,1)),:);
                wOS = 0;
                oS = 0;

                for i = 1:size(offers,1)

                    if i ~= size(offers,1)

                        %Check wealth other previous trial
                        if offersS(i+1,1) == offersS(i,1)
                            wOS = wOS +1;
                        else
                            wOS = 0;
                        end

                        %Check offer previous trial
                        if offersS(i+1,2) == offersS(i,2)
                            oS = oS +1;
                        else
                            oS = 0;
                        end

                        %If three reps of wealth other or offer, shuffle again.
                        if wOS > 2 || oS > 2

                            cycle = cycle + 1;
                            break
                        end
                    else
                        randCheck = 0;
                        break
                    end

                end
            end

            trials((nbtrials*(k-1))+1:(nbtrials*(k-1))+nbtrials,4) = repmat(k,1,nbtrials);
            trials((nbtrials*(k-1))+1:(nbtrials*(k-1))+nbtrials,5) = repmat(wealth(wealthPP(k)),1,nbtrials);
            trials((nbtrials*(k-1))+1:(nbtrials*(k-1))+nbtrials,6:7) = offersS;

        end


        %%              Fixation cross jitter        
        % fMRI 
        % jitter_1 = 2:(3/89):5;
        % jitter_2 = 2:(3/89):5;
        % jitter_3 = 2:(3/89):5;

        % fixed randomized jitters for 2 fixation crosses 
        % jitter between
        start = 2;
        stop = 4;

        trials(:,8:10) = [shuffle(start:((stop-start)/(nbtrials-1)):stop)',...
            shuffle(start:((stop-start)/(nbtrials-1)):stop)',... 
            shuffle(start:((stop-start)/(nbtrials-1)):stop)';...
            shuffle(start:((stop-start)/(nbtrials-1)):stop)',...
            shuffle(start:((stop-start)/(nbtrials-1)):stop)',... 
            shuffle(start:((stop-start)/(nbtrials-1)):stop)';...
            shuffle(start:((stop-start)/(nbtrials-1)):stop)',...
            shuffle(start:((stop-start)/(nbtrials-1)):stop)',... 
            shuffle(start:((stop-start)/(nbtrials-1)):stop)'];
        
        %Initials other player
        trials(:,11:12) = player_numbers(size(trials,1));
        
        %L/R Accept/Reject counterbalancing
        trials(:,13) = [shuffle([zeros(1,length(wealthO)*(sum(offerRep)/2)), ones(1,length(wealthO)*(sum(offerRep)/2))]),...
            shuffle([zeros(1,length(wealthO)*(sum(offerRep)/2)), ones(1,length(wealthO)*(sum(offerRep)/2))]),...
            shuffle([zeros(1,length(wealthO)*(sum(offerRep)/2)), ones(1,length(wealthO)*(sum(offerRep)/2))])];
        
        
        c.header = {'ppnr', 'trial', 'blocktrial','block','wealthPP','wealthO','offer','jitter1','jitter2','jitter3', 'initial1', 'initial2', 'LR'};
        c.trials = trials;
        
        
        
    %     %%              Load offer images
    % 
    % 
    %     %Stimulus direcotry
    %     stimdir = [cd '/Pictures_SP/'];

    %     %%                            Prepare Stimuli                            %%
    % 
    %     %Read all filenames
    %     listing = dir(stimdir);
    %     filenames = char(listing.name);
    % 
    %     %first two entries are non informative
    %     filenames(1:2,:) = [];
    %     %filenames(end,:) = [];
    % 
    % 
    %     %Save filenames
    %     c.filenames = filenames;
    % 
    %     % Read images and add to variable
    %     images = zeros(720, 960, 3, length(filenames(:,1)), 'uint8');
    % 
    %     for i = 1:(length(filenames(:,1)))
    % 
    %         [~,~,ext] = fileparts(filenames(i,:));
    %         if strcmp(strtrim(ext), strtrim('.jpg'))
    %             % Read image from stiminfo
    %             tmpimg = imread([stimdir, filenames(i,:)], 'jpg');
    % 
    %             % Store in new variable
    %             images(:,:,:,i) = tmpimg; 
    %         else
    %             continue
    %         end
    % 
    %     end
    % 
    %     c.images = images;
    catch me 
        fprintf('Error in counterbalancing script\n');
        me.message
        me.stack
        me.stack.line
        Screen('CloseAll');
        return
    end
end






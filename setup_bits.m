% This script sets up the Bitsi boxes - on for the button boxes, one for the scanner-triggers
% It assumes that there is a SCANNER variable
% SCANNER = {'Skyra','Dummy','Debugging','Keyboard'}; SCANNER = SCANNER{3};

switch SCANNER
    case 'Skyra'
        
        %Set WD
        %cd wd;
        
        %Set trigger
        scannertrigger = 97;
          
        %Set output/input comports
        bitsiboxScanner = Bitsi('/dev/ttyS1');
        bitsiboxButtons = Bitsi('/dev/ttyS5');
        
%         %Set trigger
%         scannertrigger = 15; %key "a"
%         
%         %Set comports to KB 
%         bitsiboxScanner = Bitsi('');
%         bitsiboxButtons = Bitsi('');
%         bitsiEye = Bitsi('');
        
        % Right hand -- button down
        ButtonA = 11; % left
        ButtonB = 12; % right
        
       %Bitsi test script
%         a = 1;
%         while a
% 
%             %Clear keyboard                
%             [response, keyDownTimestamp] = bitsiboxScanner.getResponse(0.001, true);            
%             while response %%>>>>>>>>>>>>>>>>>> DO SOMETHING WITH SCANNER PULSE<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%%
%                 [response, keyDownTimestamp] = bitsiboxScanner.getResponse(0.001, true);
%             end
% 
%             %Ask for response
%             while (response == 0)  
%                 [response, ~] = bitsiboxScanner.getResponse(0.001, true);
%                 if response
%                     fprintf('%i', response);
%                     a = 0;
%                 end
%             end
%         end
        
        
    case 'Dummy'
        
        %Set WD
        cd '/home_local/meduser/Desktop/data/users/inghui/MRI Script 2015-01-28/';
        
        %Set trigger
        scannertrigger = 97;
        
        %Set output/input comports
        bitsiboxScanner = Bitsi('/dev/ttyS2');
        bitsiboxButtons = Bitsi('');
        bitsiEye = Bitsi('/dev/ttyS1');
     
        % Right hand -- button down
        ButtonA = 11; % left
        ButtonB = 12; % right
        ButtonC = 13; % confirm
        ButtonD = KbName('a'); % pauze
        ButtonE = KbName('b'); % next
        ButtonF = KbName('Escape'); % close
        ButtonG = KbName('space');

    
        
    case {'Debugging', 'Keyboard'}
        
        %Set WD
        %cd 'C:\Users\claciv\Desktop\JGame_SPTP';
        %cd 'M:\PhD_Donders_2015\projects\Justice Game';
        wd = 'C:\Users\meduser\Desktop\experiment_MRI';
        cd(wd)
        
        %Set trigger
        scannertrigger = KbName('a'); %key "a"
        
        %Set comports to KB 
        bitsiboxScanner = Bitsi('');
        bitsiboxButtons = Bitsi('');
        bitsiEye = Bitsi('');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Note: Edit any of letters below, to use the ones you want
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ButtonA = KbName('leftarrow');  % left
        ButtonB = KbName('downarrow'); % right
        ButtonC = KbName('rightarrow');  % confirm & middle
        ButtonD = KbName('space'); % spacebar, continue after break
        ButtonF = KbName('Escape'); % close
        

     case 'buttonbox'
        scannertrigger = KbName('a');
        bitsiboxScanner = Bitsi('');
        bitsiboxButtons = Bitsi('COM1');
     
        % Right hand -- button down
        ButtonA = 97; % index finger
        ButtonB = 98; % middle finger
        ButtonC = 99; % ring finger
        ButtonD = 100; % pinky finger
        ButtonA_up = 65;
        ButtonB_up = 66;
        ButtonC_up = 67;
        ButtonD_up = 68;    
        
    otherwise
        disp('Missing proper value for "SCANNER" variable. Cannot set up Bitsi-boxes properly..');
end
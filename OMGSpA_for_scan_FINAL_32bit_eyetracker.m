function OMGSpA_for_scan_FINAL_32bit_eyetracker(subj,group,subgroup,run)
%OMGSpA 
%   
% Description as of 7/25/14
% total run time 382
% TPs: 191
% TR : 2
%Eye tracker-- turn on get_eye, 2.5 degrees of visual angle for box
% multi slice acquisition, 69 slices, full brain coverage
% On a given trial an arrow cue is presented centrally along with a word
% above or below that arrow (1.85 secs). after a blank screen (1 sec) 9
% objects are presented
% on the screen for 150 ms followed by a 2 second response window. 
% 4 conditions
% 1: Passive, same 9 images come up for every trial, in different
% configuratoins. cue word is 'passive', arrow cue is non informative.
% subjects make random button press after objects appear
% 2: MemRet: subjects learn word-picture associations (e.g. word 'cat' is
% paired with picture of a donut. must respond whether the correct picture
% (one of 4 donut exemplars) appears at teh center of the screen.
% distractors (images that are never targets for that particular
% subject)show up at the 8 peripheral locations. if it's a match trial,
% subject presses '1' if it's a nonmatch trial (an object that is paired
% with another word e.g. picture of a faucet, which had been paired with
% 'motorcycle' appears) subj presses 2. 
% 3: CueAtt: subjects study a bunch of images the day before and do 4
% encoding tasks on them (to match number of views of each object in other
% condition)-- 2 motor/visuospatial: "would it fit in a shoe box?", "would you
% pick it up with one hand or 2?, and two semantic: "is it more likely to be
% found indoors our outdoors?", "is it mostly functional or mostly
% decorative?". In the scanner, they are presented with an arrow pointing
% to one of 8 possible locations along with a word cue. Subjects are
% instrucuted to covertly attend to the location that is cued and determine
% whether that object appears at that location. (e.g. does a TV appear at
% that location). after a blank screen, 9 objects appear. on 50% of trials
% the target appears at teh cued location (match), and the other 50% another target
% for that subject for that condition appears at that location (nonmatch).
% On nonmatch trials, the cued target appears somewhere else (one of 7
% other peripheral locations). on match trials another target appears at on
%e of the 7 other locations
% 4: MGAtt: subjects study word-locations associations on Day 1. eg vase
% goes in the upper upper left. In the scanner subjects are presented with
% the word 'vase' and a noninformative arrow cue. they must retrieve the
% location associated with 'vase' and covertly attend to that location to
% deteremine whether a vase appears. after a blank screen, 9 objects appear. on 50% of trials
% the target appears at teh cued location (match), and the other 50% another target
% for that subject for that condition appears at that location (nonmatch).
% On nonmatch trials, the cued target appears somewhere else (one of 7
% other peripheral locations). on match trials another target appears at on
%e of the 7 other locations
%attempt 12 runs, total scan time 78 mins
%% Catch a missing subject variable
if ~exist('subj','var')
    subj = input('What is your subject #? (e.g., 005): ','s');
else
    subj = subj;
end

if ~exist('group','var')
    group = input('What group number? (e.g., 1): ','s');
else
    group = group;
end

if ~exist('subgroup', 'var')
    subgroup = input ('What is your subgroup number (e.g., A):','s');
else
    subgroup = subgroup;
end

if ~exist('run','var')
    run = input('Which run? (e.g., 101): ','s');
else
    run = run;
end
get_eye = 0;
if get_eye
    edf_filename=input('Input unique name for saving eyelink data, only 8 or less letters and num allowed:', 's');
    edf_filename=strcat(edf_filename,'.edf');
end
    
%%    
 try
    %----------------------------------
    % Re-seed Randomizer and set priority (64-bit)
    s = RandStream.create('mt19937ar','seed',sum(100*clock)); %re-seed rand with clock, see help rand for details
    %RandStream.setGlobalStream(s);

    % ----------------------------------
    % Re-seed randomizer (32-bit)
     %s = RandStream.create('mt19937ar','seed',sum(100*clock)); %re-seed rand with clock, see help rand for details
    RandStream.setDefaultStream(s);

    

    % ----------------------
    % Set ALL file paths:
    %% Log File (here, only a saved trial struct:
    outdir='~/Documents/Somers/Maya_MATLAB/OMGSpA_output';
    %outdir='~/Documents/MATLAB/OMGSpA_output';
    d=datestr(now,'yyyymmdd_HHMM');
    %% Open Log File
    log=fopen([outdir 'OMGSpa_' num2str(subj) '_group_' num2str(group) '_subgroup_' subgroup '_run_' num2str(run) '_' d '.txt'], 'wt');
    fprintf(log,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n','numTrial','blocktype','rt','validorinvalid','subjectresponse','word','pic','which_target','CuedLocation','alternateLocation','ReplacementTarget','which_replacement_target');
    %% File Read in for each condition --Counterbalanced across subjects
    listDir = '~/Documents/Somers/Maya_MATLAB/OMGSpaLists/Target_lists/';
    targetDir = ['~/Documents/Somers/Maya_MATLAB/OMGSpaImages/TargetImages_' num2str(group) '/'];
    distDir = ['~/Documents/Somers/Maya_MATLAB/OMGSpaImages/DistractorImages_' num2str(group) '/'];
    passiveDir = ['~/Documents/Somers/Maya_MATLAB/OMGSpaImages/passiveImages/'];
    distImages = dir(['~/Documents/Somers/Maya_MATLAB/OMGSpaImages/DistractorImages_' num2str(group) '/*.jpg']);
    randomized_distImages = [randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages))];
        %% File Read in for each condition --Counterbalanced across subjects -- change for Harvard Mac

    %listDir = '~/Documents/MATLAB/OMGSpaLists/Target_lists/';
    %targetDir = ['~/Documents/MATLAB/OMGSpaImages/TargetImages_' num2str(group) '/'];
    %distDir = ['~/Documents/MATLAB/OMGSpaImages/DistractorImages_' num2str(group) '/'];
    %passiveDir = ['~/Documents/MATLAB/OMGSpaImages/passiveImages/'];
    %distImages = dir(['~/Documents/MATLAB/OMGSpaImages/DistractorImages_' num2str(group) '/*.jpg']);
    %make distractor images into textures before the scan
    %randomized_distImages = [randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages)) randperm(length(distImages))];



%% Display Parameters:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Display Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

    HideCursor;
    
    Screen('Preference', 'VBLTimestampingMode', 1);
    Screen('Preference','SkipSyncTests', 1);
    Screen('Preference','VisualDebugLevel', 0);
    Screen('Preference', 'SuppressAllWarnings', 1);
    
    whichScreen = max(Screen('Screens'));
    
    [window, rect] = Screen('OpenWindow', whichScreen);
    white = [256 256 256];
    grey =  [190,190,190];
    red = [255, 0,0];
    green = [0 255 0];
    blue = [0 0 255];
    black = 0;
    TextStyle = 1;
    Font = 'arial';
    FontSize = 40;
    res=[1024 768];%scanner resolution
    %res=[1680 1050];
    %res=[1440 900];%laptop resolution
    %res=[1280 800];
    Screen('TextFont',window, Font);
    Screen('TextSize',window, FontSize);
    Screen('TextStyle', window, TextStyle);
    Screen('FillRect', window, white);
    
    DrawFormattedText(window,'Loading images ...','center','center',black,50);
    Screen('Flip',window);
    
    %set up pixesl per degree
    p.v_dist 		= 88;	% 88cm for 12 and 32 channel,  viewing distance behavioral: 60(cm)
    p.mon_width  	= 40;	% 40 scanner, 28 mac air, 43 tammy office, 51 my office horizontal dimension of viewable Screen (cm)
    fprintf '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~pix_per_deg~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n'
    pix_per_deg = pi * rect(3) / atan(p.mon_width/p.v_dist/2) / 360	% pixels per degree
    fprintf '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~pix_per_deg~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n'
    
    %convert stim size to pixels
    box=2.5*pix_per_deg; % this will be your discrimination box. 2.5 degrees
    
    [id,name] = GetKeyboardIndices; % get a list of all devices connected
    device = 0;
    %deviceString = 'Teensy Keyboard/Mouse';
    deviceString = 'Apple Keyboard';%'Apple Internal Keyboard / Trackpad';
    %deviceString = 'Apple Internal Keyboard / Trackpad';
    for i=1:length(name) % for each possible device
        if strcmp(name{i},deviceString) % compare the name to the name you want
            device = id(i); % grab the correct id, and exit loop
            break;
        end
    end
    
    if device == 0 % error check
        error('No device by that name was detected');
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Cue Params
    % This loads up co-ordinates for the offscreen rectangle that will
    % encompass the arrow cue (cueWinRect), and the anchor points on the arrow (arrowPoints).
    % Both are relative to total screen size.
    
    centerX=res(1)/2;
    centerY=res(2)/2;
    xSpace = round(res(1)/9);
    ySpace = round(res(2)/9);
    r=((res(2)-4*ySpace))/2;
    xMilliSpace = round(res(1)/100);
    yMilliSpace = round(res(2)/100);
    cueWinRect = [centerX-.25*xSpace centerY-.25*ySpace centerX+.25*xSpace centerY+.25*ySpace]; % window is 1/20 total screen area (xSpace and ySpace defined above as 1/10 total screen area)
    winX = cueWinRect(3) - cueWinRect(1); % X dimension of cue window
    winY = cueWinRect(4) - cueWinRect(2); % Y dimension of cue window
    arrowPoints=[0,(1/3)*winY; (5/8)*winX,(1/3)*winY; (5/8)*winX,0; winX,.5*winY; (5/8)*winX, winY; (5/8)*winX,(2/3)*winY; 0,(2/3)*winY]; % points on the arrow, relative to the cue window
    % = [ top , width of neck of arrow, where the top triangle is?,
    noninf_arrowPoints = [0,(1/2)*winY; (3/8)*winX,0; (3/8)*winX, (1/3)*winY; (5/8)*winX, (1/3)*winY; (5/8)*winX,0; winX,(1/2)*winY; (5/8)*winX,winY; (5/8)*winX,(2/3)*winY;  (3/8)*winX,(2/3)*winY; (3/8)*winX,winY;]; % double sided arrow for all conditions except Cued attention
    nudge=[0 8 0 8];
    putCueRect = nudge+cueWinRect;
    %Open the arrow cue in an offscreen window - only have to do this once.
    cue=Screen('OpenOffscreenWindow',window,[],cueWinRect);
    Screen('FillPoly',cue,red,arrowPoints);
    noninf_cue=Screen('OpenOffscreenWindow',window,[],cueWinRect);
    Screen('FillPoly',noninf_cue,red, noninf_arrowPoints);
    %set locations
    loc1_x = centerX+r*cosd(292.5);% 585.472 at 1024x768
    loc1_y = centerY+r*sind(292.5);% 206.6151
    loc2_x = centerX+r*cosd(337.5);
    loc2_y = centerY+r*sind(337.5);
    loc3_x = centerX+r*cosd(22.5);
    loc3_y = centerY+r*sind(22.5);
    loc4_x = centerX+r*cosd(67.5);
    loc4_y = centerY+r*sind(67.5);
    loc5_x = centerX+r*cosd(112.5);
    loc5_y = centerY+r*sind(112.5);
    loc6_x = centerX+r*cosd(157.5);
    loc6_y = centerY+r*sind(157.5);
    loc7_x = centerX+r*cosd(202.5);
    loc7_y = centerY+r*sind(202.5);
    loc8_x = centerX+r*cosd(247.5);
    loc8_y = centerY+r*sind(247.5);
    destRect = [loc1_x-65 loc1_y-65 loc1_x+65 loc1_y+65;
        loc2_x-65 loc2_y-65 loc2_x+65 loc2_y+65;
        loc3_x-65 loc3_y-65 loc3_x+65 loc3_y+65;
        loc4_x-65 loc4_y-65 loc4_x+65 loc4_y+65;
        loc5_x-65 loc5_y-65 loc5_x+65 loc5_y+65;
        loc6_x-65 loc6_y-65 loc6_x+65 loc6_y+65;
        loc7_x-65 loc7_y-65 loc7_x+65 loc7_y+65;
        loc8_x-65 loc8_y-65 loc8_x+65 loc8_y+65;
        centerX-65 centerY-65 centerX+65 centerY+65];

    rotAngles = [292.5
        337.5
        22.5
        67.5
        112.5
        157.5
        202.5
        247.5];

    bottom_word_loc = centerY + 35;
    top_word_loc = centerY - 75;
    nloc = 8;

    %% Set keys
    MatchKey = 30;
    NonMatchKey = 31;
    %MatchKey2 = KbName('1!');
    %NonMatchKey2 = KbName('2@');

    stopkey = KbName('q');
    trigger = KbName('=+');
    trigger2 = KbName('='); %Backup trigger
    %buttons = [MatchKey NonMatchKey];
    ImgsToDraw.img = zeros(1,9);
    %options.location =  'Harvard';%'laptop';
    %options.eyetracker  = true;
    %options.eyecalibration = true; %Run calibration on eyetracker (every other run)
    once = 0;

    validinvalid = '';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                        EYE LINK SETUP
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if get_eye
        
        % Provide Eyelink with details about the graphics environment
        % and perform some initializations. The information is returned
        % in a structure that also contains useful defaults
        % and control codes (e.g. tracker state bit and Eyelink key values).
        el=EyelinkInitDefaults(window);%%returns values
        
        
        
        % STEP 4
        % Initialization of the connection with the Eyelink Gazetracker.
        % exit program if this fails.
        if ~EyelinkInit(0)
            fprintf('Eyelink Init aborted.\n');
            % Shutdown Eyelink:
            Eyelink('Shutdown');
            sca;
            return;
        end
        
        connected=Eyelink('IsConnected');%%Just to verify connection
        
        [v vs]=Eyelink('GetTrackerVersion');
        
        fprintf('Running experiment on a ''%s'' tracker.\n', vs );
        
        % open file to record data to
        tempeye = Eyelink('Openfile', edf_filename);%%doesn't return
        if tempeye~=0
            fprintf('Cannot create EDF file ''%s'' ', edf_filename);
            Eyelink( 'Shutdown');
            return;
        end
        
        
        % CHANGE HOST PC PARAMETERS HERE
        % SET UP TRACKER CONFIGURATION
        % Setting the proper recording resolution, proper calibration type,
        % as well as the data file content;
        Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, (rect(3)-1), (rect(4)-1)); % scr_r(3) = width; scr_r(4) = height
        Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, (rect(3)-1), (rect(4)-1));
        
        % set calibration type.
        Eyelink('command', 'calibration_type = HV9');
        
        Eyelink('command', 'generate_default_targets = NO');
        
        %9 point
        caloffset=7*pix_per_deg; %7.5 %6.8 for m/sh %%%%%% this moves in calibration dots 7 deg from the edges and top/bottom
        width=rect(3);
        height=rect(4);
        center = [rect(3) rect(4)]/2;	% center of Screen (pixel coordinates)
        Eyelink('command','calibration_samples = 10');
        Eyelink('command','calibration_sequence = 0,1,2,3,4,5,6,7,8,9');
        Eyelink('command','calibration_targets = %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
            width/2,height/2,  width/2,height/2-caloffset,  width/2,height/2 + caloffset,  width/2 -caloffset,height/2,  width/2 +caloffset,height/2,...
            width/2-caloffset, height/2- caloffset, width/2-caloffset, height/2+ caloffset, width/2+caloffset, height/2- caloffset, width/2+caloffset, height/2+ caloffset);
        Eyelink('command','validation_samples = 9');
        Eyelink('command','validation_sequence = 0,1,2,3,4,5,6,7,8,9');
        Eyelink('command','validation_targets = %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
            width/2,height/2,  width/2,height/2-caloffset,  width/2,height/2 + caloffset,  width/2 -caloffset,height/2,  width/2 +caloffset,height/2,...
            width/2-caloffset, height/2- caloffset, width/2-caloffset, height/2+ caloffset, width/2+caloffset, height/2- caloffset, width/2+caloffset, height/2+ caloffset );
        
        
        eyelink('command', 'recording_parse_type = GAZE');
        eyelink('command', 'saccade_acceleration_threshold = 8000');
        eyelink('command', 'saccade_velocity_threshold = 30');
        eyelink('command', 'saccade_motion_threshold = 0.0');
        eyelink('command', 'saccade_pursuit_fixup = 60');
        eyelink('command', 'fixation_update_interval = 0');
        
        % set EDF file contents
        Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
        Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS');
        
        % set link data (used for gaze cursor)
        Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
        Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS');
        
        
        % make sure we're still connected.
        if Eyelink('IsConnected')~=1
            Eyelink( 'Shutdown');
            return;
        end;
        
        % setup the proper calibration foreground and background colors
        el.backgroundcolour = white; % would be better to have grey background for everything 
        el.foregroundcolour = black;
        
        % you must call this function to apply the changes from above
        EyelinkUpdateDefaults(el);
        % Hide the mouse cursor;
        Screen('HideCursorHelper', window);
        
        % Calibrate the eye tracker
        EyelinkDoTrackerSetup(el);
        eye_used = Eyelink('EyeAvailable');
        %
        %    % do a final check of calibration using driftcorrection
        % %     EyelinkDoDriftCorrection(el);
        %
        %
        %
    end %if eye
  

    
    %% Session Params & Initialize some variables
    nBlocks=8; % total # of blocks
    nTrialsPerBlock=8; % trials per block
    nTrials=nBlocks*nTrialsPerBlock; % total number of trials
    nBlocksperCondperRun = 2;
    nBlocksperRun = 8;
    %% Timing

    ImageDuration = 0.15; % how long images are up. 150 ms to prevent moving attentional spotlight
    CueDuration = 1.85; %
    BlankDuration = 1.0; %blank between cue and images
    RespDuration = 2.0; % response duration
    BlockCueDuration = 4.0; %length of cue for each block
    TotalTrialTime = CueDuration +  BlankDuration + ImageDuration +RespDuration
    FixDuration = 10.0; %first, middle and last fix % 5 TRs
    triggerPressed = 0; % set this to 1 once the trigger goes through (equals sign)
    triggerOn = 0;
    firstTrial = 0; % set this to 1 after the first trial of each block. this allows going into the loop to present the block cue
    blockCounter =1; %keep count of how many blocks. 8 total
    TotalBlockTime = ((CueDuration +  BlankDuration + ImageDuration +RespDuration)*nTrialsPerBlock) + BlockCueDuration 
    TotalRunTime = ((TotalBlockTime * nBlocksperRun) + (FixDuration*3)); % 148 TRs
    PassImgCounter = 0; %count the passive images
    subjKeyPress = 1; % reset every time subject presses a key
    numTrial = 1; % trial number counter. not used for antyhign except output
    numTrialFix = 1;

    tt=1; % initialize cumulative trial counter
    keynum=1; %
    rt=NaN; % reaction time
    isCorrect=NaN; %this doesnt do anything at the moment
    distCounter = 1; %distractor counter
    whetherMatchTrialMemRet=zeros(nTrialsPerBlock, nBlocksperCondperRun ); %initialize matrix of 0's for match/nonmatch trials
    whetherMatchTrialMGAtt=zeros(nTrialsPerBlock, nBlocksperCondperRun);
    whetherMatchTrialcueAtt=zeros(nTrialsPerBlock, nBlocksperCondperRun);
    whetherMatchTrialMemRet(1:4, 1:2) =1;
    whetherMatchTrialMGAtt(1:4, 1:2) = 1;
    whetherMatchTrialcueAtt(1:4, 1:2)=1;

    whetherMatchTrialMemRet = Shuffle(whetherMatchTrialMemRet); %randomize
    whetherMatchTrialMGAtt = Shuffle(whetherMatchTrialMGAtt);
    whetherMatchTrialcueAtt = Shuffle(whetherMatchTrialcueAtt);
    CueAtt_loc1 = randperm(nloc)';
    CueAtt_loc2 = randperm(nloc)';

    CueAtt_loc = [CueAtt_loc1 CueAtt_loc2]; % assign locations for the cued attention trials

    targNum1 = [1:8]'; 
    targNum = [targNum1 targNum1];% make an 8 x 2 matrxi of numbers 1-8 that can be used to choose the replacement targets from
    blocktype = 4;% set to 4 conditions
    %blocktype = [1 1];
    %blocktype = [blocktype blocktype];
    blocktype = [randperm(blocktype) randperm(blocktype)];%pseudorandomize the blocktypes

    blocknames = ['Fixati'; 'CueAtt'; 'MGuAtt'; 'MemRet'; 'Passiv'];   

    %% Open Log File
    d=datestr(now,'yyyymmdd_HHMM');
    log=fopen ([outdir 'OMGSpa_' num2str(subj) '_group_' num2str(group) '_subgroup_' subgroup '_run_' num2str(run) '_' d '.txt'], 'wt');
    fprintf(log,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n','numTrial','blocktype','rt','validorinvalid','subjectresponse','word','pic','which_target','CuedLocation','alternateLocation','ReplacementTarget','which_replacement_target');

    for p = 1:length(randomized_distImages);
        dist_imageFile = [distDir distImages(randomized_distImages(p)).name];
        pic = imread(dist_imageFile);
        distsToDraw(p) = Screen('MakeTexture',window,pic);
        
    end
    
    %read in structures from text files for each trial type
    
    MemRet_list = ReadStructsFromText([listDir 'MemRet_word_pic_loc_' subgroup '.txt']);
    MGAtt_list = ReadStructsFromText([listDir 'MGAtt_word_pic_loc_' subgroup '.txt']);
    CueAtt_list = ReadStructsFromText([listDir 'CueAtt_word_pic_loc_' subgroup '.txt']);
    Passive_list = ReadStructsFromText([listDir 'Passive_pics_' subgroup '.txt']);
    
    MemRet_list1 = Shuffle(MemRet_list)';% shuffle and transpose
    MemRet_list2 = Shuffle(MemRet_list)';% shuffle and transpose
    MemRet_list = [MemRet_list1 MemRet_list2];% concatenate into a 8 x 2 matrix
    
    MGAtt_list1 = Shuffle(MGAtt_list)';% shuffle and transpose
    MGAtt_list2 = Shuffle(MGAtt_list)';% shuffle and transpose
    MGAtt_list = [MGAtt_list1 MGAtt_list2];
    
    CueAtt_list1 = Shuffle(CueAtt_list)';% shuffle and transpose
    CueAtt_list2 = Shuffle(CueAtt_list)';% shuffle and transpose
    CueAtt_list = [CueAtt_list1 CueAtt_list2];

    
    %make all of the passive images into textures
    for l = 1:length(Passive_list)
        passive_imageFile = [passiveDir Passive_list(l).image];
        pic = imread(passive_imageFile);
        passiveImages(l) = Screen('MakeTexture', window, pic);
    end
    passiveImages1 = Shuffle(passiveImages);
    passiveImages2 = Shuffle(passiveImages);
    passiveImages3 = Shuffle(passiveImages);
    passiveImages4 = Shuffle(passiveImages);
    passiveImages5 = Shuffle(passiveImages);
    passiveImages6 = Shuffle(passiveImages);
    passiveImages7 = Shuffle(passiveImages);
    passiveImages8 = Shuffle(passiveImages);
    passiveImages9 = Shuffle(passiveImages);
    passiveImages10 = Shuffle(passiveImages);
    passiveImages11 = Shuffle(passiveImages);
    passiveImages12 = Shuffle(passiveImages);
    passiveImages13 = Shuffle(passiveImages);
    passiveImages14 = Shuffle(passiveImages);
    passiveImages15 = Shuffle(passiveImages);
    passiveImages16 = Shuffle(passiveImages);
    
    passiveImages = [passiveImages1 passiveImages2 passiveImages3 passiveImages4 passiveImages5 passiveImages6 passiveImages7 passiveImages8 passiveImages9 passiveImages10 passiveImages11 passiveImages12 passiveImages13 passiveImages14 passiveImages15 passiveImages16];
    
    
    
    %%%%eyetracker
    %%%%stuff==============================================
    %%%%===================================================
    if get_eye
        Eyelink('Message', 'TRIAL_VAR_LABELS blocknames(1,:) blocknames(2,:) blocknames(3,:) blocknames(4,:) blocknames(5,:)');
        Eyelink('Message', 'V_TRIAL_GROUPING blocknames(1,:) blocknames(2,:) blocknames(3,:) blocknames(4,:) blocknames(5,:)');
        
        
        %Eyelink('Message', 'TRIALID %d', p.fullblockorder(1,epoch_num));
        
        % This supplies the title at the bottom of the eyetracker display
        %Eyelink('command', 'record_status_message "TRIAL %d"', p.fullblockorder(1,epoch_num));
        % Before recording, we place reference graphics on the host display
        % Must be offline to draw to EyeLink screen
        Eyelink('Command', 'set_idle_mode');
        % clear tracker display and draw box at fix point
        Eyelink('Command', 'clear_screen 0')
        %             Eyelink('command', 'draw_box %d %d %d %d 15', width/2-50, height/2-50, width/2+50, height/2+50);
        
        Eyelink('command', 'draw_box %d %d %d %d 15',center(1)-box, center(2)-box, center(1)+box, center(2)+box);
        
        %%%%% add in boxes at other locations
        Eyelink('command', 'draw_box1 %d %d %d %d 15', loc1_x-box, loc1_y -box, loc1_x+box, loc1_y+box);
        Eyelink('command', 'draw_box2 %d %d %d %d 15', loc2_x-box, loc2_y -box, loc2_x+box, loc2_y+box);
        Eyelink('command', 'draw_box3 %d %d %d %d 15', loc3_x-box, loc3_y -box, loc3_x+box, loc3_y+box);
        Eyelink('command', 'draw_box4 %d %d %d %d 15', loc4_x-box, loc4_y -box, loc4_x+box, loc4_y+box);
        Eyelink('command', 'draw_box5 %d %d %d %d 15', loc5_x-box, loc5_y -box, loc5_x+box, loc5_y+box);
        Eyelink('command', 'draw_box6 %d %d %d %d 15', loc6_x-box, loc6_y -box, loc6_x+box, loc6_y+box);
        Eyelink('command', 'draw_box7 %d %d %d %d 15', loc7_x-box, loc7_y -box, loc7_x+box, loc7_y+box);
        Eyelink('command', 'draw_box8 %d %d %d %d 15', loc8_x-box, loc8_y -box, loc8_x+box, loc8_y+box);
        Eyelink('Command', 'set_idle_mode');
        WaitSecs(0.01);%.05
        
        %%%actually start recording
        %Eyelink('StartRecording');
    end
    
    
    
    DrawFormattedText(window,'Waiting for scanner...','center','center',black,50);
    Screen('Flip',window);
    %passiveImages = [Passive_list1 Passive_list2 Passive_list3 Passive_list4 Passive_list5 Passive_list6 Passive_list7 Passive_list8 Passive_list9 Passive_list10 Passive_list11 Passive_list12 Passive_list13 Passive_list14 Passive_list15 Passive_list16];
    %%
    %%%%if exp --> put in wait for trigger
    %% Wait for trigger
    while triggerPressed == 0
        [keyIsDown, secs, keyCode, deltaSecs] =KbCheck(device);
        if keyCode(trigger)>0 || keyCode(trigger2)>0
            if triggerPressed == 0
                disp('trigger pressed!')
                triggerOn = 1;
                triggerPressed = 1;
            end
        end
    end
    %% Start experiment.
    Priority(9);
    hadmiddlefix=0;
    centerBox = [centerX-box, centerY-box, centerX+box, centerY+box]
    Screen('FillRect', window,white,centerBox)
    Screen('Flip',window)
    if triggerOn == 1
        expStart = GetSecs;
        if get_eye
            Eyelink('Message', 'TRIALID %d', 0);
            % This supplies the title at the bottom of the eyetracker display
                    Eyelink('command', 'record_status_message "TRIAL %d"', 0); 
        %%%actually start recording
            Eyelink('StartRecording');
        end
        DrawFormattedText(window,'+','center','center',black,48);
        Screen('Flip',window);
        
        if get_eye
            Eyelink('Message', 'SYNCTIME');
        end
        WaitSecs(FixDuration-(GetSecs-expStart));% 10.4 seconds or 4 TRs
        if get_eye
        % stop the recording of eye-movements for the current trial
            Eyelink('StopRecording');
            Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 1, center(1)-box, center(2)-box, center(1)+box, center(2)+box, blocknames(1,:));

            Eyelink('Message', '!V TRIAL_VAR index %d', numTrialFix)
            Eyelink('Message', '!V TRIAL_VAR type %s', blocknames(1,:))

            %%give it info about what group belongs to
            Eyelink('Message', '!V TRIAL_VAR_DATA %s', blocknames(1,:));

            % Sending a 'TRIAL_RESULT' message to mark the end of a trial in 
            % Data Viewer. This is different than the end of recording message 
            % END that is logged when the trial recording ends. The viewer will
            % not parse any messages, events, or samples that exist in the data 
            % file after this message.
            Eyelink('Message', 'TRIAL_RESULT 0')
        end
        numTrialFix = numTrialFix + 1;
        for b = 1:length(blocktype);
            if blockCounter == 5
                hadmiddlefix=1;
                if get_eye
                    Eyelink('Message', 'TRIALID %d', 0);
                    % This supplies the title at the bottom of the eyetracker display
                    Eyelink('command', 'record_status_message "TRIAL %d"', 0); 
                %%%actually start recording
                    Eyelink('StartRecording');
                end
                middleFix = GetSecs;
                if get_eye
                    Eyelink('Message', 'SYNCTIME');
                end
                fprintf '%%%%%%%%%%%%%%%%%%%%%%%%% ideal time after mid fix%%%%%%%%%%%%%%%%%%%%%%%% /n'
                idealTime= FixDuration + (blockCounter-1)*(TotalBlockTime)
                fprintf '%%%%%%%%%%%%%%%%%%%%%%%%% time so far after mid fix%%%%%%%%%%%%%%%%%%%%%%%% /n'
                timeSoFar=GetSecs-expStart
                extraTime=timeSoFar-idealTime;
                DrawFormattedText(window,'+','center','center',black,48);
                Screen ('Flip', window);
                while (GetSecs - middleFix) < FixDuration -extraTime 
                    WaitSecs(.001);
                end
                if get_eye
                    % stop the recording of eye-movements for the current trial
                    Eyelink('StopRecording');
                    Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 1, center(1)-box, center(2)-box, center(1)+box, center(2)+box, blocknames(1,:));
                    
                    Eyelink('Message', '!V TRIAL_VAR index %d', numTrialFix)
                    Eyelink('Message', '!V TRIAL_VAR type %s', blocknames(1,:))
                    
                    %%give it info about what group belongs to
                    Eyelink('Message', '!V TRIAL_VAR_DATA %s', blocknames(1,:));
                    
                    % Sending a 'TRIAL_RESULT' message to mark the end of a trial in
                    % Data Viewer. This is different than the end of recording message
                    % END that is logged when the trial recording ends. The viewer will
                    % not parse any messages, events, or samples that exist in the data
                    % file after this message.
                    Eyelink('Message', 'TRIAL_RESULT 0')
                end
                numTrialFix = numTrialFix + 1;
                MiddleFixDur = GetSecs - middleFix %should be 10.4 seconds of 4 TRs
                
            end
            if blocktype(b) == 1; %Cued attention conditions
                blockStart = GetSecs;
                if blockCounter <= length(blocktype)/2;
                    whichBlock = 1;
                elseif blockCounter > length(blocktype)/2;
                    whichBlock = 2;
                end
                
                %while (GetSecs - blockStart) < TotalBlockTime
                for t = 1:nTrialsPerBlock;
                    for c = whichBlock:whichBlock;
                        if firstTrial == 0; %if it's the first trial of the block, put up the block cue
                            DrawFormattedText(window,'Arrow Location','center','center',black,48);
                            Screen('Flip',window);
                            OnsetTime = GetSecs;
                            
                            idealTime=FixDuration + (blockCounter-1)*(TotalBlockTime)+ hadmiddlefix*FixDuration
                            timeSoFar=GetSecs-expStart;
                            extraTime=timeSoFar-idealTime;
                            while (GetSecs - blockStart) < (BlockCueDuration - extraTime)
                                WaitSecs(.001);
                            end
                
                
                
                
                
                            firstTrial = 1;
                            thisisblockcuedur = GetSecs - OnsetTime
                            
                            
                        end
                        trialStart = GetSecs;
                        CueUp = GetSecs;
                        if get_eye
                            Eyelink('Message', 'TRIALID %d', blocktype(b));
                            % This supplies the title at the bottom of the eyetracker display
                            Eyelink('command', 'record_status_message "TRIAL %d"', blocktype(b));
                            %%%actually start recording
                            Eyelink('StartRecording');
                        end
                        Screen('DrawTexture',window,cue,[],putCueRect,rotAngles(CueAtt_loc(t,c),:)); %arrow will point to target location (50% valid)
                        DrawFormattedText (window,CueAtt_list(t,c).word,'center', top_word_loc, black, 48); %put up word cues below and above the center arrow
                        DrawFormattedText (window,CueAtt_list(t,c).word,'center', bottom_word_loc, black, 48);
                        timetogettocue = GetSecs - trialStart;
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        if get_eye
                            Eyelink('Message', 'SYNCTIME');
                        end
                        once = 0; %set to 0 so you only write to the file once
                        a=[1 2 3 4 5 6 7 8]; % list of possible target numbers
                        h = CueAtt_loc(t,c); % the location that was actually cued
                        x = RandSample(a(a~=targNum(t,c))); % <-- find a replacement target number (this will be used at the cued location on invalid trials and another location for valid trials)
                        i = RandSample(a(a~=CueAtt_loc(t,c)));%,<-- choose  a second location 
                        which_target = RandSample([1 2 3 4]); % choose whcih of 4 exemplars the target will be (random on every trial)
                        which_repTarget = RandSample([1 2 3 4]);% choose whcih of 4 exemplars the replacement targ will be (random on every trial)
                        CueAtt_pic = imread([targetDir CueAtt_list(t,c).image '_' num2str(which_target) '.jpg']);
                        CueAttRep_pic = imread([targetDir CueAtt_list(x,c).image '_' num2str(which_repTarget) '.jpg']);
                        tx_CueAtt(t) = Screen('MakeTexture', window, CueAtt_pic);
                        Replacement_Targ(x) = Screen('MakeTexture',window, CueAttRep_pic);
                        while (GetSecs - trialStart) < CueDuration %2 seconds
                            %waiting
                        end
                        %once = 0
                        CueUp = GetSecs - CueUp;
                        
                        BlankUp = GetSecs;
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        if whetherMatchTrialcueAtt(t,c) == 1 % cue is valid
                            validinvalid = 'valid';
                            %Screen('DrawTexture', window, tx_CueAtt(p),[], destRect(CueAtt_list(p).location,:));
                            
                            % Load target and distractors into an ordered list
                            for loc = 1:9
                                if (loc ~= h) & (loc ~=i) %if it's a dirstractor location, put a distractor there
                                    ImgsToDraw(loc).tx = distsToDraw(distCounter);
                                    distCounter = distCounter + 1;
                                elseif loc == i % if it's the replacement target location, put the replacement target there (valid trial)
                                    ImgsToDraw(loc).tx = Replacement_Targ(x);
                                    
                                elseif loc == h %if it's the target location, put the target there (valid trial)
                                    ImgsToDraw(loc).tx = tx_CueAtt(t);
                                end
                            end
                            
                        elseif whetherMatchTrialcueAtt(t,c) == 0 % cue is invalid
                            validinvalid = 'invalid';
                            for loc = 1:9
                                if (loc ~= h) & (loc ~=i)%if it's a dirstractor location, put a distractor there
                                    ImgsToDraw(loc).tx = distsToDraw(distCounter);
                                    distCounter = distCounter + 1;
                                elseif loc == h % draw Replacement at cued location
                                    ImgsToDraw(loc).tx = Replacement_Targ(x);
                                    
                                elseif loc == i % draw Original Target at another location
                                    ImgsToDraw(loc).tx = tx_CueAtt(t);
                                end
                            end
                        end
                        while (GetSecs - trialStart) < CueDuration + BlankDuration
                            %waiting
                        end
                        BlankUp = GetSecs - BlankUp
                        TargUp = GetSecs;
                        Screen('DrawTextures', window, [ImgsToDraw.tx], [], destRect') %draws multiple textures at diff  locations at the same time 
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        OnsetTime = GetSecs;%%%%% should this be outside this loop? probably...
                        % Now show them
                        while (GetSecs - trialStart) < CueDuration + BlankDuration + ImageDuration
                            %waiting
                        end
                        TargUp = GetSecs - TargUp
                        RespUp = GetSecs;
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen ('Flip', window);
                        % Wait until all keys are released
                        
                        idealTime= FixDuration + (hadmiddlefix*FixDuration) + (blockCounter-1)*(TotalBlockTime)+ BlockCueDuration+  (CueDuration+BlankDuration+ImageDuration)*t + RespDuration*(t-1)
                        timeSoFar=GetSecs-expStart
                        extraTime=timeSoFar-idealTime
                            
                        while (GetSecs - trialStart ) < TotalTrialTime -extraTime
                            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(device);
                            if keyIsDown;
                                rt = secs-OnsetTime;
                                subjKeyPress = find(keyCode); %gets the actual keycode (e.g. 30, 31)
                            end
                            
                        end
                        if get_eye
                            % stop the recording of eye-movements for the current trial
                            Eyelink('StopRecording');
                            Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 1, center(1)-box, center(2)-box, center(1)+box, center(2)+box, blocknames(blocktype(b)+1,:));
                            
                            Eyelink('Message', '!V TRIAL_VAR index %d', numTrialFix)
                            Eyelink('Message', '!V TRIAL_VAR type %s', blocknames(blocktype(b)+1,:))
                            
                            %%give it info about what group belongs to
                            Eyelink('Message', '!V TRIAL_VAR_DATA %s', blocknames(blocktype(b)+1,:));
                            
                            % Sending a 'TRIAL_RESULT' message to mark the end of a trial in
                            % Data Viewer. This is different than the end of recording message
                            % END that is logged when the trial recording ends. The viewer will
                            % not parse any messages, events, or samples that exist in the data
                            % file after this message.
                            Eyelink('Message', 'TRIAL_RESULT 0')
                        end
                        % Check response at end of trial
                        if subjKeyPress == NonMatchKey
                            fprintf (['=====================NonMATCH=================== \n  subjKeyPress:' num2str(subjKeyPress) '\n'])
                            answer = 'nonmatch';
                        elseif subjKeyPress == MatchKey
                            fprintf (['=====================MATCH=================== \n  subjKeyPress:' num2str(subjKeyPress) '\n'])
                            answer = 'match'
                        elseif subjKeyPress == 1
                            fprintf (['=====================NONE=================== \n\n  subjKeyPress None:' num2str(subjKeyPress) '\n'])
                                %'subjKeyPress Match: ' num2str(subjKeyPress(MatchKey)) '\n' ...
                                %'Key Code All: ' num2str(subjKeyPress) '\n'])
                            answer = 'no response';
                        else 
                            answer = 'wrong button';
                        end
                        fprintf(log,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n',num2str(numTrial),'CueAtt',rt,validinvalid,answer,num2str(subjKeyPress),CueAtt_list(t,c).word,CueAtt_list(t,c).image,num2str(which_target),num2str(CueAtt_loc(t,c)),num2str(i),CueAtt_list(x,c).image,num2str(which_repTarget));
                        subjKeyPress = 1; %reset subjkeypress to 1 after every time you right
                        %waiting
                        
                        %RespUp = GetSecs - RespUp
                        trialTime = GetSecs -trialStart
                        numTrial = numTrial + 1; %increase trial counter
                        numTrialFix = numTrialFix + 1;
                    end
                    %once = 0;
                end
                blockTime = GetSecs - blockStart
                
                
                firstTrial = 0;
                %once = 0;
                blockCounter = blockCounter +1
                %end
                
                
                
            elseif blocktype(b) == 2
                blockStart = GetSecs;
                if blockCounter <= length(blocktype)/2;
                    whichBlock = 1;
                elseif blockCounter > length(blocktype)/2;
                    whichBlock = 2;
                end
                %while (GetSecs - blockStart) < TotalBlockTime
                for t = 1:nTrialsPerBlock
                    for c = whichBlock:whichBlock
                        if firstTrial == 0
                            DrawFormattedText(window,'Remember Location','center','center',black,48)
                            Screen('Flip',window);
                            OnsetTime = GetSecs;
                            idealTime= FixDuration + (blockCounter-1)*(TotalBlockTime)+ hadmiddlefix*FixDuration;
                            timeSoFar=GetSecs-expStart;
                            extraTime=timeSoFar-idealTime;
                            while (GetSecs - blockStart) < (BlockCueDuration - extraTime)
                                WaitSecs(.001);
                            end
                            firstTrial = 1
                            thisisblockcuedur = GetSecs - OnsetTime
                        end
                        trialStart = GetSecs;
                        CueUp = GetSecs;
                        if get_eye
                            Eyelink('Message', 'TRIALID %d', blocktype(b));
                            % This supplies the title at the bottom of the eyetracker display
                            Eyelink('command', 'record_status_message "TRIAL %d"', blocktype(b));
                            %%%actually start recording
                            Eyelink('StartRecording');
                        end
                        DrawFormattedText (window,MGAtt_list(t,c).word,'center', top_word_loc, black, 48); %draw word cue above nad below arrow cue
                        DrawFormattedText (window,MGAtt_list(t,c).word,'center', bottom_word_loc, black, 48);
                        timetogettocue = GetSecs - trialStart;
                        Screen('DrawTexture',window,noninf_cue,[],putCueRect,0) % put up noninformative arrow cue (double headed arrow)
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        if get_eye
                            Eyelink('Message', 'SYNCTIME');
                        end
                        once = 0;
                        h = MGAtt_list(t,c).location; % learned location
                        a=[1 2 3 4 5 6 7 8]; % list of all other locations/targnums
                        x = RandSample(a(a~=targNum(t,c)));%choose a different target num for the replacement targ
                        i = RandSample(a(a~=MGAtt_list(t,c).location));%choose second  different location the replacement target to go (valid trials) or actual target to go (invalid trials)
                        which_target = RandSample([1 2 3 4]); % randomly choose whihc exemplar
                        which_repTarget = RandSample([1 2 3 4]);
                        MGAtt_pic = imread([targetDir MGAtt_list(t,c).image '_' num2str(which_target) '.jpg']);
                        tx_MGAtt(t) = Screen('MakeTexture', window, MGAtt_pic);
                        MGAttRep_pic = imread([targetDir MGAtt_list(x,c).image '_' num2str(which_repTarget) '.jpg']);%read in replacement target
                        Replacement_Targ(x) = Screen('MakeTexture',window, MGAttRep_pic);
                        while (GetSecs - trialStart) < CueDuration
                            %waiting
                        end
                        CueUp = GetSecs - CueUp
                        BlankUp = GetSecs;
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        if whetherMatchTrialMGAtt(t,c) == 1 % cue is valid
                            validinvalid = 'valid';
                            %Screen('DrawTexture', window, tx_CueAtt(p),[], destRect(CueAtt_list(p).location,:));
                            
                            % Load target and distractors into an ordered list
                            for loc = 1:9
                                if (loc ~= h) & (loc ~=i)
                                    ImgsToDraw(loc).tx = distsToDraw(distCounter);
                                    distCounter = distCounter + 1;
                                elseif loc == i %draw replacement targ at uncued loc
                                    ImgsToDraw(loc).tx = Replacement_Targ(x);
                                    
                                elseif loc == h %draw orig targ at cued location
                                    ImgsToDraw(loc).tx = tx_MGAtt(t);
                                end
                            end
                            
                        elseif whetherMatchTrialMGAtt(t,c) == 0 %cue is invalid
                            validinvalid = 'invalid';
                            for loc = 1:9
                                if (loc ~= h) & (loc ~=i)
                                    ImgsToDraw(loc).tx = distsToDraw(distCounter);
                                    distCounter = distCounter + 1;
                                elseif loc == h % draw Replacement at cued location
                                    ImgsToDraw(loc).tx = Replacement_Targ(x);
                                    
                                elseif loc == i % draw Original Target at another location
                                    ImgsToDraw(loc).tx = tx_MGAtt(t);
                                end
                            end
                        end
                        while (GetSecs - trialStart) < CueDuration + BlankDuration
                            %waiting
                        end
                        BlankUp = GetSecs - BlankUp
                        TargUp = GetSecs;
                        % Now show them:
                        Screen('DrawTextures', window, [ImgsToDraw.tx], [], destRect')
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        OnsetTime = GetSecs;%%%%% should this be outside this loop? probably...
                        while (GetSecs - trialStart) < CueDuration + BlankDuration + ImageDuration
                            %waiting
                        end
                        TargUp = GetSecs - TargUp
                        RespUp = GetSecs;
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen ('Flip', window);
                        % Wait until all keys are released
                        idealTime= FixDuration + (hadmiddlefix*FixDuration) + (blockCounter-1)*(TotalBlockTime)+ BlockCueDuration+  (CueDuration+BlankDuration+ImageDuration)*t + RespDuration*(t-1)
                        timeSoFar=GetSecs-expStart;
                        extraTime=timeSoFar-idealTime;
                            
                        while (GetSecs - trialStart ) < TotalTrialTime -extraTime
                            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(device);
                            if keyIsDown;
                                rt = secs-OnsetTime;
                                subjKeyPress = find(keyCode); %gets the actual keycode (e.g. 30, 31)
                            end
                            
                        end
                        if get_eye
                            % stop the recording of eye-movements for the current trial
                            Eyelink('StopRecording');
                            Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 1, center(1)-box, center(2)-box, center(1)+box, center(2)+box, blocknames(blocktype(b)+1,:));
                            
                            Eyelink('Message', '!V TRIAL_VAR index %d', numTrialFix)
                            Eyelink('Message', '!V TRIAL_VAR type %s', blocknames(blocktype(b)+1,:))
                            
                            %%give it info about what group belongs to
                            Eyelink('Message', '!V TRIAL_VAR_DATA %s', blocknames(blocktype(b)+1,:));
                            
                            % Sending a 'TRIAL_RESULT' message to mark the end of a trial in
                            % Data Viewer. This is different than the end of recording message
                            % END that is logged when the trial recording ends. The viewer will
                            % not parse any messages, events, or samples that exist in the data
                            % file after this message.
                            Eyelink('Message', 'TRIAL_RESULT 0')
                        end
                        % Check response at end of trial
                        if subjKeyPress == NonMatchKey
                            fprintf (['=====================NonMATCH=================== \n  subjKeyPress:' num2str(subjKeyPress) '\n'])
                            answer = 'nonmatch';
                        elseif subjKeyPress == MatchKey
                            fprintf (['=====================MATCH=================== \n  subjKeyPress:' num2str(subjKeyPress) '\n'])
                            answer = 'match'
                        elseif subjKeyPress == 1
                            fprintf (['=====================NONE=================== \n\n  subjKeyPress None:' num2str(subjKeyPress) '\n'])
                                %'subjKeyPress Match: ' num2str(subjKeyPress(MatchKey)) '\n' ...
                                %'Key Code All: ' num2str(subjKeyPress) '\n'])
                            answer = 'no response'
                        else 
                            answer = 'wrong button'
                        end
                        
                        fprintf(log,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n',num2str(numTrial),'MGAtt',rt,validinvalid,answer,num2str(subjKeyPress),MGAtt_list(t,c).word,MGAtt_list(t,c).image,num2str(which_target),num2str(MGAtt_list(t,c).location),num2str(i),MGAtt_list(x,c).image,num2str(which_repTarget));

                        subjKeyPress = 1;%reset to 1
                        
                        RespUp = GetSecs - RespUp
                        trialTime = GetSecs -trialStart
                        numTrial = numTrial + 1;
                        numTrialFix = numTrialFix + 1;
                    end
                    once = 0;
                end
                blockTime = GetSecs - blockStart
                firstTrial = 0;
                blockCounter = blockCounter +1
                %end
            elseif blocktype(b) == 3 % Mem Retrieval condition
                blockStart = GetSecs;
                if blockCounter <= length(blocktype)/2;
                    whichBlock = 1;
                elseif blockCounter > length(blocktype)/2;
                    whichBlock = 2;
                end
                %while (GetSecs - blockStart) < TotalBlockTime
                for t = 1:nTrialsPerBlock
                    for c = whichBlock:whichBlock
                        
                        if firstTrial == 0
                            DrawFormattedText(window,'Remember Object','center','center',black,48)
                            Screen('Flip',window);
                            idealTime= FixDuration + (blockCounter-1)*(TotalBlockTime)+ hadmiddlefix*FixDuration;
                            timeSoFar=GetSecs-expStart;
                            extraTime=timeSoFar-idealTime;
                            while (GetSecs - blockStart) < (BlockCueDuration - extraTime)
                                WaitSecs(.001);
                            end
                            firstTrial = 1
                        end
                        trialStart = GetSecs;
                        if get_eye
                            Eyelink('Message', 'TRIALID %d', blocktype(b));
                            % This supplies the title at the bottom of the eyetracker display
                            Eyelink('command', 'record_status_message "TRIAL %d"', blocktype(b));
                            %%%actually start recording
                            Eyelink('StartRecording');
                        end
                        DrawFormattedText (window,MemRet_list(t,c).word,'center', top_word_loc, black, 48);
                        DrawFormattedText (window,MemRet_list(t,c).word,'center', bottom_word_loc, black, 48);
                        Screen('DrawTexture',window,noninf_cue,[],putCueRect,0)
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        if get_eye
                            Eyelink('Message', 'SYNCTIME');
                        end
                        once = 0;
                        h = MemRet_list(t,c).location; %this will always be 9 bc targets will always be presented at fixation
                        a = [1 2 3 4 5 6 7 8] ;% list of possible target numbers to choose from
                        x = RandSample(a(a~=targNum(t,c))); %choose a replacement target number for nonmatch/invalid trials
                        which_target = RandSample([1 2 3 4]); %choose exemplar for target
                        which_repTarget = RandSample([1 2 3 4]);%choose exemplar for replacement targ
                        MemRet_pic = imread([targetDir MemRet_list(t,c).image '_' num2str(which_target) '.jpg']);%orig target
                        tx_MemRet(t) = Screen('MakeTexture', window, MemRet_pic);
                        MemRetRep_pic = imread([targetDir MemRet_list(x,c).image '_' num2str(which_repTarget) '.jpg']);% replacement targ
                        Replacement_Targ(x) = Screen('MakeTexture',window, MemRetRep_pic);
                        
                        while (GetSecs - trialStart) < CueDuration
                            %waiting
                        end
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        whetherMatchTrialMemRet(t,c);
                        if whetherMatchTrialMemRet(t,c) == 1 % cue is valid
                            validinvalid = 'valid';
                            for loc = 1:9
                                if (loc ~= h) %& (loc ~=x)
                                    ImgsToDraw(loc).tx = distsToDraw(distCounter);
                                    distCounter = distCounter + 1;
                                elseif loc == h % draw orig target at center
                                    ImgsToDraw(loc).tx = tx_MemRet(t);
                                end
                            end
                            
                        elseif whetherMatchTrialMemRet(t,c) == 0
                            validinvalid = 'invalid'
                            for loc = 1:9
                                if (loc ~= h) %& (loc ~=x)
                                    ImgsToDraw(loc).tx = distsToDraw(distCounter);
                                    distCounter = distCounter + 1;
                                elseif loc == h % draw replacement Target at center
                                    ImgsToDraw(loc).tx = Replacement_Targ(x);
                                end
                            end
                        end
                        while (GetSecs - trialStart) < CueDuration + BlankDuration
                            %waiting
                        end
                        % Now show them:
                        TargUp = GetSecs;
                        Screen('DrawTextures', window, [ImgsToDraw.tx], [], destRect')
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        OnsetTime = GetSecs;
                        while (GetSecs - trialStart) < CueDuration + BlankDuration + ImageDuration
                            %waiting
                        end
                        TargUp = GetSecs - TargUp
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip', window);
                        GetSecs - OnsetTime;
                        % Wait until all keys are released
                        idealTime= FixDuration + (hadmiddlefix*FixDuration) + (blockCounter-1)*(TotalBlockTime)+ BlockCueDuration+  (CueDuration+BlankDuration+ImageDuration)*t + RespDuration*(t-1)
                        timeSoFar=GetSecs-expStart;
                        extraTime=timeSoFar-idealTime;
                            
                        while (GetSecs - trialStart ) < TotalTrialTime -extraTime
                            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(device);
                            if keyIsDown;
                                rt = secs-OnsetTime;
                                subjKeyPress = find(keyCode); %gets the actual keycode (e.g. 30, 31)
                            end
                            
                        end
                        if get_eye
                            % stop the recording of eye-movements for the current trial
                            Eyelink('StopRecording');
                            Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 1, center(1)-box, center(2)-box, center(1)+box, center(2)+box, blocknames(blocktype(b)+1,:));
                            
                            Eyelink('Message', '!V TRIAL_VAR index %d', numTrialFix)
                            Eyelink('Message', '!V TRIAL_VAR type %s', blocknames(blocktype(b)+1,:))
                            
                            %%give it info about what group belongs to
                            Eyelink('Message', '!V TRIAL_VAR_DATA %s', blocknames(blocktype(b)+1,:));
                            
                            % Sending a 'TRIAL_RESULT' message to mark the end of a trial in
                            % Data Viewer. This is different than the end of recording message
                            % END that is logged when the trial recording ends. The viewer will
                            % not parse any messages, events, or samples that exist in the data
                            % file after this message.
                            Eyelink('Message', 'TRIAL_RESULT 0')
                        end
                        % Check response at end of trial
                        if subjKeyPress == NonMatchKey
                            fprintf (['=====================NonMATCH=================== \n  subjKeyPress:' num2str(subjKeyPress) '\n'])
                            answer = 'nonmatch';
                        elseif subjKeyPress == MatchKey
                            fprintf (['=====================MATCH=================== \n  subjKeyPress:' num2str(subjKeyPress) '\n'])
                            answer = 'match'
                        elseif subjKeyPress == 1
                            fprintf (['=====================NONE=================== \n\n  subjKeyPress None:' num2str(subjKeyPress) '\n'])
                                %'subjKeyPress Match: ' num2str(subjKeyPress(MatchKey)) '\n' ...
                                %'Key Code All: ' num2str(subjKeyPress) '\n'])
                            answer = 'no response'
                        else 
                            answer = 'wrong button'
                        end
                        fprintf(log,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n',num2str(numTrial),'MemRet',rt,validinvalid,answer,num2str(subjKeyPress),MemRet_list(t,c).word,MemRet_list(t,c).image,num2str(which_target),num2str(MemRet_list(t,c).location),num2str(MemRet_list(t,c).location),MemRet_list(x,c).image,num2str(which_repTarget));

                        subjKeyPress = 1
                        %waiting
                        
                        %RespUp = GetSecs - RespUp
                        trialTime = GetSecs -trialStart
                        numTrial = numTrial + 1;
                        numTrialFix = numTrialFix + 1;
                    end
                    once = 0;
                end
                firstTrial = 0;
                %once = 0;
                blockCounter = blockCounter +1
                blockTime = GetSecs - blockStart
                %end
            elseif blocktype(b) == 4 % passive condition
                blockStart = GetSecs;
                if blockCounter <= length(blocktype)/2;
                    whichBlock = 1
                elseif blockCounter > length(blocktype)/2;
                    whichBlock = 2
                end
                %while (GetSecs - blockStart) < TotalBlockTime
                for t = 1:nTrialsPerBlock
                    for c = whichBlock:whichBlock
                        if firstTrial == 0
                            DrawFormattedText(window,'Passive','center','center',black,48)
                            Screen('Flip',window);
                            idealTime= FixDuration + (blockCounter-1)*(TotalBlockTime)+ hadmiddlefix*FixDuration;
                            timeSoFar=GetSecs-expStart;
                            extraTime=timeSoFar-idealTime;
                            while (GetSecs - blockStart) < (BlockCueDuration - extraTime)
                                WaitSecs(.001);
                            end
                            firstTrial = 1
                        end
                        trialStart = GetSecs;
                        if get_eye
                            Eyelink('Message', 'TRIALID %d', blocktype(b));
                            % This supplies the title at the bottom of the eyetracker display
                            Eyelink('command', 'record_status_message "TRIAL %d"', blocktype(b));
                            %%%actually start recording
                            Eyelink('StartRecording');
                        end
                        DrawFormattedText (window,'passive','center', top_word_loc, black, 48);
                        DrawFormattedText (window,'passive','center', bottom_word_loc, black, 48);
                        Screen('DrawTexture',window,noninf_cue,[],putCueRect,0);
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        if get_eye
                            Eyelink('Message', 'SYNCTIME');
                        end
                        once = 0;
                        while (GetSecs - trialStart) < CueDuration
                            %waiting
                        end
                        for loc = 1:9 %put up the same 9 images in different configurations every trial
                            PassImgCounter = PassImgCounter + 1;
                            ImgsToDraw(loc).tx = passiveImages(PassImgCounter);
                        end
                        
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        while (GetSecs - trialStart) < CueDuration + BlankDuration
                            %waiting
                        end
                        
                        % Now show them:
                        TargUp = GetSecs;
                        Screen('DrawTextures', window, [ImgsToDraw.tx], [], destRect')
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen('Flip',window);
                        OnsetTime = GetSecs;
                        while (GetSecs - trialStart) < CueDuration + BlankDuration + ImageDuration
                            %waiting
                        end
                        TargUp = GetSecs - TargUp
                        DrawFormattedText(window,'+','center','center',black,48);
                        Screen ('Flip', window);
                        GetSecs - OnsetTime;
                        RespUp = GetSecs;
                        
                        % Wait until all keys are released
                        idealTime= FixDuration + (hadmiddlefix*FixDuration) + (blockCounter-1)*(TotalBlockTime)+ BlockCueDuration+  (CueDuration+BlankDuration+ImageDuration)*t + RespDuration*(t-1)
                        timeSoFar=GetSecs-expStart;
                        extraTime=timeSoFar-idealTime;
                            
                        while (GetSecs - trialStart ) < TotalTrialTime -extraTime
                            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(device);
                            if keyIsDown;
                                rt = secs-OnsetTime;
                                subjKeyPress = find(keyCode); %gets the actual keycode (e.g. 30, 31)
                            end
                            
                        end
                        if get_eye
                            % stop the recording of eye-movements for the current trial
                            Eyelink('StopRecording');
                            Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 1, center(1)-box, center(2)-box, center(1)+box, center(2)+box, blocknames(blocktype(b)+1,:));
                            
                            Eyelink('Message', '!V TRIAL_VAR index %d', numTrialFix)
                            Eyelink('Message', '!V TRIAL_VAR type %s', blocknames(blocktype(b)+1,:))
                            
                            %%give it info about what group belongs to
                            Eyelink('Message', '!V TRIAL_VAR_DATA %s', blocknames(blocktype(b)+1,:));
                            
                            % Sending a 'TRIAL_RESULT' message to mark the end of a trial in
                            % Data Viewer. This is different than the end of recording message
                            % END that is logged when the trial recording ends. The viewer will
                            % not parse any messages, events, or samples that exist in the data
                            % file after this message.
                            Eyelink('Message', 'TRIAL_RESULT 0')
                        end
                        % Check response at end of trial
                        if subjKeyPress == NonMatchKey
                            fprintf (['=====================NonMATCH=================== \n  subjKeyPress:' num2str(subjKeyPress) '\n'])
                            answer = 'nonmatch';
                        elseif subjKeyPress == MatchKey
                            fprintf (['=====================MATCH=================== \n  subjKeyPress:' num2str(subjKeyPress) '\n'])
                            answer = 'match'
                        elseif subjKeyPress == 1
                            fprintf (['=====================NONE=================== \n\n  subjKeyPress None:' num2str(subjKeyPress) '\n'])
                                %'subjKeyPress Match: ' num2str(subjKeyPress(MatchKey)) '\n' ...
                                %'Key Code All: ' num2str(subjKeyPress) '\n'])
                            answer = 'no response'
                        else 
                            answer = 'wrong button'
                        end
                        fprintf(log,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n',num2str(numTrial),'Passive',rt,'passive',answer,num2str(subjKeyPress),'passive','passive','passive','passive','passive','passive','passive');

                        subjKeyPress = 1
                        %waiting
                        
                        %RespUp = GetSecs - RespUp
                        trialTime = GetSecs -trialStart
                        numTrial = numTrial + 1;
                        numTrialFix = numTrialFix + 1;
                    end
                    once = 0;
                    
                end
                firstTrial = 0
                %once = 0;
                blockCounter = blockCounter +1
                blockTime = GetSecs - blockStart
                
                %end
            
            end
            
                

        end
            RunTimeBeforeFinalFix = (GetSecs - expStart) %how long before "final fix"
            if blockCounter > 8
                FinalFix = GetSecs;
                if get_eye
                    Eyelink('Message', 'TRIALID %d', 0);
                    % This supplies the title at the bottom of the eyetracker display
                    Eyelink('command', 'record_status_message "TRIAL %d"', 0); 
                %%%actually start recording
                    Eyelink('StartRecording');
                end
                
                DrawFormattedText(window,'+','center','center',black,48);
                Screen ('Flip', window);
                if get_eye
                    Eyelink('Message', 'SYNCTIME');
                end
                while (GetSecs - expStart) < TotalRunTime
                    %fprintf 'i am in last fix'
                end
                if get_eye
                    % stop the recording of eye-movements for the current trial
                    Eyelink('StopRecording');
                    Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 1, center(1)-box, center(2)-box, center(1)+box, center(2)+box, blocknames(1,:));
                    
                    Eyelink('Message', '!V TRIAL_VAR index %d', numTrialFix)
                    Eyelink('Message', '!V TRIAL_VAR type %s', blocknames(1,:))
                    
                    %%give it info about what group belongs to
                    Eyelink('Message', '!V TRIAL_VAR_DATA %s', blocknames(1,:));
                    
                    % Sending a 'TRIAL_RESULT' message to mark the end of a trial in
                    % Data Viewer. This is different than the end of recording message
                    % END that is logged when the trial recording ends. The viewer will
                    % not parse any messages, events, or samples that exist in the data
                    % file after this message.
                    Eyelink('Message', 'TRIAL_RESULT 0')
                end
                numTrialFix = numTrialFix + 1;
                fprintf 'DONE'
                FinalFix = GetSecs - FinalFix %how long was final fix
                ActualTotalRunTime = GetSecs - expStart %total run duration
                fprintf '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! '
                blocktype
                fprintf '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                RestrictKeysForKbCheck([]);
                fclose(log);
              
                Screen(window,'Close');
                close all
                sca;
            end
    end
    %%%%%eyetracker
    %%%%stuff==============================================
    %%%%===================================================
 
    %     % STEP 7
    %     % finish up: stop recording eye-movements,
    %     % close graphics wp, close data file and shut down tracker
%      Eyelink('command', 'generate_default_targets = YES')
    if get_eye
        Eyelink('Command', 'set_idle_mode');
        WaitSecs(0.5);
        Eyelink('CloseFile');
        % download data file
        try
            fprintf('Receiving data file ''%s''\n', edf_filename );
            status=Eyelink('ReceiveFile');
            if status > 0
                fprintf('ReceiveFile status %d\n', status);
            end
            if 2==exist(edf_filename, 'file')
                fprintf('Data file ''%s'' can be found in ''%s''\n', edf_filename, pwd );
            end
        catch
            fprintf('Problem receiving data file ''%s''\n', edf_filename );
        end
        %%%%%%%%%%%%%%%%shut it down
        Eyelink('ShutDown');
    end
catch X
    sca
    ListenChar(0)
    ShowCursor
    rethrow(X)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% End the experiment (don't change anything in this section)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    RestrictKeysForKbCheck([]);
    fclose(log);
    Screen(window,'Close');
    close all
    sca;
    return
end
        

%for p = 1:length(MemRet_list)
%        imageFile = [stimdir imgs(imgSeqRSVP(p)).name];
%       pic = imread(imageFile);
%       tx(p) = Screen('MakeTexture',window,pic);
%    end




%end




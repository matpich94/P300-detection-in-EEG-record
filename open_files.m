clear all
close all
clc

%% Load Recorded Files

% Files properties
path = 'inputs\';
names = {'b_cake_1', 'b_cake_1_bis', 'b_cake_4', 'b_cake_2', 'b_love_4', 'b_love_5', ...
          'b_love_7_good','b_love_2', 'b_love_9', 'b_low_4_good', 'b_low_5', 'b_low_8',...
         'b_low_9_good','b_why_8', 'b_why_3',  'b_why_8_bis', 'b_wolf_8','b_wolf_5',...
         'b_wolf_4'};
     
extension = '.vhdr';

% Electrodes Properties
eeg_chans= {'Fz', 'Cz', 'Pz', 'Oz', 'P3', 'P4', 'PO7', 'PO8'}; % EEG channels to consider
electrodes = [2 24 13 17 14 19 46 50]; % EEG channels number

% Random Sequence applied during the experiment
sequences = [3, 5, 6, 2, 1, 4, 9, 8, 7,...
                 9, 4, 6, 1, 7, 3, 5, 8, 2,...
                 8, 7, 3, 4, 2, 5, 1, 6, 9,...
                 3, 6, 9, 4, 2, 1, 5, 7, 8,...
                 9, 6, 1, 4, 5, 7, 8, 2, 3,...
                 1, 4, 2, 8, 9, 7, 3, 6, 5,...
                 6, 8, 1, 2, 3, 5, 4, 9, 7,...
                 4, 9, 2, 3, 1, 8, 5, 7, 6,...
                 2, 9, 7, 6, 5, 4, 3, 8, 1,...
                 5, 6, 9, 7, 4, 1, 2, 8, 3];
             
% Data/Labels
Data_fourier = [];
Data_temporal = [];
Labels = [];
     
for f = 1:length(names)
    
%% Load the data
    file = [names{f}, extension];
    [EEG, ~] = pop_loadbv(path, file);    

    %% Frequency filter 
    
    % High pass to very low frequencies removal
    [b,a]=butter(2,2/(EEG.srate/2), 'high'); % filter parameters fc = 0.1 or 2 HZ
    for ch=1:size(EEG.data,1)
        eegfilt(ch,:)=filtfilt(b,a,double(EEG.data(ch,:)));
        
    end
    
    %Low pass to remove frequency above 800 Hz
    [b1,a1] = butter(2,800/(EEG.srate/2),'low');% filter parameters
    for ch=1:size(EEG.data,1)
        eegfilt(ch,:)=filtfilt(b1,a1,double(EEG.data(ch,:)));
    end

    %% Define the zone of the ten sequences
    latency = [EEG.event.latency].';
    duration_10_sequences = 72000/0.2;

    for i = 1:(length(EEG.event)-1)
       if latency(i+1) - latency(i)>= duration_10_sequences
           start_time = latency(i) + 5000;   
           disp(start_time)
       end    
    end


    %% Keep only the data between the start time and the end time
    data = eegfilt(:, (start_time:start_time + duration_10_sequences));

    %% Define the epochs 
    Epochs = cell(1,90);
    for i = 1:90
        Epochs{1,i} = data(electrodes, (4000*(i-1) + 1):(4000*i));
    end

    %% Remove the baseline
    for i = 1:90
        Epochs{i} = Epochs{i} - mean(Epochs{i},2);   
    end

    %% Fourrier Transform
    n_components = 40; % We keep 40 components from the FFT
    threshold= 300; %PSD Amplitude

    set = [];
    for j = 1:length(Epochs)
        sample = [];
        signal_temporal = [];
        for p = 1:8
            clearvars fxx pxx
            [pxx, fxx]= pwelch(Epochs{j}(p,:), [], 0, [], EEG.srate);
            sample = [sample; pxx(1:n_components)];  
            signal_temporal = [signal_temporal, Epochs{j}(p,:)];
        end
        set = [set, sample];
        Data_temporal = [Data_temporal; signal_temporal];
    end

    %% Defintion of the sets
    for j = 1:9
        ch = int2str(j);
        if contains(names{f},ch)
            disp (ch);
            label = (sequences == j);
        end
        
    end
    
    set = set';
    label = label';
    
    Data_fourier = [Data_fourier; set];
    Labels = [Labels; label];
    
    clearvars a b ch data duration_10_sequences EEG eegfilt start_time...
                Epochs fxx i j label set latency p pxx sample 


end
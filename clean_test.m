function cleaned_EEG = clean_test(path)

Electrod={'FP1';'FPZ';'FP2';'AF3';'AF4';'F7';'F5';'F3';'F1';'FZ';'F2';'F4';
    'F6';'F8';'FT7';'FC5';'FC3';'FC1';'FCZ';'FC2';'FC4';'FC6';'FT8';'T7';
    'C5';'C3';'C1';'CZ';'C2';'C4';'C6';'T8';'TP7';'CP5';'CP3';'CP1';'CPZ';
    'CP2';'CP4';'CP6';'TP8';'P7';'P5';'P3';'P1';'PZ';'P2';'P4';'P6';'P8';
    'PO7';'PO5';'PO3';'POZ';'PO4';'PO6';'PO8';'CB1';'O1';'OZ';'O2';'CB2'};

cd (path);,pth=pwd;

%  cd(['X:\TEMERTY2\TEMP\Data4Mina\new Nback\',subject]),pth=pwd;
    %cd(['X:\TEMERTY\TMSLAB\\Patients\',subject{nid},'\NBACK\POST6MONTHS\Raw']),pth=pwd;
    M=[];   EEG_T=[];
    
    for nb= 1:4
        
        dd=dir(['*',num2str(nb-1),'B*.cnt']);
        
        if ~isempty(dd)
            EEG = pop_loadcnt(dd.name , 'dataformat', 'auto','keystroke','on');
            EEG = pop_resample(EEG,1000);
            EEG = eeg_checkset( EEG );
            
            EEG = pop_select( EEG,'nochannel',{'M1' 'M2' 'VEO' 'HEO' 'EKG' 'EMG'});
            EEG = eeg_checkset( EEG );
            
            R=[];
            for n=1:1:length(EEG.event)-1
                if strcmp(EEG.event(n).type, EEG.event(n+1).type)
                    if  EEG.event(n).latency == EEG.event(n+1).latency, R=[R n];end
                end
            end
            EEG.event(R)=[];
            
            [x_filt,y_filt]=butter(2,[1 55]/(1000/2),'bandpass');
            for elec=1:size(EEG.data,1)
                EEG.data(elec,:)=filtfilt(x_filt,y_filt,double(EEG.data(elec,:)));
            end
            
end 
    end
    cleaned_EEG = EEG;
end



clc
clear
close all

%% design parameters

Fs = 100;
fc1 = 1;
fc2 = 15;

[b,a] = cheby1(7,0.1,[fc1 fc2]/(Fs/2));
[H,f] = freqz(b,a);

f = f/pi*Fs/2;

plot(f,abs(H))
grid minor
axis([0 50 0 1.1])

%% initilize parameters

c = 0;

window = 100;
noverlap = 50;
nfft = 128;
Fs = 100;

wname = 'db4';

Case = {'AFIB','APB','Bigeminy','LBBBB','NSR','PR','PVC','RBBBB'};

m = size(Case);

for case_ = 1:m(2)
    
    %% load data
    
    dir1 = ['../data/' Case{case_} '/'];
    list = ls(dir1);
    list(1:2,:) = [];
    
    [num_data,~] = size(list);
    
    for n = 1:num_data
        
        disp(list(n,:))
        load([dir1 '/' list(n,:)]);
        ecg = val;
        
        %% filter signal
        
        ecg_denoise = filtfilt(b,a,ecg);
        
        subplot(211);plot(ecg);title('noisy signal')
        subplot(212);plot(ecg_denoise);title('denoised signal')
        
        [~,len] = size(ecg);
        
        %% Segment signal
        
        num_len = 6;
        seg_len = len/num_len;
        
        for seg = 1:num_len
            
            c = c+1;
            ecg_seg = ecg_denoise((seg-1)*seg_len+1:seg*seg_len);
            
            %% Time-Fourier transform
            % Short time Fourier transform
            [S,F,T] = spectrogram(ecg_seg,window,noverlap,nfft,Fs);
            S = S./max(S(:));
            stft = imresize(S,[28,28]);
            
            % Continuous wavelet transform
            wt = cwt(ecg_seg);
            wt = wt/max(wt(:));
            wave = imresize(wt,[28,28]);
            
            fea(:,:,1) = stft;
            fea(:,:,2) = wave;
            
            %% feature map
            
            feature(:,:,:,c) = fea;
            
            %% set labels
            
            switch Case{case_}
                case 'AFIB'
                    label(c) = 1;
                case 'APB'
                    label(c) = 2;
                case 'Bigeminy'
                    label(c) = 3;
                case 'LBBBB'
                    label(c) = 4;
                case 'NSR'
                    label(c) = 5;
                case 'PR'
                    label(c) = 6;
                case 'PVC'
                    label(c) = 7;
                case 'RBBBB'
                    label(c) = 8;
            end
            
        end
        
    end
    
    clc
    
end




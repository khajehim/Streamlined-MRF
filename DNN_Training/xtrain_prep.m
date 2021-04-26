%%  MATLAB Fucntion to Prepare X Data for DNN Training 
%   Note: MATLAB Communications toolbox is required for this function to work
%   These codes are to accompany the following manuscript:
%   Streamlined Magnetic Resonance Fingerprinting: Fast Whole-brain Coverage with Deep-learning Based Parameter Estimation
%   NeuroImage 2021
%   DOI: TBD
%   Please send your comments and questions to:
%   Mahdi Khajehim, mahdi.khajehim@mail.utoronto.ca, mahdi.khajehim@gmail.com
%   Spring 2021
function  XTrain=xtrain_prep(SNR_Training,Noise_Train_Repeats,T1_range,T2_range,B1_range,Dictionary)

counter=1;
XTrain=cell(1,length(SNR_Training)*Noise_Train_Repeats*length(T1_range)*length(T2_range)*length(B1_range));

for i=1:1:length(SNR_Training)
    for j=1:Noise_Train_Repeats
        for T1_counter=1:length(T1_range)
            for T2_counter=1:length(T2_range)
                for B1_counter=1:length(B1_range)
                    
                    ts=squeeze(Dictionary(T1_counter,T2_counter,B1_counter,:)-min(Dictionary(T1_counter,T2_counter,B1_counter,:)))./(max(Dictionary(T1_counter,T2_counter,B1_counter,:))-min(Dictionary(T1_counter,T2_counter,B1_counter,:)));
                    ts2=(ts(1:200)); 
                    XTrain{counter}=awgn(ts2,SNR_Training(i),'measured'); % XTrain: Deep learning training data-set
                    counter=counter+1;
                    
                end
            end
        end
    end
end
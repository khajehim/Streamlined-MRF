%%  MATLAB Fucntion to Prepare Y Data for DNN Training 
%   These codes are to accompany the following manuscript:
%   Streamlined Magnetic Resonance Fingerprinting: Fast Whole-brain Coverage with Deep-learning Based Parameter Estimation
%   NeuroImage 2021
%   DOI: TBD
%   Please send your comments and questions to:
%   Mahdi Khajehim, mahdi.khajehim@mail.utoronto.ca, mahdi.khajehim@gmail.com
%   Spring 2021
function  YTrain=ytrain_prep(SNR_Training,Noise_Train_Repeats,T1_range,T2_range,B1_range)


counter=1;

for i=1:1:length(SNR_Training)
    for j=1:Noise_Train_Repeats
        for T1_counter=1:length(T1_range)
            for T2_counter=1:length(T2_range)
                for B1_counter=1:length(B1_range)
                    
                    YTrain{1,counter}=[T1_range(T1_counter);T2_range(T2_counter);B1_range(B1_counter)]; 
                    counter=counter+1;
                    
                end
            end
        end
    end
end
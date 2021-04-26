%%  MATLAB Function to Estimate T1,B1+ and T2*  Based on Dictionary Matching
%   These codes are to accompany the following manuscript:
%   Streamlined Magnetic Resonance Fingerprinting: Fast Whole-brain Coverage with Deep-learning Based Parameter Estimation
%   NeuroImage 2021
%   DOI: TBD
%   Please send your comments and questions to:
%   Mahdi Khajehim, mahdi.khajehim@mail.utoronto.ca, mahdi.khajehim@gmail.com
%   Spring 2021

function      [T1_Map,T2star_Map,B1_Map]=Dic_match_map(data_nor1,T1_range0,B1_range0,T2_range0,Dictionary_nor1,SlcNum)


f = waitbar(0,' Initializing Dictionary Matching ...');
Num_of_Iterations=size(data_nor1,1)*size(data_nor1,2);
percent_counter=0;
tic 
T1_Map=zeros(size(data_nor1,1),size(data_nor1,2));
T2star_Map=zeros(size(data_nor1,1),size(data_nor1,2));
B1_Map=zeros(size(data_nor1,1),size(data_nor1,2));

for i=1:size(data_nor1,1)
    for j=1:size(data_nor1,2)
        
        data_ts=squeeze(data_nor1(i,j,:));
        
        [~,T1_Map(i,j),T2star_Map(i,j),B1_Map(i,j)]= cal_cor_val_ver1(i,j,T1_range0,T2_range0,B1_range0,data_ts,Dictionary_nor1);
        
        percent_counter=percent_counter+(1/Num_of_Iterations);
        elapsedTime = toc ;
        waitbar(percent_counter,f,{['Dictionary Matching for Slice = ' num2str(SlcNum) ' ( ' num2str(round(100*percent_counter)) ' % completed )...' ];[ 'Remaining Time : ' num2str(floor(((elapsedTime/60)/percent_counter)-(elapsedTime/60))) ' Minutes' ]});
        
    end
end
close (f)
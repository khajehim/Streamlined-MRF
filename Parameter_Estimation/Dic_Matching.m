%%  MATLAB Code to Estimate Parameters Based on Dictionary Matching (to compare with DNN)
%   These codes are to accompany the following manuscript:
%   Streamlined Magnetic Resonance Fingerprinting: Fast Whole-brain Coverage with Deep-learning Based Parameter Estimation
%   NeuroImage 2021
%   DOI: TBD
%   Please send your comments and questions to:
%   Mahdi Khajehim, mahdi.khajehim@mail.utoronto.ca, mahdi.khajehim@gmail.com
%   Spring 2021
%% read data

NumSlc=24;
selpath = uigetdir; % select the path in which data is located
cd(selpath)
% Dimensions as follows: X(x-dimension,y-dimension,slice-dimension,time-dimension)
load('X.mat') % X contains an example dataset, contact corres author for data sharing agreement


%% Code for reconstruction of the multi-slice data using Dictionary Matching

% Normalize the Dictionary 
Dictionary_nor=Dictionary./mean(Dictionary,4);
Dictionary_nor1=Dictionary_nor(:,:,:,1:200);
Dictionary_nor2=Dictionary_nor(:,:,:,201:280);

% Pre-allocate Space
T1_Map_MultiSlc=zeros(size(X,1),size(X,2),NumSlc);
B1_Map_MultiSlc=zeros(size(X,1),size(X,2),NumSlc);
T2star_Map_MultiSlc=zeros(size(X,1),size(X,2),NumSlc);
T2_Map_MultiSlc=zeros(size(X,1),size(X,2),NumSlc);

for SlcNum=1:NumSlc
    
    data=double(squeeze(X(:,:,SlcNum,:)));
    
    % Normalize the data
    data_nor=data./mean(data,3);       
    data_nor1=data_nor(:,:,1:200);      % GE Stage
    data_nor2=data(:,:,201:end);        % SE Stage
    
 
    % Dictionary Matching Estimates
    [T1_Map,T2star_Map,B1_Map]=Dic_match_map(data_nor1,T1_range0,B1_range0,T2_range0,Dictionary_nor1,SlcNum);
    
    % Just T2 Mapping: doesn't need neural network but uses values coming from the previous stage!)
    T2_Map=DicMatch_t2map(data_nor2,T1_range0,B1_range0,T1_Map,T2_range0,B1_Map,Dictionary_nor2);
    
    % 3rd dimension is the slice dimension
    T1_Map_MultiSlc(:,:,SlcNum)=T1_Map;
    B1_Map_MultiSlc(:,:,SlcNum)=B1_Map;
    T2star_Map_MultiSlc(:,:,SlcNum)=T2star_Map;
    T2_Map_MultiSlc(:,:,SlcNum)=T2_Map;
    
end


%% Multi-Slice Figures

% T1
T1_Map_MultiSlc_DNN2=reshape(T1_Map_MultiSlc,[size(data_nor,1) size(data_nor,1) 1 NumSlc]);
figure;montage(T1_Map_MultiSlc_DNN2,[]);
colorbar
caxis([0 2500])
title(' T1 Map DNN (ms)')
colormap(gca,'hot');
pause(2)

% T2
T2_Map_True_MultiSlc_DNN2=reshape(T2_Map_MultiSlc,[size(data_nor,1) size(data_nor,1) 1 NumSlc]);
figure;montage(T2_Map_True_MultiSlc_DNN2,[]);
colorbar
caxis([0 200])
title(' T2 Map DNN (ms)')
colormap(gca,'hot');
pause(2)

% T2*
T2_Map_MultiSlc_DNN2=reshape(T2star_Map_MultiSlc,[size(data_nor,1) size(data_nor,1) 1 NumSlc]);
figure;montage(T2_Map_MultiSlc_DNN2,[]);
colorbar
caxis([0 200])
title(' T2* Map DNN (ms)')
colormap(gca,'hot');
pause(2)


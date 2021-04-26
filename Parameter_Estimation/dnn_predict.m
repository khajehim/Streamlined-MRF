%%  MATLAB Fucntion to Generate the T1/T2*/B1 estimates using the trained DNN
%   These codes are to accompany the following manuscript:
%   Streamlined Magnetic Resonance Fingerprinting: Fast Whole-brain Coverage with Deep-learning Based Parameter Estimation
%   NeuroImage 2021
%   DOI: TBD
%   Please send your comments and questions to:
%   Mahdi Khajehim, mahdi.khajehim@mail.utoronto.ca, mahdi.khajehim@gmail.com
%   Spring 2021

function [T1_Map,T2star_Map,B1_Map]=dnn_predict(data_nor,net)

T1_Map=zeros(size(data_nor,1),size(data_nor,2));
B1_Map=zeros(size(data_nor,1),size(data_nor,2));
T2star_Map=zeros(size(data_nor,1),size(data_nor,2));

for i=1:size(data_nor,1)
    for j=1:size(data_nor,2)
        if( data_nor(i,j)~=0)
            
            M=predict(net,squeeze(data_nor(i,j,:))); % this is where the network is being used!
            
            T1_Map(i,j)=M(1);
            T2star_Map(i,j)=M(2);
            B1_Map(i,j)=M(3);
            
        else
            T1_Map(i,j)=0;
            T2star_Map(i,j)=0;
            B1_Map(i,j)=0;
        end
    end
end

%%  MATLAB Fucntion to Generate the T2-Map Using a mini-dictionary and DNN Estimates from the First Stage
%   These codes are to accompany the following manuscript:
%   Streamlined Magnetic Resonance Fingerprinting: Fast Whole-brain Coverage with Deep-learning Based Parameter Estimation
%   NeuroImage 2021
%   DOI: TBD
%   Please send your comments and questions to:
%   Mahdi Khajehim, mahdi.khajehim@mail.utoronto.ca, mahdi.khajehim@gmail.com
%   Spring 2021

function      T2_Map=dnn_t2map(data_nor2,T1_range0,B1_range0,T1_Map,T2_range0,B1_Map,TR_Values,TE_Values,FA_Values,calib_time)

T2_Map=zeros(size(data_nor2,1),size(data_nor2,1));
coder.extrinsic('Dic_Gen_EPI_sMRF_mex')

for i=1:size(data_nor2,1)
    for j=1:size(data_nor2,2)
        
        ts=squeeze(data_nor2(i,j,:));
        
        if( T1_Map(i,j)~=0 && ~isnan(T1_Map(i,j)))
            
            cc_val2=zeros(length(T2_range0),1);
            
            for r2=1:length(T2_range0)
                T1_value=T1_Map(i,j);
                B1_value=B1_Map(i,j);
                
                T1_value0=T1_value*(max(T1_range0)-min(T1_range0))+min(T1_range0);
                B1_value0=B1_value*(max(B1_range0)-min(B1_range0))+min(B1_range0);
                
                [Dic_ts0]=Dic_Gen_EPI_sMRF_mex(T1_value0,T2_range0(r2),B1_value0,TR_Values,TE_Values,FA_Values,calib_time);
                Dic_ts=squeeze(Dic_ts0(201:280));
                rr=  abs(dot(ts./norm(ts),Dic_ts./norm(Dic_ts)));
                cc_val2(r2)=rr;
                
            end
            
            [~, max_ind]=max(cc_val2(:));
            [r2_est]=ind2sub(size(cc_val2),max_ind);
            T2_Map(i,j)=T2_range0(r2_est);
            
        else
            
            T2_Map(i,j)=0;
        end
    end
end
%%  MATLAB Function to Estimate correlation value between a time series data and the dictionary
%   These codes are to accompany the following manuscript:
%   Streamlined Magnetic Resonance Fingerprinting: Fast Whole-brain Coverage with Deep-learning Based Parameter Estimation
%   NeuroImage 2021
%   DOI: TBD
%   Please send your comments and questions to:
%   Mahdi Khajehim, mahdi.khajehim@mail.utoronto.ca, mahdi.khajehim@gmail.com
%   Spring 2021
function  [cc_val,T1_val,T2_val,B1_val]= cal_cor_val_for_dic_match(T1_range,T2_range,B1_range,data_ts,Dictionary_nor1)

cc_val=zeros(length(T1_range),length(T2_range),length(B1_range));

if( (data_ts(1))~=0 && ~isnan(data_ts(1)) )
    
    for r1=1:length(T1_range)
        for r2=1:length(T2_range)
            for r3=1:length(B1_range)
                
                
                rr=  abs(dot(squeeze(data_ts)./norm(squeeze(data_ts)),squeeze(Dictionary_nor1(r1,r2,r3,:))./norm(squeeze(Dictionary_nor1(r1,r2,r3,:)))));
                
                cc_val(r1,r2,r3)=rr;
                
                
            end
        end
    end
    
    [max_val, max_ind]=max(cc_val(:));
    [r1_est, r2_est,r3_est]=ind2sub(size(cc_val),max_ind);
    
    
 
        T1_val=T1_range(r1_est);
        T2_val=T2_range(r2_est);
        B1_val=B1_range(r3_est);
    
else
    
    T1_val=0;
    T2_val=0;
    B1_val=0;
    
    
end
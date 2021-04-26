%%  MATLAB Code to Generate the Bloch Dictionary for DNN training
%   These codes are to accompany the following manuscript:
%   Streamlined Magnetic Resonance Fingerprinting: Fast Whole-brain Coverage with Deep-learning Based Parameter Estimation
%   NeuroImage 2021
%   DOI: TBD
%   Please send your comments and questions to:
%   Mahdi Khajehim:
%   mahdi.khajehim@mail.utoronto.ca, mahdi.khajehim@gmail.com
%   Spring 2021

%% Initialize main parameters

clc;
clear;
calib_time=20; % (ms.) Value as reported on the pulse sequence 

%% Sequence name and dictionary specification

Sequnece_Name='MRF';
T1_range0=100:20:4000;

T2_range0=[5:5:30, 32:2:130, 135:5:200, 210:10:350];
% T2_range0=[25:50:200];
B1_range0=0.5:0.05:1.5;

c_threshold=0.50;

%% Print Dictionary Details
format long
disp('Summary of Simulation Parameters : ');
fprintf('\n')
Names={'Number of T1 Values';'Number of T2/T2* Values';'Number of B1+ Values';'Overall Dictionary Size'};
Values=[length(T1_range0);length(T2_range0);length(B1_range0);length(T1_range0)*length(T2_range0)*length(B1_range0)];
Paramaeters=table(Names,Values)
format 

%% Initialize Sequence Values
% Copy these provided files to the current path
load('FA_Values');
load('TE_Values');
load('TR_Values');

%% TE, TR and FA plots

figure;plot(TE_Values);hold off
title('Pattern of TE Change');
xlabel('TE index');
ylabel(' TE (ms)');
axis([1 length(TE_Values) 1 max(TE_Values)+5]);
grid on

figure;plot(TR_Values);hold off
title('Pattern of TR Change');
xlabel('TR index');
ylabel(' TR (ms)');
axis([1 length(TR_Values) 1 max(TR_Values)+5]);
grid on

figure;plot(FA_Values);
title('Pattern of FA Change');
xlabel('TR index');
ylabel(' FA (Degree)');
grid on


%% Dictionary Generation (Dictionary required to train DNN)
% provided MEX compilation works in Intel processors
tic 
[Dictionary]=Dic_Gen_EPI_sMRF_mex(T1_range0,T2_range0,B1_range0,TR_Values,TE_Values,deg2rad(FA_Values),calib_time);
toc

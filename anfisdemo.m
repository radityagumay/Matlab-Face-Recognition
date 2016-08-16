
clear all;
close all;

load f; input=f(:, 1:54); target_tr=f(:,55);
load ff; test=F(:, 1:54); target_te=F(:,55);

%first classifier
%[fismat,outputs,recog_tr,recog_te,labels,performance]=scg_nfc(input,target_tr,test,target_te,epoch,class,clustersize);
[fismat,outputs,recog_tr,recog_te,labels,performance]=scg_nfc(input,target_tr,test,target_te,100,10,1);

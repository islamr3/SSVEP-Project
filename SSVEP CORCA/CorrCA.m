function [W, ISC]=CorrCA(data1,data2)
% data1 :The number of channels, Data length [sample]
% data2 :The number of channels, Data length [sample]
%  !!!! Note: data1 and data2 should have the same dimension.

[Nc,Ns]=size(data1);
data=[data1' data2'];
R=cov(data);

R11=R(1:Nc,1:Nc);
R22=R(Nc+1:end,Nc+1:end);
R12=R(1:Nc,Nc+1:end);
R21=R(Nc+1:end,1:Nc);

[W,ISC]=eig(R12+R21,R11+R22);
[ISC,indx]=sort(diag(ISC),'descend');
W=W(:,indx);
end
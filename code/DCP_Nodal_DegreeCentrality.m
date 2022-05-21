function DCP_Nodal_DegreeCentrality(InputFile, OutputFile, NType, AUCInterval)
RealNet=load(InputFile);
A=RealNet.A;
Dc=cellfun(@(a) DegreeCentrality(a, NType), A,...
    'UniformOutput', false);
Dc=cell2mat(Dc);
SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'Dc');
if AUCInterval>0
    deltas=AUCInterval;
    aDc=(sum(Dc, 2)-sum(Dc(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aDc', '-append');
end
function Dc=DegreeCentrality(Matrix, NType)
if NType==1
    [avgDc, Dc]=node_degree(Matrix);
elseif NType==2
    [avgDc, Dc]=node_degree_weight(Matrix);
end
Dc=Dc';

function [averk ki] = node_degree(A)
A = abs(A);
A = A - diag(diag(A));
A = logical(A);
ki = sum(A);
averk = mean(ki);
return

function [averk ki] = node_degree_weight(W)
W = abs(W);
W = W - diag(diag(W));

ki = sum(W);
averk = mean(ki);

return
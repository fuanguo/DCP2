function DCP_Nodal_ClustCoeff(InputFile, OutputFile, NType, AUCInterval)

RealNet=load(InputFile);
A=RealNet.A;
NCp=cellfun(@(a) NodalClustCoeff(a, NType), A,...
    'UniformOutput', false);
NCp=cell2mat(NCp);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'NCp');

if AUCInterval>0
    deltas=AUCInterval;
    aNCp=(sum(NCp, 2)-sum(NCp(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aNCp', '-append');
end

function Ci=NodalClustCoeff(Matrix, NType)
if NType==1
    [Cp, Ci]=node_clustcoeff_binary(Matrix);
elseif NType==2
    [Cp, Ci]=node_clustcoeff_weight(Matrix, 2); % Onnela
end
Ci=Ci';

function [avercc, cci] = node_clustcoeff_binary(A)
N = size(A,1);
cci = zeros(1,N);
for i = 1:N
    NV = find(A(i,:));
    if length(NV) == 1 || isempty(NV)
        cci(i) = 0;
    else
        cci(i) = ((sum(sum(A(NV,NV))))/2)/((length(NV)^2-length(NV))/2);
    end
end
avercc = mean(cci);
return

function [avercc cci] = node_clustcoeff_weight(W, Algorithm)
if Algorithm == 1 % Barrat's algorithm
    A = W;
    N = size(A,1);
    cci = zeros(1,N);
    for i = 1:N
        NV = find(A(i,:));
        if length(NV) == 1 || isempty(NV)
            cci(i) = 0;
        else
            nei = A(NV,NV);
            [X Y] = find(nei);
            cci(i) = sum([A(i,NV(X)) A(i,NV(Y))])/2/((length(NV)-1)*sum(A(i,:)));
        end
    end
    avercc = mean(cci);
elseif Algorithm == 2 % Onnela's algorithm
    W = W/(max(max(W)));
    A=W ~= 0;                     %adjacency matrix
    S = W.^(1/3)+(W.').^(1/3);	%symmetrized weights matrix ^1/3
    K = sum(A+A.',2);            	%total degree (in + out)
    cyc3 = diag(S^3)/2;           %number of 3-cycles (ie. directed triangles)
    K(cyc3 == 0) = inf;             %if no 3-cycles exist, make C=0 (via K=inf)
    CYC3 = K.*(K-1)-2*diag(A^2);	%number of all possible 3-cycles
    cci = (cyc3./CYC3)';              %clustering coefficient
    avercc = mean(cci);   
else
    error('Wrong input for the second argument')
end
return
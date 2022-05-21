function DCP_RUN_GenRandNet(InputFile, OutputFile, NType, RandNum)
RealNetS=load(InputFile);
A=RealNetS.A;
Rand=cellfun(@(a) GenerateRandCell(a, NType, RandNum), A,...
    'UniformOutput', false);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end

save(OutputFile, 'Rand', '-v7.3'); %Fixed a bug when Rand Mat were huge!

function Rand=GenerateRandCell(A, NType, RandNum)
RType='1';
Rand=cell(RandNum, 1);
if NType==1
    if strcmpi(RType, '1')
        Rand=cellfun(@(r) GenBRandNet1(A), Rand,...
            'UniformOutput', false);
    elseif strcmpi(RType, '2')
        Rand=cellfun(@(r) GenBRandNet2(A), Rand,...
            'UniformOutput', false);
    end
elseif NType==2
    if strcmpi(RType, '1')
        Rand=cellfun(@(r) GenWRandNet1(A), Rand,...
            'UniformOutput', false);
    elseif strcmpi(RType, '2')
        Rand=cellfun(@(r) GenWRandNet2(A), Rand,...
            'UniformOutput', false);
    end
end

function RandNet=GenBRandNet1(RealNet)
RandNet=dcp_gen_random_network1(RealNet);
if size(RandNet, 1)>500
    RandNet=sparse(RandNet);
end

function RandNet=GenBRandNet2(RealNet)
RandNet=dcp_gen_random_network2(RealNet);
if size(RandNet, 1)>500
    RandNet=sparse(RandNet);
end

function RandNet=GenWRandNet1(RealNet)
RandNet=dcp_gen_random_network1_weight(RealNet);
if size(RandNet, 1)>500
    RandNet=sparse(RandNet);
end

function RandNet=GenWRandNet2(RealNet)
RandNet=dcp_gen_random_network2_weight(RealNet);
if size(RandNet, 1)>500
    RandNet=sparse(RandNet);
end

function [Arand] = dcp_gen_random_network1(A)
Arand = A;
Arand = Arand - diag(diag(Arand));
nrew = 0;
[i1,j1] = find(Arand);
aux = find(i1>j1);
i1 = i1(aux);
j1 = j1(aux);
Ne = length(i1);
ntry = 2*Ne;
for i = 1:ntry
    e1 = 1+floor(Ne*rand);
    e2 = 1+floor(Ne*rand);
    v1 = i1(e1);
    v2 = j1(e1);
    v3 = i1(e2);
    v4 = j1(e2);
    if (v1~=v3)&&(v1~=v4)&&(v2~=v4)&&(v2~=v3);
        if rand > 0.5;
            if (Arand(v1,v3)==0)&&(Arand(v2,v4)==0);
                Arand(v1,v2) = 0;
                Arand(v3,v4) = 0;
                Arand(v2,v1) = 0;
                Arand(v4,v3) = 0;
                Arand(v1,v3) = 1;
                Arand(v2,v4) = 1;
                Arand(v3,v1) = 1;
                Arand(v4,v2) = 1;
                nrew = nrew + 1;
                i1(e1) = v1;
                j1(e1) = v3;
                i1(e2) = v2;
                j1(e2) = v4;
            end
        else
            v5 = v3;
            v3 = v4;
            v4 = v5;
            clear v5;
            if (Arand(v1,v3)==0)&&(Arand(v2,v4)==0);
                Arand(v1,v2) = 0;
                Arand(v4,v3) = 0;
                Arand(v2,v1) = 0;
                Arand(v3,v4) = 0;
                Arand(v1,v3) = 1;
                Arand(v2,v4) = 1;
                Arand(v3,v1) = 1;
                Arand(v4,v2) = 1;
                nrew = nrew + 1;
                i1(e1) = v1;
                j1(e1) = v3;
                i1(e2) = v2;
                j1(e2) = v4;

            end;
        end;
    end;
end;
return

function [Arand] = dcp_gen_random_network2(A)
N = length(A);
K = sum(A(:))/2;
randp = randperm(N*(N-1)/2);
Value = zeros(length(randp),1);
Value(randp(1:K)) = 1;
Arand = gretna_triu2matrix(Value, N);
return

function [Wrand] = dcp_gen_random_network1_weight(W)

W = W - diag(diag(W));

Wrand = W;
Topo = W;
Topo(Topo ~= 0) = 1;

N = length(Topo);
K = sum(sum(Topo))/2;

if K == N*(N-1)/2
    error('The inputed matrix/network is fully connected, please use gretna_gen_random_network2_weight.m to generate random networks')
else

    nrew = 0;
    
    [i1,j1] = find(Topo);
    aux = find(i1>j1);
    i1 = i1(aux);
    j1 = j1(aux);
    Ne = length(i1);
    
    ntry = 2*Ne;% maximum randmised times
    
    for i = 1:ntry
        e1 = 1+floor(Ne*rand);% randomly select two links
        e2 = 1+floor(Ne*rand);
        v1 = i1(e1);
        v2 = j1(e1);
        v3 = i1(e2);
        v4 = j1(e2);
       
        
        if (v1~=v3)&&(v1~=v4)&&(v2~=v4)&&(v2~=v3);
            if rand > 0.5;
                if (Topo(v1,v3)==0)&&(Topo(v2,v4)==0);
                    
                    % the following line prevents appearance of isolated clusters of size 2
                    %           if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);
                    
                    Topo(v1,v2) = 0;
                    Topo(v3,v4) = 0;
                    Topo(v2,v1) = 0;
                    Topo(v4,v3) = 0;
                    
                    Topo(v1,v3) = 1;
                    Topo(v2,v4) = 1;
                    Topo(v3,v1) = 1;
                    Topo(v4,v2) = 1;
                    
                    Wrand(v1,v3) = Wrand(v1,v2);
                    Wrand(v2,v4) = Wrand(v3,v4);
                    Wrand(v3,v1) = Wrand(v2,v1);
                    Wrand(v4,v2) = Wrand(v4,v3);
                    
                    Wrand(v1,v2) = 0;
                    Wrand(v3,v4) = 0;
                    Wrand(v2,v1) = 0;
                    Wrand(v4,v3) = 0;
                    
                    nrew = nrew+1;
                    
                    i1(e1) = v1;
                    j1(e1) = v3;
                    i1(e2) = v2;
                    j1(e2) = v4;
                    
                    % the following line prevents appearance of isolated clusters of size 2
                    %            end;
                    
                end;
            else
                v5 = v3;
                v3 = v4;
                v4 = v5;
                clear v5;
                
                if (Topo(v1,v3)==0)&&(Topo(v2,v4)==0);
                    
                    % the following line prevents appearance of isolated clusters of size 2
                    %           if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);
                    
                    Topo(v1,v2) = 0;
                    Topo(v4,v3) = 0;
                    Topo(v2,v1) = 0;
                    Topo(v3,v4) = 0;
                    
                    Topo(v1,v3) = 1;
                    Topo(v2,v4) = 1;
                    Topo(v3,v1) = 1;
                    Topo(v4,v2) = 1;
                    
                    Wrand(v1,v3) = Wrand(v1,v2);
                    Wrand(v2,v4) = Wrand(v3,v4);
                    Wrand(v3,v1) = Wrand(v2,v1);
                    Wrand(v4,v2) = Wrand(v4,v3);
                    
                    Wrand(v1,v2) = 0;
                    Wrand(v3,v4) = 0;
                    Wrand(v2,v1) = 0;
                    Wrand(v4,v3) = 0;
                    
                    nrew=nrew+1;
                    
                    i1(e1) = v1;
                    j1(e1) = v3;
                    i1(e2) = v2;
                    j1(e2) = v4;
                    
                    % the following line prevents appearance of isolated clusters of size 2
                    %           end;
                    
                end
            end
        end
    end
end

return

function [Wrand] = dcp_gen_random_network2_weight(W)
W = W - diag(diag(W));
Topo = W;
Topo(Topo ~= 0) = 1;
N = length(Topo);
K = sum(sum(Topo))/2;
if K == N*(N-1)/2
    [~, Weivec] = gretna_matrix2triu(W);
    
    randwei = Weivec(randperm(length(Weivec)));
    [Wrand] = gretna_triu2matrix (randwei, N);
    return
else
    nrew = 0;
    [i1,j1] = find(Topo);
    aux = find(i1>j1);
    i1 = i1(aux);
    j1 = j1(aux);
    Ne = length(i1);
    ntry = 2*Ne;
    for i = 1:ntry
        e1 = 1+floor(Ne*rand);
        e2 = 1+floor(Ne*rand);
        v1 = i1(e1);
        v2 = j1(e1);
        v3 = i1(e2);
        v4 = j1(e2);
        if (v1~=v3)&&(v1~=v4)&&(v2~=v4)&&(v2~=v3)
            if rand > 0.5
                if (Topo(v1,v3)==0)&&(Topo(v2,v4)==0)
                    Topo(v1,v2) = 0;
                    Topo(v3,v4) = 0;
                    Topo(v2,v1) = 0;
                    Topo(v4,v3) = 0;
                    Topo(v1,v3) = 1;
                    Topo(v2,v4) = 1;
                    Topo(v3,v1) = 1;
                    Topo(v4,v2) = 1;
                    nrew = nrew+1;
                    i1(e1) = v1;
                    j1(e1) = v3;
                    i1(e2) = v2;
                    j1(e2) = v4;
                end
            else
                v5 = v3;
                v3 = v4;
                v4 = v5;
                clear v5;
                if (Topo(v1,v3)==0)&&(Topo(v2,v4)==0)
                    Topo(v1,v2) = 0;
                    Topo(v4,v3) = 0;
                    Topo(v2,v1) = 0;
                    Topo(v3,v4) = 0;
                    Topo(v1,v3) = 1;
                    Topo(v2,v4) = 1;
                    Topo(v3,v1) = 1;
                    Topo(v4,v2) = 1;
                    nrew=nrew+1;
                    i1(e1) = v1;
                    j1(e1) = v3;
                    i1(e2) = v2;
                    j1(e2) = v4;
                end;
            end;
        end;
    end;
end
Weivec = W(logical(triu(W)));
randwei = Weivec(randperm(length(Weivec)));
Mid = triu(Topo);
Mid(Mid ~= 0) = randwei;
Wrand = Mid + Mid';
return
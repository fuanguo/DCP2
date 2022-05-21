function DCP_Global_SmallWorld(InputFile, RandNetFile, OutputFile, NType, AUCInterval)
ClustAlgor=2;
RealNet=load(InputFile);
A=RealNet.A;
if ~isempty(RandNetFile)
    RandNet=load(RandNetFile);
    Rand=RandNet.Rand;
else
    Rand=[];
end
if NType==1
    Cp=cellfun(@(a) dcp_node_clustcoeff(a), A,...
        'UniformOutput', false);
    Lp=cellfun(@(a) dcp_node_shortestpathlength(a), A,...
        'UniformOutput', false);
elseif NType==2
    if ClustAlgor==2
        Cp=cellfun(@(a) dcp_node_clustcoeff_weight(a, 1), A,...
            'UniformOutput', false);
    elseif ClustAlgor==1
        Cp=cellfun(@(a) dcp_node_clustcoeff_weight(a, 2), A,...
            'UniformOutput', false);
    end
    Lp=cellfun(@(a) dcp_node_shortestpathlength_weight(a), A,...
        'UniformOutput', false);
end
Cp=cell2mat(Cp);
Lp=cell2mat(Lp);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'Cp', 'Lp');

if AUCInterval>0
    deltas=AUCInterval;
    aCp= (sum(Cp)-sum(Cp([1 end]))/2)*deltas;
    aLp=(sum(Lp)-sum(Lp([1 end]))/2)*deltas;
    save(OutputFile, 'aCp', 'aLp', '-append');
end

if ~isempty(Rand)
    [Cprand, Lprand]=cellfun(@(r) RandSmallWorld(r, NType, ClustAlgor), Rand,...
        'UniformOutput', false);
    Cprand=cell2mat(Cprand);
    Lprand=cell2mat(Lprand);
    Gamma=Cp./mean(Cprand);
    Lambda=Lp./mean(Lprand);
    Sigma=Gamma./Lambda;
    save(OutputFile, 'Gamma', 'Lambda', 'Sigma', '-append');
    if AUCInterval>0
        deltas=AUCInterval;
        aGamma=(sum(Gamma)-sum(Gamma([1 end]))/2)*deltas;
        aLambda=(sum(Lambda)-sum(Lambda([1 end]))/2)*deltas;
        aSigma=(sum(Sigma)-sum(Sigma([1 end]))/2)*deltas;
        save(OutputFile, 'aGamma', 'aLambda', 'aSigma', '-append');
    end
end

function [Cp, Lp]=RandSmallWorld(A, NType, ClustAlgor)
if NType==2
    if ClustAlgor==2
        Cp=cellfun(@(a) dcp_node_clustcoeff_weight(a, 1), A,...
            'UniformOutput', false);
    elseif ClustAlgor==1
        Cp=cellfun(@(a) dcp_node_clustcoeff_weight(a, 2), A,...
            'UniformOutput', false);
    end
    Lp=cellfun(@(a) dcp_node_shortestpathlength_weight(a), A,...
        'UniformOutput', false);
elseif NType==1
    Cp=cellfun(@(a) dcp_node_clustcoeff(a), A,...
        'UniformOutput', false);
    Lp=cellfun(@(a) dcp_node_shortestpathlength(a), A,...
        'UniformOutput', false);
end
Cp=cell2mat(Cp);
Lp=cell2mat(Lp);

function [avercc, cci] = dcp_node_clustcoeff(A)
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

function [averLp Lpi] = dcp_node_shortestpathlength(A)
N = length(A);
D = dcp_distance(A);
D = D + diag(diag(1./zeros(N,N)));
D = 1./D;
Lpi = 1./(sum(D)/(N-1));
averLp = 1/(sum(sum(D))/(N*(N-1)));
return

function [D] = dcp_distance(A)
A = abs(A);
A = A - diag(diag(A));
[D] = all_shortest_paths(sparse(double(A)),struct('algname','auto'));
return

function [D,P] = all_shortest_paths(A,varargin)
[trans check full2sparse] = get_matlab_bgl_options(varargin{:});
if full2sparse && ~issparse(A), A = sparse(A); end
options = struct('algname', 'auto', 'inf', Inf, 'edge_weight', 'matrix');
options = merge_options(options,varargin{:});
edge_weight_opt = 'matrix';
if strcmp(options.edge_weight, 'matrix')
 
else
    edge_weight_opt = options.edge_weight;
end
if check
    check_matlab_bgl(A,struct('values',1));
    if strcmpi(options.algname, 'auto')
        nz = nnz(A);
        if (nz/(numel(A)+1) > .1)
            options.algname = 'floyd_warshall';
        else
            options.algname = 'johnson';
        end
    end
else
    if strcmpi(options.algname, 'auto')
        error('all_shortest_paths:invalidParameter', ...
            'algname auto is not compatible with no check');       
    end
end
if trans, A = A'; end
if nargout > 1
    [D,P] = matlab_bgl_all_sp_mex(A,lower(options.algname),options.inf,edge_weight_opt);
    P = P';
else
    D = matlab_bgl_all_sp_mex(A,lower(options.algname),options.inf,edge_weight_opt);
end
if trans, D = D'; end

function [avercc cci] = dcp_node_clustcoeff_weight(W, Algorithm)
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

function [averLp, Lpi] = dcp_node_shortestpathlength_weight(W)
N = length(W);
D = gretna_distance_weight(W);
D = D + diag(diag(1./zeros(N,N)));
D = 1./D;
Lpi = 1./(sum(D)/(N-1));
averLp = 1/(sum(sum(D))/(N*(N-1)));
return
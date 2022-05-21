function DCP_Global_Efficiency(InputFile, RandNetFile, OutputFile, NType, AUCInterval)
RealNet=load(InputFile);
A=RealNet.A;
if ~isempty(RandNetFile)
    RandNet=load(RandNetFile);
    Rand=RandNet.Rand;
else
    Rand=[];
end

if NType==1
    Eloc=cellfun(@(a) dcp_node_local_efficiency(a), A,...
        'UniformOutput', false);
    Eg=cellfun(@(a) dcp_node_global_efficiency(a), A,...
        'UniformOutput', false);
elseif NType==2
    Eloc=cellfun(@(a) dcp_node_local_efficiency_weight(a), A,...
        'UniformOutput', false);
    Eg=cellfun(@(a) dcp_node_global_efficiency_weight(a), A,...
        'UniformOutput', false);
end
Eloc=cell2mat(Eloc);
Eg=cell2mat(Eg);


SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'Eloc', 'Eg');

if AUCInterval>0
    deltas=AUCInterval;
    aEloc= (sum(Eloc)-sum(Eloc([1 end]))/2)*deltas;
    aEg=(sum(Eg)-sum(Eg([1 end]))/2)*deltas;
    save(OutputFile, 'aEloc', 'aEg', '-append');
end

function [Eloc, Eg]=RandEfficiency(A, NType)
if NType==1
    Eloc=cellfun(@(a) dcp_node_local_efficiency(a), A,...
        'UniformOutput', false);
    Eg=cellfun(@(a) dcp_node_global_efficiency(a), A,...
        'UniformOutput', false);
elseif NType==2
    Eloc=cellfun(@(a) dcp_node_local_efficiency_weight(a), A,...
        'UniformOutput', false);
    Eg=cellfun(@(a) dcp_node_global_efficiency_weight(a), A,...
        'UniformOutput', false);
end
Eloc=cell2mat(Eloc);
Eg=cell2mat(Eg);

function [averlocE locEi] = dcp_node_local_efficiency(A)
N = length(A);
locEi = zeros(1,N);
for i=1:N
    NV =  find(A(i,:));
    if length(NV) > 1
        B = A(NV,NV);
        [locEi(i), tmp] = dcp_node_global_efficiency(B);
    end
end
averlocE = mean(locEi);
return

function [avergE gEi] = dcp_node_global_efficiency(A)
N = length(A);
D = dcp_distance(A);
D = D + diag(diag(1./zeros(N,N)));
D = 1./D;
gEi    = sum(D)/(N -1);
avergE = sum(sum(D))/(N*(N-1));
return 

function [averlocE locEi] = dcp_node_local_efficiency_weight(W)
N = length(W);
locEi = zeros(1,N);
for i=1:N
    NV =  find(W(i,:));
    if length(NV) > 1
        B = W(NV,NV);
        [locEi(i), tmp] = dcp_node_global_efficiency_weight(B);
    end
end
averlocE = mean(locEi);
return

function [avergE, gEi] = dcp_node_global_efficiency_weight(W)
N = length(W);
D = dcp_distance_weight(W);
D = D + diag(diag(1./zeros(N,N)));
D = 1./D;
gEi    = sum(D)/(N -1);
avergE = sum(sum(D))/(N*(N-1));
return

function [D] = dcp_distance(A)
A = abs(A);
A = A - diag(diag(A));
[D] = all_shortest_paths(sparse(double(A)),struct('algname','auto'));
return

function [D] = dcp_distance_weight(W)
W = abs(W);
W = W - diag(diag(W));
W(logical(W)) = 1./W(logical(W));
[D] = all_shortest_paths(sparse(W),struct('algname','auto'));
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


function DCP_Nodal_Efficiency(InputFile, OutputFile, NType, AUCInterval)
RealNet=load(InputFile);
A=RealNet.A;
Ne=cellfun(@(a) NodalEfficiency(a, NType), A,...
    'UniformOutput', false);
Ne=cell2mat(Ne);
SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'Ne');

if AUCInterval>0
    deltas=AUCInterval;
    aNe=(sum(Ne, 2)-sum(Ne(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aNe', '-append');
end

function Ne=NodalEfficiency(Matrix, NType)
if NType==1
    [avgNe, Ne]=node_global_efficiency(Matrix);
elseif NType==2
    [avgNe, Ne]=node_global_efficiency_weight(Matrix);
end
Ne=Ne';

function [avergE gEi] = node_global_efficiency(A)
N = length(A);
D = dcp_distance(A);
D = D + diag(diag(1./zeros(N,N)));
D = 1./D;
gEi    = sum(D)/(N -1);
avergE = sum(sum(D))/(N*(N-1));
return 

function [avergE, gEi] = node_global_efficiency_weight(W)
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
    % do nothing if we are using the matrix weights
else
    edge_weight_opt = options.edge_weight;
end

if check
    % check the values of the matrix
    check_matlab_bgl(A,struct('values',1));
    
    % set the algname
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


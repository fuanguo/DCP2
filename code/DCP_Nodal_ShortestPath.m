function DCP_Nodal_ShortestPath(InputFile, OutputFile, NType, AUCInterval)
RealNet=load(InputFile);
A=RealNet.A;
NLp=cellfun(@(a) NodalShortestPath(a, NType), A,...
    'UniformOutput', false);
NLp=cell2mat(NLp);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'NLp');

if AUCInterval>0
    deltas=AUCInterval;
    aNLp=(sum(NLp, 2)-sum(NLp(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aNLp', '-append');
end

function Li=NodalShortestPath(Matrix, NType)
if NType==1
    [Lp, Li]=node_shortestpathlength(Matrix);
elseif NType==2
    [Lp, Li]=node_shortestpathlength_weight(Matrix);
end
Li=Li';

function [averLp Lpi] = node_shortestpathlength(A)
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

function [averLp, Lpi] = node_shortestpathlength_weight(W)
N = length(W);
D = dcp_distance_weight(W);
D = D + diag(diag(1./zeros(N,N)));
D = 1./D;
Lpi = 1./(sum(D)/(N-1));
averLp = 1/(sum(sum(D))/(N*(N-1)));
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

function [trans check full2sparse] = get_matlab_bgl_options(varargin)
doptions = set_matlab_bgl_default();
if nargin>0
    options = merge_options(doptions,varargin{:});
else
    options = doptions;
end
trans = ~options.istrans;
check = ~options.nocheck;
full2sparse = options.full2sparse;

function options = merge_options(default_options,varargin)
if ~isempty(varargin) && mod(length(varargin),2) == 0
    options = merge_structs(struct(varargin{:}),default_options);
elseif length(varargin)==1 && isstruct(varargin{1})
    options = merge_structs(varargin{1},default_options);
elseif ~isempty(varargin)
    error('matlag_bgl:optionsParsing',...
        'There were an odd number of key-value pairs of options specified');
else
    options = default_options;
end

function S = merge_structs(A, B)
S = A;
fn = fieldnames(B);
for ii = 1:length(fn)
    if (~isfield(A, fn{ii}))
        S.(fn{ii}) = B.(fn{ii});
    end
end

function old_default = set_matlab_bgl_default(varargin)
persistent default_options;
if ~isa(default_options,'struct')
    % initial default options
    default_options = struct('istrans', 0, 'nocheck', 0, 'full2sparse', 0);
end
if nargin == 0
    old_default = default_options;
else
    old_default = default_options;
    default_options = merge_options(default_options,varargin{:});
end
   

function DCP_Nodal_BetweennessCentrality(InputFile, OutputFile, NType, AUCInterval)
RealNet=load(InputFile);
A=RealNet.A;
Bc=cellfun(@(a) BetweennessCentrality(a, NType), A,...
    'UniformOutput', false);
Bc=cell2mat(Bc);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'Bc');

if AUCInterval>0
    deltas=AUCInterval;
    aBc=(sum(Bc, 2)-sum(Bc(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aBc', '-append');
end

function Bc=BetweennessCentrality(Matrix, NType)
if NType==1
    [avgBc, Bc]=node_betweenness(Matrix);
elseif NType==2
    [avgBc, Bc]=node_betweenness_weight(Matrix);
end
Bc=Bc';

function [averb, bi] = node_betweenness(A)
A = abs(A);
A = A - diag(diag(A));

x = sparse(A);

[tmp, tmpE] = betweenness_centrality(x,'unweighted',1);

bi = tmp'/2;
averb = mean(bi);

return
function [averb, bi] = node_betweenness_weight(W)
W = abs(W);
W = W - diag(diag(W));
W(logical(W)) = 1./W(logical(W));

x = sparse(W);

[tmp, tmpE] = betweenness_centrality(x);

bi = tmp'/2;
averb = mean(bi);

return

function [bc,E] = betweenness_centrality(A,varargin)
[trans check full2sparse] = get_matlab_bgl_options(varargin{:});
if full2sparse && ~issparse(A), A = sparse(A); end

options = struct('unweighted', 0, 'ec_list', 0, 'edge_weight', 'matrix');
options = merge_options(options,varargin{:});

% edge_weights is an indicator that is 1 if we are using edge_weights
% passed on the command line or 0 if we are using the matrix.
edge_weights = 0;
edge_weight_opt = 'matrix';

if strcmp(options.edge_weight, 'matrix')
    % do nothing if we are using the matrix weights
else
    edge_weights = 1;
    edge_weight_opt = options.edge_weight;
end

if check
    % check the values
    if options.unweighted ~= 1 && edge_weights ~= 1
        check_matlab_bgl(A,struct('values',1,'noneg',1));
    else
        check_matlab_bgl(A,struct());
    end
    if edge_weights && any(edge_weights < 0)
        error('matlab_bgl:invalidParameter', ...
                'the edge_weight array must be non-negative');
    end
end

if trans
    A = A';
end

weight_arg = options.unweighted;
if ~weight_arg
    weight_arg = edge_weight_opt;
else
    weight_arg = 0;
end
if nargout > 1
    [bc,ec] = betweenness_centrality_mex(A,weight_arg);
    
    [i j] = find(A);
    if ~trans
        temp = i;
        i = j;
        j = temp;
    end
    
    if options.ec_list
        E = [j i ec];
    else
        E = sparse(j,i,ec,size(A,1),size(A,1));
    end
    
else
    bc = betweenness_centrality_mex(A,weight_arg);
end
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

function check_matlab_bgl(A,options)

if ~isfield(options, 'nodefault') || options.nodefault == 0
    if size(A,1) ~= size(A,2)
        error('matlab_bgl:invalidParameter', 'the matrix A must be square.');
    end
end

if isfield(options, 'values') && options.values == 1
    if ~isa(A,'double')
        error('matlab_bgl:invalidParameter', 'the matrix A must have double values.');
    end
end

if isfield(options, 'noneg') && options.noneg == 1
    v=min(min(A));
    if ~isempty(v) && v < 0
        error('matlab_bgl:invalidParameter', 'the matrix A must have non-negative values.');
    end
end

if isfield(options, 'sym') && options.sym == 1
    if ~isequal(A,A')
        error('matlab_bgl:invalidParameter', 'the matrix A must be symmetric.');
    end
end

if isfield(options, 'nosparse') && options.nosparse == 1
else
    if ~issparse(A)
        error('matlab_bgl:invalidParameter', 'the matrix A must be sparse.  (See set_matlab_bgl_default.)');
    end
end

if isfield(options,'nodiag') && options.nodiag == 1
    if any(diag(A))
        error('matlab_bgl:invalidParameter',...
            'the matrix A must not have any diagonal values')
    end
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
   

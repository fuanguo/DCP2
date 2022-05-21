function DCP_getThresMat(Mat, OutputFile, SType, TType, Thres, NType)
if ischar(Mat)
    Mat=load(Mat);
end
Mat=Mat-diag(diag(Mat));
if SType==1
    Mat=Mat.*(Mat>0);
elseif SType==2
    Mat=abs(Mat.*(Mat<0));
elseif SType==3
    Mat=abs(Mat);
else
    error('Error: Invalid Matrix Sign');
end
if TType==1
    TFlag='s';
elseif TType==2
    TFlag='r';
else
    error('Invalid Threshold Method');
    return
end
    
A=arrayfun(@(t) logical(dcp_R2b(Mat, TFlag, t)), Thres,...
    'UniformOutput', false);
if NType==2
    A=cellfun(@(bin) bin.*Mat, A, 'UniformOutput', false);
end
A=cellfun(@(a) a, A, 'UniformOutput', false);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'A');
function [A, rthr] = dcp_R2b(W, type, thr)
N = length(W);
W = abs(W);
W = W - diag(diag(W)); % removing the self-correlation
A = zeros(N);

if type == 's'
    if thr > 1 || thr <= 0
        error('0 < thr <= 1');
    end
    sparsity = thr;
    K = ceil(sparsity*N*(N-1));
    
    if mod(K,2) ~= 0
        K = K + 1;
    end
end

if type == 'k'
    if thr < 1 || thr > (N)*(N-1)/2,
        error(' 1 <= thr <= N*(N-1)/2');
    end
    K = 2*thr;
end

if type == 's' || type == 'k',
    Wvec = reshape(W, N*N,1);
    Wvec = sort(Wvec,'descend');
    rthr = Wvec((K));
else
    rthr = thr;
end

if rthr == 0
    A(W > rthr) = 1;
    warning('The non-zero mimimum in the matrix is larger than that determined by the specificed parameter!')
else
    A(W >= rthr) = 1;
end

return

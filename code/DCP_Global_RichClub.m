function DCP_Global_RichClub(InputFile, RandNetFile, OutputFile, NType,~)
RealNet=load(InputFile);
A=RealNet.A;
if ~isempty(RandNetFile)
    RandNet=load(RandNetFile);
    Rand=RandNet.Rand;
else
    Rand=[];
end

if NType==1
    phi_real=cellfun(@(a) dcp_rich_club(a), A,...
        'UniformOutput', false);
elseif NType==2
    phi_real=cellfun(@(a) dcp_rich_club_weight(a), A,...
        'UniformOutput', false);
end
phi_real=cell2mat(phi_real')';

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'phi_real');

if ~isempty(Rand)
    % Overall phi from random networks
    phi_rand=cellfun(@(r) RandRichClub(r, NType), Rand,...
        'UniformOutput', false);
    phi_rand=cell2mat(phi_rand')';
    phi_norm=phi_real./phi_rand;
    save(OutputFile, 'phi_norm', '-append');
end

function phi=RandRichClub(A, NType)
if NType==1
    phi=cellfun(@(a) dcp_rich_club(a), A,...
        'UniformOutput', false);
elseif NType==2
    phi=cellfun(@(a) dcp_rich_club_weight(a), A,...
        'UniformOutput', false);
end
phi=cell2mat(phi);
phi=mean(phi);

function phi = dcp_rich_club(A)
A=A - diag(diag(A));
A=abs(A);
N=size(A, 1);
phi=nan(1, N-1);
K=sum(A);
kmin = max([1 min(K)]); kmax = max(K);
k = kmin:kmax-1;
for i = 1:length(k)
    ind = find(K <= k(i));
    net = A;
    net(ind,:) = [];
    net(:,ind) = []; 
    if sum(net(:)) == 0, break, end
    phi(1, k(i)) = sum(net(:))/length(net)/(length(net)-1);
end

function phi = dcp_rich_club_weight(W)
W=W - diag(diag(W));
W=abs(W);
N=size(W, 1);
phi=nan(1, N-1);
Wvec = sort(W(logical(triu(W))),'descend');
Wbin = logical(W);
K  = sum(Wbin);
clear Wbin
kmin = max([1 min(K)]); kmax = max(K);
k = kmin:kmax-1;
for i = 1:length(k)
    ind = find(K <= k(i));
    net = W;
    net(ind,:) = [];
    net(:,ind) = [];
    if sum(net(:)) == 0, break, end
    index = find(triu(net));
    phi(1,k(i))  = sum(net(index))/sum(Wvec(1:length(index)));
end

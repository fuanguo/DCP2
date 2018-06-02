function DCP_matrix(subFile,opt)
[~,atlasName,~]=fileparts(opt.atlas);
if strcmp(atlasName,'aal90')
    brainLabel=1:90;
else
    brainLabel=1:max(max(max(spm_read_vols(spm_vol(opt.atlas)))));
end
indextem={};
i=1;
if opt.fa==1
    indextem{i}=[subFile filesep 'DCP_DTI_DATA' filesep 'dti_fa.nii'];
    i=i+1;
end
if opt.md==1
    indextem{i}=[subFile filesep 'DCP_DTI_DATA' filesep 'dti_adc.nii'];
    i=i+1;
end
if opt.nativeCheck==1
    DCP_DTI_matrix([subFile filesep 'DCP_DTI_DATA' filesep 'dti_' num2str(opt.angle) '_' num2str(opt.lowFA) '_' ...
        num2str(opt.seed) '.trk'],opt.atlas,brainLabel,...
        indextem,[subFile filesep 'DCP_MATRIX'],opt.fn,opt.length);
else
    DCP_DTI_matrix([subFile filesep 'DCP_DTI_DATA' filesep 'dti_' num2str(opt.angle) '_' num2str(opt.lowFA) '_' ...
        num2str(opt.seed) '.trk'],[subFile filesep 'DCP_PARCELLATION' filesep 'w' atlasName '.nii'],brainLabel,...
        indextem,[subFile filesep 'DCP_MATRIX'],opt.fn,opt.length);
end
end
function DCP_DTI_matrix(trkFile,atlasFile,brainLabel,templateFile,output,FNFlag,lengthFlag)
    if ~exist(output)
        mkdir(output);
    end
    Fibers={};
    [trkPath,trkName,trkfix]=fileparts(trkFile);
    [atlasPath,atlasName,atlasfix]=fileparts(atlasFile);
    trknetPath=[output filesep atlasName '_' trkName trkfix];
    [header tracks] = trk_read(trkFile);
    voxelsize = header.voxel_size;
    for ii=1:length(tracks)
        repvoxelsize = repmat(voxelsize,[size(tracks(1,ii).matrix,1),1]);
        Fibers{ii} = tracks(1,ii).matrix./repvoxelsize;     %实际空间坐标系变换到voxel空间
    end
    V = spm_vol(atlasFile);
    Atlas = spm_read_vols(V);
    for i=1:length(templateFile)
        VF{i}=spm_vol(templateFile{i});
        FA{i}=spm_read_vols(VF{i});
    end
    [XLim YLim ZLim] = size(Atlas);
    if FNFlag==1,
        Matrix_FNum = zeros(length(brainLabel),length(brainLabel));
    end
    if lengthFlag==1,
        Matrix_Length=zeros(length(brainLabel),length(brainLabel));
    end
    if length(templateFile)>0
        Matrix_Voxel=zeros(length(brainLabel),length(brainLabel));
    end
    for i=1:length(templateFile)
        Matrix_tem{i}=zeros(length(brainLabel),length(brainLabel));
    end
    nettracnum = 1;
    for i2 = 1:length(Fibers)
        pStart = floor(Fibers{i2}(1,:)+1);
        pEnd = floor(Fibers{i2}(end,:)+1);
        pStart(2) = YLim+1-pStart(2);
        pEnd(2) = YLim+1-pEnd(2);
        if pStart(1)>0 && pStart(1)<=XLim &&  pStart(2)>0 && pStart(2)<=YLim && pStart(3)>0 && pStart(3)<=ZLim && pEnd(1)>0 && pEnd(1)<=XLim && pEnd(2)>0 && pEnd(2)<=YLim && pEnd(3)>0 && pEnd(3)<=ZLim
            m = Atlas(pStart(1),pStart(2),pStart(3));
            n = Atlas(pEnd(1),pEnd(2),pEnd(3));
            if m >0 && n > 0 && m ~= n && ismember(m,brainLabel) && ismember(n,brainLabel)
                %FN
                xindex=find(brainLabel==m);
                yindex=find(brainLabel==n);
                if FNFlag==1 || lengthFlag==1
                    Matrix_FNum(xindex,yindex) = Matrix_FNum(xindex,yindex) + 1;
                    Matrix_FNum(yindex,xindex) = Matrix_FNum(yindex,xindex) + 1;
                end
                tracksnetwork(1,nettracnum) = tracks(1,i2);
                nettracnum = nettracnum+1;
                if length(templateFile)>0 || lengthFlag==1
                    for j=1:size(Fibers{i2},1)
                        point(j,:)=floor(Fibers{i2}(j,:)+1);
                        point(j,2) = YLim+1-point(j,2);
                        if point(j,1)>0 && point(j,1)<=XLim &&  point(j,2)>0 && point(j,2)<=YLim && point(j,3)>0 && point(j,3)<=ZLim
                            %FA
                            for k=1:length(templateFile)
                                Matrix_tem{k}(xindex,yindex)=Matrix_tem{k}(xindex,yindex)+FA{k}(point(j,1),point(j,2),point(j,3));
                                Matrix_tem{k}(yindex,xindex)=Matrix_tem{k}(yindex,xindex)+FA{k}(point(j,1),point(j,2),point(j,3));
                            end
                            Matrix_Voxel(xindex,yindex)=Matrix_Voxel(xindex,yindex)+1;
                            Matrix_Voxel(yindex,xindex)=Matrix_Voxel(yindex,xindex)+1;
                            %Length
                            if lengthFlag==1
                                if(j>1)
                                    Lengthtemp = pdist([Fibers{i2}(j,:);Fibers{i2}(j-1,:)]);
                                    Matrix_Length(xindex,yindex) = Matrix_Length(xindex,yindex) + Lengthtemp;
                                    Matrix_Length(yindex,xindex) = Matrix_Length(yindex,xindex) + Lengthtemp;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if length(templateFile)>0 || lengthFlag==1
        for il=1:length(brainLabel)
            for jl=1:length(brainLabel)
                if Matrix_Voxel(il,jl)~=0
                    for k=1:length(templateFile)
                        Matrix_tem{k}(il,jl)=Matrix_tem{k}(il,jl)/Matrix_Voxel(il,jl);
                    end
                    if lengthFlag==1
                        Matrix_Length(il,jl) = Matrix_Length(il,jl)./Matrix_FNum(il,jl);
                    end
                end
            end
        end
    end

    header.n_count = nettracnum-1;
    trk_write(header,tracksnetwork,trknetPath);
    if FNFlag==1
        save([output filesep atlasName '_' trkName '_FNum.mat'], 'Matrix_FNum');
        save([output filesep atlasName '_' trkName '_FNum.txt'], '-ascii','Matrix_FNum');
    end
    if lengthFlag==1
        save([output filesep atlasName '_' trkName '_Length.mat'], 'Matrix_Length');
        save([output filesep atlasName '_' trkName '_Length.txt'], '-ascii','Matrix_Length');
    end
    for i=1:length(templateFile)
        [~,tmpName,~]=fileparts(templateFile{i});
        if strcmp(tmpName,'dti_adc'),
            tmpName='dti_md';
        end
        eval(['Matrix_' tmpName '=Matrix_tem{i};']);
        save([output filesep atlasName '_' trkName '_' tmpName '.mat'],['Matrix_' tmpName]);
        save([output filesep atlasName '_' trkName '_' tmpName '.txt'],'-ascii',['Matrix_' tmpName]);
    end
end
function [header,tracks] = trk_read(filePath)
%TRK_READ - Load TrackVis .trk files
%TrackVis displays and saves .trk files in LPS orientation. After import, this
%function attempts to reorient the fibers to match the orientation of the
%original volume data.
%
% Syntax: [header,tracks] = trk_read(filePath)
%
% Inputs:
%    filePath - Full path to .trk file [char]
%
% Outputs:
%    header - Header information from .trk file [struc]
%    tracks - Track data structure array [1 x nTracks]
%      nPoints - # of points in each streamline
%      matrix  - XYZ coordinates and associated scalars [nPoints x 3+nScalars]
%      props   - Properties of the whole tract (ex: length)
%
% Example:
%    exDir           = '/path/to/along-tract-stats/example';
%    subDir          = fullfile(exDir, 'subject1');
%    trkPath         = fullfile(subDir, 'CST_L.trk');
%    [header tracks] = trk_read(trkPath);
%
% Other m-files required: none
% Subfunctions: get_header
% MAT-files required: none

% Author: John Colby (johncolby@ucla.edu)
% UCLA Developmental Cognitive Neuroimaging Group (Sowell Lab)
% Mar 2010

% edit by TengdaZhao 2013/09/03

% Parse in header
fid    = fopen(filePath,  'rb', 'l');
header = get_header(fid);

% Check for byte order
if header.hdr_size~=1000
    fclose(fid);
    fid    = fopen(filePath, 'r', 'b'); % Big endian for old PPCs
    header = get_header(fid);
end

if header.hdr_size~=1000, error('Header length is wrong'), end



% Check orientation
[tmp ix] = max(abs(header.image_orientation_patient(1:3)));
[tmp iy] = max(abs(header.image_orientation_patient(4:6)));
iz = 1:3;
iz([ix iy]) = [];


 iTrk=0;
 while feof(fid) == 0
    iTrk = iTrk+1;
    temp = fread(fid, 1, 'int');
    if (temp~=0)
    tracks(iTrk).nPoints = temp;
    tracks(iTrk).matrix  = fread(fid, [3+header.n_scalars, tracks(iTrk).nPoints], 'float')';
    
    if header.n_properties
        tracks(iTrk).props = fread(fid, header.n_properties, 'float');
    end
    
    % Modify orientation of tracks (always LPS) to match orientation of volume
    header.dim        = header.dim([ix iy iz]);
    header.voxel_size = header.voxel_size([ix iy iz]);
    coords = tracks(iTrk).matrix(:,1:3);
    coords = coords(:,[ix iy iz]);
    if header.image_orientation_patient(ix) < 0
        coords(:,ix) = header.dim(ix)*header.voxel_size(ix) - coords(:,ix);
    end
    if header.image_orientation_patient(3+iy) < 0
        coords(:,iy) = header.dim(iy)*header.voxel_size(iy) - coords(:,iy);
    end
    tracks(iTrk).matrix(:,1:3) = coords;
    header.n_count                   =iTrk;
    end
    
end

fclose(fid);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function trk_write(header,tracks,savePath)
%TRK_WRITE - Write TrackVis .trk files
%
% Syntax: trk_write(header,tracks,savePath)
%
% Inputs:
%    header   - Header information for .trk file [struc]
%    tracks   - Track data struc array [1 x nTracks]
%      nPoints  - # of points in each track
%      matrix   - XYZ coordinates and associated scalars [nPoints x 3+nScalars]
%      props    - Properties of the whole tract
%    savePath - Path where .trk file will be saved [char]
%
% Output files:
%    Saves .trk file to disk at location given by 'savePath'.
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: TRK_READ

% Author: John Colby (johncolby@ucla.edu)
% UCLA Developmental Cognitive Neuroimaging Group (Sowell Lab)
% Apr 2010

fid = fopen(savePath, 'w');

% Write header
fwrite(fid, header.id_string, '*char');
fwrite(fid, header.dim, 'short');
fwrite(fid, header.voxel_size, 'float');
fwrite(fid, header.origin, 'float');
fwrite(fid, header.n_scalars , 'short');
fwrite(fid, header.scalar_name', '*char');
fwrite(fid, header.n_properties, 'short');
fwrite(fid, header.property_name', '*char');
fwrite(fid, header.vox_to_ras', 'float');
fwrite(fid, header.reserved, '*char');
fwrite(fid, header.voxel_order, '*char');
fwrite(fid, header.pad2, '*char');
fwrite(fid, header.image_orientation_patient, 'float');
fwrite(fid, header.pad1, '*char');
fwrite(fid, header.invert_x, 'uchar');
fwrite(fid, header.invert_y, 'uchar');
fwrite(fid, header.invert_z, 'uchar');
fwrite(fid, header.swap_xy, 'uchar');
fwrite(fid, header.swap_yz, 'uchar');
fwrite(fid, header.swap_zx, 'uchar');
fwrite(fid, header.n_count, 'int');
fwrite(fid, header.version, 'int');
fwrite(fid, header.hdr_size, 'int');

% Check orientation
[tmp ix] = max(abs(header.image_orientation_patient(1:3)));
[tmp iy] = max(abs(header.image_orientation_patient(4:6)));
iz = 1:3;
iz([ix iy]) = [];

% Write body
for iTrk = 1:header.n_count
    % Modify orientation back to LPS for display in TrackVis
    header.dim        = header.dim([ix iy iz]);
    header.voxel_size = header.voxel_size([ix iy iz]);
    coords = tracks(iTrk).matrix(:,1:3);
    coords = coords(:,[ix iy iz]);
    if header.image_orientation_patient(ix) < 0
        coords(:,ix) = header.dim(ix)*header.voxel_size(ix) - coords(:,ix);
    end
    if header.image_orientation_patient(3+iy) < 0
        coords(:,iy) = header.dim(iy)*header.voxel_size(iy) - coords(:,iy);
    end
    tracks(iTrk).matrix(:,1:3) = coords;
    
    fwrite(fid, tracks(iTrk).nPoints, 'int');
    fwrite(fid, tracks(iTrk).matrix', 'float');
    if header.n_properties
        fwrite(fid, tracks(iTrk).props, 'float');
    end
end

fclose(fid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function header = get_header(fid)

header.id_string                 = fread(fid, 6, '*char')';
header.dim                       = fread(fid, 3, 'short')';
header.voxel_size                = fread(fid, 3, 'float')';
header.origin                    = fread(fid, 3, 'float')';
header.n_scalars                 = fread(fid, 1, 'short')';
header.scalar_name               = fread(fid, [20,10], '*char')';
header.n_properties              = fread(fid, 1, 'short')';
header.property_name             = fread(fid, [20,10], '*char')';
header.vox_to_ras                = fread(fid, [4,4], 'float')';
header.reserved                  = fread(fid, 444, '*char');
header.voxel_order               = fread(fid, 4, '*char')';
header.pad2                      = fread(fid, 4, '*char')';
header.image_orientation_patient = fread(fid, 6, 'float')';
header.pad1                      = fread(fid, 2, '*char')';
header.invert_x                  = fread(fid, 1, 'uchar');
header.invert_y                  = fread(fid, 1, 'uchar');
header.invert_z                  = fread(fid, 1, 'uchar');
header.swap_xy                   = fread(fid, 1, 'uchar');
header.swap_yz                   = fread(fid, 1, 'uchar');
header.swap_zx                   = fread(fid, 1, 'uchar');
header.n_count                   = fread(fid, 1, 'int')';
header.version                   = fread(fid, 1, 'int')';
header.hdr_size                  = fread(fid, 1, 'int')';
end
function DCP_eddycurrent(subPath)
  DCP_combine_DTI([subPath filesep 'DCP_DTI_DATA']);
  DCP_eddycurrent_cmd([subPath filesep 'DCP_DTI_DATA']);
end
function DCP_combine_DTI(filePath)
  bvalFile=dir([filePath filesep '*.bval']);
  bvecFile=dir([filePath filesep '*.bvec']);
  niftiFile=dir([filePath filesep '*.nii']);
  bvec=[];
  bval=[];
  mat=[];
  firstNiftiFile_v=spm_vol([filePath filesep niftiFile(1).name]);
  for i=1:length(bvalFile)
      temp=load([filePath filesep bvalFile(i).name],'-ascii');
      bval=cat(2,bval,temp);
      temp=load([filePath filesep bvecFile(i).name],'-ascii');
      bvec=cat(2,bvec,temp);
      temp=spm_read_vols(spm_vol([filePath filesep niftiFile(i).name]));
      mat=cat(4,mat,temp);
  end
  save([filePath filesep 'bval'],'-ascii','bval');
  save([filePath filesep 'bvec'],'-ascii','bvec');
  
  VG=firstNiftiFile_v(1);
  VG.fname=[filePath filesep 'DATA_4D.nii'];
  my_write_vol_nii(mat,VG,'','');
end
function DCP_eddycurrent_cmd(filePath)
  mfilePath=mfilename('fullpath');
  filesepIndex=regexp(mfilePath,filesep);
  parentPath=mfilePath(1:filesepIndex(length(filesepIndex)-1));
  if ~isempty(regexp(computer,'PCWIN')),
      eddyPath=[parentPath filesep 'winexe' filesep 'bneddy.exe'];
      system([eddyPath ' -i ' filePath filesep 'DATA_4D.nii' ' -o ' filePath filesep 'eddy_DATA_4D -ref 0']);
      rotate_bvec(filePath);
  else
      rotbvecPath=[parentPath filesep 'linuxexe' filesep 'rotbvecs'];
      system(['eddy_correct ' filePath filesep 'DATA_4D.nii ' filePath filesep 'eddy_DATA_4D.nii 0']);
      system([rotbvecPath ' ' filePath filesep 'bvec ' filePath filesep 'eddy_bvec ' filePath filesep 'eddy_DATA_4D.ecclog']);
      bvec=load([filePath filesep 'eddy_bvec']);
      bvec=bvec';
      save([filePath filesep 'eddy_bvec'],'-ascii','bvec');
      gzip([filePath filesep 'eddy_DATA_4D.nii'],filePath);
  end
end
function rotate_bvec(filePath)
    bvec=load([filePath filesep 'bvec'],'-ascii');
    for i=1:size(bvec,2)
        rotmat=importdata([filePath filesep 'eddy_DATA_4D.txt'],' ',5*(i-1)+1);
        rotmat=decompose(rotmat.data);
        rot_bvec(i,1)=bvec(1,i)*rotmat(1,1)+bvec(2,i)*rotmat(1,2)+bvec(3,i)*rotmat(1,3);
        rot_bvec(i,2)=bvec(1,i)*rotmat(2,1)+bvec(2,i)*rotmat(2,2)+bvec(3,i)*rotmat(2,3);
        rot_bvec(i,3)=bvec(1,i)*rotmat(3,1)+bvec(2,i)*rotmat(3,2)+bvec(3,i)*rotmat(3,3);
    end
    save([filePath filesep 'eddy_bvec'],'-ascii','rot_bvec');
end
function rotmat=decompose(affmat)
    aff3=affmat(1:3,1:3);
    x=affmat(1:3,1);
    y=affmat(1:3,2);
    z=affmat(1:3,3);
    sx=norm(x);
    sy=sqrt(dot(y,y)-(dot(x,y)^2)/(sx*sx));
    a=dot(x,y)/(sx*sy);
    x0=x/sx;
    y0=y/sy-a*x0;
    sz=sqrt(dot(z,z)-(dot(x0,z))^2-(dot(y0,z))^2);
    b=dot(x0,z)/sz;
    c=dot(y0,z)/sz;
    params(7)=sx;params(8)=sy;params(9)=sz;
    scales=zeros(3,3);scales(1,1)=sx;scales(2,2)=sy;scales(3,3)=sz;
    skew=[1 a b 0; 0 1 c 0; 0 0 1 0; 0 0 0 1];
    params(10)=a;params(11)=b;params(12)=c;
    rotmat=aff3*inv(scales)*inv(skew(1:3,1:3));
end
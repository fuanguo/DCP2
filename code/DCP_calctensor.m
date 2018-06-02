function DCP_calctensor(subFile)
  bval=load([subFile filesep 'DCP_DTI_DATA' filesep 'bval'],'-ascii');
  bval_value=bval(2);
  
  mfilePath=mfilename('fullpath');
  filesepIndex=regexp(mfilePath,filesep);
  parentPath=mfilePath(1:filesepIndex(length(filesepIndex)-1));
  if ~isempty(regexp(computer,'PCWIN')),
      dtkreconPath=[parentPath filesep 'winexe' filesep 'dti_recon.exe'];
  elseif ~isempty(regexp(computer,'GLNXA')),
      dtkreconPath=[parntPath filesep 'linexe' filesep 'dti_recon'];
  else
      dtkreconPath=[parntPath filesep 'macexe' filesep 'dti_recon'];
  end
  system([dtkreconPath ' ' subFile filesep 'DCP_DTI_DATA' filesep 'eddy_DATA_4D.nii.gz ' subFile filesep ...
      'DCP_DTI_DATA' filesep 'dti' ' -gm ' ...
      subFile filesep 'DCP_DTI_DATA' filesep 'eddy_bvec -b ' num2str(bval_value)]);
end
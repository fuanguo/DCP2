function DCP_tracker(subFile, opt)
  mfilePath=mfilename('fullpath');
  filesepIndex=regexp(mfilePath,filesep);
  parentPath=mfilePath(1:filesepIndex(length(filesepIndex)-1));
  invert_contents={'x','y','z','no invert'};
  swap_contents={'sxy','syz','szx','no swap'};
  opt.invert=invert_contents{opt.invert};
  if strcmp(opt.invert, 'no invert')
      opt.invert='';
  else
      opt.invert=['-i' opt.invert];
  end
  opt.swap=swap_contents{opt.swap};
  if ~isempty(regexp(computer,'PCWIN'))
      trackerPath=[parentPath filesep 'winexe' filesep 'dti_tracker.exe'];
  elseif ~isempty(regexp(computer,'GLNXA'))
      trackerPath=[parentPath filesep 'linexe' filesep 'dti_tracker'];
  else
      trackerPath=[parentPath filesep 'macexe' filesep 'dti_tracker'];
  end
  if exist([ subFile filesep 'DCP_DTI_DATA' filesep 'dti_' num2str(opt.angle) '_' num2str(opt.lowFA) '_' ...
        num2str(opt.seed) '.trk'])>0
    delete([ subFile filesep 'DCP_DTI_DATA' filesep 'dti_' num2str(opt.angle) '_' num2str(opt.lowFA) '_' ...
        num2str(opt.seed) '.trk']);
  end
  if strcmp(opt.swap, 'no swap')
    system([trackerPath ' ' subFile filesep 'DCP_DTI_DATA' filesep 'dti ' ...
        subFile filesep 'DCP_DTI_DATA' filesep 'dti_' num2str(opt.angle) '_' num2str(opt.lowFA) '_' ...
        num2str(opt.seed) '.trk -at ' num2str(opt.angle) ' ' opt.invert ' -m '...
        subFile filesep 'DCP_DTI_DATA' filesep 'dti_fa.nii ' num2str(opt.lowFA) ' ' num2str(opt.highFA) ' -it nii'...
        ' -rseed ' num2str(opt.seed)]);
  else
      system([trackerPath ' ' subFile filesep 'DCP_DTI_DATA' filesep 'dti ' ...
        subFile filesep 'DCP_DTI_DATA' filesep 'dti_' num2str(opt.angle) '_' num2str(opt.lowFA) '_' ...
        num2str(opt.seed) '.trk -at ' num2str(opt.angle)  ' ' opt.invertt ' -' opt.swap ' -m '...
        subFile filesep 'DCP_DTI_DATA' filesep 'dti_fa.nii ' num2str(opt.lowFA) ' ' num2str(opt.highFA) ' -it nii'...
        ' -rseed ' num2str(opt.seed)]);
  end
end
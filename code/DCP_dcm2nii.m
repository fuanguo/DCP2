function DCP_dcm2nii(subPath)
  if exist(subPath)==7
    modalityFile=dir(subPath);
    if ~isempty(regexp(computer,'MACI')) && strcmp(modalityFile(3).name, '.DS_Store')
        modalityFile(3)=[];
    end

    for i=3:length(dir(subPath))
        if modalityFile(i).isdir==1 && ~strcmp(modalityFile(i).name, 'DCP_DTI_DATA') && ~strcmp(modalityFile(i).name, 'DCP_PARCELLATION')...
                 && ~strcmp(modalityFile(i).name, 'DCP_MATRIX')
            DCP_dcm2nii_cmd([subPath filesep modalityFile(i).name])
        end
    end
  end
end
function DCP_dcm2nii_cmd(input)
  mfilePath=mfilename('fullpath');
  filesepIndex=regexp(mfilePath,filesep);
  parentPath=mfilePath(1:filesepIndex(length(filesepIndex)-1));
  if ~isempty(regexp(computer,'PCWIN')),
      dcm2niiPath=[parentPath filesep 'winexe' filesep 'dcm2nii.exe'];
  elseif ~isempty(regexp(computer,'GLNXA')),
      dcm2niiPath=[parentPath filesep 'linexe' filesep 'dcm2nii'];
  else
      dcm2niiPath=[parentPath filesep 'macexe' filesep 'dcm2nii'];
  end
  system([dcm2niiPath ' -g n ' input]);
end
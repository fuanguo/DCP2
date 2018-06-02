function DCP_bet(input,fValue,output,mask)
  [inputPath,inputName,postfix]=fileparts(input);
  mfilePath=mfilename('fullpath');
  filesepIndex=regexp(mfilePath,filesep);
  parentPath=mfilePath(1:filesepIndex(length(filesepIndex)-1));
  if ~isempty(regexp(computer,'PCWIN')),
      exePath=[parentPath filesep 'winexe' filesep];
      system([exePath 'dcm2nii -n n -s y -m n ' input]);
      if ~strcmp(inputPath, output)
        movefile([inputPath filesep 'f' inputName '.hdr'],[output filesep 'f' inputName '.hdr']);
        movefile([inputPath filesep 'f' inputName '.img'],[output filesep 'f' inputName '.img']);
      end
      if mask==0
          system([exePath 'bet ' output filesep 'f' inputName '.img ' output filesep 'bet_' inputName ' -f ' ...
              num2str(fValue)]);
          system([exePath 'dcm2nii -n y -g n -m n -o ' output filesep 'bet_' inputName ' ' ...
              output filesep 'bet_' inputName '.img']);
          movefile([output filesep 'fbet_' inputName '.nii'],[output filesep 'bet_' inputName '.nii']);
      else
           system([exePath 'bet ' output filesep 'f' inputName '.img ' output filesep 'bet_' inputName ' -m -f ' ...
              num2str(fValue)]);
           system([exePath 'dcm2nii -n y -g n -m n -o ' output filesep 'bet_' inputName ' ' ...
              output filesep 'bet_' inputName '.img']);
           system([exePath 'dcm2nii -n y -g n -m n -o ' output filesep 'bet_' inputName ' ' ...
              output filesep 'bet_' inputName '_mask.img']);
           movefile([output filesep 'fbet_' inputName '.nii'],[output filesep 'bet_' inputName '.nii']);
           movefile([output filesep 'fbet_' inputName '_mask.nii'],[output filesep 'bet_' inputName '_mask.nii']);
      end
      delete([output filesep '*.hdr']);
      delete([output filesep '*.img']);
  else
      if mask==0
        system(['bet2 ' input ' ' output filesep 'bet_' inputName ' -f ' num2str(fValue)]);
      else
        system(['bet2 ' input ' ' output filesep 'bet_' inputName ' -m -f ' num2str(fValue)]);
      end
  end
end
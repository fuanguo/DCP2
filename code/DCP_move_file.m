function DCP_move_file(subPath)
  if exist([subPath filesep 'DCP_DTI_DATA'])==7,
      rmdir([subPath filesep 'DCP_DTI_DATA'],'s');
  end
  if exist([subPath filesep 'DCP_PARCELLATION'])==7,
      rmdir([subPath filesep 'DCP_PARCELLATION'],'s');
  end
  if exist(subPath)==7
    modalityFile=dir(subPath);
    mkdir([subPath filesep 'DCP_DTI_DATA']);
    mkdir([subPath filesep 'DCP_PARCELLATION']);
    for i=3:length(modalityFile)
        if modalityFile(i).isdir==1
            bvalFile=dir([subPath filesep modalityFile(i).name filesep '*.bval']);
            bvecFile=dir([subPath filesep modalityFile(i).name filesep '*.bvec']);
            niftiFile=dir([subPath filesep modalityFile(i).name filesep '*.nii']);
            T1File=dir([subPath filesep modalityFile(i).name filesep 'co*.nii']);
            if length(bvalFile)>0
                for j=1:length(niftiFile),
                    movefile([subPath filesep modalityFile(i).name filesep bvalFile(j).name],...
                        [[subPath filesep 'DCP_DTI_DATA' filesep bvalFile(j).name]]);
                    movefile([subPath filesep modalityFile(i).name filesep bvecFile(j).name],...
                        [[subPath filesep 'DCP_DTI_DATA' filesep bvecFile(j).name]]);
                    movefile([subPath filesep modalityFile(i).name filesep niftiFile(j).name],...
                        [[subPath filesep 'DCP_DTI_DATA' filesep niftiFile(j).name]]);
                end
            else
                for j=1:length(T1File),
                    movefile([subPath filesep modalityFile(i).name filesep T1File(j).name],...
                        [subPath filesep 'DCP_PARCELLATION' filesep 'T1.nii']);
                    delete([subPath filesep modalityFile(i).name filesep '*.nii']);
                end
            end
        end
    end
  end
end
function Metrics_Merge(inpath,outpath)
[~,mat_name,~]=fileparts(outpath);
outpath=[outpath filesep strcat(mat_name,'.mat')];
instruct='[';
for i=1:length(inpath)
    Mat=load(inpath{i});
    matname_cell=fieldnames(Mat);
    for j=1:length(matname_cell)
        %m=matname(j,:);
        mat=Mat.(char(matname_cell{j}));
        mat=mat.';
        eval(strcat('mat_',num2str(i),'_',num2str(j),'=mat;'));
    end
end
save_instruct='save(outpath,';
for j=1:length(matname_cell)
    matname=char(matname_cell{j});
    instruct='[';
    for i=1:length(inpath)
        instruct=[instruct,'mat_',num2str(i),'_',num2str(j),';'];
    end
    instruct(end)=']';
    eval(strcat(matname,'=',instruct,';'));
    save_instruct=[save_instruct,'''',matname,'''',','];
end
save_instruct(end)=')';
eval(strcat(save_instruct,';'));
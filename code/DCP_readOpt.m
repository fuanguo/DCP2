function Opt=DCP_readOpt(handles)
    inputFile=get(handles.inputEdit,'String');
    Opt.inputFile=inputFile;
    sub=get(handles.subEdit, 'String');
    Opt.sub=sub;
    type=get(handles.subType, 'Value');
    Opt.pipeline.type=type;
    maxQueue=get(handles.queueEdit, 'String');
    Opt.pipeline.maxQueue=str2double(maxQueue);
    SGEoption=get(handles.SGEoption, 'String');
    Opt.pipeline.SGEoption=SGEoption;
    convert=get(handles.ConvertCheck, 'Value');
    Opt.preprocessing.convert=convert;
    eddy=get(handles.EddyCheck, 'Value');
    Opt.preprocessing.eddy=eddy;
    tensorCal=get(handles.TenCalCheck, 'Value');
    Opt.preprocessing.tensorCal=tensorCal;
    flag=get(handles.TrackCheck, 'Value');
    Opt.tracktography.flag=flag;
    lowFA=get(handles.lFAEdit, 'String');
    Opt.tracktography.lowFA=str2double(lowFA);
    highFA=get(handles.hFAEdit, 'String');
    Opt.tracktography.highFA=str2double(highFA);
    angle=get(handles.AngleEdit, 'String');
    Opt.tracktography.angle=str2double(angle);
    seed=get(handles.SeedEdit, 'String');
    Opt.tracktography.seed=str2double(seed);
    invert=get(handles.InvertPop, 'Value');
    Opt.tracktography.invert=invert;
    swap=get(handles.SwapPop, 'Value');
    Opt.tracktography.swap=swap;
    flag=get(handles.ParCheck, 'Value');
    Opt.parcellation.flag=flag;
    spm8=get(handles.SPM8,'Value');
    if spm8==1
        Opt.parcellation.spm='spm8';
    else
        Opt.parcellation.spm='spm12';
    end
    template=get(handles.Temedit, 'String');
    Opt.parcellation.template=template;
    T1=get(handles.bT1Edit, 'String');
    Opt.parcellation.T1=str2double(T1);
    B0=get(handles.bB0Edit, 'String');
    Opt.parcellation.B0=str2double(B0);
    aal=get(handles.AALCheck, 'Value');
    Opt.parcellation.aal=aal;
    random=get(handles.RandomCheck, 'Value');
    Opt.parcellation.random=random;
    otherAtlas=get(handles.Atlasedit, 'String');
    Opt.parcellation.otherAtlas=otherAtlas;
    nativeCheck=get(handles.NativeCheck, 'Value');
    Opt.parcellation.nativeCheck=nativeCheck;
    nativeEdit=get(handles.nativeEdit, 'String');
    Opt.parcellation.nativeEdit=nativeEdit;
    flag=get(handles.MatrixCheck, 'Value');
    Opt.matrix.flag=flag;
    fn=get(handles.FNCheck, 'Value');
    Opt.matrix.fn=fn;
    fa=get(handles.FACheck, 'Value');
    Opt.matrix.fa=fa;
    md=get(handles.MDCheck, 'Value');
    Opt.matrix.md=md;
    length=get(handles.LenCheck, 'Value');
    Opt.matrix.length=length;
    flag=get(handles.MergeCheck, 'Value');
    Opt.merge.flag=flag;
    outputFile=get(handles.outputEdit, 'String');
    Opt.merge.outputFile=outputFile;
end
function DCP_load(handles, opt)
    set(handles.inputEdit, 'String', opt.inputFile);
    set(handles.subEdit, 'String', opt.sub);
    opt.pipeline.type=opt.pipeline.type;
    set(handles.subType, 'Value', opt.pipeline.type);
    if (opt.pipeline.type==3)
        set(handles.SGEoption, 'Visible', 'On');
    else
        set(handles.SGEoption, 'Visible', 'Off');
    end
    set(handles.queueEdit, 'String', num2str(opt.pipeline.maxQueue));
    set(handles.SGEoption, 'String', opt.pipeline.SGEoption);
    set(handles.ConvertCheck, 'Value', opt.preprocessing.convert);
    set(handles.EddyCheck, 'Value', opt.preprocessing.eddy);
    set(handles.TenCalCheck, 'Value', opt.preprocessing.tensorCal);
    set(handles.TrackCheck, 'Value', opt.tracktography.flag);
    set(handles.lFAEdit, 'String', num2str(opt.tracktography.lowFA));
    set(handles.hFAEdit, 'String', num2str(opt.tracktography.highFA));
    set(handles.AngleEdit, 'String', num2str(opt.tracktography.angle));
    set(handles.SeedEdit, 'String', num2str(opt.tracktography.seed));
    set(handles.InvertPop, 'Value', opt.tracktography.invert);
    set(handles.SwapPop, 'Value', opt.tracktography.swap);
    if strcmp(opt.parcellation.spm,'spm8')
        set(handles.SPM8,'Value',1);
        set(handles.SPM12,'Value',0);
    else
        set(handles.SPM8,'Value',0);
        set(handles.SPM12,'Value',1);
    end
    set(handles.Temedit, 'String', opt.parcellation.template);
    set(handles.ParCheck, 'Value', opt.parcellation.flag);
    set(handles.bT1Edit, 'String', num2str(opt.parcellation.T1));
    set(handles.bB0Edit, 'String', num2str(opt.parcellation.B0));
    set(handles.AALCheck, 'Value', opt.parcellation.aal);
    set(handles.RandomCheck, 'Value', opt.parcellation.random);
    set(handles.Atlasedit, 'String', opt.parcellation.otherAtlas);
    set(handles.NativeCheck, 'Value', opt.parcellation.nativeCheck);
    if (opt.parcellation.nativeCheck==1)
        set(handles.nativeEdit, 'Visible', 'On');
        set(handles.nativeBnt, 'Visible', 'On');
        set(handles.Temtext, 'Enable', 'Off');
        set(handles.Temedit, 'Enable', 'Off');
        set(handles.TemBtn, 'Enable', 'Off');
        set(handles.bT1text, 'Enable', 'Off');
        set(handles.bT1Edit, 'Enable', 'Off');
        set(handles.bB0text, 'Enable', 'Off');
        set(handles.bB0Edit, 'Enable', 'Off');
        set(handles.AALCheck, 'Enable', 'Off');
        set(handles.RandomCheck, 'Enable', 'Off');
        set(handles.atlastext, 'Enable', 'Off');
        set(handles.Atlasedit, 'Enable', 'Off');
        set(handles.AtlasBtn, 'Enable', 'Off');
    else
        set(handles.nativeEdit, 'Visible', 'Off');
        set(handles.nativeBnt, 'Visible', 'Off');
    end
    set(handles.nativeEdit, 'String', opt.parcellation.nativeEdit);
    set(handles.MatrixCheck, 'Value', opt.matrix.flag);
    set(handles.FNCheck, 'Value', opt.matrix.fn);
    set(handles.FACheck, 'Value', opt.matrix.fa);
    set(handles.MDCheck, 'Value', opt.matrix.md);
    set(handles.LenCheck, 'Value', opt.matrix.length);
    set(handles.MergeCheck, 'Value', opt.merge.flag);
    set(handles.outputEdit, 'String', opt.merge.outputFile);
end
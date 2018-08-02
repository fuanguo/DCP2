function DCP_reorient(path)
V    = spm_vol(path);
centre = DCP_center(V);
M=[1 0 0 0-centre(1);0 1 0 0-centre(2);0 0 1 0-centre(3);0 0 0 1];
Mats = spm_get_space(path);
spm_get_space(path,M*Mats);
end
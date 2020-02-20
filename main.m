function bsc_streamlineCategoryPriors_BL()
%[classificationOut] =bsc_streamlineCategoryPriors_BL(wbfg, fsDir,inflateITer)
%
% This function automatedly segments the wm streamlines of the brain into
% categories based on their terminations.

% Inputs:
% -wbfg: a whole brain fiber group structure
% -fsDir: path to THIS SUBJECT'S freesurfer directory
% -inflateITer: number of inflate iterations to run.  0 or empty = no run
%
% Outputs:
%  classificationOut:  standardly constructed classification structure
%  Same for the other tracts
% (C) Daniel Bullock, 2019, Indiana University

if ~isdeployed
    disp('adding paths');
    addpath(genpath('/N/u/hayashis/git/vistasoft'))
    addpath(genpath('/N/u/brlife/git/jsonlab'))
    addpath(genpath('/N/u/brlife/git/wma_tools'))
    addpath(genpath('/N/u/brlife/git/encode'))
end

config = loadjson('config.json');
wbfg = fgRead(config.track);
atlas=niftiRead('aparc.a2009s+aseg.nii.gz');

if isfield(config,'inflateITer')
    inflateITer=config.inflateITer;
else
    inflateITer=0;
end

[fg_classified] = bsc_streamlineCategoryPriors_v6(wbfg,atlas,inflateITer);
generate_productjson(fg_classified);

%fprintf('\n classification structure stored with %i streamlines identified across %i tracts',...
%sum(classification.index>0),length(classification.names))
%wma_formatForBrainLife_v2(classification,wbfg)

tractspath='classification/tracts';
mkdir(tractspath);
for it = 1:length(fg_classified)
    tract.name   = fg_classified{it}.name;
    tract.color = fg_classified{it}.colorRgb;

    fprintf('saving tract.json for %s\n', tract.name);

    %pick randomly up to 1000 fibers (pick all if there are less than 1000)
    fiber_count = min(1000, numel(fg_classified{it}.fibers));
    tract.coords = fg_classified{it}.fibers(randperm(fiber_count))';
    tract.coords = cellfun(@(x)round(x,3), tract.coords', 'UniformOutput', false);
    savejson('', tract, 'FileName', fullfile(tractspath,sprintf('%i.json',it)), 'FloatFormat', '%.5g');

    all_tracts(it).name = fg_classified{it}.name;
    all_tracts(it).color = fg_classified{it}.colorRgb;
    all_tracts(it).filename = sprintf('%i.json',it);

    clear tract
end
savejson('', all_tracts, fullfile(tractspath, 'tracts.json'));

disp('all done');

end


function main()
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

config = loadjson('config.json')
wbfg = fgRead(config.track);
atlas=niftiRead('aparc.a2009s+aseg.nii.gz');

%no longer matters, remove this
if isfield(config,'inflateITer')
    inflateITer=config.inflateITer;
else
    inflateITer=1;
end

disp('\nstep 1/3 bsc_inflateRelabelIslands ------------------------------------');
fixedAtlas=bsc_inflateRelabelIslands(atlas);
disp('\nstep 2/3 bsc_streamlineCategoryPriors_v7 ------------------------------');
[classification] = bsc_streamlineCategoryPriors_v7(wbfg,fixedAtlas, inflateITer);
disp('\nstep 3/3 bsc_makeFGsFromClassification_v4 -----------------------------');
[classification] = bsc_streamlineCategoryPriors_v7(wbfg,fixedAtlas,inflateITer);

disp('\npostprocessing---------------------------------------------------------');
fg_classified = bsc_makeFGsFromClassification_v4(classification, wbfg);
generate_productjson(fg_classified);

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

save('classification/classification.mat','classification');
savejson('', all_tracts, fullfile(tractspath, 'tracts.json'));

disp('all done');

end


<h1 align="center">Segment tractogram into fiber categories</h1>

<p align="center">
  Anatomical streamline categories (fronto-parietal, occipito-temporal, …) from a whole-brain tractogram and the subject's FreeSurfer Destrieux parcellation; a quick quality check of tractography.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.151"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.151-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> ⚠️ **This branch, `1.3`, is the deprecated brainlife.io App Segment tractogram into fiber categories** ([doi:10.25663/brainlife.app.151](https://doi.org/10.25663/brainlife.app.151)). It is kept so earlier results stay reproducible. Use **Segment tractogram into fiber categories** ([doi:10.25663/brainlife.app.249](https://doi.org/10.25663/brainlife.app.249)) instead. The other Apps in this repository are listed under **Versions on brainlife.io** below.

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Segments all streamlines from an input tractogram in to general categories (i.e. fronto-temporal, parieto-occipital etc).**

| | |
|---|---|
| 📥 **Inputs** | `neuro/track/tck` · `neuro/freesurfer` |
| 📤 **Outputs** | `neuro/wmc-deprecated` · `neuro/wmc` |
| 🐳 **Container** | `brainlife/freesurfer:6.0.0` |
| ⚙️ **Resources** | 8 CPUs · 60 GB memory · 10 h walltime |
| 🔑 **Requires** | `FREESURFER_LICENSE` |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.151](https://doi.org/10.25663/brainlife.app.151) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `track` | `neuro/track/tck` | yes | Whole brain tractography |
| `freesurfer` | `neuro/freesurfer` | yes |  |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `wmc` | `neuro/wmc-deprecated` |  |
| `classification` | `neuro/wmc` |  |

<details>
<summary><b>⚙️ Parameters</b> (1)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `inflateITer` | number | `2` | How many iterations of inflation should be run to inflate grey matter into white matter. 2 recommended. |

</details>

<!-- brainlife-app:end -->

## 🏷️ Versions on brainlife.io

Each version is a separate App on brainlife.io, built from its own branch of this repository.

| Version | FreeSurfer | Branch | Run it | Status |
|---|---|---|---|---|
| Segment tractogram into fiber categories | 6.0.2 | [`2.0`](https://github.com/brainlife/app-streamlineCategorySegmentation/tree/2.0) | [doi:10.25663/brainlife.app.249](https://doi.org/10.25663/brainlife.app.249) | current |
| **Segment tractogram into fiber categories** (this branch) | 6.0.0 | [`1.3`](https://github.com/brainlife/app-streamlineCategorySegmentation/tree/1.3) | [doi:10.25663/brainlife.app.151](https://doi.org/10.25663/brainlife.app.151) | deprecated |

## 🚀 Running the App

This App is highly recommended as an initial quality assurance check on a newly generated tractogram, or as a sanity check on problematic segmentations.

### ☁️ On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.249](https://doi.org/10.25663/brainlife.app.249), choose a whole-brain [tractogram](https://brainlife.io/datatypes/5907d922436ee50ffde9c549) (`neuro/track/tck`) and the [FreeSurfer output](https://brainlife.io/datatypes/58cb22c8e13a50849b25882e) of the same subject, and press **Execute**. A subject-specific FreeSurfer output is required because the App uses its [Destrieux 2009 parcellation](https://doi.org/10.1016/j.neuroimage.2010.06.010) (`aparc.a2009s+aseg`). The App archives a [White Matter Classification (WMC)](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b) dataset tagged `categories` to your project.

### 💻 Locally

The segmentation is compiled MATLAB code that runs in containers. You need [Singularity/Apptainer](https://apptainer.org/), [`jq`](https://jqlang.github.io/jq/) and a [FreeSurfer license](https://surfer.nmr.mgh.harvard.edu/registration.html) (used to convert `aparc.a2009s+aseg.mgz` to NIfTI with FreeSurfer 6.0.2; not needed if `aparc.a2009s+aseg.nii.gz` is already in the working directory).

1. Clone this repository and check out the version you want (for example `git checkout 2.0`).
2. Create `config.json` with the paths to your inputs:

   ```json
   {
       "track": "/input/track/track.tck",
       "freesurfer": "/input/freesurfer/output",
       "inflateITer": 2
   }
   ```

   `inflateITer` is the number of iterations used to inflate grey matter labels into white matter (2 recommended).

3. Export your license and run the App:

   ```bash
   export FREESURFER_LICENSE="$(cat ~/freesurfer/license.txt)"
   ./main
   ```

To run the uncompiled MATLAB code instead, get the [wma_tools](https://github.com/DanNBullock/wma_tools) repository, install [vistasoft](https://github.com/vistalab/vistasoft) and [SPM](https://www.fil.ion.ucl.ac.uk/spm/software/) (tested with SPM8), and call the [`bsc_streamlineCategoryPriors_BL`](https://github.com/DanNBullock/wma_tools/blob/master/bsc_streamlineCategoryPriors_BL.m) wrapper with a `config.json` like the one above, adjusting its `addpath(genpath(...))` statements to your setup.

### 🧪 Sample data

Viable FreeSurfer and tractography datasets can be found on brainlife.io, for example in the [O3D publication](https://brainlife.io/pub/5a0f0fad2c214c9ba8624376) and in the HCP [FreeSurfer](https://brainlife.io/project/5941a225f876b000210c11e5/detail) and [tractography](https://brainlife.io/project/5c3caea0a6747b0036dcbf9a/) projects.

## 📦 Outputs

```text
classification/
├── classification.mat   WMC structure: one category name per endpoint-region pair, one label per streamline
└── tracts/              tracts.json and one <n>.json per category, for visualisation on brainlife.io
```

The default branch also writes `classification/surfaces/` (VTK surfaces of the parcellation with an `index.json`). The categorisation is *complete*: every streamline is assigned to some category (see the [discussion of white matter classification schemas](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b)). No `product.json` is generated.

## How streamlines are categorised

Each streamline gets two labels, one for the region in which each endpoint terminates in the [FreeSurfer 2009 Destrieux atlas](https://surfer.nmr.mgh.harvard.edu/fswiki/DestrieuxAtlasChanges); label order, and so streamline orientation, does not matter. Regions are grouped as follows:

| Brain region designation | FS 2009 aseg region (11/12XXX for 3-digit numbers) |
| --- | --- |
| Subcortical | 10:13, 17:20, 26, 58, 27, 49:56, 59 |
| Spinal | 16, 28, 60 |
| Cerebellum | 8, 47, 7, 46 |
| Ventricles | 31, 63, 4, 43, 14, 24, 15, 44, 5, 62, 30, 80, 72 |
| White matter | 42, 2 |
| Corpus callosum | 251:255 |
| Unknown | 0, 2000, 1000, 77:82, 24, 42, 3 |
| Optic chiasm | 85 |
| Frontal | 124, 148, 118, 165, 101, 154, 105, 115, 154, 155, 115, 170, 129, 146, 153, 164, 106, 116, 108, 131, 171, 112, 150, 104, 169, 114, 113, 116, 107, 163, 139, 132, 140 |
| Temporal | 144, 134, 138, 137, 173, 174, 135, 175, 121, 151, 123, 162, 133 |
| Occipital | 120, 119, 111, 158, 166, 143, 145, 159, 152, 122, 162, 161, 121, 160, 102 |
| Parietal | 157, 127, 168, 136, 126, 125, 156, 128, 141, 172, 147, 109, 103, 130, 110 |
| Insula | 117, 149 |

Some categories carry an extra term when the streamlines meet further criteria:

| Sub-category | Criteria |
| --- | --- |
| Interhemispheric | Endpoints occur in separate hemispheres |
| U-fiber | Streamlines that are superficial (not deep in the white matter) and shorter than 30 mm |

Some memberships override others: a streamline ending in a ventricle is not biologically plausible and is labelled "ventricle" whatever its other endpoint; the same holds for "unknown", "corpus callosum" and "white matter".

### Recommended uses

1. **Tractography quality check.** The fibre counts per category (under the WMC dataset's *Details → Task Results → Number of fibers*) say a lot about the source tractogram. Tractography without anatomical constraints (for example MRtrix 2.0) produces many more invalid streamlines ("ventricle", "unknown", "corpus callosum", "white matter") than anatomically constrained tracking (MRtrix 3.0), so, for the same streamline count, constrained tractograms tend to yield larger and more reliable tracts.
2. **Tract candidate assessment.** A tract cannot be segmented if the tractogram does not contain its streamlines (this happens occasionally with the IFOF, for example, through poor tracking parameters or problems with the DWI). If a segmentation fails to find a plausible tract, run this App and inspect the matching category in the tractography viewer: if nothing resembling the tract is there, the tractogram is to blame; if it is, the problem lies with the segmentation.

Established tracts and their category (not exhaustive; suggestions are welcome via the repository's issues):

| Tract | Category |
| --- | --- |
| Arcuate | Fronto-temporal |
| VOF (vertical occipital fasciculus) | Occipital-occipital (and U-fiber) |
| TP-SPL (temporo-parietal connection) | Temporal-parietal |
| MdLF (middle longitudinal fasciculus) | Temporo-parietal |
| Aslant | Frontal-frontal |
| CST (corticospinal tract) | Spinal-frontal |
| SLF (superior longitudinal fasciculus) | Frontal-parietal |
| ILF (inferior longitudinal fasciculus) | Occipital-temporal |
| IFOF (inferior fronto-occipital fasciculus) | Frontal-occipital |
| pArc (posterior arcuate) | Temporal-parietal |
| Uncinate | Frontal-temporal |

## 🩺 Troubleshooting

- **`Please set FREESURFER_LICENSE in .bashrc`**: no FreeSurfer license in the environment. Export `FREESURFER_LICENSE` (brainlife.io provides it automatically).
- **`output missing`**: the segmentation did not write `classification/classification.mat`. Check the logs and make sure the tractogram and FreeSurfer output belong to the same subject and are in the same space.

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Destrieux C, Fischl B, Dale A, Halgren E. Automatic parcellation of human cortical gyri and sulci using standard anatomical nomenclature. *NeuroImage* 53(1):1–15 (2010). [doi:10.1016/j.neuroimage.2010.06.010](https://doi.org/10.1016/j.neuroimage.2010.06.010)
- Segment tractogram into fiber categories. brainlife.io App. [doi:10.25663/brainlife.app.151](https://doi.org/10.25663/brainlife.app.151)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Bullock et al. Associative white matter connecting the dorsal and ventral posterior human cortex. *Brain Structure and Function* 224:2631-2660 (2019). [doi:10.1007/s00429-019-01907-8](https://doi.org/10.1007/s00429-019-01907-8)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)

## 👥 Authors

- [Daniel Bullock](https://github.com/DanNBullock)
- [Franco Pestilli](https://github.com/francopestilli) (project director)

**Contributors:** [Soichi Hayashi](https://github.com/soichih)

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

[MIT](LICENSE). FreeSurfer is distributed under its own [license](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense).

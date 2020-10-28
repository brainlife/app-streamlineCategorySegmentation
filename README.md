[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.151-blue.svg)](https://doi.org/10.25663/brainlife.app.151)

![alt text](wmaSeg.png)

# app-streamlineCategorySegmentation
Automatically segment a tractogram into categories (i.e. fronto-parietal tracts, parieto-temporal tracts, etc).
THIS APPLICATION IS HIGHLY RECOMMENDED AS A MEANS OF RUNNING AN INITIAL QUALITY ASSURANCE CHECK ON YOUR GENERATED TRACTOGRAPHY OR AS A SANITY CHECK ON PROBLEMATIC SEGMENTATIONS.

### Authors
- Daniel Bullock (dnbulloc@iu.edu)

### Contributors
- Soichi Hayashi (hayashis@iu.edu)

### Project Director
- Franco Pestilli (franpest@indiana.edu)

### Funding 
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NIMH-T32-5T32MH103213-05](https://img.shields.io/badge/NIMH_T32-5T32MH103213--05-blue.svg)](https://projectreporter.nih.gov/project_info_description.cfm?aid=9725739)

### References 
TBA

## Running the App 

### On Brainlife.io

Visit https://doi.org/10.25663/brainlife.app.151 to run this app on the brainlife.io platform.  Requires a freesurfer input (as it makes use of the 2009 parcellation) and an input tractography.

### Running Locally (on your machine) using singularity & docker

Because this is compiled code which runs on singularity, you can download the repo and run it locally with minimal setup.  Ensure that you have singularity and freesurfer set up locally (freesurfer setup not necessary if relevant parcellation files have already been converted to nii.gz).

### Running Locally (on your machine)

Pull the wma toolkit repo:  https://github.com/DanNBullock/wma_tools

Ensure that vistasoft (https://github.com/vistalab/vistasoft) and spm (https://www.fil.ion.ucl.ac.uk/spm/software/ ; tested with spm8) are installed.

Run: https://github.com/DanNBullock/wma_tools/blob/master/bsc_streamlineCategoryPriors_BL.m, but take care to ensure that the addpath-genpath statements are relevant to your local setup.

Utilize a config.json setup that is analagous to the one contained within this repo, listed as a sample.

### Sample Datasets

Visit brainlife.io and explore the following data sets to find viable freesurfer and tractography inputs:

03D: https://brainlife.io/pub/5a0f0fad2c214c9ba8624376

HCP freesurfer:  https://brainlife.io/project/5941a225f876b000210c11e5/detail
HCP tractography:  https://brainlife.io/project/5c3caea0a6747b0036dcbf9a/


## Output

The relevant output for this application is a classification structure.  The classification structure is a .mat file which contains a matlab structure (entitled classification) with two fields:  names and index.  The names field lists the names of tracts which were identified by this process as strings.  The index field is a 1 dimensional vector containing zeros for all unidentified streamlines, and integer index values corresponding to streamlines' membership in the corresponding structure of the names vector.

#### Product.json

Not relevant for this App as it does not generate processed data. 

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) and (in some cases), Freesurfer, and mrtrix3 to run . If you don't have singularity, you will need to install following dependencies.  

https://singularity.lbl.gov/docs-installation
https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall
http://www.mrtrix.org/

## General Use Guide

### **Guide to preliminary category determinants:**

Initial categorization occurs in virtue of each streamline&#39;s endpoints.  That is, each streamline is assigned two category labels, one for each endpoint.  Category label ordering ultimately does not matter, and thus neither does streamline orientation (i.e. first to last node vs last to first node).  This label is applied based on the volume in which the endpoint terminates.  The code checks which label from the [Freesurfer 2009 Destrieux atlas](https://surfer.nmr.mgh.harvard.edu/fswiki/DestrieuxAtlasChanges)), and category membership is ultimately determined from the tables depicted below.



| **Brain Region Designation** | **FS 2009 ASEG Region** **(11/12XXX) for 3 digit numbers** |
| --- | --- |
| Subcortical | 10:13, 17:20, 26, 58, 27, 49:56, 59, |
| Spinal | 16, 28, 60 |
| Cerebellum | 8, 47, 7, 46, |
| Ventricles | 31, 63, 4 43, 14, 24, 15, 44, 5, 62, 30, 80, 72 |
| White matter | 42, 2 |
| Corpus Callosum | 251:255 |
| Unknown | 0, 2000, 1000, 77:82, 24, 42, 3 |
| Optic Chiasm | 85 |
| Frontal | 124, 148, 118, 165, 101, 154, 105, 115, 154, 155, 115, 170, 129, 146, 153, 164, 106, 116, 108, 131, 171, 112, 150, 104, 169, 114, 113, 116, 107, 163, 139, 132, 140 |
| Temporal | 144, 134, 138, 137, 173, 174, 135, 175, 121, 151, 123, 162, 133, |
| Occipital | 120, 119, 111, 158, 166, 143, 145, 159, 152, 122, 162, 161, 121, 160, 102 |
| Parietal | 157, 127, 168, 136, 126, 125, 156, 128, 141, 172, 147, 109, 103, 130, 110 |
| Insula | 117, 149 |

### **Additional sub-categorical determinants:**

In some cases secondary terms are affixed to a category, indicating that the streamlines associated with this subcategory meet some additional criteria which merits further note.  Listed below are these sub-categories and their membership requirements

| **Sub-category** | **Criteria** |
| --- | --- |
| Interhemispheric | Endpoints occur in separate hemispheres of brain |
| U fiber | Streamlines that are both superficial (i.e. not deep in the white matter) and less than 30 mm in length. |

### **Additional Notes:**

Finally, it&#39;s worth noting that some category membership is more important than others.  For example, a streamline which has a termination in a ventricle is not biologically plausible, and thus warrants a separate designation (and thus the label &quot;ventricle&quot; overrides).  The same is true of streamlines ending in &quot;unknown&quot;, &quot;corpus callosum&quot;, and &quot;white matter&quot;.

### **Recommended applications (uses):**

1. **1.****  Tractography quality check:** even the cursory counts provided by the plot found under the [White Matter Classification (WMC) : categories] object's [Details -> Task Results -> Number of fibers] can provide insights about source tractograms.  For example, tractography run with Mrtrix 2.0 is not subject to anatomical constraints, and thus tends to have a much greater number of invalid streamlines (&quot;ventricle&quot;, &quot;unknown&quot;, &quot;corpus callosum, &quot;whitematter&quot;).  Mrtrix 3.0, on the other hand, does subject its tracking to anatomical constraints, and so there are fewer of these invalid streamlines.  As a consequence of this, for tractograms of the same streamline count, segmentation on Mrtrix 3.0 generated tractograms tends to return larger (and/or more reliable) tracts than tractograms run by Mrtrix 2.0.  As such, running a category segmentation can provide you with a quick assessment of this data quality feature.

1. **2.**** Tract candidate assessment:**  Even in the event that your whole brain tractography has been subjected to anatomical constraints, one is not guaranteed to obtain a robust segmentation of tracts (full coverage of tracts, all tracts well represented).  In some cases, the source tractography may simply not generate the necessary streamlines to model the relevant tract (this happens occasionally with the IFOF, for example).  This may be due to a bad parameterization for tractography generation or due to issues with the input dwi itself.  Regardless of the cause, the simple mantra of &quot;Garbage in, garbage out&quot; holds true: _you cannot segment a tract from a whole brain tractography model of the requisite streamlines aren&#39;t there._  

As an example, say that for several of your subjects, your segmentation algorithm of choice fails to find a robust or anatomically plausible IFOF.  In such a case, in order to diagnose the potential cause of this, one is advised to run this app and determine if your source tractography model has any streamlines that might possibly be attributed to the IFOF.  Using the tractography visualizer, one would look at the fronto-occipital category and note whether or not there appears to be a vaguely &quot;IFOF-ish&quot; looking tract running along the ventral areas of the brain.  If you fail to find such an entity, this suggests that your input tractography is to blame (for whatever reason).  If you do find something that approximates the IFOF, this suggests that something has gone awry with the segmentation, the appropriate remedy for which depends on the segmentation algorithm used.

The table below provides an overview of several established tracts and their associated category.  Not intended to serve as an exhaustive account of such tracts.  Interested parties are encouraged to message Dan Bullock with recommended additions or inquiries about unlisted tracts.

| **Tract Name** | **Corresponding Category** |
| --- | --- |
| Arcuate | Fronto-temporal |
| VOF (vertical occipital fasciculus) | Occipital-occipital (&amp; U-fiber) |
| TP-SPL (temporo parietal connection) | Temporal-parietal |
| MdLF (middle longitudinal fasciculus)   | Temporo-parietal |
| Aslant | Frontal-frontal |
| CST (cortico spinal tract) | Spinal-frontal |
| SLF (superior longitudinal fasciculus) | Frontal-parietal |
| ILF (inferior longitudinal fasciculus) | Occipital-temporal |
| IFOF (inferior fronto-occipital fasciculus) | Frontal-occipital |
| pArc (posterior arcuate) | Temporal-parietal |
| Uncinate | Frontal-temporal | 

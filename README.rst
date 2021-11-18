IgemRNA
---------
*IgemRNA* is transcriptome analysis `MATLAB <https://se.mathworks.com/products/matlab.html?s_tid=hp_products_matlab>`_ software with a graphical user interface (GUI) designed   for the analysis of transcriptome data directly or the analysis of context-specific models generated from the provided model reconstruction, transciptome and optional medium     composition data files. *IgemRNA* facilitates some of the `Cobra Toolbox 3.0 <https://github.com/opencobra/cobratoolbox/>`_ constraint-based modelling functionalities for          context-specific model generation and performing optimisation methods like `FBA <https://opencobra.github.io/cobratoolbox/latest/modules/analysis/FBA/index.html>`_ 
or `FVA <https://opencobra.github.io/cobratoolbox/stable/modules/analysis/FVA/index.html>`_ on them.
Furthermore, *IgemRNA* can be used to validate transcriptomics data taking into account the interconnectivity 
of biochemical networks, steady state assumptions and Gene-Protein-Reaction (GPR) relationship. The result context-specific models can then be further analysed and compared to other phenotypes. The main advantage of *IgemRNA* software is that no previos programming skills are required due to the integrated user-friendly GUI which allows to select data files and data processing options in the *IgemRNA* form (see fig. 1). 

.. image:: https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/img/IgemRNAForm.png
  :width: 550
**fig. 1** - Full IgemRNA form

Folder structure description
**********
The *IgemRNA* tool initially consists of 2 root folders (`Data <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/tree/main/Data>`_, `Scripts <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/tree/main/Scripts>`_), additional result folders are created when specific analysis tasks have been performed (*Results non-optimization, Results post-optimization*)   
and an `IgemRNA.m <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/IgemRNA.m>`_ file which calls the user graphical interface form. 
*Data* folder stores all input data files used for this tutorial and *Scripts* folder consists of all the script files that are being executed by the *IgemRNA* software according user-selected options in the *IgemRNA* form as well as the test cases provided in this demonstration.
The *Results non-optimization* (results of direct transcriptome analysis) and *Results post-optimization* (results of context-specific model analysis) are folders where all the result files are saved. 


Running IgemRNA software
**********
In order to run *IgemRNA* the user must first have the `MATLAB <https://se.mathworks.com/products/matlab.html?s_tid=hp_products_matlab>`_ environment installed and started as well as have the `IgemRNA <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA>`_ software downloaded and the files extracted. Then the user can navigate to the root folder of *IgemRNA* in *MATLAB* where the `IgemRNA.m <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/IgemRNA.m>`_ file is located and run it. 


Input data files
**********
To access all options in the *IgemRNA* form, the user must supply input data files. This can be done by pressing the *Open* button in the corresponding file upload row and selecting the files via *File Explorer*. **Transcriptomics data file** (see fig. 2B) is required to run *non-optimization tasks* but an additional **model reconstruction file** is required to access the *post-optimization tasks*. **Medium composition data file** (see fig. 2A) is optional, the selection of this data file does not extend the form, but specifies the provided exchange reaction constraints (upper and lower bounds) in the model for *post-optimization tasks* analysis.

Transcriptomics data and medium composition data can be provided in *.xls* or *.xlsx* formats, where columns are named respectively (see fig. 2) and sheet names correspond to dataset and phenotype names (*dataSetName_phenotypeName*). The model reconstruction file can be provided in *.xls*, *.xml* or other formats supported by *Cobra Toolbox 3.0.* 

.. image:: https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/img/inputDataFormat.png
  :width: 500
**fig. 2** - Input data file structure; A - Medium data file structure; B - Transcriptomics data file structure

Data files used for this tutorial can be found in the `Data <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/tree/main/Data>`_ folder:

* `MediumData.xlsx <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/MediumData.xlsx>`_ (medium composition data)
* `Yeast_8_4_0.xls <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/Yeast_8_4_0.xls>`_ (the yeast consensus genome-scale model reconstruction)  
* `TranscriptomicsData.xlsx <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/TranscriptomicsData.xlsx>`_ (RNA-seq measurements), source `here <https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE130549>`_.

Non-optimization tasks 
**********

Non-optimization tasks include several transcriptomics data analysis tasks: 

* filter highly and lowly expressed genes, 
* filter lowly expressed genes, 
* filter up/down regulated genes between different phenotypes or data sets. 

The results of each task are stored in a different folder within the *Results non-optimization* folder: *Gene expression level comparison*, *Highly-lowly expressed genes*, *Lowly expressed genes* (see fig. 3).

.. image:: https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/img/nonOptTasksFolderStructure.png
  :width: 400
**fig. 3** - *Non-optimization results* folder

**********
1. Filter highly and lowly expressed genes
**********
Non-optimization task *Filter highly and lowly expressed genes* generates result *Excel* files for each provided transcriptomics dataset. File names are assigned based on the provided dataset and phenotype names (from transcriptomics data), the applied thresholding approach (*GT1, LT1, LT2* **TODO: add additional information about thresholds**) and provided global thresholds values (see fig. 4). Each result *Excel* file contains one sheet with the list of genes provided by transcriptomics data and 4 columns: *GeneId*, *Data* (the expression value), *ExpressionLevel* and *ThApplied*. The *ExpressionLevel* column contains the expression levels determined based on the selected thresholding approach, provided global and for thresholding approaches *LT1* and *LT2* calculated local thresholds. Column *ThApplied* displays whether a local or a global threshold for a specific gene was applied (see fig. 5). 

.. |pic1| image:: https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/img/filterHighlyLowlyExpressedGenesFolder.PNG
   :width: 440

.. |pic2| image::  https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/img/filterHighlyLowlyExpressedGenesFile.PNG
   :width: 250

|pic1|    |pic2|

**fig. 4** - *Filter highly and lowly expressed genes* folder;    **fig. 5** - Filter highly and lowly expressed genes result file


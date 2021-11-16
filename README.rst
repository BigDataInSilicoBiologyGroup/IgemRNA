**********
IgemRNA
**********
IgemRNA is a library with a graphical user interface written for the MATLAB environment that facilitates some of the `Cobra Toolbox 3.0 <https://github.com/opencobra/cobratoolbox/>`_ 
functionality. 
IgemRNA supports the analysis of transcriptome data directly or to apply GSM biochemical network topology properties and perform optimisation methods like `FBA <https://opencobra.github.io/cobratoolbox/latest/modules/analysis/FBA/index.html>`_ 
or `FVA <https://opencobra.github.io/cobratoolbox/stable/modules/analysis/FVA/index.html>`_ and analyse their results. 
Furthermore, IgemRNA can be used to validate transcriptomics data facilitating interconnectivity 
of biochemical networks, steady state assumptions, Gene - Protein - Reaction (GPR) relationship and can use optional medium composition data to create context-specific 
models which can then be further analysed and compared to other phenotypes.

**********
Folder structure description
**********
The IgemRNA tool initially consists of 2 root folders (Data, Scripts), additional result folders are added after specific tasks have been performed (Results non-optimization, Results post-optimization)   
and an IgemRNA.m file which calls the user graphical interface form. 
Data files used for this tutorial can be found in the Data folder:

* `MediumData.xlsx <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/MediumData.xlsx>`_ (medium composition data)
* `Yeast_8_4_0.xls <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/Yeast_8_4_0.xls>`_ (the yeast consensus genome-scale model)  
* `TranscriptomicsData.xlsx <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/TranscriptomicsData.xlsx>`_ (RNA-req measurements), source `here <https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE130549>`_.

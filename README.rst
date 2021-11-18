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

.. image:: https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/img/IgemRNAForm.png
  :width: 500

**********
Folder structure description
**********
The IgemRNA tool initially consists of 2 root folders (Data, Scripts), additional result folders are added after specific tasks have been performed (Results non-optimization, Results post-optimization)   
and an IgemRNA.m file which calls the user graphical interface form. 
Data files used for this tutorial can be found in the Data folder:

* `MediumData.xlsx <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/MediumData.xlsx>`_ (medium composition data)
* `Yeast_8_4_0.xls <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/Yeast_8_4_0.xls>`_ (the yeast consensus genome-scale model)  
* `TranscriptomicsData.xlsx <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/TranscriptomicsData.xlsx>`_ (RNA-req measurements), source `here <https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE130549>`_.

**********
File upload
**********
To access all options in the IgemRNA form, the user must supply input data files Fig. 3 A section. This can be done by pressing the ‘Open’ button in the corresponding file row and finding the necessary files via File Explorer. Transcriptomics data is required to run non-optimization tasks (Fig. 3 F) but an additional model file is necessary to access the post-optimization tasks (Fig. 3 G). Medium composition file is optional if such data is available, the selection of this data file does not extend the form, but specifies the given exchange reaction constraints (upper bounds and lower bounds) on the model for post-optimization tasks analysis. For an organized overview of the analysis and results it is recommended that the necessary data files are located in the Data folder of IgenRNA tool (for more details see main publication section Materials and Methods 2.2 Tools functionality description). 


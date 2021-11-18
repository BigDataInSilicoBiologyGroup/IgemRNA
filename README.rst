

IgemRNA
**********
*IgemRNA* is transcriptome analysis `MATLAB <https://se.mathworks.com/products/matlab.html?s_tid=hp_products_matlab>`_ software with a graphical user interface (GUI) designed   for the analysis of transcriptome data directly or the analysis of context-specific models generated from the provided model reconstruction, transciptome and optional medium     composition data files. *IgemRNA* facilitates some of the `Cobra Toolbox 3.0 <https://github.com/opencobra/cobratoolbox/>`_ constraint-based modelling functionalities for          context-specific model generation and performing optimisation methods like `FBA <https://opencobra.github.io/cobratoolbox/latest/modules/analysis/FBA/index.html>`_ 
or `FVA <https://opencobra.github.io/cobratoolbox/stable/modules/analysis/FVA/index.html>`_ on them.
Furthermore, *IgemRNA* can be used to validate transcriptomics data taking into account the interconnectivity 
of biochemical networks, steady state assumptions and Gene-Protein-Reaction (GPR) relationship. The result context-specific models can then be further analysed and compared to other phenotypes. The main advantage of *IgemRNA* software is that no previos programming skills are required due to the integrated user-friendly GUI which allows to select data files and data processing options in the *IgemRNA* form (see fig. 1). 

.. image:: https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/img/IgemRNAForm.png
  :width: 550
  :align: center
fig. 1 - Full IgemRNA form

**********
Folder structure description
**********
The *IgemRNA* tool initially consists of 2 root folders (`Data <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/tree/main/Data>`_, `Scripts <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/tree/main/Scripts>`_), additional result folders are created when specific analysis tasks have been performed (*Results non-optimization, Results post-optimization*)   
and an `IgemRNA.m <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/IgemRNA.m>`_ file which calls the user graphical interface form. 
Data files used for this tutorial can be found in the `Data <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/tree/main/Data>`_ folder:

* `MediumData.xlsx <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/MediumData.xlsx>`_ (medium composition data)
* `Yeast_8_4_0.xls <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/Yeast_8_4_0.xls>`_ (the yeast consensus genome-scale model reconstruction)  
* `TranscriptomicsData.xlsx <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA_v4/blob/main/Data/TranscriptomicsData.xlsx>`_ (RNA-seq measurements), source `here <https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE130549>`_.

*Scripts* folder consists of all the script files that are being executed by the *IgemRNA* software according user selected options in the *IgemRNA* form as well as the test cases provided in this demonstration.
The *Results non-optimization* (results of direct transcriptome analysis) and *Results post-optimization* (results of context-specific model analysis) folders are where all the result files are saved. 

**********
Running IgemRNA software
**********
In order to run *IgemRNA* the user must first have the `MATLAB <https://se.mathworks.com/products/matlab.html?s_tid=hp_products_matlab>`_ environment installed and started as well as have the `IgemRNA <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA>`_ software downloaded and the files extracted. Then the user can navigate to the root folder of *IgemRNA* in *MATLAB* where the `IgemRNA.m <https://github.com/BigDataInSilicoBiologyGroup/IgemRNA/blob/main/IgemRNA.m>`_ file is located and run it. 


**********
File upload
**********
To access all options in the IgemRNA form, the user must supply input data files. This can be done by pressing the ‘Open’ button in the corresponding file row and finding the necessary files via File Explorer. Transcriptomics data is required to run non-optimization tasks (Fig. 3 F) but an additional model file is necessary to access the post-optimization tasks (Fig. 3 G). Medium composition file is optional if such data is available, the selection of this data file does not extend the form, but specifies the given exchange reaction constraints (upper bounds and lower bounds) on the model for post-optimization tasks analysis. For an organized overview of the analysis and results it is recommended that the necessary data files are located in the Data folder of IgenRNA tool (for more details see main publication section Materials and Methods 2.2 Tools functionality description). 


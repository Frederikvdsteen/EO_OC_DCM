# EO_OC_DCM
This code accompagnies the paper entitled:

Dynamic causal modelling shows a prominent role of local inhibition in alpha power modulation in higher visual cortex

Frederik Van de Steen<sup>superscript1,2,3*</sup>, Dimitris Pinotsis4,5, Wouter Devos1, Nigel Colenbier1,6,7, Iege Bassez1, Karl Friston3 and Daniele Marinazzo1

1 Department of Data Analysis, Ghent University, Ghent, Belgium
2 Vrije Universiteit Brussel, Brussel, Belgium, AIMS laboratory. 
3 The Wellcome Trust Centre for Neuroimaging, University College London, London, United Kingdom
4 Centre for Mathematical Neuroscience and Psychology and Department of Psychology, City - University of London, London, EC1V 0HB, United Kingdom
5 The Picower Institute for Learning & Memory and Department of Brain and Cognitive Sciences, Massachusetts Institute of Technology, Cambridge, MA, 02139, USA
6 Research Center for Motor Control and Neuroplasticity, KU Leuven, 3001 Leuven, Belgium
7 IRCCS San Camillo Hospital, Venice, Italy
* Corresponding author: Frederik.van.de.steen@vub.be


The folder [perm_ttest](https://github.com/Frederikvdsteen/EO_OC_DCM/tree/main/perm_ttest) contains the code for the 
permutation based t-testing of spectral analysis of all channels

## Pre-processing,MEEG objects and spectral analysis functions
The function prep_eeglab.m was used for pre-processing the EEG data with EEGLAB (version 13.3.2b)
and the fucntion semi_automated_ica_rejection_and_rereferencing.m was used for re-referencing and manually removing independen components


# EO_OC_DCM
This code accompagnies the paper entitled:

**Dynamic causal modelling shows a prominent role of local inhibition in alpha power modulation in higher visual cortex**

Frederik Van de Steen<sup>1,2,3,8</sup>, Dimitris Pinotsis<sup>4,5</sup> Wouter Devos<sup>1</sup>, Nigel Colenbier<sup>1,6,7</sup>, Iege Bassez<sup>1</sup>, Karl Friston<sup>3</sup> and Daniele Marinazzo<sup>1</sup>

<sup>1</sup> Department of Data Analysis, Ghent University, Ghent, Belgium

<sup>2</sup> Vrije Universiteit Brussel, Brussel, Belgium, AIMS laboratory. 

<sup>3</sup> The Wellcome Trust Centre for Neuroimaging, University College London, London, United Kingdom

<sup>4</sup> Centre for Mathematical Neuroscience and Psychology and Department of Psychology, City - University of London, London, EC1V 0HB, United Kingdom

<sup>5</sup> The Picower Institute for Learning & Memory and Department of Brain and Cognitive Sciences, Massachusetts Institute of Technology, Cambridge, MA, 02139, USA

<sup>6</sup> Research Center for Motor Control and Neuroplasticity, KU Leuven, 3001 Leuven, Belgium

<sup>7</sup> IRCCS San Camillo Hospital, Venice, Italy

<sup>8</sup> Corresponding author: Frederik.van.de.steen@vub.be

 


## Pre-processing,MEEG objects and spectral analysis functions
The function [prep_eeglab.m](https://github.com/Frederikvdsteen/EO_OC_DCM/tree/main/prep_eeglab.m) was used for pre-processing the EEG data with EEGLAB (version 13.3.2b)
and the function [semi_automated_ica_rejection_and_rereferencing.m](https://github.com/Frederikvdsteen/EO_OC_DCM/tree/main/semi_automated_ica_rejection_and_rereferencing.m) was used for re-referencing and manually removing independent components.

The folder [perm_ttest](https://github.com/Frederikvdsteen/EO_OC_DCM/tree/main/perm_ttest) contains the code for the 
permutation based t-testing of spectral analysis of all channels

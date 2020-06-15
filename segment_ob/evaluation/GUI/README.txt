Evaluation framework for automatic singing transcription
=============================================================
Version 1.0
Copyright © 2014, 
ATIC Research Group, Universidad de Malaga
Authors: Emilio Molina (emm@ic.uma.es),
Ana M. Barbancho (ibp@ic.uma.es), 
Lorenzo J. Tardón (lorenzo@ic.uma.es), 
Isabel Barbancho (ibp@ic.uma.es)
Date: 23/09/2014

Folders included
----------------

./CommandLineTool -> Evaluation framework to be used from MATLAB
                     command window. This is the core of the framework, and
                     it does not include any GUI. A demonstration of the usage 
		     of the tool can be found in the file DEMO_evaluation.m. 
		     Please, refer to
                     ./CommandLineTool/README.txt for more information.

./GUI -> Comprehensive GUI with extended functions to visualize results, play 
         sounds, etc. 
	 Please, refer to ./GUI/README.txt for more informa-
         tion, and MANUAL_GUI.pdf for instructions.

./DATASET -> Ground-truth annotations of the dataset, and recordings of     
             children singing popular songs (see [1]). 
	     Please, refer to README.txt to know about the conditions of use. 

./CommandLineTool
=================

This software is free software; you can redistribute it and/or modify it 
under the terms of version 3.0 of GNU General Public License as published 
by the Free Software Foundation.

This program is distributed as is, WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
FITNESS FOR A PARTICULAR PURPOSE.

If you use this software for academic research, please cite
the reference [1].

For commercial use of this toolbox, please contact the authors.


In the folder ./CommandLineTool, three files can be found:
    - classifyNotes.m --> Compute evaluation measures for one single 
                          transcription file (together with its ground-truth).
    - evaluation.m --> Compute evaluation measures for a whole dataset.
    - DEMO_evaluation.m --> DEMO of usage of the two previous functions.

More information can be found in the help of these files, and in [1].

./GUI
=====

This software is free software; you can redistribute it and/or modify it 
under the terms of version 3.0 of GNU General Public License as published 
by the Free Software Foundation.

This program is distributed as is, WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
FITNESS FOR A PARTICULAR PURPOSE.

If you use this software for academic research, please cite
the reference [1].

For commercial use of this toolbox, please contact the authors.

The main GUI can be found in the file GUI_main.m. Please, check MANUAL.pdf
for a brief introduction to the software. 

DATASET
=======
All the .WAV files provided, transcriptions and all the annotations are offered 
free of charge for non-commercial use only. You can not redistribute it nor 
modify them. Distribution rights granted to ATIC Research Group, 
Universidad de Malaga. All rights reserved.

If you use this dataset for academic research, please cite
the reference [1].

The proposed dataset contains annotations for different types of material:

(a) - Children (ATIC Research Group recordings): 14 melodies of traditional
children songs (557 seconds) sung by 8 different
children (5-11 years old). These files are named as childX.wav.

(b) - Adult male: 13 pop melodies (315 seconds) sung by 8 different adult 
male untrained singers. These recordings were chosen from the public
dataset MTG-QBH [2].
(c) - Adult female: 11 pop melodies (281 seconds) sung by 5 different adult 
female untrained singers, also taken from MTG-QBH dataset [2].

The recordings taken from the MTG-QBH dataset can be downloaded from:
http://www.mtg.upf.edu/download/datasets/mtg-qbh

- Naming convention:
In MTG-QBH, the .WAV files are named as q1.wav, q2.wav, etc. 
However, in our dataset we include extra information about the gender of 
the singer in the filename (afemale1.wav, afemale2.wav, etc.). 
Please, check MTGQBH_renaming.m in order to rename the files according to 
our convention. The resulting .WAV files can be then copied to ./DATASET in 
order to get the complete dataset.

References
----------

[1] Molina, E., Barbancho A. M., Tardon, L. J., Barbancho, I., "Evaluation
framework for automatic singing transcription", Proceedings of ISMIR 2014.

[2] J. Salamon, J. Serra and E. Gomez, “Tonal Representations
for Music Retrieval: From Version Identification to Query-by-Humming”, 
International Journal of Multimedia Information Retrieval, special issue on 
Hybrid Music Information Retrieval, vol. 2, no. 1, pp. 45-58, 2013.

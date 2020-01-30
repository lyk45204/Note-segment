# Note-segment

This framework is used to reproduce the note segmentation part of pyin which use HMM to realize note segment. The framework contains several parts below.

First, batch read the .csv files of pitchtrack, rms of amplititude and notetrack which are produced by sonic annotator and the ground truth of notetrack. These files should be stored in a test folder.
Second, the preprocess step modify the form of readed files.
Third, the HMM-based model do note segmentation of the pitchtrack and do postprocess with the help of rms of amplititude. Also, speech part of the pitch track is deleted with the help of ground truth notetrack.
Finally, the framework evaluates the reproduciton result with a toolbox based on metrix and a visulization tool(automatically save the data which is used to visualize). Three comparisons has been done, that is re VS gt, tony VS gt, and re VS Tony. re means reimplement, tony is the software of pyin, gt is ground truth.


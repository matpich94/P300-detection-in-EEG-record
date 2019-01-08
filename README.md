# P300-detection-in-EEG-record
This code is used to detect a specific wave, the P300, in the EEG record of one patient.

## Short overview

The patient receives tactile stimulation corresponding to letters. When a tactile stimulation occurs, it elicits a specific wave in his/her EEG (Electroencephalography) record.

We record the EEG activity of one patient during the stimulations. Then we train a Support Vector Machine in order to detect the presence of the P300 in the EEG record. 

Finally we can predict the word the subject wants to write.

## Libraries

sklearn / numpy

## Functions

bitrate.py : computes the bite rate of the device according to the number of letters predicted per second
plot_conf_mat.py : plot proper confusion matrix
open_files.m : convert the temporal data recorded by the EEG to Power Spectrum using Fourier Transform 

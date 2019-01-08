# -*- coding: utf-8 -*-
"""
Created on Thu Aug 16 15:27:37 2018

@author: Mathieu Pichon
"""

def bitrate(acc, n_classes):
    import math
    B = math.log(n_classes,2) + acc*math.log(acc,2) + (1-acc)*math.log((float(1-acc)/float(n_classes-1)),2)
    return B
import io
import json
import argparse
import os
import random
import math

from PIL import Image
from flask import Flask, jsonify, request

import gym

import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from collections import namedtuple
from itertools import count
from PIL import Image

import torch
import torch.nn as nn
import torchaudio

import torch.optim as optim
import torch.nn.functional as F
import torchvision.transforms as T

import torch.nn.parallel
import torch.backends.cudnn as cudnn
import torch.utils.data

import matplotlib.animation as animation
from IPython.display import HTML


device = torch.device("cuda" if torch.cuda.is_available() else "cpu")


DIR = "/home/sippycups/Music/2018/"
FNS = os.listdir(DIR)

if __name__ == "__main__":
    waveform, sample_rate = torchaudio.load(DIR + FNS[0])
    print("Shape of waveform: {}".format(waveform.size()))
    print("Sample rate of waveform: {}".format(sample_rate))

    plt.figure()
    plt.plot(waveform.t().numpy())
    plt.show()

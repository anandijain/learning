import os
import torch
import torchaudio
import matplotlib.pyplot as plt


DIRECTORY = "/home/sippycups/Music/2019/"
FILE_NAMES = os.listdir(DIRECTORY)


def sgram(wave):
    return torchaudio.transforms.Spectrogram()(wave)


def wavey(filename):
    return torchaudio.load(DIRECTORY + filename)[0]

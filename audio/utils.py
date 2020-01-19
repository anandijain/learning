import os
import torch
import torchaudio

DIRECTORY = "/home/sippycups/Music/2018/"
FILE_NAMES = os.listdir(DIRECTORY)
WINDOW_LEN = 10000

def sgram(wave):
    return torchaudio.transforms.Spectrogram()(wave)


def wavey(filename=FILE_NAMES[0]):
    return torchaudio.load(DIRECTORY + filename)


def data_windows(n: int = 100000):
    m = len(FILE_NAMES)
    d = {}
    for i, fn in enumerate(FILE_NAMES):
        t = wavey(fn)
        window = t[0][i*n:(i+1)*n]
        if n > len(window):
            d[fn] = i
            break
    return d



import os
import torch
import torchaudio
from torch.utils.data import Dataset, DataLoader
import numpy as np
DIRECTORY = "/home/sippycups/Music/2019/"
FILE_NAMES = os.listdir(DIRECTORY)


def sgram(wave):
    return torchaudio.transforms.Spectrogram()(wave)


def wavey(fn=FILE_NAMES[0]):
    return torchaudio.load(DIRECTORY + fn)


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


class Waveys(Dataset):
    def __init__(self, window, fn='5 14 19 matt anand ilan.wav'):
        wave = torchaudio.load(filepath=fn)
        self.w = wave[0]
        self.sample_rate = wave[1]
        # print(self.sample_rate)
        self.length = len(self.w[0]) // window - 1
        self.window = window

    def __len__(self):
        return self.length

    def __getitem__(self, idx):
        l = self.w[0][idx*self.window:(idx + 1)*self.window]
        r = self.w[1][idx*self.window:(idx + 1)*self.window]
        x = torch.cat([l, r])
        # print(x)
        if np.nan in x:
            print('oh no')
        return l.view(1, -1)


class Files(Dataset):
    def __init__(self, dir=DIRECTORY):
        self.fns = [DIRECTORY + f for f in FILE_NAMES]
        self.length = len(self.fns)

    def __len__(self):
        return self.length
        
    def __getitem__(self, idx):
        return self.fns[idx]

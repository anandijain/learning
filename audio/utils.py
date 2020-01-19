import os
import torch
import torchaudio
from torch.utils.data import Dataset, DataLoader

DIRECTORY = "/home/sippycups/Music/2018/"
FILE_NAMES = os.listdir(DIRECTORY)
WINDOW_LEN = 10000


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
    def __init__(self, fn='81 - 2018 - 09 2 18 18.wav', window=WINDOW_LEN):
        wave = wavey(fn=fn)
        self.w = wave[0][0]
        self.sample_rate = wave[1]
        print(self.sample_rate)
        self.length = len(self.w) // window - 1
        self.window = window

    def __len__(self):
        return self.length

    def __getitem__(self, idx):
        # x = self.w[idx*self.window:(idx + 1)*self.window]

        # warning
        x = self.w[10*self.window:11*self.window]
        return x.view(1, -1)


class Files(Dataset):
    def __init__(self, dir=DIRECTORY):
        self.fns = [DIRECTORY + f for f in FILE_NAMES]
        self.length = len(self.fns)

    def __len__(self):
        return self.length
        
    def __getitem__(self, idx):
        return self.fns[idx]

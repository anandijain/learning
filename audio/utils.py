import os
import torch
import numpy as np

import torchaudio

from torch.nn import functional as F
from torch.utils.data import Dataset, DataLoader



class WaveSet(Dataset):
    def __init__(self, fn:str, seconds:int):
        """
        seconds is int that is multiplied by sample rate 
        """
        wave = torchaudio.load(filepath=fn)
        self.w = wave[0]
        self.sample_rate = wave[1]
        window_len = seconds * self.sample_rate
        # print(self.sample_rate)
        self.length = (len(self.w[0]) // window_len) - 2
        self.window_len = window_len

    def __len__(self):
        return self.length

    def __getitem__(self, idx):
        l = self.w[0][idx*self.window_len:(idx + 1)*self.window_len]
        r = self.w[1][idx*self.window_len:(idx + 1)*self.window_len]
        x = torch.cat([l, r])
        # print(x)
        if np.nan in x:
            print('oh no')
        return x.view(1, -1)


# class Files(Dataset):
#     def __init__(self, dir):
#         self.fns = [dir + f for f in FILE_NAMES]
#         self.length = len(self.fns)

#     def __len__(self):
#         return self.length

#     def __getitem__(self, idx):
#         return self.fns[idx]


# def sgram(wave):
#     return torchaudio.transforms.Spectrogram()(wave)


# def wavey(fn=FILE_NAMES[0]):
#     return torchaudio.load(DIRECTORY + fn)


# def data_windows(n: int = 100000):
#     m = len(FILE_NAMES)
#     d = {}
#     for i, fn in enumerate(FILE_NAMES):
#         t = wavey(fn)
#         window = t[0][i*n:(i+1)*n]
#         if n > len(window):
#             d[fn] = i
#             break
#     return d

def full_fn_to_name(fn):
    return fn.split('/')[-1].split('.')[0].replace(' ', '_')


def loss_function(recon_x, x, mu, logvar):
    BCE = F.binary_cross_entropy(recon_x, x, reduction='sum')
    KLD = -0.5 * torch.sum(1 + logvar - mu.pow(2) - logvar.exp())
    return BCE + KLD

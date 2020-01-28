"""

"""
import os
import time

import torch
import torchaudio

from torch import nn, optim
from torch.nn import functional as F

from torch.utils.data import DataLoader
from torch.utils.tensorboard import SummaryWriter

import utils
import vae


writer = SummaryWriter()

# device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
device = torch.device("cpu")
print(device)

LOG_INTERVAL = 500
BATCH_SIZE = 16
BOTTLENECK = 100


def train_epoch(d, epoch: int, save=False):

    model = d['m']
    optimizer = d['o']
    dataset = d['data']
    train_loader = d['loader']
    sample_rate = d['sr']
    path = d['path']
    
    loss_fn = nn.MSELoss()
    model.train()
    train_loss = 0
    for batch_idx, data in enumerate(train_loader):
        data = data.to(device)
        optimizer.zero_grad()
        recon_batch, mu, logvar = model(data)
        # recon_batch = model(data)
        # print(recon_batch)

        # loss = loss_fn(recon_batch, data)
        loss = utils.loss_function(recon_batch, data, mu, logvar)
        loss.backward()

        writer.add_scalar('train_loss', loss)
        train_loss += loss.item()
        optimizer.step()

        if batch_idx % LOG_INTERVAL == 0:
            print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
                epoch, batch_idx * len(data), len(train_loader.dataset),
                100. * batch_idx / len(train_loader),
                loss.item() / len(data)))

    print('====> Epoch: {} Average loss: {:.4f}'.format(
          epoch, train_loss / len(train_loader.dataset)))

    with torch.no_grad():
        sample = torch.randn(1, BOTTLENECK).to(device)
        sample = model.decode(sample).cpu()

    return sample.view(2, -1)  # to stereo


def prep(fn: str):

    song_folder = fn.split('.')[0]
    path = 'samples/' + song_folder + '/'

    try:
        os.makedirs(path)
    except FileExistsError:
        print(f'warning: going to overwrite {path}')

    seconds = 2
    dataset = utils.WaveSet(fn, seconds)

    window_len = dataset.window_len
    sample_rate = dataset.sample_rate

    train_loader = DataLoader(dataset, batch_size=BATCH_SIZE)

    model = vae.VAE(dim=window_len*2, bottleneck=BOTTLENECK).to(device)
    print(model)
    optimizer = optim.Adam(model.parameters())

    d = {
        'm': model,
        'o': optimizer,
        'data': dataset,
        'loader': train_loader,
        'sr': sample_rate,
        'path': path,
    }
    return d


def train(fn='test.wav', epochs=10, save=True):
    d = prep(fn)

    y_hats = [train_epoch(d, epoch)
              for epoch in range(1, epochs + 1)]  # [epochs, 2, n]

    song = torch.cat(y_hats, dim=1)
    print(song)

    if save:
        torchaudio.save(d['path'] + f'gen_{fn}' + '.wav', song, d['sr'])


if __name__ == "__main__":

    train()

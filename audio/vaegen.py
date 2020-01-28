"""

"""
import glob
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


# larger window sizes wont usually work on my GPU because of the RAM
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
# device = torch.device("cpu")
print(device)

#CUTOFF_FREQ = 12000
LOG_INTERVAL = 100

BATCH_SIZE = 64
WINDOW_SECONDS = 1  # n
MIDDLE = 600  # 11025 # 22050 # 44100
BOTTLENECK = 500
EPOCHS = 100
START_SAVING_AT = 0

# works on gpu
CONFIG_1 = {
    'WINDOW_SECONDS': 2,  # n
    'MIDDLE': 300,
    'BOTTLENECK': 200,
}

MODEL_FN = f'n_{WINDOW_SECONDS}_mid_{MIDDLE}_bot_{BOTTLENECK}.pth'
FILE_NAME = '/home/sippycups/Music/misc/81 - misc - 18 9 13 17.wav'


def train_epoch(d, epoch: int, save=False):

    model = d['m']
    optimizer = d['o']
    dataset = d['data']
    train_loader = d['loader']
    sample_rate = d['sr']
    path = d['path']

    model.train()
    train_loss = 0
    for batch_idx, data in enumerate(train_loader):
        data = data.to(device)
        optimizer.zero_grad()

        recon_batch, mu, logvar = model(data)

        loss = utils.loss_function(recon_batch, data, mu, logvar)
        loss.backward()
        idx = len(dataset) * epoch + batch_idx

        d['writer'].add_scalar('train_loss', loss.item(), global_step=idx)

        train_loss += loss.item()
        optimizer.step()

        # if batch_idx % LOG_INTERVAL == 0:
        #     print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
        #         epoch, batch_idx * len(data), len(train_loader.dataset),
        #         100. * batch_idx / len(train_loader),
        #         loss.item() / len(data)))

    # print('====> Epoch: {} Average loss: {:.4f}'.format(
    #       epoch, train_loss / len(train_loader.dataset)))

    with torch.no_grad():
        sample = torch.randn(1, BOTTLENECK).to(device)
        sample = model.decode(sample).cpu()

    return sample.view(2, -1)  # to stereo


def prep(fn: str):
    short_fn = utils.full_fn_to_name(fn)

    path = 'samples/' + short_fn + '/'

    try:
        os.makedirs(path)
    except FileExistsError:
        print(f'warning: going to overwrite {path}')

    dataset = utils.WaveSet(fn, WINDOW_SECONDS)
    print(f'len(dataset): {len(dataset)} (num of windows)')
    window_len = dataset.window_len
    sample_rate = dataset.sample_rate

    train_loader = DataLoader(dataset, batch_size=BATCH_SIZE, shuffle=True)

    model = vae.VAE(dim=window_len*2, bottleneck=BOTTLENECK,
                    middle=MIDDLE).to(device)
    try:
        model.load_state_dict(torch.load(MODEL_FN))
        print(f'loaded: {MODEL_FN}')
    except FileNotFoundError:
        pass
    print(model)
    optimizer = optim.Adam(model.parameters())
    writer = SummaryWriter(
        f"runs/{short_fn}_n_{WINDOW_SECONDS}_{time.asctime()}")

    d = {
        'm': model,
        'o': optimizer,
        'data': dataset,
        'loader': train_loader,
        'sr': sample_rate,
        'path': path,
        'writer': writer
    }
    return d


def train(fn=FILE_NAME, epochs=EPOCHS, start_saving_at=START_SAVING_AT, save=True, save_model=True, lopass=False):
    d = prep(fn)
    short_fn = utils.full_fn_to_name(fn)
    y_hats = []
    for epoch in range(1, epochs + 1):  # [epochs, 2, n]
        print(f'epoch: {epoch} {short_fn}')
        if epoch < start_saving_at:
            train_epoch(d, epoch)
        else:
            y_hat = train_epoch(d, epoch)
            # takes too long
            # if lopass:
            #     y_hat = torchaudio.functional.lowpass_biquad(
            #         y_hat.view(1, 2, -1), d['sr'], CUTOFF_FREQ)
            #       print(f'lopassed: {y_hat}')
            y_hats.append(y_hat.view(2, -1))

    song = torch.cat(y_hats, dim=1)
    print(song)

    if save:
        save_wavfn = f'gen_{short_fn}_n_{WINDOW_SECONDS}_mid_{MIDDLE}_bot_{BOTTLENECK}.wav'

        torchaudio.save(d['path'] + save_wavfn, song, d['sr'])
    if save_model:
        torch.save(d["m"].state_dict(), MODEL_FN)
    return song


def gen_folder(folder="/home/sippycups/Music/2019/"):
    # broken
    fns = glob.glob(f'{folder}/**.wav')
    for i, wavfn in enumerate(fns):
        print(f'{i}: {wavfn}')
        try:
            train(wavfn)
        except RuntimeError:
            continue
       # if i == 5:
        #    break


if __name__ == "__main__":
    train()
    # gen_folder()

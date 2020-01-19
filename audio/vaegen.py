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
SAMPLE_RATE = 44100
WINDOW_LEN = SAMPLE_RATE * 4
LOG_INTERVAL = 5
BATCH_SIZE = 128
BOTTLENECK = 100


def loss_function(recon_x, x, mu, logvar):
    # BCE = F.binary_cross_entropy(
    #     recon_x, x.view(-1, WINDOW_LEN), reduction='sum')
    BCE = F.binary_cross_entropy(
        recon_x, x, reduction='sum')
    KLD = -0.5 * torch.sum(1 + logvar - mu.pow(2) - logvar.exp())
    return BCE + KLD


def train_epoch(modtrain_loader: DataLoader, fn: str, sample_rate: int, epoch: int, save=False):
    model.train()
    train_loss = 0
    for batch_idx, data in enumerate(train_loader):
        data = data.to(device)
        optimizer.zero_grad()
        recon_batch, mu, logvar = model(data)
        loss = loss_function(recon_batch, data, mu, logvar)
        loss.backward()

        writer.add_scalar('train_loss', loss)
        train_loss += loss.item()
        optimizer.step()

        if batch_idx % LOG_INTERVAL == 0:
            print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
                epoch, batch_idx * len(data), len(train_loader.dataset),
                100. * batch_idx / len(train_loader),
                loss.item() / len(data)))

            with torch.no_grad():
                sample = torch.randn(1, BOTTLENECK).to(device)
                sample = model.decode(sample).cpu()

                if save:
                    torchaudio.save(fn + str(epoch) + '.wav',
                                    sample.view(2, -1), sample_rate)

    print('====> Epoch: {} Average loss: {:.4f}'.format(
          epoch, train_loss / len(train_loader.dataset)))


def test_epoch(test_loader, epoch):
    model.eval()
    test_loss = 0
    with torch.no_grad():
        for i, (data, _) in enumerate(test_loader):
            data = data.to(device)
            recon_batch, mu, logvar = model(data)
            test_loss += loss_function(recon_batch, data, mu, logvar).item()
            if i == 0:
                n = min(data.size(0), 8)
                comparison = torch.cat([data[:n],
                                        recon_batch.view(BATCH_SIZE, 1, 28, 28)[:n]])

    test_loss /= len(test_loader.dataset)
    print('====> Test set loss: {:.4f}'.format(test_loss))

def prep(fn):
    # fileset = utils.Files()
    # fileloader = DataLoader(fileset)
    model = vae.VAE(dim=WINDOW_LEN, bottleneck=BOTTLENECK).to(device)
    optimizer = optim.Adam(model.parameters(), lr=1e-3)



def train(fn='/home/sippycups/Music/2018/81 - 2018 - 119 8 5 18.wav', epochs=50):
    os.makedirs()
    os.makedirs('samples/' + fn.split('/')[-1])
    for epoch in range(1, epochs + 1):

        # for i, fn in enumerate(fileset):

        train_loader = DataLoader(utils.Waveys(
            window=WINDOW_LEN, fn=fn), batch_size=BATCH_SIZE)

        train(train_loader, epoch)
        # test(epoch)


if __name__ == "__main__":

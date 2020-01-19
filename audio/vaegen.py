"""

"""
import os
import time

import torch
from torch.utils.data import DataLoader
import torchaudio
from torch.utils.tensorboard import SummaryWriter
from torch import nn, optim
from torch.nn import functional as F

import vae
import utils


writer = SummaryWriter()

# device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
device = torch.device("cpu"
print(device)
SAMPLE_RATE = 44100
WINDOW_LEN = SAMPLE_RATE * 5 
LOG_INTERVAL = 500
BATCH_SIZE = 128
BOTTLENECK = 50


def loss_function(recon_x, x, mu, logvar):
    # BCE = F.binary_cross_entropy(
    #     recon_x, x.view(-1, WINDOW_LEN), reduction='sum')
    BCE = F.binary_cross_entropy(
        recon_x, x, reduction='sum')
    KLD = -0.5 * torch.sum(1 + logvar - mu.pow(2) - logvar.exp())
    return BCE + KLD


def train(train_loader, epoch):
    model.train()
    train_loss = 0
    for batch_idx, data in enumerate(train_loader):
        data = data.to(device)
        optimizer.zero_grad()
        recon_batch, mu, logvar = model(data)
        loss = loss_function(recon_batch, data, mu, logvar)
        writer.add_scalar('train_loss', loss)
        loss.backward()
        train_loss += loss.item()
        optimizer.step()
        if batch_idx % LOG_INTERVAL == 0:
            print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
                epoch, batch_idx * len(data), len(train_loader.dataset),
                100. * batch_idx / len(train_loader),
                loss.item() / len(data)))

    print('====> Epoch: {} Average loss: {:.4f}'.format(
          epoch, train_loss / len(train_loader.dataset)))


def test(test_loader, epoch):
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


if __name__ == "__main__":

    
    epochs = 50
    
    train_loader = DataLoader(utils.Waveys(
        window=WINDOW_LEN), batch_size=BATCH_SIZE)
    
    model = vae.VAE(dim=WINDOW_LEN, bottleneck=BOTTLENECK).to(device)
    optimizer = optim.Adam(model.parameters(), lr=1e-3)

    time_dir = time.asctime() + '/'
    os.mkdir('samples/' + time_dir)

    for epoch in range(1, epochs + 1):
        train(train_loader, epoch)
        # test(epoch)
        with torch.no_grad():
            sample = torch.randn(1, BOTTLENECK).to(device)
            sample = model.decode(sample).cpu()
            torchaudio.save('samples/' + time_dir +
                            'vaetest' + str(epoch) + '.wav', sample, 44100)

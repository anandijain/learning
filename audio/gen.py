import time
import os

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim

from torch.utils.data import Dataset, DataLoader

import torchaudio

from scipy.io.wavfile import write
import matplotlib.pyplot as plt

import utils

GEN_PATH = 'gen.pth'
DISC_PATH = 'disc.pth'
DIRECTORY = "/home/sippycups/Music/2018/"
FILE_NAMES = os.listdir(DIRECTORY)

FAKES_PATH = 'samples/'

WINDOW_LEN = 50000
GEN_LATENT = WINDOW_LEN // 100


class Generator(nn.Module):
    def __init__(self, window=WINDOW_LEN):
        super(Generator, self).__init__()
        self.l1 = nn.Linear(GEN_LATENT, GEN_LATENT)
        # self.l2 = nn.Linear(GEN_LATENT, WINDOW_LEN // 10)
        # self.l3 = nn.Linear(WINDOW_LEN // 10, GEN_LATENT)
        self.l4 = nn.Linear(GEN_LATENT, WINDOW_LEN)

    def forward(self, x):
        x = F.relu(self.l1(x))
        x = F.relu(self.l2(x))
        x = F.relu(self.l3(x))
        x = F.relu(self.l4(x))
        return x


class Discriminator(nn.Module):
    def __init__(self, window=WINDOW_LEN):
        super(Discriminator, self).__init__()
        self.l1 = nn.Linear(WINDOW_LEN, WINDOW_LEN // 16)
        # self.l2 = nn.Linear(WINDOW_LEN // 4, WINDOW_LEN // 16)
        # self.l3 = nn.Linear(WINDOW_LEN // 16, WINDOW_LEN // 16)
        self.l4 = nn.Linear(WINDOW_LEN // 16, 1)

    def forward(self, x):
        x = F.relu(self.l1(x))
        x = F.relu(self.l2(x))
        x = F.relu(self.l3(x))
        x = F.relu(self.l4(x))
        return F.softmax(x, dim=0)


class Waveys(Dataset):
    def __init__(self, window=WINDOW_LEN):
        wave = utils.wavey(filename='81 - 2018 - 09 2 18 18.wav')
        self.w = wave[0][0]
        self.sample_rate = wave[1]
        print(self.sample_rate)
        self.length = len(self.w) // window - 1
        self.window = window

    def __len__(self):
        return self.length

    def __getitem__(self, idx):
        x = self.w[idx*self.window:(idx + 1)*self.window]
        return x.view(1, -1)


def weights_init(m):
    classname = m.__class__.__name__
    if classname.find('Conv') != -1:
        nn.init.normal_(m.weight.data, 0.0, 0.02)
    elif classname.find('BatchNorm') != -1:
        nn.init.normal_(m.weight.data, 1.0, 0.02)
        nn.init.constant_(m.bias.data, 0)


def train(load_trained=False, write_gen=True):
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    # device = torch.device('cpu')
    time_dir = time.asctime()
    if write_gen:
        if not os.path.isdir(FAKES_PATH):
            os.mkdir(FAKES_PATH)
            os.mkdir(time_dir)

    WAV_WRITE_PATH = FAKES_PATH + time_dir + '/'

    ngpu = 1
    workers = 4
    batch_size = 128
    num_epochs = 100
    lr = 0.0002
    beta1 = 0.5

    dataset = Waveys()
    dataloader = DataLoader(dataset, batch_size=batch_size,
                            shuffle=True, num_workers=workers)
    # Create the generator
    netG = Generator().to(device)
    netD = Discriminator().to(device)

    # Handle multi-gpu if desired
    if device.type == 'cuda':
        netG = nn.DataParallel(netG, list(range(ngpu)))
        netD = nn.DataParallel(netD, list(range(ngpu)))

    if load_trained:
        netG.load_state_dict(torch.load(GEN_PATH))
        netD.load_state_dict(torch.load(DISC_PATH))
    else:
        netG.apply(weights_init)
        netD.apply(weights_init)

    criterion = nn.BCELoss()
    fixed_noise = torch.randn(1, GEN_LATENT, device=device)

    real_label = 1
    fake_label = 0

    optimizerD = optim.Adam(netD.parameters(), lr=lr, betas=(beta1, 0.999))
    optimizerG = optim.Adam(netG.parameters(), lr=lr, betas=(beta1, 0.999))

    fakes = []
    G_losses = []
    D_losses = []

    iters = 0

    print("Starting Training Loop...")
    # For each epoch
    for epoch in range(num_epochs):
        for i, data in enumerate(dataloader, 0):
            netD.zero_grad()

            real_cpu = data[0].to(device)

            b_size = real_cpu.size(0)
            label = torch.full((b_size,), real_label, device=device)
            output = netD(real_cpu).view(-1)

            errD_real = criterion(output, label)
            errD_real.backward()
            D_x = output.mean().item()

            noise = torch.randn(b_size, GEN_LATENT, device=device)

            fake = netG(noise)
            label.fill_(fake_label)
            output = netD(fake.detach()).view(-1)

            errD_fake = criterion(output, label)
            errD_fake.backward()
            D_G_z1 = output.mean().item()
            errD = errD_real + errD_fake
            optimizerD.step()

            netG.zero_grad()
            label.fill_(real_label)
            output = netD(fake).view(-1)
            errG = criterion(output, label)
            errG.backward()
            D_G_z2 = output.mean().item()
            optimizerG.step()
            
            with torch.no_grad():
                fake = netG(fixed_noise).detach().cpu()
                if write_gen:
                    write(WAV_WRITE_PATH + 'fake_' + str(epoch) + '_' +
                          str(i) + '.wav', 44100, fake.detach().cpu().numpy().T)
                    
                    # write(FAKES_PATH + 'real_' + str(epoch) + '_' + str(i) +
                    #       '.wav', 44100, real_cpu.detach().cpu().numpy().T)

            if i % 50 == 0:
                print('[%d/%d][%d/%d]\tLoss_D: %.4f\tLoss_G: %.4f\tD(x): %.4f\tD(G(z)): %.4f / %.4f'
                      % (epoch, num_epochs, i, len(dataloader),
                         errD.item(), errG.item(), D_x, D_G_z1, D_G_z2))

                print(f'fake: {fake}')

            G_losses.append(errG.item())
            D_losses.append(errD.item())
            fakes.append(fake)

        torch.save(netG.state_dict(), GEN_PATH)
        torch.save(netD.state_dict(), DISC_PATH)

    return fakes, G_losses, D_losses


if __name__ == "__main__":
    data, G_losses, D_losses = train()

    plt.figure(figsize=(10, 5))
    plt.title("Generator and Discriminator Loss During Training")
    plt.plot(G_losses, label="G")
    plt.plot(D_losses, label="D")
    plt.xlabel("iterations")
    plt.ylabel("Loss")
    plt.legend()
    plt.show()

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim

class VAE(nn.Module):
    def __init__(self, dim, bottleneck=50):
        super(VAE, self).__init__()
        self.dim = dim
        self.fc1 = nn.Linear(dim, 400)
        self.fc21 = nn.Linear(400, bottleneck)
        self.fc22 = nn.Linear(400, bottleneck)
        self.fc3 = nn.Linear(bottleneck, 400)
        self.fc4 = nn.Linear(400, dim)

    def encode(self, x):
        h1 = F.relu(self.fc1(x))
        return self.fc21(h1), self.fc22(h1)

    def reparameterize(self, mu, logvar):
        std = torch.exp(0.5*logvar)
        eps = torch.randn_like(std)
        return mu + eps*std

    def decode(self, z):
        h3 = F.relu(self.fc3(z))
        # print(f'h3: {h3.shape}')
        return torch.sigmoid(self.fc4(h3))

    def forward(self, x):
        # print(x.shape)
        mu, logvar = self.encode(x)
        z = self.reparameterize(mu, logvar)
        # print(z.shape)
        return self.decode(z), mu, logvar

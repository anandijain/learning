import os

import pandas as pd
import numpy as np
import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader
import pandas as pd
from sklearn import preprocessing

import matplotlib.pyplot as plt

num_epochs = 1
batch_size = 1
hidden_shape = 10
num_layers = 1
window = 1

log_interval = 100
break_idx = 100

save_folder = "./models/"
save_fn = "lstm.pt"

save_path = save_folder + save_fn
dir = "../data/stocks/Data/Stocks/"

# device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
device = torch.device("cpu")

print(device)


def plot_data(data, separate=True):
    # numpy input
    col_names = ["open", "high", "low", "close"]
    groups = range(4)
    i = 1
    plt.figure()
    if separate:
        for group in groups:
            plt.subplot(len(groups), 1, i)
            plt.plot(data[:, group])
            plt.title(col_names[group], y=0.5, loc="right")
            i += 1
    else:
        plt.plot(data)
    plt.show()


def dataset_shapes(dataset):
    sample_x, sample_y = dataset[0]
    print(
        f"dataset_shapes: sample_x shape: {sample_x.shape}, sample_y shape: {sample_y.shape}"
    )
    return sample_x, sample_y


def dataloader_shapes(data_loader):
    for (x, y) in data_loader:
        print(f"dataloader_shapes: x shape: {x.shape}, y shape: {y.shape}")
        break
    return x, y


def attempt_load(model, path):
    try:
        model.load_state_dict(torch.load(path))
        print(f"model state dict loaded from: {path}")
    except Exception:
        pass
    return model


def init_model_folder(save_folder):
    if os.path.exists(save_folder):
        pass
    else:
        os.mkdir(save_folder)


def get_loaders():
    fileset = FileLoader(dir)
    data = fileset[1]

    dataset = LSTMLoader(data, window_len=window)
    data_loader = DataLoader(dataset, batch_size=batch_size, shuffle=False)
    return fileset, dataset, data_loader


def quick_plot(sep=False):
    fs, ds, dl = get_loaders()
    plot_data(fs[0], separate=sep)


def main():
    pass


class FileLoader:
    def __init__(self, dir):
        self.files = os.listdir(dir)
        self.length = len(self.files)
        self.dir = dir
        self.file = self.files[0]

    def __getitem__(self, index):
        self.file = self.files[index]
        df = pd.read_csv(self.dir + self.files[index])
        return df.iloc[:, 1:5].values

    # x = df.values #returns a numpy array
    # min_max_scaler = preprocessing.MinMaxScaler()
    # x_scaled = min_max_scaler.fit_transform(x)
    # data = x_scaled

    def __len__(self):
        return self.length


class LSTMLoader(Dataset):
    def __init__(self, data, window_len=1, predict_window=1):
        self.samples = []
        self.length = len(data)
        self.window_len = window_len
        self.predict_window = predict_window
        self.data = data
        self.get_data()

    def get_data(self):
        for i in range(0, self.length - self.predict_window):
            upper_idx = i + self.window_len
            x = torch.tensor(self.data[i:upper_idx, :]).view(1, 1, -1).float()
            y = (
                torch.tensor(self.data[upper_idx : upper_idx + self.predict_window, :])
                .view(1, 1, -1)
                .float()
            )
            self.samples.append((x, y))

    def __len__(self):
        return self.length - self.predict_window  # (self.window_len + 1)

    def __getitem__(self, index):
        return self.samples[index]


class LSTM(nn.Module):
    def __init__(self, input_dim, hidden_dim, batch_size, output_dim=1, num_layers=1):
        super(LSTM, self).__init__()
        self.input_dim = input_dim
        self.hidden_dim = hidden_dim
        self.batch_size = batch_size
        self.num_layers = num_layers
        self.lstm = nn.LSTM(self.input_dim, self.hidden_dim, self.num_layers)
        self.linear = nn.Linear(self.hidden_dim, output_dim)

    def init_hidden(self):
        return (
            torch.zeros(self.num_layers, self.batch_size, self.hidden_dim).to(device),
            torch.zeros(self.num_layers, self.batch_size, self.hidden_dim).to(device),
        )

    def forward(self, input):
        # lstm_out: [input_size, batch_size, hidden_dim]
        # self.hidden: (a, b), where a and b both (num_layers, batch_size, hidden_dim).
        lstm_out, self.hidden = self.lstm(
            input.view(len(input), self.batch_size, -1), self.hidden
        )
        y_pred = self.linear(lstm_out[-1].view(self.batch_size, -1))
        return y_pred.view(-1)


def get_data():
    fn = dir + "stocks.npy"
    if not os.path.isfile(fn):
        df = pd.read_csv(dir + "big_ole.csv")
        df = df.fillna(value=-1)
        data = df.values

        np.save(data, fn)
    else:
        data = np.load(fn)

    return data


if __name__ == "__main__":

    init_model_folder(save_folder)

    # data = get_data()
    dataset = LSTMLoader(data, window_len=window)
    data_loader = DataLoader(dataset, batch_size=batch_size, shuffle=False)
    x, y = dataloader_shapes(data_loader)

    sample_x, sample_y = dataset_shapes(dataset)
    input_shape = len(sample_x.flatten())
    output_shape = len(sample_y.flatten())
    print(f"in shape: {input_shape}, out shape: {output_shape}")

    model = LSTM(
        input_shape,
        hidden_dim=hidden_shape,
        batch_size=batch_size,
        output_dim=output_shape,
        num_layers=num_layers,
    )

    model = attempt_load(model, save_path)
    model.to(device)

    loss_fn = torch.nn.CrossEntropyLoss()
    learning_rate = 1e-2
    optimiser = torch.optim.Adam(model.parameters(), lr=learning_rate)

    hist = np.zeros(num_epochs * len(dataset))

    for epoch in range(num_epochs):
        # Clear stored gradient
        torch.save(model.state_dict(), save_path)
        model.hidden = model.init_hidden()

        for i, (x, y) in enumerate(data_loader):
            optimiser.zero_grad()
            print(x)
            print(x.shape)
            x = x.view(1, batch_size, -1)
            y = y.view(1, batch_size, -1)

            x, y = x.to(device), y.to(device)

            y_pred = model(x)
            y_pred = y_pred.view(1, batch_size, -1)

            loss = loss_fn(y_pred, y)

            if i % log_interval == 0:
                print("Epoch ", epoch, "MSE: ", loss.item())
                print(f"y_pred: {y_pred[0, 0]}, y: {y[0, 0]}")
                print(f"i: {i} / len: {len(data_loader)}")

            hist[epoch] = loss.item()
            loss.backward(retain_graph=True)
            optimiser.step()

    torch.save(model.state_dict(), save_path)

    plt.plot(y_pred.detach().flatten().numpy(), label="Preds")
    plt.plot(y.detach().flatten().numpy(), label="Data")
    plt.legend()
    plt.show()

    plt.plot(hist, label="Training loss")
    plt.legend()
    plt.show()

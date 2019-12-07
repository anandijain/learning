"""

"""
import os
import io
import random

from matplotlib.backends.backend_agg import FigureCanvasAgg
from matplotlib.backends.backend_svg import FigureCanvasSVG

from matplotlib.figure import Figure

import torch
import torchaudio
import matplotlib.pyplot as plt

import pandas as pd
import numpy as np

from flask import Flask, Response, request, render_template


app = Flask(__name__)

DIRECTORY = "/home/sippycups/Music/2019/"
FILE_NAMES = os.listdir(DIRECTORY)


def sgram(wave):
    return torchaudio.transforms.Spectrogram()(wave)


def wavey(filename):
    return torchaudio.load(DIRECTORY + filename)[0]


@app.route("/")
def hello_world():
    """

    """
    return str(FILE_NAMES)


@app.route('/sgrams/<int:i>')
def display_sgram(i):
    song_name = FILE_NAMES[i]
    print(f'song_name: {song_name}')
    specgram = sgram(wavey(song_name))

    fig = Figure(figsize=(20, 10), dpi=500)
    axis = fig.add_subplot(1, 1, 1, title=str(song_name))
    axis.imshow(specgram.log2()[0, :, :].numpy(), cmap='rainbow')
    output = io.BytesIO()
    FigureCanvasAgg(fig).print_png(output)
    return Response(output.getvalue(), mimetype="image/png")


@app.route('/waves/<int:i>')
def display_wave(i):
    song_name = FILE_NAMES[i]
    wave = wavey(song_name)
    fig = Figure(figsize=(10, 10), dpi=100)
    axis = fig.add_subplot(1, 1, 1, title=str(song_name))
    axis.plot(wave.t().numpy())
    output = io.BytesIO()
    FigureCanvasAgg(fig).print_png(output)
    return Response(output.getvalue(), mimetype="image/png")


if __name__ == "__main__":
    import webbrowser

    host = "0.0.0.0"
    app.run(host=host, debug=True)

    webbrowser.open("http://" + host + ":5000/")

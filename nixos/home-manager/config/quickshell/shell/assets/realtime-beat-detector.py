#!/bin/python

import pyaudio
import numpy as np
import aubio
import signal
import sys

from typing import List, Tuple


class BeatDetector:
    def __init__(self, buf_size: int):
        self.buf_size: int = buf_size

        # Set up pyaudio and aubio beat detector
        self.audio: pyaudio.PyAudio = pyaudio.PyAudio()
        samplerate: int = 44100

        self.stream: pyaudio.Stream = self.audio.open(
            format=pyaudio.paFloat32,
            channels=1,
            rate=samplerate,
            input=True,
            frames_per_buffer=self.buf_size,
            stream_callback=self._pyaudio_callback
        )

        fft_size: int = self.buf_size * 2

        # tempo detection
        self.tempo: aubio.tempo = aubio.tempo("default", fft_size, self.buf_size, samplerate)

    # this one is called every time enough audio data (buf_size) has been read by the stream
    def _pyaudio_callback(self, in_data, frame_count, time_info, status):
        # Interpret a buffer as a 1-dimensional array (aubio do not work with raw data)
        audio_data = np.frombuffer(in_data, dtype=np.float32)
        # true if beat present
        beat = self.tempo(audio_data)

        # if beat detected, calculate BPM and send to OSC
        if beat[0]:
            print(self.tempo.get_bpm(), flush=True)

        return None, pyaudio.paContinue  # Tell pyAudio to continue

    def __del__(self):
        self.stream.close()
        self.audio.terminate()
        print('--- Stopped ---')


# main
def main():
    bd = BeatDetector(512)

    # capture ctrl+c to stop gracefully process
    def signal_handler(none, frame):
        bd.stream.stop_stream()
        bd.stream.close()
        bd.audio.terminate()
        print(' ===> Ctrl + C')
        sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)

    # Audio processing happens in separate thread, so put this thread to sleep
    signal.pause()


# main run
if __name__ == "__main__":
    main()

#  SPDX-FileCopyrightText:  Copyright 2021, 2023 Arm Limited and/or its affiliates <open-source-office@arm.com>
#  SPDX-License-Identifier: Apache-2.0
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
"""
This script can be used with the noise reduction use case to save
the dumped noise reduced audio to a wav file.

Example use:
python rnnoise_dump_extractor.py --dump_file output.bin --output_dir ./denoised_wavs/
"""

import argparse
import struct
import typing
from os import path

import numpy as np
import soundfile as sf


def extract(
        dump_file: typing.IO,
        output_dir: str,
        export_npy: bool
):
    """
    Extract audio file from RNNoise output dump

    @param dump_file:   Audio dump file location
    @param output_dir:  Output direction
    @param export_npy:  Whether to export the audio as .npy
    """
    while True:
        filename_length = struct.unpack("i", dump_file.read(4))[0]

        if filename_length == -1:
            return

        filename = struct \
            .unpack(f"{filename_length}s", dump_file.read(filename_length))[0] \
            .decode('ascii')

        audio_clip_length = struct.unpack("I", dump_file.read(4))[0]
        output_file_name = path.join(output_dir, f"denoised_{filename}")
        audio_clip = dump_file.read(audio_clip_length)

        with sf.SoundFile(output_file_name, 'w', channels=1, samplerate=48000, subtype="PCM_16",
                          endian="LITTLE") as wav_file:
            wav_file.buffer_write(audio_clip, dtype='int16')
            print(f"{output_file_name} written to disk")

        if export_npy:
            output_file_name += ".npy"
            pack_format = f"{int(audio_clip_length / 2)}h"
            npdata = np.array(struct.unpack(pack_format, audio_clip)).astype(np.int16)
            np.save(output_file_name, npdata)
            print(f"{output_file_name} written to disk")


def main(args):
    """
    Run RNNoise audio dump extraction
    @param args:    Parsed args
    """
    extract(args.dump_file, args.output_dir, args.export_npy)


parser = argparse.ArgumentParser()

parser.add_argument(
    "--dump_file",
    type=argparse.FileType('rb'),
    help="Dump file with audio files to extract.",
    required=True
)

parser.add_argument(
    "--output_dir",
    help="Output directory, Warning: Duplicated file names will be overwritten.",
    required=True
)

parser.add_argument(
    "--export_npy",
    help="Export the audio buffer in NumPy format",
    action="store_true"
)

parsed_args = parser.parse_args()

if __name__ == "__main__":
    main(parsed_args)

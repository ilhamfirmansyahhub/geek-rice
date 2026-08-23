#!/usr/bin/env python3

import time
import subprocess

from evdev import InputDevice, ecodes


DEVICE = "/dev/input/event4"

SHELL = "$HOME/.local/src/Brain_Shell"

STATUS = "/tmp/brain_search_status"


KEYMAP = {
    16:"q",
    17:"w",
    18:"e",
    19:"r",
    20:"t",
    21:"y",
    22:"u",
    23:"i",
    24:"o",
    25:"p",

    30:"a",
    31:"s",
    32:"d",
    33:"f",
    34:"g",
    35:"h",
    36:"j",
    37:"k",
    38:"l",

    44:"z",
    45:"x",
    46:"c",
    47:"v",
    48:"b",
    49:"n",
    50:"m"
}


def desktop_empty():

    try:

        out = subprocess.check_output(
            [
                "hyprctl",
                "activewindow",
                "-j"
            ],
            stderr=subprocess.DEVNULL
        ).decode()


        if out.strip() == "{}":
            return True


        if '"class":"quickshell"' in out:
            return True


        return False


    except:

        return False



def search_open():

    try:

        with open(STATUS, "r") as f:

            return f.read().strip() == "open"


    except:

        return False



def open_search():

    subprocess.Popen(
        [
            "qs",
            "ipc",
            "-c",
            SHELL,
            "call",
            "brain-search",
            "toggle"
        ],

        stdout=subprocess.DEVNULL,

        stderr=subprocess.DEVNULL
    )



device = InputDevice(DEVICE)

print(
    "Brain Runner:",
    device.name
)


opened = False



for event in device.read_loop():


    if event.type != ecodes.EV_KEY:
        continue


    if event.value != 1:
        continue


    if event.code not in KEYMAP:
        continue



    # kalau search sedang terbuka,
    # jangan lakukan apa-apa

    if search_open():

        opened = True

        continue



    # search sudah ditutup,
    # reset lock

    if opened:

        opened = False



    # hanya desktop kosong

    if not desktop_empty():

        continue



    open_search()


    opened = True


    time.sleep(0.5)

#!/usr/bin/env python3
import sys
from time import sleep
from select import select

durations = {
        "+": (52, 17),
        "-": (25, 5),
}

def formatTime(minutes, seconds):
    return format(minutes, "02d") + ":" + format(seconds, "02d")

def waitMinutes(mins):
    print()
    for minute in range(mins):
        for second in range(0, 60):
            print("\033[A\r\033[K" + formatTime(minute, second) + " of " + formatTime(mins, 0))
            try:
                sleep(1)
            except KeyboardInterrupt:
                print("\033[A\r\033KInterrupted at", formatTime(minute, second))
                return
            while sys.stdin in select([sys.stdin], [], [], 0)[0]:
                for it in range(2):
                    input()
                    print("\033[A", end="")
    print("\033[A\r\033[K" + formatTime(mins, 0))

if len(sys.argv) != 2:
    print("Usage:", sys.argv[0], "<tsk file>", file=sys.stderr)
    sys.exit(1)

try:
    tasks = []
    with open(sys.argv[1]) as f:
        for line in f.readlines():
            line = line.strip()
            if len(line) < 7:
                continue

            if line[:4] == "TODO":
                tasks.append((line[6:], line[4]))

    count = 0
    for task in tasks:
        if task[1] not in durations:
            print("unknown task duration:", task[1])
            continue
        print("Work on:", task[0])
        waitMinutes(durations[task[1]][0])
        count += 1

        if count % 4 > 0:
            print("Make a break.")
            waitMinutes(durations[task[1]][1])
        else:
            print("Big break time.")
            waitMinutes(30)

except FileNotFoundError:
    print("Unable to find tsk file.", file=sys.stderr)
    sys.exit(1)


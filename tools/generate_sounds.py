#!/usr/bin/env python3
import math
import random
import struct
import wave
from pathlib import Path

RATE = 22050
OUT = Path(__file__).resolve().parent.parent / "assets" / "sounds"


def silence(seconds):
    return [0.0] * int(seconds * RATE)


def envelope(i, n, attack=0.005, release=0.05):
    t = i / RATE
    total = n / RATE
    a = min(1.0, t / attack) if attack > 0 else 1.0
    r = min(1.0, (total - t) / release) if release > 0 else 1.0
    return max(0.0, min(a, r))


def square(phase, duty=0.5):
    return 1.0 if (phase % 1.0) < duty else -1.0


def triangle(phase):
    p = phase % 1.0
    return 4 * p - 1 if p < 0.5 else 3 - 4 * p


def sweep(seconds, start_hz, end_hz, wave_fn, volume, attack=0.002, release=0.03, curve=1.0):
    n = int(seconds * RATE)
    out = []
    phase = 0.0
    for i in range(n):
        k = (i / n) ** curve
        hz = start_hz + (end_hz - start_hz) * k
        phase += hz / RATE
        out.append(wave_fn(phase) * volume * envelope(i, n, attack, release))
    return out


def noise(seconds, volume, decay, seed):
    rng = random.Random(seed)
    n = int(seconds * RATE)
    out = []
    held = 0.0
    for i in range(n):
        if i % 2 == 0:
            held = rng.uniform(-1, 1)
        out.append(held * volume * math.exp(-decay * i / RATE))
    return out


def mix(*tracks):
    n = max(len(t) for t in tracks)
    return [sum(t[i] for t in tracks if i < len(t)) for i in range(n)]


def concat(*tracks):
    out = []
    for t in tracks:
        out.extend(t)
    return out


def note(midi):
    return 440.0 * 2 ** ((midi - 69) / 12)


def write(name, samples):
    OUT.mkdir(parents=True, exist_ok=True)
    peak = max(1.0, max(abs(s) for s in samples))
    frames = b"".join(struct.pack("<h", int(s / peak * 32767)) for s in samples)
    with wave.open(str(OUT / name), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(frames)


def shoot():
    return sweep(0.08, 1100, 450, lambda p: square(p, 0.25), 0.22, curve=0.6)


def enemy_hit():
    return mix(
        noise(0.06, 0.35, 60, seed=1),
        sweep(0.06, 260, 140, triangle, 0.4),
    )


def enemy_death():
    return mix(
        noise(0.25, 0.4, 14, seed=2),
        sweep(0.25, 420, 60, lambda p: square(p, 0.5), 0.3, curve=0.5, release=0.1),
    )


def player_hurt():
    n = int(0.4 * RATE)
    out = []
    phase = 0.0
    for i in range(n):
        t = i / RATE
        hz = 320 - 220 * (i / n) + 25 * math.sin(2 * math.pi * 30 * t)
        phase += hz / RATE
        out.append(square(phase, 0.4) * 0.45 * envelope(i, n, 0.002, 0.15))
    return mix(out, noise(0.15, 0.3, 25, seed=3))


def confirm():
    return concat(
        sweep(0.07, note(76), note(76), lambda p: square(p, 0.25), 0.3, release=0.02),
        sweep(0.14, note(83), note(83), lambda p: square(p, 0.25), 0.3, release=0.1),
    )


def game_over():
    parts = []
    for midi, seconds in [(67, 0.22), (63, 0.22), (60, 0.22), (55, 0.7)]:
        parts.append(mix(
            sweep(seconds, note(midi), note(midi), triangle, 0.45, release=seconds * 0.6),
            sweep(seconds, note(midi) * 1.005, note(midi) * 1.005, lambda p: square(p, 0.5), 0.12, release=seconds * 0.6),
        ))
    return concat(*parts)


def music():
    bpm = 112
    beat = 60 / bpm
    bars = 8
    total = int(bars * 4 * beat * RATE)
    out = [0.0] * total

    def place(samples, at_seconds):
        start = int(at_seconds * RATE)
        for i, s in enumerate(samples):
            out[(start + i) % total] += s

    def heartbeat(at):
        place(sweep(0.16, 95, 45, lambda p: math.sin(2 * math.pi * p), 0.9, release=0.1), at)
        place(sweep(0.13, 80, 40, lambda p: math.sin(2 * math.pi * p), 0.6, release=0.09), at + beat * 0.4)

    progression = [45, 45, 41, 43, 45, 45, 40, 40]
    arpeggio = [0, 3, 7, 12, 7, 3, 7, 10]

    for bar in range(bars):
        root = progression[bar]
        bar_start = bar * 4 * beat
        for b in range(4):
            if b % 2 == 0:
                heartbeat(bar_start + b * beat)
        place(sweep(4 * beat, note(root - 12), note(root - 12), triangle, 0.35, attack=0.05, release=0.3), bar_start)
        for step in range(8):
            midi = root + 12 + arpeggio[step]
            place(sweep(beat / 2 * 0.9, note(midi), note(midi), lambda p: square(p, 0.125), 0.08, release=beat / 2 * 0.7),
                  bar_start + step * beat / 2)
        hat = noise(0.04, 0.08, 120, seed=bar)
        for step in range(8):
            if step % 2 == 1:
                place(hat, bar_start + step * beat / 2)

    return [s * 0.6 for s in out]


def main():
    write("shoot.wav", shoot())
    write("enemy_hit.wav", enemy_hit())
    write("enemy_death.wav", enemy_death())
    write("player_hurt.wav", player_hurt())
    write("confirm.wav", confirm())
    write("game_over.wav", game_over())
    write("music.wav", music())


if __name__ == "__main__":
    main()

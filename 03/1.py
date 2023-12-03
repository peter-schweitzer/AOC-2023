#!/bin/python3

from functools import reduce
from re import finditer

with open("input.txt") as f:
    lines = [line.strip() for line in f.readlines()]

print(
    reduce(
        lambda acc, e: acc
        + reduce(
            lambda acc, x: acc + int(x.group(0)),
            filter(
                lambda num: len(
                    list(
                        filter(
                            lambda l: len(
                                l[
                                    max(num.start() - 1, 0) : min(num.end() + 1, len(l))
                                ].strip(".0123456789")
                            ),
                            lines[max(e[0] - 1, 0) : min(e[0] + 2, len(lines))],
                        )
                    )
                ),
                finditer("\\d+", e[1]),
            ),
            0,
        ),
        enumerate(lines),
        0,
    )
)

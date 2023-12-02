#!/bin/python3
from functools import reduce


def line_power(sets: list[str]) -> int:
    minimums = {"red": 0, "green": 0, "blue": 0}
    for set in sets:
        for subset in [x.strip() for x in set.split(",")]:
            [amount, color] = subset.split(" ")
            minimums[color] = max(int(amount), minimums[color])
    return reduce(lambda x, acc: acc * x, minimums.values(), 1)


with open("input.txt") as f:
    print(
        sum(
            line_power(line[1].split(";"))
            for line in [x.split(":") for x in f.readlines()]
        )
    )

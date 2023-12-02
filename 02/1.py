#!/bin/python3

max_amounts = {"red": 12, "green": 13, "blue": 14}

f = open("input.txt")
lines = [x.split(":") for x in f.readlines()]
f.close()


def filter_line(sets: str) -> bool:
    for set in sets.split(";"):
        for subset in [x.strip() for x in set.split(",")]:
            [amount, color] = subset.split(" ")
            if int(amount) > max_amounts[color]:
                return False
    return True


print(sum([int(line[0].split(" ")[1]) for line in lines if filter_line(line[1])]))

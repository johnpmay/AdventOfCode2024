with open ('../../AdventOfCode_inputs/AoC-2024-01-input.txt', 'r') as casefile:
	l1, l2 = zip(*[x.split() for x in casefile.read().strip().splitlines()])
l1 = sorted([int(x) for x in l1])
l2 = sorted([int(x) for x in l2])
ans1 = sum(abs(x-y) for x,y in zip(l1,l2))
print(ans1)

ans2 = sum(l2.count(x)*x for x in l1)
print(ans2)

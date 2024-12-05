with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-05-input.txt" ):

(rules, updates) := StringSplit(Trim(input), "\n\n")[]:
rules := map(s->map(s2i,Split(s,"|")), Split(rules,"\n")):
updates := map(s->(map(s2i,Split(s,","))), Split(updates, "\n")):

V := ListTools:-MakeUnique(map2(op,1,rules)):
N := [seq(map2(op,2,select(n->m=n[1], rules)), m in V)]:
T := table([seq(V[i]={N[i][]}, i=1..nops(V))]):
comp := (x,y)->evalb(y in T[x]):

sortups := map(sort, updates, strict=comp):

(goodidx, fixidx) := selectremove(i->sortups[i]=updates[i], [seq(1..numelems(updates))]):

ans1 := add(sortups[i][ceil(numelems(sortups[i])/2)], i in goodidx);

ans2 := add(sortups[i][ceil(numelems(sortups[i])/2)], i in fixidx);


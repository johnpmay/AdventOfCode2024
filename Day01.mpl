with(StringTools):
s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile( "../AdventOfCode_inputs/AoC-2024-01-input.txt" ):
pinput := map(Words,Split(Trim(input), "\n")):

list1 := map2(s2i@op, 1, pinput):
list2 := map2(s2i@op, 2, pinput):
ans1 := add( map(abs, sort(list1) -~ sort(list2) ) );
ans2 := add(s*numboccur(s,list2), s in list1);

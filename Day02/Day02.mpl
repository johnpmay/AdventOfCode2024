with(StringTools):
s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile( "../../AdventOfCode_inputs/AoC-2024-02-input.txt" ):

pinput := map(Split,Split(Trim(input), "\n"), " "):
pinput := subsindets(pinput, 'string', s2i):

goodRep := proc(r)
local diffs := {op(r[1..-2] - r[2..-1])};
    return diffs subset {1,2,3} or diffs subset {-1,-2,-3};
end proc:
ans1 := add(ifelse(goodRep(r),1,0), r in pinput);

goodRep2 := proc(r)
local i;
    return orseq(goodRep(subsop(i=NULL,r)), i=1..nops(r));
end proc:
ans2 := add(ifelse(goodRep2(r),1,0), r in pinput);


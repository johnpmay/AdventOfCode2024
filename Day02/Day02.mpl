with(StringTools):
input := FileTools:-Text:-ReadFile( "../../AdventOfCode_inputs/AoC-2024-02-input.txt" ):

pinput := map(Split,Split(Trim(input), "\n"), " "):
pinput := subsindets(pinput, 'string', convert, 'integer'):

goodRep := proc(r)
local d, diffs := r[1..-2] - r[2..-1];
    if     abs(add(signum(d), d in diffs)) = nops(diffs)
       and max(abs~(diffs)) <= 3 and min(abs~(diffs)) >=1
    then
         return true;
    else
         return false;
    end if;
end proc:
ans1 := add(ifelse(goodRep(r),1,0), r in pinput);

goodRep2 := proc(r)
local i;
    if goodRep(r) then return true; end if;
    for i from 1 to nops(r) do
        if goodRep(subsop(i=NULL,r)) then return true; end if;
    end do;
    return false;
end proc:
ans2 := add(ifelse(goodRep2(r),1,0), r in pinput);


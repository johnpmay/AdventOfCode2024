with(StringTools): s2i := s->sscanf(s,"%d")[1]: i2s := i->cat("",i):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-11-input.txt" ):
inp := s2i~(map(Words,Trim(input)));

count := proc(n, s)
option remember;
    if n = 0 then return 1;
    elif s=0 then return count(n-1,1);
    end if;
    local l := length(s);
    if l mod 2 = 0 then
         local f := floor( s/10^(l/2) );
         return count(n-1,f) + count(n-1,s-f*10^(l/2));
    else return count(n-1, 2024*s);
    end if;
end proc:
ans1 := CodeTools:-Usage( add( map2(count, 25, inp) ) );
ans2 := CodeTools:-Usage( add( map2(count, 75, inp) ) );

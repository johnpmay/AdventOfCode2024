with(StringTools): s2i := s->sscanf(s,"%d")[1]: i2s := i->cat("",i):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-11-input.txt" ):
inp := s2i~(map(Words,Trim(input)));
count := proc(n, s)
option cache;
    if n = 0 then return 1;
    elif s=0 then return count(n-1,1);
    elif s=1 and n>=3 then return 2*count(n-3,2)+count(n-3,0)+count(n-3,4); #20 24
    elif s=2 and n>=3 then return 2*count(n-3,4)+count(n-3,0)+count(n-3,8); # 40 48
    elif s=3 and n>=3 then return count(n-3,6)+count(n-3,0)+count(n-3,7)+count(n-3,2); # 60 72
    elif s=4 and n>=3 then return count(n-3,8)+count(n-3,0)+count(n-3,9)+count(n-3,6); # 80 96

    elif s=5 and n>=5 then return 2*count(n-5,2)+2*count(n-5,0)+  count(n-5,4)+3*count(n-5,8); # 20 48 28 80
    elif s=6 and n>=5 then return   count(n-5,2)+2*count(n-5,4)+2*count(n-5,5)+  count(n-5,7)+count(n-5,9)+count(n-5,6); # 24 57 94 56
    elif s=7 and n>=5 then return 2*count(n-5,2)+  count(n-5,8)+2*count(n-5,6)+  count(n-5,7)+count(n-5,0)+count(n-5,3); # 28 67 60 32
    elif s=8 and n>=5 then return   count(n-5,3)+2*count(n-5,2)+2*count(n-5,7)+  count(n-5,6)+count(n-4,8); # 32 77 26 08
    elif s=9 and n>=5 then return   count(n-5,3)+2*count(n-5,6)+2*count(n-5,8)+  count(n-5,9)+count(n-5,1)+count(n-5,4); # 36 86 91 84
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

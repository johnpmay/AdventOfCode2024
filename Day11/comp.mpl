with(StringTools): s2i := s->sscanf(s,"%d")[1]: i2s := i->cat("",i):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-11-input.txt" ):
inp := s2i~(map(Words,Trim(input)));

countr := proc(n, s)
option remember;
    if n = 0 then return 1;
    elif s=0 then return thisproc(n-1,1);
    end if;
    local l := length(s);
    if l mod 2 = 0 then
         local f := floor( s/10^(l/2) );
         return thisproc(n-1,f) + thisproc(n-1,s-f*10^(l/2));
    else return thisproc(n-1, 2024*s);
    end if;
end proc:
ansr := CodeTools:-Usage( add( map2(countr, 75, inp) ) );

countrs := proc(n, s)
option remember,system;
    if n = 0 then return 1;
    elif s=0 then return thisproc(n-1,1);
    end if;
    local l := length(s);
    if l mod 2 = 0 then
         local f := floor( s/10^(l/2) );
         return thisproc(n-1,f) + thisproc(n-1,s-f*10^(l/2));
    else return thisproc(n-1, 2024*s);
    end if;
end proc:
ansrs := CodeTools:-Usage( add( map2(countrs, 75, inp) ) );


countc7 := proc(n, s)
option cache(1000000);
    if n = 0 then return 1;
    elif s=0 then return thisproc(n-1,1);
    end if;
    local l := length(s);
    if l mod 2 = 0 then
         local f := floor( s/10^(l/2) );
         return thisproc(n-1,f) + thisproc(n-1,s-f*10^(l/2));
    else return thisproc(n-1, 2024*s);
    end if;
end proc:
ansc7 := CodeTools:-Usage( add( map2(countc7, 75, inp) ) );

countc6 := proc(n, s)
option cache(100000);
    if n = 0 then return 1;
    elif s=0 then return thisproc(n-1,1);
    end if;
    local l := length(s);
    if l mod 2 = 0 then
         local f := floor( s/10^(l/2) );
         return thisproc(n-1,f) + thisproc(n-1,s-f*10^(l/2));
    else return thisproc(n-1, 2024*s);
    end if;
end proc:
ansc6 := CodeTools:-Usage( add( map2(countc6, 75, inp) ) );

countc5 := proc(n, s)
option cache(10000);
    if n = 0 then return 1;
    elif s=0 then return thisproc(n-1,1);
    end if;
    local l := length(s);
    if l mod 2 = 0 then
         local f := floor( s/10^(l/2) );
         return thisproc(n-1,f) + thisproc(n-1,s-f*10^(l/2));
    else return thisproc(n-1, 2024*s);
    end if;
end proc:
ansc5 := CodeTools:-Usage( add( map2(countc5, 75, inp) ) );


countc4 := proc(n, s)
option cache(1000);
    if n = 0 then return 1;
    elif s=0 then return thisproc(n-1,1);
    end if;
    local l := length(s);
    if l mod 2 = 0 then
         local f := floor( s/10^(l/2) );
         return thisproc(n-1,f) + thisproc(n-1,s-f*10^(l/2));
    else return thisproc(n-1, 2024*s);
    end if;
end proc:
ansc4 := CodeTools:-Usage( add( map2(countc4, 75, inp) ) );

countc := proc(n, s)
option cache;
    if n = 0 then return 1;
    elif s=0 then return thisproc(n-1,1);
    end if;
    local l := length(s);
    if l mod 2 = 0 then
         local f := floor( s/10^(l/2) );
         return thisproc(n-1,f) + thisproc(n-1,s-f*10^(l/2));
    else return thisproc(n-1, 2024*s);
    end if;
end proc:
ansc := CodeTools:-Usage( add( map2(countc, 75, inp) ) );

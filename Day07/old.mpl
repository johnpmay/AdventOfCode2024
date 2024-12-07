with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-07-input.txt" ):

eqs := map(proc(s) local t:=Split(s,":"); [s2i(t[1]),s2i~(Split(Trim(t[2])," "))] end,
           Split(Trim(input), "\n")): nops(eqs);
check := proc(rs, ns)
    if nops(ns) = 1 then
        return evalb(rs=ns[1]);
    else
        return thisproc(rs, [ns[1]*ns[2], ifelse(nops(ns)>2, ns[3..-1][],NULL)])
            or thisproc(rs, [ns[1]+ns[2], ifelse(nops(ns)>2, ns[3..-1][],NULL)]);
    end if;
end proc:
(goods, bads) := selectremove(e->check(e[]), eqs):
ans1 := add(e[1], e in goods);

check2 := proc(rs, ns)
    if nops(ns) = 1 then
        return evalb(rs=ns[1]);
    elif ns[1] > rs or ns[2] > rs then # numbers are all positive
        return false;
    else
        return
               thisproc(rs, [10^(ilog10(ns[2])+1)*ns[1]+ns[2],
                             ifelse(nops(ns)>2, ns[3..-1][],NULL)])
	    or thisproc(rs, [ns[1]*ns[2], ifelse(nops(ns)>2, ns[3..-1][],NULL)])
            or thisproc(rs, [ns[1]+ns[2], ifelse(nops(ns)>2, ns[3..-1][],NULL)]);
    end if;
end proc:
goods2 := CodeTools:-Usage( select(e->check2(e[]), bads) ):
ans2 := ans1 + add(e[1], e in goods2);

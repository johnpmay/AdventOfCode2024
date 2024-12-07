with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-07-input.txt" ):

eqs := map(proc(s) local t:=Split(s,":"); [s2i(t[1]),s2i~(Split(Trim(t[2])," "))] end,
           Split(Trim(input), "\n")): nops(eqs);
check := proc(rs, ns, tot := ns[1], pos := 2)
    if pos > nops(ns) then
        return evalb(rs=tot);
    elif tot > rs then
        return false;
    else
        return thisproc(rs, ns, tot*ns[pos], pos+1)
            or thisproc(rs, ns, tot+ns[pos], pos+1);
    end if;
end proc:
(goods, bads) := selectremove(e->check(e[]), eqs):
ans1 := add(e[1], e in goods);

check2 := proc(rs, ns, tot := ns[1], pos := 2)
    if pos > nops(ns) then
        return evalb(rs=tot);
    elif tot > rs then
        return false;
    else
        return
               thisproc(rs, ns, 10^(ilog10(ns[pos])+1)*tot+ns[pos], pos+1)
	    or thisproc(rs, ns, tot*ns[pos], pos+1)
            or thisproc(rs, ns, tot+ns[pos], pos+1);
    end if;

end proc:
goods2 := CodeTools:-Usage( select(e->check2(e[]), bads) ):
ans2 := ans1 + add(e[1], e in goods2);



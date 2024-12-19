with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-19-input.txt" ):

pats, todo := StringSplit(Trim(input), "\n\n")[]:
pats := sort( StringSplit(pats, ", ") ):
todo := Split(todo):

ismatch := proc(s)
option remember;
local p;
global pats:
   for p in pats do
       if not IsPrefix(p, s) then next; end if;
       if p = s then return true; end if;
       if thisproc(Drop(s,length(p))) then return true; end if;
   end do;
   return false;
end proc:
ans1 := CodeTools:-Usage( add(ifelse( ismatch(p),1,0),p in todo) );

countmatch := proc(s)
option remember;
local p;
global pats:
   if s = "" then return 1; end if;
   return add( ifelse(IsPrefix(p,s),thisproc(Drop(s,length(p))),0), p in pats );
end proc:
ans2 := CodeTools:-Usage( add(countmatch(s), s in todo) );


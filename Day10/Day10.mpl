with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-10-input.txt" ):
splitin := Split(Trim(input),"\n"):
ths := map2([SearchAll], "0", splitin):
ths := [seq(ifelse(ths[i]<>[], map(h->[i,h],ths[i])[], NULL), i=1..nops(ths))]:

ogrid := s2i~(Array(map(Explode,splitin)));
(m,n) := upperbound(ogrid);
grid := Array(0..m+1, 0..n+1, ()->11):
grid[1..m,1..n] := ogrid:

scoreTH := proc(start)
global grid; # option trace;
local dir;
   local  peaks := {};
   grid[start[]];
   if grid[start[]] = 9 then return {start}; end if;
   for dir in [[0,1],[1,0],[-1,0],[0,-1]] do
       if grid[(start+dir)[]] = grid[start[]]+1 then
           peaks := peaks union thisproc(start+dir);
       end if;
   end do;
   return peaks;
end proc:
ans1 := add(nops(t), t in scoreTH~(ths));

rateTH := proc(start)
global grid; # option trace;
local dir;
   local score := 0;
   grid[start[]];
   if grid[start[]] = 9 then return 1; end if;
   for dir in [[0,1],[1,0],[-1,0],[0,-1]] do
       if grid[(start+dir)[]] = grid[start[]]+1 then
           score := score + thisproc(start + dir);
       end if;
   end do;
   return score;
end proc:
ans2 := add(rateTH~(ths));



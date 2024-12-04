with(StringTools):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-04-input.txt" ):
ogrid := Array( subs("."="", map(Explode,Split(Trim(input), "\n"))) ):
r,c := upperbound(ogrid);
grid := Array(-3..r+3, -3..c+3, ()->""):
grid[1..r,1..c] := ogrid:
n,m := upperbound(grid):

count := 0:
for i from 1 to m do for j from 1 to n do
    if grid[i,j]="X" then
       for step in [[1,0],[-1,0],[0,-1],[0,1],[1,1],[-1,-1],[-1,1],[1,-1]] do
           if  cat(seq( grid[([i,j]+~k*step)[]], k=0..3)) = "XMAS"
           then
               count := count + 1;
           end if;
       end do;
    end if;
end do; end do:
ans1 := count;

count := 0:
for i from 1 to m do for j from 1 to n do
    if grid[i,j]="A" then
       if      {grid[i+1,j+1], grid[i-1,j-1]} = {"M","S"}
           and {grid[i-1,j+1], grid[i+1,j-1]} = {"M","S"}
       then
           count := count + 1;
       end if;
    end if;
end do; end do:
ans2 := count;



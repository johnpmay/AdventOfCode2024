with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-15-input.txt" ):

sgrid, moves := op(StringSplit(Trim(input), "\n\n")):
ssgrid := map(Explode, Split(sgrid,"\n")):
m,n := nops(ssgrid), nops(ssgrid[1]);
ogrid := table([seq(seq([i,j]=ssgrid[i,j],i=1..m),j=1..n)]):
moves := subs("^"=[-1,0], "v"=[1,0], "<"=[0,-1], ">"=[0,1], "\n"=NULL, Explode(moves)):

move := proc(loc, dir, actor)
global grid;
    if grid[loc] <> actor then error "not a robot"; end if;
    if grid[loc+dir] = "#" then return false; end if;
    if grid[loc+dir] = "." then grid[loc] := "."; grid[loc+dir] := actor; return true; end if;
    if grid[loc+dir] = "O" then
       if move(loc+dir, dir,"O") then
           return move(_passed);
       else
           return false;
       end if;
   end if;
   error "SNH", loc, dir, actor, grid[loc+dir];
end proc:

grid:=copy(ogrid):
start := lhs(select(e->rhs(e)="@", [entries(grid,'pairs')])[]);
pos := start:
for d in moves do
    if move(pos, d, "@") then pos := pos + d; end if;
end do;

boxlocs := map(lhs, select(e->rhs(e)="O", [entries(grid,'pairs')])):
ans1 := add(100*(b[1]-1)+(b[2]-1), b in boxlocs);

sgrid2 := subs("O"=("[","]"),"."=(".","."),"#"=("#","#"),"@"=("@","."),map(Explode, Split(sgrid,"\n"))):
m,n := nops(sgrid2), nops(sgrid2[1]);
ogrid2 := table([seq(seq([i,j]=sgrid2[i,j],i=1..m),j=1..n)]):
move2 := proc(loc, dir, actor, grid) #option trace;
local bkgrid;
    if   grid[loc] <> actor then error "not a ", actor, loc, dir; end if;
    if   grid[loc+dir] = "#" then return false; 
    elif grid[loc+dir] = "." then grid[loc] := "."; grid[loc+dir] := actor; return true;
    elif grid[loc+dir] = "[" then

        if dir[1]=0 then
           if move2(loc+dir+[0,1],dir,"]",grid) then
               move2(loc+dir,dir,"[",grid);
               return move2(_passed);
           else
               return false;
           end if;
        end if; # L/R fine
        bkgrid := copy( grid );
        if move2(loc+dir,dir,"[",bkgrid) and move2(loc+dir+[0,1],dir,"]",bkgrid) then
            grid := copy(bkgrid); return thisproc(_passed);
        else
            return false;
        end if;
    elif grid[loc+dir] = "]" then
        if dir[1]=0 then
            if move2(loc+dir+[0,-1],dir,"[",grid) then 
                move2(loc+dir,dir,"]",grid);
                return move2(_passed);
            else
                return false;
            end if;
        end if;
        bkgrid := copy( grid );
        if move2(loc+dir,dir,"]",bkgrid) and move2(loc+dir+[0,-1],dir,"[",bkgrid) then
            grid := copy(bkgrid); return thisproc(_passed);
        else
            return false;
        end if;
    end if;
    error "SNH", loc, dir, actor, grid[loc+dir];
end proc:

grid:=copy(ogrid2):
start := lhs(select(e->rhs(e)="@", [entries(grid,'pairs')])[]);
pos := start:
nops(moves);
for d in moves do
    if move2(pos, d, "@", grid) then pos := pos + d; end if;
end do:
boxlocs := map(lhs, select(e->rhs(e)="[", [entries(grid,'pairs')])):
ans2 := add(100*(b[1]-1)+(b[2]-1), b in boxlocs);


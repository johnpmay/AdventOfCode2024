with(StringTools): clamp := (x,y,z)->max(x,min(y,z)):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-06-input.txt" ):
ogrid := Array( subs("."=0, "#"=1, "^"=-1, 
    map(Explode,Split(Trim(input), "\n"))), datatype=integer[1] ):
(m,n) := upperbound(ogrid);

member(-1,ogrid,'gstart'): gstart := [gstart];
rot90 := p -> [Re,Im]((p[1]+p[2]*I)*(-I)):

gdir := [-1, 0]; gpos := gstart:
grid := copy(ogrid): gpath := table():
gpath[gpos] := true: # track the path for part 2
for count from 0 to n^2 do # m=n
    grid[gpos[]] := -1;
    gnew := gpos +~ gdir;
    if map2(clamp, 1, gnew,m) <> gnew then break; end if;
    if grid[gnew[]]=1 then gdir := rot90(gdir);
    else gpos := gnew; gpath[gpos] := true;
    end if;
end do:

ans1 := numboccur(-1, (convert(grid[1..m,1..n],list)));

cands := {indices(gpath,'nolist')} minus {gstart}:
walkpath := proc(newb)
global ogrid, gstart, m, n;
local gdir, gpos, grid, count, gnew, gpath := table();
    gdir := [-1, 0]; gpos := gstart;
    grid := ogrid: # don't copy because we'll be careful
    grid[newb[]] := 1; # set barrier
    for count to n^2 do 
        gnew := gpos +~ gdir;
        if map2(clamp, 1, gnew, m) <> gnew then # off grid
            gpos := gnew;
            break;
        elif grid[gnew[]]=1 then # rotate, don't move yet
            gdir := rot90(gdir);
        else
            gpos := gnew;
            if gpath[gpos, gdir] = true then # in a loop!    
                break;
            end if;
            gpath[gpos, gdir] := true;
        end if;    
    end do:
    grid[newb[]] := 0; # remove barrier
    return evalb( map2(clamp, 1, gpos,m) = gpos );
end proc:

ans2 := CodeTools:-Usage( nops(select(walkpath, cands)) );


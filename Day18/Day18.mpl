#restart;
with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-18-input.txt" ): dim:=[70,70]: tm := 1024:

bytes := map(c->s2i~(Split(c,",")),Split(Trim(input), "\n")):
ogrid := table([seq(c="#",c in bytes[1..tm]), 
    seq([-1,i]="$", i=-1..dim[2]+1),
    seq([dim[1]+1,i]="$", i=-1..dim[2]+1),
    seq([i,dim[2]+1]="$", i=-1..dim[1]+1),
    seq([i,-1]="$", i=-1..dim[1]+1)],
 sparse="."):

start := [0,0];
finish := dim;
grid := copy(ogrid):

DFS := proc(grid, start, finish) #option trace;
local pq, costsofar, path, cost, pos, d, newcost, newpos; 

    costsofar := table(sparse=infinity):

    path := table(sparse={}):
    pq := DEQueue();
    push_back(pq, start):
    costsofar[start] := 0:

    while not empty(pq) do

        pos := pop_back(pq);
        cost := costsofar[pos];
        if pos = finish then
            break;
        end if;
        for d in [[0,1],[1,0],[0,-1],[-1,0]] do
            newpos := pos+d;
            newcost := cost+1;
            if grid[newpos] ="." and newcost < costsofar[newpos] then
                #print("insert", newpos=grid[newpos], newcost);
                push_back(pq, newpos);
                costsofar[newpos] := newcost;        
            end if;
        end do;

    end do:
    return costsofar[finish];
end proc:
ans1 := DFS(grid, start, finish);

searchp := proc(t)
local grid, i,c;

    grid := table([seq(c="#",c in bytes[1..t]), 
                seq([-1,i]="$", i=-1..dim[2]+1),
                seq([dim[1]+1,i]="$", i=-1..dim[2]+1),
                seq([i,dim[2]+1]="$", i=-1..dim[1]+1),
                seq([i,-1]="$", i=-1..dim[1]+1)], sparse="."):

    c := DFS(grid, start, finish);
    if c <> infinity then
        return true;
    else
        return false;
    end if;
end proc:

# Binary Search!
space := [1025, nops(bytes)]:
while space[1]<>space[2] do
    p := space[1]+floor((space[2]-space[1])/2);
    if searchp(p) then
       space := [p+1, space[2]];
    else
       space := [space[1], p];
    end if;
end do:

ans2 := nprintf("%d,%d",bytes[space[1]][]);

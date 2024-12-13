with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-12-input.txt" ):

ll_input := map(Explode,Split(Trim(input), "\n")):
m := nops(ll_input); n := nops(ll_input[1]);
grid := Array(0..m+1, 0..n+1, ()->"."):
ogrid := Array(ll_input):
grid[1..m,1..n] := ogrid:

allstart := {indices(ogrid)}:
allveg := indets(ll_input,string);
alldir := [ [0,1],[1,0],[0,-1],[-1,0] ];

e := 0.1:
Regions := table(sparse = {}):
Tracking:=convert(grid, table):

for start in allstart do
    if Tracking[start[]] = "." then
        next;
    else
        Tracking[start[]] := ".";
    end if;
    nS := DEQueue([start]); # DFS stack
    rg := DEQueue(); # result

    while not empty(nS) do
        curr := pop_back(nS);
        # find boundries - directions that leave the region
        bdd := {seq}(ifelse(grid[curr[]]=grid[(curr+d)[]],NULL,d), d in alldir);

        # find corners
        # first CCW corners
        if   nops(bdd) = 4 then corn := seq(seq([i,j],i in [e,1-e]),j=[e,1-e]);
        elif nops(bdd) = 3 then # two corners
            if not [ 0, 1] in bdd then corn := [e,e],[1-e,0];
            elif not [-1, 0] in bdd then corn := [1-e,e],[1-e,1-e];
            elif not [ 1, 0] in bdd then corn := [e,e],[0,1-e];
            elif not [ 0,-1] in bdd then corn := [e,1-e],[1-e,1-e]; 
            end if;
        elif nops(bdd) <= 1 then corn := NULL;
        elif bdd[1]*~bdd[2] = [0,0] then # one corner
            if   bdd = {[ 1, 0],[ 0, 1]} then corn := [1-e,1-e];
            elif bdd = {[-1, 0],[ 0,-1]} then corn := [e,e];
            elif bdd = {[ 1, 0],[ 0,-1]} then corn := [1-e,e];
            elif bdd = {[-1, 0],[ 0, 1]} then corn := [e,1-e];
            end if;
        else corn := NULL;
        end if;
        # CW corners
        if [0,1] in bdd and not [-1,0] in bdd
                        and grid[(curr+[-1,1])[]] = grid[curr[]]
        then corn ,= [e,1-e];
        end if;
        if [-1,0] in bdd and not [0,-1] in bdd
                        and grid[(curr+[-1,-1])[]] = grid[curr[]]
        then corn ,= [e,e];
        end if;
        if [0,-1] in bdd and not [1,0] in bdd
                        and grid[(curr+[1,-1])[]] = grid[curr[]]
        then corn ,= [1-e,e];
        end if;
        if [1,0] in bdd and not ([0,1] in bdd)
                        and grid[(curr+[1,1])[]] = grid[curr[]]
        then corn ,= [1-e,1-e];
        end if;

        push_back(rg, [curr, bdd, ({seq(curr+c,c in {corn})})]);    
        for dir in alldir do
            if Tracking[(curr+dir)[]] = grid[curr[]] then
                Tracking[(curr+dir)[]] := ".";
                push_back(nS, curr+dir);
            end if;
        end do;
    end do:

    Regions[grid[start[]]] union= {convert(rg, list)};

end do:

cost := table(sparse=0):cost2 := table(sparse=0):
tot := 0:tot2:=0:
for v in allveg do
   for r in Regions[v] do
      perim := add(nops(s[2]), s in r);
      corns := nops([seq(s[3][], s in r)]);
      area := nops(r);
      cost[v] += perim*area;
      cost2[v] += corns*area;
   end do;
   tot += cost[v];
   tot2 += cost2[v];
end do:

ans1 := tot;
ans2 := tot2;


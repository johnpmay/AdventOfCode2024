with(StringTools):
s2i := s->sscanf(s,"%d")[1]:
lclamp := (x,y,z)->map(i->max(x,min(i,z)), y):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-20-input.txt" ):

mazelines := (Split(Trim(input), "\n")):
sgrid := map(Explode, mazelines):
m,n := nops(sgrid), nops(sgrid[1]);
tgrid := table([seq(seq([i,j]=sgrid[i,j],i=2..m-1),j=2..n-1)], sparse="#"):
start := lhs(select(e->rhs(e)="S", [entries(tgrid,'pairs')])[]);
finish := lhs(select(e->rhs(e)="E", [entries(tgrid,'pairs')])[]);
tgrid[start] := ".": tgrid[finish] := ".":
alldirs := [[1,0],[0,1],[-1,0],[0,-1]]:

BFS := proc(grid, start, finish)
local pq, costsofar, path, cost, pos, d, newcost, newpos;

    path := table(sparse=FAIL):
    costsofar := table(sparse=infinity);
    pq := DEQueue();

    push_back(pq, start):
    costsofar[start[]] := 0:
    path[start] := start; 

    while not empty(pq) do

        pos := pop_front(pq);
        cost := costsofar[pos[]];
        if cost = lim then return infinity; end if;
        if pos = finish then
            break;
        end if;
        if grid[pos] = "#" then next; end if;
        for d in [[0,1],[1,0],[0,-1],[-1,0]] do
            newpos := pos+d;
            newcost := cost+1;
            if  newcost < costsofar[newpos[]]
            then
                push_back(pq, newpos);
                costsofar[newpos[]] := newcost;
                path[newpos] := pos;
            end if;
        end do;

    end do:
    return costsofar, path;
end proc:

fcosts, path := BFS(tgrid, finish, start):
nocheat := fcosts[start[]];
scosts, rpath := BFS(tgrid, start, finish):

fcosts := Array(1..n,1..n,(i,j)->ifelse(fcosts[i,j]<>infinity,fcosts[i,j],10^6),datatype=integer[8]):
scosts := Array(1..n,1..n,(i,j)->ifelse(scosts[i,j]<>infinity,scosts[i,j],10^6),datatype=integer[8]):

p := start:
best := p:
while p <> finish do
    best ,= path[p];
    p := path[p];
end do:
best := [best]:
nops(best);

p := finish:
rbest := p:
while p <> start do
    rbest ,= rpath[p];
    p := rpath[p];
end do:
rbest := [rbest]:
nops(rbest);

cpairs := [{ seq( select(e->tgrid[e[2]]="#" and lclamp(2,e[2],m-1)=e[2], map(d->[b,b+d], alldirs, b))[], b in best ) }[]]: nops(cpairs);
singlecheats := select(w->numboccur(".", map(e->tgrid[e], map(`+`, alldirs, w[2]))) > 1, cpairs):

thresh := 100;
saves := CodeTools:-Usage( map(c->nocheat-(fcosts[c[1][]]+1+scosts[c[2][]]), singlecheats) ):
ans1 := add(ifelse( c>=thresh, 1, 0), c in saves);
taxicab :=(a,b)->add(abs~(a-b)):
countcheats := proc(thresh, nocheat, scosts, fcosts, best, rbest)
local c,p, tot := 0:
#i :=0;
for c in rbest do 
if scosts[c[]] > nocheat-thresh then next; end if;
for p in rbest do
#    if i mod 10^5 = 0 then printf("%d, ",i/10^5); end if; i++;
    if p=c or scosts[c[]]+fcosts[p[]] > nocheat-thresh then next; end if;
    if add(abs~(p-c)) > 20 then next; end if;
    if nocheat-scosts[c[]]-add(abs~(p-c))-fcosts[p[]] >= thresh then tot++ end if;
end do; end do:
return tot;
end proc:

ans2 := CodeTools:-Usage( countcheats(thresh, nocheat, scosts, fcosts, best, rbest) );

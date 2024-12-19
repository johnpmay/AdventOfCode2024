with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-16-input.txt" ):

mazelines := (Split(Trim(input), "\n")):
sgrid := map(Explode, mazelines):
m,n := nops(sgrid), nops(sgrid[1]);
tgrid := table([seq(seq([i,j]=sgrid[i,j],i=1..m),j=1..n)]):

start := lhs(select(e->rhs(e)="S", [entries(tgrid,'pairs')])[]);
finish := lhs(select(e->rhs(e)="E", [entries(tgrid,'pairs')])[]);

rot90 := d -> [Re,Im](-I*(d[1]+d[2]*I)):
rot90c := d -> [Re,Im](I*(d[1]+d[2]*I)):

dijkmaze := proc(start, direct, finish) #option trace;
local pq, validd, d, costsofar, path, cost, curr, cpos, cdir, t;
uses priqueue;
global tgrid;
costsofar := table(sparse=infinity):

path := table(sparse={}):
initialize(pq):
insert([0, start,direct], pq):
costsofar[start,direct] := 0:
path[start,direct] := {};

validd := select(d->tgrid[finish-d]<>"#", [[1,0],[0,1],[-1,0],[0,-1]]);

while pq[0] <> 0 do

   curr := extract(pq);
   cost := -1*curr[1];
   cpos := curr[2];

   cdir := curr[3];

   if tgrid[cpos] = "#" then error "should not happen", cpos; end if;

  # print(curr);

   if cpos = finish and andseq(costsofar[finish,d]<>(infinity), d in validd) then
      break;
   end if;


   if tgrid[cpos+cdir] <> "#" then
       if costsofar[cpos+cdir,cdir] >= cost+1 then
           if costsofar[cpos+cdir,cdir] > cost+1 then
               path[cpos+cdir,cdir] := {[cpos, cdir]};
               costsofar[cpos+cdir,cdir] := cost+1;
               insert([-1*(cost+1),cpos+cdir,cdir], pq);
           else
               path[cpos+cdir,cdir] union= {[cpos, cdir]};
           end if;
       end if;
   end if;

   for t in [rot90,rot90c](cdir) do
        if costsofar[cpos,t] >= cost+1000 then
           if costsofar[cpos,t] > cost+1000 then
               path[cpos,t] := {[cpos, cdir]};
               costsofar[cpos,t] := cost+1000;

               insert([-1*(cost+1000), cpos, t], pq);
           else
               path[cpos,t] union= {[cpos, cdir]};
           end if;
       end if;
   end do;

end do:
return [seq([d,costsofar[finish,d]], d in validd)], path;
end proc:

score, pt := CodeTools:-Usage( dijkmaze(start, [0,1], finish) );
ans1 := min(map2(op,2,score));

fins := map(e->[finish,e[1]], select(e->e[2]=ans1, score));
mark := table(sparse=0):
mark[[finish,[]]] := 1:
mark[[start,[]]] := 1:
spots := DEQueue(fins):
while not empty(spots) do
    s := pop_back(spots);
    for t in pt[s[]] do
        if mark[t]=0 then
            mark[t] := 1;
            push_back(spots,t);
        end if;
    end do;
end do:
ans2 := nops(map2(op,1,{indices(mark,nolist)}) );


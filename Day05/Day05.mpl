#restart;
with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-05-input.txt" ):

(rules, updates) := StringSplit(Trim(input), "\n\n")[]:
rules := map(s->map(s2i,Split(s,"|")), Split(rules,"\n")):
updates := map(s->(map(s2i,Split(s,","))), Split(updates, "\n")):

goodups := DEQueue():
obadups := DEQueue():
for u in updates do
    good := true;
    for r in rules do
        if member(r[1],u,'i') and member(r[2],u,'j') then
           if j < i then good := false; push_back(obadups, u); break; end if;
        end if;
     end do;
     if good then push_back(goodups, u) end if;
end do:

ans1 := add(g[ceil(numelems(g)/2)], g in goodups);

badups := DEQueue(convert(obadups,list)):
fixups := DEQueue():
while not empty(badups) do
    u := pop_front(badups);
    for r in rules do
        if member(r[1],u,'i') and member(r[2],u,'j') then
           if j < i then
               # swap u[i] and u[j] and requeue
               push_back(badups, subsop(i=u[j],j=u[i],u));
               next 2; # try again - bluntly fixing r might have broken something else
           end if;
        end if;
     end do;    
     push_back(fixups, u);          
end do:

ans2 := add(g[ceil(numelems(g)/2)], g in fixups);

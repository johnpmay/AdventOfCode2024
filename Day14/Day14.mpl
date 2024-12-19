with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-14-input.txt" ):dim:=[101,103];

robots := map(sscanf,Split(Trim(input), "\n"),"p=%d,%d v=%d,%d"): numrob := nops(robots);
quad[1] := [ceil(dim[1]/2)..dim[1]-1, 0..floor(dim[2]/2)-1]:
quad[2] := [0..floor(dim[1]/2)-1, 0..floor(dim[2]/2)-1]:
quad[3] := [0..floor(dim[1]/2)-1, ceil(dim[2]/2)..dim[2]-1]:
quad[4] := [ceil(dim[1]/2)..dim[1]-1, ceil(dim[2]/2)..dim[2]-1]:
timee := 100:
rpos := table():
grid := table(sparse=0):
for i to nops(robots) do
    r := robots[i]:
    rpos[i] := [r[1]+timee*r[3] mod dim[1],r[2]+timee*r[4] mod dim[2]];
    grid[rpos[i][]] += 1;
end do:
ans1 := mul( add(add(grid[i,j], i=quad[k][1]),j=quad[k][2]), k=1..4);

count := table():
M := Array(1..dim[1],1..dim[2], 0, order=C_order, datatype=float[8]):
bd := max(dim[1],dim[2])-1:
lines := Array(0..bd,0):
hvar := Array(0..bd,0):
vvar := Array(0..bd,0):
for t from 0 to bd do
    M[1..dim[1],1..dim[2]] := 0;
    for i to nops(robots) do
        r := robots[i]:
        M[(r[1]+t*r[3] mod dim[1])+1,(r[2]+t*r[4] mod dim[2])+1] := 1;
    end do:
    vvar[t] := add(Statistics:-Variance(M));
    hvar[t] := add(Statistics:-Variance(M^%T));
end do:


ans2 := NumberTheory:-ChineseRemainder([min[index](hvar),min[index](vvar)], dim);

timee := ans2:
rpos := table():
grid := table(sparse=0):
for i to nops(robots) do
    r := robots[i]:
    rpos[i] := [r[1]+timee*r[3] mod dim[1],r[2]+timee*r[4] mod dim[2]];
    grid[rpos[i][]] += 1;
end do:

for i to dim[2] do
    printf(cat("",seq(ifelse(grid[j-1,i-1]=0,".",grid[j-1,i-1]),j=1..dim[1]),"\n"));
end do;
printf("\n\n");


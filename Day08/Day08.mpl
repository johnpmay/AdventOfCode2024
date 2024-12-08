with(StringTools): lclamp := (x,y,z)->map(i->max(x,min(i,z)), y): 
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-08-input.txt" ):

grid := Array( map(Explode,Split(Trim(input), "\n")) ):
(m,n) := upperbound(grid);
atts := convert(grid,set) minus {"."}:
# build a table Ls of antenna locations
L := remove(p->rhs(p)=".", [indices(convert(grid,table),'pairs')]):
Ls := ListTools:-Classify(rhs, L):
for l in indices(Ls,'nolist') do Ls[l] := map([lhs],Ls[l]); end do:

antinodes := {}:
for a in atts do
    pairs := [ seq([Ls[a][c[1]],Ls[a][c[2]]], c in combinat:-choose(nops(Ls[a]),2)) ];
    for p in pairs do
        delta := p[2] - p[1];
        antinodes := antinodes union { p[1] - delta, p[2] + delta};
    end do;
end do:
ans1 := add(ifelse(lclamp(1,a,m)=a,1,0), a in antinodes);

antinodes := {}:
for a in atts do
    pairs := [ seq([Ls[a][c[1]],Ls[a][c[2]]], c in combinat:-choose(nops(Ls[a]),2)) ];
    for p in pairs do
        delta := p[2] - p[1];
        newas := NULL:
        na := p[1];
        while lclamp(1, na, m) = na do
            newas := newas, na;
            na := na - delta;
        end do;
        na := p[2];
        while lclamp(1, na, m) = na do
            newas := newas, na;
            na := na + delta;
        end do;
        antinodes := antinodes union { newas };
    end do;
end do:
ans2 := nops(antinodes);


with(StringTools):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-13-input.txt" ):
machinesL := map(Split,StringSplit(Trim(input), "\n\n"),"\n"):
machines := map(m->[sscanf(m[1],"Button A: X+%d, Y+%d"),
                    sscanf(m[2],"Button B: X+%d, Y+%d"),
                    sscanf(m[3],"Prize: X=%d, Y=%d")], machinesL):
tokens := table([0=0, 10000000000000=0]):
for p in [0, 10000000000000] do
    for m in machines do
        sol := isolve({m[1][1]*a+m[2][1]*b=m[3][1]+p, m[1][2]*a+m[2][2]*b=m[3][2]+p});
        if sol <> NULL then
        tokens[p] += eval(3*a+b, sol);
        end if;
    end do:
end do:
ans1 := tokens[0];
ans2 := tokens[10000000000000];



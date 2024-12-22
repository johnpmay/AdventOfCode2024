#restart;
with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-22-input.txt" ):

monkeys := s2i~(Split(Trim(input), "\n")):
nM := nops(monkeys);

Bits:-Xor(42, 15); #mix
100000000 mod 16777216; #prune

evo := proc(S)
local tmp, newS;
   tmp := S*64;
   newS := Bits:-Xor(tmp, S) mod 16777216;
   tmp := iquo(newS, 32);
   newS := Bits:-Xor(tmp, newS)  mod 16777216;
   tmp := newS*2048;
   newS :=  Bits:-Xor(tmp, newS)  mod 16777216;
end proc:

pricegrid := Matrix(1..nM, 1..2001, datatype=integer[8]):
for i to nM do
s:=monkeys[i]; pricegrid[i,1] := s mod 10;
    for j to 2000 do
         s:=evo(s);
         res[i] := s;
         pricegrid[i,j+1] := s mod 10;
     end do:
end do:
ans1:=add(entries(res,'nolist'));

Statistics:-Tally(convert(pricegrid,Vector));
changes := pricegrid[1..nM, 2..2001] - pricegrid[1..nM, 1..2000]:
code := "abcdefghijklmnopqrs":
enc := i->code[i+10]:
dec := c->convert(c,ByteArray)[1]-106:
cs := Matrix( 1..nM, 1..2000, (i,j)->code[changes[i,j]+10] ):
cs := [ seq( Join(convert(cs[i],list),""), i=1..nM) ]:

rowprice := proc(fpc, m)
local i:=Search(fpc, cs[m]);
 if i = 0 then return 0;
 else return pricegrid[m, i+4];
 end if;
end proc: 

profit := fpc ->local i; add(rowprice(fpc, i), i=1..nM); 

scanrow := proc(m)
global cs, pricegrid;
local pricetable := table(sparse=0);
    for local i to 2000-3 do
        if pricetable[cs[m][i..i+3]] = 0 then
            pricetable[cs[m][i..i+3]] := pricegrid[m,i+4];
        end if;
    end do;
    return pricetable;
end proc:

rowtables := CodeTools:-Usage( [seq(scanrow(m), m=1..nops(monkeys))] ):

ngrams := { seq(indices(rowtables[i],nolist), i=1..nops(monkeys)) }: nops(ngrams);

findbest := proc()
global rowtables, ngrams;
local best, g, i, tmp, loc;
    best := 0;
    for g in ngrams do
       tmp := add( rowtables[i][g], i=1..nops(monkeys) );
        if tmp > best then best := tmp; loc := g; end if;
    end do:
    return best, loc;
end proc:

ans2 := CodeTools:-Usage(findbest());


#ngrams := { seq(NGrams(cs[i], 4)[], i=1..nM) }: nops(ngrams) < 18^4;
#totals := CodeTools:-Usage( [seq(profit(g), g in ngrams)] ):
#map(dec, Explode(ngrams[ max[index](totals) ]));
#ans2 := max(totals);



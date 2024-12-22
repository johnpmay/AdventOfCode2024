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
res := table():
for m in monkeys do
s:=m; to 2000 do s:=evo(s); end do:
res[m]:=s;
end do:
ans1:=add(entries(res,'nolist'));
pricegrid := Matrix(1..nM, 1..2001, datatype=integer[8]):
for i to nM do
s:=monkeys[i]; pricegrid[i,1] := s mod 10;
for j to 2000 do s:=evo(s); pricegrid[i,j+1] := s mod 10; end do:
end do:
pricegrid;
Statistics:-Tally(convert(pricegrid,Vector));
changes := pricegrid[1..nM, 2..2001] - pricegrid[1..nM, 1..2000];
code := "abcdefghijklmnopqrs";
enc := i->code[i+10];
dec := c->convert(c,ByteArray)[1]-106;
cs := Matrix( 1..nM, 1..2000, (i,j)->code[changes[i,j]+10] );
cs := [ seq( Join(convert(cs[i],list),""), i=1..nM) ]:

rowprice := proc(fpc, m)
local i:=Search(fpc, cs[m]);
 if i = 0 then return 0;
 else return pricegrid[m, i+4];
 end if;
end proc: 

profit := fpc ->local i; add(rowprice(fpc, i), i=1..nM); 

ngrams := { seq(NGrams(cs[i], 4)[], i=1..nM) }: nops(ngrams) < 18^4;
totals := [seq(profit(g), g in ngrams)]:
map(dec, Explode(ngrams[ max[index](totals) ]));
ans2 := max(totals);



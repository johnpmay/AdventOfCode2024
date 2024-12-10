with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-09-input.txt" ):
diskmap:= map(s2i,Explode(Trim(input))):
files := diskmap[[seq(i,i=1..nops(diskmap),2)]]: nops(files);
spaces := diskmap[[seq(i,i=2..nops(diskmap),2)]]: nops(spaces);

layout := DEQueue():
backfillid  := nops(files)-1:
backfillrem := files[-1]:
for i to nops(files) while i <= backfillid do
     push_back(layout, [i-1, files[i]]);
     empty := spaces[i];
     while backfillrem <= empty and backfillid > i do
         push_back(layout, [backfillid,backfillrem]);
         empty -= backfillrem;
         backfillid--; 
         backfillrem := files[backfillid+1];  
     end do;
     if i = backfillid then
         push_back(layout, [backfillid,backfillrem]);
         break;
     elif empty <> 0 then
         push_back(layout, [backfillid,empty]);
         backfillrem -= empty;
     end if;
end do:
val := 0: blk := 0:
for b in layout do b;
	val += b[1] * b[2]*(2*blk+b[2]-1)/2;
	blk += b[2];
end do:
ans1 := val;

empties := table(sparse=NULL):
emsp := table(spaces): moved := NULL:
for i from nops(files) to 1 by -1 do
# find a space to move file i
     for s to i-1 do # must be an empty space to the left         
         if emsp[s] >= files[i] then
             empties[s] ,= [i-1,files[i]];         
             emsp[s] -= files[i];
             moved ,= i;
             break;
         end if;  
     end do;
end do:
for s to nops(spaces) do
    if emsp[s] <> 0 then empties[s] ,= ["e",  emsp[s]]; end if;
end do:
val := 0: blk := 0:
for i to nops(files) do i;
    if not i in [moved] then 
        val += (i-1) * files[i]*(2*blk+files[i]-1)/2;
    end if;
    blk += files[i];
    for b in [empties[i]] do
        if b[1] <> "e" then
            val += b[1] * b[2]*(2*blk+b[2]-1)/2;
        end if;
        blk += b[2];
    end do;
end do:
ans2 := val;



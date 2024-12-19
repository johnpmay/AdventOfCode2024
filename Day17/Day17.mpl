with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2024-17-input.txt" ):

regs, programs := StringSplit(Trim(input),"\n\n")[];
reg :=map(e->s2i(Split(e,":")[2]), Split(regs,"\n"));
program := [parse(Trim(Split(programs, ":")[2]))];

litop := proc(n) return n end proc:

combo := proc(n) 
global register;
    if n<=3 then
       return n; 
    elif n<=6 then
       return register[n-3];
    else
       error;
    end if;
end proc:

opcode[0] := proc(n)
global register, instr;
   instr += 2;
   PRINT("A = %d / %d\n", register[1],  2^combo(n) );
   register[1] := trunc( register[1] / 2^combo(n));
end proc: # 0 adv - division

opcode[1] := proc(n)
global register, instr;
   instr += 2;
   PRINT("B = %d XOR %d\n", register[2], litop(n) );
   register[2] := Bits:-Xor( register[2], litop(n) );
end proc: # 1 bxl - xor

opcode[2] := proc(n)
global register, instr;
    instr += 2;
    PRINT("B = %d => %d\n", combo(n), combo(n) mod 8);
    register[2] := combo(n) mod 8;
end proc: # bst - low 3 bits

opcode[3] := proc(n)
global register, instr;
    if register[1] = 0 then
        PRINT("Don't jump, register A=0\n");
        instr += 2;
    else
        PRINT("Jump to %d, register A=%d\n", litop(n), register[1]);
        instr := litop(n);
    end if;
end proc: # jnz - jump non-zero

opcode[4] := proc(n)
global register, instr;
    instr += 2;
    PRINT("B = %d XOR %d\n", register[2], register[3] );
    register[2] := Bits:-Xor( register[2], register[3] ); # ignore n
end proc: # bxc

opcode[5] := proc(n)
global register, instr, out;
    instr += 2;
    PRINT("OUTPUT %d => %d\n", combo(n), combo(n) mod 8);
    push_back(out, combo(n) mod 8);
end proc: # out

opcode[6] := proc(n)
global register, instr;
    instr += 2;
    PRINT("B = %d / %d\n", register[1],  2^combo(n) );
    register[2] := trunc( register[1] / 2^combo(n));
end proc: # bdv

opcode[7] := proc(n)
global register, instr;
    instr += 2;
    PRINT("C = %d / %d\n", register[1],  2^combo(n) );
    register[3] := trunc( register[1] / 2^combo(n));
end proc: #cdv

opname := ["adv", "bxl", "bst", "jnz", "bxc", "out", "bdv", "cdv"];

runprogram := proc(program, reg)
global instr, register, out;
local endloc;
    register := table(reg);
    instr := 0;
    endloc := nops(program);
    out := DEQueue():

    while instr < endloc do
        opcode[program[instr+1]](program[instr+2]);
    end do:
    instr = endloc;
    return convert(out,list);
end proc:

out := runprogram(program, reg);
ans1 := nprintf(Join(map(convert, out, string),","));

ttt:=time():
dtab := table(sparse={}):
dtab[0] := {0}:
ssize := 1;
for i from 1 to nops(program)/ssize do
    for f from 2^(3*(ssize-1)) to 2^(3*ssize)-1 do
        for g in dtab[i-1] do
            if runprogram(program, [f+2^(3*ssize)*g,0,0])
               = program[-ssize*i..-1]
            then
               dtab[i] union= {f+2^(3*ssize)*g};
               printf("%a ", convert(f+2^(3*ssize)*g, binary));
            end if;
        end do;
    end do;
if nops(dtab[i]) = 0 then printf("\nFailed\n");break; end if;
printf("\n");
end do;

ans2 := min(dtab[nops(program)/ssize]);

#check:
if ans2 = infinity then false
else evalb({0}={op(runprogram(program, [ans2,0,0])-program)});
end if;
(time()-ttt)*Unit(s);


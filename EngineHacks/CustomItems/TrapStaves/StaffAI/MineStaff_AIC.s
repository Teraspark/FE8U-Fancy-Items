.thumb
.set RangeMap, 0x0202E4E4
.set TerrainMap, 0x0202E4DC
.set UnitMap, 0x0202E4D8

.set FindTrapTypeAt, 0x0802E24C

.equ TerrainList, OffsetList + 0x0
@arguments:
	@r0 = stack pocket pointer
	@r1 = active unit pointer
	@r2 = x of tile; r3 = y of tile
	
push 	{r4-r7,lr}
mov 	r4, r1
mov 	r5, r2
mov 	r6, r3
mov 	r7, r0

mov 	r0, r5
mov 	r1, r6
mov 	r2, #0xB
ldr 	r3, =#FindTrapTypeAt
mov 	lr, r3
.short 0xF800
cmp 	r0, #0x0
bne UnSelectable

ldr 	r3, =#TerrainMap
ldr 	r3, [r3]
lsl 	r2, r6, #0x2
add 	r1, r3, r2
ldr 	r1, [r1]
add 	r0, r1, r5
ldrb	r2, [r0]	@get terrain id of selected tile
@compare against list of usable terrain
ldr 	r3, TerrainList
TLoop:
ldrb 	r0, [r3]
cmp 	r0, #0x0
beq UnSelectable
cmp 	r0, r2
bne TReLoop
mov 	r0, #0x1
b End
TReLoop:
add 	r3, #0x1
ldrb 	r0, [r3]
cmp 	r0, #0x0
bne TLoop

UnSelectable:
mov 	r0, #0x0
End:
pop 	{r4-r7}
pop 	{r1}
bx	r1

.ltorg
.align

OffsetList:

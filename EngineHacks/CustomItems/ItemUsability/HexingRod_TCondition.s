.thumb
.include "_TargetSelectionDefinitions.s"

.equ AllegianceCheck, OffsetList + 0x0
.equ HexRodStatus, 0x9

@arguments
	@r0 = unit pointer of target

push {r4-r6, lr}
mov 	r4, r0
ldr 	r0, =SelectedUnit
ldr 	r5, [r0]
mov 	r2, #0xB
ldrb 	r0, [r5, r2]
ldrb 	r1, [r4, r2]
ldr 	r3, AllegianceCheck
_blr 	r3
cmp 	r0, #0x0
bne End
mov 	r0, r4
add 	r0, #0x30
ldrb 	r0, [r0]
mov 	r1, #0xF
and 	r1, r0
cmp 	r1, #0x0
beq 	CanHex
cmp 	r1, #HexRodStatus
bne 	End
CanHex:
mov 	r0, #0x10
ldsb 	r0, [r4,r0]
mov 	r1, #0x11
ldsb 	r1, [r4,r1]
mov 	r2, #0xB
ldsb 	r2, [r4, r2]
mov 	r3, #0x0
_blh 	AddTargetListEntry, r4
End:
pop 	{r4-r6}
pop 	{r3}
bx 	r3
.align
.ltorg
OffsetList:

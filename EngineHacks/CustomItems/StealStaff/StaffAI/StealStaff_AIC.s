.thumb
.include "../../StaffAI/_ItemAIDefinitions.h.s"

@arguments: 
	@r0 = stack pocket pointer
	@r1= active unit
	@r2= target unit

@returns:
	@ r0 = check _ItemAIDefinitions.h.s for return values
	
.equ IsActiveUnitEnemy, OffsetList + 0x0
.equ StealableItemCheck, OffsetList + 0x4
.equ StealableItemCalcLoop, OffsetList + 0x8

push 	{r4-r7, lr}
mov 	r4, r2
mov 	r5, r1
mov 	r6, r0

cmp 	r4, r5
beq CantHit 	@stop unit from targeting itself

@Check allegiance
mov 	r0, r4
ldr 	r3, IsActiveUnitEnemy
_blr 	r3
cmp 	r0, #0x0
beq CantHit

@insert other conditions here

@ check if target has items that can be stolen
mov r0, r5
mov r1, r4
ldr 	r2, StealableItemCalcLoop
ldr 	r3, StealableItemCheck
_blr r3
cmp 	r0, #0x0
beq CantHit
mov r7, r0

mov r5, #0x0
str r5, [r6, #spNewPriority]

ItemLoop:
@check bitmap to see if item in slot can be stolen
mov r0, #0x1
lsl r0, r0, r5
and r0, r7
cmp r0, #0x0
beq ItemLoopInc
lsl r0, r5, #0x1
add r0, #0x1E
ldrh r0, [r4, r0]
_blh Item_GetCost
ldr r1, [r6, #spNewPriority]
cmp r0, r1
ble ItemLoopInc
str r0, [r6, #spNewPriority]
strb r5, [r6, #spNewValue]
ItemLoopInc:
add r5, #0x1
cmp r5, #0x5
blo ItemLoop

ldr r0, [r6, #spNewPriority]
ldr r1, [r6, #spPriority]
cmp r0, r1
ble CantHit

Usable:
mov 	r0, #0x3
b End

CantHit:
mov 	r0, #0x0
End:
pop 	{r4-r7}
pop 	{r1}
bx 	r1
.ltorg
.align
OffsetList:

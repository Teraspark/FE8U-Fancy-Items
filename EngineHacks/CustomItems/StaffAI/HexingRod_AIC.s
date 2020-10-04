.thumb

.set 	HexRodStatus, 0x9
.set 	MinHitRate, 0x0 @minimum accuracy against unit to target them
.include "_ItemAIDefinitions.s"
@parameters: r0 = stack pocket pointer, r1= active unit, r2= target unit
	push 	{r4-r7, lr}
	mov 	r4, r0
	mov 	r5, r1
	mov 	r6, r2
	
	mov 	r0, r6
	_blh 	AIAllegianceCheck
	
	cmp r0, #0x1
	beq CantUse
	
	@make sure hitrate
	mov 	r0, r5
	mov 	r1, r6
	_blh StaffHitRate
	cmp 	r0, #MinHitRate
	ble 	CantUse
	
	@check if unit already has status
	
	@get status
	mov 	r0, #0x30
	ldrb 	r0, [r6, r0]
	
	@check if unit already has a status effect
	mov 	r1, #0xF
	and 	r0, r1
	@mov 	r1, #HexRodStatus
	cmp 	r0, #0x0
	bne CantUse
	
	@compare against current target
	ldr 	r0, [r4, #0x1C]
	mov 	r1, #0x1
	neg 	r1, r1
	cmp 	r0, r1
	beq 	Usable	@skip if there was no previous target
	_blh RamUnitByID
	_blh Unit_GetMaxHP	@get previous target's max hp
	mov 	r7, r0
	mov 	r0, r6
	_blh Unit_GetMaxHP	@get current target's max hp
	mov 	r1, r7
	cmp 	r1, r0
	bgt CantUse
	Usable:
	mov 	r0, #0x1
	b End
	
	CantUse:
	mov 	r0, #0x0
	End:
	pop 	{r4-r7}
	pop 	{r1}
	bx		r1
	@return 0x1 if targetable, 0x0 if not
	.ltorg
	.align

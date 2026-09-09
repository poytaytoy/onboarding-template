	.file	"main.cpp"
	.intel_syntax noprefix
	.text
	.p2align 4
	.type	_ZN12_GLOBAL__N_123apply_reference_stencilERKNS_13ReferenceGridERS0_, @function
_ZN12_GLOBAL__N_123apply_reference_stencilERKNS_13ReferenceGridERS0_:
.LFB2506:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	mov	rax, QWORD PTR [rdi]
	mov	rbx, QWORD PTR 8[rdi]
	lea	rcx, -1[rax]
	mov	QWORD PTR -40[rsp], rbx
	mov	QWORD PTR -32[rsp], rcx
	test	rax, rax
	je	.L2
	mov	r10, QWORD PTR 16[rdi]
	lea	rdi, [rax+rax*2]
	mov	r15, QWORD PTR 16[rsi]
	xor	eax, eax
	lea	rsi, -8[0+rbx*8]
	sal	rdi, 3
	.p2align 4,,10
	.p2align 3
.L3:
	mov	rcx, QWORD PTR [r10+rax]
	mov	rdx, QWORD PTR [r15+rax]
	add	rax, 24
	movsd	xmm0, QWORD PTR [rcx]
	movsd	QWORD PTR [rdx], xmm0
	movsd	xmm0, QWORD PTR [rcx+rsi]
	movsd	QWORD PTR [rdx+rsi], xmm0
	cmp	rax, rdi
	jne	.L3
	cmp	QWORD PTR -40[rsp], 0
	je	.L58
.L9:
	mov	rax, QWORD PTR -32[rsp]
	mov	rbx, QWORD PTR -40[rsp]
	mov	rdi, QWORD PTR [r10]
	mov	rcx, QWORD PTR [r15]
	lea	rax, [rax+rax*2]
	sal	rax, 3
	mov	rsi, QWORD PTR [r10+rax]
	mov	rdx, QWORD PTR [r15+rax]
	cmp	rbx, 2
	jbe	.L26
	lea	rax, 8[rsi]
	lea	r8, 8[rcx]
	cmp	rdx, rax
	lea	r9, 8[rdi]
	setne	al
	cmp	rdx, r8
	setne	r8b
	and	eax, r8d
	cmp	rdx, r9
	setne	r8b
	and	eax, r8d
	lea	r8, 15[rsi]
	sub	r8, rcx
	cmp	r8, 30
	seta	r8b
	test	al, r8b
	je	.L27
	cmp	rcx, r9
	je	.L27
	shr	rbx
	xor	eax, eax
	mov	r8, rbx
	sal	r8, 4
	.p2align 4,,10
	.p2align 3
.L13:
	movupd	xmm4, XMMWORD PTR [rdi+rax]
	movups	XMMWORD PTR [rcx+rax], xmm4
	movupd	xmm5, XMMWORD PTR [rsi+rax]
	movups	XMMWORD PTR [rdx+rax], xmm5
	add	rax, 16
	cmp	r8, rax
	jne	.L13
	mov	rbx, QWORD PTR -40[rsp]
	mov	rax, rbx
	and	rax, -2
	and	ebx, 1
	je	.L17
	movsd	xmm0, QWORD PTR [rdi+rax*8]
	movsd	QWORD PTR [rcx+rax*8], xmm0
	movsd	xmm0, QWORD PTR [rsi+rax*8]
	movsd	QWORD PTR [rdx+rax*8], xmm0
.L17:
	mov	rax, QWORD PTR -40[rsp]
	cmp	QWORD PTR -32[rsp], 1
	lea	r9, -1[rax]
	jbe	.L1
.L6:
	mov	rax, QWORD PTR -40[rsp]
	mov	QWORD PTR -24[rsp], r15
	mov	ebx, 1
	mov	r8d, 24
	movsd	xmm3, QWORD PTR .LC1[rip]
	movsd	xmm2, QWORD PTR .LC3[rip]
	sub	rax, 2
	mov	r11, rax
	movapd	xmm5, xmm3
	movapd	xmm4, xmm2
	mov	rdi, rax
	and	eax, 1
	shr	r11
	or	rdi, 1
	unpcklpd	xmm5, xmm5
	mov	QWORD PTR -16[rsp], rax
	sal	rdi, 3
	sal	r11, 4
	unpcklpd	xmm4, xmm4
	add	r11, 8
	lea	r13, -8[rdi]
	lea	r12, 8[rdi]
	.p2align 4,,10
	.p2align 3
.L8:
	mov	r15, QWORD PTR -24[rsp]
	mov	rdx, r8
	mov	rax, QWORD PTR [r10+r8]
	add	rbx, 1
	mov	rsi, QWORD PTR -24[r10+r8]
	add	r8, 24
	cmp	QWORD PTR -40[rsp], 3
	mov	rcx, QWORD PTR [r10+r8]
	mov	rdx, QWORD PTR [r15+rdx]
	je	.L28
	lea	rbp, 8[rdx]
	lea	r14, 16[rsi]
	cmp	rbp, r14
	lea	r15, 16[rcx]
	setne	r14b
	cmp	rbp, r15
	setne	bpl
	test	r14b, bpl
	je	.L28
	mov	r14, rdx
	mov	ebp, 8
	sub	r14, rax
	cmp	r14, 16
	jbe	.L28
	.p2align 4,,10
	.p2align 3
.L20:
	movupd	xmm7, XMMWORD PTR [rsi+rbp]
	movupd	xmm0, XMMWORD PTR [rcx+rbp]
	movupd	xmm1, XMMWORD PTR [rax+rbp]
	addpd	xmm0, xmm7
	movupd	xmm7, XMMWORD PTR -8[rax+rbp]
	mulpd	xmm1, xmm4
	addpd	xmm0, xmm7
	movupd	xmm7, XMMWORD PTR 8[rax+rbp]
	addpd	xmm0, xmm7
	mulpd	xmm0, xmm5
	addpd	xmm0, xmm1
	movups	XMMWORD PTR [rdx+rbp], xmm0
	add	rbp, 16
	cmp	rbp, r11
	jne	.L20
	cmp	QWORD PTR -16[rsp], 0
	je	.L23
	movsd	xmm0, QWORD PTR [rcx+rdi]
	addsd	xmm0, QWORD PTR [rsi+rdi]
	addsd	xmm0, QWORD PTR [rax+r13]
	addsd	xmm0, QWORD PTR [rax+r12]
	movsd	xmm1, QWORD PTR [rax+rdi]
	mulsd	xmm0, xmm3
	mulsd	xmm1, xmm2
	addsd	xmm0, xmm1
	movsd	QWORD PTR [rdx+rdi], xmm0
.L23:
	mov	rax, QWORD PTR -32[rsp]
	cmp	rbx, rax
	jb	.L8
.L1:
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
.L27:
	.cfi_restore_state
	mov	r8, QWORD PTR -40[rsp]
	xor	eax, eax
	.p2align 4,,10
	.p2align 3
.L18:
	movsd	xmm0, QWORD PTR [rdi+rax*8]
	movsd	QWORD PTR [rcx+rax*8], xmm0
	movsd	xmm0, QWORD PTR [rsi+rax*8]
	movsd	QWORD PTR [rdx+rax*8], xmm0
	add	rax, 1
	cmp	rax, r8
	jb	.L18
	cmp	QWORD PTR -32[rsp], 1
	jbe	.L1
	mov	rax, QWORD PTR -40[rsp]
	lea	r9, -1[rax]
	cmp	r9, 1
	ja	.L6
	jmp	.L1
	.p2align 4,,10
	.p2align 3
.L28:
	mov	ebp, 1
	.p2align 4,,10
	.p2align 3
.L22:
	movsd	xmm1, QWORD PTR [rcx+rbp*8]
	addsd	xmm1, QWORD PTR [rsi+rbp*8]
	movsd	xmm0, QWORD PTR -8[rax+rbp*8]
	movsd	xmm6, QWORD PTR [rax+rbp*8]
	add	rbp, 1
	addsd	xmm0, xmm1
	addsd	xmm0, QWORD PTR [rax+rbp*8]
	mulsd	xmm6, xmm2
	mulsd	xmm0, xmm3
	addsd	xmm0, xmm6
	movsd	QWORD PTR -8[rdx+rbp*8], xmm0
	cmp	rbp, r9
	jne	.L22
	jmp	.L23
.L26:
	mov	r8, rbx
	xor	eax, eax
	jmp	.L18
.L2:
	cmp	QWORD PTR -40[rsp], 0
	je	.L59
	mov	r15, QWORD PTR 16[rsi]
	mov	r10, QWORD PTR 16[rdi]
	jmp	.L9
.L58:
	cmp	QWORD PTR -32[rsp], 1
	jbe	.L1
.L10:
	mov	r9, -1
	jmp	.L6
.L59:
	mov	r10, QWORD PTR 16[rdi]
	mov	r15, QWORD PTR 16[rsi]
	jmp	.L10
	.cfi_endproc
.LFE2506:
	.size	_ZN12_GLOBAL__N_123apply_reference_stencilERKNS_13ReferenceGridERS0_, .-_ZN12_GLOBAL__N_123apply_reference_stencilERKNS_13ReferenceGridERS0_
	.p2align 4
	.type	_Z13apply_stencilRK4GridRS_._omp_fn.0, @function
_Z13apply_stencilRK4GridRS_._omp_fn.0:
.LFB2914:
	.cfi_startproc
	endbr64
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 56
	.cfi_def_cfa_offset 112
	mov	rbx, QWORD PTR [rdi]
	lea	rax, -1[rbx]
	cmp	rax, 1
	jbe	.L60
	mov	r12, rdi
	call	omp_get_num_threads@PLT
	mov	ebp, eax
	call	omp_get_thread_num@PLT
	movsx	rsi, ebp
	xor	edx, edx
	movsx	rcx, eax
	lea	rax, -2[rbx]
	div	rsi
	cmp	rcx, rdx
	jb	.L62
.L71:
	imul	rcx, rax
	add	rdx, rcx
	add	rax, rdx
	cmp	rdx, rax
	jnb	.L60
	mov	r15, QWORD PTR 8[r12]
	lea	rsi, 2[rdx]
	add	rax, 1
	mov	rdi, QWORD PTR 16[r12]
	mov	QWORD PTR 8[rsp], rax
	lea	r13, 1[rdx]
	mov	rbx, QWORD PTR 24[r12]
	imul	rsi, r15
	lea	rax, -1[r15]
	mov	r9, r13
	movsd	xmm3, QWORD PTR .LC1[rip]
	mov	QWORD PTR 16[rsp], rax
	lea	r14, 0[0+r15*8]
	movsd	xmm2, QWORD PTR .LC3[rip]
	imul	r9, r14
	mov	QWORD PTR [rsp], rbx
	movapd	xmm5, xmm3
	mov	rax, rsi
	movapd	xmm4, xmm2
	unpcklpd	xmm5, xmm5
	sub	rax, r15
	unpcklpd	xmm4, xmm4
	lea	r8, 8[rdi+rax*8]
	mov	rax, r15
	add	r9, rbx
	neg	rax
	add	rax, rax
	mov	QWORD PTR 24[rsp], rax
	lea	rax, -2[r15]
	mov	rbx, rax
	mov	r12, rax
	and	eax, 1
	or	rbx, 1
	mov	QWORD PTR 32[rsp], rax
	shr	r12
	mov	QWORD PTR 40[rsp], rbx
	sal	r12, 4
	.p2align 4,,10
	.p2align 3
.L65:
	movsd	xmm0, QWORD PTR -8[r8]
	mov	rax, QWORD PTR 24[rsp]
	add	r13, 1
	lea	rdx, -8[r8]
	cmp	QWORD PTR 16[rsp], 1
	movsd	QWORD PTR [r9], xmm0
	lea	rcx, [rsi+rax]
	movsd	xmm0, QWORD PTR -8[rdi+rsi*8]
	mov	rax, QWORD PTR [rsp]
	movsd	QWORD PTR -8[rax+rsi*8], xmm0
	jbe	.L79
	cmp	r15, 3
	je	.L72
	mov	rbp, r8
	lea	r10, [r14+r8]
	lea	rbx, 8[r8]
	xor	eax, eax
	sub	rbp, r14
	lea	r11, 8[r9]
	.p2align 4,,10
	.p2align 3
.L67:
	movupd	xmm6, XMMWORD PTR 0[rbp+rax]
	movupd	xmm0, XMMWORD PTR [r10+rax]
	movupd	xmm7, XMMWORD PTR [rdx+rax]
	movupd	xmm1, XMMWORD PTR [r8+rax]
	addpd	xmm0, xmm6
	movupd	xmm6, XMMWORD PTR [rbx+rax]
	mulpd	xmm1, xmm4
	addpd	xmm0, xmm7
	addpd	xmm0, xmm6
	mulpd	xmm0, xmm5
	addpd	xmm0, xmm1
	movups	XMMWORD PTR [r11+rax], xmm0
	add	rax, 16
	cmp	rax, r12
	jne	.L67
	cmp	QWORD PTR 32[rsp], 0
	je	.L69
	mov	rax, QWORD PTR 40[rsp]
.L66:
	lea	r8, [rsi+rax]
	add	rcx, rax
	movsd	xmm1, QWORD PTR [rdx+rax*8]
	movsd	xmm0, QWORD PTR [rdi+r8*8]
	addsd	xmm0, QWORD PTR [rdi+rcx*8]
	addsd	xmm0, QWORD PTR -8[rdx+rax*8]
	addsd	xmm0, QWORD PTR 8[rdx+rax*8]
	mulsd	xmm1, xmm2
	mulsd	xmm0, xmm3
	addsd	xmm0, xmm1
	movsd	QWORD PTR [r9+rax*8], xmm0
.L69:
	mov	rax, QWORD PTR 8[rsp]
	add	r9, r14
	add	rsi, r15
	mov	r8, r10
	cmp	r13, rax
	jb	.L65
.L60:
	add	rsp, 56
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L79:
	.cfi_restore_state
	lea	r10, [r8+r14]
	jmp	.L69
	.p2align 4,,10
	.p2align 3
.L72:
	mov	eax, 1
	lea	r10, [r8+r14]
	jmp	.L66
.L62:
	add	rax, 1
	xor	edx, edx
	jmp	.L71
	.cfi_endproc
.LFE2914:
	.size	_Z13apply_stencilRK4GridRS_._omp_fn.0, .-_Z13apply_stencilRK4GridRS_._omp_fn.0
	.section	.text._ZNSt6vectorIdSaIdEED2Ev,"axG",@progbits,_ZNSt6vectorIdSaIdEED5Ev,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIdSaIdEED2Ev
	.type	_ZNSt6vectorIdSaIdEED2Ev, @function
_ZNSt6vectorIdSaIdEED2Ev:
.LFB2563:
	.cfi_startproc
	endbr64
	mov	rax, QWORD PTR [rdi]
	test	rax, rax
	je	.L80
	mov	rsi, QWORD PTR 16[rdi]
	mov	rdi, rax
	sub	rsi, rax
	jmp	_ZdlPvm@PLT
	.p2align 4,,10
	.p2align 3
.L80:
	ret
	.cfi_endproc
.LFE2563:
	.size	_ZNSt6vectorIdSaIdEED2Ev, .-_ZNSt6vectorIdSaIdEED2Ev
	.weak	_ZNSt6vectorIdSaIdEED1Ev
	.set	_ZNSt6vectorIdSaIdEED1Ev,_ZNSt6vectorIdSaIdEED2Ev
	.section	.text._ZNSt6vectorIS_IdSaIdEESaIS1_EED2Ev,"axG",@progbits,_ZNSt6vectorIS_IdSaIdEESaIS1_EED5Ev,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIS_IdSaIdEESaIS1_EED2Ev
	.type	_ZNSt6vectorIS_IdSaIdEESaIS1_EED2Ev, @function
_ZNSt6vectorIS_IdSaIdEESaIS1_EED2Ev:
.LFB2633:
	.cfi_startproc
	endbr64
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	mov	r12, rdi
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	mov	rbp, QWORD PTR 8[rdi]
	mov	rbx, QWORD PTR [rdi]
	cmp	rbp, rbx
	je	.L83
	.p2align 4,,10
	.p2align 3
.L87:
	mov	rdi, QWORD PTR [rbx]
	test	rdi, rdi
	je	.L84
	mov	rsi, QWORD PTR 16[rbx]
	add	rbx, 24
	sub	rsi, rdi
	call	_ZdlPvm@PLT
	cmp	rbp, rbx
	jne	.L87
.L86:
	mov	rbx, QWORD PTR [r12]
.L83:
	test	rbx, rbx
	je	.L82
	mov	rsi, QWORD PTR 16[r12]
	mov	rdi, rbx
	sub	rsi, rbx
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	jmp	_ZdlPvm@PLT
	.p2align 4,,10
	.p2align 3
.L84:
	.cfi_restore_state
	add	rbx, 24
	cmp	rbp, rbx
	jne	.L87
	jmp	.L86
	.p2align 4,,10
	.p2align 3
.L82:
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE2633:
	.size	_ZNSt6vectorIS_IdSaIdEESaIS1_EED2Ev, .-_ZNSt6vectorIS_IdSaIdEESaIS1_EED2Ev
	.weak	_ZNSt6vectorIS_IdSaIdEESaIS1_EED1Ev
	.set	_ZNSt6vectorIS_IdSaIdEESaIS1_EED1Ev,_ZNSt6vectorIS_IdSaIdEESaIS1_EED2Ev
	.section	.text._ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_,"axG",@progbits,_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_,comdat
	.p2align 4
	.weak	_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_
	.type	_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_, @function
_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_:
.LFB2880:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA2880
	endbr64
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 24
	.cfi_def_cfa_offset 80
	mov	QWORD PTR 8[rsp], rdi
	test	rsi, rsi
	je	.L104
	mov	r14, QWORD PTR [rdx]
	mov	r13, rsi
	mov	r12, rdx
	mov	rbp, rdi
	movabs	r15, 9223372036854775800
	jmp	.L99
	.p2align 4,,10
	.p2align 3
.L111:
	cmp	r15, rbx
	jb	.L110
	mov	rdi, rbx
.LEHB0:
	call	_Znwm@PLT
	mov	rcx, rax
.L92:
	movq	xmm0, rcx
	add	rbx, rcx
	punpcklqdq	xmm0, xmm0
	mov	QWORD PTR 16[rbp], rbx
	movups	XMMWORD PTR 0[rbp], xmm0
	mov	r14, QWORD PTR [r12]
	mov	rbx, QWORD PTR 8[r12]
	sub	rbx, r14
	cmp	rbx, 8
	jle	.L95
	mov	rdi, rcx
	mov	rdx, rbx
	mov	rsi, r14
	call	memmove@PLT
	mov	rcx, rax
.L96:
	add	rcx, rbx
	add	rbp, 24
	mov	QWORD PTR -16[rbp], rcx
	sub	r13, 1
	je	.L90
.L99:
	mov	rbx, QWORD PTR 8[r12]
	pxor	xmm0, xmm0
	mov	QWORD PTR 16[rbp], 0
	movups	XMMWORD PTR 0[rbp], xmm0
	sub	rbx, r14
	jne	.L111
	xor	ecx, ecx
	jmp	.L92
	.p2align 4,,10
	.p2align 3
.L104:
	mov	rbp, rdi
.L90:
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	mov	rax, rbp
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L95:
	.cfi_restore_state
	jne	.L96
	movsd	xmm0, QWORD PTR [r14]
	movsd	QWORD PTR [rcx], xmm0
	jmp	.L96
	.p2align 4,,10
	.p2align 3
.L110:
	test	rbx, rbx
	jns	.L94
	call	_ZSt28__throw_bad_array_new_lengthv@PLT
	.p2align 4,,10
	.p2align 3
.L94:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE0:
.L106:
	endbr64
	mov	rdi, rax
.L100:
	call	__cxa_begin_catch@PLT
.L101:
	cmp	QWORD PTR 8[rsp], rbp
	je	.L112
	mov	rbx, QWORD PTR 8[rsp]
	mov	rdi, rbx
	call	_ZNSt6vectorIdSaIdEED1Ev
	mov	rax, rbx
	add	rax, 24
	mov	QWORD PTR 8[rsp], rax
	jmp	.L101
.L112:
.LEHB1:
	call	__cxa_rethrow@PLT
.LEHE1:
.L107:
	endbr64
	mov	rbx, rax
.L103:
	call	__cxa_end_catch@PLT
	mov	rdi, rbx
.LEHB2:
	call	_Unwind_Resume@PLT
.LEHE2:
	.cfi_endproc
.LFE2880:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table._ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_,"aG",@progbits,_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_,comdat
	.align 4
.LLSDA2880:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT2880-.LLSDATTD2880
.LLSDATTD2880:
	.byte	0x1
	.uleb128 .LLSDACSE2880-.LLSDACSB2880
.LLSDACSB2880:
	.uleb128 .LEHB0-.LFB2880
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L106-.LFB2880
	.uleb128 0x1
	.uleb128 .LEHB1-.LFB2880
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L107-.LFB2880
	.uleb128 0
	.uleb128 .LEHB2-.LFB2880
	.uleb128 .LEHE2-.LEHB2
	.uleb128 0
	.uleb128 0
.LLSDACSE2880:
	.byte	0x1
	.byte	0
	.align 4
	.long	0

.LLSDATT2880:
	.section	.text._ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_,"axG",@progbits,_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_,comdat
	.size	_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_, .-_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"cannot create std::vector larger than max_size()"
	.section	.text.unlikely,"ax",@progbits
	.align 2
.LCOLDB5:
	.text
.LHOTB5:
	.align 2
	.p2align 4
	.type	_ZN12_GLOBAL__N_113ReferenceGridC2Emm, @function
_ZN12_GLOBAL__N_113ReferenceGridC2Emm:
.LFB2502:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA2502
	push	r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	push	r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	push	r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	push	rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	push	rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	mov	rbx, rdi
	sub	rsp, 32
	.cfi_def_cfa_offset 80
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR 24[rsp], rax
	xor	eax, eax
	mov	rax, rdx
	mov	QWORD PTR [rdi], rsi
	shr	rax, 60
	mov	QWORD PTR 8[rdi], rdx
	jne	.L139
	pxor	xmm0, xmm0
	mov	r12, rsi
	mov	rbp, rdx
	movups	XMMWORD PTR 8[rsp], xmm0
	test	rdx, rdx
	je	.L140
	sal	rbp, 3
	mov	rdi, rbp
.LEHB3:
	call	_Znwm@PLT
.LEHE3:
	mov	rdx, rbp
	xor	esi, esi
	lea	r13, [rax+rbp]
	mov	rdi, rax
	mov	QWORD PTR [rsp], rax
	mov	r14, rax
	mov	QWORD PTR 16[rsp], r13
	call	memset@PLT
.L117:
	movabs	rax, 384307168202282325
	mov	QWORD PTR 8[rsp], r13
	cmp	rax, r12
	jb	.L141
	pxor	xmm0, xmm0
	lea	r13, [r12+r12*2]
	mov	QWORD PTR 32[rbx], 0
	movups	XMMWORD PTR 16[rbx], xmm0
	sal	r13, 3
	test	r12, r12
	je	.L129
	mov	rdi, r13
.LEHB4:
	call	_Znwm@PLT
.LEHE4:
	mov	rdi, rax
.L120:
	add	r13, rdi
	movq	xmm0, rdi
	mov	rsi, r12
	mov	QWORD PTR 32[rbx], r13
	punpcklqdq	xmm0, xmm0
	mov	r13, rsp
	movups	XMMWORD PTR 16[rbx], xmm0
	mov	rdx, r13
.LEHB5:
	call	_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_
.LEHE5:
	mov	QWORD PTR 24[rbx], rax
	test	r14, r14
	je	.L142
	mov	rax, QWORD PTR 24[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L138
	add	rsp, 32
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	mov	rsi, rbp
	mov	rdi, r14
	pop	rbx
	.cfi_def_cfa_offset 40
	pop	rbp
	.cfi_def_cfa_offset 32
	pop	r12
	.cfi_def_cfa_offset 24
	pop	r13
	.cfi_def_cfa_offset 16
	pop	r14
	.cfi_def_cfa_offset 8
	jmp	_ZdlPvm@PLT
	.p2align 4,,10
	.p2align 3
.L142:
	.cfi_restore_state
	mov	rax, QWORD PTR 24[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L138
	add	rsp, 32
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	pop	rbx
	.cfi_def_cfa_offset 40
	pop	rbp
	.cfi_def_cfa_offset 32
	pop	r12
	.cfi_def_cfa_offset 24
	pop	r13
	.cfi_def_cfa_offset 16
	pop	r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L140:
	.cfi_restore_state
	mov	QWORD PTR [rsp], 0
	xor	r14d, r14d
	xor	r13d, r13d
	mov	QWORD PTR 16[rsp], 0
	jmp	.L117
	.p2align 4,,10
	.p2align 3
.L129:
	xor	edi, edi
	jmp	.L120
.L138:
	call	__stack_chk_fail@PLT
.L141:
	mov	rax, QWORD PTR 24[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L138
	lea	rdi, .LC4[rip]
.LEHB6:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE6:
.L139:
	mov	rax, QWORD PTR 24[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L138
	lea	rdi, .LC4[rip]
.LEHB7:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE7:
.L130:
	endbr64
	mov	rbp, rax
	mov	r13, rsp
	jmp	.L125
.L131:
	endbr64
	mov	rbp, rax
	jmp	.L123
	.section	.gcc_except_table,"a",@progbits
.LLSDA2502:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2502-.LLSDACSB2502
.LLSDACSB2502:
	.uleb128 .LEHB3-.LFB2502
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB4-.LFB2502
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L130-.LFB2502
	.uleb128 0
	.uleb128 .LEHB5-.LFB2502
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L131-.LFB2502
	.uleb128 0
	.uleb128 .LEHB6-.LFB2502
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L130-.LFB2502
	.uleb128 0
	.uleb128 .LEHB7-.LFB2502
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
.LLSDACSE2502:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC2502
	.type	_ZN12_GLOBAL__N_113ReferenceGridC2Emm.cold, @function
_ZN12_GLOBAL__N_113ReferenceGridC2Emm.cold:
.LFSB2502:
.L123:
	.cfi_def_cfa_offset 80
	.cfi_offset 3, -48
	.cfi_offset 6, -40
	.cfi_offset 12, -32
	.cfi_offset 13, -24
	.cfi_offset 14, -16
	mov	rdi, QWORD PTR 16[rbx]
	mov	rsi, QWORD PTR 32[rbx]
	sub	rsi, rdi
	test	rdi, rdi
	je	.L125
	call	_ZdlPvm@PLT
.L125:
	mov	rdi, r13
	call	_ZNSt6vectorIdSaIdEED1Ev
	mov	rax, QWORD PTR 24[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L143
	mov	rdi, rbp
.LEHB8:
	call	_Unwind_Resume@PLT
.LEHE8:
.L143:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE2502:
	.section	.gcc_except_table
.LLSDAC2502:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC2502-.LLSDACSBC2502
.LLSDACSBC2502:
	.uleb128 .LEHB8-.LCOLDB5
	.uleb128 .LEHE8-.LEHB8
	.uleb128 0
	.uleb128 0
.LLSDACSEC2502:
	.section	.text.unlikely
	.text
	.size	_ZN12_GLOBAL__N_113ReferenceGridC2Emm, .-_ZN12_GLOBAL__N_113ReferenceGridC2Emm
	.section	.text.unlikely
	.size	_ZN12_GLOBAL__N_113ReferenceGridC2Emm.cold, .-_ZN12_GLOBAL__N_113ReferenceGridC2Emm.cold
.LCOLDE5:
	.text
.LHOTE5:
	.set	_ZN12_GLOBAL__N_113ReferenceGridC1Emm,_ZN12_GLOBAL__N_113ReferenceGridC2Emm
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC9:
	.string	"--check"
	.section	.rodata.str1.8
	.align 8
.LC19:
	.string	"{\"runtime_ms\": %.3f, \"memory_mb\": %.3f, \"score\": %.3f}\n"
	.section	.rodata.str1.1
.LC20:
	.string	"PASS"
.LC21:
	.string	"[%s] %s  (max_diff=%.3e)\n"
.LC22:
	.string	"FAIL"
	.section	.text.unlikely
.LCOLDB24:
	.section	.text.startup,"ax",@progbits
.LHOTB24:
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB2520:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA2520
	endbr64
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 488
	.cfi_def_cfa_offset 544
	mov	rdx, QWORD PTR fs:40
	mov	QWORD PTR 472[rsp], rdx
	xor	edx, edx
	cmp	edi, 1
	jle	.L145
	mov	rdi, QWORD PTR 8[rsi]
	lea	rsi, .LC9[rip]
	call	strcmp@PLT
	mov	DWORD PTR 116[rsp], eax
	test	eax, eax
	je	.L346
.L145:
	movdqa	xmm0, XMMWORD PTR .LC16[rip]
	mov	edi, 8388608
	movaps	XMMWORD PTR 288[rsp], xmm0
.LEHB9:
	call	_Znwm@PLT
.LEHE9:
	mov	edx, 8388600
	xor	esi, esi
	mov	QWORD PTR [rax], 0x000000000
	lea	rdi, 8[rax]
	mov	rbx, rax
	lea	rbp, 8388608[rax]
	mov	QWORD PTR 304[rsp], rax
	mov	QWORD PTR 320[rsp], rbp
	call	memset@PLT
	movdqa	xmm0, XMMWORD PTR .LC16[rip]
	mov	edi, 8388608
	mov	QWORD PTR 312[rsp], rbp
	movaps	XMMWORD PTR 336[rsp], xmm0
	pxor	xmm0, xmm0
	movups	XMMWORD PTR 360[rsp], xmm0
.LEHB10:
	call	_Znwm@PLT
.LEHE10:
	mov	QWORD PTR [rax], 0x000000000
	lea	rdi, 8[rax]
	xor	esi, esi
	mov	r14, rax
	lea	rbp, 8388608[rax]
	mov	edx, 8388600
	lea	r12, 384[rsp]
	mov	QWORD PTR 352[rsp], rax
	mov	QWORD PTR 368[rsp], rbp
	call	memset@PLT
	mov	edx, 1024
	mov	rdi, r12
	mov	esi, 1024
	mov	QWORD PTR 360[rsp], rbp
.LEHB11:
	call	_ZN12_GLOBAL__N_113ReferenceGridC1Emm
.LEHE11:
	lea	rax, 432[rsp]
	mov	edx, 1024
	mov	esi, 1024
	mov	rdi, rax
	mov	QWORD PTR 64[rsp], rax
.LEHB12:
	call	_ZN12_GLOBAL__N_113ReferenceGridC1Emm
.LEHE12:
	mov	r9, QWORD PTR 400[rsp]
	mov	rcx, rbx
	xor	r8d, r8d
	xor	eax, eax
	movsd	xmm0, QWORD PTR .LC13[rip]
	.p2align 4,,10
	.p2align 3
.L233:
	lea	rdx, -384[r8]
	mov	rsi, QWORD PTR [r9]
	cmp	rdx, 255
	jbe	.L266
	lea	rdx, 8192[rsi]
	cmp	rdx, rcx
	lea	rdx, 8192[rcx]
	jbe	.L285
	cmp	rsi, rdx
	jb	.L267
.L285:
	lea	rdi, 8[rcx]
	mov	QWORD PTR [rcx], 0
	mov	QWORD PTR 8184[rcx], 0
	and	rdi, -8
	sub	rcx, rdi
	add	ecx, 8192
	shr	ecx, 3
	rep stosq
	lea	rdi, 8[rsi]
	mov	QWORD PTR [rsi], 0
	mov	QWORD PTR 8184[rsi], 0
	and	rdi, -8
	sub	rsi, rdi
	lea	ecx, 8192[rsi]
	shr	ecx, 3
	rep stosq
.L242:
	add	r8, 1
	add	r9, 24
	mov	rcx, rdx
	cmp	r8, 1024
	jne	.L233
	call	_ZNSt6chrono3_V212system_clock3nowEv@PLT
	lea	r15, 336[rsp]
	mov	ecx, 200
	lea	r13, 288[rsp]
	mov	rbp, rax
	lea	rax, 256[rsp]
	mov	QWORD PTR 48[rsp], r12
	mov	r12, rcx
	mov	QWORD PTR 24[rsp], rax
	lea	rax, _Z13apply_stencilRK4GridRS_._omp_fn.0[rip]
	mov	QWORD PTR 32[rsp], rax
	mov	rax, r14
	mov	r14, r15
	mov	r15, r13
	mov	QWORD PTR 40[rsp], rbp
	jmp	.L243
.L268:
	mov	rbx, rbp
	mov	r15, rdx
.L243:
	movdqa	xmm6, XMMWORD PTR [r15]
	mov	rsi, rbx
	mov	rdi, rax
	mov	rbp, rax
	movaps	XMMWORD PTR [rsp], xmm6
	mov	rdx, QWORD PTR 8[rsp]
	lea	r13, 0[0+rdx*8]
	mov	rdx, r13
	call	memcpy@PLT
	mov	rax, QWORD PTR [rsp]
	mov	rdx, r13
	sub	rax, 1
	imul	rax, r13
	lea	rdi, 0[rbp+rax]
	lea	rsi, [rbx+rax]
	call	memcpy@PLT
	movdqa	xmm6, XMMWORD PTR [rsp]
	xor	edx, edx
	xor	ecx, ecx
	mov	rsi, QWORD PTR 24[rsp]
	mov	rdi, QWORD PTR 32[rsp]
	mov	QWORD PTR 280[rsp], rbp
	mov	QWORD PTR 272[rsp], rbx
	movaps	XMMWORD PTR 256[rsp], xmm6
	call	GOMP_parallel@PLT
	mov	rdx, r14
	mov	rax, rbx
	mov	r14, r15
	sub	r12, 1
	jne	.L268
	mov	rbp, QWORD PTR 40[rsp]
	mov	r12, QWORD PTR 48[rsp]
	call	_ZNSt6chrono3_V212system_clock3nowEv@PLT
	pxor	xmm0, xmm0
	sub	rax, rbp
	mov	ebp, 200
	cvtsi2sd	xmm0, rax
	divsd	xmm0, QWORD PTR .LC17[rip]
	movsd	QWORD PTR [rsp], xmm0
	call	_ZNSt6chrono3_V212system_clock3nowEv@PLT
	mov	rbx, QWORD PTR 64[rsp]
	mov	r13, rax
	jmp	.L244
.L269:
	mov	r12, rax
.L244:
	mov	rsi, rbx
	mov	rdi, r12
	call	_ZN12_GLOBAL__N_123apply_reference_stencilERKNS_13ReferenceGridERS0_
	mov	rax, rbx
	mov	rbx, r12
	sub	rbp, 1
	jne	.L269
	call	_ZNSt6chrono3_V212system_clock3nowEv@PLT
	movsd	xmm7, QWORD PTR [rsp]
	pxor	xmm0, xmm0
	pxor	xmm2, xmm2
	comisd	xmm7, xmm0
	jbe	.L245
	sub	rax, r13
	pxor	xmm2, xmm2
	cvtsi2sd	xmm2, rax
	divsd	xmm2, QWORD PTR .LC17[rip]
	divsd	xmm2, xmm7
.L245:
	movsd	xmm0, QWORD PTR [rsp]
	mov	edi, 2
	mov	eax, 3
	movsd	xmm1, QWORD PTR .LC18[rip]
	lea	rsi, .LC19[rip]
.LEHB13:
	call	__printf_chk@PLT
.LEHE13:
	lea	rdi, 448[rsp]
	call	_ZNSt6vectorIS_IdSaIdEESaIS1_EED1Ev
	lea	rdi, 400[rsp]
	call	_ZNSt6vectorIS_IdSaIdEESaIS1_EED1Ev
	lea	rdi, 352[rsp]
	call	_ZNSt6vectorIdSaIdEED1Ev
	lea	rdi, 304[rsp]
	call	_ZNSt6vectorIdSaIdEED1Ev
	xor	eax, eax
.L144:
	mov	rdx, QWORD PTR 472[rsp]
	sub	rdx, QWORD PTR fs:40
	jne	.L343
	add	rsp, 488
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
.L266:
	.cfi_restore_state
	mov	rdx, -384
	.p2align 4,,10
	.p2align 3
.L237:
	cmp	rdx, 255
	jbe	.L234
	mov	QWORD PTR 3072[rcx+rdx*8], 0x000000000
	mov	QWORD PTR 3072[rsi+rdx*8], 0x000000000
	add	rdx, 1
	cmp	rdx, 640
	jne	.L237
	add	r8, 1
	add	r9, 24
	add	rcx, 8192
	jmp	.L233
	.p2align 4,,10
	.p2align 3
.L234:
	movsd	QWORD PTR 3072[rcx+rdx*8], xmm0
	movsd	QWORD PTR 3072[rsi+rdx*8], xmm0
	add	rdx, 1
	jmp	.L237
.L267:
	xor	edi, edi
	.p2align 4,,10
	.p2align 3
.L238:
	mov	QWORD PTR [rcx+rdi*8], 0x000000000
	mov	QWORD PTR [rsi+rdi*8], 0x000000000
	add	rdi, 1
	cmp	rdi, 1024
	jne	.L238
	jmp	.L242
.L346:
	lea	rax, _ZN12_GLOBAL__N_1L12kPublicCasesE[rip]
	mov	QWORD PTR 48[rsp], rax
.L231:
	mov	rax, QWORD PTR 48[rsp]
	movdqu	xmm3, XMMWORD PTR [rax]
	mov	ecx, DWORD PTR 24[rax]
	movhlps	xmm5, xmm3
	mov	DWORD PTR 32[rsp], ecx
	mov	rcx, QWORD PTR 16[rax]
	movq	r12, xmm3
	movq	rax, xmm5
	movaps	XMMWORD PTR [rsp], xmm3
	imul	rax, r12
	mov	QWORD PTR 80[rsp], rcx
	movq	QWORD PTR 56[rsp], xmm5
	movaps	XMMWORD PTR 288[rsp], xmm3
	mov	rbp, rax
	movabs	rax, 1152921504606846975
	cmp	rax, rbp
	jb	.L347
	lea	rbx, 0[0+rbp*8]
	mov	QWORD PTR 104[rsp], rbx
	test	rbp, rbp
	je	.L148
	mov	rdi, rbx
.LEHB14:
	call	_Znwm@PLT
.LEHE14:
	movq	xmm0, rax
	lea	r13, [rax+rbx]
	lea	rdi, 8[rax]
	mov	r15, rax
	punpcklqdq	xmm0, xmm0
	mov	QWORD PTR 320[rsp], r13
	mov	QWORD PTR [rax], 0x000000000
	movaps	XMMWORD PTR 304[rsp], xmm0
	cmp	rbp, 1
	je	.L149
	cmp	rdi, r13
	je	.L150
	lea	rdx, -8[rbx]
	xor	esi, esi
	call	memset@PLT
.L150:
	mov	rdi, r13
.L149:
	mov	rbx, QWORD PTR 104[rsp]
	movdqa	xmm4, XMMWORD PTR [rsp]
	mov	QWORD PTR 312[rsp], rdi
	pxor	xmm0, xmm0
	movups	XMMWORD PTR 360[rsp], xmm0
	mov	rdi, rbx
	movaps	XMMWORD PTR 336[rsp], xmm4
.LEHB15:
	call	_Znwm@PLT
.LEHE15:
	movq	xmm0, rax
	lea	r13, [rax+rbx]
	sub	rbp, 1
	mov	QWORD PTR 120[rsp], rax
	punpcklqdq	xmm0, xmm0
	mov	QWORD PTR 368[rsp], r13
	lea	rdi, 8[rax]
	mov	QWORD PTR [rax], 0x000000000
	movaps	XMMWORD PTR 352[rsp], xmm0
	je	.L151
	cmp	r13, rdi
	je	.L152
	lea	rdx, -8[rbx]
	xor	esi, esi
	call	memset@PLT
.L152:
	mov	rdi, r13
.L151:
	movdqa	xmm5, XMMWORD PTR [rsp]
	mov	rcx, QWORD PTR 56[rsp]
	movabs	rax, 1152921504606846975
	mov	QWORD PTR 360[rsp], rdi
	movaps	XMMWORD PTR 384[rsp], xmm5
	cmp	rax, rcx
	jb	.L348
	mov	rax, QWORD PTR 56[rsp]
	pxor	xmm0, xmm0
	movups	XMMWORD PTR 440[rsp], xmm0
	lea	r13, 0[0+rax*8]
	test	rax, rax
	je	.L155
	mov	rdi, r13
.LEHB16:
	call	_Znwm@PLT
.LEHE16:
	lea	rbp, [rax+r13]
	mov	QWORD PTR 432[rsp], rax
	mov	r14, rax
	mov	QWORD PTR 448[rsp], rbp
	cmp	rbp, rax
	je	.L254
	mov	rdx, r13
	xor	esi, esi
	mov	rdi, rax
	call	memset@PLT
.L254:
	movabs	rax, 384307168202282325
	mov	QWORD PTR 440[rsp], rbp
	cmp	rax, r12
	jb	.L349
	imul	rdi, r12, 24
	pxor	xmm0, xmm0
	xor	eax, eax
	mov	QWORD PTR 416[rsp], rax
	movaps	XMMWORD PTR 400[rsp], xmm0
	mov	QWORD PTR 40[rsp], rdi
	test	r12, r12
	je	.L257
.LEHB17:
	call	_Znwm@PLT
.LEHE17:
	mov	rbp, rax
.L159:
	mov	rax, QWORD PTR 40[rsp]
	mov	rsi, r12
	mov	rdi, rbp
	mov	QWORD PTR 400[rsp], rbp
	add	rax, rbp
	mov	QWORD PTR 416[rsp], rax
	lea	rax, 432[rsp]
	mov	rdx, rax
	mov	QWORD PTR 64[rsp], rax
.LEHB18:
	call	_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_
.LEHE18:
	mov	QWORD PTR 88[rsp], rax
	mov	QWORD PTR 408[rsp], rax
	test	r14, r14
	je	.L161
	mov	rsi, r13
	mov	rdi, r14
	call	_ZdlPvm@PLT
.L161:
	movdqa	xmm1, XMMWORD PTR [rsp]
	pxor	xmm0, xmm0
	cmp	QWORD PTR 56[rsp], 0
	movups	XMMWORD PTR 264[rsp], xmm0
	movaps	XMMWORD PTR 432[rsp], xmm1
	je	.L350
	mov	rdi, r13
.LEHB19:
	call	_Znwm@PLT
.LEHE19:
	lea	r14, [rax+r13]
	mov	QWORD PTR 256[rsp], rax
	mov	rbx, rax
	mov	QWORD PTR 272[rsp], r14
	cmp	r14, rax
	je	.L253
	mov	rdx, r13
	xor	esi, esi
	mov	rdi, rax
	call	memset@PLT
.L253:
	pxor	xmm0, xmm0
	xor	eax, eax
	mov	QWORD PTR 264[rsp], r14
	mov	QWORD PTR 464[rsp], rax
	movaps	XMMWORD PTR 448[rsp], xmm0
	test	r12, r12
	je	.L258
	mov	rdi, QWORD PTR 40[rsp]
.LEHB20:
	call	_Znwm@PLT
.LEHE20:
	mov	r14, rax
.L169:
	mov	rax, QWORD PTR 40[rsp]
	lea	rdx, 256[rsp]
	mov	rsi, r12
	mov	rdi, r14
	mov	QWORD PTR 448[rsp], r14
	add	rax, r14
	mov	QWORD PTR 24[rsp], rdx
	mov	QWORD PTR 464[rsp], rax
.LEHB21:
	call	_ZSt18__do_uninit_fill_nIPSt6vectorIdSaIdEEmS2_ET_S4_T0_RKT1_
.LEHE21:
	mov	QWORD PTR 96[rsp], rax
	mov	QWORD PTR 456[rsp], rax
	test	rbx, rbx
	je	.L171
	mov	rsi, r13
	mov	rdi, rbx
	call	_ZdlPvm@PLT
.L171:
	test	r12, r12
	je	.L175
	mov	rdx, r12
	mov	rax, r12
	mov	rbx, QWORD PTR 56[rsp]
	shr	rdx
	shr	rax, 3
	mov	rcx, rdx
	sub	rcx, rax
	add	rax, rdx
	mov	rdx, rbx
	mov	QWORD PTR 176[rsp], rax
	mov	rax, rbx
	shr	rdx, 3
	shr	rax
	mov	QWORD PTR 168[rsp], rcx
	mov	rsi, rax
	sub	rsi, rdx
	mov	QWORD PTR 184[rsp], rsi
	lea	rsi, [rax+rdx]
	mov	QWORD PTR 192[rsp], rsi
	test	rbx, rbx
	je	.L176
	imul	rsi, r12, -8
	lea	rcx, -8[r13]
	xor	r10d, r10d
	xor	r8d, r8d
	mov	QWORD PTR 208[rsp], rcx
	lea	rcx, -1[rbx]
	mov	r11, r15
	mov	rdi, r15
	mov	QWORD PTR 160[rsp], rcx
	mov	rcx, rax
	mov	r9, r14
	mov	r14, r10
	mov	QWORD PTR 144[rsp], rsi
	lea	rsi, [rax+rax]
	xor	eax, eax
	sal	rcx, 4
	mov	QWORD PTR 136[rsp], rax
	mov	rax, rbp
	mov	r10, r12
	mov	QWORD PTR 128[rsp], rbp
	mov	rbp, r8
	mov	r8, rax
	mov	QWORD PTR 200[rsp], rcx
	mov	QWORD PTR 152[rsp], rcx
	mov	rcx, r15
	mov	r15, r13
	mov	r13, rbx
	mov	QWORD PTR [rsp], rsi
	jmp	.L177
.L330:
	mov	eax, DWORD PTR 32[rsp]
	cmp	eax, 1
	je	.L259
	cmp	eax, 2
	je	.L180
	lea	r12, [rdi+r15]
	cmp	rbx, r12
	jnb	.L282
	lea	rax, [rbx+r15]
	cmp	rdi, rax
	jb	.L260
.L282:
	mov	rdx, r15
	xor	esi, esi
	mov	QWORD PTR 248[rsp], r11
	mov	QWORD PTR 240[rsp], r10
	mov	QWORD PTR 232[rsp], r9
	mov	QWORD PTR 224[rsp], r8
	mov	QWORD PTR 216[rsp], rcx
	call	memset@PLT
	mov	rdx, r15
	xor	esi, esi
	mov	rdi, rbx
	call	memset@PLT
	mov	rcx, QWORD PTR 216[rsp]
	mov	r8, QWORD PTR 224[rsp]
	mov	r9, QWORD PTR 232[rsp]
	mov	r10, QWORD PTR 240[rsp]
	mov	r11, QWORD PTR 248[rsp]
.L189:
	mov	rax, QWORD PTR 208[rsp]
	add	rbp, 1
	sub	r14, 8
	mov	rdi, r12
	add	QWORD PTR 128[rsp], 24
	add	QWORD PTR 136[rsp], r13
	add	r11, rax
	cmp	QWORD PTR 144[rsp], r14
	je	.L337
.L177:
	mov	rax, QWORD PTR 128[rsp]
	mov	r12d, DWORD PTR 32[rsp]
	mov	rbx, QWORD PTR [rax]
	test	r12d, r12d
	jne	.L330
	mov	rax, QWORD PTR 168[rsp]
	cmp	rbp, rax
	mov	rax, QWORD PTR 176[rsp]
	setnb	r12b
	cmp	rbp, rax
	setb	sil
	xor	eax, eax
	test	r12b, sil
	jne	.L195
.L326:
	mov	QWORD PTR [rdi+rax*8], 0x000000000
	mov	QWORD PTR [rbx+rax*8], 0x000000000
	add	rax, 1
	cmp	r13, rax
	jne	.L326
.L341:
	lea	r12, [rdi+r15]
	jmp	.L189
.L283:
	mov	QWORD PTR [rdi+rax*8], 0x000000000
	mov	QWORD PTR [rbx+rax*8], 0x000000000
	add	rax, 1
	cmp	rax, r13
	je	.L341
.L195:
	mov	rsi, QWORD PTR 184[rsp]
	cmp	rax, rsi
	jb	.L283
	mov	rsi, QWORD PTR 192[rsp]
	cmp	rax, rsi
	jnb	.L283
	movsd	xmm0, QWORD PTR .LC13[rip]
	movsd	QWORD PTR [rdi+rax*8], xmm0
	movsd	QWORD PTR [rbx+rax*8], xmm0
	add	rax, 1
	cmp	r13, rax
	jne	.L195
	jmp	.L341
.L337:
	mov	r15, rcx
	mov	rbp, r8
	mov	r14, r9
	mov	r12, r10
.L176:
	cmp	QWORD PTR 80[rsp], 0
	lea	r11, 288[rsp]
	lea	r8, 384[rsp]
	je	.L204
.L255:
	lea	rbx, 384[rsp]
	mov	r8, QWORD PTR 64[rsp]
	xor	r10d, r10d
	lea	r11, 336[rsp]
	mov	QWORD PTR [rsp], rbx
	lea	r9, 288[rsp]
	lea	rbx, _Z13apply_stencilRK4GridRS_._omp_fn.0[rip]
	mov	r13, QWORD PTR 304[rsp]
	mov	QWORD PTR 128[rsp], r15
	mov	rax, QWORD PTR 352[rsp]
	mov	r15, r11
	mov	QWORD PTR 136[rsp], rbp
	mov	rbp, r10
	mov	QWORD PTR 144[rsp], r14
	mov	r14, r9
	mov	QWORD PTR 152[rsp], r12
	mov	r12, r8
	mov	QWORD PTR 32[rsp], rbx
	jmp	.L203
.L263:
	mov	rdx, QWORD PTR [rsp]
	mov	QWORD PTR [rsp], r12
	mov	r13, rbx
	mov	r12, rdx
	mov	rdx, r14
	mov	r14, r15
	mov	r15, rdx
.L203:
	movdqa	xmm1, XMMWORD PTR [r14]
	mov	rsi, r13
	mov	rdi, rax
	mov	rbx, rax
	add	rbp, 1
	movaps	XMMWORD PTR 64[rsp], xmm1
	mov	rdx, QWORD PTR 72[rsp]
	sal	rdx, 3
	mov	QWORD PTR 160[rsp], rdx
	call	memcpy@PLT
	mov	rax, QWORD PTR 64[rsp]
	mov	rdx, QWORD PTR 160[rsp]
	sub	rax, 1
	imul	rax, rdx
	lea	rdi, [rbx+rax]
	lea	rsi, 0[r13+rax]
	call	memcpy@PLT
	movdqa	xmm1, XMMWORD PTR 64[rsp]
	xor	ecx, ecx
	xor	edx, edx
	mov	rsi, QWORD PTR 24[rsp]
	mov	rdi, QWORD PTR 32[rsp]
	mov	QWORD PTR 280[rsp], rbx
	movaps	XMMWORD PTR 256[rsp], xmm1
	mov	QWORD PTR 272[rsp], r13
	call	GOMP_parallel@PLT
	mov	rdi, QWORD PTR [rsp]
	mov	rsi, r12
	call	_ZN12_GLOBAL__N_123apply_reference_stencilERKNS_13ReferenceGridERS0_
	mov	rax, r13
	cmp	QWORD PTR 80[rsp], rbp
	jne	.L263
	mov	r8, r12
	mov	r12, QWORD PTR 152[rsp]
	mov	r11, r15
	mov	rbp, QWORD PTR 136[rsp]
	mov	r15, QWORD PTR 128[rsp]
	mov	r14, QWORD PTR 144[rsp]
	test	r12, r12
	je	.L205
.L204:
	mov	QWORD PTR [rsp], 0x000000000
	mov	rsi, QWORD PTR 56[rsp]
	xor	ecx, ecx
	xor	edx, edx
.L209:
	test	rsi, rsi
	je	.L212
	mov	rdi, QWORD PTR 8[r11]
	mov	rax, QWORD PTR 16[r8]
	imul	rdi, rdx
	mov	r9, QWORD PTR [rax+rcx]
	mov	rax, QWORD PTR 16[r11]
	lea	rdi, [rax+rdi*8]
	xor	eax, eax
.L208:
	movsd	xmm0, QWORD PTR [rdi+rax*8]
	subsd	xmm0, QWORD PTR [r9+rax*8]
	add	rax, 1
	andpd	xmm0, XMMWORD PTR .LC14[rip]
	maxsd	xmm0, QWORD PTR [rsp]
	movsd	QWORD PTR [rsp], xmm0
	cmp	rax, rsi
	jne	.L208
.L212:
	add	rdx, 1
	add	rcx, 24
	cmp	rdx, r12
	jne	.L209
.L210:
	mov	rbx, r14
	cmp	QWORD PTR 96[rsp], r14
	je	.L218
.L213:
	mov	rdi, QWORD PTR [rbx]
	test	rdi, rdi
	je	.L216
	mov	rsi, QWORD PTR 16[rbx]
	add	rbx, 24
	sub	rsi, rdi
	call	_ZdlPvm@PLT
	mov	rax, QWORD PTR 96[rsp]
	cmp	rbx, rax
	jne	.L213
.L218:
	test	r14, r14
	je	.L215
	mov	rsi, QWORD PTR 40[rsp]
	mov	rdi, r14
	call	_ZdlPvm@PLT
.L215:
	mov	rbx, rbp
	cmp	QWORD PTR 88[rsp], rbp
	je	.L224
.L219:
	mov	rdi, QWORD PTR [rbx]
	test	rdi, rdi
	je	.L222
	mov	rsi, QWORD PTR 16[rbx]
	add	rbx, 24
	sub	rsi, rdi
	call	_ZdlPvm@PLT
	mov	rax, QWORD PTR 88[rsp]
	cmp	rbx, rax
	jne	.L219
.L224:
	test	rbp, rbp
	je	.L221
	mov	rsi, QWORD PTR 40[rsp]
	mov	rdi, rbp
	call	_ZdlPvm@PLT
.L221:
	mov	rax, QWORD PTR 120[rsp]
	test	rax, rax
	je	.L225
	mov	rsi, QWORD PTR 104[rsp]
	mov	rdi, rax
	call	_ZdlPvm@PLT
.L225:
	test	r15, r15
	je	.L226
	mov	rsi, QWORD PTR 104[rsp]
	mov	rdi, r15
	call	_ZdlPvm@PLT
.L226:
	movsd	xmm0, QWORD PTR .LC15[rip]
	comisd	xmm0, QWORD PTR [rsp]
	mov	rax, QWORD PTR 48[rsp]
	mov	rdi, QWORD PTR stderr[rip]
	mov	r8, QWORD PTR 32[rax]
	jnb	.L227
	movsd	xmm0, QWORD PTR [rsp]
	mov	esi, 2
	mov	eax, 1
	lea	rcx, .LC22[rip]
	lea	rdx, .LC21[rip]
.LEHB22:
	call	__fprintf_chk@PLT
	add	DWORD PTR 116[rsp], 1
.L252:
	add	QWORD PTR 48[rsp], 40
	mov	rcx, QWORD PTR 48[rsp]
	lea	rax, _ZN12_GLOBAL__N_1L12kPublicCasesE[rip+200]
	cmp	rcx, rax
	jne	.L231
	xor	eax, eax
	cmp	DWORD PTR 116[rsp], 0
	setne	al
	jmp	.L144
	.p2align 4,,10
	.p2align 3
.L216:
	add	rbx, 24
	cmp	QWORD PTR 96[rsp], rbx
	jne	.L213
	jmp	.L218
.L180:
	cmp	QWORD PTR 160[rsp], 2
	jbe	.L351
	lea	rsi, 8[rdi]
	mov	rax, rbp
	cmp	rbx, rsi
	jne	.L352
.L186:
	add	rbx, r14
	lea	rsi, 0[r13+rbp]
.L185:
	test	al, 1
	je	.L192
	mov	QWORD PTR [r11+rax*8], 0x000000000
	mov	QWORD PTR [rbx+rax*8], 0x000000000
	add	rax, 1
	cmp	rsi, rax
	jne	.L185
	jmp	.L341
	.p2align 4,,10
	.p2align 3
.L192:
	mov	rdx, QWORD PTR .LC7[rip]
	mov	QWORD PTR [r11+rax*8], rdx
	mov	QWORD PTR [rbx+rax*8], rdx
	add	rax, 1
	cmp	rsi, rax
	jne	.L185
	jmp	.L341
.L352:
	movsd	xmm4, QWORD PTR .LC7[rip]
	movq	xmm5, rbp
	xor	eax, eax
	pxor	xmm3, xmm3
	movdqa	xmm2, XMMWORD PTR .LC6[rip]
	punpcklqdq	xmm5, xmm5
	unpcklpd	xmm4, xmm4
.L187:
	movdqa	xmm0, xmm2
	paddq	xmm2, XMMWORD PTR .LC10[rip]
	paddq	xmm0, xmm5
	pand	xmm0, XMMWORD PTR .LC11[rip]
	pcmpeqd	xmm0, xmm3
	pshufd	xmm1, xmm0, 177
	pand	xmm0, xmm1
	andpd	xmm0, xmm4
	movups	XMMWORD PTR [rdi+rax], xmm0
	movups	XMMWORD PTR [rbx+rax], xmm0
	add	rax, 16
	cmp	QWORD PTR 200[rsp], rax
	jne	.L187
	mov	rax, QWORD PTR [rsp]
	cmp	r13, rax
	je	.L341
	add	rax, rbp
	movsd	xmm0, QWORD PTR .LC7[rip]
	test	al, 1
	je	.L191
	pxor	xmm0, xmm0
.L191:
	mov	rax, QWORD PTR [rsp]
	mov	rsi, QWORD PTR 136[rsp]
	lea	r12, [rdi+r15]
	add	rax, rsi
	movsd	QWORD PTR [rcx+rax*8], xmm0
	mov	rax, QWORD PTR 152[rsp]
	movsd	QWORD PTR [rbx+rax], xmm0
	jmp	.L189
.L259:
	mov	rax, rbp
	add	rbx, r14
	lea	rsi, 0[r13+rbp]
.L179:
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, rax
	movsd	QWORD PTR [r11+rax*8], xmm0
	movsd	QWORD PTR [rbx+rax*8], xmm0
	add	rax, 1
	cmp	rsi, rax
	jne	.L179
	jmp	.L341
.L222:
	add	rbx, 24
	cmp	QWORD PTR 88[rsp], rbx
	jne	.L219
	jmp	.L224
.L148:
	movdqa	xmm5, XMMWORD PTR [rsp]
	xor	edx, edx
	xor	eax, eax
	pxor	xmm0, xmm0
	mov	QWORD PTR 320[rsp], rax
	xor	r15d, r15d
	xor	edi, edi
	mov	QWORD PTR 352[rsp], rdx
	mov	QWORD PTR 368[rsp], rdx
	mov	QWORD PTR 120[rsp], rdx
	movaps	XMMWORD PTR 304[rsp], xmm0
	movaps	XMMWORD PTR 336[rsp], xmm5
	jmp	.L151
.L155:
	xor	ecx, ecx
	xor	r14d, r14d
	xor	ebp, ebp
	mov	QWORD PTR 432[rsp], rcx
	mov	QWORD PTR 448[rsp], rcx
	jmp	.L254
.L227:
	movsd	xmm0, QWORD PTR [rsp]
	mov	esi, 2
	mov	eax, 1
	lea	rcx, .LC20[rip]
	lea	rdx, .LC21[rip]
	call	__fprintf_chk@PLT
	jmp	.L252
.L351:
	mov	rax, rbp
	jmp	.L186
.L260:
	xor	eax, eax
.L181:
	mov	QWORD PTR [rdi+rax*8], 0x000000000
	mov	QWORD PTR [rbx+rax*8], 0x000000000
	add	rax, 1
	cmp	rax, r13
	jne	.L181
	jmp	.L189
.L258:
	xor	r14d, r14d
	jmp	.L169
.L350:
	xor	esi, esi
	xor	ebx, ebx
	xor	r14d, r14d
	mov	QWORD PTR 256[rsp], rsi
	mov	QWORD PTR 272[rsp], rsi
	jmp	.L253
.L257:
	xor	ebp, ebp
	jmp	.L159
.L347:
	mov	rax, QWORD PTR 472[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L343
	lea	rdi, .LC4[rip]
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE22:
.L343:
	call	__stack_chk_fail@PLT
.L348:
	mov	rax, QWORD PTR 472[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L343
	lea	rdi, .LC4[rip]
.LEHB23:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE23:
.L349:
	mov	rax, QWORD PTR 472[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L343
	lea	rdi, .LC4[rip]
.LEHB24:
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE24:
.L175:
	cmp	QWORD PTR 80[rsp], 0
	jne	.L255
.L205:
	mov	QWORD PTR [rsp], 0x000000000
	jmp	.L210
.L271:
	endbr64
	mov	rbx, rax
	jmp	.L250
.L272:
	endbr64
	mov	rbx, rax
	jmp	.L167
.L273:
	endbr64
	mov	rbx, rax
	jmp	.L178
.L278:
	endbr64
	mov	rbx, rax
	jmp	.L250
.L279:
	endbr64
	mov	rbx, rax
	jmp	.L249
.L281:
	endbr64
	mov	rbx, rax
	jmp	.L247
.L280:
	endbr64
	mov	rbx, rax
	jmp	.L248
.L274:
	endbr64
	mov	rbx, rax
	lea	rax, 432[rsp]
	mov	QWORD PTR 64[rsp], rax
	jmp	.L164
.L275:
	endbr64
	mov	rbx, rax
	jmp	.L162
.L276:
	endbr64
	mov	rbx, rax
	lea	rax, 256[rsp]
	mov	QWORD PTR 24[rsp], rax
	jmp	.L174
.L277:
	endbr64
	mov	rbx, rax
	jmp	.L172
	.section	.gcc_except_table
.LLSDA2520:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2520-.LLSDACSB2520
.LLSDACSB2520:
	.uleb128 .LEHB9-.LFB2520
	.uleb128 .LEHE9-.LEHB9
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB10-.LFB2520
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L278-.LFB2520
	.uleb128 0
	.uleb128 .LEHB11-.LFB2520
	.uleb128 .LEHE11-.LEHB11
	.uleb128 .L279-.LFB2520
	.uleb128 0
	.uleb128 .LEHB12-.LFB2520
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L280-.LFB2520
	.uleb128 0
	.uleb128 .LEHB13-.LFB2520
	.uleb128 .LEHE13-.LEHB13
	.uleb128 .L281-.LFB2520
	.uleb128 0
	.uleb128 .LEHB14-.LFB2520
	.uleb128 .LEHE14-.LEHB14
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB15-.LFB2520
	.uleb128 .LEHE15-.LEHB15
	.uleb128 .L271-.LFB2520
	.uleb128 0
	.uleb128 .LEHB16-.LFB2520
	.uleb128 .LEHE16-.LEHB16
	.uleb128 .L272-.LFB2520
	.uleb128 0
	.uleb128 .LEHB17-.LFB2520
	.uleb128 .LEHE17-.LEHB17
	.uleb128 .L274-.LFB2520
	.uleb128 0
	.uleb128 .LEHB18-.LFB2520
	.uleb128 .LEHE18-.LEHB18
	.uleb128 .L275-.LFB2520
	.uleb128 0
	.uleb128 .LEHB19-.LFB2520
	.uleb128 .LEHE19-.LEHB19
	.uleb128 .L273-.LFB2520
	.uleb128 0
	.uleb128 .LEHB20-.LFB2520
	.uleb128 .LEHE20-.LEHB20
	.uleb128 .L276-.LFB2520
	.uleb128 0
	.uleb128 .LEHB21-.LFB2520
	.uleb128 .LEHE21-.LEHB21
	.uleb128 .L277-.LFB2520
	.uleb128 0
	.uleb128 .LEHB22-.LFB2520
	.uleb128 .LEHE22-.LEHB22
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB23-.LFB2520
	.uleb128 .LEHE23-.LEHB23
	.uleb128 .L272-.LFB2520
	.uleb128 0
	.uleb128 .LEHB24-.LFB2520
	.uleb128 .LEHE24-.LEHB24
	.uleb128 .L274-.LFB2520
	.uleb128 0
.LLSDACSE2520:
	.section	.text.startup
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC2520
	.type	main.cold, @function
main.cold:
.LFSB2520:
.L247:
	.cfi_def_cfa_offset 544
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	lea	rdi, 448[rsp]
	call	_ZNSt6vectorIS_IdSaIdEESaIS1_EED1Ev
.L248:
	lea	rdi, 400[rsp]
	call	_ZNSt6vectorIS_IdSaIdEESaIS1_EED1Ev
.L249:
	lea	rdi, 352[rsp]
	call	_ZNSt6vectorIdSaIdEED1Ev
.L250:
	lea	rdi, 304[rsp]
	call	_ZNSt6vectorIdSaIdEED1Ev
	mov	rax, QWORD PTR 472[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L353
	mov	rdi, rbx
.LEHB25:
	call	_Unwind_Resume@PLT
.LEHE25:
.L162:
	test	rbp, rbp
	je	.L164
	mov	rsi, QWORD PTR 40[rsp]
	mov	rdi, rbp
	call	_ZdlPvm@PLT
.L164:
	mov	rdi, QWORD PTR 64[rsp]
	call	_ZNSt6vectorIdSaIdEED1Ev
.L167:
	lea	rdi, 352[rsp]
	call	_ZNSt6vectorIdSaIdEED1Ev
	jmp	.L250
.L172:
	test	r14, r14
	je	.L174
	mov	rsi, QWORD PTR 40[rsp]
	mov	rdi, r14
	call	_ZdlPvm@PLT
.L174:
	mov	rdi, QWORD PTR 24[rsp]
	call	_ZNSt6vectorIdSaIdEED1Ev
.L178:
	lea	rdi, 400[rsp]
	call	_ZNSt6vectorIS_IdSaIdEESaIS1_EED1Ev
	jmp	.L167
.L353:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE2520:
	.section	.gcc_except_table
.LLSDAC2520:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC2520-.LLSDACSBC2520
.LLSDACSBC2520:
	.uleb128 .LEHB25-.LCOLDB24
	.uleb128 .LEHE25-.LEHB25
	.uleb128 0
	.uleb128 0
.LLSDACSEC2520:
	.section	.text.unlikely
	.section	.text.startup
	.size	main, .-main
	.section	.text.unlikely
	.size	main.cold, .-main.cold
.LCOLDE24:
	.section	.text.startup
.LHOTE24:
	.section	.rodata.str1.1
.LC25:
	.string	"public/square-32"
.LC26:
	.string	"public/nonsquare-48x80"
.LC27:
	.string	"public/checker-64"
.LC28:
	.string	"public/one-step-50"
	.section	.rodata.str1.8
	.align 8
.LC29:
	.string	"public/nonsquare-boundary-80x50"
	.section	.data.rel.ro.local,"aw"
	.align 32
	.type	_ZN12_GLOBAL__N_1L12kPublicCasesE, @object
	.size	_ZN12_GLOBAL__N_1L12kPublicCasesE, 200
_ZN12_GLOBAL__N_1L12kPublicCasesE:
	.quad	32
	.quad	32
	.quad	20
	.long	0
	.zero	4
	.quad	.LC25
	.quad	48
	.quad	80
	.quad	40
	.long	1
	.zero	4
	.quad	.LC26
	.quad	64
	.quad	64
	.quad	30
	.long	2
	.zero	4
	.quad	.LC27
	.quad	50
	.quad	50
	.quad	1
	.long	0
	.zero	4
	.quad	.LC28
	.quad	80
	.quad	50
	.quad	10
	.long	1
	.zero	4
	.quad	.LC29
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	0
	.long	1069547520
	.align 8
.LC3:
	.long	0
	.long	1071644672
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC6:
	.quad	0
	.quad	1
	.section	.rodata.cst8
	.align 8
.LC7:
	.long	0
	.long	1072693248
	.section	.rodata.cst16
	.align 16
.LC10:
	.quad	2
	.quad	2
	.align 16
.LC11:
	.quad	1
	.quad	1
	.section	.rodata.cst8
	.align 8
.LC13:
	.long	0
	.long	1079574528
	.section	.rodata.cst16
	.align 16
.LC14:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC15:
	.long	-1598689907
	.long	1051772663
	.section	.rodata.cst16
	.align 16
.LC16:
	.quad	1024
	.quad	1024
	.section	.rodata.cst8
	.align 8
.LC17:
	.long	0
	.long	1093567616
	.align 8
.LC18:
	.long	-1598689907
	.long	1076938487
	.hidden	DW.ref.__gxx_personality_v0
	.weak	DW.ref.__gxx_personality_v0
	.section	.data.rel.local.DW.ref.__gxx_personality_v0,"awG",@progbits,DW.ref.__gxx_personality_v0,comdat
	.align 8
	.type	DW.ref.__gxx_personality_v0, @object
	.size	DW.ref.__gxx_personality_v0, 8
DW.ref.__gxx_personality_v0:
	.quad	__gxx_personality_v0
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:

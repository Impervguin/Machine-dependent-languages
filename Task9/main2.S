	.file	"asmmatrix.c"
	.text
	.globl	AsmMatrixMul
	.type	AsmMatrixMul, @function
AsmMatrixMul:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$120, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%rdx, -88(%rbp)
	movq	%rcx, -96(%rbp)
	movq	%r8, -104(%rbp)
	movq	%r9, -112(%rbp)
	movq	32(%rbp), %rax
	movq	%rax, -120(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-80(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -48(%rbp)
	movq	-104(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -40(%rbp)
	movq	24(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -32(%rbp)
	movq	-72(%rbp), %rax
	cmpq	%rax, 16(%rbp)
	jne	.L6
	movq	-104(%rbp), %rax
	cmpq	%rax, 24(%rbp)
	jne	.L6
	movq	-80(%rbp), %rdx
	movq	-96(%rbp), %rax
	cmpq	%rax, %rdx
	jne	.L6
	movl	$0, -60(%rbp)
	movl	$0, -56(%rbp)
	movl	$0, -52(%rbp)
	movq	-88(%rbp), %rax
	movq	-112(%rbp), %rdx
	movq	-120(%rbp), %rcx
	movq	%rax, %rbx
	movq	%rdx, %rsi
	movq	%rcx, %rdi
#APP
# 12 "asmmatrix.c" 1
	mov -72(%rbp), %rcx 
	rowcycle:
	    pushq %rcx
	    movq -104(%rbp), %rcx
	    mov $0, -56(%rbp)
	    colcycle:
	        xorq %rax, %rax
	        pushq %rcx
	        movq -80(%rbp), %rcx
	        push -60(%rbp)
	        push -56(%rbp)
	        sumcycle:
	            pushq %rax
	            mov -60(%rbp), %eax
	            mov (%rbx, %rax, 0x4), %edx
	            mov -56(%rbp), %eax
	            mov (%rsi, %rax, 0x4), %eax
	            imul %eax, %edx
	            popq %rax
	            add %edx, %eax
	            inc -60(%rbp)
	            pushq %rax
	            mov -104(%rbp), %eax
	            add %eax, -56(%rbp)
	            popq %rax
	            loop sumcycle
	        mov -52(%rbp), %ecx
	        mov %eax, (%rdi, %rcx, 0x4)
	        pop -56(%rbp)
	        pop -60(%rbp)
	        inc -52(%rbp)
	        inc -56(%rbp)
	        popq %rcx
	        loop colcycle
	    mov -80(%rbp), %eax
	    add %eax, -60(%rbp)
	    popq %rcx
	    loop rowcycle
	
# 0 "" 2
#NO_APP
	jmp	.L1
.L6:
	nop
.L1:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L5
	call	__stack_chk_fail@PLT
.L5:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	AsmMatrixMul, .-AsmMatrixMul
	.globl	AvxMatrixMul
	.type	AvxMatrixMul, @function
AvxMatrixMul:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$120, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%rdx, -88(%rbp)
	movq	%rcx, -96(%rbp)
	movq	%r8, -104(%rbp)
	movq	%r9, -112(%rbp)
	movq	32(%rbp), %rax
	movq	%rax, -120(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-80(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -48(%rbp)
	movq	-104(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -40(%rbp)
	movq	24(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -32(%rbp)
	movl	$0, -60(%rbp)
	movl	$0, -56(%rbp)
	movl	$0, -52(%rbp)
	movq	-88(%rbp), %rax
	movq	-112(%rbp), %rdx
	movq	-120(%rbp), %rcx
	movq	%rax, %rbx
	movq	%rdx, %rsi
	movq	%rcx, %rdi
#APP
# 65 "asmmatrix.c" 1
	movq $0x1, %rax 
	movdqa (%rbx), %xmm0 
	movdqa %xmm0, (%rdi) 
	
# 0 "" 2
#NO_APP
	nop
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	AvxMatrixMul, .-AvxMatrixMul
	.section	.rodata
.LC0:
	.string	"1"
	.text
	.globl	CMatrixMul
	.type	CMatrixMul, @function
CMatrixMul:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%rdx, -88(%rbp)
	movq	%rcx, -96(%rbp)
	movq	%r8, -104(%rbp)
	movq	%r9, -112(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, %rdx
	subq	$1, %rdx
	movq	%rdx, -24(%rbp)
	movq	-104(%rbp), %rdx
	movq	%rdx, %rcx
	subq	$1, %rcx
	movq	%rcx, -16(%rbp)
	movq	24(%rbp), %rcx
	movq	%rcx, %rsi
	subq	$1, %rsi
	movq	%rsi, -8(%rbp)
	movq	16(%rbp), %rsi
	cmpq	-72(%rbp), %rsi
	jne	.L10
	movq	24(%rbp), %rsi
	cmpq	-104(%rbp), %rsi
	jne	.L10
	movq	-80(%rbp), %rsi
	cmpq	-96(%rbp), %rsi
	je	.L11
.L10:
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	jmp	.L9
.L11:
	movq	$0, -48(%rbp)
	jmp	.L13
.L18:
	movq	$0, -40(%rbp)
	jmp	.L14
.L17:
	movl	$0, -52(%rbp)
	movq	$0, -32(%rbp)
	jmp	.L15
.L16:
	movq	%rax, %rsi
	imulq	-48(%rbp), %rsi
	leaq	0(,%rsi,4), %rdi
	movq	-88(%rbp), %rsi
	addq	%rsi, %rdi
	movq	-32(%rbp), %rsi
	movl	(%rdi,%rsi,4), %edi
	movq	%rdx, %rsi
	imulq	-32(%rbp), %rsi
	leaq	0(,%rsi,4), %r8
	movq	-112(%rbp), %rsi
	addq	%rsi, %r8
	movq	-40(%rbp), %rsi
	movl	(%r8,%rsi,4), %esi
	imull	%edi, %esi
	addl	%esi, -52(%rbp)
	addq	$1, -32(%rbp)
.L15:
	movq	-32(%rbp), %rsi
	cmpq	-80(%rbp), %rsi
	jb	.L16
	movq	%rcx, %rsi
	imulq	-48(%rbp), %rsi
	leaq	0(,%rsi,4), %rdi
	movq	32(%rbp), %rsi
	leaq	(%rdi,%rsi), %r8
	movq	-40(%rbp), %rsi
	movl	-52(%rbp), %edi
	movl	%edi, (%r8,%rsi,4)
	addq	$1, -40(%rbp)
.L14:
	movq	-40(%rbp), %rsi
	cmpq	24(%rbp), %rsi
	jb	.L17
	addq	$1, -48(%rbp)
.L13:
	movq	-48(%rbp), %rsi
	cmpq	16(%rbp), %rsi
	jb	.L18
.L9:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	CMatrixMul, .-CMatrixMul
	.section	.rodata
.LC1:
	.string	"%d "
	.text
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -96(%rbp)
	movl	$2, -92(%rbp)
	movl	$3, -88(%rbp)
	movl	$4, -84(%rbp)
	movl	$5, -80(%rbp)
	movl	$6, -76(%rbp)
	movl	$7, -72(%rbp)
	movl	$8, -68(%rbp)
	movl	$9, -64(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -48(%rbp)
	movaps	%xmm0, -32(%rbp)
	movd	%xmm0, -16(%rbp)
	leaq	-96(%rbp), %rcx
	leaq	-96(%rbp), %rax
	subq	$8, %rsp
	leaq	-48(%rbp), %rdx
	pushq	%rdx
	pushq	$3
	pushq	$3
	movq	%rcx, %r9
	movl	$3, %r8d
	movl	$3, %ecx
	movq	%rax, %rdx
	movl	$3, %esi
	movl	$3, %edi
	call	AvxMatrixMul
	addq	$32, %rsp
	movq	$0, -112(%rbp)
	jmp	.L20
.L23:
	movq	$0, -104(%rbp)
	jmp	.L21
.L22:
	movq	-112(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	movq	-104(%rbp), %rdx
	addq	%rdx, %rax
	movl	-48(%rbp,%rax,4), %eax
	movl	%eax, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$1, -104(%rbp)
.L21:
	cmpq	$2, -104(%rbp)
	jbe	.L22
	movl	$10, %edi
	call	putchar@PLT
	addq	$1, -112(%rbp)
.L20:
	cmpq	$2, -112(%rbp)
	jbe	.L23
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L25
	call	__stack_chk_fail@PLT
.L25:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.2.0-4ubuntu3) 13.2.0"
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

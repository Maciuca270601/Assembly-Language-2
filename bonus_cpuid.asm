section .text
	global cpu_manufact_id
	global features
	global l2_cache_info
;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	
	; function should save these 3 registers
	push ebx
	push edi
	push esi

	xor eax, eax ; eax = 0 for first part of the task
	cpuid
	mov edi, [ebp + 8] ; char *id_string
	
	; the result is a 12 bytes string stored in ebx:edx:ecx
	mov dword[edi], ebx
	add edi, 4
	mov dword[edi], edx
	add edi, 4
	mov dword[edi], ecx

	;restore the 3 registers saved at the start
	pop esi
	pop edi
	pop ebx

	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0

	;save cdecl
	push ebx
	push esi
	push edi
	
	mov eax, 1 ; eax = 1 for second part of the task
	cpuid

	; VMX is saved on 5th bit of ecx
	; EDI is a mask that has 1 only on its 5th bit
	mov eax, [ebp + 8]
	mov edi, 0x00000010 
	and edi, ecx
	cmp edi, 0x00000010
	
	je set_vmx
	mov dword[eax], 0
	jmp done_vmx_check

set_vmx:
	mov dword[eax], 1

done_vmx_check:
	; RDRAND is saved on 30th bit of ecx
	; EDI is a mask that has 1 only on its 30th bit
	mov eax, [ebp + 12]
	mov edi, 0x40000000
	and edi, ecx
	cmp edi, 0x40000000

	je set_rdrand
	mov dword[eax], 0
	jmp done_rdrand_check
set_rdrand:
	mov dword[eax], 1
	
done_rdrand_check:
	; AVX is saved on
	; EDI is a mask that has 1 only on its
	mov eax, [ebp + 16]
	mov edi, 0x10000000
	and edi, ecx
	cmp edi, 0x10000000

	je set_avx
	mov dword[eax], 0
	jmp done_avx_check
set_avx:
	mov dword[eax], 1
done_avx_check:
	; restore the 3 registers saved at the start
	pop edi
	pop esi
	pop ebx

	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0

	; function saves these 3 registers
	push ebx
	push edi
	push esi

	mov eax, 0x80000006 ; eax = 80000006h for this last part
	cpuid
	;copy of ecx
	mov esi, ecx
	
	; Line Size is saved on ECX lower byte(00-07)
	; EDI is a mask that has that specific byte setted on 1
	mov eax, [ebp + 8]
	and esi, 0xff
	mov dword[eax], esi

	; Line Cache Size is also saved on ECX (16-31 bits)
	mov eax, [ebp + 12]
	shr ecx, 16
	and ecx, 0xffff
	mov dword[eax], ecx

	;restore the 3 registers saved at the start
	pop esi
	pop edi
	pop ebx

	leave
	ret

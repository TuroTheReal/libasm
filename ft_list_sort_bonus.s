global ft_list_sort

section .text

						; Arguments: rdi = t_list **lst, rsi = int (*cmp)(void *, void *)
						; Retour: rien
ft_list_sort:
	push rbx			; sauvegarder registres callee-saved
	push r12
	push r13
	push r14
	push r15

						; Vérifications
	test rdi, rdi
	jz .end				; lst == NULL
	test rsi, rsi
	jz .end				; cmp == NULL

	mov r12, rdi		; r12 = lst (&ptr)
	mov r13, rsi		; r13 = fonction de comparaison

	mov rax, [r12]		; rax = *lst
	test rax, rax
	jz .end				; liste vide

						; Bubble sort optimisé
.bubble_sort_loop:
	mov r14, 0			; swapped = false
	mov rbx, [r12]		; rbx = current = *lst

						; Vérifier si current->next existe
	mov rax, [rbx + 8]
	test rax, rax
	jz .check_if_swapped

.inner_loop:
	mov r15, [rbx + 8]	; r15 = next = current->next
	test r15, r15
	jz .check_if_swapped

						; Comparer current->data et next->data
	mov rdi, [rbx]		; rdi = current->data
	mov rsi, [r15]		; rsi = next->data
	call r13			; appeler cmp(current->data, next->data)

						; Si cmp > 0, échanger les données
	cmp eax, 0
	jle .no_swap

						; Échanger les pointeurs de données
	mov rcx, [rbx]		; rcx = current->data
	mov rdx, [r15]		; rdx = next->data
	mov [rbx], rdx		; current->data = next->data
	mov [r15], rcx		; next->data = current->data

	mov r14, 1			; swapped = true

.no_swap:
	mov rbx, r15		; current = next
	jmp .inner_loop

.check_if_swapped:
	 					; Si aucun échange, tri terminé
	test r14, r14
	jnz .bubble_sort_loop

.end:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	ret
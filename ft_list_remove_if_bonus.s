global ft_list_remove_if
extern free
section .text

							; Arguments: rdi = t_list **lst, rsi = void *data_ref,
							; rdx = int (*cmp)(void *, void *), rcx = void (*free_fct)(void *)
							; Retour: rien

ft_list_remove_if:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
							; Vérifications initiales
	test rdi, rdi			; Vérifier si lst est NULL
	jz .end
	test rdx, rdx			; Vérifier si cmp est NULL
	jz .end

	mov r12, rdi			; r12 = lst (pointeur vers le pointeur de liste)
	mov r13, rsi			; r13 = data_ref
	mov r14, rdx			; r14 = cmp function
	mov r15, rcx			; r15 = free_fct	; Vérifier si *lst est NULL
	mov rax, [r12]			; rax = *lst
	test rax, rax
	jz .end

.remove_head_loop:
	mov rbx, [r12]			; rbx = *lst (premier noeud)
	test rbx, rbx
	jz .end					; Préparer les arguments pour cmp(current->data, data_ref)
	mov rdi, [rbx]			; rdi = current->data
	mov rsi, r13			; rsi = data_ref
							; Aligner la pile avant l'appel (nécessaire pour ABI x86-64)
	mov rax, rsp
	and rax, 15				; Vérifier l'alignement
	jz .call_cmp_head		; Déjà aligné
	sub rsp, 8				; Aligner sur 16 bytes
	push rbx				; Sauvegarder rbx
	call r14				; Appeler cmp
	pop rbx					; Restaurer rbx
	add rsp, 8				; Restaurer l'alignement
	jmp .check_result_head

.call_cmp_head:
	push rbx				; Sauvegarder rbx
	call r14				; Appeler cmp
	pop rbx					; Restaurer rbx

.check_result_head:
	test eax, eax
	jnz .process_body		; si != 0, passer au corps de la liste	; Supprimer l'élément en tête
	mov rax, [rbx + 8]		; rax = current->next
	mov [r12], rax			; *lst = current->next
							; Libérer data si free_fct existe
	test r15, r15
	jz .free_node_head
	mov rdi, [rbx]			; rdi = current->data
							; Aligner la pile pour free_fct
	mov rax, rsp
	and rax, 15
	jz .call_free_data_head
	sub rsp, 8
	push rbx
	call r15				; free_fct(current->data)
	pop rbx
	add rsp, 8
	jmp .free_node_head

.call_free_data_head:
	push rbx
	call r15				; free_fct(current->data)
	pop rbx

.free_node_head:
	mov rdi, rbx
							; Aligner la pile pour free
	mov rax, rsp
	and rax, 15
	jz .call_free_head
	sub rsp, 8
	call free wrt ..plt
	add rsp, 8
	jmp .remove_head_loop

.call_free_head:
	call free wrt ..plt		; free(current)
	jmp .remove_head_loop

.process_body:
							; Maintenant traiter le reste de la liste
	mov rbx, [r12]			; rbx = premier noeud restant
	test rbx, rbx
	jz .end

.body_loop:
	mov rax, [rbx + 8]		; rax = current->next
	test rax, rax
	jz .end					; fin de liste

							; Préparer les arguments pour cmp(next->data, data_ref)
	mov rdi, [rax]			; rdi = next->data
	mov rsi, r13			; rsi = data_ref

							; Aligner la pile pour l'appel
	push rbx				; Sauvegarder current
	push rax				; Sauvegarder next
	mov rcx, rsp
	and rcx, 15
	jz .call_cmp_body
	sub rsp, 8
	call r14				; cmp(next->data, data_ref)
	add rsp, 8
	jmp .check_result_body

.call_cmp_body:
	call r14				; cmp(next->data, data_ref)

.check_result_body:
							; Sauvegarder le résultat de la comparaison
	mov rcx, rax			; rcx = résultat de cmp
	pop rax					; restaurer next
	pop rbx					; restaurer current

	test ecx, ecx			; tester le résultat de cmp
	jnz .advance			; si != 0, avancer

							; Supprimer next
	mov rcx, [rax + 8]		; rcx = next->next
	mov [rbx + 8], rcx		; current->next = next->next

							; Libérer data si free_fct existe
	test r15, r15
	jz .free_node_body

	mov rdi, [rax]			; rdi = next->data
	push rbx				; sauvegarder current
	push rax				; sauvegarder next
	mov rcx, rsp
	and rcx, 15
	jz .call_free_data_body
	sub rsp, 8
	call r15				; free_fct(next->data)
	add rsp, 8
	jmp .restore_after_free_data

.call_free_data_body:
	call r15				; free_fct(next->data)

.restore_after_free_data:
	pop rax					; restaurer next
	pop rbx					; restaurer current

.free_node_body:
	mov rdi, rax			; rdi = next
	push rbx				; sauvegarder current
	mov rcx, rsp
	and rcx, 15
	jz .call_free_body
	sub rsp, 8
	call free wrt ..plt		; free(next)
	add rsp, 8
	jmp .restore_after_free_node

.call_free_body:
	call free wrt ..plt		; free(next)

.restore_after_free_node:
	pop rbx					; restaurer current
							; Ne pas avancer rbx, vérifier le nouveau next
	jmp .body_loop

.advance:
	mov rbx, rax			; current = next
	jmp .body_loop

.end:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
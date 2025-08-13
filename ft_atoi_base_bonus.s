section .text
global ft_atoi_base
extern ft_strlen

					; Arguments: rdi = str, rsi = base
					; Retour: rax = nombre converti

					; r12 = pointeur sur string courante
					; r13 = pointeur base
					; r14 = longueur de la base
					; r15 = signe final (1 ou -1)

ft_atoi_base:
	; Sauvegarder les registres callee-saved
	; Ces registres DOIVENT être restaurés avant le retour

	push rbx		; registre temporaire pour calculs
	push r12		; pointeur string courante
	push r13		; pointeur base
	push r14		; longueur base
	push r15		; signe résultat

					; Check null
	test rdi, rdi
	jz .error
	test rsi, rsi
	jz .error

					; Sauvegarder paramètres dans registres callee-saved
	mov r12, rdi	; r12 = str
	mov r13, rsi	; r13 = base

	mov rdi, r13	; argument pour ft_strlen
	call ft_strlen  ; rax = longueur
	cmp rax, 2	 	; base doit être >= 2
	jl .error

	mov r14, rax	; r14 = longueur base sauvegardée

					; Vérifier la base: pas de doublons, pas +/-, pas d'espaces
	call .validate_base
	test rax, rax
	jz .error	 	; base invalide

  					; skip espace
	mov rdi, r12
	call .skip_whitespace
	mov r12, rax	; r12 = nouvelle position

					; get -/+
	mov r15, 1		; signe par défaut = +
	call .parse_signs
	mov r12, rax	; r12 = position après signes

					; to number
	call .convert_number

					; apply sign
	imul rax, r15	; résultat *= signe
	jmp .cleanup

.error:
	xor rax, rax	; if error, return 0

.cleanup:
	pop r15			; Restaurer les registres LIFO
	pop r14
	pop r13
	pop r12
	pop rbx
	ret

					; Entrée: r13 = base, r14 = longueur
					; Sortie: rax = 1 si valide, 0 sinon
.validate_base:
	xor rcx, rcx	; index i = 0

.validate_outer_loop:
	cmp rcx, r14
	jge .base_valid

	movzx eax, byte [r13 + rcx]  ; eax = base[i] (zero-extend)

					; Invalid for base
	cmp al, ' '
	je .base_invalid
	cmp al, 9
	je .base_invalid
	cmp al, 10
	je .base_invalid
	cmp al, 11
	je .base_invalid
	cmp al, 12
	je .base_invalid
	cmp al, 13
	je .base_invalid
	cmp al, '+'
	je .base_invalid
	cmp al, '-'
	je .base_invalid

					; Check double
	mov rdx, rcx	; rdx = j = i
	inc rdx		; j = i + 1

.validate_inner_loop:
	cmp rdx, r14
	jge .no_duplicate_found

	cmp al, [r13 + rdx]  ; base[i] == base[j] ?
	je .base_invalid	; doublon trouvé

	inc rdx
	jmp .validate_inner_loop

.no_duplicate_found:
	inc rcx		; i++
	jmp .validate_outer_loop

.base_valid:
	mov rax, 1	 ; base OK
	ret

.base_invalid:
	xor rax, rax	; base invalide
	ret

					; rdi = pointeur string
					; rax = pointeur premier caractère non-espace
.skip_whitespace:
	mov rax, rdi	; rax = current pos

.skip_loop:
	movzx ecx, byte [rax] 	; ecx = caractère courant
	test ecx, ecx  			; fin de chaîne ?
	jz .skip_done

  					; Vérifier carac
	cmp cl, ' '
	je .skip_next
	cmp cl, 9
	je .skip_next
	cmp cl, 10
	je .skip_next
	cmp cl, 11
	je .skip_next
	cmp cl, 12
	je .skip_next
	cmp cl, 13
	je .skip_next

	; Caractère non-espace trouvé
	jmp .skip_done

.skip_next:
	inc rax			; next pos
	jmp .skip_loop

.skip_done:
	ret
					; Parse +/- en début
					; r12 = position, r15 = signe courant
					; rax = nouvelle position, r15 modifié
.parse_signs:
	mov rax, r12	; current pos
	mov rcx, 0		; compteur de signes

.sign_loop:
	movzx rdx, byte [rax]
	test rdx, rdx
	jz .sign_done

	cmp dl, '+'
	je .sign_positive
	cmp dl, '-'
	je .sign_negative
	jmp .sign_done

.sign_positive:
	inc rcx
	cmp rcx, 1
	jg .invalid_signs	; trop de signes
	inc rax
	jmp .sign_loop

.sign_negative:
	inc rcx
	cmp rcx, 1
	jg .invalid_signs	; trop de signes
	neg r15
	inc rax
	jmp .sign_loop

.invalid_signs:
    add rsp, 8          ; Retirer l'adresse de retour de .parse_signs
    jmp .error          ; Maintenant on peut sauter en sécurité

.sign_done:
	ret


					; find pos for carac
					; al = caractère, r13 = base, r14 = longueur
					; rax = index ou -1 if not find
.find_char_in_base:
	xor rcx, rcx	; index = 0

.find_loop:
	cmp rcx, r14
	jge .char_not_found

	cmp al, [r13 + rcx]  ; find ?
	je .char_found

	inc rcx
	jmp .find_loop

.char_found:
	mov rax, rcx	; return index
	ret

.char_not_found:
	mov rax, -1	; not find
	ret

					; Convertit la séquence de chiffres en nombre
					; r12 = position, r13 = base, r14 = len
					; rax = nombre converti
.convert_number:
	xor rax, rax	; result = 0

.convert_loop:
	movzx ecx, byte [r12]	; current carac
	test ecx, ecx  			; end ?
	jz .convert_done


	mov al, cl				; caractère à chercher
	call .find_char_in_base
	cmp rax, -1				; find ?
	je .convert_done		; invalid = fin conversion

							; result = result * longueur_base + valeur_caractère
	push rax				; save value
	mov rax, rbx			; rax = résultat courant (stocké dans rbx)
	imul rax, r14			; rax = résultat * longueur_base
	pop rdx					; rdx = valeur caractère
	add rax, rdx			; rax = résultat * base + valeur
	mov rbx, rax			; save new result
	inc r12					; caractère suivant
	jmp .convert_loop

.convert_done:
	mov rax, rbx	; return
	ret
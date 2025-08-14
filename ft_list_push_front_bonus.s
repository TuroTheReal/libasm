global ft_list_push_front
extern malloc
section .text

					; Arguments: rdi = t_list **lst, rsi = void *data
					; Retour: rien
					; Structure: typedef struct s_list { void *data; struct s_list *next; } t_list;
ft_list_push_front:
    push rbx        ; sauvegarder registres callee-saved
    push r12
    push r13

    test rdi, rdi
    jz .end         	; si lst == NULL, rien à faire

    mov r12, rdi    	; r12 = lst (&ptr)
    mov r13, rsi    	; r13 = data

   						; 16 bytes = 8 -> data + 8 -> next
    mov rdi, 16
    call malloc wrt ..plt
    test rax, rax
    jz .end        		; si malloc échec, rien à faire

    mov rbx, rax    	; rbx = nouveau noeud

    					; Init node
    mov [rbx], r13      ; nouveau->data = data
    mov rcx, [r12]      ; rcx = *lst (ancien premier noeud)
    mov [rbx + 8], rcx  ; nouveau->next = *lst

    					; Maj du ptr de tête
    mov [r12], rbx      ; *lst = nouveau

.end:
    pop r13
    pop r12
    pop rbx
    ret
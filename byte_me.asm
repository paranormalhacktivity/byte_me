section .data  ;Data segment
	user_msg db "Hello! What's your name?", 10 ;Ask user to enter their name. 10 represents appending newline character
	len_user_msg equ $-user_msg ;Ask the length of  the message
	display_msg db ", It's so nice to meet you!", 10
	len_display_msg equ $-display_msg

section .bss ;Uninitialized data
  num resb 16
  len_num equ $-num

section .text
  global _start

_start: ;start here
  call .print_prompt
	call .get_user_input
	call .display_user_name
	call .append_greeting_message
	call .exit

.print_prompt:
  mov eax, 4 ;sys_write call
	mov ebx, 1 ;file descriptor(STDOUT)
	mov ecx, user_msg	;message to write
	mov edx, len_user_msg ;length of the written message
	int 80h ;call kernel "80h" is equivalent to "0x80"

.get_user_input:
  mov eax, 3 ;sys_read call
	mov ebx, 2 ;file descriptor(STDIN)
	mov ecx, num ;save STDIN to num variable
	mov edx, len_num ;length of STDIN response
	int 80h	;call kernel
	mov byte [ecx + eax - 1], 0 ;remove newline from the end of STDIN

.display_user_name:
	mov eax, 4 ;sys_write call
	mov ebx, 1 ;file descriptor(STDOUT)
	mov ecx, num ;return user input variable
	mov edx, len_num ;length of user input variable
	int 80h ;call kernel

.append_greeting_message:
	mov eax, 4 ;sys_write call
	mov ebx, 1 ;file descriptor(STDOUT)
	mov ecx, display_msg ;message to write
	mov edx, len_display_msg ;length of written message
	int 80h ;call kernel

.exit:
	mov eax, 1 ;sys_exit call
	mov ebx, 0 ;exit code 0
	int 80h ;call kernel

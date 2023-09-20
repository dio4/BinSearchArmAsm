/* BinarySearch.s */
	.data
return: .word 0
array: .word 2,5,11,23,47,95,191,383,767,998
num_read: .word 0

/* Strings */
prompt: .asciz "\nInsert int key (key<0 to quit):"
scanFMT: .asciz "%d"
echo: .asciz "\nYou enetered:%d\n"
ymsg: .asciz "\nKey was found at position %d\n"
nmsg: .asciz "\nKey not found! A near index is: %d\n"

	.text
.global main
main:
	ldr r1, =return
	str lr, [r1]
input: /* 1. Выводим строку приглашения puts
	  2. Считываем ввод в num_read с пом. scanf и строки формата scanFMT
	*/
	ldr r0, =prompt
	bl puts

	ldr r0, =scanFMT
	ldr r1, =num_read
	bl scan

@echo: выводим считанное значение

	ldr r0, =echo
	ldr r1, =num_read
	ldr r1, [r1]
	bl printf

@check (проверка ввода)
	ldr r1, =num_read
	ldr r1, [r1]
	cmp r1, #0
	blt exit

/*  r0 - min index
	r1 - max index
	r3 - mid( (low+high)/2 )	
	r5 - расчетный индекс
	r6 - введенное искомое число
	r7 - адрес массива
	r8 - сохраняем значение r3 для печати
*/

	mov r6, r1
	ldr r7, =array
	mov r0. #0 @ min index of array
	mov r1, #9 @ max index of array

Loop:
	cmp r1, r0
	blt fail   @Если high(r1) < low(r0), то ошибка

@get middle ( mid = (low+high)/2 )
	add r3, r0, r1
	mov r3, r3, ASR#1	
	mov r8, r3
	add r5, r7, r3, LSL#2 @ к началу массива прибаляем расчетный индекс(mid==r3) и умножаем на 4(размер типа int). 
						  @	Получаем АДРЕС эл. массива с расчитанным индексом mid
	ldr r5, [r5]
	cmp r5, r6
	blt RH
	bgt LH
	b found

RH:
	add r0, r3, #1 @ кладем в low знач. индекса mid+1
	b Loop
LH:
	sub r1, r3, #1
	b Loop

@found
	add r1, r8, #1
	ldr r0, =ymsg
	bl printf

@not found
fail:
	add r1, r8, #1
	ldr r0, =nmsg
	bl printf
	b input

@exit
exit:
	ldr r1, =return
	ldr r1, [r1]
	bx ldr
/* External*/

.global puts
.global printf
.global scan



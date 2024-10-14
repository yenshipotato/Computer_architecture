.data
argument: .word 50        # Initialize argument with value 50

.text    

init:
    lw t0, argument           # Load the argument value (50) into register t0
    li t2, 1                  # Load immediate 1 into register t2 (used for bitwise operations)
    addi t3, t0, 1            # Add 1 to t0 (50) and store result in t3 (t3 = 51)

calc_total:
    and t4, t3, t2            # Perform bitwise AND between t3 and t2, store in t4
    bne t4, zero, loop1       # If t4 is not zero, branch to loop1
    jal loop0                 # Otherwise, jump to loop0

loop1:
    add t5, t5, t0            # Add t0 (50) to t5, accumulating the sum
loop0:
    sll t0, t0, t2            # Shift t0 (50) left by 1 bit (multiply by 2)
    srl t3, t3, t2            # Shift t3 (51) right by 1 bit (divide by 2)
    bne t3, zero, calc_total  # Repeat if t3 is not zero

init2:
    srl t5, t5, t2            # Shift t5 right by 1 bit (divide by 2)
    li t0, 0                  # Set t0 to 0 (initial sum with 0)
    li t1, 1                  # Set t1 to 1 (index for iteration)

while:
    add t0, t0, t1            # sum += index
    sll t3, t0, t2            # t3 = sum * 2
    add t4, t5, t1            # t4 = total + index
    beq t3, t4, return        # If t3 = t4, end the loop
    add t1, t1, t2            # Increment index by 1 (increase loop step)
    beq t0, t5, while         
    blt t0, t5, while         # If sum <= total, continue loop

else:
    li t1, -1                 # If the while condition fails, set t1 to -1

return:
    mv a0, t1

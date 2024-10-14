.data
        argument: .word   0x00003e80 #0.25(bf16)
  
.text
bf16_to_fp32:     

        lw t1, argument  # Load the argument into register t1
        li t2, 16        # Load offset (16) into register t2
        sll t3, t1, t2   # Shift left the contents in register t1 by 16 bits and places the result into register t3.
        mv a0, t3 

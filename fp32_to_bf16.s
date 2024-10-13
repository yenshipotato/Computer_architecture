.data
argument:    .word   0x3e800000  # 0.25 in floating-point 32-bit (fp32) format
bit_mask:    .word   0x7fffffff  # Mask for extracting the sign bit
cond:        .word   0x7f800000  # Condition to check NaN
bit_offset:  .word   0x10        # Offset value of 16 (used for shifts)

.text    
fp32_to_bf16:
   lw t0, argument           # Load the fp32 value (0.25) into t0
   lw t1, bit_mask           # Load the bit mask (0x7fffffff) into t1
   and t2, t1, t0            # Mask the sign bit from t0 (fp32), store in t2
   
   lw t3, cond               # Load the condition value (0x78000000) into t3
   bne t3, t2, cond_neq      # If the masked bits in t2 and t3 are not equal, branch to cond_neq

cond_eq:
   lw t1, bit_offset         # Load the bit offset value (16) into t1
   srl t3, t0, t1            # Shift right logical t0 by 16 bits, result in t3 (convert to bf16)
   li t2, 1                  # Load immediate 1 into t2
   and t3, t3, t2            # Perform bitwise AND between t3 and t2 (keep LSB of bf16)
   li t2, 0x7fff             # Load immediate 0x7fff into t2
   add t3, t3, t2            # Add t2 (0x7fff) to t3
   add t3, t3, t0            # Add the original fp32 value t0 to t3 (accumulate result)
   srl t3, t3, t1            # Shift right logical the result in t3 by 16 bits again
   jal final                 # Jump and link to final

cond_neq: 
   blt t2, t3, cond_eq       # If t2 is less than t3, branch back to cond_eq
   li t1, 16                 # Load immediate 16 into t1
   srl t3, t0, t1            # Shift right logical t0 by 16 bits, store result in t3 (conversion to bf16)
   li t1, 64                 # Load immediate 64 into t1
   or t3, t3, t1             # Perform bitwise OR between t3 and t1, store in t3

final:
   nop                       # No operation (end of function)

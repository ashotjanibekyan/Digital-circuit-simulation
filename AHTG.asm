.model small

.stack 100H

.code

ORG 0100H


gate:
    MOV AL, 10101110B
    ; generate the first input of the final OR
    MOV BL, AL          ; copy the input to BL
    NOT BL              ; invert everything in bl, this will also invert the first bit

    MOV CL, AL          ; make another copy in CL
    MOV DL, AL          ; and also copy to DL
    SHL DL, 1           ; shift everything in DL to left, so when we perform DL and CL, 
    AND CL, DL          ;   we will compare the second bit of CL and third bit of DL

    SHL CL, 1           ; shift everything to left in CL, so we can compare first bit of CL and second bit of CL 
    AND BL, CL          ; (A nand B) = not(A and B)
    NOT BL              ; at this point the first bit of BL is the same as the output of the first NAND

    MOV CL, AL          ; move the input to CL
    NOT CL              ; (A nand A) = !(A and A) = !A
    SHL CL, 3           ; shift everything 3 bit left 
    XOR BL, CL          ; do the upper XOR with BL and CL

    MOV CL, AL          ; copy the input to CL
    SHL CL, 4           ; move the 5th bit of CL to 1st poistion
    AND BL, CL          ; (A nand B) = !(A and B)
    NOT BL              ; now the value of BL is what we need for the first input of the final OR

    ; generate the second input of the final OR
    MOV CL, AL          ; move the input to CL
    NOT CL              ; (A nand A) = !(A and A) = !A
    SHL CL, 3           ; shift everything in CL 3 bit left 
    
    MOV DL, AL          ; move the input to CL
    SHL DL, 6           ; shift everything in DL 6 bit left, so we can compate 7th bit of DL with 1st bit of CL
    AND CL, DL          ; now the first bit of CL has the value of first input of the last NOR
    
    MOV DL, AL          ; move the input to DL
    SHL DL, 7           ; shift everything in DL 7 bit left, so we can compare the last bit of DL with 1st bit of CL
    OR CL, DL           ; (A nor B) = not(A or B)
    NOT CL              ; now we have the second input of the final OR in the first bit of CL
    OR BL, CL           ; perform the last OR
    
    ; make DL 30H or 31H based on the value of BL
    MOV DL, 30H   ; now DL is 30H, we need to change the last bit based on the value of the first bit of BL
    SHR BL, 7           ; shift the first bit of BL to compare it with the last bit of DL
    OR DL, BL           ; since everything exept the last bit in BL is 0, we will have 30H or 31H in DL based on the value of BL
    MOV AH,2
    int 21H
    
    mov ah, 4Ch
    int 21H 

end gate
    
    
    
    
; -------------------------------------------------------------------
; Changes the position of a player
; Input: HL = Player config (at byte 1)
; Alters the value of registers: AF BC HL
; -------------------------------------------------------------------
DisplayPlayer:
     ld   b, (hl)                  ; Load 1st byte of player config into B
     inc  hl                       ; 2nd byte of player config
     ld   c, (hl)                  ; Load value into C
     ld   a, (bc)                  ; Load video memory byte for player's position into A
     inc  hl                       ; 3rd byte of player config
     or   (hl)                     ; Combine player's position with video memory byte
     ld   (bc), a                  ; Write updated video memory byte back to player's position
     halt
ret

; -------------------------------------------------------------------
; Move to the next scan line
; Input: BC = Bytes 1 and 2 of player config
; Alters the value of registers: AF BC
; -------------------------------------------------------------------
NextScan:
     inc  b              ; Increment B to move to the next Scanline, B = 010TTSSS
     ld   a, b           ; Load the high byte of the video memory address into A
     and  $07            ; Mask with 00000111b to leave just the lower 3 bits (Scanline number)
     ret  nz             ; If not zero, we are still on the same Line, so exit
                         ; If zero, then Scanline was 7 = 111b and we have now set this to 0 and incremented the screen Third
     ld   a, c           ; Load the low byte of the video memory address into A, C = LLLCCCCC
     add  a, $20         ; Add 00100000b = 32d to move to the next Line
     ld   c, a           ; Store the updated low byte back into C
     ret  c              ; If there was a carry, then Line was 7d = 111b and we have now set this to 0
                         ; and we have moved to the next Third but this was already done with INC B
                         ; If there was no carry, then we are still on the same Third so we need to undo the INC B
     ld   a, b           ; Load the high byte of the video memory address into A
     sub  $08            ; Subtract 00001000b = 8d from B (010TTSSS) to decrease the screen Third
     ld   b, a           ; Store the updated high byte back into B
ret

; -------------------------------------------------------------------
; Move to the previous scan line
; Input: BC = Bytes 1 and 2 of player config
; Alters the value of registers: AF BC
; -------------------------------------------------------------------
PreviousScan:
     ld   a, b           ; Load the high byte of the video memory address into A
     dec  b              ; Decrement B to move to the previous Scanline, B = 010TTSSS
     and  $07            ; Mask A with 00000111b to leave just the lower 3 bits (Scanline number)
     ret  nz             ; If not zero, we are still on the same Line, so exit
                         ; If zero, then Scanline was 0 = 000b and we have now set this to 7 and decremented the screen Third
     ld   a, c           ; Load the low byte of the video memory address into A, C = LLLCCCCC
     sub  $20            ; Subtract 00100000b = 32d to move to the previous Line
     ld   c, a           ; Store the updated low byte back into C
     ret  c              ; If there was a carry, then Line was 0d = 000b and we have now set this to 7
                         ; and we have moved to the previous Third but this was already done with DEC B
                         ; If there was no carry, then we are still on the same Third so we need to undo the DEC B
     ld   a, b           ; Load the high byte of the video memory address into A
     add  a, $08         ; Add 00001000b = 8d to B (010TTSSS) to increase the screen Third
     ld   b, a           ; Store the updated high byte back into B
ret

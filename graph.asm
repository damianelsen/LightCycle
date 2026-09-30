; -------------------------------------------------------------------
; Updates the positions of both players
; Input: none
; Alters the value of registers: HL
; -------------------------------------------------------------------
DisplayPlayers:
     ld   hl, player1config
     call DisplayPlayer
     ld   hl, player2config
     call DisplayPlayer
ret

; -------------------------------------------------------------------
; Updates the position of a player in the game arena
; Input: HL = Player config (at byte 1)
; Alters the value of registers: AF BC HL
; -------------------------------------------------------------------
DisplayPlayer:
     ld   b, (hl)                  ; Load 1st byte of player config into B
     inc  hl                       ; 2nd byte of player config
     ld   c, (hl)                  ; Load value into C
     ld   a, (bc)                  ; Load video memory byte for player's position into A
     inc  hl                       ; 3rd byte of player config
     call CheckCollision
     or   (hl)                     ; Combine player's position with video memory byte
     ld   (bc), a                  ; Write updated video memory byte back to player's position
ret

; -------------------------------------------------------------------
; Move to the next scan line
; Input:  DE = Bytes 1 and 2 of player config
; Output: DE = Updated bytes 1 and 2 of player config
; Alters the value of registers: AF DE
; -------------------------------------------------------------------
NextScan:
     inc  d              ; Increment D to move to the next Scanline, D = 010TTSSS
     ld   a, d           ; Load the high byte of the video memory address into A, D = 010TTSSS
     and  %00000111      ; Mask to leave just the lower 3 bits (Scanline number)
     ret  nz             ; If not zero, we are still on the same Line, so exit
                         ; If zero, then Scanline was 7 = 111b and we have now set this to 0 and incremented the screen Third
     ld   a, e           ; Load the low byte of the video memory address into A, E = LLLCCCCC
     add  a, %00100000   ; Move to the next Line
     ld   e, a           ; Store the updated low byte back into E
     ret  c              ; If there was a carry, then Line was 7d = 111b and we have now set this to 0
                         ; and we have moved to the next Third but this was already done with INC D
                         ; If there was no carry, then we are still on the same Third so we need to undo the INC D
     ld   a, d           ; Load the high byte of the video memory address into A, D = 010TTSSS
     sub  %00001000      ; Decrease the screen Third
     ld   d, a           ; Store the updated high byte back into D
ret

; -------------------------------------------------------------------
; Move to the previous scan line
; Input:  DE = Bytes 1 and 2 of player config
; Output: DE = Updated bytes 1 and 2 of player config
; Alters the value of registers: AF DE
; -------------------------------------------------------------------
PreviousScan:
     ld   a, d           ; Load the high byte of the video memory address into A, D = 010TTSSS
     dec  d              ; Decrement D to move to the previous Scanline
     and  %00000111      ; Mask to leave just the lower 3 bits (Scanline number)
     ret  nz             ; If not zero, we are still on the same Line, so exit
                         ; If zero, then Scanline was 0 = 000b and we have now set this to 7 and decremented the screen Third
     ld   a, e           ; Load the low byte of the video memory address into A, E = LLLCCCCC
     sub  %00100000      ; Move to the previous Line
     ld   e, a           ; Store the updated low byte back into E
     ret  c              ; If there was a carry, then Line was 0d = 000b and we have now set this to 7d
                         ; and we have moved to the previous Third but this was already done with DEC D
                         ; If there was no carry, then we are still on the same Third so we need to undo the DEC D
     ld   a, d           ; Load the high byte of the video memory address into A, D = 010TTSSS
     add  a, %00001000   ; Increase the screen Third
     ld   d, a           ; Store the updated high byte back into D
ret

; -------------------------------------------------------------------
; Display player death animation
; Input:  HL = Player config (at byte 4)
; Output: none
; Alters the value of registers: AF BC DE HL
; -------------------------------------------------------------------
DisplayCollision:
     dec  hl                       ; Move to 3rd byte of player config
     dec  hl                       ; Move to 2nd byte of player config
     ld   e, (hl)                  ; Load 2nd byte of player config into E
     dec  hl                       ; Move to 1st byte of player config
     ld   d, (hl)                  ; Load 1st byte of player config into D
     inc  hl                       ; 2nd byte of player config
     inc  hl                       ; 3rd byte of player config

     ld   b, 3                     ; Move up three scan lines
     displayCollisionLoop1:
          call PreviousScan
     djnz displayCollisionLoop1

     ld   a, (hl)                  ; Load player's current position into A
     and  %00001111                ; Retain only the lower nibble
     jr   nz, displayCollisionCont ; If A is not zero (there is a value in the lower nibble) we jump
     dec  de                       ; A is zero (there was a value in the higher nibble) so we need to move left by one video byte
     displayCollisionCont:
     
     push de                       ; Store DE
     ld   de, 16                   ; Load DE with sprite RAM location offset (16)
     ld   b, 7                     ; Loop 7 times
     ld   a, (hl)                  ; Load player's current position into A
     ld   hl, spriteExplosion      ; Load the initial sprite address into HL
     displayCollisionLoop2:
          rrc  a                   ; Rotate right with carry
          jr   c, displayCollisionLoop2Exit ; If the carry bit is set we can exit
          add  hl, de              ; Add the sprite RAM location offset to HL
     djnz displayCollisionLoop2    ; Loop
     displayCollisionLoop2Exit:
     pop de

     ld   b, 8                     ; The sprite has 8 rows
     displayCollisionLoop3:
          call DisplayByte         ; Display the column 1 byte of the sprite
          inc  de                  ; Move to column 2
          call DisplayByte         ; Display the column 2 byte of the sprite
          dec  de                  ; Return to column 1
          call NextScan            ; Move down to the next scan line
     djnz displayCollisionLoop3
ret

; -------------------------------------------------------------------
; Update a single video memory byte
; Input:  DE = Memory location of video byte to update
;         HL = Memory location of video byte to use
; Output: none
; Alters the value of registers: AF HL
; -------------------------------------------------------------------
DisplayByte:
     ld   a, d                     ; Load 1st byte of video RAM location to update
     and  %00011000                ; Mask to get the screen third
     jr   nz, displayByteCont1     ; Jump if we are not in screen third 0
     ld   a, e                     ; Load 2nd byte of video RAM location to update
     and  %11100000                ; Mask to get the line number
     jr   z, displayByteExit       ; Jump if we are on line 0

     displayByteCont1:
     ld   a, d                     ; Load 1st byte of video RAM location to update
     and  %00010000                ; Mask to see if we are in screen third 2
     jr   z, displayByteCont2      ; Jump if we are not
     ld   a, e                     ; Load 2nd byte of video RAM location to update
     and  %11100000                ; Mask to get the line number
     cp   160                      ; See if we are on Line 5, 101 (5) in the three most signifcant bits = 160
     jr   z, displayByteExit       ; If so, exit

     displayByteCont2:
     ld   a, e                     ; Load 2nd byte of video RAM location to update
     and  %00011111                ; Mask to get the column number
     jr   z, displayByteExit       ; If it's zero, exit
     cp   31                       ; See if we are in column 31
     jr   z, displayByteExit       ; If so, exit

     ld   a, (de)                  ; Load video RAM byte to update
     or   (hl)                     ; Combine with the video memory byte to be displayed
     ld   (de), a                  ; Update the video RAM
     
     displayByteExit:
     inc  hl                       ; Move to the next byte
ret

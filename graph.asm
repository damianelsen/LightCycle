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
     ld   a, d           ; Load the high byte of the video memory address into A
     and  $07            ; Mask with 00000111b to leave just the lower 3 bits (Scanline number)
     ret  nz             ; If not zero, we are still on the same Line, so exit
                         ; If zero, then Scanline was 7 = 111b and we have now set this to 0 and incremented the screen Third
     ld   a, e           ; Load the low byte of the video memory address into A, E = LLLCCCCC
     add  a, $20         ; Add 00100000b = 32d to move to the next Line
     ld   e, a           ; Store the updated low byte back into E
     ret  c              ; If there was a carry, then Line was 7d = 111b and we have now set this to 0
                         ; and we have moved to the next Third but this was already done with INC D
                         ; If there was no carry, then we are still on the same Third so we need to undo the INC D
     ld   a, d           ; Load the high byte of the video memory address into A
     sub  $08            ; Subtract 00001000b = 8d from D (010TTSSS) to decrease the screen Third
     ld   d, a           ; Store the updated high byte back into D
ret

; -------------------------------------------------------------------
; Move to the previous scan line
; Input:  DE = Bytes 1 and 2 of player config
; Output: DE = Updated bytes 1 and 2 of player config
; Alters the value of registers: AF DE
; -------------------------------------------------------------------
PreviousScan:
     ld   a, d           ; Load the high byte of the video memory address into A
     dec  d              ; Decrement D to move to the previous Scanline, B = 010TTSSS
     and  $07            ; Mask A with 00000111b to leave just the lower 3 bits (Scanline number)
     ret  nz             ; If not zero, we are still on the same Line, so exit
                         ; If zero, then Scanline was 0 = 000b and we have now set this to 7 and decremented the screen Third
     ld   a, e           ; Load the low byte of the video memory address into A, E = LLLCCCCC
     sub  $20            ; Subtract 00100000b = 32d to move to the previous Line
     ld   e, a           ; Store the updated low byte back into E
     ret  c              ; If there was a carry, then Line was 0d = 000b and we have now set this to 7
                         ; and we have moved to the previous Third but this was already done with DEC D
                         ; If there was no carry, then we are still on the same Third so we need to undo the DEC D
     ld   a, d           ; Load the high byte of the video memory address into A
     add  a, $08         ; Add 00001000b = 8d to D (010TTSSS) to increase the screen Third
     ld   d, a           ; Store the updated high byte back into D
ret

; -------------------------------------------------------------------
; Display player death animation
; Input: HL = Player config (at byte 4)
; Alters the value of registers: AF, BC, DE, HL
; -------------------------------------------------------------------
DisplayPlayerDeath:
     push hl                       ; Preserve HL
     ld   hl, counter              ; Load HL with counter address
     ld   (hl), $02                ; Load 2d into counter (loop two times)
     pop  hl                       ; Retrieve HL
     displayPlayerDeathLoop:
          call LoadPlayerLocation
          call SetCounter
          call MoveUpByOffset
          call SetCounter
          call MoveRightByOffset
          call UpdateVideoByte
          call LoadPlayerLocation
          call SetCounter
          call MoveDownByOffset
          call SetCounter
          call MoveRightByOffset
          call UpdateVideoByte
          call LoadPlayerLocation
          call SetCounter
          call MoveDownByOffset
          call SetCounter
          call MoveLeftByOffset
          call UpdateVideoByte
          call LoadPlayerLocation
          call SetCounter
          call MoveUpByOffset
          call SetCounter
          call MoveLeftByOffset
          call UpdateVideoByte
          ld   a, (counter)        ; Load A with counter
          dec  a                   ; Decrement the counter
          ld   (counter), a        ; Store updated counter
          cp   $00                 ; Compare with 0d
     jr   nz, displayPlayerDeathLoop
ret

; -------------------------------------------------------------------
; Load B register with counter value to ready it for looping
; Input:  none
; Output: B updated with counter value
; Alters the value of registers: BC
; -------------------------------------------------------------------
SetCounter:
     push hl                       ; Preserve HL
     ld   hl, counter              ; Load HL with counter address
     ld   b, (hl)                  ; Load B with counter value
     pop  hl                       ; Retrieve HL
ret

; -------------------------------------------------------------------
; Load the current location of the player
; Input: HL = Player config (at byte 4)
; Alters the value of registers: BC, DE
; -------------------------------------------------------------------
LoadPlayerLocation:
     push hl                       ; Preserve HL
     dec  hl                       ; Move to 3rd byte of player config
     ld   c, (hl)                  ; Load 3rd byte of player config into C
     dec  hl                       ; Move to 2nd byte of player config
     ld   e, (hl)                  ; Load 2nd byte of player config into E
     dec  hl                       ; Move to 1st byte of player config
     ld   d, (hl)                  ; Load 1st byte of player config into D
     pop  hl                       ; Retrieve HL
ret

; -------------------------------------------------------------------
; Update a single video memory byte
; Input:  C  = Video byte
;         DE = Memory location of video byte to update
; Alters the value of registers: AF
; -------------------------------------------------------------------
UpdateVideoByte:
     ld   a, (de)
     or   c
     ld   (de), a
ret

; -------------------------------------------------------------------
; Move up by <offset> pixels
; Input:  B  = Offset (# of pixels)
;         DE = Video byte memory address
; Output: DE = Updated video byte memory address
; Alters the value of registers: BC
; -------------------------------------------------------------------
MoveUpByOffset:
     moveUpByOffsetLoop:
          call PreviousScan        ; Move to the previous scan line
     djnz moveUpByOffsetLoop       ; Loop until B = 0
ret

; -------------------------------------------------------------------
; Move down by <offset> pixels
; Input:  B  = Offset (# of pixels)
;         DE = Video byte memory address
; Output: DE = Updated video byte memory address
; Alters the value of registers: BC
; -------------------------------------------------------------------
MoveDownByOffset:
     moveDownByOffsetLoop:
          call NextScan            ; Move to the next scan line
     djnz moveDownByOffsetLoop     ; Loop until B = 0
ret

; -------------------------------------------------------------------
; Move right by <offset> pixels
; Input:  B  = Offset (# of pixels)
;         C  = Video byte
;         DE = Video byte memory address
; Output: C  = Updated video byte
;         DE = Updated video byte memory address
; Alters the value of registers: AF, BC, DE
; -------------------------------------------------------------------
MoveRightByOffset:
     ld   a, c                     ; Load A with video byte
     moveRightByOffsetLoop:
          rrca                     ; Rotate A right with carry
          jr   nc, moveRightByOffsetLoopCont
          ld   a, e                ; Load 2nd byte of video byte memory address into A
          and  $1f                 ; Mask with 00011111 to get the column number
          inc  a                   ; Move right by incrementing the column number
          ld   c, a                ; Store new column number in C
          ld   a, e                ; Load 2nd byte of video byte memory address into A again
          and  $e0                 ; Mask with 11100000 to get the line number
          or   c                   ; Combine line number with new column number
          ld   e, a                ; Load updated 2nd byte of video byte memory address into E
          ld   a, $80              ; Set A to 10000000b to move the player's position to the left of the next byte
          moveRightByOffsetLoopCont:
     djnz moveRightByOffsetLoop    ; Loop until B = 0
     ld   c, a                     ; Load C with updated video byte
ret

; -------------------------------------------------------------------
; Move left by <offset> pixels
; Input:  B  = Offset (# of pixels)
;         C  = Video byte
;         DE = Video byte memory address
; Output: C  = Updated video byte
;         DE = Updated video byte memory address
; Alters the value of registers: AF, BC, DE
; -------------------------------------------------------------------
MoveLeftByOffset:
     ld   a, c                     ; Load A with video byte
     moveLeftByOffsetLoop:
          rlca                     ; Rotate A right with carry
          jr   nc, moveLeftByOffsetLoopCont
          ld   a, e                ; Load 2nd byte of video byte memory address into A
          and  $1f                 ; Mask with 00011111 to get the column number
          dec  a                   ; Move left by decrementing the column number
          ld   c, a                ; Store new column number in C
          ld   a, e                ; Load 2nd byte of video byte memory address into A again
          and  $e0                 ; Mask with 11100000 to get the line number
          or   c                   ; Combine line number with new column number
          ld   e, a                ; Load updated 2nd byte of video byte memory address into E
          ld   a, $01              ; Set A to 00000001b to move the player's position to the right of the next byte
          moveLeftByOffsetLoopCont:
     djnz moveLeftByOffsetLoop     ; Loop until B = 0
     ld   c, a                     ; Load C with updated video byte
ret

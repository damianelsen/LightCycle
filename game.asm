; -------------------------------------------------------------------
; Changes the position of both players
; Input: none
; Alters the value of registers: AF, HL 
; -------------------------------------------------------------------
MovePlayers:
     ld   hl, player1config + $03
     call MovePlayer
     ld   hl, player2config + $03
     ;call MovePlayer
ret

; -------------------------------------------------------------------
; Changes the position of a player
; Input: HL = Player config (at byte 4)
; Alters the value of registers: AF, BC, HL 
; -------------------------------------------------------------------
MovePlayer:
     ld   a, (hl)                  ; Load 4th byte of player config into A
     bit  $04, a                   ; Check if bit 4 is active (alive)
     jp   z, movePlayerEnd         ; If zero, player is not active so exit
     bit  $03, a                   ; Check if bit 3 is active (moving down)
     jr   nz, movePlayerUpDown
     bit  $02, a                   ; Check if bit 2 is active (moving up)
     jr   nz, movePlayerUpDown
     bit  $01, a                   ; Check if bit 1 is active (moving right)
     jr   nz, movePlayerRight

     movePlayerLeft:               ; Bit 0 is active (moving left)
     dec  hl                       ; Move to the 3rd byte of player config
     ld   a, (hl)                  ; Load value into A
     cp   $80                      ; Check if the player is at the left edge of the byte
     jr   nz, movePlayerLeftCont   ; If not, continue to move the player left
     ld   a, $01                   ; Set A to 00000001b to move the player's position to the right of the next byte
     ld   (hl), a                  ; Write updated value back to 3rd byte of player config
     dec  hl                       ; Move to the 2nd byte of player config
     ld   a, (hl)                  ; Load value into A
     and  $1f                      ; Mask with 00011111 to get the column number
     cp   $01                      ; Compare with 00000001b (01d) to check if the player is at the left edge of the screen
     jr   nz, movePlayerLeftCont2  ; If not, continue to move the player left
     inc  hl                       ; Move to the 3rd byte of player config
     inc  hl                       ; Move to the 4th byte of player config
     res  $04, (hl)                ; Clear bit 4 to indicate the player is no longer active
     jr   movePlayerEnd
     movePlayerLeftCont2:
     sub  $01                      ; Move player left by decrementing the column number
     ld   b, a                     ; Store new column number in B
     ld   a, (hl)                  ; Load 2nd byte of player config into A again
     and  $e0                      ; Mask with 11100000 to get the line number
     or   b                        ; Combine line number with new column number
     ld   (hl), a                  ; Write updated column and line number back to 2nd byte of player config
     jr   movePlayerEnd
     movePlayerLeftCont:
     rlca                          ; Rotate left to move the player's position to the left
     ld   (hl), a                  ; Write updated player position back to 3rd byte of player config
     jr   movePlayerEnd

     movePlayerRight:
     dec  hl                       ; Move to the 3rd byte of player config
     ld   a, (hl)                  ; Load value into A
     cp   $01                      ; Check if the player is at the right edge of the byte
     jr   nz, movePlayerRightCont  ; If not, continue to move the player right
     ld   a, $80                   ; Set A to 10000000b to move the player's position to the left of the next byte
     ld   (hl), a                  ; Write updated value back to 3rd byte of player config
     dec  hl                       ; Move to the 2nd byte of player config
     ld   a, (hl)                  ; Load value into A
     and  $1f                      ; Mask with 00011111 to get the column number
     cp   $1e                      ; Compare with 00011110b (30d) to check if the player is at the right edge of the screen
     jr   nz, movePlayerRightCont2 ; If not, continue to move the player right
     inc  hl                       ; Move to the 3rd byte of player config
     inc  hl                       ; Move to the 4th byte of player config
     res  $04, (hl)                ; Clear bit 4 to indicate the player is no longer active
     jr   movePlayerEnd
     movePlayerRightCont2:
     add  a, $01                   ; Move player right by incrementing the column number
     ld   b, a                     ; Store new column number in B
     ld   a, (hl)                  ; Load 2nd byte of player config into A again
     and  $e0                      ; Mask with 11100000 to get the line number
     or   b                        ; Combine line number with new column number
     ld   (hl), a                  ; Write updated column and line number back to 2nd byte of player config
     jr   movePlayerEnd
     movePlayerRightCont:
     rrca                          ; Rotate right to move the player's position to the right
     ld   (hl), a                  ; Write updated player position back to 3rd byte of player config
     jr   movePlayerEnd

     movePlayerUpDown:
     dec  hl                       ; Move to the 3rd byte of player config
     dec  hl                       ; Move to the 2nd byte of player config
     ld   c, (hl)                  ; Load the 2nd byte of player config into C
     dec  hl                       ; Move to the 1st byte of player config
     ld   b, (hl)                  ; Load the 1st byte of player config into B
     bit  $02, a                   ; Check if bit 2 is active (moving up)
     jr   nz, movePlayerUp         ; If bit 2 is active, jump to movePlayerUp
     call NextScan                 ; Move to the next scan line
     ld   a, b                     ; Load 1st byte of player config into A
     and  $18                      ; Mask with 00011000b to get the screen Third
     cp   $10                      ; Compare with 00010000b to see if we are in the third Third
     jr   nz, movePlayerUpDownCont ; If zero, jump to close out of the routine
     ld   a, c                     ; Load 2nd byte of player config into A
     and  $e0                      ; Mask with 11100000b to get the Line number
     cp   $a0                      ; Compare with 10100000b to see if we are on Line 5
     jr   z, movePlayerUpDownCrash ; If zero, jump to indicate the player is no longer active
     jr   movePlayerUpDownCont

     movePlayerUp:
     call PreviousScan             ; Move to the previous scan line
     ld   a, b                     ; Load 1st byte of player config into A
     and  $18                      ; Mask with 00011000b to get the screen Third
     jr   nz, movePlayerUpDownCont ; If not zero, jump to close out of the routine
     ld   a, c                     ; Load 2nd byte of player config into A
     and  $e0                      ; Mask with 11100000b to get the Line number
     jr   nz, movePlayerUpDownCont ; If not zero, jump to close out of the routine
     movePlayerUpDownCrash:
     inc  hl                       ; Move to the 2nd byte of player config
     inc  hl                       ; Move to the 3rd byte of player config
     inc  hl                       ; Move to the 4th byte of player config
     res  $04, (hl)                ; Clear bit 4 to indicate the player is no longer active
     dec  hl                       ; Move to the 3rd byte of player config
     dec  hl                       ; Move to the 2nd byte of player config
     dec  hl                       ; Move to the 1st byte of player config

     movePlayerUpDownCont:
     ld   (hl), b                  ; Write updated 1st byte of player config
     inc  hl                       ; Move to the 2nd byte of player config
     ld   (hl), c                  ; Write updated 2nd byte of player config

     movePlayerEnd:
ret

; -------------------------------------------------------------------
; Checks if a player has collided with something in the game arena
; Input: A  = Video memory byte for player's position
;        HL = Address for 3rd byte of player config
; Alters the value of registers: DE
; -------------------------------------------------------------------
CheckCollision:
     push af                       ; Preserve A
     ld   d, (hl)                  ; Load D with 3rd byte of player config
     and  d                        ; AND with A (video memory byte of player's position)
     jr   z, CheckCollisionEnd     ; If 0, there is no collision
     inc  hl                       ; Move to the 4th byte of player config
     res  $04, (hl)                ; Clear bit 4 to indicate the player has collided and is no longer active
     dec  hl                       ; Move to the 3rd byte of player config
     CheckCollisionEnd:
     pop  af                       ; Retrieve A
ret

; -------------------------------------------------------------------
; Checks if a player is still active
; Input: HL = Player config (at byte 4)
; Alters the value of registers: HL
; -------------------------------------------------------------------
CheckPlayers:
     ld   hl, player1config + $03  ; Load address of 4th byte of player 1 config to HL
     bit  $04, (hl)                ; Check if bit 4 is active (player is alive)
     jr   nz, checkPlayer2         ; If alive, check player 2
     ;call DisplayPlayerDeath       ; Display player 1 death animation
     ld   hl, player2score
     jr   checkPlayersCont
     checkPlayer2:
     ld   hl, player2config + $03  ; Load address of 4th byte of player 2 config to HL
     bit  $04, (hl)                ; Check if bit 4 is active (player is alive)
     ret  nz                       ; If alive, exit
     ;call DisplayPlayerDeath       ; Display player 2 death animation
     ld   hl, player1score
     checkPlayersCont:
     inc  (hl)                     ; Increment player score
     call PrintScores
jp   mainRestart


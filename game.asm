; -------------------------------------------------------------------
; Changes the position of both players
; Input: none
; Alters the value of registers: AF, HL 
; -------------------------------------------------------------------
MovePlayers:
     ld   hl, player1config + 3
     ;call MovePlayer
     ld   hl, player2config + 3
     call MovePlayer
ret

; -------------------------------------------------------------------
; Changes the position of a player
; Input: HL = Player config (at byte 4)
; Alters the value of registers: AF, DE, HL 
; -------------------------------------------------------------------
MovePlayer:
     ld   a, (hl)                  ; Load 4th byte of player config into A
     bit  4, a                     ; Check if bit 4 is active (alive)
     ret  z                        ; If zero, player is not active so exit
     cp   %00011000                ; Check if bit 3 is active (moving down)
     jr   z, movePlayerUpDown
     cp   %00010100                ; Check if bit 2 is active (moving up)
     jr   z, movePlayerUpDown
     cp   %00010010                ; Check if bit 1 is active (moving right)
     jr   z, movePlayerRight

     ;movePlayerLeft               ; Bit 0 is active (moving left)
     dec  hl                       ; Move to the 3rd byte of player config
     ld   a, (hl)                  ; Load value into A
     cp   %10000000                ; Check if the player is at the left edge of the byte
     jr   nz, movePlayerLeftCont   ; If not, continue to move the player left
     ld   a, %00000001             ; Move the player's position to the right of the next byte
     ld   (hl), a                  ; Write updated value back to 3rd byte of player config
     dec  hl                       ; Move to the 2nd byte of player config
     ld   a, (hl)                  ; Load value into A
     and  %00011111                ; Mask to get the column number
     dec  a                        ; Move player left by decrementing the column number
     ld   d, a                     ; Store new column number in D
     ld   a, (hl)                  ; Load 2nd byte of player config into A again
     and  %11100000                ; Mask to get the line number
     or   d                        ; Combine line number with new column number
     ld   (hl), a                  ; Write updated column and line number back to 2nd byte of player config
     ret
     movePlayerLeftCont:
     rlca                          ; Rotate left to move the player's position to the left
     ld   (hl), a                  ; Write updated player position back to 3rd byte of player config
     ret

     movePlayerRight:
     dec  hl                       ; Move to the 3rd byte of player config
     ld   a, (hl)                  ; Load value into A
     cp   %00000001                ; Check if the player is at the right edge of the byte
     jr   nz, movePlayerRightCont  ; If not, continue to move the player right
     ld   a, %10000000             ; Move the player's position to the left of the next byte
     ld   (hl), a                  ; Write updated value back to 3rd byte of player config
     dec  hl                       ; Move to the 2nd byte of player config
     ld   a, (hl)                  ; Load value into A
     and  %00011111                ; Mask to get the column number
     inc  a                        ; Move player right by incrementing the column number
     ld   d, a                     ; Store new column number in D
     ld   a, (hl)                  ; Load 2nd byte of player config into A again
     and  %11100000                ; Mask to get the line number
     or   d                        ; Combine line number with new column number
     ld   (hl), a                  ; Write updated column and line number back to 2nd byte of player config
     ret
     movePlayerRightCont:
     rra                           ; Rotate right to move the player's position to the right
     ld   (hl), a                  ; Write updated player position back to 3rd byte of player config
     ret

     movePlayerUpDown:
     dec  hl                       ; Move to the 3rd byte of player config
     dec  hl                       ; Move to the 2nd byte of player config
     ld   e, (hl)                  ; Load the 2nd byte of player config into E
     dec  hl                       ; Move to the 1st byte of player config
     ld   d, (hl)                  ; Load the 1st byte of player config into D
     bit  2, a                     ; Check if bit 2 is active (moving up)
     jr   nz, movePlayerUp         ; If bit 2 is active, jump to movePlayerUp
     ;movePlayerDown
     call NextScan                 ; Move to the next scan line
     ld   a, d                     ; Load 1st byte of player config into A
     and  %00011000                ; Mask to get the screen Third
     cp   %00010000                ; See if we are in the third Third
     jr   nz, movePlayerUpDownCont ; If zero, jump to close out of the routine
     ld   a, e                     ; Load 2nd byte of player config into A
     and  %11100000                ; Mask to get the line number
     cp   %10100000                ; See if we are on Line 5
     jr   z, movePlayerUpDownCrash ; If zero, jump to indicate the player is no longer active
     jr   movePlayerUpDownCont
     movePlayerUp:
     call PreviousScan             ; Move to the previous scan line
     ld   a, d                     ; Load 1st byte of player config into A
     and  %00011000                ; Mask to get the screen Third
     jr   nz, movePlayerUpDownCont ; If not zero, jump to close out of the routine
     ld   a, e                     ; Load 2nd byte of player config into A
     and  %11100000                ; Mask to get the line number
     jr   nz, movePlayerUpDownCont ; If not zero, jump to close out of the routine
     movePlayerUpDownCrash:
     inc  hl                       ; Move to the 2nd byte of player config
     inc  hl                       ; Move to the 3rd byte of player config
     inc  hl                       ; Move to the 4th byte of player config
     res  4, (hl)                  ; Clear bit 4 to indicate the player is no longer active
     dec  hl                       ; Move to the 3rd byte of player config
     dec  hl                       ; Move to the 2nd byte of player config
     dec  hl                       ; Move to the 1st byte of player config
     movePlayerUpDownCont:
     ld   (hl), d                  ; Write updated 1st byte of player config
     inc  hl                       ; Move to the 2nd byte of player config
     ld   (hl), e                  ; Write updated 2nd byte of player config
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
     res  4, (hl)                  ; Clear bit 4 to indicate the player has collided and is no longer active
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
     ;checkPlayer1
     ld   hl, player1config + 3    ; Load address of 4th byte of player 1 config to HL
     bit  4, (hl)                  ; Check if bit 4 is active (player is alive)
     jr   nz, checkPlayer2         ; If alive, check player 2
     call DisplayCollision         ; Display player 1 death animation
     ld   hl, player2score         ; Load memory address of player 2's score
     jr   checkPlayersCont
     checkPlayer2:
     ld   hl, player2config + 3    ; Load address of 4th byte of player 2 config to HL
     bit  4, (hl)                  ; Check if bit 4 is active (player is alive)
     ret  nz                       ; If alive, exit
     call DisplayCollision         ; Display player 2 death animation
     ld   hl, player1score         ; Load memory address of player 1's score
     checkPlayersCont:
     inc  (hl)                     ; Increment player score
     call PrintScores              ; Update the score display
jp   mainRestartMatch

; -------------------------------------------------------------------
; Checks if either player has won the game (won 5 matches)
; Input: none
; Alters the value of registers: AF, HL
; -------------------------------------------------------------------
CheckScores:
     ld   hl, player1score         ; Load memory address of player 1's score
     ld   a, (hl)                  ; Load player 1's score into A
     cp   5                        ; Compare with 5d
     jr   z, CheckScoresEnd        ; If 5, then jump
     ;CheckScoresP2
     ld   hl, player2score         ; Load memory address of player 2's score
     ld   a, (hl)                  ; Load player 2's score into A
     cp   5                        ; Compare with 5d
     ret  nz                      ; If not 5, then exit
     CheckScoresEnd:
     call PrintEndGameScreen
jp   mainRestartGame

; -------------------------------------------------------------------
; Checks whether each player player has pressed a control
; Input: none
; Alters the value of registers: none 
; -------------------------------------------------------------------
CheckControls:
     call CheckCtrlP1
     call CheckCtrlP2
ret

; -------------------------------------------------------------------
; Evaluates whether player 1 has pressed a joystick direction
; Input: none
; Output: D (direction pressed) Bit 0 = Left, Bit 1 = Right, Bit 2 = Up, Bit 3 = Down
; Alters the value of registers: AF, DE, HL
; -------------------------------------------------------------------
CheckCtrlP1:
     ld   hl, player1config + 3    ; Load address of 4th byte of player 1 config to HL
     ld   d, 0                     ; Clear D to store the key pressed
     in   a, (31)                  ; Read port 31
     ;checkCtrlP1Right
     rra                           ; Rotate A to check if right was pressed
     jr   nc, checkCtrlP1Left      ; No carry, not pressed, skip
     bit  0, (hl)                  ; Check to see if the player is currently travelling left
     ret  nz                      ; If not zero, player is currently travelling left so we can't go right
     set  1, d                     ; Set bit 1 = right
     jr   checkCtrlP1Cont
     checkCtrlP1Left:
     rra                           ; Rotate A to check if left was pressed
     jr   nc, checkCtrlP1Down      ; No carry, not pressed, skip
     bit  1, (hl)                  ; Check to see if the player is currently travelling right
     ret  nz                      ; If not zero, player is currently travelling right so we can't go left
     set  0, d                     ; Set bit 0 = left
     jr   checkCtrlP1Cont
     checkCtrlP1Down:
     rra                           ; Rotate A to check if down was pressed
     jr   nc, checkCtrlP1Up        ; No carry, not pressed, skip
     bit  2, (hl)                  ; Check to see if the player is currently travelling up
     ret  nz                      ; If not zero, player is currently travelling up so we can't go down
     set  3, d                     ; Set bit 3 = down
     jr   checkCtrlP1Cont
     checkCtrlP1Up:
     rra                           ; Rotate A to check if up was pressed
     ret  nc                      ; No carry, no direction pressed, exit
     bit  3, (hl)                  ; Check to see if the player is currently travelling down
     ret  nz                      ; If not zero, player is currently travelling down so we can't go up
     set  2, d                     ; Set bit 2 = up
     checkCtrlP1Cont:
     ld   a, d                     ; Load A with the direction pressed value
     and  a                        ; Compare with 0 to check if no direction was pressed
     ret  z                       ; If no direction was pressed, jump to end
     ld   a, (hl)                  ; Load the 4th byte of player config into A
     and  %11110000                ; Mask to clear the lower nibble
     or   d                        ; Combine with the key pressed value in D
     ld   (hl), a                  ; Write updated value back to 4th byte of player config
ret

; -------------------------------------------------------------------
; Evaluates whether player 2 has pressed a direction
;  Key O -> Left
;  Key P -> Right
;  Key Q -> Up
;  Key A -> Down
; Input: none
; Output: D (key pressed) Bit 0 = Left, Bit 1 = Right, Bit 2 = Up, Bit 3 = Down
; Alters the value of registers: AF, DE, HL
; -------------------------------------------------------------------
CheckCtrlP2:
     ld   hl, player2config + 3    ; Load address of 4th byte of player 2 config to HL
     ld   d, 0                     ; Clear D to store the key pressed
     ld   a, $df                   ; Load A with half-stack for keys P-Y
     in   a, ($fe)                 ; Read keyboard
     ;checkCtrlP2Left
     bit  1, a                     ; Check if bit 1 is 0 (key O pressed)
     jr   nz, checkCtrlP2Right     ; Z=1, not pressed, skip
     bit  1, (hl)                  ; Check to see if the player is currently travelling right
     ret  nz                      ; If not zero, player is currently travelling right so we can't go left
     set  0, d                     ; Z=0, set bit 0 = left
     jr   checkCtrlP2Cont
     checkCtrlP2Right:
     bit  0, a                     ; Check if bit 0 is 0 (key P pressed)
     jr   nz, checkCtrlP2Up        ; Z=1, not pressed, skip
     bit  0, (hl)                  ; Check to see if the player is currently travelling left
     ret  nz                      ; If not zero, player is currently travelling left so we can't go right
     set  1, d                     ; Z=0, set bit 1 = right
     jr   checkCtrlP2Cont
     checkCtrlP2Up:
     ld   a, $fb                   ; Load A with half-stack for keys Q-T
     in   a, ($fe)                 ; Read keyboard
     bit  0, a                     ; Check if bit 0 is 0 (key Q pressed)
     jr   nz, checkCtrlP2Down      ; Z=1, not pressed, skip
     bit  3, (hl)                  ; Check to see if the player is currently travelling down
     ret  nz                      ; If not zero, player is currently travelling down so we can't go up
     set  2, d                     ; Z=0, set bit 2 = up
     jr   checkCtrlP2Cont
     checkCtrlP2Down:
     ld   a, $fd                   ; Load A with half-stack for keys A-G
     in   a, ($fe)                 ; Read keyboard
     bit  0, a                     ; Check if bit 0 is 0 (key A pressed)
     ret  nz                      ; Z=1, not pressed, skip
     bit  2, (hl)                  ; Check to see if the player is currently travelling up
     ret  nz                      ; If not zero, player is currently travelling up so we can't go down
     set  3, d                     ; Z=0, set bit 3 = down
     checkCtrlP2Cont:
     ld   a, d                     ; Load A with the key pressed value
     and  a                        ; Compare with 0 to check if no key was pressed
     ret  z                       ; If no key was pressed, jump to end
     ld   a, (hl)                  ; Load the 4th byte of player config into A
     and  %11110000                ; Mask to clear the lower nibble
     or   d                        ; Combine with the key pressed value in D
     ld   (hl), a                  ; Write updated value back to 4th byte of player config
ret

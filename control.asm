; TODO: test Kempston controls

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
     ld   hl, player1config + $03  ; Load address of 4th byte of player 1 config to HL
     ld   d, $00                   ; Clear D to store the key pressed
     in   a, ($1f)                 ; Read port 31 (1fh)
     ;checkCtrlP1Right
     rra                           ; Rotate A to check if right was pressed
     jr   nc, checkCtrlP1Left      ; No carry, not pressed, skip
     bit  $00, (hl)                ; Check to see if the player is currently travelling left
     jr   nz, checkCtrlP1End       ; If not zero, player is currently travelling left so we can't go right
     set  $01, d                   ; Set bit 1 = right
     jr   checkCtrlP1Cont
     checkCtrlP1Left:
     rra                           ; Rotate A to check if left was pressed
     jr   nz, checkCtrlP1Down      ; No carry, not pressed, skip
     bit  $01, (hl)                ; Check to see if the player is currently travelling right
     jr   nz, checkCtrlP1End       ; If not zero, player is currently travelling right so we can't go left
     set  $00, d                   ; Set bit 0 = left
     jr   checkCtrlP1Cont
     checkCtrlP1Down:
     rra                           ; Rotate A to check if down was pressed
     jr   nz, checkCtrlP1Up        ; No carry, not pressed, skip
     bit  $02, (hl)                ; Check to see if the player is currently travelling up
     jr   nz, checkCtrlP1End       ; If not zero, player is currently travelling up so we can't go down
     set  $03, d                   ; Set bit 3 = down
     jr   checkCtrlP1Cont
     checkCtrlP1Up:
     rra                           ; Rotate A to check if up was pressed
     jr   nz, checkCtrlP1End       ; No carry, not pressed, skip
     bit  $03, (hl)                ; Check to see if the player is currently travelling down
     jr   nz, checkCtrlP1End       ; If not zero, player is currently travelling down so we can't go up
     set  $02, d                   ; Set bit 2 = up
     checkCtrlP1Cont:
     ld   a, d                     ; Load A with the direction pressed value
     cp   $00                      ; Compare with 0 to check if no key was pressed
     jr   z, checkCtrlP1End        ; If no key was pressed, jump to end
     ld   a, (hl)                  ; Load the 4th byte of player config into A
     and  $f0                      ; Mask with 11110000b to clear the lower nibble
     or   d                        ; Combine with the key pressed value in D
     ld   (hl), a                  ; Write updated value back to 4th byte of player config
     checkCtrlP1End:
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
     ld   hl, player2config + $03  ; Load address of 4th byte of player 2 config to HL
     ld   d, $00                   ; Clear D to store the key pressed
     ld   a, $df                   ; Load A with half-stack for keys P-Y
     in   a, ($fe)                 ; Read keyboard
     ;checkCtrlP2Left
     bit  $01, a                   ; Check if bit 1 is 0 (key O pressed)
     jr   nz, checkCtrlP2Right     ; Z=1, not pressed, skip
     bit  $01, (hl)                ; Check to see if the player is currently travelling right
     jr   nz, checkCtrlP2End       ; If not zero, player is currently travelling right so we can't go left
     set  $00, d                   ; Z=0, set bit 0 = left
     jr   checkCtrlP2Cont
     checkCtrlP2Right:
     bit  $00, a                   ; Check if bit 0 is 0 (key P pressed)
     jr   nz, checkCtrlP2Up        ; Z=1, not pressed, skip
     bit  $00, (hl)                ; Check to see if the player is currently travelling left
     jr   nz, checkCtrlP2End       ; If not zero, player is currently travelling left so we can't go right
     set  $01, d                   ; Z=0, set bit 1 = right
     jr   checkCtrlP2Cont
     checkCtrlP2Up:
     ld   a, $fb                   ; Load A with half-stack for keys Q-T
     in   a, ($fe)                 ; Read keyboard
     bit  $00, a                   ; Check if bit 0 is 0 (key Q pressed)
     jr   nz, checkCtrlP2Down      ; Z=1, not pressed, skip
     bit  $03, (hl)                ; Check to see if the player is currently travelling down
     jr   nz, checkCtrlP2End       ; If not zero, player is currently travelling down so we can't go up
     set  $02, d                   ; Z=0, set bit 2 = up
     jr   checkCtrlP2Cont
     checkCtrlP2Down:
     ld   a, $fd                   ; Load A with half-stack for keys A-G
     in   a, ($fe)                 ; Read keyboard
     bit  $00, a                   ; Check if bit 0 is 0 (key A pressed)
     jr   nz, checkCtrlP2End       ; Z=1, not pressed, skip
     bit  $02, (hl)                ; Check to see if the player is currently travelling up
     jr   nz, checkCtrlP2End       ; If not zero, player is currently travelling up so we can't go down
     set  $03, d                   ; Z=0, set bit 3 = down
     checkCtrlP2Cont:
     ld   a, d                     ; Load A with the key pressed value
     cp   $00                      ; Compare with 0 to check if no key was pressed
     jr   z, checkCtrlP2End        ; If no key was pressed, jump to end
     ld   a, (hl)                  ; Load the 4th byte of player config into A
     and  $f0                      ; Mask with 11110000b to clear the lower nibble
     or   d                        ; Combine with the key pressed value in D
     ld   (hl), a                  ; Write updated value back to 4th byte of player config
     checkCtrlP2End:
ret

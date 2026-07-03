; -------------------------------------------------------------------
; Evaluates whether a direction has been pressed
;  Key O -> Left
;  Key P -> Right
;  Key Q -> Up
;  Key A -> Down
; Return: D (key pressed)
; -------------------------------------------------------------------
;  Bit 0  | Bit 1  | Bit 2  | Bit 3
; -------------------------------------------------------------------
;  Left   | Right  | Up     | Down
; -------------------------------------------------------------------
; Alters the value of registers: AF, DE, HL
; -------------------------------------------------------------------
CheckCtrlP1:
     ld   hl, player1config + $03  ; Load address of 4th byte of player 1 config to HL
     ld   d, $00                   ; Clear D to store the key pressed
     ld   a, $df                   ; Load A with half-stack for keys P-Y
     in   a, ($fe)                 ; Read keyboard
     checkCtrlP1Left:
     bit  $01, a                   ; Check if bit 1 is 0 (key O pressed)
     jr   nz, checkCtrlP1Right     ; Z=1, not pressed, skip
     bit  $01, (hl)                ; Check to see if the player is currently travelling right
     jr   nz, checkCtrlP1End       ; If not zero, player is currently travelling right so we can't go left
     set  $00, d                   ; Z=0, set bit 0 = left
     jr   checkCtrlP1Cont
     checkCtrlP1Right:
     bit  $00, a                   ; Check if bit 0 is 0 (key P pressed)
     jr   nz, checkCtrlP1Up        ; Z=1, not pressed, skip
     bit  $00, (hl)                ; Check to see if the player is currently travelling left
     jr   nz, checkCtrlP1End       ; If not zero, player is currently travelling left so we can't go right
     set  $01, d                   ; Z=0, set bit 1 = right
     jr   checkCtrlP1Cont
     checkCtrlP1Up:
     ld   a, $fb                   ; Load A with half-stack for keys Q-T
     in   a, ($fe)                 ; Read keyboard
     bit  $00, a                   ; Check if bit 0 is 0 (key Q pressed)
     jr   nz, checkCtrlP1Down      ; Z=1, not pressed, skip
     bit  $03, (hl)                ; Check to see if the player is currently travelling down
     jr   nz, checkCtrlP1End       ; If not zero, player is currently travelling down so we can't go up
     set  $02, d                   ; Z=0, set bit 2 = up
     jr   checkCtrlP1Cont
     checkCtrlP1Down:
     ld   a, $fd                   ; Load A with half-stack for keys A-G
     in   a, ($fe)                 ; Read keyboard
     bit  $00, a                   ; Check if bit 0 is 0 (key A pressed)
     jr   nz, checkCtrlP1End       ; Z=1, not pressed, skip
     bit  $02, (hl)                ; Check to see if the player is currently travelling up
     jr   nz, checkCtrlP1End       ; If not zero, player is currently travelling up so we can't go down
     set  $03, d                   ; Z=0, set bit 3 = down
     checkCtrlP1Cont:
     ld   a, d                     ; Load A with the key pressed value
     cp   $00                      ; Compare with 0 to check if no key was pressed
     jr   z, checkCtrlP1End        ; If no key was pressed, jump to checkCtrlP1End
     ld   a, (hl)                  ; Load the 4th byte of player config into A
     and  $f0                      ; Mask with 11110000b to clear the lower nibble
     or   d                        ; Combine with the key pressed value in D
     ld   (hl), a                  ; Write updated value back to 4th byte of player config
     checkCtrlP1End:
ret                           ; Exits

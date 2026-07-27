; -------------------------------------------------------------------
; Reset's both player's configs and time after end of match
; Input: none
; Alters the value of registers: IX
; -------------------------------------------------------------------
ResetMatch:
     ld   ix, player1config
     ld   (ix),     %01001101
     ld   (ix + 1), %01000111
     ld   (ix + 2), %10000000
     ld   (ix + 3), %00010010
     ld   ix, player2config
     ld   (ix),     %01001101
     ld   (ix + 1), %01011000
     ld   (ix + 2), %00000001
     ld   (ix + 3), %00010001
     ld   ix, timer
     ld   (ix), 0
ret

; -------------------------------------------------------------------
; Reset's both player's scores after end of game
; Input: none
; Alters the value of registers: IX
; -------------------------------------------------------------------
ResetGame:
     ld   ix, player1score
     ld   (ix), 0
     ld   (ix + 1), 0
ret

; -------------------------------------------------------------------
; Wait for twenty-five interrupts
; Input: none
; Alters the value of registers: BC
; -------------------------------------------------------------------
Sleep:
     ld   b, 25                ; Load B with 25
     sleepLoop:
          halt                  ; Wait for an interrupt
     djnz sleepLoop            ; Loop until B = 0
ret

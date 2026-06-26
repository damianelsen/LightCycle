; -------------------------------------------------------------------
; Position the cursor at the specified coordinates
; Input: B = Y-coordinate (24 to 3)
;        C = X-coordinate (32 to 1)
; Alters the value of registers: AF
; -------------------------------------------------------------------
At:
     push bc
     exx
     pop bc
     call SET_CURSOR
     exx
ret

; -------------------------------------------------------------------
; Sets the ink color for printing
; Input: A = ink color
; Alters the value of registers: AF
; -------------------------------------------------------------------
Ink:
     exx
     ld   b, a
     ld   a, (ATTR_TEMP)      ; Load temporary color attributes into A
     and  $f8                 ; Mask with 11111000 to remove ink color
     or   b                   ; Add ink color provided in B
     ld   (ATTR_TEMP), a      ; Save new temporary color attributes in memory
     exx
ret

; -------------------------------------------------------------------
; Prints a string of characters to the screen, terminated with $ff
; Input: HL = address of the first character of the string
; Alters the value of registers: AF, HL
; -------------------------------------------------------------------
PrintString:
     ld   a, (hl)
     cp   $ff
     ret  z
     rst  $10
     inc  hl
     jr   PrintString
ret

; -------------------------------------------------------------------
; Paints numbers in BCD format
; Input: HL -> Pointer to number to be painted
; Alters the value of registers: AF
; -------------------------------------------------------------------
PrintBCD:
     ; ld   a, (hl)               ; Load A with number to be displayed
     ; and  $f0                   ; Mask A with 11110000 to get the tens digit
     ; rra
     ; rra
     ; rra
     ; rra                        ; Moves the tens digit to bits 0 to 3
     ; add  a, '0'                ; Convert to ASCII character
     ; rst  $10                   ; Display the tens digit
     ld   a, (hl)               ; Load A with number to be displayed again
     and  $0f                   ; Mask A with 00001111 to get the units digit
     add  a, '0'                ; Convert to ASCII character
     rst  $10                   ; Display the units digit
ret

; -------------------------------------------------------------------
; Paint the frame of the screen
; Input: none
; Alters the value of registers: AF, BC, HL 
; -------------------------------------------------------------------
PrintFrame:
     ld   hl, frameTopGraph
     call PrintString
     ld   hl, frameBottomGraph
     call PrintString
     ld   b, OFFSET_Y - $01             ; Start at row 1
     printFrameLoop:
          ld   c, OFFSET_X - $00        ; Column 0
          call At
          ld   a, $93                   ; Paint left border   
          rst  $10
          ld   c, OFFSET_X - $1f        ; Column 31
          call At
          ld   a, $94                   ; Paint right border
          rst  $10
          dec  b
          ld   a, b
          cp   $03
     jr   nz, printFrameLoop
ret

; -------------------------------------------------------------------
; Clear the play area
; Input: none
; Alters the value of registers: AF, BC, HL
; -------------------------------------------------------------------
ClearArena:
     ld   b, OFFSET_Y - $01             ; Start at row 1
     clearArenaLoop:
          ld   c, OFFSET_X - $01        ; Column 1
          call At
          ld   hl, blankLine
          call PrintString
          dec  b
          ld   a, b
          cp   $03
     jr   nz, clearArenaLoop
ret

; -------------------------------------------------------------------
; Prints the game information labels
; Input: none
; Alters the value of registers: AF, HL 
; -------------------------------------------------------------------
PrintInfoLabels:
     ld   a, $01                ; A = 1
     call OPENCHAN              ; Activates channel 1
     ld   hl, infoGame          ; HL = address string titles
     call PrintString           ; Paints titles
     ld   a, $02                ; A = 2
     call OPENCHAN              ; Activates channel 2
ret

; -------------------------------------------------------------------
; Prints the current scores
; Input: none
; Alters the value of registers: AF, BC, HL 
; -------------------------------------------------------------------
PrintScores:
     ld   a, $01              ; A = 1
     call OPENCHAN            ; Activate channel 1
     ld   bc, $1720           ; Load B with Y-coordinate for score display = 17h = 23d, C with X-coordinate = 20h = 32d
     call At                  ; Position cursor at (23, 32)
     ld   hl, player1score    ; Load player 1 score
     call PrintBCD            ; Update score display
     ld   bc, $1701           ; Load B with Y-coordinate for score display = 17h = 23d, C with X-coordinate = 01h = 1d
     call At                  ; Position cursor at (23, 1)
     ld   hl, player2score    ; Load player 2 score
     call PrintBCD            ; Update score display
     ld   a, $02              ; A = 2
     call OPENCHAN            ; Activate channel 2
ret

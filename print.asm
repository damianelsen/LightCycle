; -------------------------------------------------------------------
; Position the cursor at the specified coordinates
; Input: B = Y-coordinate (24 to 3)
;        C = X-coordinate (32 to 1)
; Alters the value of registers: none
; -------------------------------------------------------------------
At:
     push bc                  ; Preserve BC
     exx                      ; Swap all registers
     pop bc                   ; Retrieve BC
     call SET_CURSOR          ; Set cursor to desired position
     exx                      ; Swap all registers back
ret

; -------------------------------------------------------------------
; Sets the ink color for printing
; Input: A = ink color
; Alters the value of registers: AF, BC
; -------------------------------------------------------------------
; Ink:
;      exx                      ; Swap all registers
;      ld   b, a                ; Load ink color into B
;      ld   a, (ATTR_TEMP)      ; Load temporary color attributes into A
;      and  %11111000           ; Mask to remove ink color
;      or   b                   ; Add ink color
;      ld   (ATTR_TEMP), a      ; Save new temporary color attributes in memory
;      exx                      ; Swap all registers back
; ret

; -------------------------------------------------------------------
; Prints a string of characters to the screen, terminated with $ff
; Input: HL = address of the first character of the string
; Alters the value of registers: AF, HL
; -------------------------------------------------------------------
PrintString:
     ld   a, (hl)             ; Load first character of string to print into A
     cp   $ff                 ; Compare with string terminator
     ret  z                   ; If zero, exit
     rst  16                  ; Print character to screen
     inc  hl                  ; Move to next character
     jr   PrintString         ; Loop
ret

; -------------------------------------------------------------------
; Prints numbers in BCD format
; Input: HL = address of number to be printed
; Alters the value of registers: AF
; -------------------------------------------------------------------
PrintBCD:
     ld   a, (hl)             ; Load A with number to be displayed
     and  %11110000           ; Mask A to get the tens digit
     rra
     rra
     rra
     rra                      ; Moves the tens digit to bits 0 to 3
     add  a, '0'              ; Convert to ASCII character
     rst  16                  ; Display the tens digit
     ld   a, (hl)             ; Load A with number to be displayed again
     and  %00001111           ; Mask A to get the units digit
     add  a, '0'              ; Convert to ASCII character
     rst  16                  ; Display the units digit
ret

; -------------------------------------------------------------------
; Prints a single number in BCD format
; Input: HL = address of number to be printed
; Alters the value of registers: AF
; -------------------------------------------------------------------
PrintBCDSingle:
     ld   a, (hl)               ; Load A with number to be displayed again
     and  $0f                   ; Mask A with 00001111 to get the units digit
     add  a, '0'                ; Convert to ASCII character
     rst  16                  ; Display the units digit
ret

; -------------------------------------------------------------------
; Prints the screen backgtound
; Input: none
; Alters the value of registers: AF, BC, HL 
; -------------------------------------------------------------------
PrintBackground:
     call CLS
     ld   hl, backgroundHeader
     call PrintString
     ld   b, OFFSET_Y - 1          ; Start at row 1
     ld   c, OFFSET_X - 0          ; Column 0
     printBackgroundLoop:
          call At
          ld   hl, backgroundRow
          call PrintString
          dec  b
          ld   a, b
          cp   2                   ; Stop at line 2
     jr   nz, printBackgroundLoop
     ld   a, 1                     ; A = 1
     call OPENCHAN                 ; Activates channel 1
     ld   hl, backgroundFooter
     call PrintString
     ld   a, 2                     ; A = 2
     call OPENCHAN                 ; Activates channel 2
ret

; -------------------------------------------------------------------
; Prints the main screen
; Input: none
; Alters the value of registers: AF, HL
; -------------------------------------------------------------------
PrintMainScreen:
     call PrintBackground
     ld   hl, mainScreen1     ; HL = address string
     call PrintString         ; Paints string
     ld   a, 1                ; A = 1
     call OPENCHAN            ; Activates channel 1
     ld   hl, mainScreen2     ; HL = address string
     call PrintString         ; Paints string
     ld   a, 2                ; A = 2
     call OPENCHAN            ; Activates channel 2
     printMainScreenLoop:
          ld   a, $bf         ; Load A with half-stack for keys ENTER-H
          in   a, ($fe)       ; Read keyboard
          bit  $00, a         ; Check if bit 0 is 0 (ENTER key pressed)
     jr   nz, printMainScreenLoop
ret

; -------------------------------------------------------------------
; Prints the frame of the screen
; Input: none
; Alters the value of registers: AF, BC, HL 
; -------------------------------------------------------------------
PrintFrame:
     call CLS
     ld   hl, frameTopGraph
     call PrintString
     ld   hl, frameBottomGraph
     call PrintString
     ld   b, OFFSET_Y - 1          ; Start at row 1
     printFrameLoop:
          ld   c, OFFSET_X - 0     ; Column 0
          call At
          ld   a, $93              ; Paint left border   
          rst  16
          ld   c, OFFSET_X - 31    ; Column 31
          call At
          ld   a, $94              ; Paint right border
          rst  16
          dec  b
          ld   a, b
          cp   3                   ; Stop at line 3
     jr   nz, printFrameLoop
ret

; -------------------------------------------------------------------
; Clear the play area
; Input: none
; Alters the value of registers: AF, BC, HL
; -------------------------------------------------------------------
ClearArena:
     ld   b, OFFSET_Y - 1          ; Start at row 1
     clearArenaLoop:
          ld   c, OFFSET_X - 1     ; Column 1
          call At
          ld   hl, blankLine
          call PrintString         ; Prints string
          dec  b
          ld   a, b
          cp   3                   ; Stop at line 3
     jr   nz, clearArenaLoop
ret

; -------------------------------------------------------------------
; Prints the game information labels
; Input: none
; Alters the value of registers: AF, HL 
; -------------------------------------------------------------------
PrintInfoLabels:
     ld   a, 1                ; A = 1
     call OPENCHAN            ; Activates channel 1
     ld   hl, infoGame        ; HL = address info labels
     call PrintString         ; Prints string
     ld   a, 2                ; A = 2
     call OPENCHAN            ; Activates channel 2
ret

; -------------------------------------------------------------------
; Prints the current scores
; Input: none
; Alters the value of registers: AF, BC, HL 
; -------------------------------------------------------------------
PrintScores:
     ld   a, 1                ; A = 1
     call OPENCHAN            ; Activate channel 1
     ld   b, OFFSET_Y - 1     ; Row    = 1d
     ld   c, OFFSET_X - 0     ; Column = 0d
     call At                  ; Position cursor at (1, 0)
     ld   hl, player1score    ; Load player 1 score
     call PrintBCDSingle      ; Update score display
     ld   b, OFFSET_Y - 1     ; Row    =  1d
     ld   c, OFFSET_X - 31    ; Column = 31d
     call At                  ; Position cursor at (1, 31)
     ld   hl, player2score    ; Load player 2 score
     call PrintBCDSingle      ; Update score display
     ld   a, 2                ; A = 2
     call OPENCHAN            ; Activate channel 2
ret

; -------------------------------------------------------------------
; Prints the current match duration
; Input: none
; Alters the value of registers: AF, BC, HL 
; -------------------------------------------------------------------
PrintTime:
     ld   a, 1                ; A = 1
     call OPENCHAN            ; Activate channel 1
     ld   b, OFFSET_Y - 1     ; Row    =  1d
     ld   c, OFFSET_X - 15    ; Column = 15d
     call At                  ; Position cursor at (1, 15)
     ld   hl, timer           ; Load HL with memory address of match timer
     call PrintBCD            ; Update timer display
     ld   a, 2                ; A = 2
     call OPENCHAN            ; Activate channel 2
ret

; -------------------------------------------------------------------
; Prints the game over screen
; Input: none
; Alters the value of registers: AF, HL
; -------------------------------------------------------------------
PrintEndGameScreen:
     call PrintBackground
     ld   hl, endGameScreen   ; HL = address end game screen
     call PrintString         ; Paints end game screen
     ld   hl, player1score    ; Load address for player 1's score into HL
     ld   a, (hl)             ; Load player 1's score into A
     cp   5                   ; Compare with 5d
     jr   nz, printEndGameScreenP2
     ld   hl, player1name     ; Load player 1's name memory address into HL
     jr   printEndGameScreenCont
     printEndGameScreenP2:
     ld   hl, player2name     ; Load player 2's name memory address into HL
     printEndGameScreenCont:
     call PrintString         ; Paints winning player name
     printEndGameScreenLoop:
          ld   a, $bf         ; Load A with half-stack for keys ENTER-H
          in   a, ($fe)       ; Read keyboard
          bit  0, a           ; Check if bit 0 is 0 (ENTER key pressed)
          ret  z              ; If 0 (key pressed), then exit
          ld   a, $fe         ; Load A with half-stack for keys SHIFT-V
          in   a, ($fe)       ; Read keyboard
          bit  2, a           ; Check if bit 2 is 0 (X key pressed)
          jp   z, $0000       ; Reset the machine
     jr   printEndGameScreenLoop
ret

; -------------------------------------------------------------------
; Replacement character set UDGs
; -------------------------------------------------------------------
udgsChars:
db $FE, $FE, $FE, $FE, $FE, $FE, $FE, $00    ; $20 SPACE
db $FE, $EE, $EE, $EE, $FE, $EE, $FE, $00    ; $21 Exclamation Point
db $00, $00, $00, $00, $00, $00, $00, $00    ; $22
db $00, $00, $00, $00, $00, $00, $00, $00    ; $23
db $00, $00, $00, $00, $00, $00, $00, $00    ; $24
db $00, $00, $00, $00, $00, $00, $00, $00    ; $25
db $00, $00, $00, $00, $00, $00, $00, $00    ; $26
db $00, $00, $00, $00, $00, $00, $00, $00    ; $27
db $00, $00, $00, $00, $00, $00, $00, $00    ; $28
db $00, $00, $00, $00, $00, $00, $00, $00    ; $29
db $00, $00, $00, $00, $00, $00, $00, $00    ; $2A
db $00, $00, $00, $00, $00, $00, $00, $00    ; $2B
db $00, $00, $00, $00, $00, $00, $00, $00    ; $2C
db $00, $00, $00, $00, $00, $00, $00, $00    ; $2D
db $FE, $FE, $FE, $EE, $FE, $FE, $FE, $00    ; $2E Full Stop
db $00, $00, $00, $00, $00, $00, $00, $00    ; $2F
db $FE, $C6, $BA, $BA, $BA, $C6, $FE, $00    ; $30 Digit 0
db $FE, $EE, $EE, $EE, $EE, $EE, $FE, $00    ; $31 Digit 1
db $FE, $82, $FA, $82, $BE, $82, $FE, $00    ; $32 Digit 2
db $FE, $82, $FA, $82, $FA, $82, $FE, $00    ; $33 Digit 3
db $FE, $BE, $BE, $B6, $82, $F6, $FE, $00    ; $34 Digit 4
db $FE, $82, $BE, $82, $FA, $82, $FE, $00    ; $35 Digit 5
db $FE, $82, $BE, $82, $BA, $82, $FE, $00    ; $36 Digit 6
db $FE, $82, $FA, $FA, $FA, $FA, $FE, $00    ; $37 Digit 7
db $FE, $82, $BA, $82, $BA, $82, $FE, $00    ; $38 Digit 8
db $FE, $82, $BA, $82, $FA, $82, $FE, $00    ; $39 Digit 9
db $00, $00, $00, $00, $00, $00, $00, $00    ; $3A
db $00, $00, $00, $00, $00, $00, $00, $00    ; $3B
db $01, $04, $10, $40, $80, $20, $08, $02    ; $3C <
db $00, $00, $00, $00, $00, $00, $00, $00    ; $3D
db $80, $20, $08, $02, $01, $04, $10, $40    ; $3E >
db $00, $00, $00, $00, $00, $00, $00, $00    ; $3F
db $00, $00, $00, $00, $00, $00, $00, $00    ; $40
db $FE, $82, $BA, $82, $BA, $BA, $FE, $00    ; $41 Letter A
db $FE, $86, $BA, $86, $BA, $86, $FE, $00    ; $42 Letter B
db $FE, $82, $BE, $BE, $BE, $82, $FE, $00    ; $43 Letter C
db $FE, $86, $BA, $BA, $BA, $86, $FE, $00    ; $44 Letter D
db $FE, $82, $BE, $86, $BE, $82, $FE, $00    ; $45 Letter E
db $FE, $82, $BE, $86, $BE, $BE, $FE, $00    ; $46 Letter F
db $FE, $82, $BE, $B2, $BA, $82, $FE, $00    ; $47 Letter G
db $FE, $BA, $BA, $82, $BA, $BA, $FE, $00    ; $48 Letter H
db $FE, $82, $EE, $EE, $EE, $82, $FE, $00    ; $49 Letter I
db $FE, $FA, $FA, $FA, $BA, $C6, $FE, $00    ; $4A Letter J
db $FE, $BA, $B6, $8E, $B6, $BA, $FE, $00    ; $4B Letter K
db $FE, $BE, $BE, $BE, $BE, $82, $FE, $00    ; $4C Letter L
db $FE, $92, $AA, $AA, $BA, $BA, $FE, $00    ; $4D Letter M
db $FE, $BA, $9A, $AA, $B2, $BA, $FE, $00    ; $4E Letter N
db $FE, $82, $BA, $BA, $BA, $82, $FE, $00    ; $4F Letter O
db $FE, $86, $BA, $86, $BE, $BE, $FE, $00    ; $50 Letter P
db $FE, $82, $BA, $BA, $B2, $82, $FE, $00    ; $51 Letter Q
db $FE, $86, $BA, $86, $B6, $BA, $FE, $00    ; $52 Letter R
db $FE, $82, $BE, $82, $FA, $82, $FE, $00    ; $53 Letter S
db $FE, $82, $EE, $EE, $EE, $EE, $FE, $00    ; $54 Letter T
db $FE, $BA, $BA, $BA, $BA, $C6, $FE, $00    ; $55 Letter U
db $FE, $BA, $BA, $D6, $D6, $EE, $FE, $00    ; $56 Letter V
db $FE, $BA, $BA, $AA, $AA, $82, $FE, $00    ; $57 Letter W
db $FE, $BA, $D6, $EE, $D6, $BA, $FE, $00    ; $58 Letter X
db $FE, $BA, $BA, $D6, $EE, $EE, $FE, $00    ; $59 Letter Y
db $FE, $82, $F6, $EE, $DE, $82, $FE, $00    ; $5A Letter Z

; -------------------------------------------------------------------
; Main/Title screen backgrounds
; -------------------------------------------------------------------
backgroundHeader:
db 22, 0, 0                                  ; 22 = AT
db $84, $8C, $8C, $8C, $8C, $8C, $8C, $8C
db $8C, $8C, $8C, $8C, $8C, $8C, $8C, $8C
db $8C, $8C, $8C, $8C, $8C, $8C, $8C, $8C
db $8C, $8C, $8C, $8C, $8C, $8C, $8C, $88
db $ff                                       ; String terminator

backgroundRow:
db $85, '<><><><><><><><><><><><><><><>', $8A
db $ff                                       ; String terminator

backgroundFooter:
db 22, 0, 0                                  ; 22 = AT
db 16, 6                                     ; 16 = INK, 6 = Yellow
db $81, $83, $83, $83, $83, $83, $83, $83
db $83, $83, $83, $83, $83, $83, $83, $83
db $83, $83, $83, $83, $83, $83, $83, $83
db $83, $83, $83, $83, $83, $83, $83, $82
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; Main screen
; -------------------------------------------------------------------
mainScreen1:
db 22, 4, 10                                 ; 22 = AT
db 16, 5                                     ; 16 = INK, 5 = Cyan
db 'LIGHT.CYCLES'
db 22, 7, 3                                  ; 22 = AT
db 16, 4                                     ; 16 = INK, 4 = Green
db 'RIDE.YOUR.FUTURISTIC.LIGHT'
db 22, 8, 5                                  ; 22 = AT
db 'CYCLE.AROUND.THE.ARENA'
db 22, 9, 6                                  ; 22 = AT
db 'WHILST.DUELLING.WITH'
db 22, 10, 9                                 ; 22 = AT
db 'YOUR.OPPONENT'
db 22, 11, 4                                 ; 22 = AT
db 'AVOID.COLLIDING.WITH.THE'
db 22, 12, 5                                 ; 22 = AT
db 'WALLS.YOUR.OPPONENT.OR'
db 22, 13, 8                                 ; 22 = AT
db 'THE.LIGHT.TRAILS'
db 22, 14, 5                                 ; 22 = AT
db 'THE.FIRST.RIDER.TO.WIN'
db 22, 15, 3                                 ; 22 = AT
db 'FIVE.MATCHES.WINS.THE.GAME'
db 22, 18, 6                                 ; 22 = AT
db 16, 5                                     ; 16 = INK, 5 = Cyan
db 'PRESS.'
db 16, 6                                     ; 16 = INK, 6 = Yellow
db 'ENTER'
db 16, 5                                     ; 16 = INK, 5 = Cyan
db '.TO.START'
db $ff                                       ; String terminator

mainScreen2:
db 22, 1, 0                                  ; 22 = AT
db 16, 5                                     ; 16 = INK, 5 = Cyan
db 'ORIGINAL.PROGRAM.BY.DAMIAN.ELSEN'
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; End game screen
; -------------------------------------------------------------------
endGameScreen:
db 22, 4, 10                                 ; 22 = AT
db 16, 5                                     ; 16 = INK, 5 = Cyan
db 'LIGHT.CYCLES'
db 22, 10, 9                                 ; 22 = AT
db 16, 4                                     ; 16 = INK, 4 = Green
db 'RIDER.'
db 22, 10, 18                                ; 22 = AT
db 16, 4                                     ; 16 = INK, 4 = Green
db '.WINS'
db 22, 17, 5                                 ; 22 = AT
db 16, 5                                     ; 16 = INK, 5 = Cyan
db 'PRESS.'
db 16, 6                                     ; 16 = INK, 6 = Yellow
db 'ENTER'
db 16, 5                                     ; 16 = INK, 5 = Cyan
db '.TO.RESTART'
db 22, 18, 7                                 ; 22 = AT
db 'OR.PRESS.'
db 16, 6                                     ; 16 = INK, 6 = Yellow
db 'X'
db 16, 5                                     ; 16 = INK, 5 = Cyan
db '.TO.QUIT'
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; Player names
; -------------------------------------------------------------------
player1name:
db 22, 10, 15                                ; 22 = AT
db 16, 6                                     ; 16 = INK, 6 = Yellow
db 'ONE'
db $ff                                       ; String terminator
player2name:
db 22, 10, 15                                ; 22 = AT
db 16, 6                                     ; 16 = INK, 6 = Yellow
db 'TWO'
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; Screen frame UDGs
; -------------------------------------------------------------------
udgsCommon:
db $00, $00, $0f, $1f, $3a, $35, $3a, $35    ; $90 Top Left
db $00, $00, $ff, $ff, $aa, $55, $aa, $ff    ; $91 Top
db $00, $00, $e0, $f0, $a8, $74, $e8, $f4    ; $92 Top Right
db $3b, $35, $3b, $35, $3b, $35, $3b, $35    ; $93 Left
db $e8, $f4, $e8, $f4, $e8, $f4, $e8, $f4    ; $94 Right
db $3b, $37, $3f, $15, $0a, $05, $00, $00    ; $95 Bottom Left
db $ff, $ff, $ff, $55, $aa, $55, $00, $00    ; $96 Bottom
db $e8, $f4, $e8, $54, $a8, $50, $00, $00    ; $97 Bottom Right

; -------------------------------------------------------------------
; Display frame for the game screen
; -------------------------------------------------------------------
frameTopGraph:
db 22, 0, 0                                  ; 22 = AT
db 16, 5                                     ; 16 = COLOR, 5 = Cyan
db $90, $91, $91, $91, $91, $91, $91, $91    ; $90 = Top Left, $91 = Top
db $91, $91, $91, $91, $91, $91, $91, $91    ; $91 = Top
db $91, $91, $91, $91, $91, $91, $91, $91    ; $91 = Top
db $91, $91, $91, $91, $91, $91, $91, $92    ; $91 = Top, $92 = Top Right
db $ff                                       ; String terminator
frameBottomGraph:
db 22, 21, 0                                 ; 22 = AT
db $95, $96, $96, $96, $96, $96, $96, $96    ; $95 = Bottom Left, $96 = Bottom
db $96, $96, $96, $96, $96, $96, $96, $96    ; $96 = Bottom
db $96, $96, $96, $96, $96, $96, $96, $96    ; $96 = Bottom
db $96, $96, $96, $96, $96, $96, $96, $97    ; $96 = Bottom, $97 = Bottom Right
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; Blank string for clearing the play area
; -------------------------------------------------------------------
blankLine:
db $22, $22, $22, $22, $22, $22, $22, $22    ; $22 = SPACE
db $22, $22, $22, $22, $22, $22, $22, $22    ; $22 = SPACE
db $22, $22, $22, $22, $22, $22, $22, $22    ; $22 = SPACE
db $22, $22, $22, $22, $22, $22              ; $22 = SPACE
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; Labels for the game information panel
; -------------------------------------------------------------------
infoGame:
db 22, 0, 0                                  ; 22 = AT
db 'RIDER.1       TIME       RIDER.2'
db '                                '
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; Player 1 configuration
; 3 bytes per player
; -------------------------------------------------------------------
; Byte 1 (010TTSSS)     | Byte 2 (LLLCCCCC)    | Byte 4
; -------------------------------------------------------------------
; Bit 0-2: Scan line    | Bit 0-4: Column      | Bit   0: Going left
; Bit 3-4: Screen third | Bit 5-7: Line        | Bit   1: Going right
; Bit 5-7: 010          |                      | Bit   2: Going up
;                       |                      | Bit   3: Going down
;                       |                      | Bit   4: Alive
;                       |                      | Bit 5-7: Not used
; -------------------------------------------------------------------
; Byte 3 indicates the player's location within the current byte
; -------------------------------------------------------------------
                    ; TTSSS   LLLCCCCC                 ADURL
player1config: db %01001101, %01000111, %10000000, %00010010
player2config: db %01001101, %01011101, %00000001, %00010001

; -------------------------------------------------------------------
; Player scores
; -------------------------------------------------------------------
player1score: db 0
player2score: db 0

; -------------------------------------------------------------------
; Main screen
; -------------------------------------------------------------------
mainScreen:
db $16, $03, $0a                             ; $16 = AT, $03 = X =  3d, $0a = Y = 10d
db $10, $05                                  ; $10 = INK, $05 = Cyan
db 'LIGHT CYCLES'
db $16, $08, $00                             ; $16 = AT, $0a = X = 10d, $00 = Y =  0d
db $10, $04                                  ; $10 = INK, $04 = Green
db 'Ride your futuristic Light Cycle'
db 'around the arena whilst duelling'
db $16, $0a, $06                             ; $16 = AT, $0c = X = 12d, $06 = Y =  6d
db 'with your opponent.'
db $16, $0b, $01                             ; $16 = AT, $0d = X = 13d, $01 = Y =  1d
db 'Avoid colliding with the walls,'
db $16, $0c, $03                             ; $16 = AT, $0e = X = 14d, $03 = Y =  3d
db 'your opponent, or the light'
db $16, $0d, $01                             ; $16 = AT, $0f = X = 15d, $01 = Y =  1d
db 'trails.  The first rider to win'
db $16, $0e, $03                             ; $16 = AT, $10 = X = 16d, $03 = Y =  3d
db 'five matches wins the game.'
db $16, $14, $06                             ; $16 = AT, $14 = X = 20d, $06 = Y =  6d
db $10, $05                                  ; $10 = INK, $05 = Cyan
db 'Press '
db $10, $06                                  ; $10 = INK, $06 = Yellow
db 'ENTER'
db $10, $05                                  ; $10 = INK, $05 = Cyan
db ' to Start'
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; End Game screen
; -------------------------------------------------------------------
endGameScreen:
db $16, $03, $0a                             ; $16 = AT, $03 = X =  3d, $0a = Y = 10d
db $10, $05                                  ; $10 = INK, $05 = Cyan
db 'LIGHT CYCLES'
db $16, $0b, $08                             ; $16 = AT, $0b = X = 11d, $08 = Y =  8d
db $10, $04                                  ; $10 = INK, $04 = Green
db 'Player '
db $16, $0b, $12                             ; $16 = AT, $0b = X = 11d, $12 = Y = 18d
db ' Wins!'
db $16, $14, $05                             ; $16 = AT, $14 = X = 20d, $05 = Y =  5d
db $10, $05                                  ; $10 = INK, $05 = Cyan
db 'Press '
db $10, $06                                  ; $10 = INK, $06 = Yellow
db 'ENTER'
db $10, $05                                  ; $10 = INK, $05 = Cyan
db ' to Restart'
db $16, $15, $07                             ; $16 = AT, $15 = X = 21d, $07 = Y =  7d
db $10, $05                                  ; $10 = INK, $05 = Cyan
db 'Or press '
db $10, $06                                  ; $10 = INK, $06 = Yellow
db 'X'
db $10, $05                                  ; $10 = INK, $05 = Cyan
db ' to Exit'
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; Player names
; -------------------------------------------------------------------
player1name:
db $16, $0b, $0f                             ; $16 = AT, $0b = X = 11d, $0f = Y = 15d
db $10, $06                                  ; $10 = INK, $06 = Yellow
db 'ONE'
db $ff                                       ; String terminator
player2name:
db $16, $0b, $0f                             ; $16 = AT, $0b = X = 11d, $0f = Y = 15d
db $10, $06                                  ; $10 = INK, $06 = Yellow
db 'TWO'
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; Screen frame UDGs
; -------------------------------------------------------------------
udgsCommon:
db $00, $00, $00, $07, $0f, $1d, $1a, $1d    ; $90 Top Left
db $00, $00, $00, $ff, $ff, $55, $aa, $55    ; $91 Top
db $00, $00, $00, $e0, $d0, $68, $d0, $e8    ; $92 Top Right
db $1a, $1d, $1a, $1d, $1a, $1d, $1a, $1d    ; $93 Left
db $d0, $e8, $d0, $e8, $d0, $e8, $d0, $e8    ; $94 Right
db $1b, $1f, $15, $0a, $05, $00, $00, $00    ; $95 Bottom Left
db $ff, $ff, $55, $aa, $55, $00, $00, $00    ; $96 Bottom
db $d0, $a8, $50, $a0, $40, $00, $00, $00    ; $97 Bottom Right

; -------------------------------------------------------------------
; Display frame for the game screen
; -------------------------------------------------------------------
frameTopGraph:
db $16, $00, $00                             ; $16 = AT, $00 = X =  0d, $00 = Y = 0d
db $10, $05                                  ; $10 = COLOR, $05 = Cyan
db $90, $91, $91, $91, $91, $91, $91, $91    ; $90 = Top Left, $91 = Top
db $91, $91, $91, $91, $91, $91, $91, $91    ; $91 = Top
db $91, $91, $91, $91, $91, $91, $91, $91    ; $91 = Top
db $91, $91, $91, $91, $91, $91, $91, $92    ; $91 = Top, $92 = Top Right
db $ff                                       ; String terminator
frameBottomGraph:
db $16, $15, $00                             ; $16 = AT, $15 = X = 21d, $00 = Y = 0d
db $95, $96, $96, $96, $96, $96, $96, $96    ; $95 = Bottom Left, $96 = Bottom
db $96, $96, $96, $96, $96, $96, $96, $96    ; $96 = Bottom
db $96, $96, $96, $96, $96, $96, $96, $96    ; $96 = Bottom
db $96, $96, $96, $96, $96, $96, $96, $97    ; $96 = Bottom, $97 = Bottom Right
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; Blank string for clearing the play area
; -------------------------------------------------------------------
blankLine:
db $20, $20, $20, $20, $20, $20, $20, $20    ; $20 = SPACE
db $20, $20, $20, $20, $20, $20, $20, $20
db $20, $20, $20, $20, $20, $20, $20, $20
db $20, $20, $20, $20, $20, $20
db $ff                                       ; String terminator

; -------------------------------------------------------------------
; Labels for the game information panel
; -------------------------------------------------------------------
infoGame:
db $16, $00, $00                             ; $16 = AT, $00 = X = 0d, $00 = Y = 0d
db $10, $04                                  ; $10 = INK, $04 = Green
db 'Player 1      Time      Player 2'
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
                                        ;     TT SSS LLL CCCCC          XXXADURL
player1config: db $4d, $47, $80, $12    ; 010 01 101 010 00011 10000000 00010010
player2config: db $4d, $58, $01, $11    ; 010 01 101 010 11101 00000001 00010001

; -------------------------------------------------------------------
; Reset's both player's configs and time after end of match
; Input: none
; Alters the value of registers: IX
; -------------------------------------------------------------------
ResetMatch:
     ld   ix, player1config
     ld   (ix), $4d
     ld   (ix + $01), $47
     ld   (ix + $02), $80
     ld   (ix + $03), $12
     ld   ix, player2config
     ld   (ix), $4d
     ld   (ix + $01), $58
     ld   (ix + $02), $01
     ld   (ix + $03), $11
     ld   ix, timer
     ld   (ix), $00
ret

; -------------------------------------------------------------------
; Player scores
; -------------------------------------------------------------------
player1score: db $00
player2score: db $00

; -------------------------------------------------------------------
; Reset's both player's scores after end of game
; Input: none
; Alters the value of registers: IX
; -------------------------------------------------------------------
ResetGame:
     ld   ix, player1score
     ld   (ix), $00
     ld   (ix + $01), $00
ret

; -------------------------------------------------------------------
; Screen frame UDGs
; -------------------------------------------------------------------
udgsCommon:
db $00, $03, $07, $0e, $1d, $3a, $35, $3a ; $90 Top Left
db $00, $ff, $ff, $aa, $55, $aa, $00, $00 ; $91 Top
db $00, $e0, $d0, $e8, $74, $ba, $5c, $3a ; $92 Top Right
db $34, $3a, $34, $3a, $34, $3a, $34, $3a ; $93 Left
db $3c, $3a, $3c, $3a, $3c, $3a, $3c, $3a ; $94 Right
db $34, $3a, $3d, $1f, $0f, $05, $02, $00 ; $95 Bottom Left
db $00, $00, $ff, $ff, $ff, $55, $aa, $00 ; $96 Bottom
db $3a, $7c, $fa, $f4, $e8, $50, $a0, $00 ; $97 Bottom Right

; -------------------------------------------------------------------
; Display frame for the game screen
; -------------------------------------------------------------------
frameTopGraph:
db $16, $00, $00                          ; $16 = AT, $00 = X, $00 = Y
db $10, $05                               ; $10 = COLOR, $05 = Cyan
db $90, $91, $91, $91, $91, $91, $91, $91 ; $90 = Top Left, $91 = Top
db $91, $91, $91, $91, $91, $91, $91, $91 ; $91 = Top
db $91, $91, $91, $91, $91, $91, $91, $91 ; $91 = Top
db $91, $91, $91, $91, $91, $91, $91, $92 ; $91 = Top, $92 = Top Right
db $ff                                    ; String terminator
frameBottomGraph:
db $16, $15, $00                          ; $16 = AT, $15 = X = 21d, $00 = Y
db $95, $96, $96, $96, $96, $96, $96, $96 ; $95 = Bottom Left, $96 = Bottom
db $96, $96, $96, $96, $96, $96, $96, $96 ; $96 = Bottom
db $96, $96, $96, $96, $96, $96, $96, $96 ; $96 = Bottom
db $96, $96, $96, $96, $96, $96, $96, $97 ; $96 = Bottom, $97 = Bottom Right
db $ff                                    ; String terminator

; Blank string for clearing the play area
blankLine:
db $20, $20, $20, $20, $20, $20, $20, $20
db $20, $20, $20, $20, $20, $20, $20, $20
db $20, $20, $20, $20, $20, $20, $20, $20
db $20, $20, $20, $20, $20, $20
db $ff                                    ; String terminator

; Labels for the game information panel
infoGame: db $10, $04, $16, $00, $00, 'Player 1      Time      Player 2', $ff

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

ResetConfig:
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
ret

player1score: db $00
player2score: db $00

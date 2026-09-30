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

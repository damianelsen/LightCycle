org  $5dfd

Main:
     ld   hl, ATTR_PERM
     ld   (hl), $46           ; 01000010b = No flash, Bright, Black paper, Yellow ink
     call CLS

     xor  a                   ; Set A = 0 = black
     out  ($fe), a            ; Set border color

     ld   a, (BORDERCR)       ; Read current border color attributes from BORDERCR
     and  $c0                 ; 11000000b mask to set background color to black
     or   $04                 ; 00000100b mask to set foreground color to green
     ld   (BORDERCR), a       ; Write modified attributes back to BORDERCR

     ld   hl, udgsCommon      ; HL = UDG address
     ld   (UDG), hl           ; Load custom UDGs

     call PrintFrame
     call PrintInfoLabels
     call PrintScores

     mainRestart:
     call ResetConfig
     call ClearArena

     mainLoop:
          ld   hl, player1config
          call DisplayPlayer
          ld   hl, player2config
          call DisplayPlayer

          call CheckCtrlP1

          ld   hl, player1config + $03
          call MovePlayer
          ld   hl, player2config + $03
          call MovePlayer

          call CheckPlayers
          call PrintScores
     jr mainLoop

include "const.asm"
include "var.asm"
include "print.asm"
include "game.asm"
include "graph.asm"
include "control.asm"

end  Main

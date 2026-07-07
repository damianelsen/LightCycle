org  $5dfd

flags:    db $00    ; Global Game Indicators: Bit 0 - Allow game movement? 0 = No, 1 = Yes
timer:    db $00    ; Used to track the elapsed time of each match

Main:
     ld   hl, ATTR_PERM
     ld   (hl), $46           ; 01000010b = No flash, Bright, Black paper, Yellow ink

     xor  a                   ; Set A = 0 = black
     out  ($fe), a            ; Set border color

     ld   a, (BORDERCR)       ; Read current border color attributes from BORDERCR
     and  $c0                 ; 11000000b mask to set background color to black
     or   $04                 ; 00000100b mask to set foreground color to green
     ld   (BORDERCR), a       ; Write modified attributes back to BORDERCR

     ld   hl, udgsCommon      ; HL = UDG address
     ld   (UDG), hl           ; Load custom UDGs

     di                       ; Disable interrupts
     ld   a, $28              ; Load A with 40d
     ld   i, a                ; Load from A to I
     im   2                   ; Set Mode 2 interrupts
     ei                       ; Enable interrupts

     call PrintMainScreen

     mainRestartGame:
     call ResetGame
     call PrintFrame
     call PrintInfoLabels
     call PrintScores

     mainRestartMatch:
     call ResetMatch
     call PrintTime
     call ClearArena

     mainLoop:
          ld   a, (flags)               ; Load the Global Game Indicators
          bit  $00, a                   ; Check if we should allow movement, Bit 0 = Allow game movement?
          jr   z, mainLoop              ; If 0, then exit
          res  $00, a                   ; If 1, then reset to 0
          ld   (flags), a               ; Update the Global Game Indicators

          call DisplayPlayers
          call CheckCtrlP1
          call MovePlayers
          call CheckPlayers
          call CheckScores
          call PrintTime
     jr mainLoop

include "const.asm"
include "var.asm"
include "print.asm"
include "game.asm"
include "graph.asm"
include "control.asm"
include "sound.asm"

end  Main

org  $5dfd

flags:    db 0      ; Global Game Indicators: Bit 0 - Allow game movement? 0 = No, 1 = Yes
timer:    db 0      ; Used to track the elapsed time of each match

Main:
     ld   hl, ATTR_PERM
     ld   (hl), %01000110     ; No flash, Bright, Black paper, Yellow ink (FBPPPIII)

     xor  a                   ; Set A = 0 = black
     out  ($fe), a            ; Set border color

     ld   a, %01000100        ; No flash, Bright, Black paper, Green ink (FBPPPIII)
     ld   (BORDERCR), a       ; Write attributes to BORDERCR

     ld   hl, udgsCommon      ; HL = UDG address
     ld   (UDG), hl           ; Load custom UDGs

     ld   hl, udgsChars       ; HL = Replacement character set address
     ld   a, h                ; Load A with high byte of address
     dec  a                   ; Decrement A = subtract 256d as CHARS uses a -256d offset
     ld   h, a                ; Load modified byte back to H
     ld   (CHARS), hl         ; Load custom character set

     di                       ; Disable interrupts
     ld   a, 40               ; Load A with 40d
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
     call Sleep

     mainLoop:
          ld   a, (flags)               ; Load the Global Game Indicators
          bit  0, a                     ; Check if we should allow movement, Bit 0 = Allow game movement?
          jr   z, mainLoop              ; If 0, then exit
          res  0, a                     ; If 1, then reset to 0
          ld   (flags), a               ; Update the Global Game Indicators

          call DisplayPlayers
          call CheckControls
          call MovePlayers
          call SoundMove
          call CheckPlayers
          call CheckScores
          call PrintTime
     jr mainLoop

include "const.asm"
include "var.asm"
include "global.asm"
include "print.asm"
include "game.asm"
include "graph.asm"
include "control.asm"
include "sound.asm"
;include "debug.asm"

end  Main

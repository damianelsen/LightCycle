; -------------------------------------------------------------------
; Plays the sound for movement
; Input: none
; Alters the value of registers: AF, BC, DE, HL
; -------------------------------------------------------------------
SoundMove:
     ld   hl, 4345
     ld   de, 1
     call BEEP                  ; Call ROM routine
ret

; -------------------------------------------------------------------
; Plays the sound for a collision
; Input: none
; Alters the value of registers: AF, BC, DE, HL
; Notes: Based on a sound effect from Egghead 3
;        courtesy of Jonathan Cauldwell
; -------------------------------------------------------------------
SoundCollision:
     ld   e, 250                   ; Repeat 250 times
     ld   hl, 0                    ; Start pointer at beginning of ROM
     SoundCollisionLoopOuter:
          push de
          ld   b, 32               ; Length of step
          SoundCollisionLoopInner:
               push bc
               ld   a, (hl)        ; Load byte of ROM ("random" number)
               inc  hl             ; Next byte of ROM
               and  248            ; Preserve the black border
               out  (254), a       ; Play note
               ld   a, e           ; As E gets smaller ...
               cpl                 ; Increase the delay (inverts all bits of A)
               SoundCollisionLoop: ; Delay loop
                    dec  a         ; Decrement loop counter
               jr   nz, SoundCollisionLoop
               pop  bc
          djnz SoundCollisionLoopInner
          pop  de                  ; Next step
          ld   a, e
          sub  24                  ; Size of step
          cp   30                  ; End of range
          ret  z
          ret  c
          ld   e, a
          cpl
     jr   SoundCollisionLoopOuter

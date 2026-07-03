org  $7e5c

flags:    equ $5dfd           ; Global game indicators

     push af                  ; Preserve AF
     push hl                  ; Preserve HL

     ld   a, (speed)          ; Load the speed counter into A
     inc  a                   ; Increment the counter
     ld   (speed), a          ; Store the updated counter
     sub  $01                 ; Subtract 1d
     jr   nz, InterruptEnd    ; If not zero, exit
     ld   (speed), a          ; Store the updated counter (which is now 0)

     ld   hl, flags           ; Load address for game indicators into HL
     set  $00, (hl)           ; Activate flag bit 0 (Allow game movement?)

InterruptEnd:
     pop  hl                  ; Retrieve HL
     pop  af                  ; Retrieve AF
     ei                       ; Enable interrupts

reti                       ; Exit

speed:    db $00              ; Speed counter

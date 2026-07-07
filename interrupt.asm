org  $7e5c

flags:    equ $5dfd           ; Global game indicators
timer:    equ $5dfe           ; Match time elapsed counter

;Interrupt
     push af                  ; Preserve AF
     push hl                  ; Preserve HL

     ld   a, (time)           ; Load the time counter into A
     inc  a                   ; Increment the time counter
     ld   (time), a           ; Store the updated time counter
     sub  $32                 ; Subtract 32h = 50d
     jr   nz, InterruptCont   ; If not zero, exit
     ld   (time), a           ; Store the updated time counter (which is now 0)
     ld   a, (timer)          ; Load the match time into A (units and tens)
     add  a, $01              ; Increment the time - one second has passed
     daa                      ; Decimal adjust
     ld   (timer), a          ; Update memory
     ld   a, (timer + 1)      ; Load the match time into A (hundreds and thousands)
     adc  a, $00              ; Increment the time with carry
     daa                      ; Decimal adjust
     ld   (timer + 1), a      ; Store the updated match time

InterruptCont:
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
time:     db $00              ; Time counter

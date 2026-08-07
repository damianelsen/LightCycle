org  32348

flags:    equ 24101           ; Global game indicators
timer:    equ 24102           ; Match time elapsed counter

;Interrupt
     push af                  ; Preserve AF
     push hl                  ; Preserve HL

     ld   a, (time)           ; Load the time counter into A
     inc  a                   ; Increment the time counter
     ld   (time), a           ; Store the updated time counter
     sub  50                  ; Subtract 50d
     jr   nz, InterruptCont   ; If not zero, exit
     ld   (time), a           ; Store the updated time counter (which is now 0)
     ld   a, (timer)          ; Load the match time into A (units and tens)
     inc  a                   ; Increment the time - one second has passed
     daa                      ; Decimal adjust
     ld   (timer), a          ; Update memory
     ld   a, (timer + 1)      ; Load the match time into A (hundreds and thousands)
     adc  a, 0                ; Increment the time with carry
     daa                      ; Decimal adjust
     ld   (timer + 1), a      ; Store the updated match time

InterruptCont:
     ld   a, (speed)          ; Load the speed counter into A
     inc  a                   ; Increment the counter
     ld   (speed), a          ; Store the updated counter
     dec  a                   ; Decrement the counter
     jr   nz, InterruptEnd    ; If not zero, exit
     ld   (speed), a          ; Store the updated counter (which is now 0)
     ld   hl, flags           ; Load address for game indicators into HL
     set  0, (hl)             ; Activate flag bit 0 (Allow game movement?)

InterruptEnd:
     pop  hl                  ; Retrieve HL
     pop  af                  ; Retrieve AF
     ei                       ; Enable interrupts

reti                       ; Exit

speed:    db 0                ; Speed counter
time:     db 0                ; Time counter

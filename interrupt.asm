; Interrupt Service Routine
; Location of this routine is determined by interrupt vectors from two memory locations:
; (I * 256 + DeviceId) and (I * 256 + DeviceId + 1)
; With no peripherals connected there is no value on the data bus, and when this happens
; the data bus acquires the value 8 one signals (11111111b) due to the pull-up resistances
; of the lines connected to the data bus, which gives us a DeviceId of 255d.
; In main.asm we are loading I with a value of 40d so the memory locations from which the
; interrupt vectors will be read are as follows:
; (I * 256 + DeviceId)     = (40 * 256 + 255)     = 10495d (28FFh)
; (I * 256 + DeviceId + 1) = (40 * 256 + 255 + 1) = 10496d (2900h)
; These two memory locations are within the ZX Spectrum ROM and contain the following values:
; 10495d (28FFh) contains  92d (5Ch) with Little Endian this will be the low byte
; 10496d (2900h) contains 126d (7Eh) with Little Endian this will be the high byte
; This results in an interrupt vector of 7E5Ch (32348d)

org  32348

INTS_PER_SEC   equ    50      ; Interrupts per second on PAL systems

flags:         equ 24101      ; Global game indicators
timer:         equ 24102      ; Match time elapsed counter

;Interrupt
     push af                  ; Preserve AF
     push hl                  ; Preserve HL

     ld   a, (time)           ; Load the time counter into A
     inc  a                   ; Increment the time counter
     ld   (time), a           ; Store the updated time counter
     sub  INTS_PER_SEC        ; Subtract interrupts per second
     jr   nz, InterruptCont   ; If not zero, exit (one second has not yet elapsed)
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

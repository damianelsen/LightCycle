; TODO: Add game sounds

; -------------------------------------------------------------------
; Sounds a note
; Input: HL = Note
;        DE = Frequency
; Alters the value of registers: IX
; -------------------------------------------------------------------
PlayNote:
     push af
     push bc
     push de
     push hl                    ; Preserve registers
     call BEEP                  ; Call ROM routine
     pop  hl
     pop  de
     pop  bc
     pop  af                    ; Retrieve registers
ret

SoundMove:
     ld   hl, $6868
     ld   de, $0010 / $28
     call PlayNote
ret

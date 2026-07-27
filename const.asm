; Memory addresses for various game elements
ATTR_PERM:     equ $5C8D      ; Memory address where permanent color attributes are stored (FBPPPIII)
;ATTR_TEMP:     equ $5C8F      ; Memory address where attributes used by RST 16 are stored (FBPPPIII)
BORDERCR:      equ $5C48      ; Memory address where color attributes of the border are stored (FBPPPIII)
UDG:           equ $5C7B      ; Memory address where the first user-defined graphic (UDG) is stored
CHARS:         equ $5C36      ; Memory address where the default character set is stored

; Screen coordinates
OFFSET_Y:      equ 24         ; Y-coordinate of the upper left corner = 24d (rows)
OFFSET_X:      equ 32         ; X-coordinate of the upper left corner = 32d (columns)

; ROM Routines
CLS:           equ $0DAF      ; Clear screen routine (uses attributes from ATTR_PERM)
SET_CURSOR:    equ $0A23      ; Set cursor position routine (expects BC = (x, y) coordinates)
OPENCHAN:      equ $1601      ; Change display channel routine (expects A = 1 command line, A = 2 main screen)
BEEP:          equ $03B5      ; ROM beeper routine: HL = Note, DE = Duration (alters AF, BC, DE, HL, IX)

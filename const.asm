; Memory addresses for various game elements
ATTR_PERM:     equ 23693      ; Memory address where permanent color attributes are stored (FBPPPIII)
BORDERCR:      equ 23624      ; Memory address where color attributes of the border are stored (FBPPPIII)
UDG:           equ 23675      ; Memory address where the first user-defined graphic (UDG) is stored
CHARS:         equ 23606      ; Memory address where the default character set is stored

; Screen coordinates
OFFSET_Y:      equ    24      ; Y-coordinate of the upper left corner = 24d (rows)
OFFSET_X:      equ    32      ; X-coordinate of the upper left corner = 32d (columns)

; ROM Routines
CLS:           equ  3503      ; Clear screen routine (uses attributes from ATTR_PERM)
SET_CURSOR:    equ  2595      ; Set cursor position routine (expects BC = (x, y) coordinates)
OPEN_CHAN:     equ  5633      ; Change display channel routine (expects A = 1 command line, A = 2 main screen)
BEEP:          equ   949      ; ROM beeper routine: HL = Note, DE = Duration (alters AF, BC, DE, HL, IX)
PRINT_BC:      equ  6683      ; Displays the value in the BC register pair, up to a value of 9999

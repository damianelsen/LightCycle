; Memory addresses for various game elements
ATTR_PERM:     equ $5c8d      ; Memory address where permanent color attributes are stored (FBPPPIII)
ATTR_TEMP:     equ $5c8f      ; Memory address where attributes used by RST $10 are stored (FBPPPIII)
BORDERCR:      equ $5c48      ; Memory address where color attributes of the border are stored (FBPPPIII)
UDG:           equ $5c7b      ; Memory address where the first user-defined graphic (UDG) is stored

; Screen coordinates
OFFSET_Y:      equ $18        ; Y-coordinate of the upper left corner = 24d (rows)
OFFSET_X:      equ $20        ; X-coordinate of the upper left corner = 32d (columns)

; ROM Routines
CLS:           equ $0daf      ; Clear screen routine (uses attributes from ATTR_PERM)
SET_CURSOR:    equ $0a23      ; Set cursor position routine (expects BC = (x, y) coordinates)
OPENCHAN:      equ $1601      ; Change display channel routine (expects A = 1 command line, A = 2 main screen)

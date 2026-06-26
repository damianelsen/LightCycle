; Memory addresses for various game elements
ATTR_PERM:     EQU $5c8d      ; Memory address where permanent color attributes are stored (FBPPPIII)
ATTR_TEMP:     EQU $5c8f      ; Memory address where attributes used by RST $10 are stored (FBPPPIII)
BORDERCR:      EQU $5c48      ; Memory address where color attributes of the border are stored (FBPPPIII)
UDG:           EQU $5c7b      ; Memory address where the first user-defined graphic (UDG) is stored

; Screen coordinates
OFFSET_Y:      EQU $18        ; Y-coordinate of the upper left corner = 24d (rows)
OFFSET_X:      EQU $20        ; X-coordinate of the upper left corner = 32d (columns)

; ROM Routines
CLS:           EQU $0daf      ; Clear screen routine (uses attributes from ATTR_PERM)
SET_CURSOR:    EQU $0a23      ; Set cursor position routine (expects BC = (x, y) coordinates)
OPENCHAN:      EQU $1601      ; Change display channel routine (expects A = 1 command line, A = 2 main screen)

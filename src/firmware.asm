; Define characteristics of system in use

KYBRD   .SE     2              ; Set this value to 1 or 2 depending on the keyboard in use.
                               ; Most software is written to use KDB/2
SYSTYP  .SE     310            ; System type
                               ; Values are 310,320 or 330

; Firmware entry points (PDS-V3N)

        .DO     SYSTYP=320 OR 330 
; These routines are only available in 320 & 330 systems

INTLZC  .EQU     $FB00         ; 
WRTBLK  .EQU     $FB2D         ; 
WRTMOD  .EQU     $FB2F         ; 
CASIN   .EQU     $FB7E         ; 
CASOUT  .EQU     $FB62         ; 
RDBLK   .EQU     $FB91         ; 
RDMOD   .EQU     $FB93         ; 
TRNOFF  .EQU     $FBB0         ; 
TURNON  .EQU     $FB77         ; 
        .FI

HOME    .EQU     $FC37         ; Cursor to top left
CLEAR   .EQU     $FC3D         ; Clear screen contents
GETCHR  .EQU     $FC4A         ; Gets a single character into A (with cursor blinking)
EDITOR  .EQU     $FC67         ; Reads in text, echoes to the CRT and stores in a specified location
REEDIT  .EQU     $FC6F         ; Similar to EDITOR, but doesnt initialise buffer pointers (CRT is still cleared)
EDITRD  .EQU     $FC73         ; Same as REEDIT, but doesnt blank the screen
EDITIN  .EQU     $FC75         ; Reads in a screen of text
PUTCHR  .EQU     $FCBC         ; Print character at cursor
SUB32   .EQU     $FCCB         ; Moves cursor up a line on the screen
ADD32   .EQU     $FCD5         ; Moves cursor down a line on the screen
LFTJST  .EQU     $FCFD         ; Send the cursor to the far left of the current line
CRLF    .EQU     $FD14         ; Print a CRLF
OUTSTR  .EQU     $FD8E         ; Output string
DEBUG   .EQU     $FE64         ; DEBUG entry point (return to SPHERE-1 control)
INPCHR  .EQU     $FE71         ; Reads and displays a character
INPNUM  .EQU     $FEE4         ; Reads a set of characters and converts to a 16-bit binary value
PNTBYT  .EQU     $FF02         ; Displays AccA at the current cursor position
BINASC  .EQU     $FF65         ; Converts a character from binary to ASCII
ASCBIN  .EQU     $FF22         ; Converts an ASCII character to binary
MULT    .EQU     $FF93         ; Multiply 2 unsigned 16-bit numbers
DIVIDE  .EQU     $FFAF         ; Divide a 16-bit number in AccA by one in ARA

; PDS Workspace

        .DO     KYBRD=1 
KBDPIA  .EQU    $F000         ; Address of PIA for KBD/1 
        .EL
KBDPIA  .EQU    $F040         ; Address of PIA for KBD/2
        .FI

TMP     .EQU    $0000          ; Temporary storage, DO NOT use when using PDS routines
TMP1    .EQU    $0002          ; Temp. storage, DO NOT use when using PDS routines
ARB     .EQU    $0004          ; Pseudo-register (AR3=0004, AR2=0005)
ARA     .EQU    $0006          ; Pseudo-register (AR1=0006, AR2=0007)
DIGIT   .EQU    $0008          ; Temporary storage, DO NOT USE when using PDS
CSTATS  .EQU    $0009          ; Cassette status
OUTEND  .EQU    $000A          ; End of output buffer
BUFADR  .EQU    $000C          ; Start of I/O buffer
BUFEND  .EQU    $000E          ; End of I/O buffer
;unused .EQU    $0010
OUTBUF  .EQU    $0011          ; Start of output buffer
;unused .EQU    $0013
SRCADR  .EQU    $0014          ; Source for byte move
DSRADR  .EQU    $0016          ; Destination address for byte move
;unused .EQU    $0019
ENDMEM  .EQU    $001A          ; Last contiguous memory location
CSRPTR  .EQU    $001C          ; Current cursor location
BUFPTR  .EQU    $001E          ; Pointer to character being displayed
BUFFLO  .EQU    $0020          ; Pointer to top of low buffer
BUFFHI  .EQU    $0022          ; Pointer to bottom of high buffer
SCNPTR  .EQU    $0024          ; Pointer to scan beginning
SRCASM  .EQU    $0026          ; Beginning of assembler source code
DSTASM  .EQU    $0028          ; Beginning of assembler object code
ONDVAL  .EQU    $002A          ; Operand value
SYMVAL  .EQU    $002C          ; Symbol value
BRKSAV  .EQU    $002E          ; Temporary storage for data displaced by SWI
;unused .EQU    $002F
BRKADR  .EQU    $0030          ; Address of breakpoint
EDIT    .EQU    $0032          ; Non-zero if EDITOR is running
BLKNAM  .EQU    $0033          ; Name for cassette block
IOBUFF  .EQU    $0035          ; Temporary output editing area
;unused .EQU    $0037
ACIANO  .EQU    $0038          ; Address of ACIA being used for serial I/O
NOPRNT  .EQU    $030A          ; Non zero to display SIM I/O on CRT
;unused .EQU    $003B
BFRPTR  .EQU    $003C          ; Start of serial I/O buffer
BFRSZE  .EQU    $030E          ; End of serial I/O buffer



; Assembled with sbasm3 (https://www.sbprojects.net/sbasm/)
; All directives are specific to sbasm3, and may need to be changed for other assemblers

        .CR 6800               ; LOAD MC6800 CROSS OVERLAY
        .TF mm.exe,BIN         ; OUTPUT FILE IN BINARY FORMAT
        .OR $0300              ; START OF ASSEMBLY ADDRESS
        .LI   OFF                ; SWITCH OFF ASSEMBLY LISTING (EXCEPT ERRORS)
        .EF errors.err         ; USE errors.err as an error output file
        .SF SYMBOLS.SYM        ; CREATE SYMBOL FILE

        .IN     firmware

SPARE   .DB     1               ; $0300

GUESS1  .DB     1               ; $0301
GUESS2  .DB     1               ; $0302
GUESS3  .DB     1               ; $0303
GUESS4  .DB     1               ; $0304
GUESS5  .DB     1               ; $0305

CHBOX1  .DB     1               ; $0306
CHBOX2  .DB     1               ; $0307
CHBOX3  .DB     1               ; $0308
CHBOX4  .DB     1               ; $0309
CHBOX5  .DB     1               ; $030A

VAULT1  .DB     1               ; $030B
VAULT2  .DB     1               ; $030C
VAULT3  .DB     1               ; $030D
VAULT4  .DB     1               ; $030E
VAULT5  .DB     1               ; $030F

HITCCNT .DB     1               ; $0310
XCOUNT  .DB     1               ; $0311

GUESSCT .DB     1               ; $0312

CRTMP1  .DB     1               ; $0313
CRTMP2  .DB     1               ; $0314
IXTMP1  .DB     1               ; $0315
IXTMP2  .DB     1               ; $0316
IXTMP3  .DB     1               ; $0317
IXTMP4  .DB     1               ; $0318

        .BS     $07,$FF         ; Fill 7 bytes as a filler      

; Import prompt and I/O data
BUFFERS .EQU    *
        .IN     prompts
BUFFERE .EQU    *
        
; New origin, with zero-filled bytes in between

        
        .NO     $0400, $00
                      
START   CLR     GUESSCT         ; 0400 7F       CLR     0312                            ;
        JSR     HOME            ; 0403 BD       JSR     FC37    HOME                    ;
        JSR     CLEAR           ; 0406 BD       JSR     FC3D    CLEAR                   ;
        LDX     #PRMPT1S        ; 0409 CE       LDX     #0320                           ; Start of output buffer
        STX     OUTBUF          ; 040C DF       STX     11                              ; Store in the system output buffer start
        LDX     #PRMPT1E        ; 040E CE       LDX     #035D   ]                       ; End of output buffer
        STX     OUTEND          ; 0411 DF       STX     0A                              ; Store in the system output buffer end
        JSR     OUTSTR          ; 0413 BD       JSR     FD8E                            ; Output a String
        ;BSR     PICKNO          ; 0416 8D       BSR     0E      0426                    ;
        jsr     GETRND
LBL1    BSR     LBL7            ; 0418 3D       BSR     4F      0469                    ;
        INC     GUESSCT         ; 041A 7C       INC     0312                            ; Increment Guess Count
        LDAA    GUESSCT         ; 041D B6       LDAA    0312                            ; Load Guess Count into AccA     
        CMPA    #$0C            ; 0420 81       CMPA    #0C                             ;
        BEQ     LBL5            ; 0422 27       BEQ     21      0445                    ;
        BRA     LBL1            ; 0424 20       BRA     F2      0418                    ;       
PICKNO  LDX     #VAULT1         ; 0426 CE       LDAA    #030B   PICK # TO BE GUESSED    ; Start of PICKNO routine
PUTVAUL LDAA    KBDPIA          ; 0429 B6       LDAA    F000    PUT IN -> VAULT TEMP    ;
        CMPA    #$0B            ; 042C 81       CMPA    #0B                             ;
        BHI     LBL2            ; 042E 22       BHI     02      0432                    ;
        BRA     PUTVAUL         ; 0430 20       BRA     F7      0429                    ;
LBL2    CMPA    #$12            ; 0432 81       CMPA    #12                             ;
        BLS     LBL4            ; 0434 23       BLS     02      0438                    ;
        BRA     PUTVAUL         ; 0436 20       BRA     F1      0429                    ;
LBL4    ADDA    #$24            ; 0438 8B       ADDA    #24     $                       ;
        STAA    0, X            ; 043A A7       STAA    X00                             ;
        INX                     ; 043C 08       INX                                     ;
        CPX     #HITCCNT        ; 043D 8C       CPX     #0310                           ;
        BEQ     LBL3            ; 0440 27       BEQ     02      0444                    ;
        BRA     PUTVAUL         ; 0442 20       BRA     E5      0429                    ;
LBL3    RTS                     ; 0444 39       RTS                                     ; End of PICKNO routine
LBL5    LDX     #PRMPT3S        ; 0445 CE       LDX     #0370
        STX     OUTBUF          ; 0448 DF       STX     11
        LDX     #PRMPT3E        ; 044A CE       LDX     #0385                           ;
        STX     OUTEND          ; 044D DF       STX     0A                              ;
        JSR     OUTSTR          ; 044F BD       JSR     FD8E                            ; Output a String
        LDX     #VAULT1         ; 0452 CE       LDX     #030B                           ;
LBL6    LDAA    0,X             ; 0455 A6       LDAA    X00                             ;
        STX     IXTMP1          ; 0457 FF       STX     0315                            ;
        JSR     PUTCHR          ; 045A BD       JSR     FCBC                            ;
        LDX     IXTMP1          ; 045D FE       LDX     0315                            ;
        INX                     ; 0460 08       INX                                     ;
        CPX     #HITCCNT        ; 0461 8C       CPX     #0310                           ;
        BNE     LBL6            ; 0464 26       BNE     EF      0455                    ;
        JMP     LBL21           ; 0466 7E       JMP     0581                            ;
LBL7    LDX     #PRMPT2S        ; 0469 CE       LDX     #0360                           ;
        STX     OUTBUF          ; 046C DF       STX     11                              ;
        LDX     #PRMPT2E        ; 046E CE       LDX     #036C                           ;
        STX     OUTEND          ; 0471 DF       STX     0A                              ;
        JSR     OUTSTR          ; 0473 BD       JSR     FD8E                            ;
        LDX     CSRPTR          ; 0476 DE       LDX     1C      - INPUT GUESS           ;
        STX     CRTMP1          ; 0478 FF       STX     0313                            ;
LBL10   JSR     GETCHR          ; 047B BD       JSR     FC4A                            ;
        CMPA    #$14            ; 047E 81       CMPA    #14     - BACKSPACE CODE        ;
        BEQ     LBL8            ; 0480 27       BEQ     09      048B                    ;
        JSR     PUTCHR          ; 0482 BD       JSR     FCBC                            ;
        CMPA    #$3C            ; 0485 81       CMPA    #3C     <                       ;
        BEQ     LBL9            ; 0487 27       BEQ     09      0492                    ;
        BRA     LBL10           ; 0489 20       BRA     F0      047B                    ;
LBL8    LDX     CSRPTR          ; 048B DE       LDX     1C                              ;
        DEX                     ; 048D 09       DEX                                     ;
        STX     CSRPTR          ; 048E DF       STX     1C                              ;
        BRA     LBL10           ; 0490 20       BRA     E9      047B                    ;
LBL9    LDX     CSRPTR          ; 0492 DE       LDX     1C                              ;
        DEX                     ; 0494 09       DEX                                     ;
        DEX                     ; 0495 09       DEX                                     ;
        LDAA    0,X             ; 0496 A6       LDAA    X00     CRT -> GUESS TEMP.      ;
        STAA    GUESS5          ; 0498 B7       STAA    0305      |                     ;
        DEX                     ; 049B 09       DEX               |                     ;
        LDAA    0,X             ; 049C A6       LDAA    X00       |                     ;
        STAA    GUESS4          ; 049E B7       STAA    0304      |                     ;
        DEX                     ; 04A1 09       DEX               |                     ;
        LDAA    0,X             ; 04A2 A6       LDAA    X00       |                     ;
        STAA    GUESS3          ; 04A4 B7       STAA    0303      |                     ;
        DEX                     ; 04A7 09       DEX               |                     ;
        LDAA    0,X             ; 04A8 A6       LDAA    X00       |                     ;
        STAA    GUESS2          ; 04AA B7       STAA    0302      |                     ;
        DEX                     ; 04AD 09       DEX               |                     ;
        LDAA    0,X             ; 04AE A6       LDAA    X00       -                     ;
        STAA    GUESS1          ; 04B0 B7       STAA    0301    VAULT -> CHECKBOX       ;
        LDAA    VAULT1          ; 04B3 B6       LDAA    030B    |                       ;
        STAA    CHBOX1          ; 04B6 B7       STAA    0306    |                       ;
        LDAA    VAULT2          ; 04B9 B6       LDAA    030C    |                       ;
        STAA    CHBOX2          ; 04BC B7       STAA    0307    |                       ;
        LDAA    VAULT3          ; 04BF B6       LDAA    030D    |                       ;
        STAA    CHBOX3          ; 04C2 B7       STAA    0308    |                       ;
        LDAA    VAULT4          ; 04C5 B6       LDAA    030E    |                       ;
        STAA    CHBOX4          ; 04C8 B7       STAA    0309    |                       ;
        LDAA    VAULT5          ; 04CB B6       LDAA    030F    |                       ;
        STAA    CHBOX5          ; 04CE B7       STAA    030A    -                       ;
        STX     CRTMP1          ; 04D1 FF       STX     0313 HITCOUNT ROUTINE           ;
        CLR     HITCCNT         ; 04D4 7F       CLR     0310                            ;                            
        LDX     #GUESS1         ; 04D7 CE       LDX     #0301                           ;
LBL11   LDAA    0,X             ; 04DA A6       LDAA    X00                             ;
        LDAB    5,X             ; 04DC E6       LDAB    X05                             ;
        CBA                     ; 04DE 11       CBA                                     ;
        BEQ     LBL13           ; 04DF 27       BEQ     08 04E9                         ;
LBL12   INX                     ; 04E1 08       INX                                     ;
        CPX     #CHBOX1         ; 04E2 8C       CPX     #0306                           ;
        BEQ     LBL19           ; 04E5 27       BEQ     09 04F2                         ;
        BRA     LBL11           ; 04E7 20       BRA     F1 04DA                         ;
LBL13   INC     HITCCNT         ; 04E9 7C       INC     0310                            ;
        CLR     0,X             ; 04EC 6F       CLR     X00                             ;
        CLR     5,X             ; 04EE 6F       CLR     X05                             ;
        BRA     LBL12           ; 04F0 20       BRA     EF      04E1                    ;
LBL19   CLRB    XCOUNT          ; 04F2 7F       CLR     0311 - EXTRA COUNTER ROUTINE    ;
        LDX     #GUESS1         ; 04F5 CE       LDX     #0301                           ;
LBL18   STX     IXTMP1          ; 04F8 FF       STX     0315                            ;
        CPX     #CHBOX1         ; 04FB 8C       CPX     #0306                           ;
        BEQ     LBL14           ; 04FE 27       BEQ     26      0526                    ;
        LDAA    0,X             ; 0500 A6       LDAA    X00                             ;
        CMPA    #$00            ; 0502 81       CMPA    #00                             ;
        BEQ     LBL15           ; 0504 27       BEQ     1A      0520                    ;
        LDX     #CHBOX1         ; 0506 CE       LDX     #0306                           ;
LBL17   LDAB    0,X             ; 0509 E6       LDAB    X00                             ;
        CBA                     ; 050B 11       CBA                                     ;
        BEQ     LBL16           ; 050C 27       BEQ     08      0516                    ;
        INX                     ; 050E 08       INX                                     ;
        CPX     #VAULT1         ; 050F 8C       CPX     #030B                           ;
        BEQ     LBL15           ; 0512 27       BEQ     0C      0520                    ;
        BRA     LBL17           ; 0514 20       BRA     F3      0509                    ;
LBL16   CLR     0,X             ; 0516 6F       CLR     X00                             ;
        LDX     IXTMP1          ; 0518 FE       LDX     0315                            ;
        INC     XCOUNT          ; 051B 7C       INC     0311                            ;
        CLR     0,X             ; 051E 6F       CLR     X00                             ;
LBL15   LDX     IXTMP1          ; 0520 FE       LDX     0315                            ;
        INX                     ; 0523 08       INX                                     ;
        BRA     LBL18           ; 0524 20       BRA     D2      04F8                    ;
LBL14   LDX     CSRPTR          ; 0526 DE       LDX     1C      - PRINT RESULT          ;
        LDAA    HITCCNT         ; 0528 B6       LDAA    0310                            ;
        INX                     ; 052B 08       INX                                     ;
        INX                     ; 052C 0C       INX                                     ;
        ADDA    #$30            ; 052D 8B       ADDA    #30     0                       ;
        STX     CSRPTR          ; 052F DF       STX     1C                              ;
        JSR     PUTCHR          ; 0531 BD       JSR     FCBC                            ;
        LDX     CSRPTR          ; 0534 DE       LDX     1C                              ;
        INX                     ; 0536 INX                                              ;
        INX                     ; 0537 INX                                              ;
        INX                     ; 0538 INX                                              ;
        INX                     ; 0539 INX                                              ;
        INX                     ; 053A INX                                              ;
        INX                     ; 053B INX                                              ;
        STX     CSRPTR          ; 053C DF       STX     1C                              ;
        LDAA    XCOUNT          ; 053E B6       LDAA    0311                            ;
        ADDA    #$30            ; 0541 8B       ADDA    #030    0                       ;
        JSR     PUTCHR          ; 0543 BD       JSR     FCBC                            ;
        JSR     CRLF            ; 0546 BD       JSR     FD14                            ;
        LDAA    HITCCNT         ; 0549 B6       LDAA    0310                            ;
        CMPA    #$05            ; 054C 81       CMPA    #05                             ;
        BEQ     LBL20           ; 054E 27       BEQ     01      0551                    ;
        RTS                     ; 0550 39       RTS                                     ;
LBL20   LDX     #PRMPT5S        ; 0551 CE       LDX     #0390                           ;
        STX     OUTBUF          ; 0554 DF       STX     11                              ;
        LDX     #PRMPT5E        ; 0556 CE       LDX     #039D                           ;
        STX     OUTEND          ; 0559 CE       STX     0A                              ;
        JSR     OUTSTR          ; 055B BD       JSR     FD8E                            ;
        CLRB                    ; 055E 5F       CLRB                                    ;
        LDAA    GUESSCT         ; 055F B6       LDAA    0312                            ;
        INCA                    ; 0562 EC       INCA                                    ;
        LDX     #$0A            ; 0563 CE       LDX     #000A                           ;
        STX     ARB             ; 0566 DF       STX     04                              ;
        LDX     CSRPTR          ; 0568 DE       LDX     1C                              ;
        JSR     BINASC          ; 056A BD       JSR     FF64                            ;
        LDX     CSRPTR          ; 056D DE       LDX     1C                              ;
        INX                     ; 056F 08       INX                                     ;
        INX                     ; 0570 08       INX                                     ;
        INX                     ; 0571 08       INX                                     ;
        STX     CSRPTR          ; 0572 DF       STX     1C                              ;
        LDX     #PRMPT4M        ; 0574 CE       LDX     #039E                           ;
        STX     OUTBUF          ; 0577 DF       STX     11                              ;
        LDX     #PRMPT4E        ; 0579 CE       LDX     #03A5                           ;
        STX     OUTEND          ; 057C DF       STX     0A                              ;
        JSR     OUTSTR          ; 057E BD       JSR     FD8E                            ;
LBL21   JSR     CRLF            ; 0581 BD       JSR     FD14                            ;
        LDX     #PRMPT5S        ; 0584 CD       LDX     #03B0                           ;
        STX     OUTBUF          ; 0587 DF       STX     11                              ;
        LDX     #PRMPT5E        ; 0589 CE       LDX     #03CF                           ;
        STX     OUTEND          ; 058C DF       STX     0A                              ;
        JSR     OUTSTR          ; 058E BD       JSR     FD8E                            ;
        JSR     INPCHR          ; 0591 BD       JSR     FE71                            ;
        CMPA    #$4E            ; 0594 81       CMPA    #4E     N                       ;
        BEQ     QUIT            ; 0596 27       BEQ     03      059B                    ;
        JMP     START           ; 0598 7E       JMP     0400                            ; Restart the game
QUIT    JMP     DEBUG           ; 059B 7E       JMP     FE64                            ; Exit the program


.EN
        

;
;       range required = 0 -> 6
;       000 = 0
;       001 = 1
;       010 = 2
;       011 = 3
;       100 = 4
;       101 = 5
;       110 = 6
;       
;       AND B 7 -> gives lowest 3 bits.
;       IF B = 7, B should equal 0 (since 7 is not in the required range)
;
;       RND = 10101011
;       
GETRND  LDX     #VAULT1         ; Load the address of the first character of the vault
        CLR     .VCOUNT         ; Clear the counter for the Vault
        LDAB    #$02            ; Load AccB with zero
        STAB    .RND            ; Store it in RND
.LOOP   INC     .RND            ; Increment RND
        LDAA    #$40            ; Load a mask for CA2 flag.
        BITA    KBDPIA+1        ; See if a character has been typed in.
        BEQ     .LOOP           ; Try again if a character hasn't been entered.
        LDAA    KBDPIA          ; Load AccA with the typed character

        CMPA    #$0D            ; Is it <Enter> ?
        BNE     .LOOP           ; If not, cycle
.VAULTP LDAB    #$07            ; Load 7 into AccB
        ANDB   .RND             ; Get lowest 3 bits into AccB

        ADDB    $30             ; AccB now contains an ASCII value
        STAB    0,X             ; Store current ASCII value in VAULTx
        
        ROR     .RND            ; Rotate right though carry i.e. bit shift one right
        INX                     ; Get ready for next vault number
        INC     .VCOUNT         ; Increment Vault counter
        LDAB    .VCOUNT
        CMPB    #$5
        BEQ     .VAULTP
.X      jmp     DEBUG

        RTS
.RND    .DB     1               ; Temporary random number store (1 byte)
.VCOUNT .DB     1               ; Temporary count for vault number
;

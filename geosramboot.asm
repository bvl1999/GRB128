; GEOS 128 restart from REU image
;
; By Bart van Leeuwen in 2021
;
; This software is in the public domain.

*=$1c01

!byte <.end,>.end,$01,$00,$9e               ; Line 1 SYS7182
!convtab pet
!tx "7182"                                  ; Address for sys start in text
!byte $00,$00,$00
*=$1c0d

.startgeos
        sei
        lda     $D506
        and     #$30
        ora     #$47
        sta     $D506
        lda     #$7E
        sta     $FF00
        lda     $D030
        and     #$FE
        sta     $D030
        ldy     #$08
-       lda     .reudata,y
        sta     $DF01,y
        dey
        bpl     -
-       lda     $DF00
        and     #$40
        beq     -
        jmp     $C000

.reudata
!byte $91, $00, $c0, $40, $bc 
!byte $00, $80, $00, $00, $00

.end

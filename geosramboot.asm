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
        lda     #$00
        sta     $ff00          ; select bank 15: kernal, monitor, editor, basic roms enabled, io enabled.
        lda     $df00          ; test bit 4 of REU status register
        and     #$10
        beq     .reuerror      ; no REU pressent, or REU too small (size jumper not set)
        lda     #$00           ; test the behavior of the BANK register, as above check does not actually guarantee the REU is pressent.
        sta     $df06
        lda     $df06
        cmp     #$f8           ; note that the top 5 bits of this register are always 1, regardless of the value stored. This behavior is unique to the REU BANK register
        bne     .reuerror      ; and combined with previous check lets us determine if we really have an REU 
        lda     $D506          ; shared ram and dma target register
        and     #$30           ; keep the 'unused' bits (why exactly? this shouldn't really matter)
        ora     #$47           ; enable 16k shared ram at bottom and top of memory (note: $0000-$3fff come from ram block 0, $c000-$ffff come from ram block 1)
                               ; also, set DMA target to ram block 1 for the REU to ram copy (and yes, this also tells VIC2 to get its data from ram block 1..)
        sta     $D506          ; and store this configuration.
        lda     #$7E           ; select ram block 1 (note: our code actually resides in ram block 0 but will remain visible as it is in the low shared ram area), disable all roms, keep IO enabled.
        sta     $FF00
        ldx     #(.resetcode_end - .resetcode) - 1
-
        lda     .resetcode,x   ; copy GEOS reset handler to $03e4 (GEOS will take care of setting up the pointer to this handler, but won't put the handler in place unless you do a cold start from disk)
        sta     $03e4,x
        dex
        bpl     -
        lda     $D030
        and     #$FE           ; 1mhz mode for DMA, system will often crash after completion of DMA when in 2mhz mode (50% chance of starting at the wrong phase of the clock)
        sta     $D030
        ldy     #$08
-       lda     .reudata,y     ; setup REU for copying bootloader to ram
        sta     $DF01,y
        dey
        bpl     -
-       lda     $DF00          ; ensure REU is done (GEOSism, this should not be needed in this specific situation, but is needed when using the $FF00 trigger and having external code (irq) trigger the actual transfer)
        and     #$40
        beq     -
        ldx     #$05 
-
        lda     $c000,x        ; does this look like a GEOS rboot loader?
        cmp     .sig,x
        bne     .sigerror
        dex
        bpl     -
        jmp     $C000          ; yes it did, call it, it will take care of everything from here.

; print message and exit, note this must be called with a default shared ram config and with a bank 15 memory config
.reuerror
        ldx     #$00
-
        lda     .error1msg,x
        beq     +
        jsr     $ffd2
        inx
        bne -
+
        cli
        rts    

; we didn't find something which looks like a GEOS rboot loader. Note we first need to setup a 'sane' memory config so we can call kernal functions and return to basic.
.sigerror
        ldx     #$00
        stx     $ff00          ; set memory map to 'bank 15', this must be done before restoring the default shared ram config
        lda     #$04           ; set DMA target and shared ram config to ram block 0 for DMA and 1k shared ram at bottom of memory
        sta     $d506
-
        lda     .error2msg,x   ; print error message.
        beq +
        jsr     $ffd2
        inx
        bne -
+
        cli
        rts

; a GEOS rboot loader should start with this
.sig
        jmp     $c01b
        jmp     $5000

.error1msg
!tx "reu not found or too small"
!byte $0d, $00

.error2msg
!tx "geos ramboot image not found"
!byte $0d, $00              

.reudata
!byte $91, $00, $c0, $40, $bc 
!byte $00, $80, $00, $00, $00

.resetcode
        lda     #$7e
        sta     $ff00
        jmp     $c000
.resetcode_end

.end
!byte 0,0

RESET       mov.w    #__STACK_END,SP                        ; Stack pointer
StopWDT     mov.w    #WDTPW|WDTHOLD,&WDTCTL 
	    bis.b    #01h, &P1DIR                           ; set P1.0 as output
	           
Setup_P1    bic.b    #010h, &P1DIR                          ; set P1.4 as input 0001 0000, if you want P2.3, 0000 1000 -> 04h
	    bis.b    #010h, &P1IE                           ; enable interrupt for port 2 using P1.4
	    bis.b    #010h, &P1IES                          ; enable high to low interrupt 
	    bic.b    #010h, &P1IFG                          ; clear the flag bit

Mainloop    bis.w    #CPUOFF+GIE,SR                         ; CPU OFF, enable interrupts -> Cpu sleep
            Nop                                      	    ;Required only for debugger, no operation

;---------------------------------------------------------------------------------------------------------------------------------------------------
;the ISR
;---------------------------------------------------------------------------------------------------------------------------------------------------
P1_ISR:
	    xor.b     #001h, &P1OUT                          ;P1.0 = toggle
	    bic.b     #010h, &P1IFG                          ;P1.4 IFG Cleared
            Reti                                             ; Return from ISR

;---------------------------------------------------------------------------------------------------------------------------------------------------
;Interrupt Vectors
;---------------------------------------------------------------------------------------------------------------------------------------------------
	    .sect    ".reset"                                ; MSP430 RESET Vector
	    .short   RESET
	    .sect    ".int02"                                ; P1.x Vector
            .short   P2_ISR
            .end

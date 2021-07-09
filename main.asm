        .cdecls C,LIST,"msp430.h"
        .text

RESET:      mov.w #__STACK_END,SP ; Stack pointer
StopWDT:    bic.b #001h,&P2DIR                              ;set P2.0 as input
	        bis.b #001h,&P1DIR                              ;set P1.0 as output
            bis.b #040h,&P1DIR                              ;set P1.6 as output

Main_LOOP   bit.b #001h,&P2IN
            inc.b &P2IN
            jz Blink_RED
Blink_Green and.b #0x06,&P2IN
            call #Delay
            jmp Main_Loop
Blink_RED   and.b #0x06, &P2IN
            call #Delay
            jmp Main_LOOP
Delay:
            mov.w  #50000,r11
            loop dec.w r11
            jnz loop
            ret

        .global_STACK_END
        .sect  .stack

        .sect  ".reset"
        .short RESET
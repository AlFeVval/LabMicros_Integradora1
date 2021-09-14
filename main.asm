; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

#include "p18f4550.inc"

; CONFIG1L
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = HS             ; Oscillator Selection bits (HS oscillator (HS))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOR = ON              ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = ON              ; Watchdog Timer Enable bit (WDT enabled)
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = ON              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)

;****************Variables Definition*********************************			;

COCIENT		EQU	0x90
RESID		EQU	0xA0
RESULTADO	EQU	0xB0
	
MIN		EQU	0x10
DECS		EQU	0x20
UNIS		EQU	0x30

TEMP		EQU	0x50
TM1		EQU	0x60			;	
TM2		EQU	0x70			;	
TM3		EQU	0x80			;
CONSTANT D_60 = 0x3C
CONSTANT D_10 = 0x0A
;****************Main code*****************************
    #DEFINE		pausa	    PORTB,7
    #DEFINE		continuar   PORTB,6
    #DEFINE		reinicio    PORTB,5
    
    #DEFINE		a_ds	    LATB,4
    #DEFINE		b_ds	    LATB,3
    #DEFINE		c_ds	    LATB,2
    #DEFINE		d_ds	    LATB,1
    #DEFINE		e_ds	    LATB,0
    #DEFINE		f_ds	    LATC,7
    #DEFINE		g_ds	    LATC,6
    
    #DEFINE		a_us	    LATD,7
   
    
    
			ORG     0x000             	;reset vector
  			GOTO    MAIN              	;go to the main routine
INITIALIZE:
			MOVLW	D'6'
			MOVWF	ADCON1
			MOVLW	b'11100000'
			CLRF	TRISC
			MOVWF	TRISB
			CLRF	TRISA
			CLRF	TRISD			;Puerto D como salidas
			RETURN				;end of initialization subroutine

MAIN:
			CALL 	INITIALIZE

BASE:
			CALL	COUNTDOWN
			CALL	DELAY_1S
			CALL	SHOW
			GOTO 	BASE	    ;infinite loop
			
COUNTDOWN:
			MOVF	TEMP,F			;
			BZ	VALUE
			DECF	TEMP			;
			MOVF	TEMP,W
			MOVWF	RESULTADO
			CALL	DIVIDE_60
			CALL	SET_RES_MIN
			CALL	DIVIDE_10
			CLRF	COCIENT
			RETURN				;   
VALUE:
			MOVLW	d'181'			;
			MOVWF	TEMP			;
			GOTO	COUNTDOWN		;	
			
DIVIDE_60:
			MOVLW	D_60
			SUBWF	RESULTADO
			MOVF	RESULTADO,F
			BTFSC	STATUS,C
			GOTO	INC_COCIENTE_MIN
			GOTO	RESIDUO_MIN
			RETURN

INC_COCIENTE_MIN:
			INCF	COCIENT
			MOVF	COCIENT,W
			MOVWF	MIN
			GOTO	DIVIDE_60

RESIDUO_MIN:
			MOVLW	D_60
			ADDWF	RESULTADO,W
			MOVWF	RESID
			RETURN
			
SET_RES_MIN:
			MOVF	RESID,W
			MOVWF	RESULTADO
			CLRF	COCIENT
			RETURN
    
DIVIDE_10:
			MOVLW	D_10
			subwf	RESULTADO
			MOVF	RESULTADO,F
			BTFSC	STATUS,C
			GOTO	INC_COCIENTE_DS
			GOTO	RESIDUO_DS
			
INC_COCIENTE_DS:
			INCF	COCIENT
			MOVF	COCIENT,W
			MOVWF	DECS
			GOTO	DIVIDE_10
			
RESIDUO_DS:
			MOVLW	D_10
			ADDWF	RESULTADO,W
			MOVWF	UNIS
			RETURN
			

SHOW:
			CALL	DISP_MIN
			CALL	DISP_DECS
			CALL	DISP_UNIS
			RETURN
			
DISP_MIN:
			MOVLW	0x00
			SUBWF	MIN,0	
			BZ  D0
			MOVLW	0x01
			SUBWF	MIN,0
			BZ  D1
			MOVLW	0x02
			SUBWF	MIN,0
			BZ  D2
			MOVLW	0x03
			SUBWF	MIN,0
			BZ  D3	
			RETURN
			
DISP_DECS:
			MOVLW	0x00
			SUBWF	DECS,0	
			BZ  D0_DS
			MOVLW	0x01
			SUBWF	DECS,0
			BZ  D1_DS
			MOVLW	0x02
			SUBWF	DECS,0
			BZ  D2_DS
			MOVLW	0x03
			SUBWF	DECS,0
			BZ  D3_DS
			MOVLW	0x04
			SUBWF	DECS,0
			BZ  D4_DS
			MOVLW	0x05
			SUBWF	DECS,0
			BZ  D5_DS
			MOVLW	0x06
			SUBWF	DECS,0
			RETURN
			
DISP_UNIS:
			MOVLW	0x00
			SUBWF	UNIS,0	
			BZ  D0_US
			MOVLW	0x01
			SUBWF	UNIS,0
			BZ  D1_US
			MOVLW	0x02
			SUBWF	UNIS,0
			BZ  D2_US
			MOVLW	0x03
			SUBWF	UNIS,0
			BZ  D3_US
			MOVLW	0x04
			SUBWF	UNIS,0
			BZ  D4_US
			MOVLW	0x05
			SUBWF	UNIS,0
			BZ  D5_US
			MOVLW	0x06
			SUBWF	UNIS,0
			BZ  D6_US
			MOVLW	0x07
			SUBWF	UNIS,0
			BZ  D7_US
			MOVLW	0x08
			SUBWF	UNIS,0
			BZ  D8_US
			MOVLW	0x09
			SUBWF	UNIS,0
			BZ  D9_US
			RETURN
			
D0:
			MOVLW	b'01111110'		;//0
			MOVWF	PORTD			;
			RETURN;
D1:
			MOVLW	b'00110000'		;//1
			MOVWF	PORTD			;
			RETURN			;
D2:
			MOVLW	b'01101101'		;//2
			MOVWF	PORTD			;
			RETURN		;
D3:
			MOVLW	b'01111001'		;//3
			MOVWF	PORTD			;
			RETURN			;
			
D0_DS:
			BSF	a_ds;
			BSF	b_ds;
			BSF	c_ds;
			BSF	d_ds;
			BSF	e_ds;
			BSF	f_ds;
			BCF	g_ds;
			RETURN;
			
D1_DS:
			BCF	a_ds;
			BSF	b_ds;
			BSF	c_ds;
			BCF	d_ds;
			BCF	e_ds;
			BCF	f_ds;
			BCF	g_ds;			;
			RETURN			
			
D2_DS:
			BSF	a_ds;
			BSF	b_ds;
			BCF	c_ds;
			BSF	d_ds;
			BSF	e_ds;
			BCF	f_ds;
			BSF	g_ds;
			RETURN		

D3_DS:
			BSF	a_ds;
			BSF	b_ds;
			BSF	c_ds;
			BSF	d_ds;
			BCF	e_ds;
			BCF	f_ds;
			BSF	g_ds;
			RETURN			
D4_DS:
			BCF	a_ds;
			BSF	b_ds;
			BSF	c_ds;
			BCF	d_ds;
			BCF	e_ds;
			BSF	f_ds;
			BSF	g_ds;		;
			RETURN
			
D5_DS:
			BSF	a_ds;
			BCF	b_ds;
			BSF	c_ds;
			BSF	d_ds;
			BCF	e_ds;
			BSF	f_ds;
			BSF	g_ds;			
			RETURN

D0_US:
			MOVLW	b'01111110'		;//0
			MOVWF	PORTA			;
			BSF	a_us
			RETURN;
D1_US:
			MOVLW	b'00110000'		;//1
			MOVWF	PORTA			;
			BCF	a_us
			RETURN			;
D2_US:
			MOVLW	b'01101101'		;//2
			MOVWF	PORTA			;
			BSF	a_us
			RETURN		;
D3_US:
			MOVLW	b'01111001'		;//3
			MOVWF	PORTA			;
			BSF	a_us    
			RETURN			;
D4_US:
			MOVLW	b'00110011'		;//4
			MOVWF	PORTA			;
			BCF	a_us
			RETURN			;
D5_US:
			MOVLW	b'01011011'		;//5
			MOVWF	PORTA			;
			BSF	a_us
			RETURN;
D6_US:
			MOVLW	b'01011111'		;//6
			MOVWF	PORTA			;
			BSF	a_us
			RETURN			;
D7_US:
			MOVLW	b'01110000'		;//7
			MOVWF	PORTA	
			BSF	a_us
			RETURN			;
D8_US:
			MOVLW	b'01111111'		;//8
			MOVWF	PORTA	
			BSF	a_us
			RETURN;
D9_US:
			MOVLW	b'01111011'		;//9
			MOVWF	PORTA			;
			BSF	a_us
			RETURN
			
DELAY_1S:		
    			MOVLW	d'6'			;
			MOVWF	TM1			;
			MOVLW	D'235'			;
		T3:	MOVWF	TM2			;
		T2:	MOVWF	TM3			;
		T1:	DECFSZ	TM3			;
			GOTO	T1		        ;
			DECFSZ	TM2			;
			GOTO	T2			;
			DECFSZ	TM1			;
			GOTO	T3			;		
			RETURN

			
			END
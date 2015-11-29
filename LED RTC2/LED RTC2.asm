
_main:

;LED RTC2.c,57 :: 		void main(){
;LED RTC2.c,58 :: 		ADCON1 = 7;
	MOVLW      7
	MOVWF      ADCON1+0
;LED RTC2.c,59 :: 		CMCON = 7;
	MOVLW      7
	MOVWF      CMCON+0
;LED RTC2.c,60 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;LED RTC2.c,61 :: 		I2C1_Init(100000); //DS1307 I2C is running at 100KHz
	MOVLW      10
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;LED RTC2.c,62 :: 		TRISB = 0x00; // Configure PORTB as output
	CLRF       TRISB+0
;LED RTC2.c,63 :: 		TRISA = 0x00;
	CLRF       TRISA+0
;LED RTC2.c,64 :: 		TRISC = 0xFF;
	MOVLW      255
	MOVWF      TRISC+0
;LED RTC2.c,65 :: 		TRISE = 0xFF;
	MOVLW      255
	MOVWF      TRISE+0
;LED RTC2.c,66 :: 		write_ds1307(0x18,0x00);
	MOVLW      24
	MOVWF      FARG_write_ds1307_address+0
	CLRF       FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,67 :: 		write_ds1307(0x19,0x00);
	MOVLW      25
	MOVWF      FARG_write_ds1307_address+0
	CLRF       FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,68 :: 		step=0;
	CLRF       _step+0
;LED RTC2.c,69 :: 		mode=0;
	CLRF       _mode+0
;LED RTC2.c,70 :: 		wave=0;
	CLRF       _wave+0
;LED RTC2.c,71 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;LED RTC2.c,72 :: 		lcdprint(0);
	CLRF       FARG_lcdprint_i+0
	CLRF       FARG_lcdprint_i+1
	CALL       _lcdprint+0
;LED RTC2.c,73 :: 		Delay_ms(timedelay);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	NOP
	NOP
;LED RTC2.c,75 :: 		while(1)
L_main1:
;LED RTC2.c,77 :: 		uartstarter();
	CALL       _uartstarter+0
;LED RTC2.c,78 :: 		stbutton();
	CALL       _stbutton+0
;LED RTC2.c,79 :: 		step=read_ds1307(0x18);
	MOVLW      24
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _step+0
;LED RTC2.c,80 :: 		dirstep=read_ds1307(0x19);
	MOVLW      25
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _dirstep+0
;LED RTC2.c,81 :: 		if (PORTA.F5==0){steppermotor(step);}
	BTFSC      PORTA+0, 5
	GOTO       L_main3
	MOVF       _step+0, 0
	MOVWF      FARG_steppermotor_step+0
	CALL       _steppermotor+0
L_main3:
;LED RTC2.c,82 :: 		lcdprint(1);
	MOVLW      1
	MOVWF      FARG_lcdprint_i+0
	MOVLW      0
	MOVWF      FARG_lcdprint_i+1
	CALL       _lcdprint+0
;LED RTC2.c,83 :: 		delay_us(100);
	MOVLW      33
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
;LED RTC2.c,84 :: 		}
	GOTO       L_main1
;LED RTC2.c,85 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_uartstarter:

;LED RTC2.c,86 :: 		void uartstarter()
;LED RTC2.c,88 :: 		if (UART1_Data_Ready() != 0) {
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_uartstarter5
;LED RTC2.c,89 :: 		uart_rd = UART1_Read(); // read the received data,
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_rd+0
;LED RTC2.c,90 :: 		}
L_uartstarter5:
;LED RTC2.c,91 :: 		EEPROM_write(0x500,uart_rd);
	MOVLW      0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;LED RTC2.c,92 :: 		uart_wt[0]=EEPROM_read(0x500);
	MOVLW      0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_wt+0
;LED RTC2.c,93 :: 		uart_wt[1]=EEPROM_read(0x502);
	MOVLW      2
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_wt+1
;LED RTC2.c,94 :: 		Lcd_Out(1,1,uart_wt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _uart_wt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LED RTC2.c,95 :: 		if (UART1_Data_Ready() != 0) {
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_uartstarter6
;LED RTC2.c,96 :: 		UART1_Write(&uart_wt);
	MOVLW      _uart_wt+0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;LED RTC2.c,97 :: 		}// sends back text
L_uartstarter6:
;LED RTC2.c,98 :: 		return;
;LED RTC2.c,99 :: 		}
L_end_uartstarter:
	RETURN
; end of _uartstarter

_stbutton:

;LED RTC2.c,100 :: 		void stbutton()
;LED RTC2.c,102 :: 		if(PORTE.F0==0 && PORTE.F1==0){
	BTFSC      PORTE+0, 0
	GOTO       L_stbutton9
	BTFSC      PORTE+0, 1
	GOTO       L_stbutton9
L__stbutton88:
;LED RTC2.c,103 :: 		write_ds1307(0,0x80); //Reset second to 0 sec. and stop Oscillator
	CLRF       FARG_write_ds1307_address+0
	MOVLW      128
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,104 :: 		write_ds1307(1,0x00); //write min 0
	MOVLW      1
	MOVWF      FARG_write_ds1307_address+0
	CLRF       FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,105 :: 		write_ds1307(2,0x49); //write hour 9 PM
	MOVLW      2
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      73
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,106 :: 		write_ds1307(3,0x01); //write day of week 4:Wednesday
	MOVLW      3
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      1
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,107 :: 		write_ds1307(4,0x23); // write date 1
	MOVLW      4
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      35
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,108 :: 		write_ds1307(5,0x11); // write month Jan
	MOVLW      5
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      17
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,109 :: 		write_ds1307(6,0x14); // write year 14 --> 2014
	MOVLW      6
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      20
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,110 :: 		write_ds1307(7,0x10); //SQWE output at 1 Hz
	MOVLW      7
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      16
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,111 :: 		write_ds1307(0,0x00); //Reset second to 0 sec. and start Oscillator
	CLRF       FARG_write_ds1307_address+0
	CLRF       FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,112 :: 		Delay_ms(timedelay);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_stbutton10:
	DECFSZ     R13+0, 1
	GOTO       L_stbutton10
	DECFSZ     R12+0, 1
	GOTO       L_stbutton10
	NOP
	NOP
;LED RTC2.c,113 :: 		}
L_stbutton9:
;LED RTC2.c,114 :: 		if (PORTE.F0==0 && PORTE.F1==1){
	BTFSC      PORTE+0, 0
	GOTO       L_stbutton13
	BTFSS      PORTE+0, 1
	GOTO       L_stbutton13
L__stbutton87:
;LED RTC2.c,115 :: 		mode++;
	INCF       _mode+0, 1
;LED RTC2.c,116 :: 		Delay_ms(timedelay);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_stbutton14:
	DECFSZ     R13+0, 1
	GOTO       L_stbutton14
	DECFSZ     R12+0, 1
	GOTO       L_stbutton14
	NOP
	NOP
;LED RTC2.c,117 :: 		if (mode>2){mode=0;}
	MOVF       _mode+0, 0
	SUBLW      2
	BTFSC      STATUS+0, 0
	GOTO       L_stbutton15
	CLRF       _mode+0
L_stbutton15:
;LED RTC2.c,118 :: 		}
L_stbutton13:
;LED RTC2.c,121 :: 		if (PORTE.F1==0 && mode==0 && PORTE.F0==1){
	BTFSC      PORTE+0, 1
	GOTO       L_stbutton18
	MOVF       _mode+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_stbutton18
	BTFSS      PORTE+0, 0
	GOTO       L_stbutton18
L__stbutton86:
;LED RTC2.c,122 :: 		write_ds1307(0x19,0x01);
	MOVLW      25
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      1
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,123 :: 		Delay_ms(timedelay);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_stbutton19:
	DECFSZ     R13+0, 1
	GOTO       L_stbutton19
	DECFSZ     R12+0, 1
	GOTO       L_stbutton19
	NOP
	NOP
;LED RTC2.c,124 :: 		}
L_stbutton18:
;LED RTC2.c,125 :: 		if (PORTE.F2==0 && mode==0){
	BTFSC      PORTE+0, 2
	GOTO       L_stbutton22
	MOVF       _mode+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_stbutton22
L__stbutton85:
;LED RTC2.c,126 :: 		write_ds1307(0x19,0x00);
	MOVLW      25
	MOVWF      FARG_write_ds1307_address+0
	CLRF       FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,127 :: 		Delay_ms(timedelay);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_stbutton23:
	DECFSZ     R13+0, 1
	GOTO       L_stbutton23
	DECFSZ     R12+0, 1
	GOTO       L_stbutton23
	NOP
	NOP
;LED RTC2.c,128 :: 		}
L_stbutton22:
;LED RTC2.c,132 :: 		if (PORTE.F1==0 && mode==1 && PORTE.F0==1){
	BTFSC      PORTE+0, 1
	GOTO       L_stbutton26
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_stbutton26
	BTFSS      PORTE+0, 0
	GOTO       L_stbutton26
L__stbutton84:
;LED RTC2.c,133 :: 		write_ds1307(0,0x80); //Reset second to 0 sec. and stop Oscillator
	CLRF       FARG_write_ds1307_address+0
	MOVLW      128
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,134 :: 		write_ds1307(1,0x00); //write min 0
	MOVLW      1
	MOVWF      FARG_write_ds1307_address+0
	CLRF       FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,135 :: 		write_ds1307(2,0x43); //write hour 9 PM
	MOVLW      2
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      67
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,136 :: 		write_ds1307(0,0x00); //Reset second to 0 sec. and start Oscillator
	CLRF       FARG_write_ds1307_address+0
	CLRF       FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,137 :: 		Delay_ms(timedelay);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_stbutton27:
	DECFSZ     R13+0, 1
	GOTO       L_stbutton27
	DECFSZ     R12+0, 1
	GOTO       L_stbutton27
	NOP
	NOP
;LED RTC2.c,138 :: 		}
L_stbutton26:
;LED RTC2.c,139 :: 		if (PORTE.F2==0 && mode==1){
	BTFSC      PORTE+0, 2
	GOTO       L_stbutton30
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_stbutton30
L__stbutton83:
;LED RTC2.c,140 :: 		write_ds1307(0,0x80); //Reset second to 0 sec. and stop Oscillator
	CLRF       FARG_write_ds1307_address+0
	MOVLW      128
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,141 :: 		write_ds1307(1,0x59); //write min 0
	MOVLW      1
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      89
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,142 :: 		write_ds1307(2,0x46); //write hour 9 PM
	MOVLW      2
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      70
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,143 :: 		write_ds1307(0,0x00); //Reset second to 0 sec. and start Oscillator
	CLRF       FARG_write_ds1307_address+0
	CLRF       FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,144 :: 		Delay_ms(timedelay);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_stbutton31:
	DECFSZ     R13+0, 1
	GOTO       L_stbutton31
	DECFSZ     R12+0, 1
	GOTO       L_stbutton31
	NOP
	NOP
;LED RTC2.c,145 :: 		}
L_stbutton30:
;LED RTC2.c,149 :: 		if (PORTE.F1==0 && mode==2 && PORTE.F0==1){
	BTFSC      PORTE+0, 1
	GOTO       L_stbutton34
	MOVF       _mode+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_stbutton34
	BTFSS      PORTE+0, 0
	GOTO       L_stbutton34
L__stbutton82:
;LED RTC2.c,150 :: 		write_ds1307(0x10,0x01);
	MOVLW      16
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      1
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,151 :: 		write_ds1307(0x11,0x02);
	MOVLW      17
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      2
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,152 :: 		write_ds1307(0x12,0x04);
	MOVLW      18
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      4
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,153 :: 		write_ds1307(0x13,0x08);
	MOVLW      19
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      8
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,154 :: 		Delay_ms(timedelay);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_stbutton35:
	DECFSZ     R13+0, 1
	GOTO       L_stbutton35
	DECFSZ     R12+0, 1
	GOTO       L_stbutton35
	NOP
	NOP
;LED RTC2.c,155 :: 		}
L_stbutton34:
;LED RTC2.c,156 :: 		if (PORTE.F2==0 && mode==2){
	BTFSC      PORTE+0, 2
	GOTO       L_stbutton38
	MOVF       _mode+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_stbutton38
L__stbutton81:
;LED RTC2.c,157 :: 		write_ds1307(0x10,0x03);
	MOVLW      16
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      3
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,158 :: 		write_ds1307(0x11,0x06);
	MOVLW      17
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      6
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,159 :: 		write_ds1307(0x12,0x0C);
	MOVLW      18
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      12
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,160 :: 		write_ds1307(0x13,0x09);
	MOVLW      19
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      9
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,161 :: 		Delay_ms(timedelay);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_stbutton39:
	DECFSZ     R13+0, 1
	GOTO       L_stbutton39
	DECFSZ     R12+0, 1
	GOTO       L_stbutton39
	NOP
	NOP
;LED RTC2.c,162 :: 		}
L_stbutton38:
;LED RTC2.c,164 :: 		return;
;LED RTC2.c,165 :: 		}
L_end_stbutton:
	RETURN
; end of _stbutton

_steppermotor:

;LED RTC2.c,167 :: 		void steppermotor(short step)
;LED RTC2.c,169 :: 		if (step==0){ PORTA = read_ds1307(0x10);}
	MOVF       FARG_steppermotor_step+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_steppermotor40
	MOVLW      16
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      PORTA+0
	GOTO       L_steppermotor41
L_steppermotor40:
;LED RTC2.c,170 :: 		else if (step==1){ PORTA = read_ds1307(0x11);}
	MOVF       FARG_steppermotor_step+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_steppermotor42
	MOVLW      17
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      PORTA+0
	GOTO       L_steppermotor43
L_steppermotor42:
;LED RTC2.c,171 :: 		else if (step==2){ PORTA = read_ds1307(0x12);}
	MOVF       FARG_steppermotor_step+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_steppermotor44
	MOVLW      18
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      PORTA+0
	GOTO       L_steppermotor45
L_steppermotor44:
;LED RTC2.c,172 :: 		else if (step==3){ PORTA = read_ds1307(0x13);}
	MOVF       FARG_steppermotor_step+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_steppermotor46
	MOVLW      19
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      PORTA+0
L_steppermotor46:
L_steppermotor45:
L_steppermotor43:
L_steppermotor41:
;LED RTC2.c,173 :: 		PORTA.F5 = temp;
	BTFSC      _temp+0, 0
	GOTO       L__steppermotor93
	BCF        PORTA+0, 5
	GOTO       L__steppermotor94
L__steppermotor93:
	BSF        PORTA+0, 5
L__steppermotor94:
;LED RTC2.c,174 :: 		if (dirstep == 1){
	MOVF       _dirstep+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_steppermotor47
;LED RTC2.c,175 :: 		step--;
	DECF       FARG_steppermotor_step+0, 1
;LED RTC2.c,176 :: 		if (step<0){step=3;}
	MOVLW      128
	XORWF      FARG_steppermotor_step+0, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      0
	SUBWF      R0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_steppermotor48
	MOVLW      3
	MOVWF      FARG_steppermotor_step+0
L_steppermotor48:
;LED RTC2.c,177 :: 		write_ds1307(0x18,step);
	MOVLW      24
	MOVWF      FARG_write_ds1307_address+0
	MOVF       FARG_steppermotor_step+0, 0
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,178 :: 		}
	GOTO       L_steppermotor49
L_steppermotor47:
;LED RTC2.c,180 :: 		step++;
	INCF       FARG_steppermotor_step+0, 1
;LED RTC2.c,181 :: 		if (step>3){step=0;}
	MOVLW      128
	XORLW      3
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_steppermotor_step+0, 0
	SUBWF      R0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_steppermotor50
	CLRF       FARG_steppermotor_step+0
L_steppermotor50:
;LED RTC2.c,182 :: 		write_ds1307(0x18,step);
	MOVLW      24
	MOVWF      FARG_write_ds1307_address+0
	MOVF       FARG_steppermotor_step+0, 0
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,183 :: 		}
L_steppermotor49:
;LED RTC2.c,184 :: 		return;
;LED RTC2.c,185 :: 		}
L_end_steppermotor:
	RETURN
; end of _steppermotor

_lcdprint:

;LED RTC2.c,186 :: 		void lcdprint(int i)
;LED RTC2.c,188 :: 		if (i==1){
	MOVLW      0
	XORWF      FARG_lcdprint_i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__lcdprint96
	MOVLW      1
	XORWF      FARG_lcdprint_i+0, 0
L__lcdprint96:
	BTFSS      STATUS+0, 2
	GOTO       L_lcdprint51
;LED RTC2.c,189 :: 		datafetch();
	CALL       _datafetch+0
;LED RTC2.c,191 :: 		Lcd_Out(2,1,time);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _time+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LED RTC2.c,192 :: 		if  (mode==0){res=strncpy(txt,txt1,17);}
	MOVF       _mode+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_lcdprint52
	MOVLW      _txt+0
	MOVWF      FARG_strncpy_to+0
	MOVLW      _txt1+0
	MOVWF      FARG_strncpy_from+0
	MOVLW      17
	MOVWF      FARG_strncpy_size+0
	MOVLW      0
	MOVWF      FARG_strncpy_size+1
	CALL       _strncpy+0
	MOVF       R0+0, 0
	MOVWF      _res+0
	CLRF       _res+1
	GOTO       L_lcdprint53
L_lcdprint52:
;LED RTC2.c,193 :: 		else if (mode==1){res=strncpy(txt,txt2,17);}
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_lcdprint54
	MOVLW      _txt+0
	MOVWF      FARG_strncpy_to+0
	MOVLW      _txt2+0
	MOVWF      FARG_strncpy_from+0
	MOVLW      17
	MOVWF      FARG_strncpy_size+0
	MOVLW      0
	MOVWF      FARG_strncpy_size+1
	CALL       _strncpy+0
	MOVF       R0+0, 0
	MOVWF      _res+0
	CLRF       _res+1
	GOTO       L_lcdprint55
L_lcdprint54:
;LED RTC2.c,194 :: 		else if (mode==2){res=strncpy(txt,txt3,17);}
	MOVF       _mode+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_lcdprint56
	MOVLW      _txt+0
	MOVWF      FARG_strncpy_to+0
	MOVLW      _txt3+0
	MOVWF      FARG_strncpy_from+0
	MOVLW      17
	MOVWF      FARG_strncpy_size+0
	MOVLW      0
	MOVWF      FARG_strncpy_size+1
	CALL       _strncpy+0
	MOVF       R0+0, 0
	MOVWF      _res+0
	CLRF       _res+1
L_lcdprint56:
L_lcdprint55:
L_lcdprint53:
;LED RTC2.c,195 :: 		Lcd_Out(3,1,res);
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _res+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LED RTC2.c,196 :: 		return;
	GOTO       L_end_lcdprint
;LED RTC2.c,197 :: 		}
L_lcdprint51:
;LED RTC2.c,199 :: 		Lcd_Cmd(_Lcd_CLEAR); // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LED RTC2.c,200 :: 		Lcd_Cmd(_Lcd_CURSOR_OFF); // Turn cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LED RTC2.c,201 :: 		Lcd_Out(1,1,"Prj Night RTCLED");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_LED_32RTC2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LED RTC2.c,202 :: 		Lcd_Out(2,1,txta);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txta+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LED RTC2.c,203 :: 		Lcd_Out(3,1,am);
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_LED_32RTC2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LED RTC2.c,204 :: 		Delay_ms(3800);
	MOVLW      20
	MOVWF      R11+0
	MOVLW      72
	MOVWF      R12+0
	MOVLW      1
	MOVWF      R13+0
L_lcdprint58:
	DECFSZ     R13+0, 1
	GOTO       L_lcdprint58
	DECFSZ     R12+0, 1
	GOTO       L_lcdprint58
	DECFSZ     R11+0, 1
	GOTO       L_lcdprint58
;LED RTC2.c,205 :: 		Lcd_Cmd(_Lcd_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LED RTC2.c,206 :: 		return;
;LED RTC2.c,208 :: 		}
L_end_lcdprint:
	RETURN
; end of _lcdprint

_datafetch:

;LED RTC2.c,210 :: 		void datafetch()
;LED RTC2.c,212 :: 		sec=read_ds1307(0); // read second
	CLRF       FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _sec+0
;LED RTC2.c,213 :: 		minute=read_ds1307(1); // read minute
	MOVLW      1
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _minute+0
;LED RTC2.c,214 :: 		hour=read_ds1307(2); // read hour
	MOVLW      2
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _hour+0
;LED RTC2.c,215 :: 		day=read_ds1307(3); // read day
	MOVLW      3
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _day+0
;LED RTC2.c,216 :: 		date=read_ds1307(4); // read date
	MOVLW      4
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _date+0
;LED RTC2.c,217 :: 		month=read_ds1307(5); // read month
	MOVLW      5
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _month+0
;LED RTC2.c,218 :: 		year=read_ds1307(6); // read year
	MOVLW      6
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _year+0
;LED RTC2.c,220 :: 		if ((hour >= 0x43)&(hour <= 0x46)){
	MOVLW      67
	SUBWF      _hour+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _hour+0, 0
	SUBLW      70
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_datafetch59
;LED RTC2.c,221 :: 		PORTA.F5=1;temp=1;
	BSF        PORTA+0, 5
	MOVLW      1
	MOVWF      _temp+0
;LED RTC2.c,222 :: 		write_ds1307(0x20,0x02);
	MOVLW      32
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      2
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,223 :: 		}
	GOTO       L_datafetch60
L_datafetch59:
;LED RTC2.c,225 :: 		PORTA.F5=0;temp=0;
	BCF        PORTA+0, 5
	CLRF       _temp+0
;LED RTC2.c,226 :: 		write_ds1307(0x20,0x01);
	MOVLW      32
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      1
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;LED RTC2.c,227 :: 		}
L_datafetch60:
;LED RTC2.c,228 :: 		date_cast();
	CALL       _date_cast+0
;LED RTC2.c,229 :: 		time_cast();
	CALL       _time_cast+0
;LED RTC2.c,230 :: 		return;
;LED RTC2.c,231 :: 		}
L_end_datafetch:
	RETURN
; end of _datafetch

_date_cast:

;LED RTC2.c,232 :: 		void date_cast(){
;LED RTC2.c,234 :: 		dday = BCD2LowerCh(day);
	MOVF       _day+0, 0
	MOVWF      FARG_BCD2LowerCh_bcd+0
	CALL       _BCD2LowerCh+0
	MOVF       R0+0, 0
	MOVWF      _dday+0
;LED RTC2.c,235 :: 		if (dday == '1') {
	MOVF       R0+0, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_date_cast61
;LED RTC2.c,236 :: 		ddate[0] ='S';
	MOVLW      83
	MOVWF      _ddate+0
;LED RTC2.c,237 :: 		ddate[1] ='u';
	MOVLW      117
	MOVWF      _ddate+1
;LED RTC2.c,238 :: 		ddate[2] ='n';
	MOVLW      110
	MOVWF      _ddate+2
;LED RTC2.c,239 :: 		}
	GOTO       L_date_cast62
L_date_cast61:
;LED RTC2.c,240 :: 		else if (dday == '2') {
	MOVF       _dday+0, 0
	XORLW      50
	BTFSS      STATUS+0, 2
	GOTO       L_date_cast63
;LED RTC2.c,241 :: 		ddate[0] ='M';
	MOVLW      77
	MOVWF      _ddate+0
;LED RTC2.c,242 :: 		ddate[1] ='o';
	MOVLW      111
	MOVWF      _ddate+1
;LED RTC2.c,243 :: 		ddate[2] ='n';
	MOVLW      110
	MOVWF      _ddate+2
;LED RTC2.c,244 :: 		}
	GOTO       L_date_cast64
L_date_cast63:
;LED RTC2.c,245 :: 		else if (dday == '3') {
	MOVF       _dday+0, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_date_cast65
;LED RTC2.c,246 :: 		ddate[0] ='T';
	MOVLW      84
	MOVWF      _ddate+0
;LED RTC2.c,247 :: 		ddate[1] ='u';
	MOVLW      117
	MOVWF      _ddate+1
;LED RTC2.c,248 :: 		ddate[2] ='e';
	MOVLW      101
	MOVWF      _ddate+2
;LED RTC2.c,249 :: 		}
	GOTO       L_date_cast66
L_date_cast65:
;LED RTC2.c,250 :: 		else if (dday == '4') {
	MOVF       _dday+0, 0
	XORLW      52
	BTFSS      STATUS+0, 2
	GOTO       L_date_cast67
;LED RTC2.c,251 :: 		ddate[0] ='W';
	MOVLW      87
	MOVWF      _ddate+0
;LED RTC2.c,252 :: 		ddate[1] ='e';
	MOVLW      101
	MOVWF      _ddate+1
;LED RTC2.c,253 :: 		ddate[2] ='d';
	MOVLW      100
	MOVWF      _ddate+2
;LED RTC2.c,254 :: 		}
	GOTO       L_date_cast68
L_date_cast67:
;LED RTC2.c,255 :: 		else if (dday == '5') {
	MOVF       _dday+0, 0
	XORLW      53
	BTFSS      STATUS+0, 2
	GOTO       L_date_cast69
;LED RTC2.c,256 :: 		ddate[0] ='T';
	MOVLW      84
	MOVWF      _ddate+0
;LED RTC2.c,257 :: 		ddate[1] ='h';
	MOVLW      104
	MOVWF      _ddate+1
;LED RTC2.c,258 :: 		ddate[2] ='u';
	MOVLW      117
	MOVWF      _ddate+2
;LED RTC2.c,259 :: 		}
	GOTO       L_date_cast70
L_date_cast69:
;LED RTC2.c,260 :: 		else if (dday == '6') {
	MOVF       _dday+0, 0
	XORLW      54
	BTFSS      STATUS+0, 2
	GOTO       L_date_cast71
;LED RTC2.c,261 :: 		ddate[0] ='F';
	MOVLW      70
	MOVWF      _ddate+0
;LED RTC2.c,262 :: 		ddate[1] ='r';
	MOVLW      114
	MOVWF      _ddate+1
;LED RTC2.c,263 :: 		ddate[2] ='i';
	MOVLW      105
	MOVWF      _ddate+2
;LED RTC2.c,264 :: 		}
	GOTO       L_date_cast72
L_date_cast71:
;LED RTC2.c,265 :: 		else if (dday == '7') {
	MOVF       _dday+0, 0
	XORLW      55
	BTFSS      STATUS+0, 2
	GOTO       L_date_cast73
;LED RTC2.c,266 :: 		ddate[0] ='S';
	MOVLW      83
	MOVWF      _ddate+0
;LED RTC2.c,267 :: 		ddate[1] ='a';
	MOVLW      97
	MOVWF      _ddate+1
;LED RTC2.c,268 :: 		ddate[2] ='t';
	MOVLW      116
	MOVWF      _ddate+2
;LED RTC2.c,269 :: 		}
L_date_cast73:
L_date_cast72:
L_date_cast70:
L_date_cast68:
L_date_cast66:
L_date_cast64:
L_date_cast62:
;LED RTC2.c,270 :: 		ddate[3] = ' ';
	MOVLW      32
	MOVWF      _ddate+3
;LED RTC2.c,271 :: 		ddate[4] = BCD2UpperCh(date);
	MOVF       _date+0, 0
	MOVWF      FARG_BCD2UpperCh_bcd+0
	CALL       _BCD2UpperCh+0
	MOVF       R0+0, 0
	MOVWF      _ddate+4
;LED RTC2.c,272 :: 		ddate[5] = BCD2LowerCh(date);
	MOVF       _date+0, 0
	MOVWF      FARG_BCD2LowerCh_bcd+0
	CALL       _BCD2LowerCh+0
	MOVF       R0+0, 0
	MOVWF      _ddate+5
;LED RTC2.c,273 :: 		ddate[6] = '/';
	MOVLW      47
	MOVWF      _ddate+6
;LED RTC2.c,274 :: 		ddate[7] = BCD2UpperCh(month);
	MOVF       _month+0, 0
	MOVWF      FARG_BCD2UpperCh_bcd+0
	CALL       _BCD2UpperCh+0
	MOVF       R0+0, 0
	MOVWF      _ddate+7
;LED RTC2.c,275 :: 		ddate[8] = BCD2LowerCh(month);
	MOVF       _month+0, 0
	MOVWF      FARG_BCD2LowerCh_bcd+0
	CALL       _BCD2LowerCh+0
	MOVF       R0+0, 0
	MOVWF      _ddate+8
;LED RTC2.c,276 :: 		ddate[9] = '/';
	MOVLW      47
	MOVWF      _ddate+9
;LED RTC2.c,277 :: 		ddate[10] = '2';
	MOVLW      50
	MOVWF      _ddate+10
;LED RTC2.c,278 :: 		ddate[11] = '0';
	MOVLW      48
	MOVWF      _ddate+11
;LED RTC2.c,279 :: 		ddate[12] = BCD2UpperCh(year);
	MOVF       _year+0, 0
	MOVWF      FARG_BCD2UpperCh_bcd+0
	CALL       _BCD2UpperCh+0
	MOVF       R0+0, 0
	MOVWF      _ddate+12
;LED RTC2.c,280 :: 		ddate[13] = BCD2LowerCh(year);
	MOVF       _year+0, 0
	MOVWF      FARG_BCD2LowerCh_bcd+0
	CALL       _BCD2LowerCh+0
	MOVF       R0+0, 0
	MOVWF      _ddate+13
;LED RTC2.c,281 :: 		ddate[14] = '\0';
	CLRF       _ddate+14
;LED RTC2.c,282 :: 		return;
;LED RTC2.c,283 :: 		}
L_end_date_cast:
	RETURN
; end of _date_cast

_time_cast:

;LED RTC2.c,284 :: 		void time_cast(){
;LED RTC2.c,285 :: 		dhour = BCD2UpperCh(hour);
	MOVF       _hour+0, 0
	MOVWF      FARG_BCD2UpperCh_bcd+0
	CALL       _BCD2UpperCh+0
	MOVF       R0+0, 0
	MOVWF      _dhour+0
;LED RTC2.c,286 :: 		if (dhour == '4') {
	MOVF       R0+0, 0
	XORLW      52
	BTFSS      STATUS+0, 2
	GOTO       L_time_cast74
;LED RTC2.c,287 :: 		time[0] = ' ';
	MOVLW      32
	MOVWF      _time+0
;LED RTC2.c,288 :: 		time[9] = 'A';
	MOVLW      65
	MOVWF      _time+9
;LED RTC2.c,289 :: 		}
	GOTO       L_time_cast75
L_time_cast74:
;LED RTC2.c,290 :: 		else if (dhour == '5') {
	MOVF       _dhour+0, 0
	XORLW      53
	BTFSS      STATUS+0, 2
	GOTO       L_time_cast76
;LED RTC2.c,291 :: 		time[0] = '1';
	MOVLW      49
	MOVWF      _time+0
;LED RTC2.c,292 :: 		time[9] = 'A';
	MOVLW      65
	MOVWF      _time+9
;LED RTC2.c,293 :: 		}
	GOTO       L_time_cast77
L_time_cast76:
;LED RTC2.c,294 :: 		else if (dhour == '6') {
	MOVF       _dhour+0, 0
	XORLW      54
	BTFSS      STATUS+0, 2
	GOTO       L_time_cast78
;LED RTC2.c,295 :: 		time[0] = ' ';
	MOVLW      32
	MOVWF      _time+0
;LED RTC2.c,296 :: 		time[9] = 'P';
	MOVLW      80
	MOVWF      _time+9
;LED RTC2.c,297 :: 		}
	GOTO       L_time_cast79
L_time_cast78:
;LED RTC2.c,298 :: 		else if (dhour == '7') {
	MOVF       _dhour+0, 0
	XORLW      55
	BTFSS      STATUS+0, 2
	GOTO       L_time_cast80
;LED RTC2.c,299 :: 		time[0] = '1';
	MOVLW      49
	MOVWF      _time+0
;LED RTC2.c,300 :: 		time[9] = 'P';
	MOVLW      80
	MOVWF      _time+9
;LED RTC2.c,301 :: 		}
L_time_cast80:
L_time_cast79:
L_time_cast77:
L_time_cast75:
;LED RTC2.c,303 :: 		time[1] = BCD2LowerCh(hour);
	MOVF       _hour+0, 0
	MOVWF      FARG_BCD2LowerCh_bcd+0
	CALL       _BCD2LowerCh+0
	MOVF       R0+0, 0
	MOVWF      _time+1
;LED RTC2.c,304 :: 		time[2] = ':';
	MOVLW      58
	MOVWF      _time+2
;LED RTC2.c,305 :: 		time[3] = BCD2UpperCh(minute);
	MOVF       _minute+0, 0
	MOVWF      FARG_BCD2UpperCh_bcd+0
	CALL       _BCD2UpperCh+0
	MOVF       R0+0, 0
	MOVWF      _time+3
;LED RTC2.c,306 :: 		time[4] = BCD2LowerCh(minute);
	MOVF       _minute+0, 0
	MOVWF      FARG_BCD2LowerCh_bcd+0
	CALL       _BCD2LowerCh+0
	MOVF       R0+0, 0
	MOVWF      _time+4
;LED RTC2.c,307 :: 		time[5] = ':';
	MOVLW      58
	MOVWF      _time+5
;LED RTC2.c,308 :: 		time[6] = BCD2UpperCh(sec);
	MOVF       _sec+0, 0
	MOVWF      FARG_BCD2UpperCh_bcd+0
	CALL       _BCD2UpperCh+0
	MOVF       R0+0, 0
	MOVWF      _time+6
;LED RTC2.c,309 :: 		time[7] = BCD2LowerCh(sec);
	MOVF       _sec+0, 0
	MOVWF      FARG_BCD2LowerCh_bcd+0
	CALL       _BCD2LowerCh+0
	MOVF       R0+0, 0
	MOVWF      _time+7
;LED RTC2.c,310 :: 		time[8] = ' ';
	MOVLW      32
	MOVWF      _time+8
;LED RTC2.c,311 :: 		time[10] = 'M';
	MOVLW      77
	MOVWF      _time+10
;LED RTC2.c,312 :: 		time[11] = '\0';
	CLRF       _time+11
;LED RTC2.c,313 :: 		return;
;LED RTC2.c,314 :: 		}
L_end_time_cast:
	RETURN
; end of _time_cast

_BCD2UpperCh:

;LED RTC2.c,315 :: 		unsigned char BCD2UpperCh(unsigned char bcd)
;LED RTC2.c,317 :: 		return ((bcd >> 4) + '0');
	MOVF       FARG_BCD2UpperCh_bcd+0, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      48
	ADDWF      R0+0, 1
;LED RTC2.c,318 :: 		}
L_end_BCD2UpperCh:
	RETURN
; end of _BCD2UpperCh

_BCD2LowerCh:

;LED RTC2.c,320 :: 		unsigned char BCD2LowerCh(unsigned char bcd)
;LED RTC2.c,322 :: 		return ((bcd & 0x0F) + '0');
	MOVLW      15
	ANDWF      FARG_BCD2LowerCh_bcd+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
;LED RTC2.c,323 :: 		}
L_end_BCD2LowerCh:
	RETURN
; end of _BCD2LowerCh

_read_ds1307:

;LED RTC2.c,325 :: 		unsigned short read_ds1307(unsigned short address)
;LED RTC2.c,327 :: 		I2C1_Start();
	CALL       _I2C1_Start+0
;LED RTC2.c,328 :: 		I2C1_Wr(0xd0); //address 0x68 followed by direction bit (0 for write, 1 for read) 0x68 followed by 0 --> 0xD0
	MOVLW      208
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;LED RTC2.c,329 :: 		I2C1_Wr(address);
	MOVF       FARG_read_ds1307_address+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;LED RTC2.c,330 :: 		I2C1_Repeated_Start();
	CALL       _I2C1_Repeated_Start+0
;LED RTC2.c,331 :: 		I2C1_Wr(0xd1); //0x68 followed by 1 --> 0xD1
	MOVLW      209
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;LED RTC2.c,332 :: 		dataa=I2C1_Rd(0);
	CLRF       FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      _dataa+0
;LED RTC2.c,333 :: 		I2C1_Stop();
	CALL       _I2C1_Stop+0
;LED RTC2.c,334 :: 		return(dataa);
	MOVF       _dataa+0, 0
	MOVWF      R0+0
;LED RTC2.c,335 :: 		}
L_end_read_ds1307:
	RETURN
; end of _read_ds1307

_write_ds1307:

;LED RTC2.c,337 :: 		void write_ds1307(unsigned short address,unsigned short w_data)
;LED RTC2.c,339 :: 		I2C1_Start(); // issue I2C start signal
	CALL       _I2C1_Start+0
;LED RTC2.c,341 :: 		I2C1_Wr(0xD0);// send byte via I2C (device address + W)
	MOVLW      208
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;LED RTC2.c,342 :: 		I2C1_Wr(address); // send byte (address of DS1307 location)
	MOVF       FARG_write_ds1307_address+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;LED RTC2.c,343 :: 		I2C1_Wr(w_data); // send data (data to be written)
	MOVF       FARG_write_ds1307_w_data+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;LED RTC2.c,344 :: 		I2C1_Stop(); // issue I2C stop signal
	CALL       _I2C1_Stop+0
;LED RTC2.c,345 :: 		}
L_end_write_ds1307:
	RETURN
; end of _write_ds1307


_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27

;MonoTronic.c,65 :: 		void main(){
;MonoTronic.c,68 :: 		DDRA = 0x00;
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	PUSH       R6
	PUSH       R7
	PUSH       R8
	PUSH       R9
	LDI        R27, 0
	OUT        DDRA+0, R27
;MonoTronic.c,69 :: 		DDRB = 0xFF;
	LDI        R27, 255
	OUT        DDRB+0, R27
;MonoTronic.c,70 :: 		DDRC = 0xFF;
	LDI        R27, 255
	OUT        DDRC+0, R27
;MonoTronic.c,71 :: 		DDRD = 0x00;
	LDI        R27, 0
	OUT        DDRD+0, R27
;MonoTronic.c,74 :: 		ADC_Init();           // Initialize ADC
	CALL       _ADC_Init+0
;MonoTronic.c,75 :: 		LCD_start();          // Initialize LCD
	CALL       _LCD_start+0
;MonoTronic.c,76 :: 		UART1_Init(9600);     // Initialize UART communication with baud rate of 9600
	LDI        R27, 51
	OUT        UBRRL+0, R27
	LDI        R27, 0
	OUT        UBRRH+0, R27
	CALL       _UART1_Init+0
;MonoTronic.c,77 :: 		Delay_ms(10);
	LDI        R17, 104
	LDI        R16, 229
L_main0:
	DEC        R16
	BRNE       L_main0
	DEC        R17
	BRNE       L_main0
;MonoTronic.c,78 :: 		recirculation_mode();
	CALL       _recirculation_mode+0
;MonoTronic.c,79 :: 		AC_mode = 0;
	LDI        R27, 0
	STS        _AC_mode+0, R27
	STS        _AC_mode+1, R27
;MonoTronic.c,80 :: 		Delay_ms(10);
	LDI        R17, 104
	LDI        R16, 229
L_main2:
	DEC        R16
	BRNE       L_main2
	DEC        R17
	BRNE       L_main2
;MonoTronic.c,82 :: 		flag = false;
	LDI        R27, 0
	STS        _flag+0, R27
;MonoTronic.c,85 :: 		while(1){
L_main4:
;MonoTronic.c,86 :: 		CO_in = get_CO_in();
	CALL       _get_CO_in+0
	CALL       _float_fpint+0
	STS        _CO_in+0, R16
	STS        _CO_in+1, R17
;MonoTronic.c,87 :: 		CO_out = get_CO_out();
	CALL       _get_CO_out+0
	CALL       _float_fpint+0
	STS        _CO_out+0, R16
	STS        _CO_out+1, R17
;MonoTronic.c,88 :: 		CO2_in = get_CO2_in();
	CALL       _get_CO2_in+0
	CALL       _float_fpint+0
	STS        _CO2_in+0, R16
	STS        _CO2_in+1, R17
;MonoTronic.c,89 :: 		CO2_out = get_CO2_out();
	CALL       _get_CO2_out+0
	CALL       _float_fpint+0
	STS        _CO2_out+0, R16
	STS        _CO2_out+1, R17
;MonoTronic.c,90 :: 		Delay_ms(50);
	LDI        R18, 3
	LDI        R17, 8
	LDI        R16, 120
L_main6:
	DEC        R16
	BRNE       L_main6
	DEC        R17
	BRNE       L_main6
	DEC        R18
	BRNE       L_main6
;MonoTronic.c,91 :: 		if(CO_in >= 1000 || CO2_in >= 10000)
	LDS        R18, _CO_in+0
	LDS        R19, _CO_in+1
	LDI        R16, 232
	LDI        R17, 3
	CP         R18, R16
	CPC        R19, R17
	BRLT       L__main101
	JMP        L__main91
L__main101:
	LDS        R18, _CO2_in+0
	LDS        R19, _CO2_in+1
	LDI        R16, 16
	LDI        R17, 39
	CP         R18, R16
	CPC        R19, R17
	BRLT       L__main102
	JMP        L__main90
L__main102:
	JMP        L_main10
L__main91:
L__main90:
;MonoTronic.c,93 :: 		AC_off();
	CALL       _AC_off+0
;MonoTronic.c,94 :: 		AC_mode = 2;
	LDI        R27, 2
	STS        _AC_mode+0, R27
	LDI        R27, 0
	STS        _AC_mode+1, R27
;MonoTronic.c,95 :: 		}
L_main10:
;MonoTronic.c,96 :: 		if(CO_in >= 30)
	LDS        R18, _CO_in+0
	LDS        R19, _CO_in+1
	LDI        R16, 30
	LDI        R17, 0
	CP         R18, R16
	CPC        R19, R17
	BRGE       L__main103
	JMP        L_main11
L__main103:
;MonoTronic.c,98 :: 		CO_control();
	CALL       _CO_control+0
;MonoTronic.c,99 :: 		}
L_main11:
;MonoTronic.c,100 :: 		if(CO_in < 30)
	LDS        R18, _CO_in+0
	LDS        R19, _CO_in+1
	LDI        R16, 30
	LDI        R17, 0
	CP         R18, R16
	CPC        R19, R17
	BRLT       L__main104
	JMP        L_main12
L__main104:
;MonoTronic.c,102 :: 		if(CO2_in >= 1300)
	LDS        R18, _CO2_in+0
	LDS        R19, _CO2_in+1
	LDI        R16, 20
	LDI        R17, 5
	CP         R18, R16
	CPC        R19, R17
	BRGE       L__main105
	JMP        L_main13
L__main105:
;MonoTronic.c,104 :: 		CO2_control();
	CALL       _CO2_control+0
;MonoTronic.c,105 :: 		}
L_main13:
;MonoTronic.c,106 :: 		occupancy = check_occupancy();
	CALL       _check_occupancy+0
	STS        _occupancy+0, R16
	STS        _occupancy+1, R17
;MonoTronic.c,107 :: 		CO2_occu =  CO2_occu_get(occupancy);
	MOVW       R2, R16
	CALL       _CO2_occu_get+0
	STS        _CO2_occu+0, R16
	STS        _CO2_occu+1, R17
;MonoTronic.c,108 :: 		if(CO2_in < CO2_occu && CO2_check == true)
	LDS        R18, _CO2_in+0
	LDS        R19, _CO2_in+1
	CP         R18, R16
	CPC        R19, R17
	BRLT       L__main106
	JMP        L__main93
L__main106:
	LDS        R16, _CO2_check+0
	CPI        R16, 1
	BREQ       L__main107
	JMP        L__main92
L__main107:
L__main88:
;MonoTronic.c,110 :: 		recirculation_mode();       // Switch back to recirculation once below threshold
	CALL       _recirculation_mode+0
;MonoTronic.c,111 :: 		AC_mode = 0;
	LDI        R27, 0
	STS        _AC_mode+0, R27
	STS        _AC_mode+1, R27
;MonoTronic.c,112 :: 		CO2_check = false;
	LDI        R27, 0
	STS        _CO2_check+0, R27
;MonoTronic.c,108 :: 		if(CO2_in < CO2_occu && CO2_check == true)
L__main93:
L__main92:
;MonoTronic.c,114 :: 		}
L_main12:
;MonoTronic.c,115 :: 		send_data(CO_in, CO_out, CO2_in, CO2_out);
	LDS        R8, _CO2_out+0
	LDS        R9, _CO2_out+1
	LDS        R6, _CO2_in+0
	LDS        R7, _CO2_in+1
	LDS        R4, _CO_out+0
	LDS        R5, _CO_out+1
	LDS        R2, _CO_in+0
	LDS        R3, _CO_in+1
	CALL       _send_data+0
;MonoTronic.c,116 :: 		Delay_ms(1000);
	LDI        R18, 41
	LDI        R17, 150
	LDI        R16, 128
L_main17:
	DEC        R16
	BRNE       L_main17
	DEC        R17
	BRNE       L_main17
	DEC        R18
	BRNE       L_main17
;MonoTronic.c,118 :: 		}
	JMP        L_main4
;MonoTronic.c,119 :: 		}
L_end_main:
	POP        R9
	POP        R8
	POP        R7
	POP        R6
	POP        R5
	POP        R4
	POP        R3
	POP        R2
L__main_end_loop:
	JMP        L__main_end_loop
; end of _main

_CO_control:

;MonoTronic.c,122 :: 		void CO_control(){
;MonoTronic.c,123 :: 		if(CO_in - CO_out >= 10)      // case 1
	LDS        R0, _CO_out+0
	LDS        R1, _CO_out+1
	LDS        R18, _CO_in+0
	LDS        R19, _CO_in+1
	SUB        R18, R0
	SBC        R19, R1
	LDI        R16, 10
	LDI        R17, 0
	CP         R18, R16
	CPC        R19, R17
	BRGE       L__CO_control110
	JMP        L_CO_control19
L__CO_control110:
;MonoTronic.c,125 :: 		if(AC_mode == 0)     // If AC was in recirculation, set to fresh air
	LDS        R16, _AC_mode+0
	LDS        R17, _AC_mode+1
	CPI        R17, 0
	BRNE       L__CO_control111
	CPI        R16, 0
L__CO_control111:
	BREQ       L__CO_control112
	JMP        L_CO_control20
L__CO_control112:
;MonoTronic.c,127 :: 		fresh_air_mode();
	CALL       _fresh_air_mode+0
;MonoTronic.c,128 :: 		AC_mode = 1;
	LDI        R27, 1
	STS        _AC_mode+0, R27
	LDI        R27, 0
	STS        _AC_mode+1, R27
;MonoTronic.c,129 :: 		}
L_CO_control20:
;MonoTronic.c,130 :: 		if(AC_mode == 1)    // If AC was in fresh air, check for increase
	LDS        R16, _AC_mode+0
	LDS        R17, _AC_mode+1
	CPI        R17, 0
	BRNE       L__CO_control113
	CPI        R16, 1
L__CO_control113:
	BREQ       L__CO_control114
	JMP        L_CO_control21
L__CO_control114:
;MonoTronic.c,132 :: 		if(flag == false)    // First time case 1 detected in fresh air mode
	LDS        R16, _flag+0
	CPI        R16, 0
	BREQ       L__CO_control115
	JMP        L_CO_control22
L__CO_control115:
;MonoTronic.c,134 :: 		CO_flag = CO_in;
	LDS        R16, _CO_in+0
	LDS        R17, _CO_in+1
	STS        _CO_flag+0, R16
	STS        _CO_flag+1, R17
;MonoTronic.c,135 :: 		flag = true;
	LDI        R27, 1
	STS        _flag+0, R27
;MonoTronic.c,136 :: 		}
L_CO_control22:
;MonoTronic.c,137 :: 		if(CO_in - CO_flag > 20)    // If CO increased by 20 ppm since this case detected so turn AC off
	LDS        R0, _CO_flag+0
	LDS        R1, _CO_flag+1
	LDS        R18, _CO_in+0
	LDS        R19, _CO_in+1
	SUB        R18, R0
	SBC        R19, R1
	LDI        R16, 20
	LDI        R17, 0
	CP         R16, R18
	CPC        R17, R19
	BRLT       L__CO_control116
	JMP        L_CO_control23
L__CO_control116:
;MonoTronic.c,139 :: 		AC_off();
	CALL       _AC_off+0
;MonoTronic.c,140 :: 		AC_mode = 2;
	LDI        R27, 2
	STS        _AC_mode+0, R27
	LDI        R27, 0
	STS        _AC_mode+1, R27
;MonoTronic.c,141 :: 		CO_flag = 0;
	LDI        R27, 0
	STS        _CO_flag+0, R27
	STS        _CO_flag+1, R27
;MonoTronic.c,142 :: 		flag = false;
	LDI        R27, 0
	STS        _flag+0, R27
;MonoTronic.c,143 :: 		Delay_ms(2);
	LDI        R17, 21
	LDI        R16, 199
L_CO_control24:
	DEC        R16
	BRNE       L_CO_control24
	DEC        R17
	BRNE       L_CO_control24
;MonoTronic.c,144 :: 		}
L_CO_control23:
;MonoTronic.c,145 :: 		}
L_CO_control21:
;MonoTronic.c,146 :: 		}
L_CO_control19:
;MonoTronic.c,147 :: 		if(CO_out - CO_in >= 10)       // case 2
	LDS        R0, _CO_in+0
	LDS        R1, _CO_in+1
	LDS        R18, _CO_out+0
	LDS        R19, _CO_out+1
	SUB        R18, R0
	SBC        R19, R1
	LDI        R16, 10
	LDI        R17, 0
	CP         R18, R16
	CPC        R19, R17
	BRGE       L__CO_control117
	JMP        L_CO_control26
L__CO_control117:
;MonoTronic.c,149 :: 		if(AC_mode == 1)     // If AC was in fresh air, set to recirculation
	LDS        R16, _AC_mode+0
	LDS        R17, _AC_mode+1
	CPI        R17, 0
	BRNE       L__CO_control118
	CPI        R16, 1
L__CO_control118:
	BREQ       L__CO_control119
	JMP        L_CO_control27
L__CO_control119:
;MonoTronic.c,151 :: 		recirculation_mode();
	CALL       _recirculation_mode+0
;MonoTronic.c,152 :: 		AC_mode = 0;
	LDI        R27, 0
	STS        _AC_mode+0, R27
	STS        _AC_mode+1, R27
;MonoTronic.c,153 :: 		}
L_CO_control27:
;MonoTronic.c,154 :: 		if(AC_mode == 0)       // If AC was in recirculation, check for increase
	LDS        R16, _AC_mode+0
	LDS        R17, _AC_mode+1
	CPI        R17, 0
	BRNE       L__CO_control120
	CPI        R16, 0
L__CO_control120:
	BREQ       L__CO_control121
	JMP        L_CO_control28
L__CO_control121:
;MonoTronic.c,156 :: 		if(flag == false)        // First time this case detected
	LDS        R16, _flag+0
	CPI        R16, 0
	BREQ       L__CO_control122
	JMP        L_CO_control29
L__CO_control122:
;MonoTronic.c,158 :: 		CO_flag = CO_in;
	LDS        R16, _CO_in+0
	LDS        R17, _CO_in+1
	STS        _CO_flag+0, R16
	STS        _CO_flag+1, R17
;MonoTronic.c,159 :: 		flag = ~flag;
	LDS        R16, _flag+0
	COM        R16
	STS        _flag+0, R16
;MonoTronic.c,160 :: 		}
L_CO_control29:
;MonoTronic.c,161 :: 		if((CO_in - CO_flag) > 20)  // If CO increased by 20 ppm since this case detected so turn AC off
	LDS        R0, _CO_flag+0
	LDS        R1, _CO_flag+1
	LDS        R18, _CO_in+0
	LDS        R19, _CO_in+1
	SUB        R18, R0
	SBC        R19, R1
	LDI        R16, 20
	LDI        R17, 0
	CP         R16, R18
	CPC        R17, R19
	BRLT       L__CO_control123
	JMP        L_CO_control30
L__CO_control123:
;MonoTronic.c,163 :: 		AC_off();
	CALL       _AC_off+0
;MonoTronic.c,164 :: 		CO_flag = 0;
	LDI        R27, 0
	STS        _CO_flag+0, R27
	STS        _CO_flag+1, R27
;MonoTronic.c,165 :: 		flag = ~flag;
	LDS        R16, _flag+0
	COM        R16
	STS        _flag+0, R16
;MonoTronic.c,166 :: 		AC_mode = 2;
	LDI        R27, 2
	STS        _AC_mode+0, R27
	LDI        R27, 0
	STS        _AC_mode+1, R27
;MonoTronic.c,167 :: 		}
L_CO_control30:
;MonoTronic.c,168 :: 		}
L_CO_control28:
;MonoTronic.c,170 :: 		}
L_CO_control26:
;MonoTronic.c,171 :: 		}
L_end_CO_control:
	RET
; end of _CO_control

_CO2_control:

;MonoTronic.c,174 :: 		void CO2_control()
;MonoTronic.c,176 :: 		if(AC_mode == 0)                  // If AC was in recirculation mode
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	PUSH       R6
	PUSH       R7
	PUSH       R8
	PUSH       R9
	LDS        R16, _AC_mode+0
	LDS        R17, _AC_mode+1
	CPI        R17, 0
	BRNE       L__CO2_control125
	CPI        R16, 0
L__CO2_control125:
	BREQ       L__CO2_control126
	JMP        L_CO2_control31
L__CO2_control126:
;MonoTronic.c,178 :: 		fresh_air_mode();      // Set to fresh air mode
	CALL       _fresh_air_mode+0
;MonoTronic.c,179 :: 		AC_mode = 1;
	LDI        R27, 1
	STS        _AC_mode+0, R27
	LDI        R27, 0
	STS        _AC_mode+1, R27
;MonoTronic.c,180 :: 		occupancy = check_occupancy();
	CALL       _check_occupancy+0
	STS        _occupancy+0, R16
	STS        _occupancy+1, R17
;MonoTronic.c,181 :: 		Delay_ms(10);
	LDI        R17, 104
	LDI        R16, 229
L_CO2_control32:
	DEC        R16
	BRNE       L_CO2_control32
	DEC        R17
	BRNE       L_CO2_control32
;MonoTronic.c,182 :: 		CO2_occu =  CO2_occu_get(occupancy);   // Get threshold based on occupancy
	LDS        R2, _occupancy+0
	LDS        R3, _occupancy+1
	CALL       _CO2_occu_get+0
	STS        _CO2_occu+0, R16
	STS        _CO2_occu+1, R17
;MonoTronic.c,183 :: 		CO2_check = true;
	LDI        R27, 1
	STS        _CO2_check+0, R27
;MonoTronic.c,184 :: 		}
L_CO2_control31:
;MonoTronic.c,185 :: 		if(AC_mode == 1 && CO2_check == false)      // If fresh air mode while CO2 high outside
	LDS        R16, _AC_mode+0
	LDS        R17, _AC_mode+1
	CPI        R17, 0
	BRNE       L__CO2_control127
	CPI        R16, 1
L__CO2_control127:
	BREQ       L__CO2_control128
	JMP        L__CO2_control87
L__CO2_control128:
	LDS        R16, _CO2_check+0
	CPI        R16, 0
	BREQ       L__CO2_control129
	JMP        L__CO2_control86
L__CO2_control129:
L__CO2_control85:
;MonoTronic.c,187 :: 		if(CO2_out >= 2000)              // CO2 outside high
	LDS        R18, _CO2_out+0
	LDS        R19, _CO2_out+1
	LDI        R16, 208
	LDI        R17, 7
	CP         R18, R16
	CPC        R19, R17
	BRGE       L__CO2_control130
	JMP        L_CO2_control37
L__CO2_control130:
;MonoTronic.c,189 :: 		recirculation_mode();
	CALL       _recirculation_mode+0
;MonoTronic.c,190 :: 		AC_mode = 0;
	LDI        R27, 0
	STS        _AC_mode+0, R27
	STS        _AC_mode+1, R27
;MonoTronic.c,191 :: 		while(CO2_out > 1300)
L_CO2_control38:
	LDS        R18, _CO2_out+0
	LDS        R19, _CO2_out+1
	LDI        R16, 20
	LDI        R17, 5
	CP         R16, R18
	CPC        R17, R19
	BRLT       L__CO2_control131
	JMP        L_CO2_control39
L__CO2_control131:
;MonoTronic.c,193 :: 		CO2_out = get_CO2_out();
	CALL       _get_CO2_out+0
	CALL       _float_fpint+0
	STS        _CO2_out+0, R16
	STS        _CO2_out+1, R17
;MonoTronic.c,194 :: 		send_data(CO_in, CO_out, CO2_in, CO2_out);
	MOVW       R8, R16
	LDS        R6, _CO2_in+0
	LDS        R7, _CO2_in+1
	LDS        R4, _CO_out+0
	LDS        R5, _CO_out+1
	LDS        R2, _CO_in+0
	LDS        R3, _CO_in+1
	CALL       _send_data+0
;MonoTronic.c,195 :: 		Delay_ms(1000);
	LDI        R18, 41
	LDI        R17, 150
	LDI        R16, 128
L_CO2_control40:
	DEC        R16
	BRNE       L_CO2_control40
	DEC        R17
	BRNE       L_CO2_control40
	DEC        R18
	BRNE       L_CO2_control40
;MonoTronic.c,197 :: 		}
	JMP        L_CO2_control38
L_CO2_control39:
;MonoTronic.c,198 :: 		fresh_air_mode();   // Set back to fresh air once CO2 outside is low
	CALL       _fresh_air_mode+0
;MonoTronic.c,199 :: 		AC_mode = 1;
	LDI        R27, 1
	STS        _AC_mode+0, R27
	LDI        R27, 0
	STS        _AC_mode+1, R27
;MonoTronic.c,200 :: 		}
L_CO2_control37:
;MonoTronic.c,185 :: 		if(AC_mode == 1 && CO2_check == false)      // If fresh air mode while CO2 high outside
L__CO2_control87:
L__CO2_control86:
;MonoTronic.c,202 :: 		}
L_end_CO2_control:
	POP        R9
	POP        R8
	POP        R7
	POP        R6
	POP        R5
	POP        R4
	POP        R3
	POP        R2
	RET
; end of _CO2_control

_CO2_occu_get:

;MonoTronic.c,205 :: 		int CO2_occu_get(int occupancy)
;MonoTronic.c,207 :: 		switch(occupancy)
	JMP        L_CO2_occu_get42
;MonoTronic.c,209 :: 		case 1:
L_CO2_occu_get44:
;MonoTronic.c,210 :: 		return 550; break;
	LDI        R16, 38
	LDI        R17, 2
	JMP        L_end_CO2_occu_get
;MonoTronic.c,211 :: 		case 2:
L_CO2_occu_get45:
;MonoTronic.c,212 :: 		return 700; break;
	LDI        R16, 188
	LDI        R17, 2
	JMP        L_end_CO2_occu_get
;MonoTronic.c,213 :: 		case 3:
L_CO2_occu_get46:
;MonoTronic.c,214 :: 		return 850; break;
	LDI        R16, 82
	LDI        R17, 3
	JMP        L_end_CO2_occu_get
;MonoTronic.c,215 :: 		case 4:
L_CO2_occu_get47:
;MonoTronic.c,216 :: 		return 1000; break;
	LDI        R16, 232
	LDI        R17, 3
	JMP        L_end_CO2_occu_get
;MonoTronic.c,217 :: 		case 5:
L_CO2_occu_get48:
;MonoTronic.c,218 :: 		return 1150; break;
	LDI        R16, 126
	LDI        R17, 4
	JMP        L_end_CO2_occu_get
;MonoTronic.c,219 :: 		}
L_CO2_occu_get42:
	LDI        R27, 0
	CP         R3, R27
	BRNE       L__CO2_occu_get133
	LDI        R27, 1
	CP         R2, R27
L__CO2_occu_get133:
	BRNE       L__CO2_occu_get134
	JMP        L_CO2_occu_get44
L__CO2_occu_get134:
	LDI        R27, 0
	CP         R3, R27
	BRNE       L__CO2_occu_get135
	LDI        R27, 2
	CP         R2, R27
L__CO2_occu_get135:
	BRNE       L__CO2_occu_get136
	JMP        L_CO2_occu_get45
L__CO2_occu_get136:
	LDI        R27, 0
	CP         R3, R27
	BRNE       L__CO2_occu_get137
	LDI        R27, 3
	CP         R2, R27
L__CO2_occu_get137:
	BRNE       L__CO2_occu_get138
	JMP        L_CO2_occu_get46
L__CO2_occu_get138:
	LDI        R27, 0
	CP         R3, R27
	BRNE       L__CO2_occu_get139
	LDI        R27, 4
	CP         R2, R27
L__CO2_occu_get139:
	BRNE       L__CO2_occu_get140
	JMP        L_CO2_occu_get47
L__CO2_occu_get140:
	LDI        R27, 0
	CP         R3, R27
	BRNE       L__CO2_occu_get141
	LDI        R27, 5
	CP         R2, R27
L__CO2_occu_get141:
	BRNE       L__CO2_occu_get142
	JMP        L_CO2_occu_get48
L__CO2_occu_get142:
;MonoTronic.c,220 :: 		}
L_end_CO2_occu_get:
	RET
; end of _CO2_occu_get

_get_CO_in:

;MonoTronic.c,224 :: 		float get_CO_in(){
;MonoTronic.c,225 :: 		return (ADC_Read(CO_in_pin)*0.48828125);
	PUSH       R2
	LDI        R27, 2
	MOV        R2, R27
	CALL       _ADC_Read+0
	LDI        R18, 0
	MOV        R19, R18
	CALL       _float_ulong2fp+0
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 250
	LDI        R23, 62
	CALL       _float_fpmul1+0
;MonoTronic.c,226 :: 		}
;MonoTronic.c,225 :: 		return (ADC_Read(CO_in_pin)*0.48828125);
;MonoTronic.c,226 :: 		}
L_end_get_CO_in:
	POP        R2
	RET
; end of _get_CO_in

_get_CO_out:

;MonoTronic.c,228 :: 		float get_CO_out(){
;MonoTronic.c,229 :: 		return (ADC_Read(CO_out_pin)*0.48828125);
	PUSH       R2
	LDI        R27, 1
	MOV        R2, R27
	CALL       _ADC_Read+0
	LDI        R18, 0
	MOV        R19, R18
	CALL       _float_ulong2fp+0
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 250
	LDI        R23, 62
	CALL       _float_fpmul1+0
;MonoTronic.c,230 :: 		}
;MonoTronic.c,229 :: 		return (ADC_Read(CO_out_pin)*0.48828125);
;MonoTronic.c,230 :: 		}
L_end_get_CO_out:
	POP        R2
	RET
; end of _get_CO_out

_get_CO2_in:

;MonoTronic.c,232 :: 		float get_CO2_in(){
;MonoTronic.c,233 :: 		return (ADC_Read(CO2_in_pin)*0.48828125*100);
	PUSH       R2
	LDI        R27, 4
	MOV        R2, R27
	CALL       _ADC_Read+0
	LDI        R18, 0
	MOV        R19, R18
	CALL       _float_ulong2fp+0
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 250
	LDI        R23, 62
	CALL       _float_fpmul1+0
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 200
	LDI        R23, 66
	CALL       _float_fpmul1+0
;MonoTronic.c,234 :: 		}
;MonoTronic.c,233 :: 		return (ADC_Read(CO2_in_pin)*0.48828125*100);
;MonoTronic.c,234 :: 		}
L_end_get_CO2_in:
	POP        R2
	RET
; end of _get_CO2_in

_get_CO2_out:

;MonoTronic.c,236 :: 		float get_CO2_out(){
;MonoTronic.c,237 :: 		return (ADC_Read(CO2_out_pin)*0.48828125*100);
	PUSH       R2
	LDI        R27, 3
	MOV        R2, R27
	CALL       _ADC_Read+0
	LDI        R18, 0
	MOV        R19, R18
	CALL       _float_ulong2fp+0
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 250
	LDI        R23, 62
	CALL       _float_fpmul1+0
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 200
	LDI        R23, 66
	CALL       _float_fpmul1+0
;MonoTronic.c,238 :: 		}
;MonoTronic.c,237 :: 		return (ADC_Read(CO2_out_pin)*0.48828125*100);
;MonoTronic.c,238 :: 		}
L_end_get_CO2_out:
	POP        R2
	RET
; end of _get_CO2_out

_check_occupancy:

;MonoTronic.c,240 :: 		int check_occupancy()            // Count occupancy inside car
;MonoTronic.c,242 :: 		int count = 1;               // Assumed driver is present
; count start address is: 18 (R18)
	LDI        R18, 1
	LDI        R19, 0
;MonoTronic.c,243 :: 		if(PIND.B2 == 1)
	IN         R27, PIND+0
	SBRS       R27, 2
	JMP        L__check_occupancy81
;MonoTronic.c,244 :: 		count = count + 1;
	MOVW       R16, R18
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R18, R16
; count end address is: 18 (R18)
	JMP        L_check_occupancy49
L__check_occupancy81:
;MonoTronic.c,243 :: 		if(PIND.B2 == 1)
;MonoTronic.c,244 :: 		count = count + 1;
L_check_occupancy49:
;MonoTronic.c,245 :: 		if(PIND.B3 == 1)
; count start address is: 18 (R18)
	IN         R27, PIND+0
	SBRS       R27, 3
	JMP        L__check_occupancy82
;MonoTronic.c,246 :: 		count = count + 1;
	MOVW       R16, R18
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R18, R16
; count end address is: 18 (R18)
	JMP        L_check_occupancy50
L__check_occupancy82:
;MonoTronic.c,245 :: 		if(PIND.B3 == 1)
;MonoTronic.c,246 :: 		count = count + 1;
L_check_occupancy50:
;MonoTronic.c,247 :: 		if(PIND.B4 == 1)
; count start address is: 18 (R18)
	IN         R27, PIND+0
	SBRS       R27, 4
	JMP        L__check_occupancy83
;MonoTronic.c,248 :: 		count = count + 1;
	MOVW       R16, R18
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R18, R16
; count end address is: 18 (R18)
	JMP        L_check_occupancy51
L__check_occupancy83:
;MonoTronic.c,247 :: 		if(PIND.B4 == 1)
;MonoTronic.c,248 :: 		count = count + 1;
L_check_occupancy51:
;MonoTronic.c,249 :: 		if(PIND.B5 == 1)
; count start address is: 18 (R18)
	IN         R27, PIND+0
	SBRS       R27, 5
	JMP        L__check_occupancy84
;MonoTronic.c,250 :: 		count = count + 1;
	MOVW       R16, R18
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R18, R16
; count end address is: 18 (R18)
	JMP        L_check_occupancy52
L__check_occupancy84:
;MonoTronic.c,249 :: 		if(PIND.B5 == 1)
;MonoTronic.c,250 :: 		count = count + 1;
L_check_occupancy52:
;MonoTronic.c,251 :: 		return count;
; count start address is: 18 (R18)
	MOVW       R16, R18
; count end address is: 18 (R18)
;MonoTronic.c,252 :: 		}
L_end_check_occupancy:
	RET
; end of _check_occupancy

_LCD_Command:

;MonoTronic.c,255 :: 		void LCD_Command(unsigned char cmnd)
;MonoTronic.c,257 :: 		LCD_Data_Port= cmnd;
	OUT        PORTB+0, R2
;MonoTronic.c,258 :: 		LCD_Command_Port &= ~(1<<RS);
	IN         R16, PORTC+0
	ANDI       R16, 254
	OUT        PORTC+0, R16
;MonoTronic.c,259 :: 		LCD_Command_Port &= ~(1<<RW);
	ANDI       R16, 253
	OUT        PORTC+0, R16
;MonoTronic.c,260 :: 		LCD_Command_Port |= (1<<EN);
	ORI        R16, 4
	OUT        PORTC+0, R16
;MonoTronic.c,261 :: 		Delay_us(1);
	LDI        R16, 2
L_LCD_Command53:
	DEC        R16
	BRNE       L_LCD_Command53
	NOP
	NOP
;MonoTronic.c,262 :: 		LCD_Command_Port &= ~(1<<EN);
	IN         R27, PORTC+0
	CBR        R27, 4
	OUT        PORTC+0, R27
;MonoTronic.c,263 :: 		Delay_ms(3);
	LDI        R17, 32
	LDI        R16, 42
L_LCD_Command55:
	DEC        R16
	BRNE       L_LCD_Command55
	DEC        R17
	BRNE       L_LCD_Command55
	NOP
;MonoTronic.c,264 :: 		}
L_end_LCD_Command:
	RET
; end of _LCD_Command

_LCD_Char:

;MonoTronic.c,266 :: 		void LCD_Char (unsigned char char_data)        // LCD data write function
;MonoTronic.c,268 :: 		LCD_Data_Port= char_data;
	OUT        PORTB+0, R2
;MonoTronic.c,269 :: 		LCD_Command_Port |= (1<<RS);
	IN         R16, PORTC+0
	ORI        R16, 1
	OUT        PORTC+0, R16
;MonoTronic.c,270 :: 		LCD_Command_Port &= ~(1<<RW);
	ANDI       R16, 253
	OUT        PORTC+0, R16
;MonoTronic.c,271 :: 		LCD_Command_Port |= (1<<EN);
	ORI        R16, 4
	OUT        PORTC+0, R16
;MonoTronic.c,272 :: 		Delay_us(1);
	LDI        R16, 2
L_LCD_Char57:
	DEC        R16
	BRNE       L_LCD_Char57
	NOP
	NOP
;MonoTronic.c,273 :: 		LCD_Command_Port &= ~(1<<EN);
	IN         R27, PORTC+0
	CBR        R27, 4
	OUT        PORTC+0, R27
;MonoTronic.c,274 :: 		Delay_ms(1);
	LDI        R17, 11
	LDI        R16, 99
L_LCD_Char59:
	DEC        R16
	BRNE       L_LCD_Char59
	DEC        R17
	BRNE       L_LCD_Char59
;MonoTronic.c,275 :: 		}
L_end_LCD_Char:
	RET
; end of _LCD_Char

_LCD_start:

;MonoTronic.c,277 :: 		void LCD_start (void)                        // LCD Initialize function
;MonoTronic.c,279 :: 		LCD_Command_Dir = 0xFF;             // Make LCD command port direction as o/p
	PUSH       R2
	LDI        R27, 255
	OUT        DDRC+0, R27
;MonoTronic.c,280 :: 		LCD_Data_Dir = 0xFF;                // Make LCD data port direction as o/p
	LDI        R27, 255
	OUT        DDRB+0, R27
;MonoTronic.c,281 :: 		Delay_ms(20);                       // LCD Power ON delay always >15ms
	LDI        R17, 208
	LDI        R16, 202
L_LCD_start61:
	DEC        R16
	BRNE       L_LCD_start61
	DEC        R17
	BRNE       L_LCD_start61
	NOP
;MonoTronic.c,282 :: 		LCD_Command (0x38);                 // Initialization of 16X2 LCD in 8bit mode
	LDI        R27, 56
	MOV        R2, R27
	CALL       _LCD_Command+0
;MonoTronic.c,283 :: 		LCD_Command (0x0C);                 // Display ON Cursor OFF
	LDI        R27, 12
	MOV        R2, R27
	CALL       _LCD_Command+0
;MonoTronic.c,284 :: 		LCD_Command (0x06);                 // Auto Increment cursor
	LDI        R27, 6
	MOV        R2, R27
	CALL       _LCD_Command+0
;MonoTronic.c,285 :: 		LCD_Command (0x01);                 // Clear display
	LDI        R27, 1
	MOV        R2, R27
	CALL       _LCD_Command+0
;MonoTronic.c,286 :: 		LCD_Command (0x80);                 // Cursor at home position
	LDI        R27, 128
	MOV        R2, R27
	CALL       _LCD_Command+0
;MonoTronic.c,287 :: 		}
L_end_LCD_start:
	POP        R2
	RET
; end of _LCD_start

_LCD_String:

;MonoTronic.c,289 :: 		void LCD_String (char *str)                // Send string to LCD function
;MonoTronic.c,292 :: 		for(i=0;str[i]!=0;i++)                // Send each char of string till the NULL
; i start address is: 18 (R18)
	LDI        R18, 0
	LDI        R19, 0
; i end address is: 18 (R18)
L_LCD_String63:
; i start address is: 18 (R18)
	MOVW       R30, R18
	ADD        R30, R2
	ADC        R31, R3
	LD         R16, Z
	CPI        R16, 0
	BRNE       L__LCD_String152
	JMP        L_LCD_String64
L__LCD_String152:
;MonoTronic.c,294 :: 		LCD_Char (str[i]);
	MOVW       R30, R18
	ADD        R30, R2
	ADC        R31, R3
	LD         R16, Z
	PUSH       R19
	PUSH       R18
	PUSH       R3
	PUSH       R2
	MOV        R2, R16
	CALL       _LCD_Char+0
	POP        R2
	POP        R3
	POP        R18
	POP        R19
;MonoTronic.c,292 :: 		for(i=0;str[i]!=0;i++)                // Send each char of string till the NULL
	MOVW       R16, R18
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R18, R16
;MonoTronic.c,295 :: 		}
; i end address is: 18 (R18)
	JMP        L_LCD_String63
L_LCD_String64:
;MonoTronic.c,296 :: 		}
L_end_LCD_String:
	RET
; end of _LCD_String

_LCD_String_xy:

;MonoTronic.c,298 :: 		void LCD_String_xy (char row, char pos, char *str)  // Send string to LCD with xy position
;MonoTronic.c,300 :: 		if (row == 0 && pos<16)
	PUSH       R2
	PUSH       R3
	LDI        R27, 0
	CP         R2, R27
	BREQ       L__LCD_String_xy154
	JMP        L__LCD_String_xy97
L__LCD_String_xy154:
	LDI        R27, 16
	CP         R3, R27
	BRLO       L__LCD_String_xy155
	JMP        L__LCD_String_xy96
L__LCD_String_xy155:
L__LCD_String_xy95:
;MonoTronic.c,301 :: 		LCD_Command((pos & 0x0F)|0x80);        //Command of first row and required position<16
	MOV        R16, R3
	ANDI       R16, 15
	ORI        R16, 128
	MOV        R2, R16
	CALL       _LCD_Command+0
	JMP        L_LCD_String_xy69
;MonoTronic.c,300 :: 		if (row == 0 && pos<16)
L__LCD_String_xy97:
L__LCD_String_xy96:
;MonoTronic.c,302 :: 		else if (row == 1 && pos<16)
	LDI        R27, 1
	CP         R2, R27
	BREQ       L__LCD_String_xy156
	JMP        L__LCD_String_xy99
L__LCD_String_xy156:
	LDI        R27, 16
	CP         R3, R27
	BRLO       L__LCD_String_xy157
	JMP        L__LCD_String_xy98
L__LCD_String_xy157:
L__LCD_String_xy94:
;MonoTronic.c,303 :: 		LCD_Command((pos & 0x0F)|0xC0);        // Command of first row and required position<16
	MOV        R16, R3
	ANDI       R16, 15
	ORI        R16, 192
	MOV        R2, R16
	CALL       _LCD_Command+0
;MonoTronic.c,302 :: 		else if (row == 1 && pos<16)
L__LCD_String_xy99:
L__LCD_String_xy98:
;MonoTronic.c,303 :: 		LCD_Command((pos & 0x0F)|0xC0);        // Command of first row and required position<16
L_LCD_String_xy69:
;MonoTronic.c,304 :: 		LCD_String(str);                       // Call LCD string function
	MOVW       R2, R4
	CALL       _LCD_String+0
;MonoTronic.c,305 :: 		}
L_end_LCD_String_xy:
	POP        R3
	POP        R2
	RET
; end of _LCD_String_xy

_LCD_Clear:

;MonoTronic.c,307 :: 		void LCD_Clear()                           // Clear LCD screen
;MonoTronic.c,309 :: 		LCD_Command (0x01);                // clear display
	PUSH       R2
	LDI        R27, 1
	MOV        R2, R27
	CALL       _LCD_Command+0
;MonoTronic.c,310 :: 		LCD_Command (0x80);                // cursor at home position
	LDI        R27, 128
	MOV        R2, R27
	CALL       _LCD_Command+0
;MonoTronic.c,311 :: 		}
L_end_LCD_Clear:
	POP        R2
	RET
; end of _LCD_Clear

_recirculation_mode:

;MonoTronic.c,313 :: 		void recirculation_mode()                  // Print "Recirculation Mode" on LCD
;MonoTronic.c,315 :: 		LCD_Clear();
	PUSH       R2
	PUSH       R3
	CALL       _LCD_Clear+0
;MonoTronic.c,316 :: 		Delay_ms(10);
	LDI        R17, 104
	LDI        R16, 229
L_recirculation_mode73:
	DEC        R16
	BRNE       L_recirculation_mode73
	DEC        R17
	BRNE       L_recirculation_mode73
;MonoTronic.c,317 :: 		LCD_String("Recirculation");
	LDI        R27, #lo_addr(?lstr1_MonoTronic+0)
	MOV        R2, R27
	LDI        R27, hi_addr(?lstr1_MonoTronic+0)
	MOV        R3, R27
	CALL       _LCD_String+0
;MonoTronic.c,318 :: 		LCD_Command(0xC0);
	LDI        R27, 192
	MOV        R2, R27
	CALL       _LCD_Command+0
;MonoTronic.c,319 :: 		LCD_String("Mode");
	LDI        R27, #lo_addr(?lstr2_MonoTronic+0)
	MOV        R2, R27
	LDI        R27, hi_addr(?lstr2_MonoTronic+0)
	MOV        R3, R27
	CALL       _LCD_String+0
;MonoTronic.c,320 :: 		}
L_end_recirculation_mode:
	POP        R3
	POP        R2
	RET
; end of _recirculation_mode

_fresh_air_mode:

;MonoTronic.c,322 :: 		void fresh_air_mode()                      // Print "Fresh Air Mode" on LCD
;MonoTronic.c,324 :: 		LCD_Clear();
	PUSH       R2
	PUSH       R3
	CALL       _LCD_Clear+0
;MonoTronic.c,325 :: 		Delay_ms(10);
	LDI        R17, 104
	LDI        R16, 229
L_fresh_air_mode75:
	DEC        R16
	BRNE       L_fresh_air_mode75
	DEC        R17
	BRNE       L_fresh_air_mode75
;MonoTronic.c,326 :: 		LCD_String("Fresh Air");
	LDI        R27, #lo_addr(?lstr3_MonoTronic+0)
	MOV        R2, R27
	LDI        R27, hi_addr(?lstr3_MonoTronic+0)
	MOV        R3, R27
	CALL       _LCD_String+0
;MonoTronic.c,327 :: 		LCD_Command(0xC0);
	LDI        R27, 192
	MOV        R2, R27
	CALL       _LCD_Command+0
;MonoTronic.c,328 :: 		LCD_String("Mode");
	LDI        R27, #lo_addr(?lstr4_MonoTronic+0)
	MOV        R2, R27
	LDI        R27, hi_addr(?lstr4_MonoTronic+0)
	MOV        R3, R27
	CALL       _LCD_String+0
;MonoTronic.c,329 :: 		}
L_end_fresh_air_mode:
	POP        R3
	POP        R2
	RET
; end of _fresh_air_mode

_AC_off:

;MonoTronic.c,331 :: 		void AC_off()                      // Print "AC off" on LCD
;MonoTronic.c,333 :: 		LCD_Clear();
	PUSH       R2
	PUSH       R3
	CALL       _LCD_Clear+0
;MonoTronic.c,334 :: 		Delay_ms(10);
	LDI        R17, 104
	LDI        R16, 229
L_AC_off77:
	DEC        R16
	BRNE       L_AC_off77
	DEC        R17
	BRNE       L_AC_off77
;MonoTronic.c,335 :: 		LCD_String("AC");
	LDI        R27, #lo_addr(?lstr5_MonoTronic+0)
	MOV        R2, R27
	LDI        R27, hi_addr(?lstr5_MonoTronic+0)
	MOV        R3, R27
	CALL       _LCD_String+0
;MonoTronic.c,336 :: 		LCD_Command(0xC0);
	LDI        R27, 192
	MOV        R2, R27
	CALL       _LCD_Command+0
;MonoTronic.c,337 :: 		LCD_String("off");
	LDI        R27, #lo_addr(?lstr6_MonoTronic+0)
	MOV        R2, R27
	LDI        R27, hi_addr(?lstr6_MonoTronic+0)
	MOV        R3, R27
	CALL       _LCD_String+0
;MonoTronic.c,338 :: 		}
L_end_AC_off:
	POP        R3
	POP        R2
	RET
; end of _AC_off

_send_data:

;MonoTronic.c,341 :: 		void send_data(int co_in,int co_out,int co2_in,int co2_out) {
;MonoTronic.c,343 :: 		Delay_ms(10);
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	PUSH       R6
	PUSH       R7
	LDI        R17, 104
	LDI        R16, 229
L_send_data79:
	DEC        R16
	BRNE       L_send_data79
	DEC        R17
	BRNE       L_send_data79
;MonoTronic.c,344 :: 		UART1_Write(13);
	PUSH       R3
	PUSH       R2
	LDI        R27, 13
	MOV        R2, R27
	CALL       _UART1_Write+0
	POP        R2
	POP        R3
;MonoTronic.c,345 :: 		floatToStr(co_in,str1);
	MOVW       R16, R2
	LDI        R18, 0
	SBRC       R3, 7
	LDI        R18, 255
	MOV        R19, R18
	CALL       _float_slong2fp+0
	PUSH       R9
	PUSH       R8
	PUSH       R7
	PUSH       R6
	PUSH       R5
	PUSH       R4
	LDI        R27, #lo_addr(_str1+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_str1+0)
	MOV        R7, R27
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _FloatToStr+0
	POP        R4
	POP        R5
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;MonoTronic.c,346 :: 		UART1_write_Text("CO_in:");
	LDI        R27, #lo_addr(?lstr7_MonoTronic+0)
	MOV        R2, R27
	LDI        R27, hi_addr(?lstr7_MonoTronic+0)
	MOV        R3, R27
	CALL       _UART1_Write_Text+0
;MonoTronic.c,347 :: 		UART1_write_Text(str1);
	LDI        R27, #lo_addr(_str1+0)
	MOV        R2, R27
	LDI        R27, hi_addr(_str1+0)
	MOV        R3, R27
	CALL       _UART1_Write_Text+0
;MonoTronic.c,348 :: 		UART1_Write(13);
	LDI        R27, 13
	MOV        R2, R27
	CALL       _UART1_Write+0
;MonoTronic.c,350 :: 		floatToStr(co_out,str2);
	MOVW       R16, R4
	LDI        R18, 0
	SBRC       R5, 7
	LDI        R18, 255
	MOV        R19, R18
	CALL       _float_slong2fp+0
	PUSH       R9
	PUSH       R8
	PUSH       R7
	PUSH       R6
	LDI        R27, #lo_addr(_str2+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_str2+0)
	MOV        R7, R27
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _FloatToStr+0
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;MonoTronic.c,351 :: 		UART1_write_Text("CO_out:");
	LDI        R27, #lo_addr(?lstr8_MonoTronic+0)
	MOV        R2, R27
	LDI        R27, hi_addr(?lstr8_MonoTronic+0)
	MOV        R3, R27
	CALL       _UART1_Write_Text+0
;MonoTronic.c,352 :: 		UART1_write_Text(str2);
	LDI        R27, #lo_addr(_str2+0)
	MOV        R2, R27
	LDI        R27, hi_addr(_str2+0)
	MOV        R3, R27
	CALL       _UART1_Write_Text+0
;MonoTronic.c,353 :: 		UART1_Write(13);
	LDI        R27, 13
	MOV        R2, R27
	CALL       _UART1_Write+0
;MonoTronic.c,355 :: 		floatToStr(co2_in,str3);
	MOVW       R16, R6
	LDI        R18, 0
	SBRC       R7, 7
	LDI        R18, 255
	MOV        R19, R18
	CALL       _float_slong2fp+0
	PUSH       R9
	PUSH       R8
	LDI        R27, #lo_addr(_str3+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_str3+0)
	MOV        R7, R27
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _FloatToStr+0
	POP        R8
	POP        R9
;MonoTronic.c,356 :: 		UART1_write_Text("CO2_in:");
	LDI        R27, #lo_addr(?lstr9_MonoTronic+0)
	MOV        R2, R27
	LDI        R27, hi_addr(?lstr9_MonoTronic+0)
	MOV        R3, R27
	CALL       _UART1_Write_Text+0
;MonoTronic.c,357 :: 		UART1_write_Text(str3);
	LDI        R27, #lo_addr(_str3+0)
	MOV        R2, R27
	LDI        R27, hi_addr(_str3+0)
	MOV        R3, R27
	CALL       _UART1_Write_Text+0
;MonoTronic.c,358 :: 		UART1_Write(13);
	LDI        R27, 13
	MOV        R2, R27
	CALL       _UART1_Write+0
;MonoTronic.c,360 :: 		floatToStr(co2_out,str4);
	MOVW       R16, R8
	LDI        R18, 0
	SBRC       R9, 7
	LDI        R18, 255
	MOV        R19, R18
	CALL       _float_slong2fp+0
	LDI        R27, #lo_addr(_str4+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_str4+0)
	MOV        R7, R27
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _FloatToStr+0
;MonoTronic.c,361 :: 		UART1_write_Text("CO2_out:");
	LDI        R27, #lo_addr(?lstr10_MonoTronic+0)
	MOV        R2, R27
	LDI        R27, hi_addr(?lstr10_MonoTronic+0)
	MOV        R3, R27
	CALL       _UART1_Write_Text+0
;MonoTronic.c,362 :: 		UART1_write_Text(str4);
	LDI        R27, #lo_addr(_str4+0)
	MOV        R2, R27
	LDI        R27, hi_addr(_str4+0)
	MOV        R3, R27
	CALL       _UART1_Write_Text+0
;MonoTronic.c,363 :: 		UART1_Write(13);
	LDI        R27, 13
	MOV        R2, R27
	CALL       _UART1_Write+0
;MonoTronic.c,364 :: 		}
L_end_send_data:
	POP        R7
	POP        R6
	POP        R5
	POP        R4
	POP        R3
	POP        R2
	RET
; end of _send_data

#line 1 "D:/Team Derp's MonoTronic/Embedded Solution/Embedded C code/MonoTronic.c"
#line 1 "d:/softwares/mikroc/mikroc pro for avr/include/stdbool.h"



 typedef char _Bool;
#line 25 "D:/Team Derp's MonoTronic/Embedded Solution/Embedded C code/MonoTronic.c"
int CO_in;
int CO_out;
int CO2_in;
int CO2_out;
int occupancy;
int AC_mode;
int CO_flag;
 _Bool  flag;
 _Bool  CO2_check =  0 ;
int CO2_occu;
char str1[2];
char str2[2];
char str3[2];
char str4[2];




void CO_control();
void CO2_control();
int CO2_occu_get(int);
int check_occupancy();
float get_CO_in();
float get_CO_out();
float get_CO2_in();
float get_CO2_out();
void send_data(int, int , int, int);


void LCD_Command(unsigned char);
void LCD_Char (unsigned char);
void LCD_start (void);
void LCD_String (char);
void LCD_String_xy (char, char, char);
void LCD_Clear();
void recirculation_mode();
void fresh_air_mode();
void AC_off();


void main(){


 DDRA = 0x00;
 DDRB = 0xFF;
 DDRC = 0xFF;
 DDRD = 0x00;


 ADC_Init();
 LCD_start();
 UART1_Init(9600);
 Delay_ms(10);
 recirculation_mode();
 AC_mode = 0;
 Delay_ms(10);

 flag =  0 ;


 while(1){
 CO_in = get_CO_in();
 CO_out = get_CO_out();
 CO2_in = get_CO2_in();
 CO2_out = get_CO2_out();
 Delay_ms(50);
 if(CO_in >= 1000 || CO2_in >= 10000)
 {
 AC_off();
 AC_mode = 2;
 }
 if(CO_in >= 30)
 {
 CO_control();
 }
 if(CO_in < 30)
 {
 if(CO2_in >= 1300)
 {
 CO2_control();
 }
 occupancy = check_occupancy();
 CO2_occu = CO2_occu_get(occupancy);
 if(CO2_in < CO2_occu && CO2_check ==  1 )
 {
 recirculation_mode();
 AC_mode = 0;
 CO2_check =  0 ;
 }
 }
 send_data(CO_in, CO_out, CO2_in, CO2_out);
 Delay_ms(1000);

 }
}


void CO_control(){
 if(CO_in - CO_out >= 10)
 {
 if(AC_mode == 0)
 {
 fresh_air_mode();
 AC_mode = 1;
 }
 if(AC_mode == 1)
 {
 if(flag ==  0 )
 {
 CO_flag = CO_in;
 flag =  1 ;
 }
 if(CO_in - CO_flag > 20)
 {
 AC_off();
 AC_mode = 2;
 CO_flag = 0;
 flag =  0 ;
 Delay_ms(2);
 }
 }
 }
 if(CO_out - CO_in >= 10)
 {
 if(AC_mode == 1)
 {
 recirculation_mode();
 AC_mode = 0;
 }
 if(AC_mode == 0)
 {
 if(flag ==  0 )
 {
 CO_flag = CO_in;
 flag = ~flag;
 }
 if((CO_in - CO_flag) > 20)
 {
 AC_off();
 CO_flag = 0;
 flag = ~flag;
 AC_mode = 2;
 }
 }

 }
}


void CO2_control()
{
 if(AC_mode == 0)
 {
 fresh_air_mode();
 AC_mode = 1;
 occupancy = check_occupancy();
 Delay_ms(10);
 CO2_occu = CO2_occu_get(occupancy);
 CO2_check =  1 ;
 }
 if(AC_mode == 1 && CO2_check ==  0 )
 {
 if(CO2_out >= 2000)
 {
 recirculation_mode();
 AC_mode = 0;
 while(CO2_out > 1300)
 {
 CO2_out = get_CO2_out();
 send_data(CO_in, CO_out, CO2_in, CO2_out);
 Delay_ms(1000);

 }
 fresh_air_mode();
 AC_mode = 1;
 }
 }
}


int CO2_occu_get(int occupancy)
{
 switch(occupancy)
 {
 case 1:
 return 550; break;
 case 2:
 return 700; break;
 case 3:
 return 850; break;
 case 4:
 return 1000; break;
 case 5:
 return 1150; break;
 }
}



float get_CO_in(){
 return (ADC_Read( PORTA2 )*0.48828125);
}

float get_CO_out(){
 return (ADC_Read( PORTA1 )*0.48828125);
}

float get_CO2_in(){
 return (ADC_Read( PORTA4 )*0.48828125*100);
}

float get_CO2_out(){
 return (ADC_Read( PORTA3 )*0.48828125*100);
}

int check_occupancy()
{
 int count = 1;
 if(PIND.B2 == 1)
 count = count + 1;
 if(PIND.B3 == 1)
 count = count + 1;
 if(PIND.B4 == 1)
 count = count + 1;
 if(PIND.B5 == 1)
 count = count + 1;
 return count;
}


void LCD_Command(unsigned char cmnd)
{
  PORTB = cmnd;
  PORTC  &= ~(1<< PORTC0 );
  PORTC  &= ~(1<< PORTC1 );
  PORTC  |= (1<< PORTC2 );
 Delay_us(1);
  PORTC  &= ~(1<< PORTC2 );
 Delay_ms(3);
}

void LCD_Char (unsigned char char_data)
{
  PORTB = char_data;
  PORTC  |= (1<< PORTC0 );
  PORTC  &= ~(1<< PORTC1 );
  PORTC  |= (1<< PORTC2 );
 Delay_us(1);
  PORTC  &= ~(1<< PORTC2 );
 Delay_ms(1);
}

void LCD_start (void)
{
  DDRC  = 0xFF;
  DDRB  = 0xFF;
 Delay_ms(20);
 LCD_Command (0x38);
 LCD_Command (0x0C);
 LCD_Command (0x06);
 LCD_Command (0x01);
 LCD_Command (0x80);
}

void LCD_String (char *str)
{
 int i;
 for(i=0;str[i]!=0;i++)
 {
 LCD_Char (str[i]);
 }
}

void LCD_String_xy (char row, char pos, char *str)
{
 if (row == 0 && pos<16)
 LCD_Command((pos & 0x0F)|0x80);
 else if (row == 1 && pos<16)
 LCD_Command((pos & 0x0F)|0xC0);
 LCD_String(str);
}

void LCD_Clear()
{
 LCD_Command (0x01);
 LCD_Command (0x80);
}

void recirculation_mode()
{
 LCD_Clear();
 Delay_ms(10);
 LCD_String("Recirculation");
 LCD_Command(0xC0);
 LCD_String("Mode");
}

void fresh_air_mode()
{
 LCD_Clear();
 Delay_ms(10);
 LCD_String("Fresh Air");
 LCD_Command(0xC0);
 LCD_String("Mode");
}

void AC_off()
{
 LCD_Clear();
 Delay_ms(10);
 LCD_String("AC");
 LCD_Command(0xC0);
 LCD_String("off");
}


void send_data(int co_in,int co_out,int co2_in,int co2_out) {

 Delay_ms(10);
 UART1_Write(13);
 floatToStr(co_in,str1);
 UART1_write_Text("CO_in:");
 UART1_write_Text(str1);
 UART1_Write(13);

 floatToStr(co_out,str2);
 UART1_write_Text("CO_out:");
 UART1_write_Text(str2);
 UART1_Write(13);

 floatToStr(co2_in,str3);
 UART1_write_Text("CO2_in:");
 UART1_write_Text(str3);
 UART1_Write(13);

 floatToStr(co2_out,str4);
 UART1_write_Text("CO2_out:");
 UART1_write_Text(str4);
 UART1_Write(13);
}

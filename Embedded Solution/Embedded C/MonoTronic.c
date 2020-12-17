  /* MonoTronic.c
*  Team DERP
*  Automatic Air Quality Control */

#include<stdbool.h>

// Using LCD display to show mode of operation of AC, can be replaced by motor driver control
// Define pins for LCD interface
#define LCD_Data_Dir DDRB                // Define LCD data port direction
#define LCD_Command_Dir DDRC             // Define LCD command port direction register
#define LCD_Data_Port PORTB              // Define LCD data port
#define LCD_Command_Port PORTC           // Define LCD data port
#define RS PORTC0                        // Define Register Select (data/command reg.)pin
#define RW PORTC1                        // Define Read/Write signal pin
#define EN PORTC2

// Define pins for temperature and gas sensors
#define CO_in_pin PORTA2                    // CO sensor inside cabin
#define CO_out_pin PORTA1                   // CO sensor outside cabin
#define CO2_in_pin PORTA4                   // CO2 sensor inside cabin
#define CO2_out_pin PORTA3                  // CO2 sensor outside cabin


// Declare variables
int CO_in;       // CO sensor value inside cabin
int CO_out;      // CO sensor value outside cabin
int CO2_in;      // CO2 sensor value inside cabin
int CO2_out;     // CO2 sensor value outside cabin
int occupancy;      // Number of occupants inside car
int AC_mode;        // current AC mode, 0 - recirculation, 1 - fresh air, 2 - AC off
int CO_flag;        // To check increase of CO
bool flag;        // To check when case 1 and case 2 were detected for CO
bool CO2_check = false;   // To decide which CO2 loop to enter
int CO2_occu;       // Threshold CO2 based on occupancy
char str1[2];
char str2[2];
char str3[2];
char str4[2];



// Declare functions
void CO_control();              // To control CO concentration
void CO2_control();             // To control CO2 contentration
int CO2_occu_get(int);          // Return threshold CO2 based on occupancy
int check_occupancy();          // Get the number of occupants inside car
float get_CO_in();              // Get CO inside cabin in ppm
float get_CO_out();             // Get CO outside cabin in ppm
float get_CO2_in();             // Get CO2 inside cabin in ppm
float get_CO2_out();            // Get CO2 outside cabin in ppm
void send_data(int, int , int, int);  // Send sensor data through UART

// 16 x 2 bit LCD related functions
void LCD_Command(unsigned char);
void LCD_Char (unsigned char);
void LCD_start (void);
void LCD_String (char);
void LCD_String_xy (char, char, char);
void LCD_Clear();
void recirculation_mode();       // Print recirculation mode on LCD
void fresh_air_mode();           // Print fresh air mode on LCD
void AC_off();                   // Print AC off on LCD


void main(){

     // Set I/O ports
     DDRA = 0x00;
     DDRB = 0xFF;
     DDRC = 0xFF;
     DDRD = 0x00;


     ADC_Init();           // Initialize ADC
     LCD_start();          // Initialize LCD
     UART1_Init(9600);     // Initialize UART communication with baud rate of 9600
     Delay_ms(10);
     recirculation_mode();
     AC_mode = 0;
     Delay_ms(10);

     flag = false;

     // Main control loop
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
                       CO2_occu =  CO2_occu_get(occupancy);
                       if(CO2_in < CO2_occu && CO2_check == true)
                       {
                                  recirculation_mode();       // Switch back to recirculation once below threshold
                                  AC_mode = 0;
                                  CO2_check = false;
                       }
              }
              send_data(CO_in, CO_out, CO2_in, CO2_out);
              Delay_ms(1000);

     }
}

// Function to control Carbon Monoxide(CO)
void CO_control(){
     if(CO_in - CO_out >= 10)      // case 1
     {
              if(AC_mode == 0)     // If AC was in recirculation, set to fresh air
              {
                         fresh_air_mode();
                         AC_mode = 1;
              }
              if(AC_mode == 1)    // If AC was in fresh air, check for increase
              {
                         if(flag == false)    // First time case 1 detected in fresh air mode
                                  {
                                     CO_flag = CO_in;
                                     flag = true;
                                  }
                         if(CO_in - CO_flag > 20)    // If CO increased by 20 ppm since this case detected so turn AC off
                         {
                                  AC_off();
                                  AC_mode = 2;
                                  CO_flag = 0;
                                  flag = false;
                                  Delay_ms(2);
                         }
              }
     }
     if(CO_out - CO_in >= 10)       // case 2
     {
               if(AC_mode == 1)     // If AC was in fresh air, set to recirculation
              {
                         recirculation_mode();
                         AC_mode = 0;
              }
              if(AC_mode == 0)       // If AC was in recirculation, check for increase
              {
                         if(flag == false)        // First time this case detected
                                  {
                                     CO_flag = CO_in;
                                     flag = ~flag;
                                  }
                         if((CO_in - CO_flag) > 20)  // If CO increased by 20 ppm since this case detected so turn AC off
                         {
                                  AC_off();
                                  CO_flag = 0;
                                  flag = ~flag;
                                  AC_mode = 2;
                         }
              }

     }
}

// Function to control Carbon Dioxide(CO2)
void CO2_control()
{
     if(AC_mode == 0)                  // If AC was in recirculation mode
     {
                fresh_air_mode();      // Set to fresh air mode
                AC_mode = 1;
                occupancy = check_occupancy();
                Delay_ms(10);
                CO2_occu =  CO2_occu_get(occupancy);   // Get threshold based on occupancy
                CO2_check = true;
     }
     if(AC_mode == 1 && CO2_check == false)      // If fresh air mode while CO2 high outside
     {
                if(CO2_out >= 2000)              // CO2 outside high
                           {
                              recirculation_mode();
                              AC_mode = 0;
                              while(CO2_out > 1300)
                              {
                                            CO2_out = get_CO2_out();
                                            send_data(CO_in, CO_out, CO2_in, CO2_out);
                                            Delay_ms(1000);

                              }
                              fresh_air_mode();   // Set back to fresh air once CO2 outside is low
                              AC_mode = 1;
                           }
     }
}

// Get threshold CO2 value based on occupancy
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


// Get gas sensor values
float get_CO_in(){
     return (ADC_Read(CO_in_pin)*0.48828125);
}

float get_CO_out(){
     return (ADC_Read(CO_out_pin)*0.48828125);
}

float get_CO2_in(){
     return (ADC_Read(CO2_in_pin)*0.48828125*100);
}

float get_CO2_out(){
     return (ADC_Read(CO2_out_pin)*0.48828125*100);
}

int check_occupancy()            // Count occupancy inside car
{
    int count = 1;               // Assumed driver is present
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

// Functions for LCD
void LCD_Command(unsigned char cmnd)
{
        LCD_Data_Port= cmnd;
        LCD_Command_Port &= ~(1<<RS);
        LCD_Command_Port &= ~(1<<RW);
        LCD_Command_Port |= (1<<EN);
        Delay_us(1);
        LCD_Command_Port &= ~(1<<EN);
        Delay_ms(3);
}

void LCD_Char (unsigned char char_data)        // LCD data write function
{
        LCD_Data_Port= char_data;
        LCD_Command_Port |= (1<<RS);
        LCD_Command_Port &= ~(1<<RW);
        LCD_Command_Port |= (1<<EN);
        Delay_us(1);
        LCD_Command_Port &= ~(1<<EN);
        Delay_ms(1);
}

void LCD_start (void)                        // LCD Initialize function
{
        LCD_Command_Dir = 0xFF;             // Make LCD command port direction as o/p
        LCD_Data_Dir = 0xFF;                // Make LCD data port direction as o/p
        Delay_ms(20);                       // LCD Power ON delay always >15ms
        LCD_Command (0x38);                 // Initialization of 16X2 LCD in 8bit mode
        LCD_Command (0x0C);                 // Display ON Cursor OFF
        LCD_Command (0x06);                 // Auto Increment cursor
        LCD_Command (0x01);                 // Clear display
        LCD_Command (0x80);                 // Cursor at home position
}

void LCD_String (char *str)                // Send string to LCD function
{
        int i;
        for(i=0;str[i]!=0;i++)                // Send each char of string till the NULL
        {
                LCD_Char (str[i]);
        }
}

void LCD_String_xy (char row, char pos, char *str)  // Send string to LCD with xy position
{
        if (row == 0 && pos<16)
        LCD_Command((pos & 0x0F)|0x80);        //Command of first row and required position<16
        else if (row == 1 && pos<16)
        LCD_Command((pos & 0x0F)|0xC0);        // Command of first row and required position<16
        LCD_String(str);                       // Call LCD string function
}

void LCD_Clear()                           // Clear LCD screen
{
        LCD_Command (0x01);                // clear display
        LCD_Command (0x80);                // cursor at home position
}

void recirculation_mode()                  // Print "Recirculation Mode" on LCD
{
     LCD_Clear();
     Delay_ms(10);
     LCD_String("Recirculation");
     LCD_Command(0xC0);
     LCD_String("Mode");
}

void fresh_air_mode()                      // Print "Fresh Air Mode" on LCD
{
      LCD_Clear();
      Delay_ms(10);
      LCD_String("Fresh Air");
      LCD_Command(0xC0);
      LCD_String("Mode");
}

void AC_off()                      // Print "AC off" on LCD
{
      LCD_Clear();
      Delay_ms(10);
      LCD_String("AC");
      LCD_Command(0xC0);
      LCD_String("off");
}

// Send sensor values through UART
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
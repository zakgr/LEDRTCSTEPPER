#line 1 "C:/Users/GT21/Desktop/LEDRTC2/LED RTC2/LED RTC2.c"

sbit LCD_RS at RB0_bit;
sbit LCD_EN at RB1_bit;
sbit LCD_D4 at RB2_bit;
sbit LCD_D5 at RB3_bit;
sbit LCD_D6 at RB4_bit;
sbit LCD_D7 at RB5_bit;

sbit LCD_RS_Direction at TRISB0_bit;
sbit LCD_EN_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB4_bit;
sbit LCD_D7_Direction at TRISB5_bit;





int res;
unsigned short step;
unsigned short dirstep;
unsigned short mode;
unsigned short wave;
unsigned short sec;
unsigned short minute;
unsigned short hour;
unsigned short day;
unsigned short date;
unsigned short month;
unsigned short year;
unsigned short dataa;
unsigned char dday;
unsigned char dhour;
unsigned short temp;
char time[] ="00:00:00 PM";
char ddate[] = "00/00/0000";
char txt[] = "                 ";
char txt1[] = "DIRECTION SELECT ";
char txt2[] = "TEST MODE        ";
char txt3[] = "WAVE SELECT      ";
char txta[] = "Iezekiil Ioannou";
char *uart_rd;
char uart_wt[10];
unsigned char BCD2UpperCh(unsigned char bcd);
unsigned char BCD2LowerCh(unsigned char bcd);
void stbutton();
void datafetch();
void steppermotor(short step);
unsigned short read_ds1307(unsigned short address );
void write_ds1307(unsigned short address,unsigned short w_data);
void lcdprint(int i);
void uartstarter();
void date_cast();
void time_cast();

void main(){
 ADCON1 = 7;
 CMCON = 7;
 UART1_Init(9600);
 I2C1_Init(100000);
 TRISB = 0x00;
 TRISA = 0x00;
 TRISC = 0xFF;
 TRISE = 0xFF;
 write_ds1307(0x18,0x00);
 write_ds1307(0x19,0x00);
 step=0;
 mode=0;
 wave=0;
 Lcd_Init();
 lcdprint(0);
 Delay_ms( 100 );

 while(1)
 {
 uartstarter();
 stbutton();
 step=read_ds1307(0x18);
 dirstep=read_ds1307(0x19);
 if (PORTA.F5==0){steppermotor(step);}
 lcdprint(1);
 delay_us(100);
 }
}
void uartstarter()
{
 if (UART1_Data_Ready() != 0) {
 uart_rd = UART1_Read();
 }
 EEPROM_write(0x500,uart_rd);
 uart_wt[0]=EEPROM_read(0x500);
 uart_wt[1]=EEPROM_read(0x502);
 Lcd_Out(1,1,uart_wt);
 if (UART1_Data_Ready() != 0) {
 UART1_Write(&uart_wt);
 }
 return;
}
void stbutton()
{
 if(PORTE.F0==0 && PORTE.F1==0){
 write_ds1307(0,0x80);
 write_ds1307(1,0x00);
 write_ds1307(2,0x49);
 write_ds1307(3,0x01);
 write_ds1307(4,0x23);
 write_ds1307(5,0x11);
 write_ds1307(6,0x14);
 write_ds1307(7,0x10);
 write_ds1307(0,0x00);
 Delay_ms( 100 );
 }
 if (PORTE.F0==0 && PORTE.F1==1){
 mode++;
 Delay_ms( 100 );
 if (mode>2){mode=0;}
 }


 if (PORTE.F1==0 && mode==0 && PORTE.F0==1){
 write_ds1307(0x19,0x01);
 Delay_ms( 100 );
 }
 if (PORTE.F2==0 && mode==0){
 write_ds1307(0x19,0x00);
 Delay_ms( 100 );
 }



 if (PORTE.F1==0 && mode==1 && PORTE.F0==1){
 write_ds1307(0,0x80);
 write_ds1307(1,0x00);
 write_ds1307(2,0x43);
 write_ds1307(0,0x00);
 Delay_ms( 100 );
 }
 if (PORTE.F2==0 && mode==1){
 write_ds1307(0,0x80);
 write_ds1307(1,0x59);
 write_ds1307(2,0x46);
 write_ds1307(0,0x00);
 Delay_ms( 100 );
 }



 if (PORTE.F1==0 && mode==2 && PORTE.F0==1){
 write_ds1307(0x10,0x01);
 write_ds1307(0x11,0x02);
 write_ds1307(0x12,0x04);
 write_ds1307(0x13,0x08);
 Delay_ms( 100 );
 }
 if (PORTE.F2==0 && mode==2){
 write_ds1307(0x10,0x03);
 write_ds1307(0x11,0x06);
 write_ds1307(0x12,0x0C);
 write_ds1307(0x13,0x09);
 Delay_ms( 100 );
 }

 return;
}

void steppermotor(short step)
{
 if (step==0){ PORTA = read_ds1307(0x10);}
 else if (step==1){ PORTA = read_ds1307(0x11);}
 else if (step==2){ PORTA = read_ds1307(0x12);}
 else if (step==3){ PORTA = read_ds1307(0x13);}
 PORTA.F5 = temp;
 if (dirstep == 1){
 step--;
 if (step<0){step=3;}
 write_ds1307(0x18,step);
 }
 else{
 step++;
 if (step>3){step=0;}
 write_ds1307(0x18,step);
 }
 return;
}
void lcdprint(int i)
{
 if (i==1){
 datafetch();

 Lcd_Out(2,1,time);
 if (mode==0){res=strncpy(txt,txt1,17);}
 else if (mode==1){res=strncpy(txt,txt2,17);}
 else if (mode==2){res=strncpy(txt,txt3,17);}
 Lcd_Out(3,1,res);
 return;
 }
 else{
 Lcd_Cmd(_Lcd_CLEAR);
 Lcd_Cmd(_Lcd_CURSOR_OFF);
 Lcd_Out(1,1,"Prj Night RTCLED");
 Lcd_Out(2,1,txta);
 Lcd_Out(3,1, "AM:42012" );
 Delay_ms(3800);
 Lcd_Cmd(_Lcd_CLEAR);
 return;
 }
}

void datafetch()
{
 sec=read_ds1307(0);
 minute=read_ds1307(1);
 hour=read_ds1307(2);
 day=read_ds1307(3);
 date=read_ds1307(4);
 month=read_ds1307(5);
 year=read_ds1307(6);

 if ((hour >= 0x43)&(hour <= 0x46)){
 PORTA.F5=1;temp=1;
 write_ds1307(0x20,0x02);
 }
 else{
 PORTA.F5=0;temp=0;
 write_ds1307(0x20,0x01);
 }
 date_cast();
 time_cast();
 return;
}
void date_cast(){

 dday = BCD2LowerCh(day);
 if (dday == '1') {
 ddate[0] ='S';
 ddate[1] ='u';
 ddate[2] ='n';
 }
 else if (dday == '2') {
 ddate[0] ='M';
 ddate[1] ='o';
 ddate[2] ='n';
 }
 else if (dday == '3') {
 ddate[0] ='T';
 ddate[1] ='u';
 ddate[2] ='e';
 }
 else if (dday == '4') {
 ddate[0] ='W';
 ddate[1] ='e';
 ddate[2] ='d';
 }
 else if (dday == '5') {
 ddate[0] ='T';
 ddate[1] ='h';
 ddate[2] ='u';
 }
 else if (dday == '6') {
 ddate[0] ='F';
 ddate[1] ='r';
 ddate[2] ='i';
 }
 else if (dday == '7') {
 ddate[0] ='S';
 ddate[1] ='a';
 ddate[2] ='t';
 }
 ddate[3] = ' ';
 ddate[4] = BCD2UpperCh(date);
 ddate[5] = BCD2LowerCh(date);
 ddate[6] = '/';
 ddate[7] = BCD2UpperCh(month);
 ddate[8] = BCD2LowerCh(month);
 ddate[9] = '/';
 ddate[10] = '2';
 ddate[11] = '0';
 ddate[12] = BCD2UpperCh(year);
 ddate[13] = BCD2LowerCh(year);
 ddate[14] = '\0';
 return;
}
void time_cast(){
 dhour = BCD2UpperCh(hour);
 if (dhour == '4') {
 time[0] = ' ';
 time[9] = 'A';
 }
 else if (dhour == '5') {
 time[0] = '1';
 time[9] = 'A';
 }
 else if (dhour == '6') {
 time[0] = ' ';
 time[9] = 'P';
 }
 else if (dhour == '7') {
 time[0] = '1';
 time[9] = 'P';
 }

 time[1] = BCD2LowerCh(hour);
 time[2] = ':';
 time[3] = BCD2UpperCh(minute);
 time[4] = BCD2LowerCh(minute);
 time[5] = ':';
 time[6] = BCD2UpperCh(sec);
 time[7] = BCD2LowerCh(sec);
 time[8] = ' ';
 time[10] = 'M';
 time[11] = '\0';
 return;
}
unsigned char BCD2UpperCh(unsigned char bcd)
{
return ((bcd >> 4) + '0');
}

unsigned char BCD2LowerCh(unsigned char bcd)
{
return ((bcd & 0x0F) + '0');
}

unsigned short read_ds1307(unsigned short address)
{
 I2C1_Start();
 I2C1_Wr(0xd0);
 I2C1_Wr(address);
 I2C1_Repeated_Start();
 I2C1_Wr(0xd1);
 dataa=I2C1_Rd(0);
 I2C1_Stop();
 return(dataa);
}

void write_ds1307(unsigned short address,unsigned short w_data)
{
 I2C1_Start();

 I2C1_Wr(0xD0);
 I2C1_Wr(address);
 I2C1_Wr(w_data);
 I2C1_Stop();
}

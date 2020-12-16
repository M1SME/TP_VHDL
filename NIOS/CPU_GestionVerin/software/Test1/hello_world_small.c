#include "alt_types.h"
#include "system.h"
#include "unistd.h"
#include "stdio.h"
//#define control (char *) LEDS_BASE
//#define code_fonction (char *) SWITCHS_BASE
//#define compas (int *)COMPAS_BASE
#define butee_d (int *)(GESTIONVERIN_0_BASE +12)
#define butee_g (int *)(GESTIONVERIN_0_BASE +8)
#define freq (int *)GESTIONVERIN_0_BASE
#define duty (int *)(GESTIONVERIN_0_BASE +4)
#define config (int *)(GESTIONVERIN_0_BASE +16)
#define angle_barre (int *)(GESTIONVERIN_0_BASE +20)
int main()
{
 unsigned int a,c,d;
 unsigned char b;

 printf("Hello from Nios II!\n");
 //*control=(*control) | 3;//active circuits gestion_bp et gestion_compas
 *butee_d=1320;
 *butee_g=410;
 *freq= 2000;
 *duty=1500;
 *config=1; // circuit gestion_verin actif, sortie pwm inactive

 while (1)
 {
 //test bp en mode manuel seul
// b=*code_fonction;
 printf("code_fonction= %d\n", b);
 switch(b)
 {
 case 0: *config=1;break;
 case 1: *config=7;break;
 case 2: *config=3;break;
 default:*config=1;
 }
 //a=((*compas)-10)&511;
 printf("compas= %d\n", a);
 c=*freq;
 printf("freq= %d\n", c);
 d=*duty;
 printf("duty= %d\n", d);
 c=*butee_d;
 printf("butee_d= %d\n", c);
 d=*butee_g;
 printf("butee_g= %d\n", d);
 c=*config;
 printf("config= %d\n", c);
 d=*angle_barre;
 printf("angle_barre= %d\n", d);
 usleep(100000);

 }
 return 0;
}

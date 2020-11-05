

#define Config (unsigned int *) BOUSSOLE_0_BASE
#define Compas (unsigned int *) (BOUSSOLE_0_BASE + 4)
#define freq (unsigned int *) AVALON_PWM_0_BASE
#define duty (unsigned int *) (AVALON_PWM_0_BASE + 4)
#define ctrl (unsigned int *) (AVALON_PWM_0_BASE + 8)
#include "system.h"
#include "sys/alt_stdio.h"
#include "stdio.h"
#include "stdlib.h"

int main()
{ 
	int data_valid = 0;
	unsigned int  valeur_boussole = 0;
	int angle = 0;
	  alt_putstr("Initialisation AVALLON PWM \n");

	  *freq = 0x40d990; // divise clk par 4250000
	  *duty = 0x0fd990; // RC = 20%
	  *ctrl = 0x3;

  alt_putstr("Initialisation Module BOUSSOLE \n");

  	  *Config = 0x2;


  /* Event loop never exits. */
  while (1){

	 data_valid = *Compas & 0x100;
	  if(data_valid>>8 == 1 && (*Compas)& 0xff != 0){

		  valeur_boussole = (*Compas)& 0xff;
		  alt_putstr("Compas = 0x ");
		  printf("%x",valeur_boussole);
		  alt_putstr("\n");

		  angle = (valeur_boussole - 1 ) * 10;
		  alt_putstr("Angle =  ");
		  printf("%d",angle);
		  alt_putstr(" degres ");
		alt_putstr("\n");

	  }

  }

  return 0;
}

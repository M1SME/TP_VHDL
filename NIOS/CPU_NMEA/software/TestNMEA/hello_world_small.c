

#define Config   (unsigned int *) (NMEA_INTERFACE_0_BASE)
#define Synchro  (unsigned int *) (NMEA_INTERFACE_0_BASE + 4)
#define Centaine (unsigned int *) (NMEA_INTERFACE_0_BASE +8)
#define Dizaine  (unsigned int *) (NMEA_INTERFACE_0_BASE + 12)
#define unite    (unsigned int *) (NMEA_INTERFACE_0_BASE + 16)
#include "system.h"
#include "sys/alt_stdio.h"
#include "stdio.h"
#include "stdlib.h"

int main()
{ 
	/*int data_valid = 0;
	unsigned int  donnees_anemo = 0;
	int vitesse = 0;
	  alt_putstr("Initialisation AVALLON PWM \n");

	  *freq = 0x4c4b40; // divise clk par 5 000 000 donc Freq = 10Hz
	  *duty = 0x2625a0; // RC = 50%
	  *ctrl = 0x3;

  alt_putstr("Initialisation Module ANEMOMETRE \n");

  	  *Config = 0x2;    // Mode continu*/

	  alt_putstr("Initialisation Module NMEA \n");

	  *Config = 0x2;    // Mode continu*/
	  *unite  = 0x61;
	  *Synchro = 0x62;
	  *Centaine = 0x63;
	  *Dizaine = 0x64;

  while (1){


	  if( *Synchro & 0xff != 0){


		  alt_putstr("Synchro  = 0x ");
		  printf("%x",*Synchro & 0xff );
		  alt_putstr("\n");

		  alt_putstr("Centaine  = 0x ");
		  printf("%x",*Centaine & 0xff );
		  alt_putstr("\n");

		  alt_putstr("Dizaine = 0x ");
		  printf("%x",*Dizaine & 0xff );
		  alt_putstr("\n");

		  alt_putstr("Unite = 0x ");
		  printf("%x",*unite & 0xff );
		  alt_putstr("\n");



	  }

  }

  return 0;
}

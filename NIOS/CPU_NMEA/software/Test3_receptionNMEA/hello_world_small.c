

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

	  alt_putstr("Initialisation Module NMEA \n");

	  *Config = 0x2;    // Mode continu*/
	  *Synchro = 0x61 ;
	  *Centaine = 0x64;
	  *Dizaine = 0x63;
	  *unite = 0x62;

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


#define AVALON_PWM_0_BASE 0x00011020
#define freq (unsigned int *) AVALON_PWM_0_BASE
#define duty (unsigned int *) (AVALON_PWM_0_BASE + 4)
#include "sys/alt_stdio.h"

int main()
{ 
  alt_putstr("TEST AVALLON PWM \n");

  *freq = 0x0100; //
  *duty = 0x0200; // RC = 50%
  while (1);

  return 0;
}

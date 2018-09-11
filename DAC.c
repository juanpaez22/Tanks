// put implementations for functions, explain how it works
// Juan Paez and Evan Chang
// 4/22/2018
// Use port B pins 0-3 to output 4 bit data in the form of a voltage ranging from 0-3.3

#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"
// Code files contain the actual implemenation for public functions
// this file also contains an private functions and private data

// **************DAC_Init*********************
// Initialize 4-bit DAC, called once 
// Input: none
// Output: none
void DAC_Init(void){
	int delay;
	SYSCTL_RCGCGPIO_R |= 0x02; // enable clock in port b
  delay++;    // delay
  GPIO_PORTB_DIR_R |= 0x3F;      // make PB5-0 output
  GPIO_PORTB_DEN_R |= 0x3F;      // enable digital I/O on PB5-0
	GPIO_PORTB_DR8R_R = 0xFFFF;
}

// **************DAC_Out*********************
// output to DAC
// Input: 4-bit data, 0 to 15 
// Input=n is converted to n*3.3V/15
// Output: none
void DAC_Out(uint32_t data){
	if (data <16)
			GPIO_PORTB_DATA_R = data;
}





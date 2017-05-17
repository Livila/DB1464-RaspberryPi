#include <stdio.h>
int main( int argc, const char* argv[] )
{
	int GPIO_NR = 10;

	int gpio_addr = (((0x3F200000) & 0x00FFFFFF) + (((0x3F200000) >> 4) & 0x0F000000) + 0xF0000000);

	printf("GPIO_NR: %d\n", GPIO_NR);
	printf("gpio_addr: %x\n", gpio_addr);


//	int gpio_addr1 = gpio_addr + (4*( GPIO_NR /10));
//	int gpio_addr2 = gpio_addr1 |= 1<<(((GPIO_NR)%10)*3);
//	printf( "gpio_addt2: '%x'\n", gpio_addr2);

	printf("(4*(GPIO_NR/10))): %x\n", (4*(GPIO_NR/10)));


	printf("(1<<(((GPIO_NR) %% 10)*3): %x\n", 1<<(((GPIO_NR)%10)*3));
	printf("~(7<<((GPIO_NR %% 10)*3): %x\n", ~(7<<((GPIO_NR %10)*3)));

	printf("(gpio_addr+ (4*(GPIO_NR/10))) |= (1<<(((GPIO_NR)%%10)*3): %x\n", (gpio_addr + (4*(GPIO_NR/10))) + (1<<(((GPIO_NR)%10)*3)));

	printf("4*(7 + (GPIO_NR/32))): %x\n", 4*(7 + (GPIO_NR/32)));
	printf("(4*(10 + (GPIO_NR/32)))): %x\n", 4*(10 + (GPIO_NR/32)));

	printf("(1 << (GPIO_NR %% 32)): %x\n", 1 << (GPIO_NR % 32));

	//gpio_addr2 = gpio_addr1 &= ~(7<<((GPIO_NR %10)*3));
        //printf( "gpio_addt3: '%x'\n", gpio_addr2);

	//printf("%x\n", 4*(7 + (GPIO_NR/32)));
	//printf("högt läge: %x\n", 1 << (GPIO_NR% 32));


	//printf("Address: %x", 4*(7 + (GPIO_NR/32)));

//	LDR	r5, =variable
}



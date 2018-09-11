
#include <math.h>
#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"
#include "ST7735.h"


//header file for projectile functions
void Delay(void);		//small delay between projectile physics movement
void PrintProjectile(void);		//prints projectile
void DeleteProjectile(void);	//deletes projectile
void ProjectileSetVel(int xVel, int yVel);	//sets projectile velocity
void ProjectileSetPos(int x, int y);		//sets projectile position
int Player1Fire(int power, int angle);	//allows player 1 to fire, returns 1 if hit
int Player2Fire(int power, int angle);	//allows player 2 to fire, returns 1 if hit


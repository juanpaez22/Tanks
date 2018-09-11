#include <stdint.h>
#include "tm4c123gh6pm.h"

//header for player functions
//self-explanatory functions include move, print, and reset position

void Tank1MoveLeft(void);
void Tank2MoveLeft(void);
void Tank1MoveRight(void);
void Tank2MoveRight(void);
void Tank1Print(void);
void Tank2Print(void);
void Delay100ms(uint32_t count);
int Tank1GetPos(void);
int Tank2GetPos(void);
void TanksReset(void);


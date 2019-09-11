#include <stdio.h>
#include "nonnull.h"


/* compile without flags, and with -O2, and compare results :) */
/* http://rachid.koucha.free.fr/tech_corner/nonnull_gcc_attribute.html */

int func(void *ptr) {
	if (!ptr) {
		printf ("NULL\n");
		return -1;
	}

	printf("!NULL\n");
	return 0;
}

int main(int ac, char *av[]) {
	func(NULL);
	return 0;
}



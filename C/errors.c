#include <stdio.h>
#include <string.h>
#include <locale.h>

/**
 * replaces all instances of s to d in str
 *
 **/

void replace_char(char s, char d, char *str) {
    while ((str=strchr(str, s)) != NULL) {
        *str++=d ;
    }
}

int main(int ac, char *av[]) {
    int i ;
	char *l=setlocale(LC_ALL, "");
    replace_char(';', '\n', l) ;
    printf("locale:\n%s\n", l);
    for (i=0; i<135; ++i) {
        printf("%3d:%s\n", i, strerror(i)) ;
    }
}

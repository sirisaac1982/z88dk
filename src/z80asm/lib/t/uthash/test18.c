#include "uthash.h"
#include <stdlib.h>   /* malloc */
#include <stdio.h>    /* printf */

typedef struct example_user_t {
    int id;
    int cookie;
    UT_hash_handle hh;
} example_user_t;

int main() {
    int i;
    example_user_t *user, *users=NULL;

    /* create elements */
    for(i=0;i<10;i++) {
        if ( (user = (example_user_t*)malloc(sizeof(example_user_t))) == NULL) exit(-1);
        user->id = i;
        user->cookie = i*i;
        HASH_ADD_INT(users,id,user);
    }

    for(user=users; user != NULL; user=(example_user_t*)user->hh.next) {
        printf("user %d, cookie %d\n", user->id, user->cookie);
    }

    /* delete them all, pathologically */
    while(users) {
      printf("deleting id %i\n", users->id);
      HASH_DEL(users,users); /* single head/deletee var! */
    }
   return 0;
}
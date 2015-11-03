//
//  main.c
//  Threading
//
//  Created by Nikhil Kulkarni on 11/2/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

#include <stdio.h>
#include "pthread.h"

int num = 5;

// Lock for num
pthread_mutex_t num_lock;

void foo(pthread_t thread_two) {
//    pthread_mutex_lock(&num_lock);
    pthread_join(thread_two, NULL);
    printf("%i\n", ++num);
//    pthread_mutex_unlock(&num_lock);
    pthread_exit(0);
}

void foo1() {
//    pthread_mutex_lock(&num_lock);
    printf("%i\n", --num);
//    pthread_mutex_unlock(&num_lock);
    pthread_exit(0);
}

int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    
    pthread_t thread_one, thread_two;
    pthread_create(&thread_one, NULL, (void *) &foo, (void *)thread_two);
    pthread_create(&thread_two, NULL, (void *) &foo1, NULL);
    
    pthread_join(thread_one, NULL);
    pthread_join(thread_two, NULL);
    return 0;
}




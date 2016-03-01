//
//  main.c
//  Threading
//
//  Created by Nikhil Kulkarni on 11/2/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

#include <stdio.h>
#include "pthread.h"

int num = 0;
pthread_mutex_t num_lock;
pthread_cond_t num_full;
pthread_cond_t num_empty;
pthread_mutex_t cond_lock;

/**
 * Simple mutex lock testing
 *
 */
void foo() {
    int lock = pthread_mutex_lock(&num_lock);
        printf("Inside thread %d\n", lock);
        while (num < 500) {
            num += 5;
        }
        printf("%i\n", num);
    pthread_mutex_unlock(&num_lock);
}

void foo1() {
    int lock = pthread_mutex_lock(&num_lock);
        printf("Inside thread %d\n", lock);
        num -= 5;
        printf("%i\n", num);
    pthread_mutex_unlock(&num_lock);
}

/**
 * Simple condition variable testing
 *
 */
void digitizer() {
    pthread_mutex_lock(&cond_lock);
    while (num <= 0) {
        printf("Waiting in digitizer\n");
        pthread_cond_wait(&num_empty, &cond_lock);
    }
    pthread_mutex_unlock(&cond_lock);
    
    //...
    
    pthread_mutex_lock(&cond_lock);
    num -= 1;
    pthread_cond_signal(&num_full);
    pthread_mutex_unlock(&cond_lock);
    printf("Exiting digitizer thread\n");
}

void tracker() {
    pthread_mutex_lock(&cond_lock);
    while (num >= 10) {
        printf("Waiting in tracker\n");
        pthread_cond_wait(&num_full, &cond_lock);
    }
    pthread_mutex_unlock(&cond_lock);

    //...
    
    pthread_mutex_lock(&cond_lock);
    num += 1;
    pthread_cond_signal(&num_empty);
    int i = 0;
    while (i < 5) {
        printf("%d\n", i);
        i++;
    }
    
    pthread_mutex_unlock(&cond_lock);
    printf("Exiting tracker thread\n");
}

int main(int argc, const char * argv[]) {
    // insert code here...
    
//    pthread_t foo_t;
//    pthread_t foo1_t;
//    pthread_mutex_init(&num_lock, NULL);
    
    pthread_t digitize;
    pthread_t track;
    
    pthread_cond_init(&num_empty, NULL);
    pthread_cond_init(&num_full, NULL);
    
    pthread_mutex_init(&cond_lock, NULL);
    
    printf("Creating Digitizer\n");
    pthread_create(&digitize, NULL, (void *)digitizer, NULL);
    printf("Creating Tracker\n");
    pthread_create(&track, NULL, (void *)tracker, NULL);

    printf("Joining thread 1\n");
    pthread_join(digitize, NULL);
//    printf("Joining thread 2\n");
    pthread_join(track, NULL);
    
    return 0;
}






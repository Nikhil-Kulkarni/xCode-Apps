/*
 * student.c
 * Multithreaded OS Simulation for CS 2200, Project 6
 * Fall 2015
 *
 * This file contains the CPU scheduler for the simulation.
 * Name: Nikhil Kulkarni
 * GTID: 903031661
 */

#include <assert.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "os-sim.h"


/*
 * current[] is an array of pointers to the currently running processes.
 * There is one array element corresponding to each CPU in the simulation.
 *
 * current[] should be updated by schedule() each time a process is scheduled
 * on a CPU.  Since the current[] array is accessed by multiple threads, you
 * will need to use a mutex to protect it.  current_mutex has been provided
 * for your use.
 */
static pcb_t **current;
static pthread_mutex_t current_mutex;

static pcb_t *head;
static pthread_mutex_t ready_mutex;
static pthread_cond_t ready_wait;
static unsigned int queue_size;

static int time_slice;
static int round_robin;
static int static_priority;

static int num_cpu;

/*
 * Ready Queue implementation
 *
 */
static void addToTail(pcb_t *new_pcb)
{
    pthread_mutex_lock(&ready_mutex);
    pcb_t *current = head;
    if (head == NULL) {
        head = new_pcb;
    } else {
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_pcb;
    }
    new_pcb->next = NULL;
    queue_size++;
    pthread_cond_signal(&ready_wait);
    pthread_mutex_unlock(&ready_mutex);
}

static pcb_t* removeFromHead()
{
    pcb_t *temp = NULL;
    pthread_mutex_lock(&ready_mutex);
    temp = head;
    if (temp != NULL) {
        head = temp->next;
        queue_size--;
    }
    pthread_mutex_unlock(&ready_mutex);
    return temp;
}

static pcb_t * getHighestPriority()
{
    pthread_mutex_lock(&ready_mutex);
    pcb_t *current_node = head;
    pcb_t *highest_node = NULL;
    pcb_t *highest_previous = NULL;
    pcb_t *previous = NULL;
    
    int highest_priority = 0;
    
    while (current_node != NULL) {
        
        if (current_node->static_priority > highest_priority) {
            highest_node = current_node;
            highest_previous = previous;
            highest_priority = current_node->static_priority;
        }
        previous = current_node;
        current_node = current_node->next;
    }
    if (highest_node == head && highest_node != NULL) {
        head = highest_node->next;
        queue_size--;
    }
    else if (highest_node != NULL && highest_previous != NULL) {
        highest_previous->next = highest_node->next;
        queue_size--;
    }
    pthread_mutex_unlock(&ready_mutex);
    return highest_node;
}


/*
 * schedule() is your CPU scheduler.  It should perform the following tasks:
 *
 *   1. Select and remove a runnable process from your ready queue which
 *	you will have to implement with a linked list or something of the sort.
 *
 *   2. Set the process state to RUNNING
 *
 *   3. Call context_switch(), to tell the simulator which process to execute
 *      next on the CPU.  If no process is runnable, call context_switch()
 *      with a pointer to NULL to select the idle process.
 *	The current array (see above) is how you access the currently running
 *	process indexed by the cpu id. See above for full description.
 *	context_switch() is prototyped in os-sim.h. Look there for more information
 *	about it and its parameters.
 */
static void schedule(unsigned int cpu_id)
{
    pcb_t *new_process;
    // Remove highest priority node
    if (static_priority == 1) {
        new_process = getHighestPriority();
    } else {
        // Remove from head like normal queue
        new_process = removeFromHead();
    }
    if (new_process != NULL) {
        new_process->state = PROCESS_RUNNING;
    }
    pthread_mutex_lock(&current_mutex);
    current[cpu_id] = new_process;
    pthread_mutex_unlock(&current_mutex);
    context_switch(cpu_id, new_process, time_slice);
}


/*
 * idle() is your idle process.  It is called by the simulator when the idle
 * process is scheduled.
 *
 * This function should block until a process is added to your ready queue.
 * It should then call schedule() to select the process to run on the CPU.
 */
extern void idle(unsigned int cpu_id)
{
    /* FIX ME */
    pthread_mutex_lock(&ready_mutex);
    while (queue_size <= 0) {
        pthread_cond_wait(&ready_wait, &ready_mutex);
    }
    pthread_mutex_unlock(&ready_mutex);
    schedule(cpu_id);
    
    /*
     * REMOVE THE LINE BELOW AFTER IMPLEMENTING IDLE()
     *
     * idle() must block when the ready queue is empty, or else the CPU threads
     * will spin in a loop.  Until a ready queue is implemented, we'll put the
     * thread to sleep to keep it from consuming 100% of the CPU time.  Once
     * you implement a proper idle() function using a condition variable,
     * remove the call to mt_safe_usleep() below.
     */
}


/*
 * preempt() is the handler called by the simulator when a process is
 * preempted due to its timeslice expiring.
 *
 * This function should place the currently running process back in the
 * ready queue, and call schedule() to select a new runnable process.
 */
extern void preempt(unsigned int cpu_id)
{
    /* FIX ME */
    pthread_mutex_lock(&current_mutex);
    pcb_t * current_process = current[cpu_id];
    current_process->state = PROCESS_READY;
    pthread_mutex_unlock(&current_mutex);
    addToTail(current[cpu_id]);
    schedule(cpu_id);
}


/*
 * yield() is the handler called by the simulator when a process yields the
 * CPU to perform an I/O request.
 *
 * It should mark the process as WAITING, then call schedule() to select
 * a new process for the CPU.
 */
extern void yield(unsigned int cpu_id)
{
    /* FIX ME */
    pthread_mutex_lock(&current_mutex);
    pcb_t *current_process = current[cpu_id];
    current_process->state = PROCESS_WAITING;
    pthread_mutex_unlock(&current_mutex);
    schedule(cpu_id);
}


/*
 * terminate() is the handler called by the simulator when a process completes.
 * It should mark the process as terminated, then call schedule() to select
 * a new process for the CPU.
 */
extern void terminate(unsigned int cpu_id)
{
    /* FIX ME */
    pthread_mutex_lock(&current_mutex);
    pcb_t *terminate_process = current[cpu_id];
    terminate_process->state = PROCESS_TERMINATED;
    pthread_mutex_unlock(&current_mutex);
    schedule(cpu_id);
}


/*
 * wake_up() is the handler called by the simulator when a process's I/O
 * request completes.  It should perform the following tasks:
 *
 *   1. Mark the process as READY, and insert it into the ready queue.
 *
 *   2. If the scheduling algorithm is static priority, wake_up() may need
 *      to preempt the CPU with the lowest priority process to allow it to
 *      execute the process which just woke up.  However, if any CPU is
 *      currently running idle, or all of the CPUs are running processes
 *      with a higher priority than the one which just woke up, wake_up()
 *      should not preempt any CPUs.
 *	To preempt a process, use force_preempt(). Look in os-sim.h for
 * 	its prototype and the parameters it takes in.
 */
extern void wake_up(pcb_t *process)
{
    /* FIX ME */
    process->state = PROCESS_READY;
    addToTail(process);
    if (static_priority == 1) {
        int preempt_id = -1;
        int lowest_priority = 11;
        int i;
        pthread_mutex_lock(&current_mutex);
        for (i = 0; i < num_cpu; i++) {
            if (current[i] == NULL) {
                preempt_id = -1;
                break;
            }
            if (current[i]->static_priority < lowest_priority) {
                lowest_priority = current[i]->static_priority;
                preempt_id = i;
            }
        }
        pthread_mutex_unlock(&current_mutex);
        if (lowest_priority < process->static_priority && preempt_id != -1) {
            force_preempt(preempt_id);
        }
    }
}


/*
 * main() simply parses command line arguments, then calls start_simulator().
 * You will need to modify it to support the -r and -p command-line parameters.
 */
int main(int argc, char *argv[])
{
    int cpu_count;
    time_slice = -1;
    
    /* Parse command-line arguments */
    if (argc < 2 || argc > 4)
    {
        fprintf(stderr, "CS 2200 Project 4 -- Multithreaded OS Simulator\n"
                "Usage: ./os-sim <# CPUs> [ -r <time slice> | -p ]\n"
                "    Default : FIFO Scheduler\n"
                "         -r : Round-Robin Scheduler\n"
                "         -p : Static Priority Scheduler\n\n");
        return -1;
    }
    
    /* FIX ME - Add support for -r and -p parameters*/
    if (argc == 4 && strcmp(argv[2], "-r") == 0) {
        round_robin = 1;
        time_slice = atoi(argv[3]);
    }
    else if (argc == 3 && strcmp(argv[2], "-p") == 0) {
        static_priority = 1;
    }
    cpu_count = atoi(argv[1]);
    num_cpu = cpu_count;
    
    /* Init ready_mutex */
    pthread_mutex_init(&ready_mutex, NULL);
    pthread_cond_init(&ready_wait, NULL);
    head = NULL;
    queue_size = 0;
    
    /* Allocate the current[] array and its mutex */
    current = malloc(sizeof(pcb_t*) * cpu_count);
    assert(current != NULL);
    pthread_mutex_init(&current_mutex, NULL);
    
    /* Start the simulator in the library */
    start_simulator(cpu_count);
    
    return 0;
}

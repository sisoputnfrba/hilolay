#include "hilolay_internal.h"

#include <stdio.h>
#include <string.h>
#include "hilolay_alumnos.h"
#include "hilolay.h"


// TODO: Check what happens when a thrad is closed

/* Writes administrative info of a TCB */
void set_tcb(struct TCB* tcb, int id, enum State state) {
    tcb->state = state;
    tcb->id = id;
    tcb->next = NULL;
}

void init_internal(struct hilolay_operations* ops){
	/* Saves operations for later use */
	main_ops = ops;

	/* Initializes main as a thread */
	/* TODO: Abstract*/
    current_ult = &ults[0];
    current_ult->context = malloc(sizeof(ucontext_t));
    set_tcb(current_ult, MAIN_THREAD_ID, RUNNING);

    /* Call function on clients code */
    main_ops->suse_create(current_ult->id);
}

void* wrap(void *(*start_routine)(void *), void *arg, int tid){
	void* res = start_routine(arg);
	main_ops->suse_close(hilolay_get_tid());
	hilolay_yield();
	return res;
}

/* Creates the context of a new thread */
void create_context(struct TCB* new_ult, void *(*start_routine)(void *), void *arg) {
    new_ult->context = malloc(sizeof(ucontext_t));

    // Gets the current context as a reference, to be overwritten
    // TODO: Why current context? I assume this may affect context for global variables, but it's worth checking
    getcontext(new_ult->context);

    new_ult->context->uc_link = 0;
    new_ult->context->uc_stack.ss_sp = malloc(STACK_SIZE);
    new_ult->context->uc_stack.ss_size = STACK_SIZE;
    makecontext(new_ult->context, (void*) wrap, 3, start_routine, arg);
}

// TODO: Refactor
TCB* find_free_tcb(){
    struct TCB *new_ult = NULL;
    for (int i = 0; i < MAX_ULTS; i++) {
        if (ults[i].state == FREE) {
        	new_ult = &ults[i];
            break;
        }
    }

	return new_ult;
}

// TODO: Make referentially transparent
int get_next_id(){
	return NEXT_ID++;
}

/* Starts an ult */ //TODO: Set ERRNO
int hilolay_create(hilolay_t *thread, const hilolay_attr_t *attr, void *(*start_routine)(void *), void *arg){
    /* Finds a free TCB */
	struct TCB *new_ult = find_free_tcb();
    if (new_ult == NULL) { return ERROR_TOO_MANY_ULTS; }

    /* Creates the TCB */
    int tid = get_next_id();
    create_context(new_ult, start_routine, arg);
    set_tcb(new_ult, tid, READY);
    thread->tid = tid;

    /* Calls selected operation */
    main_ops->suse_create(tid);

    return 0;
}

TCB* get_next_tid(){ // TODO: Error cases
	int tid = main_ops->suse_schedule_next();
	for (int i = 0; i < MAX_ULTS; i++){
		if (ults[i].id == tid){
			return &(ults[i]);
		}
	}

	return NULL;
}

int swap_context(TCB *selected_ult){
	ucontext_t 	*old = current_ult->context,
				*new = selected_ult->context;

	current_ult->state = READY;
	selected_ult->state = RUNNING;

	current_ult = selected_ult;

	return swapcontext(old, new);
}

int hilolay_yield(void){
	return swap_context(get_next_tid());
}

/* Returns the running thread id */
int hilolay_get_tid(void) {
    return current_ult->id;
}

int hilolay_join(hilolay_t *thread){
	main_ops->suse_join(thread->tid);
	return hilolay_yield();
}

hilolay_sem_t* hilolay_sem_open(char *name){
    hilolay_sem_t* sem = malloc(sizeof(hilolay_sem_t));
    sem->name = malloc(strlen(name));
    stpcpy(sem->name, name);
    return sem;
}

int hilolay_sem_close(hilolay_sem_t* sem){
    free(sem->name);
    free(sem);
    return 0;
}

int hilolay_wait(hilolay_sem_t *sem){
    main_ops->suse_wait(hilolay_get_tid(), sem->name);
	return hilolay_yield();
}

int hilolay_signal(hilolay_sem_t *sem){
    main_ops->suse_signal(hilolay_get_tid(), sem->name);
	return hilolay_yield();
}

int hilolay_return(int val){
    main_ops->suse_close(hilolay_get_tid());
    return val;
}
#ifndef hilolay_internal_h__
	#define hilolay_internal_h__

	#include <assert.h>
	#include <signal.h>
	#include <stdbool.h>
	#include <stdint.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <time.h>

	#include <ucontext.h>

	#include <unistd.h>

	/* Error code sent when you cannot create more ULTs */
	#define ERROR_TOO_MANY_ULTS -1

	/* The "main thread" ID */
	#define MAIN_THREAD_ID 0

	/* ID for a new ULT */
	static int NEXT_ID = 1;

	/* Config options */
	enum {
		MAX_ULTS = 5000,
		STACK_SIZE = 0x400000,
	};

	/* The possible states of a ULT */
	enum State {
		FREE, // Free ULT - These TCB's are created at the beginning of the execution and assigned on demand
		RUNNING, // Running ULT
		READY, // Ready ULT
	};

	/* The TCB structure */
	typedef struct TCB {
		int id;
		ucontext_t* context;
		enum State state;
		struct TCB *next;
	} TCB;

	/* TCBs container */
	struct TCB ults[MAX_ULTS];

	/* Running thread */
	struct TCB *current_ult;

	/* First element of the ready queue */
	static struct TCB *READY_QUEUE_HEAD = NULL;

	/* Last element of the ready queue */
	static struct TCB *READY_QUEUE_TAIL = NULL;

#endif // hilolay_internal_h__

#ifndef hilolay_h__
	#define hilolay_h__

	/* Interface for programs, this is what the programs should use and is implemented in hilolay_internal */

	/**
	 * Initializes the library. Implemented in the client interface.
	 *
	 * Must call hilolay.c#_init function
	 */
	void hilolay_init(void);

	/**
	 * TODO
	 */
	int hilolay_create(void (*f)(void));

	/**
	 * TODO
	 */
	int hilolay_get_tid(void);
#endif // hilolay_h__

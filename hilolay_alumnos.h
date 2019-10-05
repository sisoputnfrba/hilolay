#ifndef hilolay_alumnos_h__
	#define hilolay_alumnos_h__

	/**
	 * TODO: Interface for alumnos (what they should implement in orde to make this work)
	 */
	struct hilolay_operations {
		int (*create_thread) (void (*)(void));
	};

	void init_internal(struct hilolay_operations*);

#endif // hilolay_alumnos_h__

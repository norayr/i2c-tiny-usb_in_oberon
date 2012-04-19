MODULE pthreadtypes [ INTERFACE "C" ];

IMPORT SYSTEM;
CONST
  _BITS_PTHREADTYPES_H* = 1;
  __SIZEOF_PTHREAD_ATTR_T* = 36;
  __SIZEOF_PTHREAD_MUTEX_T* = 24;
  __SIZEOF_PTHREAD_MUTEXATTR_T* = 4;
  __SIZEOF_PTHREAD_COND_T* = 48;
  __SIZEOF_PTHREAD_CONDATTR_T* = 4;
  __SIZEOF_PTHREAD_RWLOCK_T* = 32;
  __SIZEOF_PTHREAD_RWLOCKATTR_T* = 8;
  __SIZEOF_PTHREAD_BARRIER_T* = 20;
  __SIZEOF_PTHREAD_BARRIERATTR_T* = 4;
TYPE
  __pthread_internal_slist_tag* = RECORD 
    __next* : POINTER TO __pthread_internal_slist_tag;
  END;
  __pthread_slist_t* = __pthread_internal_slist_tag;
  __pthread_mutex_s_tag* = RECORD 
    __lock* : LONGINT;
    __count* : LONGINT;
    __owner* : LONGINT;
    __kind* : LONGINT;
    __nusers* : LONGINT;
    nameless0* : RECORD [UNION] 
      __spins* : LONGINT;
      __list* : __pthread_slist_t;
    END;
  END;
  pthread_t* = LONGINT;
  pthread_attr_t* = RECORD [UNION] 
    __size* : ARRAY 36 OF CHAR;
    __align* : LONGINT;
  END;
  pthread_mutex_t* = RECORD [UNION] 
    __data* : __pthread_mutex_s_tag;
    __size* : ARRAY 24 OF CHAR;
    __align* : LONGINT;
  END;
  pthread_mutexattr_t* = RECORD [UNION] 
    __size* : ARRAY 4 OF CHAR;
    __align* : LONGINT;
  END;
  pthread_cond_t* = RECORD [UNION] 
    __data* : RECORD 
      __lock* : LONGINT;
      __futex* : LONGINT;
      __total_seq* : HUGEINT;
      __wakeup_seq* : HUGEINT;
      __woken_seq* : HUGEINT;
      __mutex* : SYSTEM.PTR;
      __nwaiters* : LONGINT;
      __broadcast_seq* : LONGINT;
    END;
    __size* : ARRAY 48 OF CHAR;
    __align* : HUGEINT;
  END;
  pthread_condattr_t* = RECORD [UNION] 
    __size* : ARRAY 4 OF CHAR;
    __align* : LONGINT;
  END;
  pthread_key_t* = LONGINT;
  pthread_once_t* = LONGINT;
  pthread_rwlock_t* = RECORD [UNION] 
    __data* : RECORD 
      __lock* : LONGINT;
      __nr_readers* : LONGINT;
      __readers_wakeup* : LONGINT;
      __writer_wakeup* : LONGINT;
      __nr_readers_queued* : LONGINT;
      __nr_writers_queued* : LONGINT;
      __flags* : CHAR;
      __shared* : CHAR;
      __pad1* : CHAR;
      __pad2* : CHAR;
      __writer* : LONGINT;
    END;
    __size* : ARRAY 32 OF CHAR;
    __align* : LONGINT;
  END;
  pthread_rwlockattr_t* = RECORD [UNION] 
    __size* : ARRAY 8 OF CHAR;
    __align* : LONGINT;
  END;
  pthread_spinlock_t* = LONGINT;
  pthread_barrier_t* = RECORD [UNION] 
    __size* : ARRAY 20 OF CHAR;
    __align* : LONGINT;
  END;
  pthread_barrierattr_t* = RECORD [UNION] 
    __size* : ARRAY 4 OF CHAR;
    __align* : LONGINT;
  END;
END pthreadtypes.

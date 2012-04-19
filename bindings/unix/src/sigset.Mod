MODULE sigset [ INTERFACE "C" ];

IMPORT SYSTEM;
CONST
  _SIGSET_H_types* = 1;
  _SIGSET_NWORDS* = 32;
TYPE
  __sig_atomic_t* = LONGINT;
  __sigset_t* = RECORD 
    __val* : ARRAY 32 OF LONGINT;
  END;
END sigset.

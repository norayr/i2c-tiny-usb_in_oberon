MODULE time [ INTERFACE "C" ];

IMPORT SYSTEM, types;
CONST
  __clock_t_defined* = 1;
  __time_t_defined* = 1;
  __clockid_t_defined* = 1;
  __timer_t_defined* = 1;
  __timespec_defined* = 1;
  _STRUCT_TIMEVAL* = 1;
TYPE
  timespec_tag* = RECORD 
    tv_sec* : types.__time_t;
    tv_nsec* : LONGINT;
  END;
  timeval_tag* = RECORD 
    tv_sec* : types.__time_t;
    tv_usec* : types.__suseconds_t;
  END;
  clock_t* = types.__clock_t;
  time_t* = types.__time_t;
  clockid_t* = types.__clockid_t;
  timer_t* = types.__timer_t;
END time.

MODULE select [ INTERFACE "C" ];

IMPORT SYSTEM, sigset, types, time;
CONST
  _SYS_SELECT_H* = 1;
  __NFDBITS* = 32;
  FD_SETSIZE* = 1024;
  NFDBITS* = 32;
TYPE
  Ptr__sigset_t* = POINTER TO sigset.__sigset_t;
  Ptrtimespec_tag* = POINTER TO time.timespec_tag;
  Ptrtimeval_tag* = POINTER TO time.timeval_tag;
  Ptrfd_set* = POINTER TO fd_set;
  sigset_t* = sigset.__sigset_t;
  suseconds_t* = types.__suseconds_t;
  __fd_mask* = LONGINT;
  fd_set* = RECORD 
    __fds_bits* : ARRAY 32 OF __fd_mask;
  END;
  fd_mask* = __fd_mask;
  PROCEDURE select* (__nfds : LONGINT; __readfds : Ptrfd_set; __writefds : Ptrfd_set; __exceptfds : Ptrfd_set; __timeout : Ptrtimeval_tag) : LONGINT;
  PROCEDURE pselect* (__nfds : LONGINT; __readfds : Ptrfd_set; __writefds : Ptrfd_set; __exceptfds : Ptrfd_set; __timeout : Ptrtimespec_tag; __sigmask : Ptr__sigset_t) : LONGINT;
END select.

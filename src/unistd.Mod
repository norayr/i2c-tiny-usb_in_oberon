MODULE unistd [ INTERFACE "C" ];

IMPORT SYSTEM, types;
CONST
  _UNISTD_H* = 1;
  _POSIX_VERSION* = 200809;
  __POSIX2_THIS_VERSION* = 200809;
  _POSIX2_VERSION* = 200809;
  _POSIX2_C_BIND* = 200809;
  _POSIX2_C_DEV* = 200809;
  _POSIX2_SW_DEV* = 200809;
  _POSIX2_LOCALEDEF* = 200809;
  _XOPEN_VERSION* = 700;
  _XOPEN_XCU_VERSION* = 4;
  _XOPEN_XPG2* = 1;
  _XOPEN_XPG3* = 1;
  _XOPEN_XPG4* = 1;
  _XOPEN_UNIX* = 1;
  _XOPEN_CRYPT* = 1;
  _XOPEN_ENH_I18N* = 1;
  _XOPEN_LEGACY* = 1;
  STDIN_FILENO* = 0;
  STDOUT_FILENO* = 1;
  STDERR_FILENO* = 2;
  R_OK* = 4;
  W_OK* = 2;
  X_OK* = 1;
  F_OK* = 0;
  L_SET* = 0;
  L_INCR* = 1;
  L_XTND* = 2;
  F_ULOCK* = 0;
  F_LOCK* = 1;
  F_TLOCK* = 2;
  F_TEST* = 3;
TYPE
  Ptr2* = POINTER TO ARRAY OF INTEGER;
  Array1* = ARRAY OF POINTER TO ARRAY OF CHAR;
  Array20* = ARRAY 2 OF LONGINT;
  ssize_t* = types.__ssize_t;
  gid_t* = types.__gid_t;
  uid_t* = types.__uid_t;
  off_t* = types.__off_t;
  useconds_t* = types.__useconds_t;
  pid_t* = types.__pid_t;
  intptr_t* = types.__intptr_t;
  socklen_t* = types.__socklen_t;
VAR
  __environ* : POINTER TO ARRAY OF POINTER TO ARRAY OF CHAR;
  PROCEDURE access* (__name : types.String; __type : LONGINT) : LONGINT;
  PROCEDURE faccessat* (__fd : LONGINT; __file : types.String; __type : LONGINT; __flag : LONGINT) : LONGINT;
  PROCEDURE lseek* (__fd : LONGINT; __offset : types.__off_t; __whence : LONGINT) : types.__off_t;
  PROCEDURE close* (__fd : LONGINT) : LONGINT;
  PROCEDURE read* (__fd : LONGINT; __buf : types.Ptr; __nbytes : types.size_t) : ssize_t;
  PROCEDURE write* (__fd : LONGINT; __buf : types.Ptr; __n : types.size_t) : ssize_t;
  PROCEDURE pread* (__fd : LONGINT; __buf : types.Ptr; __nbytes : types.size_t; __offset : types.__off_t) : ssize_t;
  PROCEDURE pwrite* (__fd : LONGINT; __buf : types.Ptr; __n : types.size_t; __offset : types.__off_t) : ssize_t;
  PROCEDURE pipe* (__pipedes : Array20) : LONGINT;
  PROCEDURE alarm* (__seconds : LONGINT) : LONGINT;
  PROCEDURE sleep* (__seconds : LONGINT) : LONGINT;
  PROCEDURE ualarm* (__value : types.__useconds_t; __interval : types.__useconds_t) : types.__useconds_t;
  PROCEDURE usleep* (__useconds : types.__useconds_t) : LONGINT;
  PROCEDURE pause* () : LONGINT;
  PROCEDURE chown* (__file : types.String; __owner : types.__uid_t; __group : types.__gid_t) : LONGINT;
  PROCEDURE fchown* (__fd : LONGINT; __owner : types.__uid_t; __group : types.__gid_t) : LONGINT;
  PROCEDURE lchown* (__file : types.String; __owner : types.__uid_t; __group : types.__gid_t) : LONGINT;
  PROCEDURE fchownat* (__fd : LONGINT; __file : types.String; __owner : types.__uid_t; __group : types.__gid_t; __flag : LONGINT) : LONGINT;
  PROCEDURE chdir* (__path : types.String) : LONGINT;
  PROCEDURE fchdir* (__fd : LONGINT) : LONGINT;
  PROCEDURE getcwd* (__buf : types.String; __size : types.size_t) : types.String;
  PROCEDURE getwd* (__buf : types.String) : types.String;
  PROCEDURE dup* (__fd : LONGINT) : LONGINT;
  PROCEDURE dup2* (__fd : LONGINT; __fd2 : LONGINT) : LONGINT;
  PROCEDURE execve* (__path : types.String; __argv : Array1; __envp : Array1) : LONGINT;
  PROCEDURE fexecve* (__fd : LONGINT; __argv : Array1; __envp : Array1) : LONGINT;
  PROCEDURE execv* (__path : types.String; __argv : Array1) : LONGINT;
  PROCEDURE execle* (__path : types.String; __arg : types.String) : LONGINT;
  PROCEDURE execl* (__path : types.String; __arg : types.String) : LONGINT;
  PROCEDURE execvp* (__file : types.String; __argv : Array1) : LONGINT;
  PROCEDURE execlp* (__file : types.String; __arg : types.String) : LONGINT;
  PROCEDURE nice* (__inc : LONGINT) : LONGINT;
  PROCEDURE _exit* (__status : LONGINT);
  PROCEDURE pathconf* (__path : types.String; __name : LONGINT) : LONGINT;
  PROCEDURE fpathconf* (__fd : LONGINT; __name : LONGINT) : LONGINT;
  PROCEDURE sysconf* (__name : LONGINT) : LONGINT;
  PROCEDURE confstr* (__name : LONGINT; __buf : types.String; __len : types.size_t) : types.size_t;
  PROCEDURE getpid* () : types.__pid_t;
  PROCEDURE getppid* () : types.__pid_t;
  PROCEDURE getpgrp* () : types.__pid_t;
  PROCEDURE __getpgid* (__pid : types.__pid_t) : types.__pid_t;
  PROCEDURE getpgid* (__pid : types.__pid_t) : types.__pid_t;
  PROCEDURE setpgid* (__pid : types.__pid_t; __pgid : types.__pid_t) : LONGINT;
  PROCEDURE setpgrp* () : LONGINT;
  PROCEDURE setsid* () : types.__pid_t;
  PROCEDURE getsid* (__pid : types.__pid_t) : types.__pid_t;
  PROCEDURE getuid* () : types.__uid_t;
  PROCEDURE geteuid* () : types.__uid_t;
  PROCEDURE getgid* () : types.__gid_t;
  PROCEDURE getegid* () : types.__gid_t;
  PROCEDURE getgroups* (__size : LONGINT; __list : ARRAY OF types.__gid_t) : LONGINT;
  PROCEDURE setuid* (__uid : types.__uid_t) : LONGINT;
  PROCEDURE setreuid* (__ruid : types.__uid_t; __euid : types.__uid_t) : LONGINT;
  PROCEDURE seteuid* (__uid : types.__uid_t) : LONGINT;
  PROCEDURE setgid* (__gid : types.__gid_t) : LONGINT;
  PROCEDURE setregid* (__rgid : types.__gid_t; __egid : types.__gid_t) : LONGINT;
  PROCEDURE setegid* (__gid : types.__gid_t) : LONGINT;
  PROCEDURE fork* () : types.__pid_t;
  PROCEDURE vfork* () : types.__pid_t;
  PROCEDURE ttyname* (__fd : LONGINT) : types.String;
  PROCEDURE ttyname_r* (__fd : LONGINT; __buf : types.String; __buflen : types.size_t) : LONGINT;
  PROCEDURE isatty* (__fd : LONGINT) : LONGINT;
  PROCEDURE ttyslot* () : LONGINT;
  PROCEDURE link* (__from : types.String; __to : types.String) : LONGINT;
  PROCEDURE linkat* (__fromfd : LONGINT; __from : types.String; __tofd : LONGINT; __to : types.String; __flags : LONGINT) : LONGINT;
  PROCEDURE symlink* (__from : types.String; __to : types.String) : LONGINT;
  PROCEDURE readlink* (__path : types.String; __buf : types.String; __len : types.size_t) : ssize_t;
  PROCEDURE symlinkat* (__from : types.String; __tofd : LONGINT; __to : types.String) : LONGINT;
  PROCEDURE readlinkat* (__fd : LONGINT; __path : types.String; __buf : types.String; __len : types.size_t) : ssize_t;
  PROCEDURE unlink* (__name : types.String) : LONGINT;
  PROCEDURE unlinkat* (__fd : LONGINT; __name : types.String; __flag : LONGINT) : LONGINT;
  PROCEDURE rmdir* (__path : types.String) : LONGINT;
  PROCEDURE tcgetpgrp* (__fd : LONGINT) : types.__pid_t;
  PROCEDURE tcsetpgrp* (__fd : LONGINT; __pgrp_id : types.__pid_t) : LONGINT;
  PROCEDURE getlogin* () : types.String;
  PROCEDURE getlogin_r* (__name : types.String; __name_len : types.size_t) : LONGINT;
  PROCEDURE setlogin* (__name : types.String) : LONGINT;
  PROCEDURE gethostname* (__name : types.String; __len : types.size_t) : LONGINT;
  PROCEDURE sethostname* (__name : types.String; __len : types.size_t) : LONGINT;
  PROCEDURE sethostid* (__id : LONGINT) : LONGINT;
  PROCEDURE getdomainname* (__name : types.String; __len : types.size_t) : LONGINT;
  PROCEDURE setdomainname* (__name : types.String; __len : types.size_t) : LONGINT;
  PROCEDURE vhangup* () : LONGINT;
  PROCEDURE revoke* (__file : types.String) : LONGINT;
  PROCEDURE profil* (__sample_buffer : Ptr2; __size : types.size_t; __offset : types.size_t; __scale : LONGINT) : LONGINT;
  PROCEDURE acct* (__name : types.String) : LONGINT;
  PROCEDURE getusershell* () : types.String;
  PROCEDURE endusershell* ();
  PROCEDURE setusershell* ();
  PROCEDURE daemon* (__nochdir : LONGINT; __noclose : LONGINT) : LONGINT;
  PROCEDURE chroot* (__path : types.String) : LONGINT;
  PROCEDURE getpass* (__prompt : types.String) : types.String;
  PROCEDURE fsync* (__fd : LONGINT) : LONGINT;
  PROCEDURE gethostid* () : LONGINT;
  PROCEDURE sync* ();
  PROCEDURE getpagesize* () : LONGINT;
  PROCEDURE getdtablesize* () : LONGINT;
  PROCEDURE truncate* (__file : types.String; __length : types.__off_t) : LONGINT;
  PROCEDURE ftruncate* (__fd : LONGINT; __length : types.__off_t) : LONGINT;
  PROCEDURE brk* (__addr : types.Ptr) : LONGINT;
  PROCEDURE sbrk* (__delta : intptr_t) : types.Ptr;
  PROCEDURE syscall* (__sysno : LONGINT) : LONGINT;
  PROCEDURE lockf* (__fd : LONGINT; __cmd : LONGINT; __len : types.__off_t) : LONGINT;
  PROCEDURE fdatasync* (__fildes : LONGINT) : LONGINT;
  PROCEDURE ctermid* (__s : types.String) : types.String;
END unistd.

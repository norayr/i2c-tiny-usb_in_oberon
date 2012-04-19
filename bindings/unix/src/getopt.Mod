MODULE getopt [ INTERFACE "C" ];

IMPORT SYSTEM;
TYPE
  Ptr1* = POINTER TO ARRAY OF CHAR;
  Ptr0* = POINTER TO ARRAY OF POINTER TO ARRAY OF CHAR;
VAR
  optarg* : POINTER TO ARRAY OF CHAR;
  optind* : LONGINT;
  opterr* : LONGINT;
  optopt* : LONGINT;
  PROCEDURE getopt* (___argc : LONGINT; ___argv : Ptr0; __shortopts : Ptr1) : LONGINT;
END getopt.

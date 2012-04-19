MODULE test;
IMPORT debug;
VAR r0, r1 : REAL;

BEGIN

r1 := 533.0;
r0 := r1 / 256;

debug.OutReal("r0 = ", r0, TRUE);

END test.

MODULE BindFixes; (* 2011 noch *)

(* this module needed when we have to map signed Oberon types to unsigned C types. for instance in libusb dev^.descriptor.idProduct is uint16_t, i. e. two byte unsigned integer, and we map it with INTEGER, i. e. two bytes signed integer, then we get an overflow. Instead of getting c631 we get ffffc631, instead of getting a101 we are getting ffffa101. Solution to this is to substract ffff0000 (2^16) from our number, where ffffc631 - ffff0000 will give us c631. ffff0000 is -65536, so by adding 65536 to our number we get the correct value *)
(* this procedure will fix integer which we've previously got by assigning unsigned char to SHORTINT *)

PROCEDURE FixAndAssignShortint*(sh : SHORTINT): INTEGER;
BEGIN
IF sh < 0 THEN (*overflow*)
   RETURN (sh + 256)
ELSE
   RETURN sh
END
END FixAndAssignShortint;

PROCEDURE FixAndAssignInteger*(i : INTEGER): LONGINT;
BEGIN
IF i < 0 THEN (*overflow*)
   RETURN (i + 65536)    (* 2^(8*SIZE(INTEGER))  or 2^16 *);
ELSE
   RETURN i
END
END FixAndAssignInteger;

PROCEDURE FixAndAssignLongint*(l : LONGINT): HUGEINT;
BEGIN
IF l < 0 THEN
   RETURN (l + 4294967296)   (* 2^(8*SIZE(LONGINT)) or 2^32 *);
ELSE
   RETURN l
END
END FixAndAssignLongint;


PROCEDURE FixShortint*(VAR sh : INTEGER);
BEGIN
IF sh < 0 THEN 
   sh := sh + 256(*2^(8*SIZE(SHORTINT))*)(*2^8*);
END
END FixShortint;
(* we have to get fixed value into a variable with bigger size in order to fit*)
PROCEDURE FixInteger*(VAR i : LONGINT);
BEGIN
IF i < 0 THEN 
   i := i + (*2^(8*SIZE(INTEGER))*)65536(*2^16*);
END
END FixInteger;

PROCEDURE FixLongint*(VAR l : HUGEINT);
BEGIN
IF l < 0 THEN
   l := l + (*2^(8*SIZE(LONGINT))*)4294967296 (*2^32*);
END
END FixLongint;

END BindFixes.

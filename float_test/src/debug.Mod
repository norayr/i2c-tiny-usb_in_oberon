MODULE debug; (* 2011 noch *)

IMPORT Out, RealStr;

PROCEDURE OutReal*(s : ARRAY OF CHAR; r: REAL; eol : BOOLEAN);
VAR str0 : ARRAY 32 OF CHAR;
BEGIN
   str0 := "";
   Out.String(s);
   RealStr.RealToFixed(r, 5, str0);
   Out.String (str0); 
   IF eol THEN Out.Ln END
END OutReal;

PROCEDURE OutInteger*(s : ARRAY OF CHAR; i : INTEGER; eol : BOOLEAN);
BEGIN
   Out.String(s); Out.Int(i, 0); 
   IF eol THEN Out.Ln END
END OutInteger;

PROCEDURE OutLongint*(s : ARRAY OF CHAR; l : LONGINT; eol : BOOLEAN);
BEGIN
   Out.String(s); Out.LongInt(l, 0); 
   IF eol THEN Out.Ln END
END OutLongint;

PROCEDURE Comment*( s : ARRAY OF CHAR; eol : BOOLEAN);
BEGIN
Out.String(s); 
IF eol THEN Out.Ln END
END Comment;
END debug.

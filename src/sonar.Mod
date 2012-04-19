MODULE sonar; (* 2011 noch *)
IMPORT i2c := i2c_tiny_usb, usb, unistd, Out;

CONST    SONAR_ADDR*    = 42;
sleep_time = 10000;

PROCEDURE access_sonar(VAR h : i2c.handle): BOOLEAN;
VAR i : LONGINT;
BEGIN
i := usb.usb_control_msg(h, i2c.USB_CTRL_IN, i2c.CMD_I2C_IO + i2c.CMD_I2C_BEGIN + i2c.CMD_I2C_END, 0, SONAR_ADDR, NIL, 0, 1000);
IF i < 0 THEN
   Out.String ("usb_control_msg failed");
   i2c.usb_error;
   i2c.close(h);
   HALT(1)
END;
i := i2c.i2c_tiny_usb_get_status(h);
IF i = i2c.STATUS_ADDRESS_ACK THEN
   Out.String ("ack received"); Out.Ln;
   i := unistd.usleep(sleep_time);
   RETURN TRUE
ELSE
   i2c.close(h);
   RETURN FALSE
END;
END access_sonar;

PROCEDURE ReadByte*(VAR h : i2c.handle) : SHORTINT;
VAR ans : SHORTINT; 
character: usb.AutoPtr0;
chs : POINTER TO ARRAY OF CHAR;
ch : CHAR;
i : LONGINT;
addr : LONGINT;
r : SHORTINT;
b : BOOLEAN;
BEGIN
NEW(chs, 2);
b := access_sonar(h);
addr := SONAR_ADDR;
IF b THEN
(*  i := i2c.i2c_tiny_usb_read(h, CHR(addr), character, 1);*)
(*  chs[0] := character[0];
  Out.ShortInt( SHORT ( ORD ( chs[0] ) ), 3 ); Out.Ln;
  RETURN (SHORT(ORD(chs[0])));
  Out.LongInt(i, 0); Out.Ln;
  r := SHORT(SHORT(i));
  Out.ShortInt(r, 0); Out.Ln;
  RETURN r;
  *)
  ch := "h";
  i := i2c.i2c_read_byte(h, CHR(SONAR_ADDR), ch);
  Out.Char(ch);
  Out.Ln;
  Out.LongInt(i, 0); Out.Ln;
  RETURN SHORT(ORD(ch));
ELSE
  RETURN -1
END
END ReadByte;


PROCEDURE WriteByte*(VAR h : i2c.handle) : SHORTINT;
VAR b : BOOLEAN;
i : LONGINT;
BEGIN
b := access_sonar(h);
b := TRUE;

IF b THEN
   i := i2c.i2c_write_byte(h, CHR(SONAR_ADDR), CHR(068H));
   IF i = -1 THEN
      Out.String ("Failed to write byte"); Out.Ln; RETURN -1;
   ELSE
      Out.String ("Written."); Out.Ln; RETURN 0;
   END;
ELSE
   Out.String("Cannot access sonar"); Out.Ln;
   RETURN -1
END
END WriteByte;

PROCEDURE Command*(VAR h : i2c.handle) : SHORTINT;
VAR i : LONGINT;
ch : CHAR;
b : BOOLEAN;
BEGIN
ch := "h";
b := access_sonar(h);
i := unistd.usleep(10000);
IF b THEN
   i := i2c.i2c_read_with_cmd(h, CHR(SONAR_ADDR), ch, 1);
   Out.Char(ch); Out.Ln;
   Out.LongInt(i, 0); Out.Ln;
   Out.Char(CHR(SHORT(SHORT(i)))); Out.Ln;
   RETURN (SHORT(SHORT(i)));
ELSE
Out.String ("cannot access sonar"); Out.Ln;
END
END Command;


END sonar.

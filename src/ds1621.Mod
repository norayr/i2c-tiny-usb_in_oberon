MODULE ds1621; (* 2011 noch *)
IMPORT usb, i2c := i2c_tiny_usb, unistd, SYSTEM;
CONST DS1621_ADDR* = 048H ;
CONST sleep_time = 10000;
(*
PROCEDURE ds1621_read_control;
VAR result : LONGINT;
ch : CHAR;
BEGIN
ch := 0ACH;
REPEAT
   result := i2c_read_with_cmd(DS1621_ADDR, 0ACH, 1);
UNTIL result > 0;

END ds1621_read_control;
*)

PROCEDURE ds1621_read_control(VAR h: i2c.handle);
VAR result : LONGINT;
 ch : CHAR;
 s0, s1 : SET;
 l0 : LONGINT;
BEGIN
   ch := CHR(0ACH);
   l0 := 080H;
   s0 := SYSTEM.VAL(SET, l0);

   REPEAT
      result := i2c.i2c_read_with_cmd(h, CHR(DS1621_ADDR), CHR(0ACH), 1);
      s1 := SYSTEM.VAL(SET, result);
      s1 := s0 * s1;
   UNTIL SYSTEM.VAL(LONGINT, s1) > 0;
END ds1621_read_control;

PROCEDURE read_temperature(VAR h : i2c.handle): REAL;
VAR i, counter, slope : LONGINT;
temp0, temp1, temp2 : REAL;
s0, s1, s2 : SET;
l0 : LONGINT;
r0, r1 : REAL;
BEGIN
i := i2c.i2c_read_with_cmd(h, CHR(DS1621_ADDR), CHR(0EEH), 0);
IF i < 0 THEN RETURN -1 END;
ds1621_read_control(h);
temp0 := i2c.i2c_read_with_cmd(h, CHR(DS1621_ADDR), CHR(0AAH), 2);
IF temp0 < 0 THEN RETURN 0 END;
          (*debug.OutReal("temp0=", temp0);*)
 (* read counter and slope values *)

 counter := i2c.i2c_read_with_cmd(h, CHR(DS1621_ADDR), CHR(0A8H), 1);
 slope   := i2c.i2c_read_with_cmd(h, CHR(DS1621_ADDR), CHR(0A9H), 1);
           (*debug.OutLongint("counter=", counter);
           debug.OutLongint("slope=", slope);*)
(*
 temp1 := temp0 - 0.25 + ((slope - counter)/slope);
           debug.OutReal("temp1=", temp1);*)
 (* use counter and slope to adjust temperature (see ds1621 datasheet) *)
 s0 := SYSTEM.VAL(SET, temp0);
              (* Out.Set(s0); Out.Ln;*)
 l0 := -256(*1111111100000000*)(*0FF00H*);
 s1 := SYSTEM.VAL(SET, l0);
              (* Out.Set(s1); Out.Ln;*)
 s2 := s0 * s1;
 r0 := SYSTEM.VAL(REAL, s2);
 temp1:= r0 - 256/4;
               (*debug.OutReal("temp1=", temp1);*)

 temp2 := temp1 + (256 * (slope - counter) / slope);
               (*debug.OutReal("temp2=", temp2);*)
 (* displaying result *)
 r1 := temp2 / 256;
               (*debug.OutReal("temp2/256 ",r1);Out.Ln;*)
 (*Out.LongInt(ENTIER(r1), 0); Out.Char(".");
 Out.String (" °C"); Out.Ln;*)
 RETURN r1; (* temperature *)
END read_temperature;

PROCEDURE access_ds1621(VAR h : i2c.handle): REAL;
VAR i : LONGINT;
r : REAL;
BEGIN
   i := usb.usb_control_msg(h, i2c.USB_CTRL_IN, i2c.CMD_I2C_IO + i2c.CMD_I2C_BEGIN + i2c.CMD_I2C_END, 0, DS1621_ADDR, NIL, 0, 1000);
   IF i < 0 THEN
      i2c.usb_error;
      i2c.close(h);
      HALT(1);
   END;
   i := i2c.i2c_tiny_usb_get_status(h);
   IF i = i2c.STATUS_ADDRESS_ACK THEN
      (*Out.String ("ack received"); Out.Ln;*)
      (* activate one shot mode *)
      i := i2c.i2c_write_cmd_and_byte(h, CHR(DS1621_ADDR), 0ACX, 01X);
      IF i < 0 THEN i2c.close(h) END;
      i := unistd.usleep(sleep_time);
      r := read_temperature(h);
      RETURN r;
   ELSE
      (*Out.String ("ds1621 - not found"); Out.Ln;*)
      RETURN -1.0;
   END;
END access_ds1621;


PROCEDURE get_temp*(VAR h : i2c.handle): REAL;
BEGIN
RETURN access_ds1621(h);

END get_temp;


END ds1621.

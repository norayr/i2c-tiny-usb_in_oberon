MODULE test0; (* 2011 noch *)

IMPORT i2c := i2c_tiny_usb, unistd, ds1621, hmc6352, sonar,
debug, Out;

CONST
  I2C_TINY_USB_VID* = 00403H;
  I2C_TINY_USB_PID* = 0C631H;

PROCEDURE main;
VAR  h : i2c.handle;
i : LONGINT;
ret : LONGINT;
temperature, angle : REAL;
BEGIN
h := i2c.open(I2C_TINY_USB_PID, I2C_TINY_USB_VID);
(* do some testing *) 
ret := i2c.i2c_tiny_usb_get_func(h);
Out.String ("Functionality = "); Out.Hex(ret, 12); Out.Ln;

(* try to set i2c clock to 100kHz (10us), will actually result in ~50kHz
   since the software generated i2c clock isn't too exact. in fact setting
   it to 10us doesn't do anything at all since this already is the default *)
   Out.String (" try to set i2c clock to 100khz "); Out.Ln;
   i2c.i2c_tiny_usb_set(h, CHR(i2c.CMD_SET_DELAY), 10);

   (* try to access ds1621 at address DS1621_ADDR *)
   Out.String ("accessing ds1621"); Out.Ln;
   temperature := ds1621.get_temp(h);
   debug.OutReal ("temperature is ", temperature, FALSE); Out.String (" °C"); Out.Ln; 

   Out.String ("accessing hmc6352"); Out.Ln;
   angle := hmc6352.Angle(h);

   debug.OutReal ("angle is ", angle, FALSE);


   Out.String ("accessing sonar"); Out.Ln;
(*    
   i := sonar.WriteByte(h);
   
   
   i := sonar.ReadByte(h);
  *)
 (*  
   i := sonar.Command(h);
   *)
i2c.close(h)
END main;

BEGIN
main;

END test0.

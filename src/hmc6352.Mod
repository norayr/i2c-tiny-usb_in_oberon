MODULE hmc6352; (* 2011 noch *)
IMPORT i2c := i2c_tiny_usb, usb, unistd, Out;

CONST    HMC6352_ADDR*    = 021H;
CONST HMC6352_READ_ADDR*  = 043H;
CONST HMC6352_WRITE_ADDR* = 042H;
sleep_time = 10000;

PROCEDURE access_hmc6352(VAR h : i2c.handle): BOOLEAN;
VAR i : LONGINT;
BEGIN
i := usb.usb_control_msg(h, i2c.USB_CTRL_IN, i2c.CMD_I2C_IO + i2c.CMD_I2C_BEGIN + i2c.CMD_I2C_END, 0, HMC6352_ADDR, NIL, 0, 1000);
IF i < 0 THEN i2c.usb_error; i2c.close(h) END;
i := i2c.i2c_tiny_usb_get_status(h);
IF i = i2c.STATUS_ADDRESS_ACK THEN
   Out.String ("ack received"); Out.Ln;
   i := unistd.usleep(sleep_time);
   RETURN TRUE
ELSE
   i2c.close(h);
   RETURN FALSE
END;
END access_hmc6352;

PROCEDURE Angle*(VAR h : i2c.handle) : REAL;
VAR ang : REAL; cmd : CHAR;
i : LONGINT;
r : REAL;
addr : LONGINT;
b : BOOLEAN;
BEGIN
b := access_hmc6352(h);
cmd := CHR(041H);
addr := HMC6352_ADDR;
IF b THEN
  ang := i2c.i2c_read_with_cmd(h, CHR(addr), cmd, 2);
  RETURN (ang/10)
ELSE
  RETURN -1.0
END
END Angle;

END hmc6352.

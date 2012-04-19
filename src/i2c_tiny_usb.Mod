MODULE i2c_tiny_usb; (* 2011 noch *)

IMPORT usb, unistd,
Out, SYSTEM, BindFixes;

TYPE handle* = usb.AutoPtrusb_dev_handle;
charpair = ARRAY 2 OF CHAR;
CONST 
(*
USB_CTRL_IN=160;
USB_CTRL_OUT=32;
*)
(* the same in hexadecimal *)
USB_CTRL_IN* = 0A0H;
USB_CTRL_OUT* = 020H;

CMD_ECHO*=0;
CMD_GET_FUNC*=1;
CMD_SET_DELAY*=2;
CMD_GET_STATUS*=3;
CMD_I2C_IO*=4;
CMD_I2C_BEGIN*=1; (* flag to I2C_IO *)
CMD_I2C_END*=2;   (* flag to I2C_IO *)

I2C_M_RD* = 001H;

STATUS_IDLE*=0;
STATUS_ADDRESS_ACK*=1;
STATUS_ADDRESS_NAK*=2;

PROCEDURE usb_error*;
VAR j : usb.AutoPtr0;
s : POINTER TO ARRAY OF CHAR;
l, i : LONGINT;
BEGIN
 j := usb.usb_strerror();
 (* find length of the j^ *)
 l := -1;
 REPEAT
    INC(l);
 UNTIL j^[l] = CHR(0);
 NEW(s, l+1);
 FOR i := 0 TO l - 1 (*2*) DO
    s[i] := j^[i];
 END;
 (*s[l-1] := 0X;*)
   Out.String ("USB error: "); 
   Out.String(s^);
   Out.Ln;
END usb_error;

(* write a set of bytes to the i2c_tiny_usb device *)
PROCEDURE i2c_tiny_usb_write*(VAR h :  handle; request, value, index: LONGINT) : LONGINT;
  VAR i : LONGINT;
BEGIN
i := usb.usb_control_msg(h, USB_CTRL_OUT, request, value, index, NIL, 0, 1000);
  IF i < 0 THEN
     usb_error;
     RETURN -1
  END;
  RETURN 1
END i2c_tiny_usb_write;

(* read a set of bytes from the i2c_tiny_usb device *)
PROCEDURE i2c_tiny_usb_read*(VAR h : handle; cmd : CHAR; data : usb.AutoPtr0; len : LONGINT): LONGINT;
VAR nBytes : LONGINT;
command : LONGINT;
BEGIN
  (* send control request and accept return value *)
  command := ORD(cmd);
  nBytes := usb.usb_control_msg(h, USB_CTRL_IN, command, 0, 0, data, len, 1000);
  IF nBytes < 0 THEN
     usb_error;
     RETURN nBytes;
  END;
  RETURN 0
END i2c_tiny_usb_read;

(* get i2c usb interface firmware version *)
PROCEDURE i2c_tiny_usb_get_func*(VAR h : handle): LONGINT;
VAR 
func : LONGINT;
i : LONGINT;
BEGIN
func := 0;
i := i2c_tiny_usb_read(h, CHR(CMD_GET_FUNC), SYSTEM.VAL(usb.AutoPtr0, SYSTEM.ADR(func)),  SIZE(LONGINT));
IF i = 0 THEN
   RETURN func;
   (*Out.String ("Functionality = "); 
   (*func := func - 4294967296;*)
   Out.Hex(func, 12);
   Out.Ln*)
ELSE
   Out.String ("Unable to read functionality "); Out.Ln;
   RETURN -1;
END;
END i2c_tiny_usb_get_func;

(* set a value in the I2C_USB interface *)
PROCEDURE i2c_tiny_usb_set*(VAR h : handle; cmd : CHAR; value : LONGINT);
VAR i : LONGINT;
BEGIN
 i := usb.usb_control_msg(h, usb.USB_TYPE_VENDOR, LONG(ORD(cmd)), value, 0, NIL, 0, 1000);
 IF i < 0 THEN
    usb_error;
 END;
END i2c_tiny_usb_set;

(* get the current transaction status from the i2c_tiny_usb interface *)
PROCEDURE i2c_tiny_usb_get_status* (VAR h : handle) : LONGINT;
VAR i : LONGINT;
status : CHAR;
BEGIN
status := 0X;
i := i2c_tiny_usb_read(h, CHR(CMD_GET_STATUS), SYSTEM.VAL(usb.AutoPtr0, SYSTEM.ADR(status)), SIZE(CHAR));
IF i < 0 THEN
   Out.String ("Error reading status"); Out.Ln;
   RETURN i;
END;

RETURN (LONG(ORD(status)));
END i2c_tiny_usb_get_status;

(* write command and read an 8 or 16 bit value from the given chip *)
PROCEDURE i2c_read_with_cmd* (VAR h : handle; addr : CHAR; cmd : CHAR; length : LONGINT) : LONGINT;
VAR result : charpair(*ARRAY 2 OF CHAR*);
tmpvar, i : LONGINT;
BEGIN
result := "";
IF (length > 2 (*size of result*)) THEN
   Out.String ("Request exceeds buffer size "); Out.Ln;
   RETURN -1;
END;

(* write one byte register address to chip *)
IF length > 0 THEN
   tmpvar := 0
ELSIF length = 0 THEN
   tmpvar := CMD_I2C_END
ELSE
   Out.String ("Negative length?"); Out.Ln;
   RETURN -1;
END;
Out.String ("00"); Out.Ln;
i := usb.usb_control_msg(h, USB_CTRL_OUT, CMD_I2C_IO + CMD_I2C_BEGIN + tmpvar, 0, SYSTEM.VAL(LONGINT, LONG(ORD(addr))), SYSTEM.VAL(usb.AutoPtr0, SYSTEM.ADR(cmd)), SIZE(CHAR)(*1*), 1000);
IF i < 1 THEN
   usb_error;
   RETURN -1
END;
Out.String ("01"); Out.Ln;
i := i2c_tiny_usb_get_status(h);
Out.String ("02"); Out.Ln;
Out.String ("i = "); Out.LongInt(i, 0); Out.Ln;
IF i # STATUS_ADDRESS_ACK THEN
   Out.String ("Write command status failed!"); Out.Ln;
   RETURN -1;
END;
Out.String("03"); Out.Ln;
(* just a test? return ok *)
(* commented, because it's not possible
IF length = 0 THEN RETURN 0 END;
*)

i := unistd.usleep(10000);


i := usb.usb_control_msg(h, USB_CTRL_IN, CMD_I2C_IO + CMD_I2C_END, I2C_M_RD, LONG(ORD(addr)), SYSTEM.VAL(usb.AutoPtr0, SYSTEM.ADR(result)), SIZE(charpair)(*length*), 1000);

Out.String("04"); Out.Ln;
Out.String ("i = "); Out.LongInt(i, 0); Out.Ln;

IF i < 1 THEN
   usb_error;
   RETURN -1
END;
Out.String("05"); Out.Ln;
i := i2c_tiny_usb_get_status(h);
Out.String ("i = "); Out.LongInt(i, 0); Out.Ln;

IF i # STATUS_ADDRESS_ACK THEN
   Out.String ("read data status failed"); Out.Ln;
   RETURN -1;
END;
Out.String ("06"); Out.Ln;
IF length = 2 THEN
   RETURN 256*ORD(result[0]) + ORD(result[1])
END;
Out.String ("07"); Out.Ln;
RETURN ORD(result[0])

END i2c_read_with_cmd;


(* write a single byte to the i2c client *)
 PROCEDURE i2c_write_byte* ( VAR h : handle; addr, data : CHAR) : LONGINT;
VAR i : LONGINT;
BEGIN
(* write one byte register address to chip *)
i := usb.usb_control_msg(h, USB_CTRL_OUT, CMD_I2C_IO + CMD_I2C_BEGIN + CMD_I2C_END, 0, LONG(ORD(addr)), SYSTEM.VAL(usb.AutoPtr0, SYSTEM.ADR(data)), SIZE(CHAR)(*1*), 1000);
IF i < 1 THEN
   usb_error;
   RETURN -1
END;

i := i2c_tiny_usb_get_status(h);
IF i # STATUS_ADDRESS_ACK THEN
   Out.String ("Write command status failed"); Out.Ln;
   RETURN -1
END;

RETURN 0

END i2c_write_byte;

(* read a single byte from the i2c client *)
(* noch *)
PROCEDURE i2c_read_byte* ( VAR h : handle; addr, data : CHAR) : LONGINT;
VAR i,j : LONGINT;
BEGIN
(* write one byte register address to chip *)
(*
i := usb.usb_control_msg(h, USB_CTRL_IN, CMD_I2C_IO + CMD_I2C_BEGIN + CMD_I2C_END, 0, LONG(ORD(addr)), SYSTEM.VAL(usb.AutoPtr0, SYSTEM.ADR(data)), SIZE(CHAR)(*1*), 1000);
*)
i := usb.usb_control_msg(h, USB_CTRL_IN,CMD_I2C_IO + CMD_I2C_END, I2C_M_RD, LONG(ORD(addr)), SYSTEM.VAL(usb.AutoPtr0, SYSTEM.ADR(data)), SIZE(CHAR)(*1*), 1000);
IF i < 1 THEN
   usb_error;
   RETURN -1
END;

j := i2c_tiny_usb_get_status(h);
IF j # STATUS_ADDRESS_ACK THEN
   Out.String ("Write command status failed"); Out.Ln;
   RETURN -1
END;

RETURN ORD(data)

END i2c_read_byte;





(* write a command byte and a single byte to the i2c client *)
 PROCEDURE i2c_write_cmd_and_byte* (VAR h : handle; addr, cmd, data : CHAR) : LONGINT; 
VAR msg : charpair(*ARRAY 2 OF CHAR*);
i : LONGINT;
BEGIN
msg[0] := cmd; msg[1] := data;
(* write one byte register address to chip *)
i := usb.usb_control_msg(h, USB_CTRL_OUT, CMD_I2C_IO + CMD_I2C_BEGIN + CMD_I2C_END, 0, LONG(ORD(addr)), SYSTEM.VAL(usb.AutoPtr0, SYSTEM.ADR(msg)), SIZE(charpair)(*2*), 1000);
IF i < 1 THEN
   usb_error;
   RETURN -1;
END;
i := i2c_tiny_usb_get_status(h);
IF i # STATUS_ADDRESS_ACK THEN
   Out.String ("Write command status failed"); Out.Ln;
   RETURN -1
END;
RETURN 0;
END i2c_write_cmd_and_byte;

(* write a command byte and a 16 bit value to the i2c client *)

PROCEDURE i2c_write_cmd_and_word* (VAR h : handle; addr, cmd : CHAR; data : LONGINT) : LONGINT;

VAR msg : ARRAY 3 OF CHAR;
tmpset, tmpset0 : SET;
i, tmpint : LONGINT;
BEGIN
msg[0] := cmd;
msg[1] := SYSTEM.VAL(CHAR, SHORT(SHORT(SYSTEM.VAL(LONGINT, (data/256)))));
tmpset := SYSTEM.VAL (SET, data);
tmpint := 0FFH;
tmpset0 := SYSTEM.VAL(SET, tmpint);
tmpset := tmpset * tmpset0;
msg[2] := CHR(SHORT(SHORT(SYSTEM.VAL(LONGINT, tmpset))));

(* write one byte register address to chip *)

i := usb.usb_control_msg(h, USB_CTRL_OUT, CMD_I2C_IO + CMD_I2C_BEGIN + CMD_I2C_END, 0, LONG(ORD(addr)), SYSTEM.VAL(usb.AutoPtr0, SYSTEM.ADR(msg)), 3 (*size of msg*), 1000);

IF i < 1 THEN
   usb_error;
   RETURN -1
END;

i := i2c_tiny_usb_get_status(h);

IF i # STATUS_ADDRESS_ACK THEN
   Out.String ("Write command status failed"); Out.Ln;
   RETURN -1
END;

RETURN 0

END i2c_write_cmd_and_word;

PROCEDURE close*(VAR h : handle);
VAR
ret : LONGINT;
BEGIN
   ret := usb.usb_release_interface(h, 0);
   IF ret > 0 THEN usb_error END;
   ret := usb.usb_close(h)
END close;

PROCEDURE open*(i2c_pid, i2c_vid : LONGINT): handle;
VAR h : handle;
bus : usb.AutoPtrusb_bus_tag;
dev : usb.AutoPtrusb_device_tag;
pid, vid : LONGINT;
i, ret : LONGINT;
i2c_found : BOOLEAN;
BEGIN
i2c_found := FALSE;
h := NIL;
usb.usb_init();
i := usb.usb_find_busses();
i := usb.usb_find_devices();

bus := usb.usb_get_busses();

WHILE ( bus # NIL) & (i2c_found = FALSE) DO
      dev := bus^.devices;
      WHILE (dev # NIL) & (i2c_found = FALSE) DO

   (* because in libusb dev^.descriptor.idProduct is uint16_t, i. e. two byte unsigned integer, and we map it with INTEGER, i. e. two bytes signed integer, thenwe get an overflow. Instead of getting c631 we get ffffc631, instead of getting a101 we are getting ffffa101. Solution to this is to substract ffff0000 (2^16) from our number, where ffffc631 - ffff0000 will give us c631. ffff0000 is -65536, so by adding 65536 to our number we get the correct value *)
(*
    Out.String ("dev^.descriptor.idVendor = "); Out.Int(dev^.descriptor.idVendor, 0); Out.Ln;
    Out.String ("dev^.descriptor.idProduct = "); Out.Int(dev^.descriptor.idProduct, 0); Out.Ln;
    *)
    pid := BindFixes.FixAndAssignInteger(dev^.descriptor.idProduct);
    vid := BindFixes.FixAndAssignInteger(dev^.descriptor.idVendor);
(*
IF dev^.descriptor.idProduct < 0 THEN pid := dev^.descriptor.idProduct + 2^(8*SIZE(INTEGER))(*65536*) ELSE pid := dev^.descriptor.idProduct END;
    (*Out.String ("dev^.descriptor.idProduct = "); Out.LongInt(l0, 0); Out.Ln;*)
    IF dev^.descriptor.idVendor < 0 THEN vid := dev^.descriptor.idVendor + 2^(8*SIZE(INTEGER))(*65536*) ELSE vid := dev^.descriptor.idVendor END;
      *)
   IF (vid = i2c_vid) &
      (pid = i2c_pid) THEN
         Out.String ("I²C-Tiny-USB device on bus ");
         Out.String (bus^.dirname);
         Out.String (" device ");
         Out.String (dev^.filename);
         Out.Ln;

         (* open device *)
         h := usb.usb_open(dev);
         IF h = NIL THEN
            Out.String ("Cannot open the device"); Out.Ln; HALT(1)
         ELSE i2c_found := TRUE; Out.String ("device opened"); Out.Ln
        END;

      END;

      IF i2c_found = FALSE THEN dev := dev^.next END;
   END;


   IF i2c_found = FALSE THEN bus := bus^.next END;
   END;

IF h = NIL THEN
   Out.String ("No i2c_tiny_usb device attached"); Out.Ln; HALT(1)
END;

(* get exclusive access to interface 0 *)
Out.String (" get exclusive access to interface 0 "); Out.Ln;
ret := usb.usb_claim_interface(h, 0);
IF ret # 0 THEN
   usb_error;
   HALT(1);
END;
   RETURN h;
END open;

END i2c_tiny_usb.

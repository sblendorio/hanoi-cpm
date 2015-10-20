{----------------------------------------------------------------------------}
{   Programmname    :   GRAPH128.INC                                         }
{   Version         :   1.00                                                 }
{   Aufgabe         :   Include-File zur Unterstuetzung der 640*200 Grafik   }
{   Sprache         :   Turbo Pascal 3.00A                                   }
{   Computer        :   Commodore 128(D) mit RGBI-Monitor                    }
{   Betriebssystem  :   CP/M 3.0                                             }
{   Autor           :   Ralph Schlichtmeier                                  }
{   Copyright       :   Markt & Technik Verlag AG                            }
{----------------------------------------------------------------------------}

TYPE filename  = STRING [14];
     str80     = STRING [80];
     color     = (black, dk_grey, blue, lt_blue, green, lt_green, grey, cyan,
                  red, orange, violet, pink, brown, yellow, lt_grey, white);
     chardef   = ARRAY [32 .. 127, 0 .. 7] OF BYTE;
     switch    = (on, off, slow, fast, no);

VAR  charset1, charset2 : chardef;

{----------------------------------------------------------------------------}

PROCEDURE VDCregWr (reg, wert: BYTE);
  BEGIN
    INLINE ($01/$00/$D6/     {         LD   BC,00D6h  }
            $3A/reg/         {         LD   A,(reg)   }
            $ED/$79/         {         OUT  (C),A     }
            $ED/$78/         { status: IN   A,(C)     }
            $17/             {         RLA            }
            $D2/*-5/         {         JR   NC,status }
            $0C/             {         INC  C         }
            $3A/wert/        {         LD   A,(wert)  }
            $ED/$79)         {         OUT  (C),A     }
  END;

{----------------------------------------------------------------------------}

FUNCTION VDCregRd (reg: BYTE): BYTE;
  BEGIN
    INLINE ($01/$00/$D6/     {         LD   BC,00D6h  }
            $3A/reg/         {         LD   A,(reg)   }
            $ED/$79/         {         OUT  (C),A     }
            $ED/$78/         { status: IN   A,(C)     }
            $17/             {         RLA            }
            $D2/*-5/         {         JR   NC,status }
            $0C/             {         INC  C         }
            $ED/$68/         {         IN   L,(C)     }
            $26/$00/         {         LD   H,00h     }
            $C9)             {         RET            }
  END;

{----------------------------------------------------------------------------}

PROCEDURE VDCmemWr (adr : INTEGER; wert : BYTE);
  BEGIN
    VDCregWr (18, Hi (adr)); VDCregWr (19, Lo (adr)); VDCregWr (31, wert)
    { RAM-Adresse HighByte } { RAM-Adresse LowByte }  { Datenregister }
  END;

{----------------------------------------------------------------------------}

FUNCTION VDCmemRd (adr : INTEGER) : BYTE;
  BEGIN
    VDCregWr (18, Hi (adr)); VDCregWr (19, Lo (adr)); VDCmemRd := VDCregRd (31)
    { RAM-Adresse HighByte } { RAM-Adresse LowByte }  { Datenregister }
  END;

{----------------------------------------------------------------------------}

PROCEDURE VDCadrWr (adr : INTEGER);
  BEGIN
    VDCregWr (18, Hi (adr)); VDCregWr (19, Lo (adr));
    { RAM-Adresse HighByte } { RAM-Adresse LowByte }
  END;

{----------------------------------------------------------------------------}

PROCEDURE CursorFlash (cf : switch);
  VAR mode : BYTE;
  BEGIN
    CASE cf OF
      off  : mode := VDCregRd (10) AND 191 OR 32;
      slow : mode := VDCregRd (10) OR 96;
      fast : mode := VDCregRd (10) AND 223 OR 64;
      no   : mode := VDCregRd (10) AND 159
    ELSE
      mode := VDCregRd (10)
    END;
    VDCregWr (10, mode)
  END;

{----------------------------------------------------------------------------}

PROCEDURE AltChars (sw : switch);
  VAR mode : STRING [3];
  BEGIN
    IF sw = on THEN mode := 'G1' ELSE mode := 'G0';
    Write (CON, #27, mode)
  END;

{----------------------------------------------------------------------------}

PROCEDURE Flash (sw : switch);
  VAR mode : STRING [3];
  BEGIN
    IF sw = on THEN mode := 'G2' ELSE mode := 'G0';
    Write (CON, #27, mode)
  END;

{----------------------------------------------------------------------------}

PROCEDURE Underline (sw : switch);
  VAR mode : STRING [3];
  BEGIN
    IF sw = on THEN mode := 'G3' ELSE mode := 'G0';
    Write (CON, #27, mode)
  END;
{----------------------------------------------------------------------------}

PROCEDURE Reverse (sw : switch);
  VAR mode : STRING [3];
  BEGIN
    IF sw = on THEN mode := 'G4' ELSE mode := 'G0';
    Write (CON, #27, mode)
  END;
{----------------------------------------------------------------------------}

PROCEDURE InvScr;
  BEGIN
    VDCregWr (24, VDCregRd (24) XOR 64)
  END;

{----------------------------------------------------------------------------}

PROCEDURE Bell;
  BEGIN
    REPEAT
      Write (#7); Delay (500)
    UNTIL KeyPressed
  END;

{----------------------------------------------------------------------------}

PROCEDURE TextColor (txtcolor : color);
  CONST colorcode : ARRAY [0 .. 15] OF BYTE = (0, 12, 6, 14, 5, 13, 11, 3,
                                               2, 10, 8, 4, 9, 7, 15, 1);
  VAR txt : BYTE;
  BEGIN
    txt := 32 OR (colorcode [Ord (txtcolor)]);
    Write (CON, #27#27#27, Chr(txt))
  END;

{----------------------------------------------------------------------------}

PROCEDURE BackgroundColor (bgrcolor : color);
  VAR bgr : BYTE;
  BEGIN
    bgr := (VDCregRd (26) AND 240) OR Ord (bgrcolor);
    VDCregWr (26, bgr)
    { Farbregister unteres Nibble, Farbe aus Reg. 26 }
  END;


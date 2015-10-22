PROGRAM Hanoi;
{I GRAPH.INC}
CONST _ESC = #27;
      _CLS = #26;
      _HOME = #30;
      _REVERSE = #27'B0';
      _PLAIN = #27'C0';
      _BLINK = #27'B2';
      _NOBLINK = #27'C2';
      _UNDERLINE = #27'B3';
      _NOUNDERLINE = #27'C3';
      _DARK = #27'B1';
      _LIGHT = #27'C1';
      _BEEP = #7;

{
      _BLACK = #27#27#27#32;
      _WHITE = #27#27#27#33;
      _RED = #27#27#27#34;
      _CYAN = #27#27#27#35;
      _PURPLE = #27#27#27#36;
      _GREEN = #27#27#27#37;
      _BLUE = #27#27#27#38;
      _YELLOW = #27#27#27#39;
      _DARKPURPLE = #27#27#27#40;
      _BROWN = #27#27#27#41;
      _LIGHTRED = #27#27#27#42;
      _DARKGREY = #27#27#27#43;
      _MIDGREY = #27#27#27#44;
      _LIGHTGREEN = #27#27#27#45;
      _LIGHTBLUE = #27#27#27#46;
      _LIGHTGREY = #27#27#27#47;
}
      _BLACK = '';
      _WHITE = '';
      _RED = '';
      _CYAN = '';
      _PURPLE = '';
      _GREEN = '';
      _BLUE = '';
      _YELLOW = '';
      _DARKPURPLE = '';
      _BROWN = '';
      _LIGHTRED = '';
      _DARKGREY = '';
      _MIDGREY = '';
      _LIGHTGREEN = '';
      _LIGHTBLUE = '';
      _LIGHTGREY = '';

      colorset:array[1..7] of string[4]=(_BLUE,_DARKGREY,_LIGHTGREEN,_RED,_DARKPURPLE,
                                         _GREEN,_CYAN);

type charset=set of char;
     stringvar=string[100];

var ch:char;
    stack:array [1..3] of string[7];
    block:array [1..7] of string[80];
    l,scelta,ctemp:integer;
    anim:byte;

procedure hidecursor;
begin
 { cursorflash(off); }
  write(#27'C4');
end;

procedure showcursor;
begin
 { cursorflash(fast); }
  write(#27'B4');
end;

function readkey(validkeys:charset):char;
var ch:char;
begin
  repeat read(kbd,ch) until ch in validkeys;
  readkey := ch;
end;

function repl(a:stringvar;n:integer):stringvar;
var i:integer;
    b:stringvar;
begin
  b:='';
  if n>0 then
    for i:=1 to n do b:=b+a;
  repl:=b;
end;

function pot(x,y:integer):integer;
var i,pt:integer;
begin
  pt:=1;
  for i:=1 to y do pt:=pt*x;
  pot:=pt;
end;

function atoi(s:stringvar):integer;
var n,err:integer;
begin
  val(s,n,err);
  atoi:=n;
end;

function itoa(n:integer):stringvar;
var s:stringvar;
begin
  str(n,s);
  itoa:=s;
end;

function lastchar(s:stringvar):char;
begin
  lastchar := s[length(s)];
end;

function invpos(s:stringvar;c:char):integer;
var i,p:integer;
begin
  p:=0;
  if length(s)>0 then
     for i:=1 to length(s) do
       if s[i]=c then p:=i;
  invpos:=p;
end;

function scambia(p,d:integer):boolean;
var valida:boolean;
    a,b:integer;
begin
  a:=atoi(lastchar(stack[p]));
  b:=atoi(lastchar(stack[d]));
  if stack[d]='' then b:=100;
  if (a<>0) and (a<b) then begin
    stack[d] := stack[d]+lastchar(stack[p]);
    stack[p] := copy(stack[p],1,length(stack[p])-1);
    valida := true;
  end else
    valida := false;
  scambia := valida;
end;

function verify:boolean;
var vince:boolean;
    i:integer;
begin
  vince:=false;
  for i:=2 to 3 do
    if length(stack[i])=l then vince:=true;
  verify:=vince;
end;

procedure dispmessage(s:stringvar);
var wd:integer;
begin
  wd:=((78-length(s)) div 2)+3;
  if s='' then wd:=3;
  gotoxy(3,24); write(_REVERSE,_RED,repl(' ',77));
  gotoxy(wd,24); write(s,_BLINK,'_',_PLAIN,_NOBLINK);
end;

function getnumber:integer;
var ch:char;
begin
  ch := readkey(['1','2','3',#27]);
  if ch=#27 then
     getnumber:=-1
  else begin
     {dispmessage('');}
     getnumber:=atoi(ch);
  end;
end;

function input(var p,d:integer):integer;
begin
  gotoxy(64,6); write(_DARKPURPLE,'  ');
  gotoxy(64,7); write('  ');
  gotoxy(64,8);
  repeat
    gotoxy(64,6);
    p:=getnumber;
    if (length(stack[p])=0) and (p<>-1) then begin
      write(_BEEP);
      dispmessage('Base n.'+itoa(p)+' is empty');
    end;
  until (length(stack[p])<>0) or (p=-1);
  if p=-1 then begin
     input:=1;
     exit;
  end;
  gotoxy(64,6); write(_DARKPURPLE,itoa(p));
  gotoxy(64,7);
  d:=getnumber;
  if d=-1 then begin
     input:=1;
     exit;
  end;
  gotoxy(64,7); write(_DARKPURPLE,itoa(d));
  input:=0;
end;

procedure plotbox(x1,y1,x2,y2:integer);
var i,j:integer;
begin
  for i:=1 to 2 do
    for j:=y1 to y2 do begin
      if i=1 then gotoxy(x1,j) else gotoxy(x2,j);
      write(_RED,_REVERSE,' ');
    end;
  gotoxy(x1,y1); write(_RED,_REVERSE,repl(' ',x2-x1+1));
  gotoxy(x1,y2); write(_RED,_REVERSE,repl(' ',x2-x1+1));
  write(_PLAIN);
end;

procedure center(y:integer;col:stringvar;s:stringvar);
begin
  gotoxy((80-length(s)) div 2,y);write(col,s);
end;

procedure pulisci(a,b:integer);
var i:integer;
    s:stringvar;
begin
  s:=repl(' ',72);
  for i:=a to b do begin
    gotoxy(5,i);write(s);
  end;
end;

procedure initialize;
begin
  anim:=0;
  l:=2;
  scelta:=1;
end;

procedure introscreen;
begin
  if scelta=1 then begin
    clrscr;
    plotbox(3,2,78,24);
    plotbox(4,2,77,24);
  end else
    pulisci(3,23);
  gotoxy(36,4); write(_CYAN,'Towers of');
  gotoxy(24,06); write(_YELLOW,_DARK);
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,'   ', _REVERSE,'  ', _PLAIN,'   ',_REVERSE,'  ');
  write(_PLAIN,'  ',_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'    ',_PLAIN,'  ',_REVERSE,'    ');
  gotoxy(24,07); write(_YELLOW);
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'    ',_PLAIN,'  ',_REVERSE,'   ');
  write(_PLAIN,' ',_REVERSE,'  ',_PLAIN,' ',_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ');
  gotoxy(24,08); write(_YELLOW);
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,' ',_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,' ');
  write(_REVERSE,'      ',_PLAIN,' ',_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ');
  gotoxy(24,09); write(_YELLOW);
  write(_REVERSE,'      ',_PLAIN,' ',_REVERSE,'      ',_PLAIN,' ',_REVERSE,'  ',_PLAIN,' ',_REVERSE,'   ', _PLAIN, ' ');
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ');
  gotoxy(24,10); write(_YELLOW);
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,' ');
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,' ');
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,' ');
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ');
  gotoxy(24,11); write(_YELLOW);
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,' ');
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,' ');
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,' ');
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ');
  gotoxy(24,12); write(_YELLOW);
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,' ');
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,' ');
  write(_REVERSE,'  ',_PLAIN,'  ',_REVERSE,'  ',_PLAIN,'  ');
  write(_REVERSE,'    ',_PLAIN,'  ',_REVERSE,'    ');
  gotoxy(29,14); write(_LIGHT,_PLAIN,_CYAN,'by Francesco Sblendorio');
end;

function writeboolean(v:byte):stringvar;
begin
  case v of
    0: writeboolean:='Off';
    1: writeboolean:='On ';
  end;
end;

procedure selectionscreen;
var c:char;
    m,err:integer;
begin
  gotoxy(32,16); write(_BLUE, 'Make your choice');
  gotoxy(21,17); write(_BLUE, 'Use ',_WHITE,'+',_BLUE,' and ',_WHITE,'-',_BLUE,' keys to change blocks number');
  m:=0;
  while (m<1) or (m>4) do begin
    gotoxy(21,19); write(_BLACK,'1. Start game. Number of blocks: ',_WHITE,itoa(l),' ',_BLACK);
    gotoxy(21,20); write('2. Toggle animation. Current: ',_WHITE,writeboolean(anim),_BLACK);
    gotoxy(21,21); write('3. About Towers of Hanoi');
    gotoxy(21,22); write('4. Exit to CP/M command prompt');
    c:=readkey(['1','2','3','4','+','-',#13,#27]);
    val(c,m,err);
    if (c='+') and (l<7) then l:=l+1;
    if (c='-') and (l>1) then l:=l-1;
    if (c=#13) then m:=1;
    if (c=#27) then m:=4;
  end;
  scelta:=m;
end;

procedure printblock(n:byte);
begin
 { write(_REVERSE,colorset[n],block[n],_PLAIN); }
  write(_REVERSE,_DARK,colorset[n],block[n],_LIGHT,_PLAIN);
end;

procedure resetgame;
var i,j:integer;
    c:char;
begin
  j:=-1;
  for i:=1 to 7 do
    block[i]:=_PLAIN+repl(' ',(7-i)*2)+_REVERSE+repl(' ',4*i-2)+_PLAIN+repl(' ',(7-i)*2);
  for i:=1 to 3 do stack[i]:='';
  for i:=l downto 1 do stack[1]:=stack[1]+itoa(i);
  clrscr;
  plotbox(1,1,80,23);
  gotoxy(1,2); insline;
  gotoxy(1,2); write(_RED,_REVERSE,' ',_PLAIN,repl(' ',78),_REVERSE,' ');
  gotoxy(2,23);write(_BLACK,_REVERSE,repl(' ',13),'1',repl(' ',25),'2',repl(' ',25),'3',repl(' ',12),_PLAIN);
  gotoxy(7,4);write(_BROWN,'Current status');
  gotoxy(7,6);write(_BLUE,'# Moves done  :');
  gotoxy(7,7);write(_BLUE,'# Moves needed: ',_WHITE,pot(2,l)-1);
  gotoxy(58,4);write(_RED,'Move');
  gotoxy(58,6);write(_DARKPURPLE,'From:');
  gotoxy(58,7);write(_DARKPURPLE,'  To:');
  gotoxy(2,24);write(_RED,_REVERSE,'>',_PLAIN);
  dispmessage('');
end;

procedure visual;
var i,j,k:integer;
    b:stringvar;
begin
  for i:=1 to 3 do begin
    b:=stack[i];
    k:=length(b);
    if k<>0 then
       for j:=1 to k do begin
         gotoxy(2+(26*(i-1)),23-j);
         printblock(atoi(b[j]));
       end;
    gotoxy(2+(26*(i-1)),22-k); write(_PLAIN,repl(' ',26));
  end;
end;

procedure moveblock(p,d:integer);
var xStart,xEnd,yStart,yEnd,b,Dx,i:integer;
begin
  yStart:=23-length(stack[p]);
  yEnd:=23-length(stack[d]);
  xStart:=2+(26*(p-1));
  xEnd:=2+(26*(d-1));
  Dx:=d-p;
  b:=atoi(lastchar(stack[d]));
  for i:=yStart-2 downto 14 do begin
    gotoxy(xStart,i); printblock(b);
    gotoxy(xStart,i+1); write(_PLAIN,repl(' ',26));
    delay(40);
  end;
  delay(60);
  if Dx>0 then begin
    for i:=xStart to xEnd-1 do begin
      gotoxy(i,14); write(_PLAIN,' '); printblock(b);
      delay(25);
    end;
  end else begin
    for i:=xStart-1 downto xEnd do begin
      gotoxy(i,14); printblock(b); write(_PLAIN,' ');
      delay(25);
    end;
  end;
  delay(75);
  for i:=15 to yEnd do begin
    gotoxy(xEnd,i); printblock(b);
    gotoxy(xEnd,i-1); write(_PLAIN,repl(' ',26));
    delay(40);
  end;
end;

procedure game;
var p,d,mosse,min:integer;
    c:char;
    valida:boolean;
begin
  resetgame;
  mosse:=0;
  min:=pot(2,l)-1;
  visual;
  while (not verify) do begin
    repeat
      showcursor;
      if input(p,d)=1 then begin
        hidecursor;
        exit;
      end;
      valida:=scambia(p,d);
      if not valida then begin
         write(_BEEP);
         if p<>d then
            dispmessage(itoa(p)+' to '+itoa(d)+': Illegal move')
         else
            dispmessage('FROM=TO: Illegal move');
      end else begin
         delay(300);
         hidecursor;
         mosse:=mosse+1;
      end;
    until valida;
    if anim=1 then begin
       dispmessage('Move from '+itoa(p)+' to '+itoa(d));
       moveblock(p,d);
    end;
    dispmessage('');
    gotoxy(23,6);
    if mosse<=min then write(_WHITE) else write(_RED);
    write(mosse);
    visual;
  end;
  if mosse=min then begin
     center(10,_RED,'P E R F E C T');
       dispmessage('You won');
    write(_BEEP);
  end else begin
     center(10,_BLACK,'It''s ok, but you could do it better');
     dispmessage('You could do it better, try again');
     write(_BEEP);
  end;
  center(13,_WHITE,'-- Press any key to go back to main menu --');
  read(kbd,c);
end;

procedure infoscreen;
var c:char;
begin
  pulisci(3,22);
  center(4,_BLACK+_REVERSE,'                   ');
  center(5,_BLACK+_REVERSE,'  Towers of Hanoi  ');
  center(6,_BLACK+_REVERSE,'                   ');
  center(8,_PLAIN+_YELLOW,'written by');
  center(9,_YELLOW,'Francesco Sblendorio');
  center(10,_BLUE+_UNDERLINE,'http://www.sblendorio.eu');
  center(12,_NOUNDERLINE+_WHITE,'(C) 1996 MS-DOS version     (C) 2015 CP/M version');
  write(_PLAIN);
  read(kbd,c);
end;

procedure esci;
var c:char;
begin
  pulisci(16,22);
  center(18,_RED,'Are you sure you want to exit?');
  center(20,_WHITE,'(Y/N)');
  c := readkey(['y','Y','n','N','0','1',#27]);
  case c of
    'y','Y','1': scelta:=4;
    'n','N','0',#27: scelta:=-1;
  end;
end;

procedure exitscreen;
begin
  write(_PLAIN,_WHITE,_NOUNDERLINE);
 { backgroundcolor(black); }
  clrscr;
end;

begin
  hidecursor;
 { backgroundcolor(lt_grey); }
  write(_PLAIN);
  initialize;
  repeat
    if scelta=-1 then pulisci(16,22) else if scelta<>2 then introscreen;
    selectionscreen;
    case scelta of
      1: game;
      2: anim:=1-anim;
      3: infoscreen;
      4: esci;
    end;
  until scelta=4;
  exitscreen;
  showcursor;
end.

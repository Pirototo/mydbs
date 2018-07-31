program fukensort5(input,output);
label 1,2,3,55;
const L = 47; 
type ken = packed array[1..70] of char;
     pref = record
             EP, JP, EC, JC, PP, AR : ken;
            end;
     pref2 = record
               EC : ken;
               index : 1..47;
             end;

var target : ken; a : char; popu : integer;
    table : array[1..L + 1] of pref; 
    table2 : array[1..L] of pref2;

function lofD(x : ken) : integer;
var i : integer;
begin
  i := 1; while x[i] <> chr(0) do i := i + 1;
  lofD := i - 1;
end;

function edata(x : ken; k : integer) : ken;
var pos,i,num,xL : integer; y : ken;
begin
  xL := lofD(x);
  pos := 1; num := 0; y := ' ';
  while (num < k-1) and (pos <= xL) do
   begin if x[pos]=',' then num := num + 1; pos := pos + 1; end;
  i := pos;
  while (x[i] <> ',')and(i <= xL) do begin y[i-pos+1] := x[i]; i := i + 1; end;
  edata := y;
end;

procedure readfile;
label 99;
var fp : text;
    s : ken; 
    k : integer;
begin
  assign(fp,'ファイル名'); reset(fp);
  k := 1;
  while true do
  begin
    s:=' '; readln(fp,s);
    if s[1] = '%' then goto 99; 
    with table[k] do 
    begin 
     EP := edata(s,1);
     JP := edata(s,2);
     EC := edata(s,3);
     JC := edata(s,4);
     PP := edata(s,5);
     AR := edata(s,6);
    end;
   k := k + 1;  
  end;
99:
end;

procedure writefile;
var i : integer;
begin 
  for i := 1 to L do begin
  with table[i] do begin
    write('県名：',JP,',',EP);writeln;
    write('県庁所在地名：',JC,',',EC);writeln;
    write('人口：',PP,' (*千人) ');writeln;
    write('面積：',AR,'(*10km^2)'); writeln;
    writeln;
    end;
  end;
end;

procedure swap(a, b:integer);
var c : pref;
begin 
 c := table[a]; table[a] := table[b]; table[b] := c;
end;

procedure EPsort;
var i, j, minpos : integer;
begin
  for i := 1 to L - 1 do
  begin
   minpos := i;
    for j := i + 1 to L do
      if table[j].EP < table[minpos].EP then minpos := j;
   swap(i,minpos);
  end;
end;

procedure EPsearch(target : ken);
var hi, mid, lo : integer;
    found : boolean;
    pos : integer;
begin
  lo := 1; hi := L;
  while lo <= hi do
   begin
    mid := (lo + hi) div 2;
    if target <= table[mid].EP then hi := mid - 1;
    if target >= table[mid].EP then lo := mid + 1;
   end;
  found := (lo = hi + 2);
  pos := lo - 1;
  if found = true then
  begin
    write('県名：',table[pos].JP,',',table[pos].EP);writeln;
    write('県庁所在地名：',table[pos].JC,',',table[pos].EC);writeln;
    write('人口：',table[pos].PP, ' (*千人) ');writeln;
    write('面積：',table[pos].AR,'(*10km^2)');writeln;
  end
  else begin
    write('データは見つかりません'); writeln;
  end;
end;

procedure swap2(a, b:integer);
var c : pref2;
begin 
 c := table2[a]; table2[a] := table2[b]; table2[b] := c;
end;

procedure ECsort;
var i, j, minpos, k : integer;
begin
  for k := 1 to L do
  begin
    table2[k].index := k;
    table2[k].EC := table[k].EC;
  end;
  for i := 1 to L - 1 do
  begin
    minpos := i;
    for j := i + 1 to L do
    begin
      if table2[j].EC < table2[minpos].EC then minpos := j;
    end;
  swap2(i, minpos);
  end;
end;

procedure ECsearch(target : ken);
var lo, hi, mid, k : integer;
    found : boolean;
    pos : integer;
begin
  lo := 1; hi := L;
  while lo <= hi do
   begin
    mid := (lo + hi) div 2;
    if target <= table2[mid].EC then hi := mid - 1;
    if target >= table2[mid].EC then lo := mid + 1;
   end;
  found := (lo = hi + 2);
  pos := lo - 1;
  if found = true then
  begin
    write('県名：',table[table2[pos].index].JP,',',
              table[table2[pos].index].EP);writeln;
    write('県庁所在地名：',table[table2[pos].index].JC,',',
              table[table2[pos].index].EC);writeln;
    write('人口：',table[table2[pos].index].PP, ' (*千人) ');writeln;
    write('面積：',table[table2[pos].index].AR,'(*10km^2)'); writeln;
  end
  else begin
    write('データは見つかりません');writeln; 
  end;
end;

function tn(s : ken) : integer;
var i, j : integer;
begin
  j := 0;
  for i := 1 to lofD(s) do j := j * 10 + ord(s[i]) - 48;
  tn := j;
end;

procedure prk;
var i, j, k, minpos : integer;
begin 
  for i := 1 to L - 1 do
  begin
    minpos := i;
    for j := i + 1 to L do
    begin
      if tn(table[j].PP) > tn(table[minpos].PP) then minpos := j;
    end;
  swap(i, minpos);
  end;
  for k := 1 to L do
  begin
    writeln(table[k].JP,' ',table[k].PP,'(*千人)');
  end;
end;

procedure ark;
var i, j, k, minpos : integer;
begin 
  for i := 1 to L - 1 do
  begin
    minpos := i;
    for j := i + 1 to L do
    begin
      if tn(table[j].AR) > tn(table[minpos].AR) then minpos := j;
    end;
  swap(i, minpos);
  end;
  for k := 1 to L do
  begin
    writeln(table[k].JP,' ',table[k].AR,'(*10km^2)');
  end;
end;

function tl(x : integer) : ken;
var t, i, fig : integer;
begin
  if x = 0 then tl := '0'
  else
  begin
    t := x; fig := 0; 
    while  t > 0 do begin fig := fig + 1; t := t div 10; end;
    tl := ' '; t := x;
    for i := fig downto 1 do
      begin 
        tl[i] := chr((t - (t div 10) * 10) + 48); 
        t := t div 10; 
      end;  
  end;
end;

procedure modify(target : ken; var popu : integer);
var hi, mid, lo : integer;
    found : boolean;
    pos : integer;
begin
  lo := 1; hi := L;
  while lo <= hi do
   begin
    mid := (lo + hi) div 2;
    if target <= table[mid].EP then hi := mid - 1;
    if target >= table[mid].EP then lo := mid + 1;
   end;
  found := (lo = hi + 2);
  pos := lo - 1;
  if found = true then 
    begin
      table[pos].PP := tl(popu);
    end
  else  begin
    write('データは見つかりません'); writeln
  end;
end;

function jsave(a, b : ken) : ken;
var i, pos : integer;
begin
  jsave := a; pos := lofD(a);
  a[pos + 1] := ',';
  for i := 1 to lofD(b) do a[pos + 1 + i] := b[i];
  jsave := a;
end;

procedure saving;
var i : integer;
    s : ken;
    fp : text;
begin
   assign(fp,'ファイル名'); 
   rewrite(fp);
   append(fp);
   table[48].EP := '%%%%%%';
   table[48].JP := ' ';
   table[48].EC := ' ';
   table[48].JC := ' ';
   table[48].PP := ' ';
   table[48].AR := ' ';
   for i := 1 to 48 do
    begin
       s := ' ';
       s := jsave(table[i].EP,table[i].JP);
       s := jsave(s,table[i].EC);
       s := jsave(s,table[i].JC);
       s := jsave(s,table[i].PP);
       s := jsave(s,table[i].AR);
       writeln(fp,s);
    end;
   close(fp);
   writeln('データを上書き保存');
   goto 55;
end;

begin 
  55:
  1: readfile;
  2: 
  writeln(' 【メニュー】');
  writeln('s) 都道府県名からデータ探索【2】');
  writeln('S) 都道府県庁所在地からデータ探索【3】');
  writeln('e) 人口ランキング【4】,a) 面積ランキング【5】,m) 人口修正【6】');
  writeln('h) (全データ)列挙【1】,i) 最初から【7】');
  writeln('u) 上書き保存【8】,q) 終了【9】');
  readln(a);
  if a = 'h' then begin writefile; end;
  if a = 's' then 
  begin EPsort; write('県名は？');
        readln(target); EPsearch(target); end;
  if a = 'S' then 
  begin ECsort; write('県庁所在地名は？');
        readln(target); ECsearch(target); end;  
  if a = 'e' then begin prk end;   
  if a = 'a' then begin ark end;  
  if a = 'm' then
    begin 
     EPsort; write('修正する県名は？');
     readln(target); write('修正後の人口は？');
     readln(popu); modify(target,popu);
    end;
  if a = 'i' then goto 1;
  if a = 'u' then saving;
  if a = 'q' then goto 3;
  goto 2; 
  3:
end.

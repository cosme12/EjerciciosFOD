program p1ej2; //bien
type
archivoInt = file of integer;
var
  archivo:archivoInt;
  nombre:string; num,cantMenores,cant,total:integer;
  promedio:real;
begin
  write('Ingrese el nombre del archivo: ');readln(nombre);writeln();
  assign(archivo,nombre);
  rewrite(archivo);
  total:=0;
  cant:=0;
  write('Ingrese un numero: ');readln(num);
  while (num<>30000) do begin
    write(archivo,num);
    cant:=cant+1;
    total:=total+num;
    write('Ingrese un numero: ');readln(num);
  end;writeln();
  seek(archivo,0);
  cantMenores:=0;
  while (not eof(archivo)) do begin
    read(archivo,num);  
    writeln(num);  
    if (num<1500) then
      cantMenores:=cantMenores+1;
  end;writeln();
  writeln('La cantidad de numeros menores a 1500 es: ',cantMenores);
  promedio:=total/cant;
  writeln('El promedio es: ',promedio:2:2);
  close(archivo);
end.

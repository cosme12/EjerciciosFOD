program p1ej1;  //bien
type
archivoInt = file of integer;
var
  archivo:archivoInt;
  nombre:string; num:integer;
begin
  write('Ingrese el nombre del archivo: ');readln(nombre);writeln();
  assign(archivo,nombre);
  rewrite(archivo);
  write('Ingrese un numero: ');readln(num);
  while (num<>30000) do begin
    write(archivo,num);
    write('Ingrese un numero: ');readln(num);
  end;
  close(archivo);
end.

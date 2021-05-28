program p3ej2_2; //bien
const
valoralto = 9999;
type
regEmpleado = record
  codigo,dni,telefono:integer;
  apellido,direccion,fechaNac:string;
end;
bin = file of regEmpleado;
procedure leerEmpleado (var empleado:regEmpleado);
  begin
    with empleado do begin
      writeln('Ingrese:');
      write('Empleado: ');readln();
      if (empleado<>0) then begin
        write('Apellido: ');readln();
        write('Dni: ');readln();
        write('Telefono: ');readln();
        write('Direccion: ');readln();
        write('Fechanac: ');readln();
      end;
    end;writeln();
  end;
procedure crearArchivo (var archivo:bin);
  var
    empleado:regEmpleado;
  begin
    rewrite(arhivo);
    leerEmpleado(empleado);
    while (empleado.codigo<>0) do begin
      write(archivo,empleado);
      leerEmpleado(empleado);
    end;
    close(archivo);
  end;
procedure leer (var archivo:bin; var empleado:regEmpleado);
  begin
    if (not eof(archivo)) then
      read(archivo,empleado)
    else
      empleado.codigo:=valoralto;
  end;
procedure procesar (var archivo:bin);
  var
    empleado:regEmpleado;
  begin
    reset(archivo);
    leer(archivo,empleado);
    while (empleado.codigo <> valoralto) do begin
      if (empleado.dni < 8000000) then begin
        empleado.nombre:='***';
        seek(archivo,filepos(archivo)-1);
        write(archivo,empleado);
      end;
      leer(archivo,empleado);
    end;
    close(archivo);
  end;
var
  archivo:bin;
begin
  assign(arhcivo,'p3ej2_2.dat')
  crearArchivo(archivo);
  procesar(archivo);
end.
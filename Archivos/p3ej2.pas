program p3ej2; //bien
const
valoralto = 9999;
type
regEmpleado = record
  codigo,dni,telefono,fecha:integer;
  nombre,apellido,direccion:string;
end;
bin = file of regEmpleado;
procedure leerEmpleado (var empleado:regEmpleado);
  begin
    with empleado do begin
      writeln('Ingrese: ');
      write('Codigo de empleado: ');readln(codigo);
      if (codigo<>0) then begin
        write('Nombre: ');readln(nombre);
        //write('Apellido: ');readln(apellido);
        write('DNI: ');readln(dni);
        //write('Telefono: ');readln(telefono);
        //write('Fecha de nacimiento: ');readln(fecha);
        //write('Direccion: ');readln(direccion);
      end;
    end;writeln();
  end;
procedure cargarArchivo (var archivo:bin);
  var
    empleado:regEmpleado;
  begin
    leerEmpleado(empleado);
    while (empleado.codigo <> 0) do begin
      write(archivo,empleado);
      leerEmpleado(empleado);
    end;
  end;
procedure leer (var archivo:bin; var empleado:regEmpleado);
  begin
    if (not eof(archivo)) then
      read(archivo,empleado)
    else
      empleado.codigo:=valoralto;
  end;
procedure bajas (var archivo:bin);
  var
    empleado:regEmpleado;
  begin 
    reset(archivo);
    leer(archivo,empleado);	
    while (empleado.codigo <> valoralto) do	begin    
      if (empleado.dni < 80) then begin
        empleado.nombre:= '***';		
        seek(archivo,filepos(archivo)-1);
        write(archivo,empleado);
      end;
      leer(archivo,empleado);	   
    end;
    close(archivo);
  end;
procedure listarEmpleado (empleado:regEmpleado);
  begin
    with empleado do begin
      writeln('Codigo de empleado: ',codigo);
      writeln('Nombre: ',nombre);
      //writeln('Apellido: ',apellido);      
      writeln('DNI: ',dni);
      //writeln('Telefono: ',telefono);
      //writeln('Fecha de nacimiento: ',fecha);
      //writeln('Direccion: ',direccion);
    end;writeln();
  end;
procedure listarEmpleados (var archivo:bin);
  var
    empleado:regEmpleado;
  begin
    reset(archivo);
    leer(archivo,empleado);
    while (empleado.codigo <> valoralto) do begin
      if (empleado.nombre <> '***') then 
        listarEmpleado(empleado);
      leer(archivo,empleado);
    end;
    close(archivo);
  end;
var
  archivo:bin;
begin
  assign(archivo,'p3ej2.dat');
  rewrite(archivo);
  cargarArchivo(archivo);
  close(archivo);
  listarEmpleados(archivo);
  bajas(archivo);
  listarEmpleados(archivo);  
end.
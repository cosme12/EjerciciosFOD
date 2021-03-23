program p1ej3;  //bien
type
regEmpleado=record
  numEmp,edad,dni:integer;
  apellido,nombre:string;
end;
archivoEmpleados=file of regEmpleado;
procedure leer (var empleado:regEmpleado);
  begin
    with empleado do begin
      write('Ingrese el apellido: ');readln(apellido);
      if (apellido<>'fin') then begin
        write('Ingrese el nombre: ');readln(nombre);
        //write('Ingrese el numero de empleado: ');readln(numEmp);
        //write('Ingrese el DNI: ');readln(dni);
        write('Ingrese la edad: ');readln(edad);
      end;
    end;writeln();
  end;
procedure cargarArchivo (var archivo:archivoEmpleados);
  var
    empleado:regEmpleado;
  begin
    leer(empleado);
    while (empleado.apellido <> 'fin') do begin
      write(archivo,empleado);
      leer(empleado);
    end;
  end;
procedure listarEmpleado (empleado:regEmpleado);
  begin
    with empleado do begin
      writeln('Nombre: ',nombre);
      writeln('Apellido: ',apellido);
      //writeln('Numero de empleado: ',numEmp);
      //writeln('DNI: ',dni);
      writeln('Edad: ',edad);writeln();
    end;
  end;
procedure listarNom (var archivo:archivoEmpleados);
  var
    empleado:regEmpleado; nombre:string;
  begin
    reset(archivo);
    write('Ingrese el nombre a buscar: ');readln(nombre);
    while (not eof(archivo)) do begin
      read(archivo,empleado);
      if (empleado.nombre=nombre) then 
        listarEmpleado(empleado);            
    end;
    close(archivo);
  end;
procedure listarEmpleados (var archivo:archivoEmpleados);
  var
    empleado:regEmpleado;
  begin
    reset(archivo);
    while (not eof(archivo)) do begin
      read(archivo,empleado);
      listarEmpleado(empleado);
    end;
    close(archivo);
  end;
procedure listarMayores (var archivo:archivoEmpleados);
  var
    empleado:regEmpleado;
  begin
    reset(archivo);
    while (not eof(archivo)) do begin
      read(archivo,empleado);
      if (empleado.edad>70) then
        listarEmpleado(empleado);
    end;
    close(archivo);
  end;
procedure desplegarMenu (var archivo:archivoEmpleados);
  var
    opcion:integer;
  begin
    writeln('1. Listar un empleado por nombre determinado.');
    writeln('2. Listar todos los empleados.');
    writeln('3. Listar los empleados mayores a 70 años.');
    writeln('0. Salir.');writeln();
    write('Opcion: ');readln(opcion);writeln();
    if (opcion<>0) then begin
      case opcion of
        1: listarNom(archivo);
        2: listarEmpleados(archivo);
        3: listarMayores(archivo);
        else
          writeln('Opcion incorrecta.');writeln();
      end;
      desplegarMenu(archivo);
    end;  
  end;
var
  archivo:archivoEmpleados;
  nombreArchivo:string;
begin
  write('Ingrese el nombre del archivo: ');readln(nombreArchivo);writeln();
  assign(archivo,nombreArchivo);
  rewrite(archivo);
  cargarArchivo(archivo);
  close(archivo);
  desplegarMenu(archivo);
end.
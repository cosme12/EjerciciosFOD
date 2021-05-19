program p1ej4;  //casi bien, hay error en la opcion 5
type
regEmpleado=record
  numEmp,edad,dni:integer;
  apellido,nombre:string;
end;
archivoEmpleados=file of regEmpleado;
archivoTxt=text;
procedure leer (var empleado:regEmpleado);
  begin
    with empleado do begin
      write('Ingrese el apellido: ');readln(apellido);
      if (apellido<>'fin') then begin
        write('Ingrese el nombre: ');readln(nombre);
        write('Ingrese el numero de empleado: ');readln(numEmp);
        write('Ingrese el DNI: ');readln(dni);
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
      writeln('Numero de empleado: ',numEmp);
      writeln('DNI: ',dni);
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
procedure anadirEmpleado (var archivo:archivoEmpleados);
  var
    empleado:regEmpleado;
  begin
    writeln('Para dejar de anadir empleados, ingrese el apellido fin.');
    reset(archivo);
    seek(archivo,filesize(archivo)-1);
    leer(empleado);
    while (empleado.apellido<>'fin') do begin
      write(archivo,empleado);
      leer(empleado);
    end;
    close(archivo);
  end;
procedure modificarEmpleado (var archivo:archivoEmpleados);
  var
    empleado:regEmpleado; numEmp,edad:integer;
  begin
    writeln('Para dejar de modificar empleados, ingrese el numero 000.');writeln();
    write('Ingrese el numero de empleado a modificar edad: ');readln(numEmp);
    reset(archivo);
    while (numEmp<>000) do begin
      read(archivo,empleado);
      while (not eof(archivo)) and (numEmp<>empleado.numEmp) do
        read(archivo,empleado);
      if (numEmp=empleado.numEmp) then begin
        write('Ingrese la nueva edad: ');readln(edad);
        empleado.edad:=edad;
        seek(archivo,filepos(archivo)-1);
        write(archivo,empleado);
      end
      else
        writeln('No se encontro el empleado.');
      writeln();
      write('Ingrese el numero de empleado a modificar edad: ');readln(numEmp);
    end;
    close(archivo);
  end;
procedure regATexto (var empleado:regEmpleado; var txt:archivoTxt);
  begin
    write(txt,empleado.nombre);
    write(txt,empleado.apellido);
    write(txt,empleado.numEmp);
    write(txt,empleado.dni);
    write(txt,empleado.edad);
    write(txt,' ');
  end;
procedure exportarTodos (var archivo:archivoEmpleados);
  var
    empleado:regEmpleado; txt:archivoTxt;
  begin
    assign(txt,'todos_empleados.txt');
    rewrite(txt);
    reset(archivo);
    while (not eof(archivo)) do begin
      read(archivo,empleado);
      regATexto(empleado,txt);
    end;
    close(txt);
    close(archivo);
  end;
procedure exportarFaltaDni (var archivo:archivoEmpleados);
  var
    empleado:regEmpleado; txt:archivoTxt;
  begin
    assign(txt,'faltaDNIEmpleado.txt');
    rewrite(txt);
    reset(archivo);
    while (not eof(archivo)) do begin
      read(archivo,empleado);
      if (empleado.dni=00) then
        regATexto(empleado,txt);
    end;
    close(txt);
    close(archivo);
  end;
procedure desplegarMenu (var archivo:archivoEmpleados);
  var
    opcion:integer;
  begin
    writeln('1. Listar un empleado por nombre determinado.');
    writeln('2. Listar todos los empleados.');
    writeln('3. Listar los empleados mayores a 70 anos.');
    writeln('4. Anadir mas empleados.');
    writeln('5. Modificar la edad de empleados.');
    writeln('6. Exportar el contenido a un archivo de texto.');
    writeln('7. Exportar al archivo de texto "faltaDNIEmpleado".');
    writeln('0. Salir.');writeln();
    write('Opcion: ');readln(opcion);writeln();
    if (opcion<>0) then begin
      case opcion of
        1: listarNom(archivo);
        2: listarEmpleados(archivo);
        3: listarMayores(archivo);
        4: anadirEmpleado(archivo);
        5: modificarEmpleado(archivo);
        6: exportarTodos(archivo);
        7: exportarFaltaDni(archivo);
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

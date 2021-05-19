program p2ej2;  //bien
type
regAlumno=record
  codigo,cursadas,finales:integer;
  nombre,apellido:string;
end;
bin = file of regAlumno;
procedure crearBinario (var archivo:bin; var txt:text);
  var
    alumno:regAlumno;
  begin
    rewrite(archivo);
    reset(txt);
    while (not eof(txt)) do begin
      with alumno do begin
        readln(txt,codigo,cursadas,finales,nombre);
        readln(txt,apellido);
      end;
      write(archivo,alumno);
    end;
    close(txt);
    close(archivo);writeln();
  end;
procedure regATexto (var alumno:regAlumno; var txt:text); 
  begin
    write(txt,'Codigo de alumno: ');write(txt,alumno.codigo);write(txt,sLineBreak);
    write(txt,'Nombre: ');write(txt,alumno.nombre);write(txt,sLineBreak);
    write(txt,'Apellido: ');write(txt,alumno.apellido);write(txt,sLineBreak);
    write(txt,'Cursadas: ');write(txt,alumno.cursadas);write(txt,sLineBreak);    
    write(txt,'Finales: ');write(txt,alumno.finales);write(txt,sLineBreak);write(txt,sLineBreak);   
  end;
procedure exportarTodos (var archivo:bin; nombre:string); 
  var
    alumno:regAlumno; txt:text;
  begin
    assign(txt,nombre);
    rewrite(txt);
    reset(archivo);
    while (not eof(archivo)) do begin
      read(archivo,alumno);
      regATexto(alumno,txt);
    end;
    close(txt);
    close(archivo);
  end;
procedure actualizarMaestro (var maestro,detalle:bin);
  var
    regMaestro,regDetalle:regAlumno;
  begin
    reset(maestro);
    reset(detalle);
    while not eof(detalle) do begin
      read(maestro,regMaestro);
      read(detalle,regDetalle);
      while regMaestro.codigo <> regDetalle.codigo do begin
        read(maestro,regMaestro);
      end;
      if regDetalle.cursadas = 1 then
        regMaestro.cursadas:=regMaestro.cursadas+1
      else if regDetalle.finales = 1 then
        regMaestro.finales:=regMaestro.finales+1;
      seek(maestro,filepos(maestro)-1);
      write(maestro,regMaestro);
    end;
    close(maestro);
    close(detalle);
  end;
procedure listarUnAlumno (alumno:regAlumno);
  begin
    with alumno do begin
      writeln('Codigo de alumno: ',codigo);
      writeln('Nombre: ',nombre);
      writeln('Apellido: ',apellido);
      writeln('Cursadas: ',cursadas);
      writeln('Finales: ',finales);
    end;
  end;
procedure materiasSinFinal (var archivo:bin);
  var
    alumno:regAlumno;
  begin
    reset(archivo);
    while not eof(archivo) do begin
      read(archivo,alumno);
      if ((alumno.finales+4) < alumno.cursadas) then
        listarUnAlumno(alumno);
    end;
    close(archivo);
  end;
procedure desplegarMenu (var masbin,detbin:bin; var mastxt,dettxt:text);
  var
    opcion:integer;
  begin
    writeln('1. Listar el archivo maestro en .txt.');
    writeln('2. Listar el archivo detalle en .txt.');
    writeln('3. Actualizar el maestro con el detalle.');
    writeln('4. Listar el archivo maestro actualizado en .txt.');
    writeln('5. Listar los alumnos que tengan mas de 4 materias sin final.');
    writeln('0. Salir.');writeln();
    write('Opcion: ');readln(opcion);writeln();
    if (opcion<>0) then begin
      case opcion of
        1: exportarTodos(masbin,'reporteAlumnos.txt');
        2: exportarTodos(detbin,'reporteDetalle.txt');
        3: actualizarMaestro(masbin,detbin);
        4: exportarTodos(masbin,'reporteAlumnosActualizado.txt');
        5: materiasSinFinal(masbin);
        else
          writeln('Opcion incorrecta.');writeln();
      end;
      desplegarMenu(masbin,detbin,mastxt,dettxt);
    end;  
  end;
var
  masbin,detbin:bin; mastxt,dettxt:text;
begin
  assign(masbin,'maestrop2ej2.dat');
  assign(detbin,'detallep2ej2.dat');
  assign(mastxt,'maestrop2ej2.txt');
  assign(dettxt,'detallep2ej2.txt');
  crearBinario(masbin,mastxt);
  crearBinario(detbin,dettxt);
  desplegarMenu(masbin,detbin,mastxt,dettxt);
end.
program p2ej2;
type
regAlumno=record
  codigo,cursadas,finales:integer;
  nombre,apellido:string;
end;
bin = file of regAlumno;
procedure crearBinario (var archivo:bin; var txt:text);
  var
    nombre:string; alumno:regAlumno;
  begin
    write('Ingrese el nombre del archivo binario: ');readln(nombre);
    assign(archivo,nombre);
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
procedure
  var

  begin

  end;
procedure
  var

  begin

  end;
procedure
  var

  begin

  end;
procedure
  var

  begin

  end;
procedure
  var

  begin

  end;
var
  masbin,detbin:bin; mastxt,detbin:bin;
begin
  assign(masbin,maestrop2ej2.data);
  assign(masbin,detallep2ej2.data);
  assign(mastxt,maestrop2ej2.txt);
  assign(masbin,detallep2ej2.txt);
  crearBinario(masbin,mastxt);
  crearBinario(detbin,dettxt);
end.
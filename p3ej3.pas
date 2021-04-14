program p3ej3;
const
valoralto = 9999;
type
regNovela=record
  codigo,duracion:integer; precio:real;
  genero,nombre,director:string;
end;
bin = file of regNovela;
procedure leerNovela (var novela:regNovela);
  begin
    with novela do begin
      writeln('Ingrese:');
      write('Codigo: ');readln(codigo);
      if (codigo<>-1) then begin
        write('Nombre: ');readln(nombre);
        write('Genero: ');readln(genero);
        write('Director: ');readln(director);
        write('Duracion: ');readln(duracion);
        write('Precio: ');readln(precio);
      end;
    end;writeln();
  end;
procedure crearArchivo (var archivo:bin);
  var
    novela:regNovela;
  begin
    rewrite(archivo);
    novela.codigo:=0; //cabecera
    write(archivo,novela);
    leerNovela(novela);
    while (novela.codigo<>-1) do begin
      write(archivo,novela);
      leerNovela(novela);
    end;
    close(archivo);
  end;
procedure agregarNovela (var archivo:bin);
  var
    novela:regNovela; pos,posInicio:integer;
  begin    
    reset(archivo);
    read(archivo,novela);
    if (novela.codigo<=0) then begin
      pos:=novela.codigo*(-1);
      seek(archivo,pos);
      read(archivo,novela);
      posInicio:=novela.codigo;
      leerNovela(novela);
      write(archivo,novela);
      seek(archivo,0);
      novela.codigo:=posInicio;
      write(archivo,novela);
    end
    else begin
      seek(archivo,filesize(archivo));
      leerNovela(novela);
      write(archivo,novela);
    end;    
    close(archivo);
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
procedure desplegarMenu (var archivo:bin; var txt:text);
  var
    opcion:integer;
  begin
    writeln('1. Crear el archivo.');
    writeln('2. Dar de alta una novela.');
    writeln('3. Modificar los datos de una novela.');
    writeln('4. Eliminar una novela.');
    writeln('5. Listar las novelas en .txt.');
    writeln('0. Salir.');writeln();
    write('Opcion: ');readln(opcion);writeln();
    if (opcion<>0) then begin
      case opcion of
        1: crearArchivo(archivo);
        2: agregarNovela(archivo);
        3: modificarNovela(archivo);
        4: eliminarNovela(archivo);
        5: exportarTxt(archivo,txt);
        else
          writeln('Opcion incorrecta.');writeln();
      end;
      desplegarMenu(archivo,txt);
    end;  
  end;
var
  archivo:bin;
begin
  assign(archivo,'p3ej3.dat');  
  desplegarMenu();
end.
program p1ej5; //dentro de todo bien, tiene algunos errores de ejecucion
type
regCelular=record
  codigo,stockMin,stockDis,marca:integer;
  nombre,descrip:string;
  precio:real;
end;
txt=text;
bin=file of regCelular;
procedure leerCelular (var celular:regCelular);
  begin
    with celular do begin
      write('Ingrese el codigo de celular: ');readln(codigo);
      if (codigo<>000) then begin
        write('Ingrese el nombre: ');readln(nombre);
        write('Ingrese la marca: ');readln(marca);
        write('Ingrese la descripcion: ');readln(descrip);
        write('Ingrese el precio: ');readln(precio);
        write('Ingrese el stock minimo: ');readln(stockMin);
        write('Ingrese el stock disponible: ');readln(stockDis);
      end;
    end;writeln();
  end;
procedure regATexto (var celular:regCelular; var architxt:txt);
  begin
    write(architxt,celular.codigo);write(architxt,' ');
    write(architxt,celular.precio:6:2);write(architxt,' ');
    write(architxt,celular.marca);write(architxt,' ');
    write(architxt,celular.nombre);write(architxt,' ');    
    write(architxt,sLineBreak);
    write(architxt,celular.stockDis);write(architxt,' ');
    write(architxt,celular.stockMin);write(architxt,' ');
    write(architxt,celular.descrip);write(architxt,' ');
    write(architxt,sLineBreak);
  end;
procedure crearTxt (var architxt:txt);
  var
    celular:regCelular;
  begin    
    leerCelular(celular);
    while (celular.codigo<>000) do begin
      regATexto(celular,architxt);
      leerCelular(celular);
    end;
  end;
procedure crearBinario (var archibin:bin; var architxt:txt);
  var
    nombre:string; celular:regCelular;
  begin
    write('Ingrese el nombre del archivo binario: ');readln(nombre);
    assign(archibin,nombre);
    rewrite(archibin);
    reset(architxt);
    while (not eof(architxt)) do begin
      with celular do begin
        readln(architxt,codigo,precio,marca,nombre);
        readln(architxt,stockDis,stockMin,descrip);
      end;
      write(archibin,celular);
    end;
    close(architxt);
    close(archibin);writeln();
  end;
procedure listarUnCelular (celular:regCelular);
  begin
    with celular do begin
      writeln('Codigo: ',codigo);
      writeln('Marca: ',marca);
      writeln('Nombre: ',nombre);
      writeln('Precio: ',precio:6:2);
      writeln('Descripcion: ',descrip);
      writeln('Stock minimo: ',stockMin);
      writeln('Stock disponible: ',stockDis);writeln();
    end;
  end;
procedure listarCelularesStock (var archibin:bin);
  var
    celular:regCelular;
  begin
    reset(archibin);
    while (not eof(archibin)) do begin
      read(archibin,celular);
      if (celular.stockMin>celular.stockDis) then
        listarUnCelular(celular);
    end;
    close(archibin);
  end;
procedure listarCelularesDescrip (var archibin:bin);
  var
    celular:regCelular;
  begin
    reset(archibin);
    while (not eof(archibin)) do begin
      read(archibin,celular);
      if (celular.descrip<>'') then
        listarUnCelular(celular);
    end;
    close(archibin);
  end;
procedure exportarTodos (var archibin:bin);
  var
    celular:regCelular; txt:text;
  begin
    assign(txt,'celular.txt');
    rewrite(txt);
    reset(archibin);
    while (not eof(archibin)) do begin
      read(archibin,celular);
      regATexto(celular,txt);
    end;
    close(txt);
    close(archibin);
  end;
procedure desplegarMenu (var archibin:bin; var architxt:txt);
  var
    opcion:integer;
  begin
    writeln('1. Crear un archivo de registros.');
    writeln('2. Listar los celulares con stock menor al minimo.');
    writeln('3. Listar los celulares que tengan descripcion.');
    writeln('4. Exportar el archivo de registros a un txt.');
    writeln('0. Salir.');writeln();
    write('Opcion: ');readln(opcion);writeln();
    if (opcion<>0) then begin
      case opcion of
        1: crearBinario(archibin,architxt);
        2: listarCelularesStock(archibin);
        3: listarCelularesDescrip(archibin);
        4: exportarTodos(archibin);
        else
          writeln('Opcion incorrecta.');writeln();
      end;
      desplegarMenu(archibin,architxt);
    end;  
  end;
var
  architxt:txt; archibin:bin;
begin
  assign(architxt,'celulares.txt');
  rewrite(architxt);
  crearTxt(architxt);
  close(architxt);
  desplegarMenu(archibin,architxt);
end.

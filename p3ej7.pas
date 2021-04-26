program p3ej7; //creo que bien
const
valoralto = 9999;
type
reg=record
  codigo:integer;
  nombre,familia,descripcion,zona:string;
end;
bin = file of reg;
procedure leer (var archivo:bin; var especie:reg);
  begin
    if (not eof(archivo)) then
      read(archivo,especie)
    else
      especie.codigo:=valoralto;
  end;
procedure eliminarEspecie (var archivo:bin; codigo:integer);
  var
    especie:reg; pos,posInicio:integer;
  begin
    reset(archivo);    
    read(archivo,especie);
    posInicio:=especie.codigo;
    while (especie.codigo<>codigo) do
      read(archivo,especie);
    pos:=(filepos(archivo)-1)*(-1);
    especie.codigo:=posInicio;
    seek(archivo,filepos(archivo)-1);
    write(archivo,especie);
    seek(archivo,0);
    especie.codigo:=pos;
    write(archivo,especie);
    close(archivo);
  end;
procedure compactar (var archivo:bin);
  var
    especie:reg; cantPosiciones:integer;
  begin
    reset(archivo);
    cantPosiciones:=1;
    leer(archivo,especie);
    while (especie.codigo<>valoralto) do begin
      if (especie.codigo<0) then begin
        posActual:=filepos(archivo)-1;
        seek(archivo,filesize(archivo)-cantPosiciones);
        read(archivo,especie);
        while (especie.codigo < 0) do begin
          seek(archivo,filepos(archivo)-2);
          read(archivo,especie);
        end;
        seek(archivo,posActual);
        write(archivo,especie);
        cantPosiciones:=cantPosiciones+1;
      end;
      leer(archivo,especie);
    end;
    seek(archivo,filepos(archivo)-cantPosiciones);
    truncate(archivo);
    close(archivo);
  end;
var
  archivo:bin; codigo:integer;
begin
  assign(archivo,'p3ej7.dat');
  write('Ingrese el codigo de la especie a eliminar: ');readln(codigo);
  while (codigo<>500000) do begin
    eliminarEspecie(archivo,codigo);
    write('Ingrese el codigo de la especie a eliminar: ');readln(codigo);
  end;
  compactar(archivo);
end.
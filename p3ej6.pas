program p3ej6; //no lo probe pero creo que esta bien
const
valoralto = 9999;
type
regPrenda=record
  codigo,stock:integer;
  descripcion,colores,tipoPrenda:string;
  precio:real;
end;
bin = file of regPrenda;
binDetalle = file of integer;
procedure leerCodigo (var archivo:bin; var codigo:integer);
  begin
    if (not eof(archivo)) then
      read(archivo,codigo)
    else
      codigo:=valoralto;
  end;
procedure actualizarMaestro (var maestro:bin; var detalle:binDetalle);
  var
    prenda:regPrenda; codigo:integer;
  begin
    reset(maestro);
    reset(detalle);
    leerCodigo(detalle,codigo);
    while (codigo<>valoralto) do begin
      read(maestro,prenda);
      while (prenda.codigo<>codigo) do 
        read(maestro,prenda);
      prenda.stock:=-1;
      seek(maestro,filepos(maestro)-1);
      write(maestro,prenda);
      seek(maestro,0);
      leerCodigo(detalle,codigo);
    end;
    close(maestro);
    close(detalle);
  end;
procedure leer (var archivo:bin; var prenda:regPrenda);
  begin
    if (not eof(archivo)) then
      read(archivo,prenda)
    else
      prenda.codigo:=valoralto;
  end;
procedure crearMaestroNuevo (var maestro,maestroNuevo:bin);
  var
    prenda:regPrenda;
  begin
    reset(maestro);
    rewrite(maestroNuevo);
    leer(maestro,prenda);
    while (prenda.codigo<>valoralto) do begin
      if (prenda.codigo>0) then
        write(maestroNuevo,prenda);
      leer(maestro,prenda);
    end;
    close(maestro);
    close(maestroNuevo)
  end;
var
  maestro,maestroNuevo:bin; detalle:binDetalle;
begin
  assign(maestro,'maestrop3ej6.dat');
  assign(maestroNuevo,'maestroNuevop3ej6.dat');
  assign(detalle,'detallep3ej6.dat');
  actualizarMaestro(maestro,detalle);
  crearMaestroNuevo(maestro,maestroNuevo);
end.
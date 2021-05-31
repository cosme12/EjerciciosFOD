program p2ej17;
const
valoralto = 9999;
cantDetalles = 2;
type
regM = record
  codigo,stock:integer
  nombre,descripcion,modelo:string;
end;
regD = record
  codigo:integer; precio:real; fecha:string;
end;
bin = file of regM;
binDetalle = file of regD;
vectorDeDetalles = array [1..cantDetalles] of binDetalle;
vectorDeRegistros = array [1..cantDetalles] of regD;
procedure leer (var archivo:binDetalle; var venta:regD);
  begin
    if (not eof(archivo)) then
      read(archivo,venta)
    else
      venta.codigo:=valoralto;
  end;
procedure minimo (var V:vectorDeDetalles; VR:vectorDeRegistros; var min:regD);
  var
    i,iMin:integer;
  begin
    min.codigo:=valoralto;
    for i:= 1 to cantDetalles do begin
      if (VR[i].codigo < min.codigo) then begin
        min:=VR[i];
        iMin:=i;
      end;
    end;
    leer(V[i],VR[i]);
  end;
procedure procesar (var maestro:bin; var V:vectorDeDetalles, VR:vectorDeRegistros);
  var
    venta:regM; min:regD; i,actualVentas,maxVentas,maxCodigo:integer;
  begin
  maxVentas:=-1;
    reset(maestro);
    for i:= 1 to cantDetalles do begin
      reset(V[i]);
    end;
    minimo(V,VR,min);
    while (min.codigo <> valoralto) do begin
      read(maestro,venta);
      while (venta.codigo <> min.codigo) do //se asume que existe
        read(maestro,venta);
      actualVentas:=0;
      while (min.codigo <> valoralto) and (min.codigo = venta.codigo) do begin
        venta.stock:=venta.stock-1;
        actualVentas:=actualVentas+1;
        minimo(V,VR,min);
      end;
      seek(maestro,filepos(maestro)-1);
      write(maestro,venta);
      if (actualVentas > maxVentas) then begin
        maxVentas:=actualVentas;
        maxCodigo:=venta.codigo;
      end;
    end;
    writeln('El codigo de vehiculo con mas ventas fue: ',maxCodigo);
    close(maestro);
    for i:= 1 to cantDetalles do begin
      close(V[i]);
    end;
  end;
var
  maestro:bin; V:vectorDeDetalles; VR:vectorDeRegistros; i:integer; iString:string;
begin
  for i:= 1 to cantDetalles do begin
    Str(i,iString);
    assign(V[i],'detalle' + iString);
    leer(V[i],VR[i]);
  end;
  assign(maestro,'maestrop2ej17.dat');
  procesar(maestro,V,VR);
end.
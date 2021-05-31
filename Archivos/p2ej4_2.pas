program p2ej4_2; //creo que bien
const
valoralto = 9999;
cantDetalles = 5
type
regM = record
  codig:integer;
  fecha:string;
  tiempoTotal:real;
end;
regD = record
  codigo:integer;
  fecha:string;
  tiempoSesion:real;
end;
bin = file of regM;
binDetalle = file of regD;
vectorDeDetalles = array [1..cantDetalles] of binDetalle;
vectorDeRegistros = array [1..cantDetalles] of regD;
procedure leer (var archivo:binDetalle; var sesion:regD);
  begin
    if (not eof(archivo)) then
      read(archivo,sesion)
    else
      sesion.codigo:=valoralto;
  end;
procedure minimo (var minimo:regD; var V:vectorDeDetalles; VR:vectorDeRegistros);
  var
    i,iMin:integer;
  begin
    minimo.codigo:=valoralto;
    for i:= 1 to cantDetalles do begin
      if (VR[i].codigo <> valoralto) and (VR[i] < minimo.codigo) then begin
        minimo:=VR[i];
        iMin:=i;
      end;        
    end;
    if (minimo.codigo <> valoralto) then
      leer(V[iMin],VR[i]);
  end;
procedure merge (var maestro:bin; var V:vectorDeDetalles; VR:vectorDeRegistros);
  var
    min:regD; actual:regM; i:integer;
  begin
    rewrite(maestro);
    for i:= 1 to cantDetalles do begin
      reset(V[i])
    end;
    minimo(V,VR,min);
    while (min.codigo <> valoralto) do begin
      actual.codigo:=min.codigo;
      actual.tiempoTotal:=0;
      while (min.codigo <> valoralto) and (actual.codigo = min.codigo) do begin
        actual.fecha:=min.fecha;
        while (min.codigo <> valoralto) and (actual.codigo = min.codigo) and (actual.fecha = min.fecha) do begin
          actual.tiempoTotal:=min.tiempoSesion;
          minimo(V,VR,min);
        end;
      end;
      write(maestro,actual);
    end;
    close(maestro);
    for i:= 1 to cantDetalles do begin
      close(V[i])
    end;
  end;
var
  maestro:bin; VD:vectorDeDetalles; VR:vectorDeRegistros; i:integer; iString:string;
begin
  for i:=1 to cantDetalles do begin
    Str(i,iString);
    //assign(V[i],'detalle' + iString);
    Leer(V[i],VR[i]);
  end;
  assign(maestro,'maestrop2ej4_2.dat');
  merge(maestro,VD,VR);
end.
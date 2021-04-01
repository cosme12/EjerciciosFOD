program p2ej4; //no lo compile ni probe. creo que el planteo esta bien
const
valoralto = 9999;
cantDetalles = 5;
type
regSesion=record
  codigo,fecha,tiempoTotal:integer;
end;
regDetalle=record
  codigo,fecha,tiempo:integer;
end;
binDetalle = file of regDetalle;
vectorDeDetalles = array [1..cantDetalles] of binDetalle;
vectorDeRegistros = array [1..cantDetalles] of regDetalle;
procedure leer (var detalle:binDetalle; var producto:regProducto);
  begin
    if (not eof(detalle)) then
      read(detalle,producto)
    else
      producto.codigo:=valoralto;
  end;
procedure minimo (var V:vectorDeDetalles; var min:regDetalle);
  var
    i,iMin,valorMin:integer; Vreg:vectorDeRegistros;
  begin
    valorMin:=9999;
    for i:= 1 to cantDetalles do begin
      leer(V[i],Vreg[i]);
      if (Vreg[i].codigo <> valoralto) & (Vreg[i].codigo > valorMin) then begin
        valorMin:=Vreg[i].codigo;
        iMin:=i;
      end;
    end;
    min:=V[iMin];
    leer(V[iMin],Vreg[iMin]);
  end;
procedure crearMaestro (var maestro:bin; var V:vectorDeDetalles);
  var
    regM:regSesion; regD:regDetalle; i:integer;
  begin
    rewrite(maestro);
    for i:= 1 to cantDetalles do
      reset(V[i]);
    minimo(V,regD);
    while (regD.codigo <> valoralto) do begin
      regM.codigo:=regD.codigo;
      regM.tiempoTotal:=0;
      while (regM.codigo = regD.codigo) do begin
        regM.fecha:=regD.fecha;
        while (regD.codigo = regD.codigo) & (regM.fecha = regD.fecha) do begin
          regM.tiempoTotal:=regM.tiempoTotal + regD.tiempo;
          minimo(V,regD);
        end;        
      end;     
      write(maestro,prodM); 
    end;
    close(maestro);
    for i:= 1 to cantDetalles do
      close(V[i]);
  end;
var
  maestro:bin; V:vectorDeDetalles;
begin
  assign(maestro,'maestrop2ej4.dat');
  crearMaestro(maestro,V);
end.
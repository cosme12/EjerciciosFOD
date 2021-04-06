program p2ej3; //creo que bien pero no se puede probar. compila. al parecer hay que hacerlo usando el procedimiento minmo, no se como seria
//hay que hacer una especie de merge acumulador, para no recorrer el maestro 30 veces
const
valoralto = 9999;
type
regProducto=record
  codigo,stockMin,stockDis:integer; precio:real;
  nombre,descripcion:string;
end;
regDetalle=record
  codigo,cantVendida:integer;
end;
bin = file of regProducto;
binDetalle = file of regDetalle;
vector = array [1..30] of binDetalle;
procedure leer (var detalle:binDetalle; var producto:regDetalle);
  begin
    if (not eof(detalle)) then
      read(detalle,producto)
    else
      producto.codigo:=valoralto;
  end;
{procedure minimo (var V:vectorDeDetalles; var min:regDetalle);
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
procedure mergeAcumulador (var maestro:bin; var V:vectorDeDetalles);
  var
    actual,min:regObjeto; ult:lista;
  begin
    L:=nil;
    minimo(V,min);
    while (min.nombre<>'ZZZ') do begin
      actual.nombre:=min.nombre; actual.monto:=0;
      while (min.nombre<>'ZZZ') and (min.nombre=actual.nombre) do begin
        actual.stockDis:=actual.stockDis+min.cantVendida;
        minimo(V,min);
      end;
      agregarAtras(L,ult,actual);
    end;
  end;}
procedure actualizarMaestro (var maestro:bin; var V:vector);
  var
    prodM:regProducto; prodD:regDetalle; i,aux,total:integer;
  begin
    reset(maestro);    
    read(maestro,prodM);    
    for i:= 1 to 30 do begin 
      reset(V[i]);  
      leer(V[i],prodD); 
      while (prodD.codigo <> valoralto) do begin
        aux:=prodD.codigo;
        total:=0;
        while (aux=prodD.codigo) do begin
          total:=total+prodD.cantVendida;
          leer(V[i],prodD);
        end;
        while (prodM.codigo <> aux) do
          read(maestro,prodM);
        prodM.stockDis:=prodM.stockDis - total;
        seek(maestro,filepos(maestro)-1);
        write(maestro,prodM);
        if (not eof(maestro)) then
          read(maestro,prodM);
      end;
      close(V[i]);
    end;
    close(maestro);    
  end;
var
  maestro:bin; V:vector;
begin
  assign(maestro,'maestrop2ej3.dat');
  actualizarMaestro(maestro,V);
end.
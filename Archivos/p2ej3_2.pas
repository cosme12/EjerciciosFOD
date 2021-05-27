program p2ej3_2; //creo que no esta del todo bien
const
valoralto = 9999;
cantDetalles = 30;
type
regProducto = record
  codigo,stockDis,stockMin:integer;
  nombre,descripcion:string;
  precio:real;
end;
regDetalle = record
  codigo,cantVendida:integer;
end;
binMaestro = file of regProducto;
binDetalle = file of regDetalle;
vectorDeDetalles = array [1..cantDetalles] of binDetalle;
vectorDeRegistros = array [1..cantDetalles] of regDetalle;
procedure leer (var archivo:binDetalle; var producto:regProducto);
  begin
    if (not eof(archivo)) then
      read(archivo,producto)
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
      if (Vreg[i].codigo <> valoralto) & (Vreg[i].codigo < valorMin) then begin
        valorMin:=Vreg[i].codigo;
        iMin:=i;
      end;
    end;
    min:=V[iMin];
    leer(V[iMin],Vreg[iMin]);
  end;
procedure regATexto (producto:regProducto; var txt:text);
  begin
    write(txt,'Nombre: ');write(txt,producto.nombre);write(txt,'\n');
    write(txt,'Descripcion: ');write(txt,producto.descripcion);write(txt,'\n');
    write(txt,'Stock: ');write(txt,producto.stockDis);write(txt,'\n');
    write(txt,'Precio: ');write(txt,producto.precio);write(txt,'\n');
    write(txt,'\n');   
  end;
procedure procesar (var maestro:binMaestro; var V:vectorDeDetalles; var txt:text);
  var
    i:integer; min:regDetalle; prodM:regProducto;
  begin    
    minimo(V,min);    
    while (min.codigo <> valoralto) do begin
      read(maestro,prodM);
      while (min.codigo <> valoralto and min.codigo = prodM.codigo) do begin
        prodM.stockDis:=prodM.stockDis - min.cantVendida;
        seek(maestro,filepos(maestro)-1);
        write(maestro,prodM);
        if (prodM.stockDis < prodM.stockMin) then
          regATexto(prodM,txt);
        minimo(V,min);        
      end;            
    end;    
  end;
var
  V:vectorDeDetalles; maestro:binMaestro; txt:text;
begin
  //faltan los assign
  reset(maestro);
  for i:= 1 to cantDetalles begin
    reset(V[i]);
  end;
  procesar(maestro,V,txt);
  close(maestro);
  for i:= 1 to cantDetalles begin
    close(V[i]);
  end;
end.
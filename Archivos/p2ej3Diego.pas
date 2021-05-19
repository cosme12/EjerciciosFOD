program tp2ej1.pas;


type 
  regProducto=record
	codigo,stockMin,stockDis:integer; 
	precio:real;
	nombre,descripcion:string;
  end;
  
  regDetalle=record
    codigo,cantVendida:integer;
  end;
  
  bin = file of regProducto;
  binDetalle = file of regDetalle;

  vector = array [1..30] of binDetalle; //Vector de archivos
  vecRegDetalle = array [1..30] of regDetalle; //Para guardar el codigo minimo




{------------------------------------------------------------}

procedure Leer(var detalle: binDetalle; var d: regDetalle);
begin
    if(not EOF(detalle)) then
        read(detalle, d)
    else
        d.codigo:= 9999;
end;

{------------------------------------------------------------}



procedure minimo(var vectorArc: vector; var vectorReg: vecRegDetalle; var min: regDetalle);
var
    i,minPos: integer;
begin
    min.codigo:= 9999;
    for i:=1 to 30 do begin
        if (vectorReg[i].codigo < min.codigo) then begin
            min:=vectorReg[i];
            minPos:=i;
        end;
    end;
    if (min.codigo <> 9999) then
        Leer(vectorArc[minPos], vectorReg[minPos]); //Guardo el primer producto detalle de los 30 archivos detalle
end;



procedure actualizarMaestro (var maestro: bin; var V:vector; var vectorReg:vecRegDetalle);
var
    prodM: regProducto;
    i: integer;
    min: regDetalle;
begin
    minimo(V, vectorReg, min);//busco el codigo minimo entre los archivos detalles
    while (min.codigo <> 9999) do begin //mientras el archivo detalle no termine
        read(maestro, prodM);
        while(prodM.codigo <> min.codigo) do
            read(maestro, prodM);
        while(prodM.codigo = min.codigo) do begin
            prodM.stockDis:= prodM.stockDis - min.cantVendida;
            minimo(V, vectorReg, min);
        end;
        seek(maestro, filepos(maestro)-1);
        write(maestro, prodM);
    end;
    close(maestro);
    for i:=1 to 30 do begin
        close(V[i]);
    end;
end;




{
procedure actualizarMaestro (var maestro:bin; var V:vector);
var
  p: regProducto;
  d, d_ant: regDetalle;
begin  
  for i:=1 to 30 do begin
    reset(maestro);
    reset(V[i], 'detalle'+ str(i));
	if (not eof(V[i])) then
      read(V[i], d);
    while (not eof(V[i]) do begin
      d_ant := d;
      d_ant.cantVendida := 0;
      while (not eof(V[i]) and (d.codigo = d_ant.codigo)) do begin
        d_ant.cantVendida := d_ant.cantVendida + d.cantVendida;
        read(V[i], d);
      end;
      read(maestro, p);
      while (not eof(maestro) and (p.codigo <> d_ant.codigo)) do begin
        read(maestro, p);
      end;
      if (p.codigo == d_ant.codigo) then begin
        p.stockDis := p.stockDis - d_ant.cantVendida;
        seek(maestro, filepos(maestro)-1);
        write(maestro, p);
      end;
    end;
    close(V[i]);
    close(maestro);
  end; 
end;
}



var
  i:integer;
  maestro:bin; 
  V:vector;  // vector de archivos
  vectorReg:vecRegDetalle; //vector de registros
  iString:String;

BEGIN 
  for i:=1 to 30 do begin
    Str(i,iString);
    assign(V[i],'detalle' + iString);
    reset(V[i]); //habilito lectura todos los archivos
    Leer(V[i],vectorReg[i]);
  end;
  assign(maestro, 'maestrop2ej3.dat');
  actualizarMaestro(maestro, V, vectorReg);
  
END.

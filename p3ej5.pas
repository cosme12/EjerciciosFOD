program p3ej5; //no lo probe pero creo que bien
type
bin = file of string;
function valorEntero (texto:string):integer;
  var
    valor,codigoError:integer;
  begin
    valor:=0;
    val(texto,valor,codigoError);
    valorEntero:=valor;
  end;
procedure agregar (var archivo:bin); 
  var
    titulo:string; pos,posInicio:integer;
  begin    
    reset(archivo);
    read(archivo,titulo);
    if (valorEntero(titulo)<>0) then begin
      pos:=valorEntero(titulo);
      seek(archivo,pos);
      read(archivo,titulo);
      posInicio:=titulo;
      write('Ingrese el titulo a agregar: ');readln(titulo);
      write(archivo,titulo);
      seek(archivo,0);
      titulo:=posInicio;
      write(archivo,titulo);
    end
    else begin
      seek(archivo,filesize(archivo));
      write('Ingrese el titulo a agregar: ');readln(titulo);
      write(archivo,titulo);
    end;    
    close(archivo);
  end;
procedure eliminar (var archivo:bin); //hasta la linea 46 creo que esta bien, lo demas falta
  var
    titulo,tituloAEliminar:string; pos,posInicio:integer;
  begin
    reset(archivo);
    write('Ingrese el titulo a eliminar: ');readln(tituloAEliminar);
    read(archivo,titulo);
    posInicio:=valorEntero(titulo);
    while (titulo<>tituloAEliminar) do
      read(archivo,titulo);
    pos:=(filepos(archivo)-1)*(-1);
    titulo.codigo:=posInicio;
    seek(archivo,filepos(archivo)-1);
    write(archivo,titulo);
    seek(archivo,0);
    titulo.codigo:=pos;
    write(archivo,titulo);
    close(archivo);
  end;
procedure listar (var archivo:bin);
  var
    titulo:string;
  begin
    reset(archivo);
    read(archivo,titulo);
    while (not eof(archivo)) do begin
      if (valorEntero(titulo)=0 and titulo<>'0') then
        writeln('Titulo: ',titulo);
      read(archivo,titulo);
    end;
    close(archivo);
  end;
var

begin

end.
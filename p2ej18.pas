program p2ej18; //no lo probe. creo que bien
const
cantSectores = 5;
valoralto = 'ZZZZ';
type
arregloDeEnteros = array [1..cantSectores] of integer;
regFuncion=record
  nombre:string; fecha,sector:integer;
  entradas:arregloDeEnteros;
end;
bin = file of regFuncion;
lista=^nodo;
nodo=record
  dato:regFuncion;
  sig:lista;
end;
regEvento=record;
  nombre:string;
  funciones:lista;
end;
procedure leer (var arhcivo:bin; var funcion:regFuncion);
  begin
    if (not eof(archivo)) then
      read(archivo,funcion)
    else
      funcion.codigo:=valoralto;
  end;
procedure agregarAtras (var L,ult:lista; objeto:regObjeto);
  var
    aux:lista;
  begin
    new(aux); aux^.dato:=objeto; aux^.sig:=nil;
    if (L=nil) then
      L:=aux
    else
      ult^.sig:=aux;
    ult:=aux;
  end;
procedure imprimirEvento (evento:regEvento; totalFuncion,totalEvento:integer);
  var
    i:integer; aux:lista;
  begin
    aux:=evento.funciones;
    writeln('Nombre: ',evento.nombre);writeln();
    while (aux <> nil) do begin
      writeln('Fecha funcion: ',aux^.dato.fecha);
      for i:= 1 to cantSectores do begin
        writeln('Sector ',i,': ',aux^.dato.entradas[i],' entradas.');
      end;writeln();
      writeln('Entradas totales de la funcion: ',totalFuncion);writeln();
      aux:=aux^.sig;
    end;
    writeln('Entradas totales del evento: ',totalEvento);writeln();
  end;
procedure procesar (var archivo:bin);
  var
    funcion:regFuncion; i,fechaActual,totalFuncion,totalEvento:integer; evento:regEvento; ult:lista;
  begin
    reset(archivo);
    leer(archivo,funcion);
    while (funcion.nombre <> valoralto) do begin
      evento.funciones:=nil;
      evento.nombre:=funcion.nombre;
      totalEvento:=0;
      while (funcion.nombre <> valoralto) & (evento.nombre=funcion.nombre) do begin
        fechaActual:=funcion.fecha;
        totalFuncion:=0;
        while (funcion.nombre <> valoralto) & (evento.nombre=funcion.nombre) & (fechaActual=funcion.fecha) do begin
          for i:= 1 to cantSectores do begin
            totalFuncion:=totalFuncion+funcion.entradas[i];
          end;
          leer(archivo,funcion);
        end;
        agregarAtras(evento.funciones,ult,funcion);
        totalEvento:=totalEvento+totalFuncion;
      end;
      imprimirEvento(evento,totalFuncion,totalEvento);
    end;
    close(arhivo);
  end;
var
  archivo:bin;
begin
  assign(archivo,'archivop2ej18.dat');
  procesar(archivo);
end.
program modulosPascal;
const
cant=100;
type
rango=1..cant;
regObjeto=record
  campo:integer;
  campo1:string;
  campo2:real;
end;
lista=^nodo;
nodo=record
  dato:regObjeto;
  sig:lista;
end;
arbol=^nodoArbol;
nodoArbol=record
  dato:regObjeto;
  hi,hd:arbol;
end;
elemento=record;
  L:lista;
  ult:lista;
end;
vector=array [rango] of regObjeto;
vectorDeListas=array [rango] of elemento; // para agregar atras
vectorDeListas=array [rango] of lista; // para insertar ordenado
procedure leer (var );
  begin
    with  do begin
      write(': ');readln();
      if (<>) then begin
        write(': ');readln();
        write(': ');readln();
      end;
    end;writeln();
  end;
procedure regATexto (var celular:regCelular; var architxt:txt); //.txt con formato de 2 lineas
  begin
    write(architxt,celular.codigo);write(architxt,' ');
    write(architxt,celular.precio:6:2);write(architxt,' ');
    write(architxt,celular.marca);write(architxt,' ');
    write(architxt,celular.nombre);write(architxt,' ');    
    write(architxt,sLineBreak);
    write(architxt,celular.stockDis);write(architxt,' ');
    write(architxt,celular.stockMin);write(architxt,' ');
    write(architxt,celular.descrip);write(architxt,' ');
    write(architxt,sLineBreak);
  end;
procedure crearTxt (var architxt:txt); //falta abrir y cerrar el archivo en main
  var
    celular:regCelular;
  begin    
    leerCelular(celular);
    while (celular.codigo<>000) do begin
      regATexto(celular,architxt);
      leerCelular(celular);
    end;
  end;
procedure crearBinario (var archivo:bin; var txt:text); //archivo de registros a partir de .txt
  var
    nombre:string; celular:regCelular;
  begin
    write('Ingrese el nombre del archivo binario: ');readln(nombre);
    assign(archivo,nombre);
    rewrite(archivo);
    reset(txt);
    while (not eof(txt)) do begin
      with celular do begin
        readln(txt,codigo,precio,marca,nombre);
        readln(txt,stockDis,stockMin,descrip);
      end;
      write(archivo,celular);
    end;
    close(txt);
    close(archivo);writeln();
  end;
procedure exportarTodos (var archibin:bin); //exportar binario a .txt
  var
    celular:regCelular; txt:text;
  begin
    assign(txt,'celular.txt');
    rewrite(txt);
    reset(archibin);
    while (not eof(archibin)) do begin
      read(archibin,celular);
      regATexto(celular,txt);
    end;
    close(txt);
    close(archibin);
  end;
procedure insertar (var A:arbol; objeto:regObjeto);   // crear arbol
  begin
    if (A=nil) then begin
      new(A); A^.dato:=objeto; A^.hi:=nil; A^.hd:=nil;
    end
    else begin
      if (objeto.campo<A^.dato.campo) then
        insertar(A^.hi,objeto)
      else
        insertar(A^.hd,objeto);
    end;
  end;
procedure imprimirEnOrden (A:arbol);  //imprimir arbol en orden. para orden decreciente, intercambiar 'hi' por 'hd'
begin
  if (A<>nil) then begin
    imprimirEnOrden(A^.hi);
    writeln(A^.dato);
    imprimirEnOrden(A^.hd);
  end;
end;
procedure busquedaAcotada (A:arbol; inf,sup:integer);  //arbol
  begin
    if (A<>nil) then begin
      if (A^.dato>=inf) and (A^.dato<=sup) then begin
        writeln(A^.dato);
        busquedaAcotada(A^.hi,inf,sup);
        busquedaAcotada(A^.hd,inf,sup);
      end
      else begin
        if (A^.dato.legajo<inf) then
          busquedaAcotada(A^.hd,inf,sup)
        else
          busquedaAcotada(A^.hi,inf,sup);
      end;
    end;
  end; 
procedure minimo (var V:vectorDeListas; var min:regObjeto);
  var
    i,imin:integer;
  begin
    min.nombre:='ZZZ';
    for i:= 1 to cant do begin  //cant = cantidad de listas 
      if (V[i]<>nil) and (V[i]^.dato.nombre<min.nombre) then begin
        min.nombre:=V[i]^.dato.nombre;
        imin:=i;
      end;
    end;
    if (min.nombre<>'ZZZ') then begin
      min.monto:=V[imin]^.dato.monto;
      V[imin]:=V[imin]^.sig;
    end;
  end;
procedure merge (V:vectorDeListas; var L:lista);
  var
    min:regPeli; ult:lista;
  begin
    L:=nil;
    minimo(V,min);
    while (min.codPeli<>32000) do begin
      agregarAtras(L,ult,min);
      minimo(V,min);
    end;
  end;
procedure mergeAcumulador (V:vectorDeListas; var L:lista);
  var
    actual,min:regObjeto; ult:lista;
  begin
    L:=nil;
    minimo(V,min);
    while (min.nombre<>'ZZZ') do begin
      actual.nombre:=min.nombre; actual.monto:=0;
      while (min.nombre<>'ZZZ') and (min.nombre=actual.nombre) do begin
        actual.monto:=actual.monto+min.monto;
        minimo(V,min);
      end;
      agregarAtras(L,ult,actual);
    end;
  end;
procedure agregarAdelante (var L:lista;  // lista
objeto:regObjeto);
  var
    aux:lista;
  begin
    new(aux);
    aux^.dato:=objeto;
    aux^.sig:=L;
    L:=aux;
  end;
procedure agregarAtras (var L,ult:lista; objeto:regObjeto); // lista
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
procedure agregarAtras (var V:vector; var dimL:integer; // vector
  dimF:integer; objeto:regObjeto);
  begin
    if ((dimL+1)<=dimF) then begin
      dimL:=dimL+1;
      V[dimL]:=objeto;
    end;
  end;
procedure insertarOrdenado (var L:lista; objeto:regObjeto); // lista
  var
    aux,ant,act:lista;
  begin
    new(aux); aux^.dato:=objeto; aux^.sig:=nil;
    ant:=L; act:=L;
    while (act<>nil) and (objeto.campo>act^.dato.campo) do begin
      ant:=act;
      act:=act^.sig;
    end;
    if (ant=act) then
      L:=aux
    else
      ant^.sig:=aux;
    aux^.sig:=act;
  end;
procedure insertar (var V:vector; // vector
var dimL:integer; dimF,pos:integer; objeto:regObjeto);
  var
    i:integer;
  begin
    if (((dimL+1)<=dimF) and (pos<=dimL) and
    (pos>=1)) then begin
      for i:= dimL downto pos do
        V[i+1]:=V[i];
      V[pos]:=objeto;
      dimL:=dimL+1;
    end;
  end;
procedure cargarVector (var V:vectorDeListas); // vector de listas agrupadas segun 'campo'
  var
    objeto:regObjeto;
  begin
    leer(objeto);
    while (objeto.campo<>-1) do begin
      agregarAtras(V[objeto.campo].L,V[objeto.campo].ult,objeto);
      insertarOrdenado(V[objeto.campo],objeto);
      leer(peli);
    end;
  end;
procedure imprimirLista (L:lista);
  var
    aux:lista;
  begin
    aux:=L;
    while (aux<>nil) do begin
      writeln(aux^.dato.campo);
      aux:=aux^.sig;
    end;
  end;
procedure imprimirVector (V:vector; dimL:integer);
  var
    i:integer;
  begin
    for i:= 1 to dimL do begin
      writeln(V[i].campo);
    end;
  end;
procedure eliminar (var V:vector;  // vector
var dimL:integer; pos:integer);
  var
    i:integer;
  begin
    if ((pos>=1) and (pos<=dimL)) then begin
      for i:= pos to (dimL-1) do
        V[i]:=V[i+1];
      dimL:=dimL-1;
    end;
  end;
procedure eliminar (var L:lista; objeto:regObjeto);  // lista
  var
    ant,act:lista;
  begin
    ant:=L; act:=L;
    while (act<>nil) and (objeto.campo<>act^.dato.campo) do begin
      ant:=act; act:=act^.sig;
    end;
    if (act<>nil) then begin
      if (act=L) then
        L:=L^.sig
      else
        ant^.sig:=act^.sig;
      dispose(act);
    end;
  end;
procedure ordenarVector (var V:vector;   // seleccion
dimL:integer);
  var
    i,j,p:integer; actual:regObjeto;
  begin
    for i:= 1 to dimL do begin
      p:=i;
      for j:= (i+1) to dimL do begin
        if (V[j].campo<V[p].campo) then
          p:=j;
      end;
      actual:=V[p];
      V[p]:=V[i];
      V[i]:=actual;
    end;
  end;
procedure ordenarVector (var V:vector; dimL:integer);  // insercion
  var
    i,j:integer; actual:regObjeto;
  begin
    for i:= 2 to dimL do begin
      actual:=V[i];
      j:=i-1;
      while (j>0) and (V[j].campo>actual.campo) do begin
        V[j+1]:=V[j];
        j:=j-1;
      end;
      V[j+1]:=actual;
    end;
  end;
function buscarVectorDesordenado (vector:arreglo;
dimL,dato:integer):boolean;
  var
    pos:integer; esta:boolean;
  begin
    pos:=1; esta:=false;
    while ((pos<=dimL) and (not esta)) do begin
      if (vector[pos]=dato) then
        esta:=true
      else
        pos:=pos+1;
    end;
    buscarVectorDesordenado:=esta;
  end;
function buscarVectorOrdenadoMejorada (vector:arreglo;
dimL,dato:integer):boolean;
  var
    pos:integer; esta:boolean;
  begin
    pos:=1; esta:=false;
    while ((pos<=dimL) and (vector[pos]<dato)) do
      pos:=pos+1;
    if ((pos<=dimL) and (vector[pos]=dato)) then
      esta:=true;
    buscarVectorOrdenadoMejorada:=esta;
  end;
function buscarVectorOrdenadoDicotomica (vector:arreglo;
dimL,dato:integer):boolean;
  var
    pri,medio,ult:integer; esta:boolean;
  begin
    pri:=1; ult:=dimL; esta:=false;
    medio:=(pri+ult) div 2;
    while ((pri<=ult) and (dato<>vector[medio])) do begin
      if (dato<vector[medio]) then
        ult:=medio-1
      else
        pri:=medio+1;
      medio:=(pri+ult) div 2;
    end;
    if ((pri<=ult) and (dato=vector[medio])) then
      esta:=true;
    buscarVectorOrdenadoDicotomica:=esta;
  end;
procedure busquedaDicotomica (V:vector; var ini,fin,pos:integer; codigo:integer);  //recursiva
  var
    medio:integer;
  begin
    medio:=(ini+fin) div 2;
    if (ini<=fin) then begin
      if (codigo = V[medio].codigo) then
        pos:=medio
      else begin
        if (codigo < V[medio].codigo) then
          ini:=medio-1
        else begin
          if (codigo > V[medio].codigo) then
            fin:=medio+1;
        end;
        busquedaDicotomica(V,ini,fin,pos,codigo);
      end;
    end
    else
      pos:=-1;
  end;
function buscarDesordenadoLista (L:lista;
valor:integer):boolean;
  var
    act:lista; esta:boolean;
  begin
    act:=L; esta:=false;
    while (act<>nil) and (esta=false) do begin
      if (valor=act^.dato.valor) then
        esta:=true
      else
        act:=act^.sig;
    end;
    buscarDesordenadoLista:=esta;
  end;
function buscarOrdenadoLista (L:lista;
valor:integer):boolean;
  var
    act:lista; esta:boolean;
  begin
    act:=L; esta:=false;
    while (act<>nil) and (valor>act^.dato.valor) do begin
      act:=act^.sig;
    end;
    if (act<>nil) and (valor=act^.dato.valor) then
      esta:=true;
    buscarOrdenadoLista:=esta;
  end;
procedure
  var

  begin

  end;
procedure
  var

  begin

  end;
procedure
  var

  begin

  end;
var

begin

end.


























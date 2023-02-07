%Funci�n que nos ayuda a obtener un nuevo individuo recalculado si el
%individuo pasado como par�metro sobrepasa algunos de los l�mites establecidos en alguna dimensi�n de este.

%En donde requerimos como par�metro los siguientes valores:

%Individuo: El individuo a penalizar.
%M�nimo: El l�mite m�nimo permitido.
%M�ximo: El l�mite m�ximo permitido.
%Dimensi�n: El n�mero de dimensiones que el individuo tiene.

%Retornamos un nuevo individuo recalculado si, y solo si, el individuo sobrepasa, en alguna dimensi�n, un l�mite.


function IndividuoRecalculado = Penalizacion(Individuo,Minimo,Maximo, Dimension)

    %Creamos e inicializamos el valor del nuevo individuo recalculado:
    IndividuoRecalculado = zeros(Dimension,1); %Tomar� el mismo tama�o que el individuo.
    
    %Creamos un for para iterar cada dimensi�n del Individuo.
    for i = 1: Dimension
        if Minimo(i) > Individuo(i)  || Individuo(i) > Maximo(i) %Si el individuo sobrepasa alg�n limite, entonces en IndividuoRecalculado recalculamos una nueva posici�n v�lida:
            IndividuoRecalculado(i) = randi([Minimo(i) Maximo(i)]);
        else %Sino, pasamos el valor del individuo tal cual pero casteado a entero (ya que como recordaremos, tenemos solamente posiciones enteras en las im�genes):
            IndividuoRecalculado(i) = int32(Individuo(i));
        end
    end

end
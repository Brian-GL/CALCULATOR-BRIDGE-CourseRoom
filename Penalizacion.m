%funci�n que nos ayuda a obtener el valor de g(xj) para la penalizaci�n de una funci�n. Utilizando el segundo m�todo.
%En donde:

%g es el valor de retorno de la funci�n g(xj) dependiendo de los siguientes valores:

%x representa el valor de x en la funci�n (el conjunto de xj)
%xl representa el l�mite m�nimo aceptable de la funci�n (el conjunto de l�mites de xlj).
%xu representa el l�mite m�nimo aceptable de la funci�n (el conjunto de l�mites de xuj).

function g = Penalizacion(x,xl,xu)
    g = 0; %Inicializamos el valor de retorno en cero, ya que es una sumatoria lo que regresamos.
    Dimension = numel(xl); %Dimensi�n representa la misma dimensi�n del problema (cuantos xj existen)(es M si lo representamos con la f�rmula original).
    
    for j = 1: Dimension %Generamos un for para cada dimensi�n
        
        if xl(j) < x(j)
            g = g + 0;
        else
            g = g + (xl(j) - x(j))  ^2;
        end
        
        if  x(j) < xu(j)
            g = g + 0;
        else
            g = g + (xu(j) - x(j)) ^2;
        end 
        
    end
end
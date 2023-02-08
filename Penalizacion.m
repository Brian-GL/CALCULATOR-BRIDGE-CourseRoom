%función que nos ayuda a obtener el valor de g(xj) para la penalización de una función. Utilizando el segundo método.
%En donde:

%g es el valor de retorno de la función g(xj) dependiendo de los siguientes valores:

%x representa el valor de x en la función (el conjunto de xj)
%xl representa el límite mínimo aceptable de la función (el conjunto de límites de xlj).
%xu representa el límite mínimo aceptable de la función (el conjunto de límites de xuj).

function g = Penalizacion(x,xl,xu)
    g = 0; %Inicializamos el valor de retorno en cero, ya que es una sumatoria lo que regresamos.
    Dimension = numel(xl); %Dimensión representa la misma dimensión del problema (cuantos xj existen)(es M si lo representamos con la fórmula original).
    
    for j = 1: Dimension %Generamos un for para cada dimensión
        
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
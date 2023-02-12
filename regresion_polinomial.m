function [Codigo, Mensaje, Resultado] = regresion_polinomial(X, Y)

    try
        
        %Validar los tamaños de 'x' & 'y':
    
        TamanoX = size(X,2);
        TamanoY = size(Y,2);
    
        if TamanoX ~= TamanoY || TamanoX < 2
            Codigo = 0;
            Mensaje = "El tamaño del arreglo 'x' es desigual al tamaño del arreglo 'y', o bien el tamaño es menor la mínimo permitido (2)";
            Resultado = 0;
        else

            %Definimos por defecto el número de dimensiones a utilizar (que a su vez será el mismo valor del grado de nuestro polinomio):

            if TamanoX >= 5
                Dimension =  4; %Nuestra dimensión máxima será de 4
            else
                Dimension = TamanoX - 1;
            end
            
            %Crear el sistema de ecuaciones dinámicamente:
            MatrizDeCoeficientes = zeros(Dimension,Dimension); 
            Igualaciones = zeros(Dimension, 1); 
        
            %Variable auxiliar para llenar las matrices dinámicamente:
            k = 0;
        
            %Crear los valores mínimos y máximos en una matriz de 1 x Dimension respectivamente:
            Minimo = zeros(Dimension,1);
            Maximo = zeros(Dimension,1);

            %Llenar las matrices, los valores mínimos y máximos:
            for i = 1:Dimension
                for j = 1:Dimension
                    MatrizDeCoeficientes(i,j) = sum(X.^((j-1)+k));
                end
                Igualaciones(i,1) = sum(Y.*X.^k);
                Minimo(i,1) = -1000;
                Maximo(i,1) = 1000;
                k = k + 1;
            end
        
            %Establecemos el tamaño del sistema en una variable, la llamaremos tam;
            tam = size(Igualaciones,1);
        
            %Establecemos primero una función auxiliar que nos ayudará a multiplicar la matriz de coeficientes por un parámetro 'w'.
            FuncionAuxiliar = @(w) MatrizDeCoeficientes * w;
            
            %Ahora, establecemos nuestra función objetivo de la siguiente manera:
            %En donde calculamos el error entre las igualaciones y el individuo 'z', utilizando la fórmula: 1/2m sum i = 0; hasta i < m  de (ei^2);
            FuncionObjetivo = @(z) (0.5/tam) * sum((Igualaciones - FuncionAuxiliar(z)).^2);
        
            NumeroDeIndividuos = 50;
            NumeroDeIteraciones = 50;
            ParametroDePaso = 1.5;
            CriterioDeProbabilidad = 0.6; %en este caso el criterio de probabilidad esta entre 0.5, ya que en este algoritmo la polinización local (algoritmo de evolución diferencial) genera resultados muy favorables, por lo que es de suma importancia que este método se realize constantemente.
            FactorDeAmplificacion = 1.2;
            ConstanteDeRecombinacion = 0.9;
        
            Solucion = PolinizacionEvolutiva(FuncionObjetivo,NumeroDeIteraciones,NumeroDeIndividuos, Minimo, Maximo, Dimension, ParametroDePaso, CriterioDeProbabilidad ,FactorDeAmplificacion,ConstanteDeRecombinacion);

            RegresionPolinomial = '';
            RegresionPolinomial = strcat(RegresionPolinomial,num2str(Solucion(1)));
            for i = 2:Dimension
                if sign(Solucion(i)) == 1
                    RegresionPolinomial = strcat(RegresionPolinomial," + ",num2str(Solucion(i)),"x^",num2str(i-1));
                elseif sign(Solucion(i)) == -1
                    RegresionPolinomial = strcat(RegresionPolinomial," ",num2str(Solucion(i)),"x^",num2str(i-1));
                end
            end

            modelo = poly2sym(flipud(Solucion));
            f = matlabFunction(modelo);

            Codigo = 1;
            Mensaje = RegresionPolinomial;
            Resultado = f(TamanoX+1);

        end
    catch e
        Codigo = -1;
        Mensaje = e.message;
        Resultado = 0;
    end
end




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

            %Definimos por defecto el número de dimensiones a utilizar para la regresión polinomial (que a su vez será el mismo valor del grado de nuestro polinomio):

            if TamanoX >= 5
                DimensionPolinomial =  4; %Nuestra dimensión máxima será de 4
            else
                DimensionPolinomial = TamanoX - 1;
            end

            %Definimos el número de dimensiones de la regresión lineal, que por defecto será igual a 2:
            DimensionLineal = 2;
            
            %Crear el sistema de ecuaciones dinámicamente para la regresión polinomial:
            MatrizDeCoeficientes = zeros(DimensionPolinomial,DimensionPolinomial); 
            Igualaciones = zeros(DimensionPolinomial, 1); 
        
            %Variable auxiliar para llenar las matrices dinámicamente:
            k = 0;
        
            %Crear los valores mínimos y máximos en una matriz de 1 x DimensionPolinomial respectivamente para la regresión polinomial:
            MinimoPolinomial = zeros(DimensionPolinomial,1);
            MaximoPolinomial = zeros(DimensionPolinomial,1);

            %Crear los valores máximo y mínimo para la regresión lineal:
            MinimoLineal = [-100;-100];
            MaximoLineal = [100;100];

            %Llenar las matrices, los valores mínimos y máximos:
            for i = 1:DimensionPolinomial
                for j = 1:DimensionPolinomial
                    MatrizDeCoeficientes(i,j) = sum(X.^((j-1)+k));
                end
                Igualaciones(i,1) = sum(Y.*X.^k);
                MinimoPolinomial(i,1) = -10000;
                MaximoPolinomial(i,1) = 10000;
                k = k + 1;
            end
        
            %Establecemos el tamaño del sistema en una variable, la llamaremos tam;
            tam = size(Igualaciones,1);
        
            %Establecemos primero una función auxiliar que nos ayudará a
            %multiplicar la matriz de coeficientes por un parámetro 'w' para la regresión polinomial:
            FuncionAuxiliar = @(w) MatrizDeCoeficientes * w;
            
            %Ahora, establecemos nuestra función objetivo de la siguiente manera:
            %En donde calculamos el error entre las igualaciones y el individuo 'z', utilizando la fórmula: 1/2m sum i = 0; hasta i < m  de (ei^2);
            FuncionObjetivoPolinomial = @(z) (0.5/tam) * sum((Igualaciones - FuncionAuxiliar(z)).^2);

            %Generamos la función objetivo para la regresión lineal basándonos en el promedio de errores de los puntos:
            FuncionObjetivoLineal = @(z) (1/(2*TamanoY)) *(sum((Y-(z(1)*X+z(2))).^2));
        
            %Establecemos los valores por defecto necesarios para el algoritmo de polinización evolutiva de la solución para la regresión polinomial:
            NumeroDeIndividuos = 50;
            NumeroDeIteraciones = 75;
            ParametroDePaso = 1.5;
            CriterioDeProbabilidad = 0.6; %en este caso el criterio de probabilidad esta entre 0.5, ya que en este algoritmo la polinización local (algoritmo de evolución diferencial) genera resultados muy favorables, por lo que es de suma importancia que este método se realize constantemente.
            FactorDeAmplificacion = 1.2;
            ConstanteDeRecombinacion = 0.9;
        
            %Llamar al algoritmo de polinización evolutiva para resolver la regresión polinomial:
            SolucionPolinomial = PolinizacionEvolutiva(FuncionObjetivoPolinomial,NumeroDeIteraciones,NumeroDeIndividuos, MinimoPolinomial, MaximoPolinomial, DimensionPolinomial, ParametroDePaso, CriterioDeProbabilidad ,FactorDeAmplificacion,ConstanteDeRecombinacion);

            %Llamar al algoritmo de polinización evolutiva para resolver la regresión lineal:
            SolucionLineal = PolinizacionEvolutiva(FuncionObjetivoLineal,NumeroDeIteraciones, NumeroDeIndividuos, MinimoLineal, MaximoLineal, DimensionLineal, ParametroDePaso, CriterioDeProbabilidad ,FactorDeAmplificacion,ConstanteDeRecombinacion);
            
            % Generar la ecuación de regresión polinomial:
            RegresionPolinomial = '';
            RegresionPolinomial = strcat(RegresionPolinomial,num2str(SolucionPolinomial(1)));
            for i = 2:DimensionPolinomial
                if sign(SolucionPolinomial(i)) == 1
                    RegresionPolinomial = strcat(RegresionPolinomial," + ",num2str(SolucionPolinomial(i)),"x^",num2str(i-1));
                elseif sign(SolucionPolinomial(i)) == -1
                    RegresionPolinomial = strcat(RegresionPolinomial," ",num2str(SolucionPolinomial(i)),"x^",num2str(i-1));
                end
            end

            % Generar la ecuación de regresión lineal:
            RegresionLineal = strcat(num2str(SolucionLineal(1)),"x + ",num2str(SolucionLineal(2)));

            modelo = poly2sym(flipud(SolucionPolinomial));

            % Generar las funciones de regresión para evaluar:
            FuncionPolinomial = matlabFunction(modelo);
            FuncionLineal = @(x) SolucionLineal(1) * x + SolucionLineal(2);

            ResultadoPolinomial = 0;
            % Obtener las evaluaciones:
            if DimensionPolinomial > 2
                ResultadoPolinomial = FuncionPolinomial(TamanoX+1);
            else
                ResultadoPolinomial = SolucionPolinomial(1);
            end

            ResultadoLineal = FuncionLineal(TamanoX+1);

            % Obtener el punto medio entre las evaluaciones como resultado:
            PuntoMedio = (ResultadoPolinomial + ResultadoLineal).'/2;

            Codigo = 1;
            Mensaje = strcat("Regresión Polinomial: ",RegresionPolinomial,' | Regresión Lineal: ', RegresionLineal);
            Resultado = PuntoMedio;

        end
    catch e
        Codigo = -1;
        Mensaje = e.message;
        Resultado = 0;
    end
end



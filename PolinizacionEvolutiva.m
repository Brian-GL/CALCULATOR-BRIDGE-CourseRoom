%Función que nos ayuda a realizar el algoritmo 'PolinizacionEvolutiva', el cual nos ayuda a obtener las posibles soluciones de la función objetivo.

%En donde requerimos valores para los siguientes parámetros:

%Parámetros generales:

%Funcion -> El valor de la función objetivo a optimizar.
%NumeroDeIteraciones -> El número de iteraciones que el algoritmo realizará para encontrar la posible solución.
%NumeroDeIndividuos -> El número de individuos a crear y a utilizar en el algoritmo.
%Minimo -> El vector de límite mínimo de cada valor de la dimensión. 
%Maximo -> El vector de límite máximo de cada valor de la dimensión.
%Dimension -> El número de dimensiones que la función presenta.

%Parámetros particulares:

%ParametroDePaso -> Representa el valor del parámetro de paso que los individuos utilizarán (Valor lamdba en el algoritmo de la polinización de la flor).
%CriterioDeProbabilidad = El criterio de probabilidad que nos ayudará a 'switchear' la polinización global y local.
%FactorDeAmplificacion -> es el factor amplificación, el cual se encuentra entre el rango de valores 0 <= F <= 2 (Factor De Amplificación en el algoritmo de evolución diferencial).
%ConstanteDeRecombinacion -> es una constante de recombinación, la cual se encuentra entre los valores [0 1]. Además, esta constante nos sirve para la hora de la cruza (como en el algoritmo de evolución diferencial).

%Esta función retorna a Solucion, que es un vector con todos los valores óptimos de cada dimensión, por lo que solución es un vector de Dimensión x 1.
%Además, retornamos a Población ,que son todos aquellos individuos creados para el algoritmo, utilizado principalmente para graficar los resultados más adelante.

%Este algoritmo se basa principalmente en la combinación de los métodos que utilizan los siguientes algoritmos:
% - Polinización de la flor.
% - Evolución Diferencial.


%En cambio, para esta actividad, se agregaron los parámetros PosicionDeseada y PosicionInicial.

function Solucion = PolinizacionEvolutiva(Funcion,NumeroDeIteraciones,NumeroDeIndividuos, Minimo, Maximo, Dimension, ParametroDePaso, CriterioDeProbabilidad ,FactorDeAmplificacion,ConstanteDeRecombinacion)

    %El primer paso que tendremos que realizar es la inicialización y creación de todos los valores, vectores, matrices , datos, etc. que utilizaremos para optimizar la función objetivo.

    %     F a s e    D e     I n i c i a l i z a c i ó n     D e     V a l o r e s  %
    
    %Creamos la matriz de individuos del algoritmo, lo llamaremos Población:
    
    %La matriz será de tamaño Dimension x NumeroDeIndividuos:
    Poblacion = zeros(Dimension, NumeroDeIndividuos); %Inicializamos todos los valores en cero, para despúes llenarlos con valores aleatorios dentro del rango especificado.

    %Creamos ahora un vector para guardar solamente las evaluaciones de cada individuo de la población en la función objetivo, la llamaremos Evaluaciones:
    
    %En este caso tendremos un vector de tamaño Número de individuos, ya que la evaluación es un  valor escalar.
    Evaluaciones = zeros(1,NumeroDeIndividuos); %Al igual que los valores anteriores, este vector se crea con valores en cero.
    
    %Establecemos el valor de sigma2, el cual es requerido para el vuelo de Levy:
    Sigma2 = ((gamma(1+ParametroDePaso)/(ParametroDePaso*gamma((1+ParametroDePaso)/2)))*((sin(pi*ParametroDePaso/2))/(2^((ParametroDePaso-1)/2)))) ^ (1/ParametroDePaso); % Aparte, para la creación de este valor usamos la funnción gamma que nos brinda por defecto matlab.

    %Ahora, damos paso a la inicialización de los valores de la matriz de  Población y el vector de Evaluaciones:

    %Creamos un for desde 1 hasta el número de individuos para almacenar la información respectiva de cada uno de los valores correspondientes.
    for i=1:NumeroDeIndividuos 
        %Creamos el individuo con un valor aleatorio dentro del rango especificado en los valores Minimo y Maximo dados como parámetros:
        Individuo = Minimo+(Maximo-Minimo).*rand(Dimension,1);
        
        %Añadimos el nuevo individuo a la población 
        Poblacion(:,i) = Individuo;
        
        %Ahora, en el vector de evaluaciones guardamos la evaluación de este individuo en la función objetivo:
        Evaluaciones(i) = Funcion(Individuo);
    end
    
    %  F i n   F a s e    D e     I n i c i a l i z a c i ó n     D e     V a l o r e s  %
    
    %------------------------------------------------------------------------------------%
    %       F a s e    D e    D e s a r r o l l o    D e l    A l g o r i t m o          %
    
    %Creamos un for desde 1 hasta el número de iteraciones para desarrollar el algoritmo tal cantidad de veces:
    for iteracion = 1:NumeroDeIteraciones

        %Como primer paso debemos de obtener el índice del mejor individuo de la población, es decir, el que tenga la mejor evaluación en la función:
        [~,IndiceDelMejor] = min(Evaluaciones);%Para ello nos ayudamos mediante la función min o max, respectivamente.
        
        %Además, podemos actualizar el valor de Solución (el valor de la solución óptima a retornar).
        Solucion = Poblacion(:,IndiceDelMejor);
        
        %Generamos otro for, el que nos ayudará a iterar a cada individuo de la población:
        for i = 1: NumeroDeIndividuos
            
            %Establecemos primeramente un valor aleatorio r, tal que 0<=r<=1, con el propósito de seleccionar el tipo de polinización: global o local.
            r = rand; %Y como lo hemos ido haciendo en cada práctica, lo obtenemos con rand.
            
            %Si el valor aleatorio es menor al criterio de probabilidad previamente generado, entonces, realizamos la polinización global.
            if r < CriterioDeProbabilidad
                %    *Fase De Polinización Global*
                
                %Inicializamos este tipo de polinización creando los vectores de u y v de distribución normal requeridos en esta parte:    
                u = normrnd(0,Sigma2,[Dimension 1]); %Nos apoyamos utilizando la función normrnd que nos brinda matlab, además, utilizamos el valor previamente creado de sigma2
                v = normrnd(0,1,[Dimension 1]);%En este caso, en v aplicamos una distribución normal con 1 y no con sigma2.

                %Despúes, podemos crear ahora si nuestro vector L mediante la fórmula utilizada en el algoritmo de Mantegna:

                L = u./ (abs(v).^(1/ParametroDePaso)); %Y como recordaremos, L es un vector y no un escalar, por lo que utilizamos los operadores '.'

                %Ya obtenidos estos valores, podemos ahora crear nuestro nuevo vector de solución candidata:

                SolucionCandidata = Poblacion(:,i) + L.* (Poblacion(:,IndiceDelMejor) - Poblacion(:,i));

                %Generamos en una variable la evaluación de la nueva solución candidata:
                EvaluacionSolucionCandidata = Funcion(SolucionCandidata);

                %Si esta nueva evaluación es mejor que la evaluación previa del individuo, entonces actualizamos el individuo por la solución candidata, incluyendo su nueva evaluación.
                if EvaluacionSolucionCandidata < Evaluaciones(i)
                    Poblacion(:,i) = SolucionCandidata;
                    Evaluaciones(i) = EvaluacionSolucionCandidata;
                end

              %    *Fin Fase De Polinización Global*
              
            else %Si no, entonces realizamos evolucion diferencial, el cual se intercambió por el método de la polinización local.
                
                %Generamos otro for, para visitar a cada individuo dentro de la poblacion:
                for j = 1 : NumeroDeIndividuos
                    %Ahora, debemos de obtener valores aleatorios r1, r2 & r3, tales que no sean igual a 'j'.
                    r1 = randi([1 NumeroDeIndividuos]);
                    %Usamos while para cada r(n), con el hecho de validar que r1 != r2 != r3 != j.
                    while r1 == j
                        r1 = randi([1 NumeroDeIndividuos]);
                    end
                    r2 = randi([1 NumeroDeIndividuos]);
                    while r2 == j || r1 == r2
                        r2 = randi([1 NumeroDeIndividuos]);
                    end
                    r3 = randi([1 NumeroDeIndividuos]);
                    while r3 == j || r3 == r1 || r3 == r2
                        r3 = randi([1 NumeroDeIndividuos]);
                    end
                    %Generamos ahora el vector mutado que el algoritmo de evolución diferencial utiliza [ vi := xr1 + F (xr2 - xr3) ]
                    Vector = Poblacion(:,r1) + FactorDeAmplificacion * (Poblacion(:,r2) - Poblacion(:,r3));
                    %Generamos un vector auxiliar que nos ayudará a mutar, todo eso dependiento de nuestra constante de recombinación.
                    VectorMutado = zeros(Dimension,1);
                    for k = 1:Dimension
                        %Si nuestro número random es menor o igual a nuestra constante de recombinación, es así que podemos tomar la parte de la dimensión 'k' del vector para combinar.
                        if rand <= ConstanteDeRecombinacion
                            VectorMutado(k) = Vector(k);
                        else %sino, pasamos el valor del individuo en tal dimensión.
                            VectorMutado(k) = Poblacion(k,j);
                        end
                    end
                    %Evaluamos el vector mutado en la función:
                    EvaluacionNuevoVector = Funcion(VectorMutado); 
                    %Si esta nueva evaluación es mejor que la evaluación previa del individuo, entonces actualizamos el individuo por el vector mutado, incluyendo su nueva evaluación.
                    if EvaluacionNuevoVector < Evaluaciones(j) 
                        Poblacion(:,j) = VectorMutado;
                        Evaluaciones(j) = EvaluacionNuevoVector;
                    end
                end
            end
        end
         
    end

    %   F i n    F a s e    D e    D e s a r r o l l o    D e l    A l g o r i t m o  %


end
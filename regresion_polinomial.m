function Resultado = regresion_polinomial(x, y)

    figure
    hold on
    grid on
    plot(x,y,'-b');
    %Generamos e inicializamos primeramente los valores globales que se van a utilizar:

    %Definimos por defecto el número de dimensiones a utilizar:
    Dimension = 1;

    %Definimos el grado de nuestro polinomio:
    NumeroElementos = size(x, 2);
    Grado = NumeroElementos - 1;

    %Crear el vector de coeficientes para la función objetivo:
    Vector = zeros(1, NumeroElementos);

    %Valor auxiliar para llenar los vectores:
    k = 0;

    % Llenar los vectores:
    for j = 1: Grado
        Vector(1, j) = sum(x.^j);
    end
    Vector(1,NumeroElementos) = sum(y.*x);

    disp(Vector);

    % Generar la función objetivo: 
    FuncionObjetivo = @(x,y) x;
  
    switch (NumeroElementos)
        case 2
            FuncionObjetivo = @(x,y) Vector(1,1) * x - Vector(1,NumeroElementos);
        case 3
            FuncionObjetivo = @(x,y) Vector(1,1) * x + Vector(1,2) * x^2 - Vector(1,NumeroElementos);
        case 4
            FuncionObjetivo = @(x,y) Vector(1,1) * x + Vector(1,2) * x^2 + Vector(1,3) * x^3 - Vector(1,NumeroElementos);
        case 5
            FuncionObjetivo = @(x,y) Vector(1,1) * x + Vector(1,2) * x^2 + Vector(1,3) * x^3  + Vector(1,4) * x^4 - Vector(1,NumeroElementos);
        case 6
            FuncionObjetivo = @(x,y) Vector(1,1) * x + Vector(1,2) * x^2 + Vector(1,3) * x^3  + Vector(1,4) * x^4  + Vector(1,5) * x^5 - Vector(1,NumeroElementos);
        case 7
            FuncionObjetivo = @(x,y) Vector(1,1) * x + Vector(1,2) * x^2 + Vector(1,3) * x^3  + Vector(1,4) * x^4  + Vector(1,5) * x^5 + Vector(1,6) * x^6 - Vector(1,NumeroElementos);
        case 8
            FuncionObjetivo = @(x,y) Vector(1,1) * x + Vector(1,2) * x^2 + Vector(1,3) * x^3  + Vector(1,4) * x^4  + Vector(1,5) * x^5 + Vector(1,6) * x^6 + Vector(1,7) * x^7 - Vector(1,NumeroElementos);
        case 9
            FuncionObjetivo = @(x,y) Vector(1,1) * x + Vector(1,2) * x^2 + Vector(1,3) * x^3  + Vector(1,4) * x^4  + Vector(1,5) * x^5 + Vector(1,6) * x^6 + Vector(1,7) * x^7 + Vector(1,8) * x^8 - Vector(1,NumeroElementos);
        case 10
            FuncionObjetivo = @(x,y) Vector(1,1) * x + Vector(1,2) * x^2 + Vector(1,3) * x^3  + Vector(1,4) * x^4  + Vector(1,5) * x^5 + Vector(1,6) * x^6 + Vector(1,7) * x^7 + Vector(1,8) * x^8  + Vector(1,9) * x^9 - Vector(1,NumeroElementos);
    end

    disp(FuncionObjetivo);

    % Resolución mediante Polinización evolutiva:

    NumeroDeIndividuos = 100;
    NumeroDeIteraciones = 100;
    Minimo = [0];
    Maximo = [100]';
    ParametroDePaso = 1.5;
    CriterioDeProbabilidad = 0.6; %en este caso el criterio de probabilidad esta entre 0.5, ya que en este algoritmo la polinización local (algoritmo de evolución diferencial) genera resultados muy favorables, por lo que es de suma importancia que este método se realize constantemente.
    FactorDeAmplificacion = 1.2;
    ConstanteDeRecombinacion = 0.9;

    Solucion = PolinizacionEvolutiva(FuncionObjetivo,NumeroDeIteraciones,NumeroDeIndividuos, Minimo, Maximo, Dimension, ParametroDePaso, CriterioDeProbabilidad ,FactorDeAmplificacion,ConstanteDeRecombinacion);
    disp(Solucion);
    Evaluacion = FuncionObjetivo(100);
    Resultado = Evaluacion;
end



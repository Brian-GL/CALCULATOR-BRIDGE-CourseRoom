from fastapi import FastAPI, status
import matlab.engine
from typing import List, Union
from pydantic import BaseModel

class RegresionPolinomialInputModel(BaseModel):
    x: Union[List[float], None] = None
    y: Union[List[float], None] = None

app = FastAPI(title = "CourseRoom Calculator Bridge", description = "CourseRoom Calculator Bridge For Matlab Executions")

@app.post("/RegresionPolinomial", status_code=status.HTTP_200_OK)
def RegresionPolinomial(model: RegresionPolinomialInputModel):

  try:
    if model is None:
        return { "codigo": 400, "mensaje": "El modelo de entrada se encuentra nulo", "resultado": -1 }

    if model.x is None:
      return  { "codigo": 400, "mensaje": "El campo de entrada 'x' se encuentra nulo", "resultado": -1 }

    if model.y is None:
      return  { "codigo": 400, "mensaje": "El campo de entrada 'y' se encuentra nulo", "resultado": -1 }

    if len(model.x) != len(model.y):
      return  { "codigo": 400, "mensaje": "El campo de entrada 'x' y el campo de entrada 'y' no presentan el mismo tamaño", "resultado": -1 }

    if len(model.x) < 2:
        return  { "codigo": 400, "mensaje": "El tamaño mínimo de los arreglos debe de ser igual a 2", "resultado": -1 }

    future_eng = matlab.engine.start_matlab(background=True)
    
    x = matlab.double(vector=model.x)
    y = matlab.double(vector=model.y)

    eng = future_eng.result()
    future = eng.regresion_polinomial(x,y, background=True, nargout=3)  
    [Codigo, Mensaje, Resultado] = future.result()
    eng.quit()
  
  except Exception as e:
    return { "codigo": 500, "mensaje": str(e), "resultado": -1}
  
  if Codigo < 0:
    Code = 500
  elif Codigo == 0:
    Code = 400
  else:
    Code = 200

  return { "codigo": Code , "mensaje": Mensaje, "resultado": Resultado}


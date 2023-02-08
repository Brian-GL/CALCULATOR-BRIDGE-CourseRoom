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
        return { "codigo": 400, "data": "El modelo de entrada se encuentra nulo" }

    if model.x is None:
      return  { "codigo": 400, "data": "El campo de entrada 'x' se encuentra nulo" }

    if model.y is None:
      return  { "codigo": 400, "data": "El campo de entrada 'y' se encuentra nulo" }

    if len(model.x) != len(model.y):
      return  { "codigo": 400, "data": "El campo de entrada 'x' y el campo de entrada 'y' no presentan el mismo tamaño" }

    if len(model.x) < 2:
        return  { "codigo": 400, "data": "El tamaño mínimo de los arreglos debe de ser igual a 2" }

    future_eng = matlab.engine.start_matlab(background=True)
    eng = future_eng.result()
    future = eng.regresion_polinomial(model.x, model.y, background=True)  
    result = future.result()
    eng.quit()
  
  except Exception as e:
    return { "codigo": 500, "data": str(e)}

  return { "codigo": 200, "data": result}


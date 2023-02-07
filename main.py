from fastapi import FastAPI
import matlab.engine
from typing import List, Union
from pydantic import BaseModel

class RegresionPolinomialInputModel(BaseModel):
    x: Union[List[float], None] = None
    y: Union[List[float], None] = None

# future = matlab.engine.start_matlab(background=True)
# eng = future.result()
# eng.quit()

app = FastAPI(title = "CourseRoom Calculator Bridge", description = "CourseRoom Calculator Bridge For Matlab Executions")

@app.post("/RegresionPolinomial")
async def RegresionPolinomial(model: RegresionPolinomialInputModel):

  
  if model is None:
      return { "codigo": 400, "data": "El modelo de entrada se encuentra nulo" }

  if model.x is None:
    return  { "codigo": 400, "data": "El campo de entrada 'x' se encuentra nulo" }

  if model.y is None:
    return  { "codigo": 400, "data": "El campo de entrada 'y' se encuentra nulo" }

  if len(model.x) != len(model.y):
    return  { "codigo": 400, "data": "El campo de entrada 'x' y el campo de entrada 'y' no presentan el mismo tamaño" }

  return { "codigo": 200, "data": model}


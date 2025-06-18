from fastapi import FastAPI, Depends
from typing import List
from sqlalchemy.orm import Session
from sqlalchemy import text

from database import SessionLocal, get_db
from database import get_db
from models import Sala
from schemas import SalaRead



app = FastAPI()

@app.get("/ping")
def ping():
    return {"mensaje": "API funcionando correctamente"}

@app.get("/db-test")
def db_test(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return {"conexion": "exitosa"}
    except Exception as e:
        return {"error": str(e)}
    
 
@app.get("/salas/", response_model=List[SalaRead])
def get_salas(db: Session = Depends(get_db)):
    return db.query(Sala).all()


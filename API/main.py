from fastapi import FastAPI, Depends
from typing import List
from sqlalchemy.orm import Session
from sqlalchemy import text

from database import SessionLocal, get_db
from models import Sala, Oficina, Bano, Laboratorio, Reporte
from schemas import SalaRead, OficinaRead, BanoRead, LaboratorioRead
from schemas import ReporteRead, ReporteCreate




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

@app.get("/oficinas/", response_model=List[OficinaRead])
def get_oficinas(db: Session = Depends(get_db)):
    return db.query(Oficina).all()


@app.get("/banos/", response_model=List[BanoRead])
def get_banos(db: Session = Depends(get_db)):
    return db.query(Bano).all()


@app.get("/laboratorios/", response_model=List[LaboratorioRead])
def get_laboratorios(db: Session = Depends(get_db)):
    return db.query(Laboratorio).all()


@app.get("/reportes/", response_model=List[ReporteRead])
def get_reportes(db: Session = Depends(get_db)):
    return db.query(Reporte).all()

@app.post("/reportes/", response_model=ReporteRead)
def create_reporte(reporte: ReporteCreate, db: Session = Depends(get_db)):
    nuevo_reporte = Reporte(descripcion=reporte.descripcion)
    db.add(nuevo_reporte)
    db.commit()
    db.refresh(nuevo_reporte)
    return nuevo_reporte
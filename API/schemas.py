# schemas.py
from pydantic import BaseModel
from enum import Enum as PyEnum
from datetime import datetime

class AlaEnum(PyEnum):
    A = "A"
    B = "B"

class SalaBase(BaseModel):
    numero: str
    piso: int
    ala: AlaEnum

class SalaRead(SalaBase):
    id_sala: int

    class Config:
        orm_mode = True


class OficinaBase(BaseModel):
    ala: AlaEnum
    piso: int
    profesor: str
    numero: str

class OficinaRead(OficinaBase):
    id_oficina: int

    class Config:
        orm_mode = True


class GeneroEnum(PyEnum):
    Hombre = "Hombre"
    Mujer = "Mujer"

class BanoBase(BaseModel):
    ala: AlaEnum
    piso: int
    numero: str
    genero: GeneroEnum

class BanoRead(BanoBase):
    id_bano: int

    class Config:
        orm_mode = True

class LaboratorioBase(BaseModel):
    numero: str
    departamento: str
    ala: AlaEnum
    piso: int

class LaboratorioRead(LaboratorioBase):
    id_laboratorio: int

    class Config:
        orm_mode = True

class ReporteBase(BaseModel):
    descripcion: str

class ReporteCreate(ReporteBase):
    pass  

class ReporteRead(ReporteBase):
    id_reporte: int
    fecha: datetime

    class Config:
        orm_mode = True
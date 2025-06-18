# schemas.py
from pydantic import BaseModel
from enum import Enum as PyEnum

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

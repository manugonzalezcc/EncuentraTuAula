# models.py
from sqlalchemy import Column, Integer, String, Enum
from database import Base

class Sala(Base):
    __tablename__ = "salas"

    id_sala = Column(Integer, primary_key=True, index=True)
    numero = Column(String(10), nullable=False)
    piso = Column(Integer, nullable=False)
    ala = Column(Enum("A", "B"), nullable=False)

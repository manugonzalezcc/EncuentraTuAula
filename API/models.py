# models.py
from sqlalchemy import Column, Integer, String, Enum, TIMESTAMP, Text, func
from database import Base

class Sala(Base):
    __tablename__ = "salas"

    id_sala = Column(Integer, primary_key=True, index=True)
    numero = Column(String(10), nullable=False)
    piso = Column(Integer, nullable=False)
    ala = Column(Enum("A", "B"), nullable=False)


class Oficina(Base):
    __tablename__ = "oficinas"

    id_oficina = Column(Integer, primary_key=True, index=True)
    ala = Column(Enum("A", "B"), nullable=False)
    piso = Column(Integer, nullable=False)
    profesor = Column(String(100), nullable=False)
    numero = Column(String(10), nullable=False)

class Bano(Base):
    __tablename__ = "banos"

    id_bano = Column(Integer, primary_key=True, index=True)
    ala = Column(Enum("A", "B"), nullable=False)
    piso = Column(Integer, nullable=False)
    numero = Column(String(10), nullable=False)
    genero = Column(Enum("Hombre", "Mujer"), nullable=False)

class Laboratorio(Base):
    __tablename__ = "laboratorios"

    id_laboratorio = Column(Integer, primary_key=True, index=True)
    numero = Column(String(10), nullable=False)
    departamento = Column(String(100), nullable=False)
    ala = Column(Enum("A", "B"), nullable=False)
    piso = Column(Integer, nullable=False)

class Reporte(Base):
    __tablename__ = "reportes"

    id_reporte = Column(Integer, primary_key=True, index=True)
    descripcion = Column(Text, nullable=False)
    fecha = Column(TIMESTAMP, server_default=func.current_timestamp(), nullable=False)
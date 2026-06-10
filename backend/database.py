from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# connection string as set in K8s secret
SQLALCHEMY_DATABASE_URL = "postgresql://admin:mysecretpassword@postgres:5432/mydatabase"

# create the SQLAlchemy engine
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# create sessionmaker factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# create a base class for declarative models
Base = declarative_base()

# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

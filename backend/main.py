from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from sqlalchemy import text
from database import get_db

app = FastAPI(
    title="Tech Jobs Sentiment API",
    description="Backend service for analysing Reddit job trends",
    version="1.0.0"
)

@app.get("/")
def read_root():
    return {"message": "Welcome to the Tech Jobs Sentiment API!"}

@app.get("/health")
def health_check(db: Session = Depends(get_db)):
    """
    Health check endpoint to verify database connectivity.
    """
    try: # run simple query to check DB connection
        db.execute(text("SELECT 1"))
        return {"status": "ok", "database": "connected"}
    except Exception as e:
        return {"status": "error", "database": "disconnected", "error": str(e)}
    
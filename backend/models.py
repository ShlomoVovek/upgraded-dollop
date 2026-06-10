from sqlalchemy import Column, Integer, String, Text, Float, DateTime
from backend.database import Base
from datetime import datetime, timezone
class RawPost(Base):
    __tablename__ = "raw_posts"

    id = Column(String, primary_key=True, index=True) # id from Reddit
    title = Column(String, nullable=False)
    content = Column(Text, nullable=True)
    author = Column(String, nullable=True)
    created_utc = Column(DateTime, default=datetime.now(timezone.utc))
    subreddit = Column(String, nullable=False)
    processed = Column(Integer, default=0) # 0 for unprocessed, 1 for processed

class AnalyzedTrend(Base):
    __tablename__ = "analyzed_trends"

    id = Column(Integer, primary_key=True, index=True)
    post_id = Column(String, nullable=False) # foreign key to RawPost.id
    sentiment_score = Column(Float, nullable=False)
    sentiment_label = Column(String, nullable=False)
    analyzed_at = Column(DateTime, default=datetime.now(timezone.utc))


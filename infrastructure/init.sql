-- Bronze Layer: raw posts from Hacker News API
CREATE TABLE IF NOT EXISTS raw_hm_items (
    id SERIAL PRIMARY KEY,
    hn_id BIGINT UNIQUE NOT NULL, -- Hacker News item ID
    title TEXT, -- title of the post
    text_content TEXT, -- text content of the post (if any)
    author VARCHAR(100), -- author of the post
    created_at TIMESTAMP WITH TIME ZONE, -- creation time of the post
    url TEXT, -- URL of the post (if it's a link)
    fetch_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- time when the post was fetched
    type VARCHAR(50) NOT NULL -- type of the post (e.g., 'story', 'comment', 'job', etc.)
);

-- Gold Layer: result of semntic & trend analysis 
CREATE TABLE IF NOT EXISTS analyzed_trends (
    id SERIAL PRIMARY KEY, -- unique identifier for each analysis result
    hn_id BIGINT REFERENCES raw_hm_items(hn_id) ON DELETE CASCADE, -- reference to the original Hacker News item
    text_to_analyze TEXT, -- the text that was analyzed (could be title + text_content)
    sentiment_label VARCHAR(50), -- e.g., 'positive', 'negative', 'neutral'
    sentiment_score REAL, -- confidence score for sentiment (0-1)
    detected_technologies TEXT[], -- array of detected technologies
    analyzed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP -- time when the analysis was performed
);




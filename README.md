# Argon Challenge

A semantic search application leveraging Ruby on Rails, OpenAI Embedding API, and Pinecone.

---

## Tech Stack
I focused entirely on backend development for this project, opting to use **Ruby on Rails** for its ability to quickly facilitate production-ready deployments. While I have experience with Python, Rails has been my primary framework for the past three years, allowing me to save time and effort on ramping up.  

For embedding and similarity search functionality:
- **OpenAI Embedding API**: Used the `text-embedding-ada` model to generate 1536-dimensional embeddings for data points and queries.
- **Pinecone**: Utilized Pinecone for performing cosine similarity searches between query embeddings and stored data embeddings.

---

## Data Processing
To handle data efficiently:
1. **Data Source**: Downloaded 10,000 records from [clinicaltrials.gov](https://clinicaltrials.gov) and stored the data in an **AWS S3 bucket** for seamless retrieval in the production environment.
2. **Seed Script**: Wrote a one-time seed script (`seeds.rb`) to pull the data from the S3 bucket, preprocess it, and save it to the production database.

The preprocessing steps ensured the data was clean and structured for embedding generation and storage.

---

## Approach
The search functionality is built around cosine similarity and vector-based search using embeddings.  

1. **Embedding Generation**:  
   - Generated 1536-dimensional embeddings for clinical trial data records using OpenAI’s Embedding API.
   - Stored the embeddings in Pinecone for vector-based search.  

2. **Query Processing**:  
   - When a query is submitted, the system generates embeddings for it using the same API.
   - A cosine similarity search is then performed in Pinecone against the stored data embeddings.

3. **Matching Threshold**:  
   - A similarity threshold of **0.8** is used to determine relevant matches. 
   - Users can toggle this threshold on the search page to balance recall and precision.

---

## Additions/Improvements
The current implementation can be further enhanced in the following ways:
1. **Metadata-Based Filtering**:  
   - Incorporating metadata fields (e.g., phases, statuses, locations) into Pinecone for enhanced filtering and fine-tuned search results.

2. **Embedding Optimization**:  
   - Revisiting the data points selected for embedding to provide more context and improve the quality of search results.

---

## Testing and Deployment
Due to extensive preprocessing and database usage, I deployed the application directly to the production environment for testing. This approach simplified testing and ensured a seamless setup.  

- **Application URL**: [Argon Challenge App](https://argon-ch-6f15a5cabeaa.herokuapp.com)  
- **Code Repository**: [GitHub Repository](https://github.com/kashyapvad/argon-challenge)

---

This approach provides a scalable and efficient way to perform semantic search on large datasets while leaving room for future enhancements.

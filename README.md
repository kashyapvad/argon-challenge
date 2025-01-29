# Argon Challenge

A semantic search application leveraging Ruby on Rails, OpenAI Embedding API, and Pinecone.

---

## Tech Stack
I focused entirely on backend development for this project, opting to use **Ruby on Rails** for its ability to quickly facilitate production-ready deployments. While I have experience with Python, Rails has been my primary framework for the past three years, allowing me to save time and effort on ramping up.  

For embedding and similarity search functionality:
1. **OpenAI Embedding API**: Used the `text-embedding-ada` model to generate 1536-dimensional embeddings for data points and queries.
2. **Pinecone**: Utilized Pinecone for performing cosine similarity searches between query embeddings and stored data embeddings.

---

## Data Processing
To handle data efficiently:
1. **Data Source**: Downloaded 10,000 records from [clinicaltrials.gov](https://clinicaltrials.gov) and stored the data in an **AWS S3 bucket** for seamless retrieval in the production environment.
2. **Seed Script**: Wrote a one-time seed script to pull the data from the S3 bucket, preprocess it, and save it to the production database.
  - `seeds.rb` includes the script for preprocessing clinical trial data and populating the database with the processed records.

The preprocessing steps ensured the data was clean and structured for embedding generation and storage.

---

## Approach
The search functionality is built around cosine similarity and vector-based search using embeddings.  

1. **Embedding Generation**:  
   - Generated 1536-dimensional embeddings for clinical trial data records using OpenAI’s Embedding API.
   - Stored the embeddings in Pinecone for vector-based search.  
   - `clincial_trial.rb` contains the logic for selecting and structuring the data points used to generate embeddings

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

### Query Testing
Feel free to try out different kinds of queries, including locations or intervention types. For example:
- I tested a query like `NSCLC France`, and the system successfully retrieved clinical trials related to NSCLC from France.
- However, for queries like `NSCLC Phase 1` or `NSCLC intervention type Procedure`, the results were less accurate.  

This suggests that adding better context when embedding the clinical trial data can significantly enhance search performance and improve results for complex queries.

---

This approach provides a scalable and efficient way to perform semantic search on large datasets while leaving room for future enhancements.

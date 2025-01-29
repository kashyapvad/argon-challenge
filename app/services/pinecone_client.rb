# app/services/pinecone_client.rb

require 'httparty'

class PineconeClient
  include HTTParty
  base_uri ENV['PINECONE_BASE_URI']

  def initialize
    @headers = {
      "Api-Key" => ENV['PINECONE_API_KEY'],
      "Content-Type" => "application/json"
    }
  end

  # Upsert vectors into Pinecone
  def upsert(vectors)
    self.class.post("/vectors/upsert", headers: @headers, body: vectors.to_json)
  end

  # Query vectors from Pinecone with similarity scores
  def query query_vector, options={}
    opts = options.with_indifferent_access
    top_k = opts[:top_k] || 10000
    body = {
      vector: query_vector,
      topK: top_k,
      includeValues: false,
      includeMetadata: true,
      #filter: {}.compact  Add filters if needed
    }.to_json
    self.class.post("/query", headers: @headers, body: body)
  end

  # Delete vectors from Pinecone
  def delete(id:)
    self.class.post("/vectors/delete", headers: @headers, body: { ids: [id] }.to_json)
  end
end

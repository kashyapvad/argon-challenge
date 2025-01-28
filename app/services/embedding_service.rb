class EmbeddingService
  def self.generate_embeddings_from_openai embeddings_text
    client = OpenAI::Client.new(access_token: ENV['OPEN_AI_API_KEY'])
    begin
      response = client.embeddings(
        parameters: {
          model: "text-embedding-ada-002",
          input: embeddings_text
        }
      )
      response['data'][0]['embedding']
    rescue => e
      puts "Unexpected Error when genrating embeddings for trial #{nct_id}: #{e.message}"
    end
  end
end
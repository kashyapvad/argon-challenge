class ClinicalTrialsController < ApplicationController
  # GET /clinical_trials/search
  def search_form
    # Renders the search form view
  end

  # POST /clinical_trials/search
  def search
    query = params[:query]
    threshold_input = params[:threshold]

    # Validate and set similarity threshold
    similarity_threshold = threshold_input.present? ? threshold_input.to_f : 0.5
    similarity_threshold = 0.5 if similarity_threshold < 0.0
    similarity_threshold = 1.0 if similarity_threshold > 1.0

    if query.blank?
      flash[:alert] = "Please enter a search query."
      redirect_to search_clinical_trials_path and return
    end

    # Generate embedding for the query
    query_embeddings = EmbeddingService.generate_embeddings_from_openai(query)

    if query_embeddings.nil?
      flash[:alert] = "Failed to generate embedding for the query. Please try again."
      redirect_to search_clinical_trials_path and return
    end

    pinecone = PineconeClient.new
    response = pinecone.query(query_embeddings)

    if response.code != 200
      flash[:alert] = "Pinecone query failed: #{response.body}"
      redirect_to search_clinical_trials_path and return
    end

    # Extract and filter matches based on the similarity threshold
    matched_ids_with_scores = response.parsed_response['matches'].select do |match|
      match['score'] >= similarity_threshold
    end

    trial_ids = matched_ids_with_scores.map { |match| match['id'].to_i }
    @clinical_trials = ClinicalTrial.where(id: trial_ids)
    @pinecone_response = response

    if @clinical_trials.empty?
      flash[:notice] = "No clinical trials found with sufficient similarity to your query."
      redirect_to search_clinical_trials_path and return
    end
    render :search_results
  end
end

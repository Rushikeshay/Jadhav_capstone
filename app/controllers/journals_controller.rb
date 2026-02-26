class JournalsController < ApplicationController
  def index
    @list_of_journals = Journal.all.order({ :created_at => :desc })
    render({ :template => "journal_templates/index" })
  end

  def show
    @the_journal = Journal.find(params.fetch("path_id"))
    render({ :template => "journal_templates/show" })
  end

  def create
    @the_day = Day.find(params.fetch("query_day_id"))
    
    # 1. Gather Text Context
    activity_context = @the_day.activities.map { |a| "#{a.name} at #{a.address}. Note: #{a.notes}" }.join(", ")
    
    # 2. Gather Image URLs (CarrierWave/Cloudinary Fix)
    images = []
    @the_day.activities.each do |a|
      images << a.picture.url if a.picture.present?
      a.photos.each { |p| images << p.image.url if p.image.present? }
    end

    # 3. Call AI
    chat = AI::Chat.new
    chat.proxy = true 
    chat.system("You are a provocative travel journalist. Based on the user's activities and photos, ask 3 deep, reflective questions to help them write a journal entry.")
    
    # Verify file is in lib/openai_schemas/daily_travel_reflection_questions.json
    chat.schema_file = "lib/openai_schemas/daily_travel_reflection_questions.json"
    
    chat.user("Today I did: #{activity_context}", images: images)
    
    ai_response = chat.generate!
    
    # Extract data from structured output
    structured_data = ai_response.fetch(:content) 
    questions_array = structured_data.fetch(:questions)

    # 4. Save to Database
    the_journal = Journal.new
    the_journal.day_id = @the_day.id
    the_journal.user_id = current_user.id
    the_journal.ai_generated_questions = questions_array.join("|") 
    # Explicitly set this to nil to bypass old logic
    the_journal.best_activity_id = nil 

    if the_journal.save
      redirect_to("/days/#{@the_day.id}", { :notice => "AI questions generated!" })
    else
      redirect_to("/days/#{@the_day.id}", { :alert => the_journal.errors.full_messages.to_sentence })
    end
  end

  def update
    the_journal = Journal.find(params.fetch("path_id"))
    the_journal.response = params.fetch("query_response")

    if the_journal.save
      redirect_to("/days/#{the_journal.day_id}", { :notice => "Journal entry saved." })
    else
      redirect_to("/days/#{the_journal.day_id}", { :alert => the_journal.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_journal = Journal.find(params.fetch("path_id"))
    day_id = the_journal.day_id
    the_journal.destroy
    redirect_to("/days/#{day_id}", { :notice => "Journal deleted." } )
  end
end

class JournalsController < ApplicationController
  def index
    matching_journals = Journal.all

    @list_of_journals = matching_journals.order({ :created_at => :desc })

    render({ :template => "journal_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_journals = Journal.where({ :id => the_id })

    @the_journal = matching_journals.at(0)

    render({ :template => "journal_templates/show" })
  end

  def create
    the_journal = Journal.new
    the_journal.day_id = params.fetch("query_day_id")
    the_journal.user_id = params.fetch("query_user_id")
    the_journal.ai_generated_questions = params.fetch("query_ai_generated_questions")
    the_journal.response = params.fetch("query_response")
    the_journal.best_activity_id = params.fetch("query_best_activity_id")

    if the_journal.valid?
      the_journal.save
      redirect_to("/journals", { :notice => "Journal created successfully." })
    else
      redirect_to("/journals", { :alert => the_journal.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_journal = Journal.where({ :id => the_id }).at(0)

    the_journal.day_id = params.fetch("query_day_id")
    the_journal.user_id = params.fetch("query_user_id")
    the_journal.ai_generated_questions = params.fetch("query_ai_generated_questions")
    the_journal.response = params.fetch("query_response")
    the_journal.best_activity_id = params.fetch("query_best_activity_id")

    if the_journal.valid?
      the_journal.save
      redirect_to("/journals/#{the_journal.id}", { :notice => "Journal updated successfully." } )
    else
      redirect_to("/journals/#{the_journal.id}", { :alert => the_journal.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_journal = Journal.where({ :id => the_id }).at(0)

    the_journal.destroy

    redirect_to("/journals", { :notice => "Journal deleted successfully." } )
  end
end

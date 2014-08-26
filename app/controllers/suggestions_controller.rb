class SuggestionsController < ApplicationController
  include ErrorCode
  skip_before_action :verify_authenticity_token
  before_action :restrict_access, only: [:new, :create]
  
  def new
    @suggestion=Suggestion.new
  end
  
  
  def create
    @user=current_user
    @suggestion= @user.suggestions.build(suggestion_params(params))
    if @suggestion.save
      respond_to do |format|
        format.html { redirect_back_or root_path }
        format.json { render :json=>{ comment: @suggestion.comment,
                                      user_id: @user.id,
                                      success:  true
                                      } , status: 200 }
       end
     else
       respond_to do |format|
         flash.now[:error] = 'Invalid email/password combination'
         format.html { render 'new' }
         format.json { render :json=> { success: false,
                                        message: @suggestion.errors.full_messages,
                                        error_code: ErrorCode::SUGGESTION_VALIDATION
                                      } , status: :unprocessable_entity }
        end
      end
  end
  
  private
  def suggestion_params(params)
      params.require(:suggestion).permit(:comment,:user_id)
  end
end
class Dashboard
  def initialize(user)
    @user = user
  end

  def completed_challenges
    @user.challenge_progressions.includes(:challenge).order("updated_at DESC").limit(10)
  end
end

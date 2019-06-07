class UserMailer < ApplicationMailer

  def invitation(user)
    @user = user
    mail to: @user.email, subject: 'Invitación a la plataforma'
  end

end

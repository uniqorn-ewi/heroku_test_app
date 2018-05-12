class NotifyMailer < ApplicationMailer
  default from: 'notifications@stormy-plains-29680.herokuapp.com'

  def notify_mail(user)
    @user = user
    @url  = 'https://stormy-plains-29680.herokuapp.com'
    mail to: "#{@user.email}", subject: "ブログの作成完了メール"
  end
end

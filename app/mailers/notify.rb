# encoding: utf-8
class Notify < ActionMailer::Base
  default from: "info@beweek.ru"
  layout false

  def invite(user_from, user_to, company, code)
    @user_from = user_from
    @user_to = user_to
    @company = company
    @href = "https://beweek.ru/auth?i=" + code
    mail(
        :to => user_to,
        :subject => "#{user_from.get_name} приглашает Вас в свою компанию #{company.name}",
    )
  end

  def update(users, text)

  end

  def registration(to, pass, code, cr)
    @email = to
    @pass = pass
    @href = 'https://beweek.ru/auth?i=' + code
    @cr = cr
    if @cr.to_i == 1
      @href += "&cr=1"
    end
    mail(
        :to => to,
        :subject => "Добро пожаловать в систему Beweek!",
    )
  end

  def registr(to, pass)
    @email = to
    @pass = pass
    mail(
        :to => to,
        :subject => "Добро пожаловать в систему Beweek!",
    )
  end

  def forget(to, pass)
    @email = to
    @pass = pass
    mail(
        :to => to,
        :subject => "Восстановление данных для входа в систему Beweek",
    )
  end

  def change_pass(to, pass)
    @email = to
    @pass = pass
    mail(
        :to => to,
        :subject => "Ваши данные для входа в систему Beweek изменены",
    )
  end

end

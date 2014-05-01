class UserDecorator < Draper::Decorator
  delegate_all

  def auth_qr_image
    [authentication_token, ENV['API_URL']].join(';').to_qr_image(size: "200x200").html_safe
  end
end

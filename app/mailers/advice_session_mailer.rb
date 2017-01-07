class AdviceSessionMailer < SendWithUsMailer::Base
  default from: "no-reply@tapline.co"

  def end_session(session)
    decorated = session.decorate

    assign(:messages_count, decorated.count)
    assign(:price, decorated.price)
    assign(:fee, decorated.fee)
    assign(:seconds_talked, decorated.seconds_talked)
    assign(:calls_price, decorated.calls_price)
    assign(:subtotal, decorated.subtotal)
    assign(:tax, decorated.tax)
    assign(:charged, decorated.charged)
    assign(:card_last_4, decorated.card_last_4)
    assign(:expert_name, decorated.expert_name)
    assign(:expert_image, decorated.expert.photo_url)
    assign(:access_token, decorated.access_token)

    mail(
      email_id: "tem_SL9drSV3CJseNnwoHo9bFP",
      recipient_address: decorated.customer_email,
      to: decorated.customer_email,
      from_name: "BeSmooth Receipt",
      from_address: "no-reply@tapline.co",
      locale: "en-US"
    )
  end
end

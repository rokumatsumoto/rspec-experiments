require 'date'

class DataGenerator
  def boolean_value
    [true, false].sample
  end

  def email_address_value
    domain = %w[ gmail.com yahoo.com aol.com hotmail.com ].sample
    username_characters = (0..9).to_a + ('a'..'z').to_a + ('A'..'Z').to_a
    username_length = rand(5) + 3
    username = Array.new(username_length) { username_characters.sample }.join

    "#{username}@#{domain}"
  end

  def date_value
    Date.new(
      (1950..1999).to_a.sample,
      (1..12).to_a.sample,
      (1..28).to_a.sample,
    )
  end

  def user_record
    {
      email_address: email_address_value,
      date_of_birth: date_value,
      active:        boolean_value
    }
  end

  def users(count)
    Array.new(count) { user_record }
  end
end

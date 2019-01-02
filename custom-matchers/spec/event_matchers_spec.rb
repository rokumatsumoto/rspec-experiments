RSpec::Matchers.define :have_no_tickets_sold do
  match { |event| event.tickets_sold.count.zero? }

  failure_message do |event|
    super() + ", but had #{event.tickets_sold.count}"
  end
end

RSpec::Matchers.define :be_sold_out do
  match { |event| event.tickets_sold.count == event.capacity }

  failure_message do |event|
    unsold_count = event.capacity - event.tickets_sold.count
    super() + ", but had #{unsold_count} unsold tickets"
  end
end

Event = Struct.new(:name, :capacity) do
  def purchase_ticket_for(guest)
    tickets_sold << guest
  end

  def tickets_sold
    @tickets_sold ||= []
  end

  def inspect
    "#<Event #{name.inspect} (capacity: #{capacity})>"
  end
end

RSpec.describe '`have_no_tickets_sold` matcher' do
  example 'passing expectation' do
    art_show = Event.new('Art Show', 100)

    expect(art_show).to have_no_tickets_sold
  end

  example 'failing expectation' do
    art_show = Event.new('Art Show', 100)
    art_show.purchase_ticket_for(:a_friend)

    expect(art_show).to have_no_tickets_sold
  end
end

RSpec.describe '`be_sold_out` matcher' do
  example 'passing expectation' do
    u2_concert = Event.new('U2 Concert', 10_000)
    10_000.times { u2_concert.purchase_ticket_for(:a_fan) }

    expect(u2_concert).to be_sold_out
  end

  example 'failing expectation' do
    u2_concert = Event.new('U2 Concert', 10_000)
    9_900.times { u2_concert.purchase_ticket_for(:a_fan) }

    expect(u2_concert).to be_sold_out
  end
end

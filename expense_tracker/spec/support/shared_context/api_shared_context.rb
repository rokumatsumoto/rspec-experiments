RSpec.shared_context 'API helpers' do
  include Rack::Test::Methods

  # before do
  #   basic_authorize 'test_user', 'test_password'
  # end

   def helpers
     app.helpers
   end

   def header_json
    header 'Accept', 'application/json'
    header 'Content-Type', 'application/json'
  end

  def header_xml
    header 'Accept', 'text/xml'
    header 'Content-Type', 'text/xml'
  end
end

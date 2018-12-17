module ApiHelpers
   include Rack::Test::Methods

  def header_json
    header 'Accept', 'application/json'
    header 'Content-Type', 'application/json'
  end

  def header_xml
    header 'Accept', 'text/xml'
    header 'Content-Type', 'text/xml'
  end
end

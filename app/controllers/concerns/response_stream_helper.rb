module ResponseStreamHelper
  def response_streamer(uri)
    response.content_type = 'text/turtle'

    Net::HTTP.start(uri.host) do |client|
      request = Net::HTTP::Get.new uri

      request.add_field('Accept', 'text/turtle')

      client.request(request) do |turtle_response|
        turtle_response.read_body do |segment|
          response.stream.write segment
        end
      end
    end
  end
end
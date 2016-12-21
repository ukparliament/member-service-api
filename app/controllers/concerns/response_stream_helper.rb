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

  def response_streamer_two(uri)
    format = request.format.to_s
    response.content_type = format

    Net::HTTP.start(uri.host) do |client|
      request = Net::HTTP::Get.new uri

      request.add_field('Accept', format)

      client.request(request) do |turtle_response|
        turtle_response.read_body do |segment|
          response.stream.write segment
        end
      end
    end
  end
end
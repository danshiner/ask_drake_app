class Sender

  class << self

    def respond
      # Fulfill the request
      @advice_request.fulfill
      @advice_request.send

    end

  end

end

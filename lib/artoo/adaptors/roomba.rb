require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a Roomba
    # @see http://www.irobot.com/en/us/robots/Educators/Create.aspx Roomba information
    class Roomba < Adaptor
      attr_reader :sp

      # Creates serial or tcp connection
      # @return [Boolean]
      def connect
        if port.is_serial?
          @sp = connect_to_serial(speed = 115200)
          @sp.dtr = 0
          @sp.rts = 0
        else
          @sp = connect_to_tcp
        end
        super
      end

      # Send bytes to device
      def send_bytes(bytes)
        bytes = [bytes] unless bytes.respond_to?(:map)
        bytes.map!(&:chr)
        Logger.debug "sending: #{bytes.inspect}"
        res = []
        bytes.each{|b| res << @sp.write(b) }
        Logger.debug "returned: #{res.inspect}"
      end

      # Closes connection to device
      # @return [Boolean]
      def disconnect
        @sp.close
        super
      end

    end
  end
end

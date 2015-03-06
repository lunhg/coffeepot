require 'lzma'

class EditorController < WebsocketRails::BaseController

  def initialize_audio
    puts "Initializing audio: \n"
    puts message
    trigger_success message
  end

  def initialize_feedback
    puts message
    trigger_sucess message
  end

  def compile_coffee
    message["code"].gsub!(/[\n ]+/, "")
    c = _decompress_for message["code"]
    message["code"] = _compile c
    puts message
    trigger_success message  
  end

  def compile_stop
    puts "stopping"
    hash = {stop: message.playing}
    trigger_success hash
  end

  private

  # Decompress a chunk of code already compressed with
  # with compress_for method.
  # Compression occurs when we highlight code and generate a link for
  # it
  # usage:: ```
  # #=> In some controller
  # @code = params[:c]
  # #=> In view
  # <%= build_script decompress_for(@code) %>
  # ```
  def _decompress_for(compressed_string)
    hex = [compressed_string].pack("H*")
    string = LZMA.decompress hex
    string
  end

  def _compile(code)
    js = CoffeeScript.compile code, :bare => true, :map => true
    logger.debug js
    js
  end


end

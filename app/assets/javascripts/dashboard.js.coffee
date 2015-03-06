# Place all the behaviors and hooks related to the matching controller here
                          
class SocketWVRuntime

        # define app integration with websocket
        constructor: (@editor) ->
                @dispatcher = new WebSocketRails "#{window.location.host}/websocket"
                
        init: (audio_options) ->
                onfail = (message) ->
                        for k, v of message
                                console.log("#{k} #{v}")
                                
                onsucess = (message) =>
                        console.log("creating runtime:")
                        console.log("bufferSize: #{message.bufferSize}")
                        console.log("channels: #{message.channels}")
                        @runtime = new WavepotRuntime(null, message.bufferSize, message.channels)
                        @runtime.init()     
                        ons =  (m) -> console.log "Created"
                        @dispatcher.trigger 'initialize.feedback', {created: not not @runtime}, ons, onfail

                
                                
                @dispatcher.trigger 'initialize.audio', audio_options, onsucess, onfail

        play: ->
                if @runtime
                        code = @editor.getValue()
                        lzma = LZMA.compress @editor.getValue(), 1, (result) =>
                                result = convert_to_formated_hex result
                                ons = (message) =>
                                        @runtime.compile message.code
                                        @runtime.play()
                                onf = (message) ->
                                        console.log message
                                        
                                @dispatcher.trigger 'compile.coffee', {code: result}, ons, onf
                                        
                
        stop: ->
                ons = (message) =>
                        if message.stop
                                console.log "Stopping"
                                @runtime.stop()
                                
                onf = (message) ->
                        console.log message
                        
                @dispatcher.trigger 'compile.stop', {playing: @runtime.playing}, ons, onf

$(document).ready ->
        window.runtime = runtime = new SocketWVRuntime(window.editor)
        runtime.init bufferSize: 1024, channels:2
        $('#play').click -> runtime.play()
        $('#stop').click -> runtime.stop()

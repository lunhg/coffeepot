
$(document).ready ->
        # start websocket and initialize
        # Wavepotruntime calling server
        dispatcher = new WebSocketRails "#{window.location.host}/websocket"
        
        window.runtime = null
        
        oninitfail = (message) -> console.log("#{k} #{v}") for k, v of message
        
        oninitsucess = (message) ->
                console.log("creating runtime:")
                console.log("bufferSize: #{message.bufferSize}")
                console.log("channels: #{message.channels}")
                window.runtime = new WavepotRuntime(null, message.bufferSize, message.channels)
                window.runtime.init()     
                onis = (m) ->
                        console.log "Created"
                onif = (m) ->
                        console.log message
                dispatcher.trigger 'initialize.feedback', {created: if runtime then true else false}, onis, onif 
                                              
        dispatcher.trigger 'initialize.audio',{bufferSize: 1024, channels:2}, oninitsucess, oninitfail

        play = ->
                console.log "start compiling"
                code = window.editor.getValue()
                LZMA.compress window.editor.getValue(), 3, (result) =>
                        result = convert_to_formated_hex result
                        ons = (message) =>
                                runtime.compile message.code
                                runtime.play()                   
                        onf = (message) -> console.log message              
                        dispatcher.trigger 'compile.coffee', {code: result}, ons, onf

        $('#play').click ->
                 if runtime and not runtime.playing
                       play()
                                
        $('#stop').click ->
                runtime.stop()
                
        $('#reset').click ->
                runtime.runtime.reset()
                
        window.editor.getSession().on 'change', (e) ->
                setTimeout ->
                        if runtime.playing
                                console.log "start compiling"
                                code = window.editor.getValue()
                                LZMA.compress window.editor.getValue(), 3, (result) =>
                                        result = convert_to_formated_hex result
                                        ons = (message) =>
                                                runtime.compile message.code
                                                runtime.play()
                                                
                                        onf = (message) ->
                                                console.log message
                                        
                                        dispatcher.trigger 'compile.coffee', {code: result}, ons, onf
                , 2000

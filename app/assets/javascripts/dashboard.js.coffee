
$(document).ready ->
        # start websocket and initialize
        # Wavepotruntime calling server
        dispatcher = new WebSocketRails "#{window.location.host}/websocket"
        
        runtime = null
        
        oninitfail = (message) -> console.log("#{k} #{v}") for k, v of message
        
        oninitsucess = (message) ->
                console.log("creating runtime:")
                console.log("bufferSize: #{message.bufferSize}")
                console.log("channels: #{message.channels}")
                runtime = new WavepotRuntime(null, message.bufferSize, message.channels)
                runtime.init()     
                onis = (m) ->
                        console.log "Created"
                onif = (m) ->
                        console.log message
                dispatcher.trigger 'initialize.feedback', {created: not not @runtime}, onis, onif 
                                              
        dispatcher.trigger 'initialize.audio',{bufferSize: 1024, channels:2}, oninitsucess, oninitfail
                                
        $('#play').click ->
                 if runtime and not runtime.playing
                        console.log "start compiling"
                        code = window.editor.getValue()
                        LZMA.compress window.editor.getValue(), 3, (result) =>
                                result = convert_to_formated_hex result
                                ons = (message) =>
                                        try
                                                runtime.compile message.code
                                                runtime.play()
                                        catch e
                                                console.log e
                                                
                                onf = (message) ->
                                        console.log message
                                        
                                dispatcher.trigger 'compile.coffee', {code: result}, ons, onf
                                
        $('#stop').click ->
                runtime.stop()
                
        $('#reset').click ->
                runtime.runtime.reset()
                
        window.editor.getSession().on 'change', (e) ->
                if runtime.playing
                        console.log "start compiling"
                        code = window.editor.getValue()
                        LZMA.compress window.editor.getValue(), 3, (result) =>
                                result = convert_to_formated_hex result
                                ons = (message) =>
                                        try
                                                runtime.compile message.code
                                                runtime.play()
                                        catch e
                                                console.log e
                                                
                                onf = (message) ->
                                        console.log message
                                        
                                dispatcher.trigger 'compile.coffee', {code: result}, ons, onf
        null


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

        $a = $("<a>Push play and then record</a>")
        $("#controls").append $a
        
        $('#play').click ->
                if runtime and not runtime.playing
                        $a.html('playing')
                        play()
                        
                           
        $('#stop').click ->
                $a.html('stopped')
                runtime.stop()
                
                
        $('#reset').click -> runtime.reset()

        $a.click ->
                this.attr("href", "")
                
        $('#record').click ->
                
                ons = (message)->
                        console.log "Starting record: #{message}"
                        $a.html "Recording..."
                        runtime.record true

                 onf = (message) ->
                         console.log "Stopping record: #{message}"
                         $a.html "...encoding..."
                         runtime.record false
                         runtime.exportWAV (blob) ->
                                 console.log blob
                                 runtime.stop()
                                 runtime.clear()
                                 $a.html("click me to download").attr("download", "#{Date.now()}.wav").attr "href", window.URL.createObjectURL(blob)
    
                dispatcher.trigger 'record.request', {record: not runtime.recording}, ons, onf
                
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

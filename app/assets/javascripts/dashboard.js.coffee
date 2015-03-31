# Based on Jquery
# maybe its better to switch to pure DOM?
$(document).ready ->
        # start websocket and initialize
        # Wavepotruntime calling server
        dispatcher = new WebSocketRails "#{window.location.host}/websocket"

        # our audio runtime
        window.runtime = null

        # if fail, give a message
        oninitfail = (message) ->
                console.log("#{k} #{v}") for k, v of message

        # if sucess on create
        # initialize audio
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

        # Send a message to server
        dispatcher.trigger 'initialize.audio',{bufferSize: 1024, channels:2}, oninitsucess, oninitfail

        # This is the on_play message
        # That will be called after server send a message
        on_play = (message) =>
                bytes = ""
                for i in [0..message.code.length-1]
                        c = message.code[i] 
                        if i == 0 or i % 2 > 0 
                                bytes = "#{bytes}#{c}"          
                        else
                                bytes = "#{bytes} #{c}"

                bytes = convert_formated_hex_to_bytes bytes
                                
                LZMA.decompress bytes, (decompressed) ->
                        msg = "playing"
                        runtime.compile decompressed
                        runtime.play()
                        $a.html msg
                                        
        # This will play; the process will be:
        # - get Editor content
        # - compress it
        # - send to server
        # - on server compiled, decompress the compressed javascript
        # - compile in wavepot runtime
        # - finnaly play!
        play = ->
                # Get content
                msg = "start compiling"
                $a.html msg
                console.log msg
                code = window.editor.getValue()

                # Compress it, needs reformating
                LZMA.compress code, 3, (result) =>
                        msg = "send to server"
                        $a.html msg
                        console.log msg
                        result = convert_to_formated_hex result

                        # on server triggered, decompress
                        # the compressed javascript
                        # and send to server  
                        dispatcher.trigger 'compile.coffee', {code: result}, on_play, (message) -> console.log message


        # This is a simple console on top of editor
        $a = $("<a>Push play and then record</a>")
        $("#controls").append $a
      
        # The play button need play when isnt playing
        $('#play').click -> if runtime and not runtime.playing then play()
                                       
        # Stop stuff             
        $('#stop').click ->
                $a.html('stopped')
                runtime.stop()
                
                
        # reset stuff
        $('#reset').click -> runtime.reset()

        # When user click <a> element, initialize
        # Download step
        $a.click -> this.attr("href", "")

        # The record button    
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



        # The livecoding
        # Editor heart
        timer = null

        # The editor detect when user stop to type
        # Then waits for 1 second
        # and then play                   
        editor.getSession().on 'change', (e) ->    
                clearTimeout timer
                timer = setTimeout play, 1000
                

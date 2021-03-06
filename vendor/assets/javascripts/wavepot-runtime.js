// quick implementation of the wavepot script playback engine

function WavepotRuntime(context, bufferSize, channels) {
	this.code = '';
	this.scope = {};
	this.time = 0;
	this.context = context || new AudioContext();
	this.playing = false;
	this.bufferSize = bufferSize || 1024;
	this.scriptnode = this.context.createScriptProcessor(this.bufferSize, 0, channels || 2);
        this.worker = new Worker('assets/recorderWorker.js');
        this.worker.postMessage({
          command: 'init',
          config: {
            sampleRate: this.context.sampleRate
          }
        });
        this.recording = false;
}

WavepotRuntime.prototype.init = function(callback){
        var _this = this;
        this.scriptnode.onaudioprocess = function(e) {
        	var out = [e.outputBuffer.getChannelData(0), e.outputBuffer.getChannelData(1)];
        	var f = 0, t = 0, td = 1.0 / _this.context.sampleRate;
        	if (_this.scope && _this.scope.dsp && _this.playing) {
        		t = _this.time;
        		for (var i = 0; i < out[0].length; i++) {
        			f = _this.scope.dsp(t);
			        if(typeof(f) === 'number'){
			            out[0][i] =  f
        			    out[1][i] =  f
				}
			        else if (typeof(f) === 'object'){
				    out[0][i] =  f[0]
        			    out[1][i] =  f[1]
				}
        			t += td;
        		}
        		_this.time = t;
        	} else {
        		for (var i = 0; i < out[0].length; i++) {
        			out[0][i] = f[0] | f
        			out[1][i] = f[1] | f
        		}
        	}
	        if (_this.recording){
		    _this.worker.postMessage({
			command: 'record',
			buffer: out
		    });
		}
        }
	this.scriptnode.connect(_this.context.destination);
}

WavepotRuntime.prototype.compile = function(code) {
	// console.log('WavepotRuntime: compile', code);
	this.code = code;
	var newscope = new Object();
	try {
		var f = new Function('var sampleRate=' + this.context.sampleRate+ ';\n\n' + code + '\n\nthis.dsp = dsp;');
		console.log(f);
		var r = f.call(newscope);
		console.log(r);
	} catch(e) {
		console.error('WavepotRuntime: compilation error', e);
	}
	// console.log('WavepotRuntime: compiled', newscope);
	if (newscope && typeof(newscope.dsp) == 'function') {
		this.scope = newscope;
		return true;
	} else {
		return false;
	}
}

WavepotRuntime.prototype.play = function() {
	// console.log('WavepotRuntime: play');
	this.playing = true;
}

WavepotRuntime.prototype.stop = function() {
	// console.log('WavepotRuntime: stop');
	this.playing = false;
}

WavepotRuntime.prototype.reset = function() {
	// console.log('WavepotRuntime: reset');
	this.time = 0;
}

WavepotRuntime.prototype.record = function(b){
        this.recording = b;
}

WavepotRuntime.prototype.clear = function(){
        this.worker.postMessage({ command: 'clear' });
}

WavepotRuntime.prototype.exportWAV = function(cb){
      type =  'audio/wav';
      if (!cb) throw new Error('Callback not set');
      this.worker.postMessage({
        command: 'exportWAV',
        type: type
      });
      this.worker.onmessage = function(e){
        var blob = e.data;
        cb(blob);
      }
}



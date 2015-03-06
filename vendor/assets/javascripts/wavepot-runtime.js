// quick implementation of the wavepot script playback engine

function WavepotRuntime(context) {
	this.code = '';
	this.scope = {};
	this.time = 0;
	this.context = context || new AudioContext();
	this.playing = false;
	this.bufferSize = 1024;
	this.scriptnode = this.context.createScriptProcessor(this.bufferSize, 0, 1);	
}

WavepotRuntime.prototype.init = function(callback){
        var _this = this;
        this.scriptnode.onaudioprocess = function(e) {
        	var out = e.outputBuffer.getChannelData(0);
        	var f = 0, t = 0, td = 1.0 / this.context.sampleRate;
        	if (_this.scope && _this.scope.dsp && _this.playing) {
        		t = _this.time;
        		for (var i = 0; i < out.length; i++) {
        			f = _this.scope.dsp(t);
        			out[i] = f;
        			t += td;
        		}
        		_this.time = t;
        	} else {
        		for (var i = 0; i < out.length; i++) {
        			out[i] = f;
        		}
        	}
        }
	this.scriptnode.connect(this.context.destination);
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

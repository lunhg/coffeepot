class DashboardController < ApplicationController
  def index
    @code = """# Welcome to coffeepot
# this is a version from wavepot.com
# using coffeescript language (see coffeescript.org)
# TAU is a simple trigonometric value
tau = 2 * Math.PI;
# a helper function: t is the sample index; but you can think as phase
t_mod_f = (f, t)-> t % (1 / f) * f
# A simple sinusoid
# f -> Frequency
# a -> Amplitude
# t -> sample index
sin = (f, a, t) -> Math.sin(f * t * tau)
# A simple sawtooth
saw = (f, a, t) -> (1 - 2 * t_mod_f(f, t))* a
# A ramp function wave
ramp = (f, a, t) -> (2 * t_mod_f(f, t) - 1) * a
# A triangular wave
tri = (f, a, t) -> (Math.abs(1 - (2 * t * f) % 2) * 2 - 1) * a
# A square wave
sqr = (f, a, t) -> ((t*f % 1/f < 1/f/2) * 2 - 1) * a
# A pulse square wave
# w -> width of boundaries
pulse = (f, a, w, t) -> ((t*f % 1/f < 1/f/2*w) * 2 - 1) * a
# A white noise signal
noise = (a)->  (Math.random() * 2 - 1) * a
# Envelope
envelope = (t, head, measure, decay, release) ->
  ts = t / head % measure;
  Math.exp -ts * decay * Math.exp(ts * release)

# You can return a simple number (monoaural)
# Or you can a return an 2 element array (stereo 2 channels)
dsp = (t) ->
  l = sin 440, 0.25, t
  r = sin 443, 0.25, t
  [l, r]"""
  end

end

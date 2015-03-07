class DashboardController < ApplicationController
  def index
    @code = """# Welcome to coffeepot
# this is a version from wavepot.com
# using coffeescript language (see coffeescript.org)
# let's make sound!

# TAU is a simple trigonometric value
tau = 2 * Math.PI;

# a helper function
# t is the sample index
# but you can think as phase
t_mod_f = (f, t)-> t % (1 / f) * f

# A simple sinusoid
# f -> Frequency
# a -> Amplitude
# t -> sample index
sin = (f, a, t) -> Math.sin(f * t * tau)

# A simple sawtooth
saw = (f, a, t) ->
  sig = 1 - 2 * t_mod_f(f, t)
  sig * a

# A ramp function wave
ramp = (f, a, t) ->
  sig = 2 * t_mod_f(f, t) - 1
  sig * a

# A triangular wave
tri = (f, a, t) ->  
  sig = Math.abs(1 - (2 * t * f) % 2) * 2 - 1
  sig * a

# A square wave
sqr = (f, a, t) -> 
  sig = (t*f % 1/f < 1/f/2) * 2 - 1
  sig * a

# A pulse square wave
# w -> width of boundaries
pulse = (f, a, w, t) ->
  sig = (t*f % 1/f < 1/f/2*w) * 2 - 1
  sig * a

# A white noise signal
noise = (a)->  
  sig = Math.random() * 2 - 1
  sig * a

# In final you must return this function
# but inside, you can do anything, but must
# return a number or array
dsp = (t) ->  pulse ramp(tri(10, 0.71, t), sqr(5, 1, t), t), sin(0.00002, 1, t), saw(440, 0.71, t), t"""
  end
end

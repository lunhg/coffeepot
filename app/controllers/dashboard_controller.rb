class DashboardController < ApplicationController
  def index
    @code = """# Welcome to coffeepot
# this is a version from wavepot.com
# using coffeescript language (see coffeescript.org)
# let's make sound!

# TAU is trigonometric circle
TAU = Math.PI * 2

# A simple sinusoid
sin = (t, amp) -> Math.sin(t * TAU * 440) * amp

# A simple noise
noise = (amp) -> (Math.random() * 2 - 1) * amp

# In final you must return this function
# but inside, you can do anything, but must
# return a number or array
dsp = (t) -> noise(0.21) * sin(t, 0.71)"""
  end
end

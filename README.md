# Coffeepot

This is a simple implementation of [wavepot](http://www.wavepot.com) using [coffee-script](http://www.coffeescript.org) as languge to compile [dsp](http://www.dspguide.com)

## Features

Coffeepot is built on top of Ruby on rails; In fact I made another [project](https://www.github.com/jahpdyaknowboutblogmusic) with gibber.audio.lib,  and this is a step to change on ideas proposed by wavepot.com team. To make compilation in realtime, i used websocket-rails and coffeescript-rails modules.

## Installation

The app works with ruby and and node.js; if you already have, you can jump to

### Ruby

you need first ruby installed in system, to do this follow these steps:

- If you are in linux environment:

~~~{.bash}
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
$ \curl -sSL https://get.rvm.io | bash -s stable
$ rvm install 2.1.2
~~~

- If you are in MacOsx environment:

~~~{.bash}
\curl -sSL https://get.rvm.io | bash -s stable --rails
$ rvm install 2.1.2
~~~

### Node.js

Te ruby application runs a node.js in order to translate coffeescript language in javascript. So you need install node.js with nvm:

~~~{.bash}
$ curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash
~~~

- You will need these following lines on your ~/.bashrc:

~~~{.bash}
export NVM_DIR="/home/<somename>/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
~~~

- install the latest version of node.js:
~~~{.bash}
nvm install 0.12.0
nvm use 0.12.0
~~~

Once installed, you can add the last line in ~/.bashrc to load automatically node.js to your terminal session

### Github

Download project:

~~~{.bash}
$ git clone https://www.github.com/jahpd/coffeepot
~~~

## Running

To run app do this:

~~~{.bash}
$ cd coffeepot/
$ bundle install
$ rails s
~~~

in webrowser (suport to chrome and firefox) go to `localhost:3000` and make some sounds with coffeescript like in wavepot:

![screen1](screeshots/screen1.png)

- Play: will send a message to server, requesting compile the script; you must write a dsp function:

~~~{.coffeescript}
# ...
# any above code
# and now making a white noise
# with simple math
dsp = (t) -> (Math.random() * 2) - 1
~~~

(maybe you will like more pure sounds?)

~~~{.coffeescript}
# ...
# any above code
# and now making a sinusoid
# with a trigonometric math
dsp = (t) -> Math.sin 2*Math.PI * 440 * t
~~~

Or you can do this:

~~~{.coffeescript}
# ...
# any above code
# and some definitions
tau = 2*Math.PI
white_noise = (amplitude) -> ((Math.random() * 2) - 1) * amplitude
sinusoid = (freq, amp, phase) -> (Math.sin(tau * freq * phase)) * amplitude

# and now making a white noise
# controlled by a sinusoid
dsp = (t) -> white_noise sinusoid(1, 0.5, t)
~~~







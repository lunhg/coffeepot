# Coffeepot

This is a simple implementation of [wavepot](http://www.wavepot.com) using [coffee-script](http://www.coffeescript.org) as languge to compile [dsp](http://www.dspguide.com)

## Features

Coffeepot is built on top of Ruby on rails; In fact I made another [project](https://www.github.com/jahpdyaknowboutblogmusic) with gibber.audio.lib,  and this is a step to change on ideas proposed by wavepot.com team. To make compilation in realtime, i used websocket-rails and coffeescript-rails modules.

## Installation

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
~~~

- Install node.js with nvm:

~~~{.bash}
$ curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash
~~~

- You will need these following lines on your ~/.bashrc:

~~~{.bash}
export NVM_DIR="/home/guilherme/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
~~~

- install the latest version of node.js:
~~~{.bash}
nvm install 0.12.0
nvm use 0.12.0
~~~

Once installed, you can add the last line in ~/.bashrc to load automatically node.js to your terminal session

## Running

To run app do this:

~~~{.bash}
$ cd coffeepot/
$ bundle install
$ rails s
~~~

Go to `localhost:3000` and make some sounds with coffeescript like in wavepot





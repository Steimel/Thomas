Network
=========

Proof of concept for the NetworkController and ThomasClient

Starting the Session
====================

First, you'll need to install the Thomas gem

    ./build_and_install_gem.sh

Then, you'll need to start the server in one terminal window

    ruby example/network/server.rb

Then, you can start the client in another terminal window

    ruby example/network/client.rb

You may need to increase the size of your shell window to fit the screen.
Alternatively, you could decrease the screen size by modifying the server.rb file

Usage
=====

Press any key on either screen and see it show up.

Quit by pressing q
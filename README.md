# Argus -- Parrot AR Drone Ruby API

## Current Status

* Experimental
* Subject to change
* Use at your own risk
* May cause cancer

## Example

```ruby
  require 'argus'

  drone = Argus::Drone.new
  drone.start

  drone.take_off
  sleep 5
  drone.turn_right(1.0)
  sleep 5
  drone.turn_left(1.0)
  sleep 5
  drone.hover.land
  sleep 5
  drone.stop
```

## Providing external socket

You can also use Argus by providing an externally created socket. For example, if you are using Artoo (http://artoo.io), which makes use of celluloid-io (https://github.com/celluloid/celluloid-io). Normally in this use case, you would want to NOT use the automatic navigation callbacks, as they are not guaranteed to be thread safe within Celluloid.

```ruby
  require 'argus'
  require 'celluloid/io'

  include Celluloid::IO

  socket = UDPSocket.new
  drone = Argus::Drone.new(socket: socket)
  drone.start(false) # do not auto-notify on nav callbacks

  drone.take_off
  sleep 5
  drone.turn_right(1.0)
  sleep 5
  drone.turn_left(1.0)
  sleep 5
  drone.hover.land
  sleep 5
  drone.stop
```


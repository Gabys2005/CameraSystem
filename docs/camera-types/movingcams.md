# Moving Cameras

Moving cameras are cameras that move on the defined track. The individual parts in the model have to be named from 1 to however many points you have. By default the first point is green, last is red and every other is yellow.

## Required attributes

* `Time` - type: `number` - The time it takes to get from the first point to the last point, in seconds.

## Optional attributes

* `Bezier` - type: `boolean` - if set to true, the track will be a Bezier curve. *Note: current implementation is pretty bad and could cause a lot of lag with a lot of points*

## Point attributes

Each point can have it's own attributes which can change the way the system moves along the track:

* `Time` - type: `number` - The time it'll change to move from this point to the next one, only apples to this point
* `Fov` - type: `number` - This attribute tells the system what fov should be set to at this point. If the point it is set on is the first one, then the fov will instantly snap to that value, otherwise it'll slowly transition from the last forced fov point, or from the beggining.
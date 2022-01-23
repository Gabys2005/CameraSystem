# Static Cameras

Static cameras are cameras that do not move. By default they're blue, but that can be changed.

## Optional attributes

* `Fov` - type: `number` - What the fov should be set to when this camera is selected.
* `Updating` - type: `boolean` - if set to `true`, when that camera is selected, the system will update it's position every frame instead of once. Useful when you want to attach it to a physical camera model for example.
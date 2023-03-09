# Volumetric Fog

This is an example of Godot's volumetric fog capabilities with the Vulkan renderer.

Showcased features are:

- Positive/negative density volumes that affect albedo (incoming light) and emission.
- Box/ellipsoid shapes, height falloff, and density modulation using a 3D texture.
- Temporal reprojection for greater stability and avoiding flickering.
  - The difference is demonstrated with a moving fog volume.
- Global density adjustment. With FogVolume nodes that have a positive density,
  it's possible to apply volumetric fog only in specific areas.

Language: GDScript

Renderer: Vulkan Clustered

## Screenshots

![Screenshot](screenshots/volumetric_fog.png)

# Hack-a-Thing 1 - ARKit for iOS

Hackathing 1 for CS98 

Tony DiPadova and Alex Chan

### Motivation


Neither of us have any experience with Swift or with AR applications, so we decided to experiment with both. We are attempting to create a simple augmented reality app that projects an image onto the floor and allows us to add 3D objects to the environment. 

### Tutorial

We started by following a [tutorial](https://medium.freecodecamp.org/how-to-get-started-with-ar-in-swift-the-easy-way-7399fe1c82f5) for an app that places texture images onto the floor using an iPhone camera. We then followed another [tutorial](https://medium.freecodecamp.org/how-to-get-started-with-augmented-reality-in-swift-by-decorating-your-home-85671482df3c) for adding furniture.

### How It Works

When you run the app the camera opens. If you move it around, eventually it will detect surfaces. Any horizontal surface is defined as the floor. An image of a marble floor is projected onto the surface. If you tap on the surface, a 3D table is placed on it which you can move around and look at.
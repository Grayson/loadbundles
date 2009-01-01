# LoadBundles

LoadBundles is a simple developer's tool that I wrote to solve on basic need: loading arbitrary bundles into Mac OS X applications easily.  I have this need because I hack applications fairly frequently in order to add Applescript support.  Since I often don't have direct access to the code, it helps to write InputManagers in order to test out code.  Well, installing InputManagers is a pain.  LoadBundles is intended to be a simple means of loading bundles into particular programs.

## How it works

LoadBundles is actually two components.  The first is an InputManager.  The InputManager simply reads a small dictionary of apps and associated bundles, finds any matches, and then loads associated bundles.  The second is a rather simple application that (1) installs the InputManager if necessary and (2) lets you associate applications and bundles.  You can add associations by pressing the "+" button in the lower-left hand side of the window.  Two open dialog boxes will pop up.  The first will ask you to choose an application.  The second will ask for the bundle.  The information will be saved to the app's preferences file which will be read by the InputManager.

## Contact information

For more information, complaints, or suggestions, please write to:

[Grayson Hansard](mailto:info@fromconcentratesoftware.com)  
[From Concentrate Software](http://www.fromconcentratesoftware.com/)
# impama

im = immutable
pa = package
ma = manager

impama is a package manager made for immutable Linux distributions.

It will make it easy to install packages that are usually difficult to install on immutabe Linux.

impama is meant to be a middle ground between Distrobox / Toolbx and modifiying the base image of your Linux distribution.

impama will install packages into /home/$USER/.local/ OR /usr/local/

impama will have a very small amount of curated packages because it's meant to install only certain types of packages like printer drivers.

Depending on the package they will be modified from the original upstream package to make it work on immutable Linux.

The package manager is meant strictly for immutable Linux distributions that aren't meant to be modified and don't have their own way of dealing with package installs. i.e. Fedora Silverblue and it's variants, MicroOS, Aeon, Kalpa, stillOS, ect.

For impama to work /home/$USER/local needs to be writtable and ideally /usr/local/ also needs to be writtable.

So distributions like NixOS and VanillaOS which already have their own solutions to this issue don't need impama.

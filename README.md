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

As the sole copyright holder, I hereby permanently and irrevocably waive the requirements in Section 3(a)(1)(A)(i) (attribution/credit) and Section 3(a)(1)(B) (indication of modifications) of the CC BY-NC 4.0 license for this work. You are not required to credit me or list any changes, although both are appreciated. All other terms, including the NonCommercial restriction (no commercial use allowed), remain in full effect.

Shield: [![CC BY-NC 4.0][cc-by-nc-shield]][cc-by-nc]

This work is licensed under a
[Creative Commons Attribution-NonCommercial 4.0 International License][cc-by-nc].

[![CC BY-NC 4.0][cc-by-nc-image]][cc-by-nc]

[cc-by-nc]: https://creativecommons.org/licenses/by-nc/4.0/
[cc-by-nc-image]: https://licensebuttons.net/l/by-nc/4.0/88x31.png
[cc-by-nc-shield]: https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg

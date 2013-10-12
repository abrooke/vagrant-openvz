# Vagrant::Openvz

LINUX ONLY TECHNOLOGY.

This is primarily a provider plugin for vagrant. The provider integrates openvz with the normal actions associated with vagrant including: up, ssh, halt, destroy.

Successfully used in combination with the following vagrant plugins:

vagrant-omnibus
agrant-berkshelf

## Credits

Two other code bases contributed to the work involved in creating this plugin: vagrant-lxc, and vagrant itself.

## Platforms

Centos 6.4
Others may work, though usability unknown as of now.

## Installation without building

The plugin requires that you openvz and vagrant be installed. Then run the following from the command line which will install it from rubygems.org:

vagrant plugin install vagrant-openvz.

## Boxes

Boxes are bare bones and currently depend on the templates provided by OpenVZ. You can download the one tested box from "box/centos-6-x86_64/centos-6-x86_64.box" in this source repository, however on first usage the actualy template for the box will be downloaded through openvz.

## Building the plugin

1. Download the source code (if your going to contribute see next section) 
2. Install bundler
3. Navigate to the downloaded source code, and within the same folder as the "Gemfile" file run "bundle" to get depedencies.

Reference
* Book: Vagrant, up and running; Chapter 7; Section "Plugi-In Development Basics"

## Contributing

During development on Centos 6(.4), in order to use: "bundle exec vagrant box add" I had to download the latest version of vagrant. Track down "bsdtar" and put it in a new folder, then add the folder path to the PATH. Then export it. This way the functionality would work properly.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## ROADMAP (Features not yet added).

* Port Forwarding.
* Improve usage of env[:ui] logging. 
* Tokenize all hardcoded text.

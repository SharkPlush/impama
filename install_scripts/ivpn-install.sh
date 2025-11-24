#!/bin/bash

# PROOF OF CONCEPT FILE TESTED ON AEON DESKTOP

# https://github.com/ivpn/desktop-app/blob/master/docs/readme-build-manual.md

# THIS DETECTS IF TOOLBX OR DISTROBOX IS INSTALLED IF BOTH ARE INSTALLED WE PREFER DISTROBOX
detect_containerizer () {
  # WE CHECK IF DISTROBOX IS INSTALLED
  if command -v distrobox &> /dev/null; then
  echo "Distrobox detected"
  CONTAINERIZER="DB"
  compile_app
  
  # IF DISTROBOX ISN'T INSTALLED WE CHECK FOR TOOLBX
  elif command -v toolbox &> /dev/null; then
  echo "Toolbx detected"
  CONTAINERIZER="TB"
  compile_app
  
  # IF NONE ARE INSTALLED WE EXIT
  else
  echo "Distrobox and / or Toolbx not installed exiting.."
  exit 1
  fi
  }
# THIS FUNCTION COMPILES THE APPLICATION
compile_app () {

  # WHILE TOOLBX DOES WORK I DON'T LIKE IT BECAUSE I CANNOT SET A CUSTOM HOME DIRECTORY SO ANY INSTALLS OR CACHE MADE FROM WITHIN THE CONTAINER END UP IN THE USER HOME DIRECTORY INSTEAD OF A CUSTOM HOME DIRECTORY THAT GETS WIPED LIKE WITH DISTROBOX
  
  # ALSO I DON'T KNOW IF TOOLBX WORKS IN THE SCRIPT RIGHT NOW I DONT HAVE A SYSTEM WITH TOOLBX

  # IF ONLY TOOLBX IS INSTALL WE COMPILE WITH TOOLBX
  if [[ "$CONTAINERIZER" == "TB" ]]; then
  toolbox create temp-compiling-impama --distro fedora --release 42
  toolbox enter temp-compiling-impama -- bash -c "
  sudo dnf upgrade -y
  sudo dnf install golang git npm nodejs ruby ruby-dev gcc make curl rpm libiw-dev astyle cmake ninja-build libssl-dev python3-pytest python3-pytest-xdist unzip xsltproc doxygen graphviz python3-yaml valgrind -y
  sudo gem install fpm
  git clone https://github.com/ivpn/desktop-app.git /home/$USER/.cache/desktop-app
  cd /home/$USER/.cache/desktop-app/cli/References/Linux/
  echo | IVPN_BUILD_SKIP_GLIBC_VER_CHECK=1 ./build.sh
  cd /home/$USER/.cache/desktop-app/ui/References/Linux/
  echo | IVPN_BUILD_SKIP_GLIBC_VER_CHECK=1 ./build.sh
  "
  toolbox stop temp-compiling-impama
  toolbox rm temp-compiling-impama
  fi
  install_app
  
  # IF DISTROBOX IS INSTALLED WE COMPILE WITH DISTROBOX
  if [[ "$CONTAINERIZER" == "DB" ]]; then
  distrobox-create --name temp-compiling-impama --image fedora:42 --home /home/$USER/.cache/impama_temp_home_directory
  distrobox enter temp-compiling-impama -- bash -c "
  sudo dnf upgrade -y
  sudo dnf install golang git npm nodejs ruby ruby-dev gcc make curl rpm libiw-dev astyle cmake ninja-build libssl-dev python3-pytest python3-pytest-xdist unzip xsltproc doxygen graphviz python3-yaml valgrind -y
  sudo gem install fpm
  git clone https://github.com/ivpn/desktop-app.git /home/$USER/.cache/impama_temp_home_directory/desktop-app
  cd /home/$USER/.cache/impama_temp_home_directory/desktop-app/cli/References/Linux/
  echo | IVPN_BUILD_SKIP_GLIBC_VER_CHECK=1 ./build.sh
  cd /home/$USER/.cache/impama_temp_home_directory/desktop-app/ui/References/Linux/
  echo | IVPN_BUILD_SKIP_GLIBC_VER_CHECK=1 ./build.sh
  "
  distrobox rm temp-compiling-impama
  fi
  install_app
  }
  
install_app () {

  # IF WE COMPILED WITH TOOLBX
  if [[ "$CONTAINERIZER" == "TB" ]]; then
  sudo mkdir /usr/local/{share,bin}
  sudo mkdir /usr/local/share/applications/
  sudo mkdir -p /opt/ivpn/{etc,dnscrypt-proxy,kem,obfs4proxy,v2ray,wireguard-tools,ui}
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/common/etc/ca.crt
  sudo chmod 400 /home/$USER/.cache/desktop-app/daemon/References/common/etc/ca.crt
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/common/etc/ca.crt /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/common/etc/dnscrypt-proxy-template.toml
  sudo chmod 400 /home/$USER/.cache/desktop-app/daemon/References/common/etc/dnscrypt-proxy-template.toml
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/common/etc/dnscrypt-proxy-template.toml /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/common/etc/servers.json
  sudo chmod 600 /home/$USER/.cache/desktop-app/daemon/References/common/etc/servers.json
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/common/etc/servers.json /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/common/etc/ta.key
  sudo chmod 400 /home/$USER/.cache/desktop-app/daemon/References/common/etc/ta.key
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/common/etc/ta.key /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/client.down
  sudo chmod 700 /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/client.down
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/client.down /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/client.up
  sudo chmod 700 /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/client.up
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/client.up /opt/ivpn/etc/  
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/firewall.sh
  sudo chmod 700 /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/firewall.sh
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/firewall.sh /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/splittun.sh
  sudo chmod 700 /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/splittun.sh
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/etc/splittun.sh /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/dnscryptproxy_inst/dnscrypt-proxy
  sudo chmod 755 /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/dnscryptproxy_inst/dnscrypt-proxy
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/dnscryptproxy_inst/dnscrypt-proxy /opt/ivpn/dnscrypt-proxy/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/kem-helper/kem-helper-bin/kem-helper
  sudo chmod 755 /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/kem-helper/kem-helper-bin/kem-helper
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/kem-helper/kem-helper-bin/kem-helper /opt/ivpn/kem/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/obfs4proxy_inst/obfs4proxy
  sudo chmod 755 /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/obfs4proxy_inst/obfs4proxy
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/obfs4proxy_inst/obfs4proxy /opt/ivpn/obfs4proxy/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/v2ray_inst/v2ray
  sudo chmod 755 /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/v2ray_inst/v2ray
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/v2ray_inst/v2ray /opt/ivpn/v2ray/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg
  sudo chmod 755 /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg /opt/ivpn/wireguard-tools/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg-quick
  sudo chmod 755 /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg-quick
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg-quick /opt/ivpn/wireguard-tools/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/daemon/References/Linux/scripts/_out_bin/ivpn-service
  sudo cp /home/$USER/.cache/desktop-app/daemon/References/Linux/scripts/_out_bin/ivpn-service /usr/local/bin/
  
  sudo chown root:root /home/$USER/.cache/desktop-app/cli/References/Linux/_out_bin/ivpn
  sudo cp /home/$USER/.cache/desktop-app/cli/References/Linux/_out_bin/ivpn /usr/local/bin/
  
  sudo chown -R root:root /home/$USER/.cache/desktop-app/ui/dist/bin/
  sudo cp -r /home/$USER/.cache/desktop-app/ui/dist/bin/ /opt/ivpn/ui/
  
  sudo chown root:root /home/marksergeyev/.cache/desktop-app/ui/References/Linux/ui/IVPN.desktop
  sudo cp /home/marksergeyev/.cache/desktop-app/ui/References/Linux/ui/IVPN.desktop /opt/ivpn/ui/
  
  sudo chown -R root:root /home/marksergeyev/.cache/desktop-app/ui/References/Linux/ui/IVPN.desktop
  sudo cp /home/marksergeyev/.cache/desktop-app/ui/References/Linux/ui/IVPN.desktop /usr/local/share/applications/
  
  sudo chown -R root:root /home/marksergeyev/.cache/desktop-app/ui/References/Linux/ui/ivpnicon.svg
  sudo cp /home/marksergeyev/.cache/desktop-app/ui/References/Linux/ui/ivpnicon.svg /opt/ivpn/ui/
  fi

  # IF WE COMPILED WITH DISTROBOX
  if [[ "$CONTAINERIZER" == "DB" ]]; then
  sudo mkdir /usr/local/{share,bin}
  sudo mkdir /usr/local/share/applications/
  sudo mkdir -p /opt/ivpn/{etc,dnscrypt-proxy,kem,obfs4proxy,v2ray,wireguard-tools,ui}
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/ca.crt
  sudo chmod 400 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/ca.crt
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/ca.crt /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/dnscrypt-proxy-template.toml
  sudo chmod 400 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/dnscrypt-proxy-template.toml
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/dnscrypt-proxy-template.toml /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/servers.json
  sudo chmod 600 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/servers.json
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/servers.json /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/ta.key
  sudo chmod 400 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/ta.key
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/common/etc/ta.key /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/client.down
  sudo chmod 700 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/client.down
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/client.down /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/client.up
  sudo chmod 700 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/client.up
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/client.up /opt/ivpn/etc/  
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/firewall.sh
  sudo chmod 700 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/firewall.sh
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/firewall.sh /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/splittun.sh
  sudo chmod 700 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/splittun.sh
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/etc/splittun.sh /opt/ivpn/etc/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/dnscryptproxy_inst/dnscrypt-proxy
  sudo chmod 755 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/dnscryptproxy_inst/dnscrypt-proxy
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/dnscryptproxy_inst/dnscrypt-proxy /opt/ivpn/dnscrypt-proxy/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/kem-helper/kem-helper-bin/kem-helper
  sudo chmod 755 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/kem-helper/kem-helper-bin/kem-helper
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/kem-helper/kem-helper-bin/kem-helper /opt/ivpn/kem/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/obfs4proxy_inst/obfs4proxy
  sudo chmod 755 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/obfs4proxy_inst/obfs4proxy
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/obfs4proxy_inst/obfs4proxy /opt/ivpn/obfs4proxy/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/v2ray_inst/v2ray
  sudo chmod 755 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/v2ray_inst/v2ray
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/v2ray_inst/v2ray /opt/ivpn/v2ray/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg
  sudo chmod 755 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg /opt/ivpn/wireguard-tools/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg-quick
  sudo chmod 755 /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg-quick
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/_deps/wireguard-tools_inst/wg-quick /opt/ivpn/wireguard-tools/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/scripts/_out_bin/ivpn-service
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/daemon/References/Linux/scripts/_out_bin/ivpn-service /usr/local/bin/
  
  sudo chown root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/cli/References/Linux/_out_bin/ivpn
  sudo cp /home/$USER/.cache/impama_temp_home_directory/desktop-app/cli/References/Linux/_out_bin/ivpn /usr/local/bin/
  
  sudo chown -R root:root /home/$USER/.cache/impama_temp_home_directory/desktop-app/ui/dist/bin/
  sudo cp -r /home/$USER/.cache/impama_temp_home_directory/desktop-app/ui/dist/bin/ /opt/ivpn/ui/
  
  sudo chown root:root /home/marksergeyev/.cache/impama_temp_home_directory/desktop-app/ui/References/Linux/ui/IVPN.desktop
  sudo cp /home/marksergeyev/.cache/impama_temp_home_directory/desktop-app/ui/References/Linux/ui/IVPN.desktop /opt/ivpn/ui/
  
  sudo chown -R root:root /home/marksergeyev/.cache/impama_temp_home_directory/desktop-app/ui/References/Linux/ui/IVPN.desktop
  sudo cp /home/marksergeyev/.cache/impama_temp_home_directory/desktop-app/ui/References/Linux/ui/IVPN.desktop /usr/local/share/applications/
  
  sudo chown -R root:root /home/marksergeyev/.cache/impama_temp_home_directory/desktop-app/ui/References/Linux/ui/ivpnicon.svg
  sudo cp /home/marksergeyev/.cache/impama_temp_home_directory/desktop-app/ui/References/Linux/ui/ivpnicon.svg /opt/ivpn/ui/
  fi
  
  # IVPN NEEDS A SYSTEMD SERVICE SO WE CREATE ONE
  sudo tee /etc/systemd/system/ivpn-service.service << EOF
[Unit]
Description=ivpn-service

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/local/bin/ivpn-service 
Restart=always
WorkingDirectory=/
TimeoutStopSec=infinity

[Install]
WantedBy=multi-user.target
EOF

  # IF SELINUX IS PRESENT WE NEED TO RELABEL THE FILES OTHERWISE IT MIGHT CAUSE PROBLEMS
  if command -v sestatus &> /dev/null; then
  sudo restorecon -Rv /opt/ivpn
  sudo restorecon -v /usr/local/bin/ivpn-service
  sudo restorecon -v /usr/local/bin/ivpn
  fi

  sudo systemctl daemon-reload 
  sudo systemctl start ivpn-service
  sudo systemctl enable ivpn-service
  sudo update-desktop-database /usr/local/share/applications/
  
  # CLEANUP TOOLBX INSTALL
  if [[ "$CONTAINERIZER" == "TB" ]]; then  
  sudo rm -r /home/$USER/.cache/desktop-app/
  fi
  
  # CLEANUP DISTROBOX INSTALL
  if [[ "$CONTAINERIZER" == "DB" ]]; then  
  sudo rm -r /home/$USER/.cache/impama_temp_home_directory/
  fi
  }
detect_containerizer

#!/usr/bin/env bash

# Variáveis
urlGoogleChrome="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
dirDownloads="$HOME/Downloads/InstalacaoAuto"

listaProgramasInstalar=(
  snapd
  vim
  openssh-server
  neofetch
  gnome-tweak-tool
  wine-stable
  obs-studio
  apache2
  vlc
  git
  net-tools
  nmap
)

# Removendo possiveis travas do apt
clear
printf "[*] Removendo travas do apt...\n\n"
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

# Atualizando repositório
printf "[-] Atualizando repositório...\n\n"
sudo apt update -y

# Criando pastas de personalização
printf "[-] Verificando pastas de personalização do GNOME...\n\n"
if ls -d $HOME/.themes | grep .themes; then
  printf "[*] Diretório .themes encontrado!\n"
else
  printf "[*] Criando diretório .themes...\n"
  mkdir $HOME/.themes
fi

if ls $HOME -a | grep .icons; then
    printf "[*] Diretório .icons encontrado!\n"
else
    echo "[*] Criando diretório .icons...\n\n"
    mkdir $HOME/.icons
fi

# Atualizando o repositório
printf "[-] Atualizando repositório...\n"
sudo apt update -y

# Download de programas externos
mkdir "$dirDownloads"
printf "[-] Baixando Google Chrome...\n"
wget -c "$urlGoogleChrome" -P "$dirDownloads"

# Instalando os pacotes .deb
printf "[-] Instalando debian packages...\n "
sudo dpkg -i $dirDownloads/*.deb

# Instalar programas no apt
printf "[-] Instalando programas pelo apt...\n"
for programa in ${listaProgramasInstalar[@]}; do
  if ! dpkg -l | grep -q $programa; then
    apt install "$programa" -y
  elses
    echo "[*] $programa - [INSTALADO]"
  fi
done

## Instalando pacotes Snap
sudo snap install code
sudo snap install slack --classic
sudo snap install photogimp


#Grub
printf "[-] Instalando GRUB personalizado"
sudo chmod +x $dirDownloads/grub/install.sh
sudo ./$dirDownloads/grub/install.sh

# Themes
cp -R ./themes/* $HOME/.themes

#Icons
cp -R ./icons/* $HOME/.icons

# Atualização e limpeza
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean
sudo apt autoremove -y
printf "[*] Instalaçaõ concluída!\n\n"

# Abrindo abas de instalação de extensões
sudo apt-get install chrome-gnome-shell
google-chrome https://extensions.gnome.org/extension/19/user-themes/
google-chrome https://extensions.gnome.org/extension/307/dash-to-dock/
google-chrome https://extensions.gnome.org/extension/1251/blyr/
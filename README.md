# Home Server con k3s

## Instalación y configuración

### Configuramos red

Archivo /etc/network/interfaces
```sh
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

allow-hotplug ens33
#iface ens33 inet dhcp
iface ens33 inet static
    address 192.168.1.10
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 9.9.9.9 149.112.112.112
```

Y reiniciamos el servicio (aunque lo mejor es reinciar la maquina)
```sh
sudo systemctl disable --now NetworkManager
sudo systemctl restart networking
```

### Ejecutar poweroff y reboot sin sudo y contraseña

Para usar poweroff y reboot sin poner la contraseña
```sh
sudo EDITOR=vim visudo -f /etc/sudoers.d/power

# Y añadimos la linea
sysroot ALL=(ALL) NOPASSWD: /usr/sbin/poweroff, /usr/sbin/reboot, /usr/sbin/shutdown
```

### Montamos la unidad y la añadimos a fstab

Formateamos el disco
```sh
sudo wipefs -a /dev/sdX
sudo cfdisk /dev/sdX
sudo mkfs.ext4 -m 0 /dev/sdX1
```

Montamos el disco
```sh
sudo mkdir /mnt/storage
sudo mount /dev/sdX1 /mnt/storage
sudo chown -R 1000:1000 /mnt/storage

# sacamos el UUID del disco
sudo blkid /dev/sdX1
```

Añadimos a /etc/fstab
```sh
UUID="xxxxxxxxxxxxxxxxxx"       /mnt/storage    ext4            defaults	0 2
```

Recargamos y montamos
```sh
# Primero desmontamos
sudo umount /mnt/storage

sudo systemctl daemon-reload
sudo mount -a
```

creamos las carpetas y damos los permisos necesarios
```sh
mkdir -p /mnt/storage/torrents
mkdir -p /mnt/storage/media/{movies,tv,videos}

sudo chown -R 1000:1000 /mnt/storage/torrents
sudo chown -R 1000:1000 /mnt/storage/media

# mkdir -p /mnt/storage/sftpgo
# sudo chown -R 1000:1000 /mnt/storage/sftpgo

# mkdir -p /mnt/storage/nextcloud-data
# sudo chown -R 33:33 /mnt/storage/nextcloud-data
# 33 es el usuario www-data de apache
```

## Instalamos K3s

Instalamos k3s
```bash
curl -sfL https://get.k3s.io | sh -
```

### Configurar

#### kubectl

Por defecto, necesitas usar sudo k3s kubectl. Para usar kubectl directamente:

Copiar kubeconfig
```bash
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

# Añadir a .bashrc/.zshrc
echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
source ~/.bashrc
```

#### Habilitar Gateway API

Creamos el archivo `/var/lib/rancher/k3s/server/manifests/traefik-config.yaml`
```bash
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    providers:
      kubernetesGateway:
        enabled: true
```

#### Instalar y Configuramos cert-manager

Instalar cert-manager

Debemos tener Helm instalado
```bash
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash
```

Agregamos el repositorio de Helm
```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
```

Instalar cert-manager
```bash
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true
```

Clonamos el repositorio
```bash
git clone https://github.com/omarmpastor/homeserver-k3s.git

# Entramos en el directorio
cd homeserver-k3s
```

Configuramos Cert-manager y gateway
```bash
helm install infra ./infra \
  --set wildcardCertificate.commonName="*.example.local" \
  --set wildcardCertificate.subjectOrganization="Example Organization" \
  --set wildcardCertificate.dnsNames[0]="*.example.local" \
  --set wildcardCertificate.dnsNames[1]="example.local"
```

Ahora añadimos las apps desde [doc/ADD_APPS.md](https://github.com/omarmpastor/homeserver-k3s/blob/main/doc/ADD_APPS.md)


Para configurarlas una vez añadidas desde [doc/CONFIGURE_SERVICES.md](https://github.com/omarmpastor/homeserver-k3s/blob/main/doc/CONFIGURE_SERVICES.md)



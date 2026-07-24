# Instalacion de apps

Antes de nada generamos los secretos y el namespace necesarios
```bash
helm install config ./charts-apps/config \
  --set appSecret.data.APP_USER=user \
  --set appSecret.data.APP_PASSWORD='password'
```

## Instalamos apps

Vamos a instalar las apps
```bash
# helm install <chart> charts-apps/<chart> --namespace homeserver

# O si queremos especificar el dominio
# helm install <chart> charts-apps/<chart> --namespace homeserver --set httpRoute.domain="example.local"
```

```bash
helm install dashboard charts-apps/dashboard --namespace homeserver --set httpRoute.domain="example.local"
helm install gitea charts-apps/gitea --namespace homeserver --set httpRoute.domain="example.local"
helm install pihole charts-apps/pihole --namespace homeserver --set httpRoute.domain="example.local"
helm install jellyfin charts-apps/jellyfin --namespace homeserver --set httpRoute.domain="example.local"
helm install media-download charts-apps/media-download --namespace homeserver --set httpRoute.domain="example.local"
```

Ahora tenemos que añadir a nuestro DNS las apps
* pihole.example.local
* dashboard.example.local
* gitea.example.local
* qbittorrent.example.local
* jellyfin.example.local
* prowlarr.example.local
* radarr.example.local
* sonarr.example.local
* bazarr.example.local


Vamos a configurar las apps desde [doc/CONFIGURE_SERVICES.md](https://github.com/omarmpastor/homeserver-k3s/blob/main/doc/CONFIGURE_SERVICES.md)



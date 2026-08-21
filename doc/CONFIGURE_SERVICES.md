# Configuración de apps y servicios

## qBittorrent

Lo primero necesitamos conocer el password que nos ha puesto por defecto. Esto está en los logs del pod (Ejecutamos: `kubectl logs -n homeserver $(kubectl get pods -n homeserver -l app=qbittorrent -o name)`)

Vamos a https://qbittorrent.example.local

Entramos en la interfaz con `admin` y el password temporal que nos ha creado:
- Vamos a Tools > Options > WebUI y cambiamos el password. Si no queremos que nos pida usuario y contraseña, marcamos: `Bypass authentication for clients in whitelisted IP subnets` y le añadimos nuestra red `192.168.1.0/24`
- Vamos a Tools > Options > Behavior > User interface language > Español

### Sonarr/Radarr

Nos conectamos a
* https://radarr.example.local para radarr
* https://sonarr.example.local para sonarr

La primera vez que nos conectemos nos pedira que establezcamos un login:

* Authentication Method: Form (Login Page)
* Authentication Required: Disabled for Local Addresses
* Username: [username]
* Password: [password]

Vamos a Settings -> Media Management -> Pinchamos en el icono de arriba "Show Advanced"
- Dejamos marcado -> Use Hardlinks instead of Copy
- Al final en el botón Add Root Folder, añadimos
  - "/storage/Movies/" para radarr
  - "/storage/TV/" para sonarr
- Guardamos cambios

Vamos a Settings -> Download Clients -> + -> qBittorrent
- Host: qbittorrent-svc
- Port: 8090
- Username: [username]
- Password: [password]
- Dejamos marcado: Remove imported downloads from dowload client history

(solo radarr) Vamos a Settings -> Profiles -> Entramos a cada uno de ellos -> Language -> Spanish (sino no nos busara en prowlarr en español)

### Jackett

Nos conectamos a https://jackett.example.local

Ponemos una contraseña de administrador en [Admin password]

Pinchamos en Add Indexer -> DonTorrent (tarda en añadirlo, comprueba un rato)

### Prowlarr

Nos conectamos a https://prowlarr.example.local

La primera vez que nos conectemos nos pedira que establezcamos un login:

* Authentication Method: Form (Login Page)
* Authentication Required: Disabled for Local Addresses
* Username: [username]
* Password: [password]

Vamos a Settings -> Apps -> Añadimos Radarr
* Prowlarr Server: https://prowlarr:9696
* Radarr Server: https://radarr:7878
* API Key: Vamos a radarr -> Settings -> General -> API Key y la copiamos

Vamos a Settings -> Apps -> Añadimos Sonarr
* Prowlarr Server: https://prowlarr:9696
* Sonarr Server: https://sonarr:8989
* API Key: Vamos a sonarr -> Settings -> General -> API Key y la copiamos

Vamos a Settings -> Download Clients -> + -> qBittorrent
- Host: qbittorrent
- Port: 8090
- Username: [username]
- Password: [password]

Ahora vamos a Indexers (No a Settings > Indexers) -> Add Indexer y añadimos los que queramos

* Elitetorrent-wf (Ya no existe, no podremos añadirlo)
* Vamos a añadir DonTorrent desde Jackett:
  * Le damos a añadir y elegimos "Generic Torznab"
  * Name: DonTorrent
  * Enable: Activado
  * Redirect: Desactivado
  * URL (hay un botón "Copy Torznab Feed" en jackett, pero sustituimos el dominio por http://jackett-svc:9117): http://jackett-svc:9117/api/v2.0/indexers/dontorrent/results/torznab/
  * API Key: Copiamos la API key de Jackett
  * Pinchamos en Test y Guardamos
* Podemos añadir más desde Jackett utilizando el mismo procedimiento: DivxTotal, Wolfmax4K, etc

## Jellyfin

Arrancamos el proyecto: Desde arcane > Proyectos > Elegimos jellyfin > Subir

Vamos a https://jellyfin.example.local

Usamos el asistente para configurar el servidor estableciendo en Español y poniendo usuario y contraseña:
* Username: [username]
* Password: [password]

Configuramos 4 bibliotecas multimedia
- Tipo: Peliculas, Nombre: Peliculas, Carpetas: /data/movies, Idioma preferido de visualizado: Spanish Castillian, Pais: Spain
- Tipo: Series, Nombre: Series, Carpetas: /data/tvshows, Idioma preferido de visualizado: Spanish Castillian, Pais: Spain
- Tipo: Vídeos caseros y fotos, Nombre: Vídeos, Carpetas: /data/videos
- Tipo: Vídeos caseros y fotos, Nombre: Youtube, Carpetas: /data/youtube

Dejamos marcado: Permitir conexiones remotas a este servidor

Vamos a Panel de Control > Usuarios y añadimos omar

## Gitea

Arrancamos el proyecto: Desde arcane > Proyectos > Elegimos gitea > Subir

Vamos a https://gitea.example.local

Ahora nos sale la configuracion por defecto, vamos bajo del todo y pinchamos en "Instalar Gitea"

Nos aparece para crear un usuario:
* Username: [username]
* Email: [username]@example.local
* Password: [password]

Ahora vamos a https://gitea.example.local/-/admin/users y creamos un usuario

## Nextcloud

Vamos a https://nextcloud.example.local

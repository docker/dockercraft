Dockercraft
===========

![Dockercraft](https://github.com/docker/dockercraft/raw/master/docs/img/logo.png?raw=true)

Un simple client Minecraft pour Docker permettant de visualiser et gérer ses conteneurs.

![Dockercraft](https://github.com/docker/dockercraft/raw/master/docs/img/dockercraft.gif?raw=true)

[Vidéo YouTube](http://www.youtube.com/watch?v=eZDlJgJf55o)

>   Attention: Merci d'utiliser Dockercraft sur votre propre ordinateur. Il ne prend pas en charge l'authentification. Chaque joueur doit être considéré comme un utilisateur root !

Comment lancer Dockercraft
--------------------------

1.  **Installez Minecraft:** [minecraft.net](https://minecraft.net)

Le client Minecraft n'a pas été modifié, utilisez simplement la version officiel de Minecraft

1.  **Montez l'image disque de Dockercraft:** (une image dique officielle sera bientôt disponible)

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    docker pull gaetan/dockercraft
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    or

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    git clone git@github.com:docker/dockercraft.git
    docker build -t gaetan/dockercraft dockercraft
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2.  **Lancez un conteneur Dockercraft:**

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    docker run -t -i -d -p 25565:25565 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name dockercraft \
    gaetan/dockercraft
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    Monter `/var/run/docker.sock` à l'interieur du conteneur est nécessaire pour envoyer des requetes à l'API de Docker.

    Le port par défaut d'un serveur Minecraft est *25565*, si vous voulez choisir un port différent: `-p <port>:25565`

3.  **Ouvrir Minecraft > Multijoueur > Ajouter Serveur**

    L'adresse serveur est l'IP de l'hôte Docker. Vous n'avez pas besoin d'itentifier un port si vous utilisez déjà celui par défaut.

    Si vous utilisez [Docker Machine](https://docs.docker.com/machine/install-machine/): `docker-machine ip <machine_name>`

4.  **Rejoignez le serveur!**

    Vous devriez voir au moins un conteneur dans votre monde, qui est celui hébergé par votre serveur Dockercraft.

    Vous pouvez démarrer, stopper et supprimer des conteneurs en intéragissant avec les leviers et les boutons. Quelques commandes Docker sont aussi supporté directement via la fenettre de conversation sur Minecraft, appuyer sur `T` (raccourcis par defaut) ou sur `/` pour l'afficher.

>   Une commande commence toujours par `/`.

>   Si vous ouvrez la fenêtre de conversation avec `/` , le caractère `/` sera deja présent, mais si vous l’ouvrez avec `T` , il ne sera pas pré-écrit, vous devrez donc l’écrire avant de taper votre commande Docker.

>   exemple: `/docker run redis`.

![Dockercraft](https://github.com/docker/dockercraft/raw/master/docs/img/landscape.png?raw=true)

Nouveautés à venir
------------------

Ce n’est que le début de Dockercraft! Nous allons intégrer de nombreuses fonctionnalités de Docker:

-   Lister des [Docker Machines](https://docs.docker.com/machine/) et utiliser des portails pour voir ce qu’elles contiennent.

-   Permettre l’utilisation d’encore plus de commandes Docker

-   Afficher les [logs](https://docs.docker.com/v1.8/reference/commandline/logs/) (pour chaque conteneurs, appuyer sur un simple bouton)

-   Représenter les liens

-   Réseau Docker

-   Volumes Docker

-   ...

Si vous êtes intéressé par le design de Dockercraft, des discussions se déroule [à ce propos](https://github.com/docker/dockercraft/issues/19). Aussi, nous utilisons [Magicavoxel](https://voxel.codeplex.com) pour faire ces jolis prototypes:

![Dockercraft](https://github.com/docker/dockercraft/raw/master/docs/img/voxelproto.jpg?raw=true)

Vous pouvez trouver nos maquettes Magicavoxel dans [ce fichier](!%5BDockercraft%5D(https://github.com/docker/dockercraft/tree/master/docs/magicavoxel)).

Pour avoir des information sur notre projet, suivez nous sur Twitter: [@dockercraft](https://twitter.com/dockercraft).

Comment ça marche
-----------------

Le client Minecraft lui même reste non modifié. Toutes les modifications sont effectuées côté serveur.

Le serveur Minecraft que nous utilisons est <http://cuberite.org>. Un serveur Minecraft compatible avec les serveur de jeux écrit en C++. [github repo](https://github.com/cuberite/cuberite)

Le serveur accepte les plugins et scripts écrit en Lua. Nous en avons donc créé un pour Docker. (world/Plugins/Docker)

Malheureusement, il n’y a aucune bonne API pour communiquer avec ces plugins. Mais il y a un webadmin, et des plugins qui peuvent être adaptés pour "webtabs".

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Plugin:AddWebTab("Docker",HandleRequest_Docker)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

De base cela veut dire que le plugin peut récupérer les requêtes envoyés à `http://127.0.0.1:8080/webadmin/Docker/Docker`.

### Goproxy

Les évènements provenants de l’API Docker son transmis au plugin Lua via un petit *daemon* (écrit en GO). (go/src/goproxy)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func MCServerRequest(data url.Values, client *http.Client) {
    req, _ := http.NewRequest("POST", "http://127.0.0.1:8080/webadmin/Docker/Docker", strings.NewReader(data.Encode()))
    req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
    req.SetBasicAuth("admin", "admin")
    client.Do(req)
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Le goproxy binaire peut aussi executer les paramètres du plugin Lua, pour envoyer des requêtes au daemon:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function PlayerJoined(Player)
    -- refresh containers
    r = os.execute("goproxy containers")
end
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Contribuer
----------

Vous voulez développer sur Dockercraft? Appliquez [le guide des contributions Docker](https://github.com/docker/docker/blob/master/CONTRIBUTING.md).

![Dockercraft](https://github.com/docker/dockercraft/raw/master/docs/img/contribute.png?raw=true)

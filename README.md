# brewinstall

Ce script a pour objectif d'installer [brew](https://brew.sh/) ainsi que des applications cli et MacOS présentes dans des fichiers dédiés.

Le script va également effectuer les opérations suivantes :

- Désactiver la création des fichiers `.DS_Store` sur les partages réseau.
- Activer la commande `locate`

## Préparation

Avant d'exécuter le script, il est nécessaire de vérifier les fichiers suivants :

- `brewinstall.apps.cfg`
- `brewinstall.cask.cfg`

Ces fichiers contiennent les applications qui seront automatiquement installées.
Les lignes commençant par `#` sont ignorées.

## Utilisation


1. Clonez ou téléchargez ce répertoire

2. Éditez `brewinstall.apps.cfg` et `brewinstall.cask.cfg` selon vos besoins

3. Exécutez le script :

```bash
cd brewinstall
./brewinstall.sh
```

> Le script demandera votre mot de passe sudo pour l'opération concernant les fichiers `.DS_Store` et l'activation de la commande `locate`

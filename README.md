# Seminario de git/github/Rstudio

Ejemplo de Rstudio workflow 

## Comandos de git

### Configurar git

git config --global user.name 'Nombre Usuario'

git config --global user.email 'nombre@example.com'

git config --global --list


### Configurar editor por defecto

git config --global core.editor "subl"

### Clonar un repositorio

git clone https://github.com/lsaravia/SeminarioGit.git


### iniciar un repositorio nuevo

git init

### Ver status del repositorio

git status


### Agregar archivos para control de versiones

git add nombredearchivo 


### Guardar version de los archivos controlados

Si el archivo ya esta agregado, se puede hacer un commit sin volver a agregarlo

git commit -am "Mensaje de commit"

### Traer cambios de github

git pull

### Subir cambios al github

git push


### Enlazar repositorio local con remoto

para pushear un repositorio existente desde la consola (terminal) de R poner

git remote add origin ... (ver en GitHub la dirección)
git branch -M main
git push -u origin main

### Para crear una nueva rama 

git checkout -b nueva-rama

### Pushear la rama al remoto (hacer a mano en RStudio)

git push origin nueva-rama

### Luego hacer commits locales y para actualizar el remoto

git push origin nueva-rama

### Para hacer pull request en github

Create a pull request for 'leoNuevo' on GitHub by visiting:
https://github.com/lsaravia/SeminarioGit/pull/new/leoNuevo

Luego del pull-request en el remoto (github) cambiar a la rama main

`git checkout main`

y hacer un pull

`git pull`


### Que pasa cuando hacemos push en un repositorio y tiene cambios

git push

To github.com:EcoComplex/SoilBodySizeSpectra.git
 ! [rejected]        main -> main (fetch first)

error: failed to push some refs to 'github.com:EcoComplex/SoilBodySizeSpectra.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.

luego hay que hacer un 

`git pull` 

y ver si hay que resolver conflictos.


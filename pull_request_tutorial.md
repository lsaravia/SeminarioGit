### Creating a Topical Branch

Creamos una nueva rama para trabajar. Primero actualizamos el repositorio principal (main)

`git pull`

Para crear una rama, use git checkout -b <nuevo-nombre-de-rama> [<nombre-de-rama-base>], donde nombre-de-rama-base es opcional y el valor predeterminado es main. Voy a crear una nueva rama llamada pull-request-test desde la rama maestra y la enviaré a github.

`git checkout -b pull-request-test`

`git push origin pull-request-test`
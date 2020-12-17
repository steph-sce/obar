# User Defined Functions

Le SQL permet de définir ses propres fonctions.

## Contexte

Pour pouvoir appeler une fonction il faut être dans "contexte" de requête,
pour ça le plus simple c'est de faire un `SELECT`
```sql
SELECT RANDOM();
```

## Pourquoi faire des fonctions ?

Les fonctions servent à encapsuler la complexité.

(Un petit peu comme les VIEW, mais la ou sur une VIEW on ne peut faire qu'un SELECT, une fonciton peut contenir n'importe quel groupe de requête SQL).

## Comment ?

https://www.postgresql.org/docs/11/sql-createfunction.html


Pour créer une fonction :
```
CREATE [OR REPLACE] FUNCTION nom_fonction(param_name _type_) RETURNS  _type_ AS
$$
-- Code de la fonction ici
$$
LANGUAGE _lang_ _opti1_ _opti2_
```

`_type_` : Le langage SQL est fortement typé. On est donc obligé de définir explicitement le type de chaque paramètre et du retour de la fonction.

`_lang_` : Postrgres supporte des fonctions dans plusieurs langages, nous on utilisera le `sql`

`_opti1_` : Le premier paramètre d'optimisation sert à mettre en cache le résultat. Il y a 3 valeurs possible :

- `IMMUTABLE` : on parle aussi de fonction "pure". Le même jeu de paramètre donnera toujours le même résultat (ex: une addition). Dans se cas Postgres peut décider de stocker le résultat "en cache" et si on rappelle la fonction avec les même paramètres, il donnera le resultat caché sans exécuter la fonction.
- `VOLATILE` : A l'inverse avec ce mot clé, on indique qu'aucune prédiction / optimisation n'est possbile, Postgres devra à chaque fois ré éxucter la fonction.
- `STABLE` : Sont "stable" les fonctions qui dépendent de l'état de la BDD. En gros tant qu'on ne insère / modifie / supprime pas de ligne le résultat sera toujours le même (ex: le calcul de la moyenne d'un élève ne change pas tant qu'on ne rajoute pas de note).


`_opti2_` : Ce paramètre sert à définir le comportement face à NULL. Deux valeur possible :

- `STRICT` : si au moins un des paramètres vaut NULL alors je n'éxécute pas la fonction et renvoi automatique NULL (Null design pattern)
- `CALLED ON NULL INPUT` : On éxécutera la fonction même si un des params est NULL

```sql
CREATE OR REPLACE FUNCTION hello_world() RETURNS TEXT AS
$$
SELECT 'Hello World !'
$$
LANGUAGE sql IMMUTABLE STRICT;

-- Signature hello_world(TEXT)
CREATE OR REPLACE FUNCTION hello_world("name" TEXT) RETURNS TEXT AS
$$
SELECT 'Hello ' || "name"  || ' !'
$$
LANGUAGE sql IMMUTABLE STRICT;

SELECT hello_world(), hello_world('les Lyra') AS hello_lyra;
```

## RETURNS

En plus de renvoyer une valeur simple on peut aussi renvoyer des valeurs plus complexe (une ligne de table).

Pour ça on précisera en tant que type de `RETURNS` le nom de la table en question.

:warning: A partir du moment ou notre fonction renvoi + d'1 valeur on l'utilisera en tant que "table virtuelle" dans un `FROM`.

```sql
SELECT * FROM quoi_lire();
```

Si on ne veut pas renvoyer une structure complexe mais une liste (aka plusieurs ligne d'une table / vue). Je dois ajouter le mot clé `SETOF` entre `RETURNS` et le type.

```sql
DROP FUNCTION quoi_lire;
CREATE OR REPLACE FUNCTION quoi_lire() RETURNS SETOF post AS
$$
SELECT *
  FROM post
ORDER BY RANDOM() LIMIT 2;
$$
LANGUAGE sql STRICT VOLATILE;

SELECT * FROM quoi_lire();
```

Si jamais la structure que je renvoi ne correspond à aucune table existante je peux utiliser le mot clé `TABLE` (après `RETURNS`) pour définir la structure de ma table virtuelle (dans ce cas le `SETOF` sera implicite).

```sql
DROP FUNCTION quoi_lire;
CREATE OR REPLACE FUNCTION quoi_lire() RETURNS TABLE("id" INT, title TEXT, category TEXT) AS
$$
SELECT post.id,
       post.title,
       category.label
  FROM post
  JOIN category
    ON category.id = post.category_id
ORDER BY RANDOM() LIMIT 2;
$$
LANGUAGE sql STRICT VOLATILE;

SELECT * FROM quoi_lire();
```
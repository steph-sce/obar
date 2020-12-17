-- Deploy obar:040-drink-soft-delete to pg

BEGIN;

-- On va implémenter ici un "soft delete"
-- C'est un principe assez courant sur Internet, l'idée c'est de faire "croire"
-- à l'utilisateur qu'on a supprimé la ligne, mais par sécurité on la conserve
-- dans la base.
-- On va juste la masquer.
-- Concretement on va rajouter une colonne "deleted" à notre table.
-- Et si cette colonne vaut TRUE on considère que la ligne est "supprimé" (donc
-- on le la montrera plus à l'utilisateur)

ALTER TABLE drink
        ADD deleted BOOLEAN DEFAULT FALSE;

-- Du coup on rajoute le filtre pour la vue du menu
CREATE OR REPLACE VIEW menu AS
SELECT drink.id,
       drink.name,
       drink.price,
       ARRAY_AGG(q.quantity || ' ' || ingredient.name) AS recipe
  FROM drink
  JOIN _m2m_drink_ingredient q
    ON drink.id = q.drink_id
  JOIN ingredient
    ON ingredient.id = q.ingredient_id
 WHERE drink.deleted = FALSE
GROUP BY drink.id, drink.name, drink.price;


-- Et on "masque la complexité" dans un fonction pour simplifier la vie des utilisateurs
CREATE FUNCTION delete_drink(drink_id INT) RETURNS VOID AS
$$
    UPDATE drink SET deleted = TRUE WHERE id = drink_id;
$$
LANGUAGE sql VOLATILE STRICT;


COMMIT;
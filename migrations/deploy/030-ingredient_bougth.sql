-- Deploy obar:030-ingredient_bougth to pg

BEGIN;

-- Cette fonction ne renverra rien (elle fait juste un insert)
-- son type de retour est donc VOID
CREATE FUNCTION ingredient_bought(ingredient_id INT, quantity INT) RETURNS VOID AS
$$
    INSERT INTO stock(ingredient_id, quantity) VALUES (ingredient_id, quantity);
$$
LANGUAGE sql VOLATILE STRICT;

COMMIT;

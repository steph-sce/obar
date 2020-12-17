-- Revert obar:030-ingredient_bougth from pg

BEGIN;

DROP FUNCTION ingredient_bought;

COMMIT;

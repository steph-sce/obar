-- Revert obar:001-base-schema from pg

BEGIN;

DROP TABLE stock;
DROP TABLE _m2m_drink_ingredient;
DROP TABLE history;
DROP TABLE drink;
DROP TABLE ingredient;

COMMIT;

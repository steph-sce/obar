TRUNCATE TABLE stock, _m2m_drink_ingredient, history, drink, ingredient RESTART IDENTITY;

INSERT INTO drink(name, price) VALUES
('Gimlet', 10),
('Cosmopolitan', 10),
('Moscow Mule', 12);

INSERT INTO ingredient(name) VALUES
('Gin'),
('Citron Vert'),
('Vodka'),
('Jus de Cranberry'),
('Cointreau'),
('Ginger beer');

INSERT INTO _m2m_drink_ingredient(drink_id, ingredient_id, quantity) VALUES
(1, 1, 6),
(1, 2, 1),
(2, 2, 4),
(2, 3, 2),
(2, 5, 2),
(2, 4, 2),
(3, 3, 6),
(3, 6, 12);

INSERT INTO stock(ingredient_id, quantity) VALUES
(1, 20),
(2, 70),
(3, 70),
(4, 100),
(5, 35),
(6, 200);

INSERT INTO history(drink_id) VALUES
(3),(2),(2);

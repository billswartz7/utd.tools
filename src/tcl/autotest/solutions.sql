PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE solutions ( `Index` INTEGER , var TEXT, definition TEXT);
INSERT INTO "solutions" VALUES(1,'{an $x^2$ on it}','my_x2');
INSERT INTO "solutions" VALUES(2,'{rounding up using the ceil function}','my_ceil');
INSERT INTO "solutions" VALUES(3,'{a sqrt}','my_sqrt');
INSERT INTO "solutions" VALUES(4,'{an $x^3$ on it}','my_x3');
INSERT INTO "solutions" VALUES(5,'{rounding down using the floor function}','my_floor');
COMMIT;

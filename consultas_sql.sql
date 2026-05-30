-- CONSULTA 01 INSERTAR PROPIETARIO----

INSERT INTO tourism.owners (first_name,last_name,company_name,email,phone,tax_id,address_line1,city,state,country,postal_code)
VALUES
('Rocio','Ochoa','RO Software','rocio@gmail.com','77778888','TAX001','Santiago de Maria','Usulutan',
'Usulutan','El Salvador','3401');

----01 Ver el último propietario agregado----
SELECT * FROM tourism.owners ORDER BY owner_id DESC LIMIT 1;


-- CONSULTA 02 INSERTAR ALOJAMIENTO----
INSERT INTO tourism.accommodations (owner_id,accommodation_type_id,location_id,name,description,max_guests,bedroom_count,bathroom_count,base_price_per_night,
currency_code,check_in_time,check_out_time,is_active)
VALUES
(1,1,1,'Hotel Escolar','Alojamiento de prueba',4,2,1,75.00,'USD','14:00','12:00',TRUE);

---02 Ver el propietario junto con el alojamiento que agregue-----
SELECT a.accommodation_id,a.name,o.owner_id,o.first_name,o.last_name
FROM tourism.accommodations a
INNER JOIN tourism.owners o
ON a.owner_id = o.owner_id
WHERE a.name = 'Hotel Escolar';

-- CONSULTA 03 INSERTAR RESERVA---
INSERT INTO tourism.bookings
(guest_id,accommodation_id,room_id,booking_status_id,check_in_date,check_out_date,adult_count,
child_count,subtotal_amount,tax_amount,discount_amount,total_amount,booking_reference,booked_at)
VALUES
(1,21,1,1,'2026-06-10','2026-06-15',2,0,300.00,39.00,0.00,339.00,'RES-2026-001',CURRENT_TIMESTAMP);

--03 Ver la última reserva creada--
SELECT *FROM tourism.bookings ORDER BY booking_id DESC LIMIT 1;

---03 REGISTRAR UNA RESERVA A UN HUESPED ASOCIADO---.
INSERT INTO tourism.bookings (guest_id, accommodation_id,booking_status_id,check_in_date,check_out_date,adult_count,
child_count,subtotal_amount,tax_amount,discount_amount,total_amount,booking_reference,booked_at,created_at,updated_at)
VALUES (
    1,1,1,'2026-06-15', '2026-06-18', 2,
    0, 150.00, 19.50, 0.00,  169.50,
    'RES2026001', 
	CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

---03 VERIFICAR QUE SE REGISTRO CORRECTAMENTE
SELECT *
FROM tourism.bookings
ORDER BY booking_id DESC
LIMIT 1;

---03 MOSTRAR HUESPED Y RESERVA (EVIDENCIA)----
SELECT  g.guest_id, g.first_name,  g.last_name,
        b.booking_id, b.check_in_date, b.check_out_date,
    	b.total_amount
FROM tourism.guests g
INNER JOIN tourism.bookings b ON g.guest_id = b.guest_id
ORDER BY b.booking_id DESC LIMIT 1;

----CONSULTA 04: Consulta 04 - Registrar pago--
---Ver la estructura de la tabla payments---
SELECT column_name, data_type,is_nullable
FROM information_schema.columns
WHERE table_schema='tourism' AND table_name='payments';

---04 REGISTRAR PAGO---
INSERT INTO tourism.payments ( booking_id,payment_date,amount,payment_method,
payment_status,transaction_reference,notes,created_at)
VALUES (1,CURRENT_TIMESTAMP,169.50,'Tarjeta de Crédito',
'Completado','TXN2026001','Pago correspondiente a reserva',
CURRENT_TIMESTAMP);

---04 VERIFICAR QUE EL PAGO SE REGISTRO Y SE ASOCIA A UNA RESERVA---
SELECT p.payment_id, b.booking_reference, p.amount, p.payment_method,
    p.payment_status, p.payment_date
FROM tourism.payments p
INNER JOIN tourism.bookings b ON p.booking_id = b.booking_id
ORDER BY p.payment_id DESC LIMIT 1;


--CONSULTA 05: Filtrar activos---
----05 CONSULTA PARA VER ESTRUCTURA  DEL A TABLA tourism.accommodations---
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema='tourism' AND table_name='accommodations';

---05 FILTRAR ACTIVOS--
SELECT name, 'Activo' AS estado
FROM tourism.accommodations WHERE is_active = TRUE;


---CONSULTA 06: Huéspedes por país - Filtrar por nacionalidad---
SELECT  nationality,
COUNT(*) AS total_huespedes
FROM tourism.guests
GROUP BY nationality
ORDER BY total_huespedes DESC;

--06 Mostrar los huéspedes de un país determinado--
SELECT first_name, last_name, nationality
FROM tourism.guests
WHERE nationality = 'Bulgaria';

---Consulta 07: Reservas por fechas - Uso de BETWEEN----
SELECT b.booking_id, g.first_name, g.last_name,
b.check_in_date, b.check_out_date
FROM tourism.bookings b
INNER JOIN tourism.guests g
ON b.guest_id = g.guest_id
WHERE b.check_in_date BETWEEN '2026-01-01' AND '2026-04-30'
ORDER BY b.check_in_date ASC;

---CONSULTA 08 - UPDATE - Actualizar precio - Modificar precio---
UPDATE tourism.accommodations
SET base_price_per_night = 125.00
WHERE accommodation_id = 1;

--08 Verificar que se actualizó---
SELECT accommodation_id, name,base_price_per_night
FROM tourism.accommodations WHERE accommodation_id = 1;

--CONSULTA 09 - UPDATE - Estado reserva - Actualizar estado---
UPDATE tourism.bookings
SET booking_status_id = 2
WHERE booking_id = 1;

--09 Verificar el cambio--
SELECT b.booking_id, g.first_name,  g.last_name,  b.booking_status_id
FROM tourism.bookings b
INNER JOIN tourism.guests g ON b.guest_id = g.guest_id
WHERE b.booking_id = 1;

--CONSULTA 10: DELETE - Eliminar reseña - DELETE WHERE--
--10 Ver todas las reseñas--
SELECT review_id, booking_id, rating, review_text
FROM tourism.reviews ORDER BY review_id;

--10 : eliminar la reseña con review_id = 3---
DELETE FROM tourism.reviews WHERE review_id = 3;

--10: Verificar que se eliminó---
SELECT review_id, rating, review_text
FROM tourism.reviews
ORDER BY review_id;

--CONSULTA 11:  JOIN - Reservas + huésped - INNER JOIN--
SELECT g.first_name || ' ' || g.last_name AS huesped, b.booking_reference, b.check_in_date, b.check_out_date, b.total_amount
FROM tourism.bookings b
INNER JOIN tourism.guests g ON b.guest_id = g.guest_id
ORDER BY b.check_in_date;

--CONSULTA 12: JOIN - Alojamiento completo - INNER JOIN múltiple--
SELECT a.name AS alojamiento, at.type_name AS tipo_alojamiento,
o.first_name || ' ' || o.last_name AS propietario,
l.city, l.state, l.country, a.max_guests, a.bedroom_count,
a.bathroom_count, a.base_price_per_night, a.is_active
FROM tourism.accommodations a
INNER JOIN tourism.owners o ON a.owner_id = o.owner_id
INNER JOIN tourism.locations l ON a.location_id = l.location_id
INNER JOIN tourism.accommodation_types at ON a.accommodation_type_id = at.accommodation_type_id
ORDER BY a.name;

--CONSULTA 13: JOIN - Pagos + reservas - JOIN combinado---
SELECT p.payment_id,g.first_name || ' ' || g.last_name AS huesped,b.booking_reference,
p.amount,p.payment_method,p.payment_status,p.payment_date
FROM tourism.payments p
INNER JOIN tourism.bookings b ON p.booking_id = b.booking_id
INNER JOIN tourism.guests g  ON b.guest_id = g.guest_id
ORDER BY p.payment_date DESC;

--CONSULTA 14: LEFT JOIN - Sin reseñas - Incluye NULLs--
SELECT a.accommodation_id, a.name
FROM tourism.accommodations a
LEFT JOIN tourism.reviews r ON a.accommodation_id = r.accommodation_id
WHERE r.review_id IS NULL;

--CONSULTA 15: LEFT JOIN - Sin reservas - Filtrar NULL--
SELECT g.guest_id, g.first_name, g.last_name
FROM tourism.guests g
LEFT JOIN tourism.bookings b ON g.guest_id = b.guest_id
WHERE b.booking_id IS NULL;


----CONSULTA 16: AGG - Total ingresos - SUM---
SELECT SUM(amount) AS total_ingresos
FROM tourism.payments;

---CONSULTA 17: AGG - Promedio rating - AVG--
SELECT AVG(rating) AS promedio_rating
FROM tourism.reviews;

----CONSULTA 18: AGG - Top alojamientos - COUNT + LIMIT---
SELECT a.name,
COUNT(b.booking_id) AS total_reservas
FROM tourism.accommodations a
INNER JOIN tourism.bookings b  ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
ORDER BY total_reservas DESC
LIMIT 5;

--CONSULTA 19: HAVING - Más de 3 reservas - GROUP BY + HAVING--
SELECT a.name,  COUNT(*) AS total_reservas
FROM tourism.bookings b
INNER JOIN tourism.accommodations a ON b.accommodation_id = a.accommodation_id
GROUP BY a.name HAVING COUNT(*) > 3
ORDER BY total_reservas DESC;


---CONSULTA 20: Subconsulta - Alojamiento más caro - Subquery---
SELECT name, base_price_per_night
FROM tourism.accommodations
WHERE base_price_per_night = (
SELECT MAX(base_price_per_night)
FROM tourism.accommodations);
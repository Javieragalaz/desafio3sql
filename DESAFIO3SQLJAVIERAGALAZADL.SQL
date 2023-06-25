DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS comentarios;

--Tabla usuarios
CREATE TABLE usuarios (
id SERIAL,
email TEXT,
nombre TEXT,
apellido TEXT,
rol VARCHAR
);

INSERT INTO usuarios (email, nombre, apellido, rol)
VALUES

('juan@adl.com', 'Juan', 'Villanueva', 'administrador'),
('coni@adl.com', 'Constanza', 'Pino', 'usuario'),
('dani@adl.com', 'Daniela', 'Zambrano', 'usuario'),
('fran@adl.com', 'Francisco', 'Aqueveque', 'usuario'),
('ema@adl.com', 'Emanuel', 'Quintrecura', 'usuario');

SELECT * FROM usuarios;

-- Tabla posts
CREATE TABLE posts (
id SERIAL,
titulo VARCHAR (50),
contenido TEXT,
fecha_creacion TIMESTAMP,
fecha_actualizacion TIMESTAMP,
destacado BOOLEAN,
usuario_id BIGINT
);

INSERT INTO posts(titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)

VALUES
('elegia', 'alimentando lluvia, caralolas, a las desalentadas amapolas', '01-04-2022 08:10:00'::timestamp, '22-07-2022 04:22:00'::timestamp, true, 3),
('margarita', 'margarita, esta lista la mar y el viente lleva escencia sutil de azahar', '04-12-2022 12:01:00'::timestamp, '14-02-2023 15:10:00'::timestamp, false, 4 ),
('quedase', 'latir del tiempo que mi sien repite la silaba de sangre', '02-09-2022 22:11:00'::timestamp, '01-06-2023 19:08:00'::timestamp, true, 1),
('por una mirada un mundo', 'por una mirada, un mondo, por una sonrisa, cielo, por un beso yo no se, que te diera por un beso', '01-01-2023 14:48:00'::timestamp, '06-04-2023 15:50:00'::timestamp, true, 2),
('quiereme entera',' si me quieres, no me recortes, quiereme toda, o no me quieras', '20-07-2022 23:00:00'::timestamp, '17-12-2022 13:39:00'::timestamp, true, 1);


SELECT * FROM posts;


-- Tabla comentarios
CREATE TABLE comentarios (
id SERIAL,
contenido TEXT,
fecha_creacion TIMESTAMP,
usuario_id BIGINT,
post_id BIGINT
);

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES
('bueno', '03-04-2023 08:10:00'::timestamp, 1, 1),
('honesto', '05-02-2023 08:10:00'::timestamp, 2, 1),
('virtuoso', '30-03-2023 08:10:00'::timestamp, 3, 1),
('agradable', '23-01-2023 08:10:00'::timestamp, 1, 2),
('humano', '17-04-2023 08:10:00'::timestamp, 2, 2);


SELECT * FROM comentarios;


-- Desafío

--1 Crea y agrega al entregable las consultas para completar el SETUP de acuerdo a los pedido
SELECT * FROM usuarios;
SELECT * FROM posts;
SELECT * FROM comentarios;

--2 Cruza los datos de la tabla usuarios y postos mostrando las siguientes columnas: nombre e email del usuario juntro al título y contenido del post.
SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios u
INNER JOIN posts p
ON u.id = p.usuario_id;

--3 Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier ir y debe ser seleccionado dinámicamente.
SELECT p.id, p.titulo, p.contenido
FROM posts p
INNER JOIN usuarios usuario
ON p.usuario_id = usuario.id WHERE usuario.rol = 'administrador';

--4 Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
SELECT u.id as usuario_id, u.email, COUNT(*) as cantidad_posts
FROM posts p
LEFT JOIN usuarios u
ON p.usuario_id = u.id
WHERE u.email <> ''
GROUP BY u.id, u.email ORDER BY cantidad_posts DESC;

--5 Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT u.email FROM usuarios u INNER JOIN posts p
ON u.id = p.usuario_id GROUP BY u.email
HAVING COUNT(*) = (
SELECT MAX(num_posts) FROM (
SELECT COUNT(*) as num_posts
FROM posts
GROUP BY usuario_id) as subquery);

--6 Muestra la fecha del último post de cada usuario.
SELECT u.nombre, MAX(p.fecha_creacion) ultimo_post
FROM usuarios u
INNER JOIN posts p
ON u.id = p.usuario_id
GROUP BY u.nombre ORDER BY ultimo_post DESC;

--7 Muestra el título y contenido del post con más comentarios
SELECT p.titulo post_con_mas_comentarios, p.contenido FROM posts p LEFT JOIN comentarios c
ON p.id = c.post_id GROUP BY p.titulo, p.contenido
HAVING COUNT (*) = (
SELECT MAX(num_comment) FROM (
SELECT COUNT(*) as num_comment
FROM comentarios
GROUP BY post_id) as subquery);

--8 Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.
SELECT u1.email as autor_post, p.titulo as titulo_post, p.contenido as contenido_post, u2.email as autor_cometario, c.contenido as comentario
FROM posts p
LEFT JOIN comentarios c ON p.id = c.post_id
LEFT JOIN usuarios u1 ON p.usuario_id = u1.id
INNER JOIN usuarios u2 ON u2.id = c.usuario_id;

--9 Muestra el contenido del último comentario de cada usuario.
SELECT u.nombre, c.contenido contenido_ultimo_comentario
FROM (SELECT usuario_id, MAX(fecha_creacion) AS fecha_ult_comentario
FROM comentarios
GROUP BY usuario_id) AS ult_comentario
INNER JOIN comentarios c ON c.usuario_id = ult_comentario.usuario_id AND c.fecha_creacion = ult_comentario.fecha_ult_comentario
INNER JOIN usuarios u ON u.id = c.usuario_id;

-- 10 Muestra los emails de los usuarios que no han escrito ningun comentario.
SELECT u.email as mail_usuarios_sin_comentarios
FROM usuarios u
LEFT JOIN comentarios c on u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;

--Javiera Galaz.



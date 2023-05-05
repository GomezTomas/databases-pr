-- PRACTICO 4
-- 1.
select id_institucion, nombre_institucion
from institucion
where nombre_institucion like '%FUNDACION%';

--2.
select id_distribuidor, id_departamento, nombre
from departamento;

--3.
select nombre, apellido, telefono
from empleado
where id_tarea = '7231'
order by (apellido, nombre);

--4.
select apellido, id_empleado
from empleado
where porc_comision is null;

--5.
select apellido, id_tarea
from voluntario
where id_coordinador is null;

--6.
select *
from distribuidor
where tipo = 'I' and telefono is null;

--7.
select apellido, nombre, e_mail
from empleado
where e_mail like '%@gmail.com' and sueldo > 1000;

--8.
select distinct id_tarea
from empleado;

--9.
select apellido || ', ' || nombre as "Apellido y nombre", e_mail "Direccion de mail"
from voluntario
where telefono like '+51%';

--10.
select nombre || ', ' || apellido as "Nombre, apellido",
       extract(day from fecha_nacimiento) || '-' || extract(month from fecha_nacimiento) as "Dia y mes"
from empleado
order by (extract(month from fecha_nacimiento), extract(day from fecha_nacimiento)) asc;

--11.
select min(horas_aportadas), max(horas_aportadas), avg(horas_aportadas)
from voluntario
where extract(year from fecha_nacimiento) >= 1990;

--12.
select count(*)
from pelicula
group by idioma;


--13.
select count(*)
from empleado
group by id_departamento;

--14.
select codigo_pelicula
from renglon_entrega
group by codigo_pelicula
having count(*) >= 3 and count(*) <= 5;

--15.
select count(*), extract(month from fecha_nacimiento)
from voluntario
group by extract(month from fecha_nacimiento);

--16.
select id_institucion
from voluntario
group by id_institucion
order by count(*) desc
limit 2;

--17.
select id_ciudad
from departamento
group by id_ciudad
having count(*) >1
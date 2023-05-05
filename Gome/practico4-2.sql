-- PRACTICO 4 PARTE 2
-- EJERCICIO 1 -> PELICULAS
-- 1.1 IN
select *
from pelicula
where idioma = 'Inglés' and codigo_pelicula in(
    select codigo_pelicula
    from renglon_entrega
    where nro_entrega in (
        select nro_entrega
        from entrega
        where extract(year from fecha_entrega) = 2006
        )
    );

--1.1 EXISTS
select *
from pelicula p
where idioma = 'Inglés' and exists(
    select 1
    from renglon_entrega r
    where r.codigo_pelicula = p.codigo_pelicula and exists(
        select 2
        from entrega e
        where e.nro_entrega = r.nro_entrega and
              extract(year from fecha_entrega) = 2006
        )
    );

--1.2
select count(*)
from entrega e join distribuidor d on e.id_distribuidor = d.id_distribuidor
where extract(year from e.fecha_entrega) = 2006 and d.tipo = 'N';

--1.3
select id_departamento, id_distribuidor, nombre
from departamento
where (id_departamento, id_distribuidor) not in (
    select e.id_departamento, e.id_distribuidor
    from empleado e
    where e.id_tarea in (
        select t.id_tarea
        from tarea t
        where (t.sueldo_maximo - t.sueldo_minimo) <= (t.sueldo_maximo * 0.1)
        )
    );

--1.4
select count(*)
from pelicula p
where p.codigo_pelicula not in (
    select r.codigo_pelicula
    from renglon_entrega r
    where r.nro_entrega in (
        select e.nro_entrega
        from entrega e
        where e.id_distribuidor in (
            select d.id_distribuidor
            from distribuidor d
            where tipo = 'N'
            )
        )
    );

--1.5
select e.nombre, e.apellido
from empleado e
where e.id_empleado in (
    select e1.id_jefe
    from empleado e1
) and (e.id_departamento, e.id_distribuidor) in (
    select d.id_departamento, d.id_distribuidor
    from departamento d
    where d.id_ciudad in (
        select c.id_ciudad
        from ciudad c
        where c.id_pais in (
            select id_pais
            from unc_esq_peliculas.pais p
            where p.nombre_pais = 'ARGENTINA'
            )
        )
    );

--1.6
select e.nombre, e.apellido
from empleado e join departamento d on e.id_distribuidor = d.id_distribuidor
and e.id_departamento = d.id_departamento join ciudad c on d.id_ciudad = c.id_ciudad
join unc_esq_peliculas.pais p on c.id_pais = p.id_pais
where p.nombre_pais = 'ARGENTINA' and (e.porc_comision + 10.0) >= (
    select porc_comision
    from empleado e1
    where e1.id_empleado = d.jefe_departamento
    );

--1.7
select p.genero, count(*)
from pelicula p
where p.codigo_pelicula in(
    select r.codigo_pelicula
    from renglon_entrega r
    where r.nro_entrega in(
        select e.nro_entrega
        from entrega e
        where extract(year from fecha_entrega) >= 2010
        )
    )
group by p.genero;

--1.8
select fecha_entrega, id_video, sum(cantidad)
from entrega e join renglon_entrega re on e.nro_entrega = re.nro_entrega
group by fecha_entrega, id_video
order by fecha_entrega;

--1.9
select c.nombre_ciudad, count(id_empleado)
from ciudad c join departamento d on c.id_ciudad = d.id_ciudad join empleado e on d.id_distribuidor = e.id_distribuidor and d.id_departamento = e.id_departamento
where extract(year from age(now(), e.fecha_nacimiento)) >= 18
group by c.nombre_ciudad
having count(id_empleado) >= 30;


--EJERCICIO 2 -> VOLUNTARIOS
--2.1
select i.nombre_institucion, count(*)
from institucion i join voluntario v on i.id_institucion = v.id_institucion
group by i.nombre_institucion
order by nombre_institucion;

--2.2
select count(distinct v.id_coordinador) as "Numero de coordinadores", nombre_pais, nombre_continente
from voluntario v join voluntario v1 on v.id_coordinador = v1.nro_voluntario
join institucion i on v.id_institucion = i.id_institucion
join direccion d on i.id_direccion = d.id_direccion
join unc_esq_voluntario.pais p on d.id_pais = p.id_pais
join continente c on p.id_continente = c.id_continente
group by nombre_pais, nombre_continente;

--2.3
select apellido, nombre, fecha_nacimiento
from voluntario
where id_institucion = (
    select id_institucion
    from voluntario
    where apellido = 'Zlotkey'
    )
and apellido != 'Zlotkey';

--2.4
select nro_voluntario, apellido, horas_aportadas
from voluntario
where horas_aportadas > (
    select avg(horas_aportadas)
    from voluntario
    )
order by horas_aportadas;

--EJERCICIO 3
--3.1 opcion 1
create table IF NOT EXISTS DistribuidorNac as
    select d.id_distribuidor, d.nombre, d.direccion, d.telefono, n.nro_inscripcion, n.encargado, n.id_distrib_mayorista
    from unc_esq_peliculas.distribuidor d join unc_esq_peliculas.nacional n on d.id_distribuidor = n.id_distribuidor;

--3.1 opcion 2
CREATE TABLE DistribuidorNac
(
    id_distribuidor numeric(5,0) NOT NULL,
    nombre character varying(80) NOT NULL,
    direccion character varying(120) NOT NULL,
    telefono character varying(20),
    nro_inscripcion numeric(8,0) NOT NULL,
    encargado character varying(60) NOT NULL,
    id_distrib_mayorista numeric(5,0),
    CONSTRAINT pk_distribuidorNac PRIMARY KEY (id_distribuidor)
);

insert into distribuidornac (id_distribuidor, nombre, direccion, telefono, nro_inscripcion, encargado, id_distrib_mayorista),
select d.id_distribuidor, d.nombre, d.direccion, d.telefono, n.nro_inscripcion, n.encargado, n.id_distrib_mayorista
from unc_esq_peliculas.distribuidor d join unc_esq_peliculas.nacional n
    on d.id_distribuidor = n.id_distribuidor;

--3.2
alter table DistribuidorNac add
    codigo_pais varchar(5);

--3.3
update DistribuidorNac set codigo_pais = i.id_distribuidor
from unc_esq_peliculas.internacional i
where DistribuidorNac.id_distribuidor = i.id_distribuidor

--3.4
delete from distribuidornac where DistribuidorNac.id_distrib_mayorista is null;

select *
from distribuidornac
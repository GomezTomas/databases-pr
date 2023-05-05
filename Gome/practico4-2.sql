-- PRACTICO 4 PARTE 2
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
where (id_departamento, id_distribuidor) not in (select e.id_departamento, e.id_distribuidor
                          from empleado e
                          where e.id_tarea in (select t.id_tarea
                                               from tarea t
                                               where (t.sueldo_maximo - t.sueldo_minimo) <= (t.sueldo_maximo * 0.1)));

--1.4
select count(*)
from pelicula p
where p.codigo_pelicula not in(
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




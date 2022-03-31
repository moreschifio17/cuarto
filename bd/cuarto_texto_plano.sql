--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

-- Started on 2021-08-26 21:18:10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2385 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 589 (class 1247 OID 44476)
-- Name: estados; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE estados AS ENUM (
    'ACTIVO',
    'INACTIVO',
    'PENDIENTE',
    'CONFIRMADO',
    'ANULADO'
);


ALTER TYPE estados OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 44487)
-- Name: meses(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION meses(valor integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare
descripcion_mes varchar;
begin
	raise notice '%','Codigo Ingresado '||valor;
	if valor = 1 then
		descripcion_mes = 'Enero';
	end if;
	if valor = 2 then
		descripcion_mes = 'Febrero';
	end if;
	if valor = 3 then
		descripcion_mes = 'Marzo';
	end if;
	case valor 
	when 4 then descripcion_mes = 'Abril';
	when 5 then descripcion_mes = 'Mayo';
	when 6 then descripcion_mes = 'Junio';
	when 7 then descripcion_mes = 'Julio';
	when 8 then descripcion_mes = 'Agosto';
	when 9 then descripcion_mes = 'Septiembre';
	when 10 then descripcion_mes = 'Octubre';
	when 11 then descripcion_mes = 'Noviembre';
	when 12 then descripcion_mes = 'Diciembre';
	else
		if (valor < 1 or valor > 12) then
			descripcion_mes = 'CODIGO DE MES INVALIDO';
			raise exception '%','Codigo Invalido '||valor||' no existe en los meses';
		end if;
	end case;
	raise notice '%','Codigo Valido '||valor||' sin problemas';
	return descripcion_mes;
end;
$$;


ALTER FUNCTION public.meses(valor integer) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 45251)
-- Name: sp_compras_pedidos(integer, date, integer, integer, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_compras_pedidos(cid_cp integer, ccp_fecha date, cid_suc integer, cid_art integer, ccantidad integer, usuario character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then --Insertar compras_pedidos
		perform * from compras_pedidos where id_suc = cid_suc and estado = 'PENDIENTE';
		if found then
			raise exception 'EXISTEN PEDIDOS PENDIENTES DE CONFIRMACION';
		end if;
		insert into compras_pedidos (id_cp, cp_fecha, id_suc, estado, auditoria)
		values ((select coalesce(max(id_cp),0) + 1 from compras_pedidos), ccp_fecha, cid_suc, 'PENDIENTE', 'INSERCION/'||usuario||'/'||now());
		raise notice 'DATOS GUARDADOS CON EXITO';
	end if;
	if operacion = 2 then --Modificar compras_pedidos
		perform * from compras_pedidos where id_cp = cid_cp and estado = 'PENDIENTE';
		if not found then
			raise exception 'ESTE PEDIDO NO SE PUEDE MODIFICAR';
		end if;
		update compras_pedidos set cp_fecha = ccp_fecha, auditoria = coalesce(auditoria,'')||chr(13)||'MODIFICACION/'||usuario||'/'||now() where id_cp = cid_cp;
		raise notice 'DATOS MODIFICADOS CON EXITO';
	end if;
	if operacion = 3 then --Confirmar compras_pedidos
		perform * from compras_pedidos where id_cp = cid_cp and estado = 'PENDIENTE';
		if not found then
			raise exception 'ESTE PEDIDO NO SE PUEDE CONFIRMAR';
		end if;
		perform * from compras_pedidos_detalles where id_cp = cid_cp;
		if not found then
			raise exception 'ESTE PEDIDO NO POSEE DETALLES CARGADOS';
		end if;
		update compras_pedidos set estado = 'CONFIRMADO', auditoria = coalesce(auditoria,'')||chr(13)||'CONFIRMACION/'||usuario||'/'||now() where id_cp = cid_cp;
		raise notice 'DATOS CONFIRMADOS CON EXITO';
	end if;
	if operacion = 4 then --Anular compras_pedidos
		perform * from compras_pedidos where id_cp = cid_cp and estado = 'PENDIENTE';
		if not found then
			raise exception 'ESTE PEDIDO NO SE PUEDE ANULAR';
		end if;
		update compras_pedidos set estado = 'ANULADO', auditoria = coalesce(auditoria,'')||chr(13)||'ANULACION/'||usuario||'/'||now() where id_cp = cid_cp;
		raise notice 'DATOS ANULADOS CON EXITO';
	end if;
	if operacion = 5 then --Insertar compras_pedidos_detalles
		perform * from compras_pedidos where id_cp = cid_cp and estado = 'PENDIENTE';
		if not found then
			raise exception 'A ESTE PEDIDO NO SE PUEDE AGREGAR PRODUCTOS';
		end if;
		perform * from compras_pedidos_detalles where id_cp = cid_cp and id_art = cid_art;
		if found then
			raise exception 'ESTE PRODUCTO YA FUE REGISTRADO';
		end if;
		insert into compras_pedidos_detalles (id_cp, id_art, cantidad, precio)
		values (cid_cp, cid_art, ccantidad, (select precio_compra from articulos where id_art = cid_art));
		raise notice 'PRODUCTO AÑADIDO CON EXITO';
	end if;
	if operacion = 6 then --Modificar compras_pedidos_detalles
		perform * from compras_pedidos where id_cp = cid_cp and estado = 'PENDIENTE';
		if not found then
			raise exception 'A ESTE PEDIDO NO SE PUEDE MODIFICAR CANTIDADES';
		end if;
		update compras_pedidos_detalles set cantidad = ccantidad, precio = (select precio_compra from articulos where id_art = cid_art) where id_cp = cid_cp and id_art = cid_art;
		raise notice 'CANTIDAD MODIFICADA CON EXITO';
	end if;
	if operacion = 7 then --Eliminar compras_pedidos_detalles
		perform * from compras_pedidos where id_cp = cid_cp and estado = 'PENDIENTE';
		if not found then
			raise exception 'A ESTE PEDIDO NO SE PUEDE ELIMINAR PRODUCTOS';
		end if;
		delete from compras_pedidos_detalles where id_cp = cid_cp and id_art = cid_art;
		raise notice 'PRODUCTO ELIMINADO CON EXITO';
	end if;
end;
$$;


ALTER FUNCTION public.sp_compras_pedidos(cid_cp integer, ccp_fecha date, cid_suc integer, cid_art integer, ccantidad integer, usuario character varying, operacion integer) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 45353)
-- Name: sp_compras_presupuestos(integer, date, date, integer, text, integer, integer, integer, integer, integer, integer, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_compras_presupuestos(cid_cpre integer, ccpre_fecha date, ccpre_validez date, ccpre_numero integer, ccpre_observacion text, cid_suc integer, cid_pro integer, cid_art integer, ccantidad integer, cprecio integer, cid_cp integer, usuario text, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare d record;
begin
	if operacion = 1 then --Insertar compras_presupuestos
		insert into compras_presupuestos (id_cpre, cpre_fecha, cpre_validez, cpre_numero, cpre_observacion, id_suc, id_pro, estado, auditoria)
		values ((select coalesce (max(id_cpre),0) + 1 from compras_presupuestos), ccpre_fecha, ccpre_validez, ccpre_numero, ccpre_observacion, cid_suc, cid_pro, 'PENDIENTE', 'INSERCION/'||usuario||'/'||now());
		raise notice '%','DATOS GUARDADOS CON EXITO';
	end if;
	if operacion = 2 then --Modificar compras_presupuestos
		update compras_presupuestos 
		set cpre_fecha = ccpre_fecha, 
		cpre_validez = ccpre_validez, 
		cpre_numero = ccpre_numero, 
		cpre_observacion = ccpre_observacion, 
		id_pro = cid_pro, 
		auditoria = coalesce (auditoria, '')||chr(13)||'MODIFICACION/'||usuario||'/'||now()
		where id_cpre = cid_cpre;
		raise notice '%', 'DATOS MODIFICADOS CON EXITO';
	end if;
	if operacion = 3 then --Confirmar compras_presupuestos
		update compras_presupuestos 
		set estado = 'CONFIRMADO',
		auditoria = coalesce (auditoria, '')||chr(13)||'CONFIRMACION/'||usuario||'/'||now()
		where id_cpre = cid_cpre;
		raise notice '%', 'DATOS CONFIRMADOS CON EXITO';
	end if;
	if operacion = 4 then --Anular compras_presupuestos
		update compras_presupuestos 
		set estado = 'ANULADO',
		auditoria = coalesce (auditoria, '')||chr(13)||'ANULACION/'||usuario||'/'||now()
		where id_cpre = cid_cpre;
		raise notice '%', 'DATOS ANULADOS CON EXITO';
	end if;
	if operacion = 5 then --Insertar compras_presupuestos_detalles
		insert into compras_presupuestos_detalles (id_cpre, id_art, cantidad, precio)
		values (cid_cpre, cid_art, ccantidad, cprecio);
		raise notice '%', 'PRODUCTO AÑADIDO CON EXITO';
	end if;
	if operacion = 6 then --Modificar compras_presupuestos_detalles
		update compras_presupuestos_detalles set cantidad = ccantidad, precio = cprecio where id_cpre = cid_cpre and id_art = cid_art;
		raise notice '%', 'PRODUCTO MODIFICADO CON EXITO';
	end if;
	if operacion = 7 then --Eliminar compras_presupuestos_detalles
		delete from compras_presupuestos_detalles where id_cpre = cid_cpre and id_art = cid_art;
		raise notice '%', 'PRODUCTO ELIMINADO CON EXITO';
	end if;
	if operacion = 8 then --Insertar compras_presupuestos_pedidos desde los pedidos
		for d in select * from compras_pedidos_detalles where id_cp = cid_cp loop
			insert into compras_presupuestos_pedidos (id_cpre, id_cp, id_art, cantidad, precio)
			values (cid_cpre, d.id_cp, d.id_art, d.cantidad, d.precio);
		end loop;
		raise notice '%', 'PEDIDO AÑADIDO CON EXITO';
	end if;
	if operacion = 9 then --Modificar compras_presupuestos_pedidos
		update compras_presupuestos_pedidos set cantidad = ccantidad, precio = cprecio where id_cpre = cid_cpre and id_cp = cid_cp and id_art = cid_art;
		raise notice '%', 'PRODUCTO MODIFICADO CON EXITO';
	end if;
	if operacion = 10 then --Reinsertar compras_presupuestos_pedidos
		select * into d from compras_pedidos_detalles where id_cp = cid_cp and id_art = cid_art;
		insert into compras_presupuestos_pedidos (id_cpre, id_cp, id_art, cantidad, precio)
		values (cid_cpre, cid_cp, cid_art, d.cantidad, d.precio);
		raise notice '%', 'PRODUCTO AÑADIDO CON EXITO';
	end if;
	if operacion = 11 then --Eliminar compras_presupuestos_pedidos
		delete from compras_presupuestos_pedidos where id_cpre = cid_cpre and id_cp = cid_cp and id_art = cid_art;
		raise notice '%', 'PRODUCTO ELIMINADO CON EXITO';
	end if;
end;
$$;


ALTER FUNCTION public.sp_compras_presupuestos(cid_cpre integer, ccpre_fecha date, ccpre_validez date, ccpre_numero integer, ccpre_observacion text, cid_suc integer, cid_pro integer, cid_art integer, ccantidad integer, cprecio integer, cid_cp integer, usuario text, operacion integer) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 44488)
-- Name: sp_paises(integer, character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_paises(cid_pais integer, cpais_descrip character varying, cpais_gentilicio character varying, cpais_codigo character varying, usuario character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then --INSERCION EN paises
		perform * from paises where pais_descrip = upper(trim(cpais_descrip));
		if found then
			raise exception 'ESTE PAIS YA FUE REGISTRADO';
		end if;
		if(trim(cpais_descrip)='')then
			raise exception 'NO SE PUEDE DEJAR VACIA LA DESCRIPCION';
		end if;
		if(trim(cpais_gentilicio)='')then
			raise exception 'NO SE PUEDE DEJAR VACIO EL GENTILICIO';
		end if;
		insert into paises (id_pais, 
				pais_descrip, 
				pais_gentilicio, 
				pais_codigo, 
				estado, 
				auditoria)
		values ((select coalesce(max(id_pais),0) + 1 from paises), 
			upper(trim(cpais_descrip)), 
			cpais_gentilicio, 
			cpais_codigo, 
			'ACTIVO', 
			'INSERCION/'||usuario||'/'||now());
		raise notice 'DATOS GUARDADOS CON EXITO';
	end if;
	if operacion = 2 then --MODIFICACION EN paises
		perform * from paises where pais_descrip = upper(trim(cpais_descrip)) and id_pais != cid_pais;
		if found then
			raise exception 'ESTE PAIS YA FUE REGISTRADO';
		end if;
		update paises 
		set 	pais_descrip = upper(trim(cpais_descrip)), 
			pais_gentilicio = cpais_gentilicio,
			pais_codigo = cpais_codigo,
			auditoria = coalesce(auditoria, '')||chr(13)||'MODIFICACION/'||usuario||'/'||now()
		where id_pais = cid_pais;
		raise notice 'DATOS MODIFICADOS CON EXITO';
	end if;
	if operacion = 3 then --ACTIVAR EN paises
		update paises 
		set 	estado = 'ACTIVO',
			auditoria = coalesce(auditoria, '')||chr(13)||'ACTIVACION/'||usuario||'/'||now()
		where id_pais = cid_pais;
		raise notice 'DATOS ACTIVADOS CON EXITO';
	end if;
	if operacion = 4 then --INACTIVAR O ELIMINAR EN paises
		perform * from ciudades where id_pais = cid_pais;
		if found then
			update paises 
			set 	estado = 'INACTIVO',
				auditoria = coalesce(auditoria, '')||chr(13)||'INACTIVACION/'||usuario||'/'||now()
			where id_pais = cid_pais;
			raise notice 'DATOS INACTIVADOS CON EXITO';
		else
			delete from paises where id_pais = cid_pais;
			raise notice 'DATOS ELIMINADOS CON EXITO';
		end if;
	end if;
end;
$$;


ALTER FUNCTION public.sp_paises(cid_pais integer, cpais_descrip character varying, cpais_gentilicio character varying, cpais_codigo character varying, usuario character varying, operacion integer) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 45025)
-- Name: sp_personas(integer, character varying, character varying, character varying, character varying, character varying, character varying, date, character varying, boolean, integer, integer, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_personas(cid_per integer, cper_ruc character varying, cper_ci character varying, cper_nombre character varying, cper_apellido character varying, cper_direccion character varying, cper_correo character varying, cper_fenaci date, cper_celular character varying, cpersona_fisica boolean, cid_ciu integer, cid_ec integer, cid_gen integer, usuario character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then --INSERCION
		if(cpersona_fisica)then
			perform * from personas where per_ci = cper_ci and id_ciu IN (select id_ciu from ciudades where id_pais = (select id_pais from ciudades where id_ciu = cid_ciu));
			if found then
				raise exception 'ESTA PERSONA YA HA SIDO REGISTRADA';
			end if;
		end if;
		insert into personas (id_per, per_ruc, per_ci, per_nombre, per_apellido, per_direccion, per_correo, 
			per_fenaci, per_celular, persona_fisica, id_ciu, id_ec, id_gen, estado, auditoria)
		values ((select coalesce(max(id_per),0) + 1 from personas), 
			cper_ruc, cper_ci, UPPER(TRIM(cper_nombre)), UPPER(TRIM(cper_apellido)), cper_direccion, cper_correo, 
			cper_fenaci, cper_celular, cpersona_fisica, cid_ciu, cid_ec, cid_gen, 'ACTIVO', 'INSERCION/'||usuario||'/'||now());
		raise notice 'DATOS GUARDADOS CON EXITO';
	end if;
	if operacion = 2 then --MODIFICACION
		if ((select persona_fisica from personas where id_per = cid_per) is true) then
			perform * from personas where persona_fisica is true and per_ci = cper_ci and id_ciu IN (select id_ciu from ciudades where id_pais = (select id_pais from ciudades where id_ciu = cid_ciu)) and id_per != cid_per;
			if found then
				raise exception 'ESTA PERSONA YA HA SIDO REGISTRADA';
			end if;
		end if;
		
		update personas set per_ruc = cper_ruc, per_ci = cper_ci, per_nombre = UPPER(TRIM(cper_nombre)), per_apellido = UPPER(TRIM(cper_apellido)),
			per_direccion = cper_direccion, per_correo = cper_correo, per_fenaci = cper_fenaci, per_celular = cper_celular,
			id_ciu = cid_ciu, id_ec = cid_ec, id_gen = cid_gen, auditoria = coalesce(auditoria, '')||chr(13)||'MODIFICACION/'||usuario||'/'||now()
		where id_per = cid_per;
		raise notice 'DATOS ACTUALIZADOS CON EXITO';
	end if;
	if operacion = 3 then --ACTIVACION
		update personas set estado = 'ACTIVO', auditoria = coalesce(auditoria, '')||chr(13)||'ACTIVACION/'||usuario||'/'||now() where id_per = cid_per;
		raise notice 'DATOS ACTIVADOS CON EXITO';
	end if;
	if operacion = 4 then --INACTIVACION
		update personas set estado = 'INACTIVO', auditoria = coalesce(auditoria, '')||chr(13)||'INACTIVACION/'||usuario||'/'||now() where id_per = cid_per;
		raise notice 'DATOS INACTIVADOS';
	end if;
end;
$$;


ALTER FUNCTION public.sp_personas(cid_per integer, cper_ruc character varying, cper_ci character varying, cper_nombre character varying, cper_apellido character varying, cper_direccion character varying, cper_correo character varying, cper_fenaci date, cper_celular character varying, cpersona_fisica boolean, cid_ciu integer, cid_ec integer, cid_gen integer, usuario character varying, operacion integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 181 (class 1259 OID 44489)
-- Name: acciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE acciones (
    id_ac integer NOT NULL,
    ac_descrip character varying,
    estado estados,
    auditoria text
);


ALTER TABLE acciones OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 45192)
-- Name: articulos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE articulos (
    id_art integer NOT NULL,
    art_descrip character varying,
    precio_compra integer,
    precio_venta integer,
    id_mar integer,
    id_ta integer,
    estado estados,
    auditoria text
);


ALTER TABLE articulos OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 44495)
-- Name: cargos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cargos (
    id_car integer NOT NULL,
    car_descrip character varying,
    estado estados,
    auditoria text
);


ALTER TABLE cargos OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 44501)
-- Name: ciudades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ciudades (
    id_ciu integer NOT NULL,
    ciu_descrip character varying,
    estado estados,
    auditoria text,
    id_pais integer
);


ALTER TABLE ciudades OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 45210)
-- Name: compras_pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE compras_pedidos (
    id_cp integer NOT NULL,
    cp_fecha date,
    id_suc integer,
    estado estados,
    auditoria text
);


ALTER TABLE compras_pedidos OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 45223)
-- Name: compras_pedidos_detalles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE compras_pedidos_detalles (
    id_cp integer NOT NULL,
    id_art integer NOT NULL,
    cantidad integer,
    precio integer
);


ALTER TABLE compras_pedidos_detalles OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 45265)
-- Name: compras_presupuestos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE compras_presupuestos (
    id_cpre integer NOT NULL,
    cpre_fecha date,
    cpre_validez date,
    cpre_numero integer,
    cpre_observacion text,
    id_suc integer,
    id_pro integer,
    estado estados,
    auditoria text
);


ALTER TABLE compras_presupuestos OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 45283)
-- Name: compras_presupuestos_detalles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE compras_presupuestos_detalles (
    id_cpre integer NOT NULL,
    id_art integer NOT NULL,
    cantidad integer,
    precio integer
);


ALTER TABLE compras_presupuestos_detalles OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 45313)
-- Name: compras_presupuestos_pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE compras_presupuestos_pedidos (
    id_cpre integer NOT NULL,
    id_cp integer NOT NULL,
    id_art integer NOT NULL,
    cantidad integer,
    precio integer
);


ALTER TABLE compras_presupuestos_pedidos OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 44507)
-- Name: estados_civiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE estados_civiles (
    id_ec integer NOT NULL,
    ec_descrip character varying,
    estado estados,
    auditoria text
);


ALTER TABLE estados_civiles OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 44513)
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE funcionarios (
    id_fun integer NOT NULL,
    fecha_ingreso date,
    fecha_egreso date,
    monto_salario integer,
    estado estados,
    auditoria text,
    id_per integer,
    id_car integer
);


ALTER TABLE funcionarios OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 44519)
-- Name: generos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE generos (
    id_gen integer NOT NULL,
    gen_descrip character varying,
    estado estados,
    auditoria text
);


ALTER TABLE generos OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 44525)
-- Name: grupos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE grupos (
    id_gru integer NOT NULL,
    gru_descrip character varying,
    estado estados,
    auditoria text
);


ALTER TABLE grupos OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 45176)
-- Name: marcas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE marcas (
    id_mar integer NOT NULL,
    mar_descrip character varying,
    estado estados,
    auditoria text
);


ALTER TABLE marcas OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 44531)
-- Name: modulos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE modulos (
    id_mod integer NOT NULL,
    mod_descrip character varying,
    mod_icono character varying,
    estado estados,
    auditoria text,
    mod_orden integer
);


ALTER TABLE modulos OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 44537)
-- Name: paginas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE paginas (
    id_pag integer NOT NULL,
    pag_descrip character varying,
    pag_ubicacion character varying,
    pag_icono character varying,
    estado estados,
    auditoria text,
    id_mod integer
);


ALTER TABLE paginas OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 44543)
-- Name: paises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE paises (
    id_pais integer NOT NULL,
    pais_descrip character varying,
    pais_gentilicio character varying,
    pais_codigo character varying,
    estado estados,
    auditoria text
);


ALTER TABLE paises OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 44549)
-- Name: permisos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE permisos (
    id_gru integer NOT NULL,
    id_pag integer NOT NULL,
    id_ac integer NOT NULL,
    estado estados,
    auditoria text
);


ALTER TABLE permisos OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 44555)
-- Name: personas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE personas (
    id_per integer NOT NULL,
    per_ruc character varying,
    per_ci character varying,
    per_nombre character varying,
    per_apellido character varying,
    per_direccion character varying,
    per_correo character varying,
    per_fenaci date,
    per_celular character varying,
    persona_fisica boolean,
    estado estados,
    auditoria text,
    id_ciu integer,
    id_ec integer,
    id_gen integer
);


ALTER TABLE personas OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 45252)
-- Name: proveedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE proveedores (
    id_pro integer NOT NULL,
    id_per integer,
    estado estados,
    auditoria text
);


ALTER TABLE proveedores OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 44561)
-- Name: sucursales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE sucursales (
    id_suc integer NOT NULL,
    suc_ruc character varying,
    suc_nombre character varying,
    suc_direccion character varying,
    suc_correo character varying,
    suc_celular character varying,
    suc_ubicacion character varying,
    suc_imagen character varying,
    estado estados,
    auditoria text
);


ALTER TABLE sucursales OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 45184)
-- Name: tipos_articulos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tipos_articulos (
    id_ta integer NOT NULL,
    ta_descrip character varying,
    estado estados,
    auditoria text
);


ALTER TABLE tipos_articulos OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 44567)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE usuarios (
    id_usu integer NOT NULL,
    usu_login character varying,
    usu_contrasena character varying,
    usu_imagen character varying,
    estado estados,
    auditoria text,
    id_fun integer,
    id_gru integer,
    id_suc integer
);


ALTER TABLE usuarios OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 44573)
-- Name: usuarios_sucursales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE usuarios_sucursales (
    id_usu integer NOT NULL,
    id_suc integer NOT NULL,
    estado estados,
    auditoria text
);


ALTER TABLE usuarios_sucursales OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 45238)
-- Name: v_articulos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_articulos AS
 SELECT a.id_art,
    a.art_descrip,
    a.precio_compra,
    a.precio_venta,
    a.id_mar,
    a.id_ta,
    a.estado,
    a.auditoria,
    m.mar_descrip,
    ta.ta_descrip
   FROM ((articulos a
     JOIN marcas m ON ((m.id_mar = a.id_mar)))
     JOIN tipos_articulos ta ON ((ta.id_ta = a.id_ta)));


ALTER TABLE v_articulos OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 45031)
-- Name: v_ciudades; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_ciudades AS
 SELECT c.id_ciu,
    c.ciu_descrip,
    c.estado,
    c.auditoria,
    c.id_pais,
    p.pais_descrip,
    p.pais_gentilicio,
    p.pais_codigo
   FROM (ciudades c
     JOIN paises p ON ((p.id_pais = c.id_pais)));


ALTER TABLE v_ciudades OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 45242)
-- Name: v_compras_pedidos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_compras_pedidos AS
 SELECT c.id_cp,
    c.cp_fecha,
    c.id_suc,
    c.estado,
    c.auditoria,
    s.suc_nombre,
    s.suc_celular,
    s.suc_correo,
    s.suc_direccion,
    s.suc_imagen,
    s.suc_ubicacion,
    to_char((c.cp_fecha)::timestamp with time zone, 'DD/MM/YYYY'::text) AS cp_fecha_formato
   FROM (compras_pedidos c
     JOIN sucursales s ON ((s.id_suc = c.id_suc)));


ALTER TABLE v_compras_pedidos OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 45246)
-- Name: v_compras_pedidos_detalles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_compras_pedidos_detalles AS
 SELECT c.id_cp,
    c.id_art,
    c.cantidad,
    c.precio,
    a.art_descrip,
    a.id_mar,
    a.id_ta,
    m.mar_descrip,
    ta.ta_descrip
   FROM (((compras_pedidos_detalles c
     JOIN articulos a ON ((a.id_art = c.id_art)))
     JOIN marcas m ON ((m.id_mar = a.id_mar)))
     JOIN tipos_articulos ta ON ((ta.id_ta = a.id_ta)));


ALTER TABLE v_compras_pedidos_detalles OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 45328)
-- Name: v_proveedores; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_proveedores AS
 SELECT p.id_pro,
    p.id_per,
    p.estado,
    p.auditoria,
    pe.per_ci,
    pe.per_ruc,
    pe.per_nombre,
    pe.per_apellido,
    pe.per_direccion,
    pe.per_celular,
    pe.per_correo
   FROM (proveedores p
     JOIN personas pe ON ((pe.id_per = p.id_per)));


ALTER TABLE v_proveedores OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 45332)
-- Name: v_compras_presupuestos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE OR REPLACE  VIEW v_compras_presupuestos AS
 SELECT c.id_cpre,
    c.cpre_fecha,
    c.cpre_validez,
    c.cpre_numero,
    c.cpre_observacion,
    c.id_suc,
    c.id_pro,
    c.estado,
    c.auditoria,
    p.per_ruc,
    p.per_nombre,
    p.per_apellido,
    s.suc_nombre,
    ( SELECT COALESCE(sum((compras_presupuestos_detalles.cantidad * compras_presupuestos_detalles.precio)), (0)::bigint) AS "coalesce"
           FROM compras_presupuestos_detalles
          WHERE (compras_presupuestos_detalles.id_cpre = c.id_cpre)) AS monto_detalles,
    ( SELECT COALESCE(sum((compras_presupuestos_pedidos.cantidad * compras_presupuestos_pedidos.precio)), (0)::bigint) AS "coalesce"
           FROM compras_presupuestos_pedidos
          WHERE (compras_presupuestos_pedidos.id_cpre = c.id_cpre)) AS monto_pedidos,
    (( SELECT COALESCE(sum((compras_presupuestos_detalles.cantidad * compras_presupuestos_detalles.precio)), (0)::bigint) AS "coalesce"
           FROM compras_presupuestos_detalles
          WHERE (compras_presupuestos_detalles.id_cpre = c.id_cpre)) + ( SELECT COALESCE(sum((compras_presupuestos_pedidos.cantidad * compras_presupuestos_pedidos.precio)), (0)::bigint) AS "coalesce"
           FROM compras_presupuestos_pedidos
          WHERE (compras_presupuestos_pedidos.id_cpre = c.id_cpre))) AS monto_total,
    to_char((c.cpre_fecha)::timestamp with time zone, 'DD/MM/YYYY'::text) AS cpre_fecha_formato,
    to_char((c.cpre_validez)::timestamp with time zone, 'DD/MM/YYYY'::text) AS cpre_validez_formato
   FROM ((compras_presupuestos c
     JOIN sucursales s ON ((s.id_suc = c.id_suc)))
     JOIN v_proveedores p ON ((p.id_pro = c.id_pro)));


ALTER TABLE v_compras_presupuestos OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 45337)
-- Name: v_compras_presupuestos_detalles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_compras_presupuestos_detalles AS
 SELECT c.id_cpre,
    c.id_art,
    c.cantidad,
    c.precio,
    a.art_descrip,
    a.id_mar,
    a.id_ta,
    m.mar_descrip,
    ta.ta_descrip
   FROM (((compras_presupuestos_detalles c
     JOIN articulos a ON ((a.id_art = c.id_art)))
     JOIN tipos_articulos ta ON ((ta.id_ta = a.id_ta)))
     JOIN marcas m ON ((m.id_mar = a.id_mar)));


ALTER TABLE v_compras_presupuestos_detalles OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 45342)
-- Name: v_compras_presupuestos_pedidos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_compras_presupuestos_pedidos AS
 SELECT c.id_cpre,
    c.id_cp,
    c.id_art,
    c.cantidad,
    c.precio,
    a.art_descrip,
    a.id_mar,
    a.id_ta,
    m.mar_descrip,
    ta.ta_descrip
   FROM (((compras_presupuestos_pedidos c
     JOIN articulos a ON ((a.id_art = c.id_art)))
     JOIN tipos_articulos ta ON ((ta.id_ta = a.id_ta)))
     JOIN marcas m ON ((m.id_mar = a.id_mar)));


ALTER TABLE v_compras_presupuestos_pedidos OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 45347)
-- Name: v_compras_presupuestos_consolidacion; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_compras_presupuestos_consolidacion AS
 SELECT c.id_cpre,
    c.id_art,
    sum(c.cantidad) AS cantidad,
    c.precio,
    c.art_descrip,
    c.id_mar,
    c.id_ta,
    c.mar_descrip,
    c.ta_descrip
   FROM ( SELECT d.id_cpre,
            d.id_art,
            d.cantidad,
            d.precio,
            d.art_descrip,
            d.id_mar,
            d.id_ta,
            d.mar_descrip,
            d.ta_descrip
           FROM v_compras_presupuestos_detalles d
        UNION ALL
         SELECT p.id_cpre,
            p.id_art,
            p.cantidad,
            p.precio,
            p.art_descrip,
            p.id_mar,
            p.id_ta,
            p.mar_descrip,
            p.ta_descrip
           FROM v_compras_presupuestos_pedidos p) c
  GROUP BY c.id_cpre, c.id_art, c.precio, c.art_descrip, c.id_mar, c.id_ta, c.mar_descrip, c.ta_descrip;


ALTER TABLE v_compras_presupuestos_consolidacion OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 44579)
-- Name: v_paginas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_paginas AS
 SELECT p.id_pag,
    p.pag_descrip,
    p.pag_ubicacion,
    p.pag_icono,
    p.estado,
    p.auditoria,
    p.id_mod,
    m.mod_descrip,
    m.mod_icono
   FROM (paginas p
     JOIN modulos m ON ((m.id_mod = p.id_mod)));


ALTER TABLE v_paginas OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 44694)
-- Name: v_permisos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_permisos AS
 SELECT p.id_gru,
    p.id_pag,
    p.id_ac,
    p.estado,
    p.auditoria,
    g.gru_descrip,
    a.ac_descrip,
    pa.pag_descrip,
    pa.pag_ubicacion,
    pa.pag_icono,
    pa.id_mod,
    m.mod_descrip,
    m.mod_icono,
    m.mod_orden
   FROM ((((permisos p
     JOIN grupos g ON ((g.id_gru = p.id_gru)))
     JOIN acciones a ON ((a.id_ac = p.id_ac)))
     JOIN paginas pa ON ((pa.id_pag = p.id_pag)))
     JOIN modulos m ON ((m.id_mod = pa.id_mod)));


ALTER TABLE v_permisos OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 45026)
-- Name: v_personas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_personas AS
 SELECT p.id_per,
    p.per_ruc,
    p.per_ci,
    p.per_nombre,
    p.per_apellido,
    p.per_direccion,
    p.per_correo,
    p.per_fenaci,
    p.per_celular,
    p.persona_fisica,
    p.estado,
    p.auditoria,
    p.id_ciu,
    p.id_ec,
    p.id_gen,
    c.ciu_descrip,
    c.id_pais,
    pa.pais_descrip,
    pa.pais_gentilicio,
    pa.pais_codigo,
    e.ec_descrip,
    g.gen_descrip,
        CASE p.persona_fisica
            WHEN true THEN 'FISICA'::text
            ELSE 'JURIDICA'::text
        END AS tipo_persona
   FROM ((((personas p
     JOIN ciudades c ON ((c.id_ciu = p.id_ciu)))
     JOIN paises pa ON ((pa.id_pais = c.id_pais)))
     JOIN estados_civiles e ON ((e.id_ec = p.id_ec)))
     JOIN generos g ON ((g.id_gen = p.id_gen)));


ALTER TABLE v_personas OWNER TO postgres;
select * from v_personas;

--
-- TOC entry 197 (class 1259 OID 44583)
-- Name: v_usuarios; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_usuarios AS
 SELECT u.id_usu,
    u.usu_login,
    u.usu_contrasena,
    u.usu_imagen,
    u.estado,
    u.auditoria,
    u.id_fun,
    u.id_gru,
    u.id_suc,
    f.id_car,
    c.car_descrip,
    gr.gru_descrip,
    s.suc_ruc,
    s.suc_nombre,
    s.suc_direccion,
    s.suc_celular,
    s.suc_correo,
    s.suc_ubicacion,
    s.suc_imagen,
    p.per_ruc,
    p.per_ci,
    p.per_nombre,
    p.per_apellido,
    p.per_direccion,
    p.per_correo,
    p.per_fenaci,
    p.per_celular,
    p.id_ciu,
    p.id_ec,
    p.id_gen,
    ciu.id_pais,
    ciu.ciu_descrip,
    pa.pais_descrip,
    pa.pais_gentilicio,
    pa.pais_codigo,
    ec.ec_descrip,
    g.gen_descrip
   FROM (((((((((usuarios u
     JOIN funcionarios f ON ((f.id_fun = u.id_fun)))
     JOIN cargos c ON ((c.id_car = f.id_car)))
     JOIN personas p ON ((p.id_per = f.id_per)))
     JOIN ciudades ciu ON ((ciu.id_ciu = p.id_ciu)))
     JOIN paises pa ON ((pa.id_pais = ciu.id_pais)))
     JOIN estados_civiles ec ON ((ec.id_ec = p.id_ec)))
     JOIN generos g ON ((g.id_gen = p.id_gen)))
     JOIN sucursales s ON ((s.id_suc = u.id_suc)))
     JOIN grupos gr ON ((gr.id_gru = u.id_gru)));


ALTER TABLE v_usuarios OWNER TO postgres;

--
-- TOC entry 2354 (class 0 OID 44489)
-- Dependencies: 181
-- Data for Name: acciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO acciones (id_ac, ac_descrip, estado, auditoria) VALUES (1, 'VISUALIZAR', 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:15:11.864417-04');


--
-- TOC entry 2371 (class 0 OID 45192)
-- Dependencies: 203
-- Data for Name: articulos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO articulos (id_art, art_descrip, precio_compra, precio_venta, id_mar, id_ta, estado, auditoria) VALUES (1, 'CHAMPION CALCE 43', 150000, 200000, 2, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO articulos (id_art, art_descrip, precio_compra, precio_venta, id_mar, id_ta, estado, auditoria) VALUES (2, 'PELOTA DE FUTBOL', 200000, 250000, 1, 6, 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO articulos (id_art, art_descrip, precio_compra, precio_venta, id_mar, id_ta, estado, auditoria) VALUES (3, 'PELOTA DE BASQUET', 200000, 250000, 1, 6, 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO articulos (id_art, art_descrip, precio_compra, precio_venta, id_mar, id_ta, estado, auditoria) VALUES (4, 'PERFUME', 200000, 250000, 4, 2, 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO articulos (id_art, art_descrip, precio_compra, precio_venta, id_mar, id_ta, estado, auditoria) VALUES (5, 'PELOTA DE BASQUET', 300000, 400000, 6, 6, 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO articulos (id_art, art_descrip, precio_compra, precio_venta, id_mar, id_ta, estado, auditoria) VALUES (6, 'ZAPATILLAS CALCE 35', 10000, 20000, 2, 4, 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');


--
-- TOC entry 2355 (class 0 OID 44495)
-- Dependencies: 182
-- Data for Name: cargos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO cargos (id_car, car_descrip, estado, auditoria) VALUES (1, 'DESARROLLADOR', 'ACTIVO', NULL);
INSERT INTO cargos (id_car, car_descrip, estado, auditoria) VALUES (2, 'RECEPCIONISTA', 'ACTIVO', NULL);
INSERT INTO cargos (id_car, car_descrip, estado, auditoria) VALUES (10, 'DESARROLLADOR', NULL, NULL);
INSERT INTO cargos (id_car, car_descrip, estado, auditoria) VALUES (20, 'RECEPCIONISTA', NULL, NULL);
INSERT INTO cargos (id_car, car_descrip, estado, auditoria) VALUES (30, 'CAJERO', NULL, NULL);


--
-- TOC entry 2356 (class 0 OID 44501)
-- Dependencies: 183
-- Data for Name: ciudades; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO ciudades (id_ciu, ciu_descrip, estado, auditoria, id_pais) VALUES (1, 'ÑEMBY', 'ACTIVO', NULL, 1);
INSERT INTO ciudades (id_ciu, ciu_descrip, estado, auditoria, id_pais) VALUES (2, 'FERNANDO DE LA MORA', 'ACTIVO', NULL, 1);
INSERT INTO ciudades (id_ciu, ciu_descrip, estado, auditoria, id_pais) VALUES (3, 'YPANE', 'ACTIVO', NULL, 1);
INSERT INTO ciudades (id_ciu, ciu_descrip, estado, auditoria, id_pais) VALUES (4, 'BUENOS AIRES', 'ACTIVO', NULL, 2);
INSERT INTO ciudades (id_ciu, ciu_descrip, estado, auditoria, id_pais) VALUES (0, 'NO DEFINIDO', 'ACTIVO', 'INSERCION/ctorres/2021-08-17 18:34:43.582117-04', 0);


--
-- TOC entry 2372 (class 0 OID 45210)
-- Dependencies: 204
-- Data for Name: compras_pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO compras_pedidos (id_cp, cp_fecha, id_suc, estado, auditoria) VALUES (1, '2021-08-26', 1, 'CONFIRMADO', 'INSERCION/ctorres/2021-08-25 20:12:26.65848-04
CONFIRMACION/ctorres/2021-08-25 20:12:45.00537-04');
INSERT INTO compras_pedidos (id_cp, cp_fecha, id_suc, estado, auditoria) VALUES (2, '2021-08-27', 1, 'PENDIENTE', 'INSERCION/ctorres/2021-08-26 20:09:52.491583-04');


--
-- TOC entry 2373 (class 0 OID 45223)
-- Dependencies: 205
-- Data for Name: compras_pedidos_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO compras_pedidos_detalles (id_cp, id_art, cantidad, precio) VALUES (1, 3, 10, 200000);
INSERT INTO compras_pedidos_detalles (id_cp, id_art, cantidad, precio) VALUES (1, 5, 15, 300000);
INSERT INTO compras_pedidos_detalles (id_cp, id_art, cantidad, precio) VALUES (1, 1, 5, 150000);


--
-- TOC entry 2375 (class 0 OID 45265)
-- Dependencies: 210
-- Data for Name: compras_presupuestos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO compras_presupuestos (id_cpre, cpre_fecha, cpre_validez, cpre_numero, cpre_observacion, id_suc, id_pro, estado, auditoria) VALUES (3, '2021-08-27', '2021-08-27', 123, 'asdfasdfasdf', 1, 3, 'PENDIENTE', 'INSERCION/ctorres/2021-08-26 20:19:10.961063-04');
INSERT INTO compras_presupuestos (id_cpre, cpre_fecha, cpre_validez, cpre_numero, cpre_observacion, id_suc, id_pro, estado, auditoria) VALUES (4, '2021-08-27', '2021-08-27', 123, 'asdfasdf', 1, 3, 'PENDIENTE', 'INSERCION/ctorres/2021-08-26 20:19:42.627133-04');
INSERT INTO compras_presupuestos (id_cpre, cpre_fecha, cpre_validez, cpre_numero, cpre_observacion, id_suc, id_pro, estado, auditoria) VALUES (1, '2021-08-25', '2021-09-01', 123, '', 1, 1, 'ANULADO', 'INSERCION/ctorres/2021-08-25 20:09:36.831103-04
ANULACION/ctorres/2021-08-26 20:38:52.81803-04');
INSERT INTO compras_presupuestos (id_cpre, cpre_fecha, cpre_validez, cpre_numero, cpre_observacion, id_suc, id_pro, estado, auditoria) VALUES (2, '2021-08-27', '2021-08-27', 123, 'asdfasdfasdf', 1, 2, 'CONFIRMADO', 'INSERCION/ctorres/2021-08-26 20:17:54.856905-04
CONFIRMACION/ctorres/2021-08-26 20:38:56.823722-04');


--
-- TOC entry 2376 (class 0 OID 45283)
-- Dependencies: 211
-- Data for Name: compras_presupuestos_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO compras_presupuestos_detalles (id_cpre, id_art, cantidad, precio) VALUES (1, 1, 10, 1000);
INSERT INTO compras_presupuestos_detalles (id_cpre, id_art, cantidad, precio) VALUES (1, 3, 10, 1000);
INSERT INTO compras_presupuestos_detalles (id_cpre, id_art, cantidad, precio) VALUES (3, 1, 1, 1000);


--
-- TOC entry 2377 (class 0 OID 45313)
-- Dependencies: 212
-- Data for Name: compras_presupuestos_pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO compras_presupuestos_pedidos (id_cpre, id_cp, id_art, cantidad, precio) VALUES (1, 1, 3, 10, 200000);
INSERT INTO compras_presupuestos_pedidos (id_cpre, id_cp, id_art, cantidad, precio) VALUES (1, 1, 5, 15, 300000);
INSERT INTO compras_presupuestos_pedidos (id_cpre, id_cp, id_art, cantidad, precio) VALUES (1, 1, 1, 5, 150000);
INSERT INTO compras_presupuestos_pedidos (id_cpre, id_cp, id_art, cantidad, precio) VALUES (3, 1, 3, 10, 200000);
INSERT INTO compras_presupuestos_pedidos (id_cpre, id_cp, id_art, cantidad, precio) VALUES (3, 1, 5, 15, 300000);


--
-- TOC entry 2357 (class 0 OID 44507)
-- Dependencies: 184
-- Data for Name: estados_civiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO estados_civiles (id_ec, ec_descrip, estado, auditoria) VALUES (1, 'SOLTERO', 'ACTIVO', NULL);
INSERT INTO estados_civiles (id_ec, ec_descrip, estado, auditoria) VALUES (2, 'CASADO', 'ACTIVO', NULL);
INSERT INTO estados_civiles (id_ec, ec_descrip, estado, auditoria) VALUES (3, 'DIVORCIADO', 'ACTIVO', NULL);
INSERT INTO estados_civiles (id_ec, ec_descrip, estado, auditoria) VALUES (4, 'VIUDO', 'ACTIVO', NULL);
INSERT INTO estados_civiles (id_ec, ec_descrip, estado, auditoria) VALUES (0, 'NO DEFINIDO', 'ACTIVO', 'INSERCION/ctorres/2021-08-17 18:35:27.98724-04');


--
-- TOC entry 2358 (class 0 OID 44513)
-- Dependencies: 185
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO funcionarios (id_fun, fecha_ingreso, fecha_egreso, monto_salario, estado, auditoria, id_per, id_car) VALUES (1, '2021-01-01', NULL, 3000000, 'ACTIVO', NULL, 1, 1);
INSERT INTO funcionarios (id_fun, fecha_ingreso, fecha_egreso, monto_salario, estado, auditoria, id_per, id_car) VALUES (2, '2021-01-01', NULL, 3000000, 'ACTIVO', NULL, 2, 2);


--
-- TOC entry 2359 (class 0 OID 44519)
-- Dependencies: 186
-- Data for Name: generos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO generos (id_gen, gen_descrip, estado, auditoria) VALUES (1, 'MASCULINO', 'ACTIVO', NULL);
INSERT INTO generos (id_gen, gen_descrip, estado, auditoria) VALUES (2, 'FEMENINO', 'ACTIVO', NULL);
INSERT INTO generos (id_gen, gen_descrip, estado, auditoria) VALUES (0, 'NO DEFINIDO', 'ACTIVO', 'INSERCION/ctorres/2021-08-17 18:35:55.495687-04');


--
-- TOC entry 2360 (class 0 OID 44525)
-- Dependencies: 187
-- Data for Name: grupos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grupos (id_gru, gru_descrip, estado, auditoria) VALUES (1, 'DESARROLLADORES', 'ACTIVO', NULL);
INSERT INTO grupos (id_gru, gru_descrip, estado, auditoria) VALUES (2, 'RECEPCIONISTAS', 'ACTIVO', NULL);


--
-- TOC entry 2369 (class 0 OID 45176)
-- Dependencies: 201
-- Data for Name: marcas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO marcas (id_mar, mar_descrip, estado, auditoria) VALUES (1, 'PUMA', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO marcas (id_mar, mar_descrip, estado, auditoria) VALUES (2, 'NIKE', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO marcas (id_mar, mar_descrip, estado, auditoria) VALUES (3, 'TOYOTA', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO marcas (id_mar, mar_descrip, estado, auditoria) VALUES (4, 'ADIDAS', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO marcas (id_mar, mar_descrip, estado, auditoria) VALUES (5, 'LACOSTE', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO marcas (id_mar, mar_descrip, estado, auditoria) VALUES (6, 'DIADORA', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');


--
-- TOC entry 2361 (class 0 OID 44531)
-- Dependencies: 188
-- Data for Name: modulos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO modulos (id_mod, mod_descrip, mod_icono, estado, auditoria, mod_orden) VALUES (3, 'Archivo', 'fa fa-file', 'ACTIVO', NULL, 1);
INSERT INTO modulos (id_mod, mod_descrip, mod_icono, estado, auditoria, mod_orden) VALUES (1, 'Compra', 'fa fa-shopping-cart', 'ACTIVO', NULL, 2);
INSERT INTO modulos (id_mod, mod_descrip, mod_icono, estado, auditoria, mod_orden) VALUES (2, 'Cobros', 'fas fa-file-invoice-dollar', 'ACTIVO', NULL, 3);
INSERT INTO modulos (id_mod, mod_descrip, mod_icono, estado, auditoria, mod_orden) VALUES (4, 'Config. Sistema', 'fa fa-cog', 'ACTIVO', NULL, 4);


--
-- TOC entry 2362 (class 0 OID 44537)
-- Dependencies: 189
-- Data for Name: paginas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO paginas (id_pag, pag_descrip, pag_ubicacion, pag_icono, estado, auditoria, id_mod) VALUES (1, 'Pedido de Compra', '/cuarto/compra/pedido', 'fas fa-people-carry', 'ACTIVO', 'INSERCION/ctorres/2021-08-03 13:59:18.194366-04', 1);
INSERT INTO paginas (id_pag, pag_descrip, pag_ubicacion, pag_icono, estado, auditoria, id_mod) VALUES (3, 'Ajustes de Stock', '/cuarto/compra/ajuste', 'fa fa-cog', 'ACTIVO', 'INSERCION/ctorres/2021-08-03 13:59:18.194366-04', 1);
INSERT INTO paginas (id_pag, pag_descrip, pag_ubicacion, pag_icono, estado, auditoria, id_mod) VALUES (4, 'Cobros', '/cuarto/cobro/cobro', 'fas fa-cash-register', 'ACTIVO', 'INSERCION/ctorres/2021-08-03 13:59:18.194366-04', 2);
INSERT INTO paginas (id_pag, pag_descrip, pag_ubicacion, pag_icono, estado, auditoria, id_mod) VALUES (5, 'Cuenta de Clientes', '/cuarto/cobro/cuenta', 'fas fa-handshake', 'ACTIVO', 'INSERCION/ctorres/2021-08-03 13:59:18.194366-04', 2);
INSERT INTO paginas (id_pag, pag_descrip, pag_ubicacion, pag_icono, estado, auditoria, id_mod) VALUES (6, 'Paises', '/cuarto/archivo/pais', 'fas fa-flag', 'ACTIVO', 'INSERCION/ctorres/2021-08-03 13:59:18.194366-04', 3);
INSERT INTO paginas (id_pag, pag_descrip, pag_ubicacion, pag_icono, estado, auditoria, id_mod) VALUES (7, 'Ciudades', '/cuarto/archivo/ciudad', 'fas fa-globe-americas', 'ACTIVO', 'INSERCION/ctorres/2021-08-03 13:59:18.194366-04', 3);
INSERT INTO paginas (id_pag, pag_descrip, pag_ubicacion, pag_icono, estado, auditoria, id_mod) VALUES (8, 'Personas', '/cuarto/archivo/persona', 'fas fa-users', 'ACTIVO', 'INSERCION/ctorres/2021-08-03 13:59:18.194366-04', 3);
INSERT INTO paginas (id_pag, pag_descrip, pag_ubicacion, pag_icono, estado, auditoria, id_mod) VALUES (9, 'Cambio de Sucursal', '/cuarto/configuracion/sucursal', 'fa fa-university', 'ACTIVO', 'INSERCION/ctorres/2021-08-03 13:59:18.194366-04', 4);
INSERT INTO paginas (id_pag, pag_descrip, pag_ubicacion, pag_icono, estado, auditoria, id_mod) VALUES (10, 'Mi Perfil', '/cuarto/configuracion/perfil', 'fas fa-user', 'ACTIVO', 'INSERCION/ctorres/2021-08-03 13:59:18.194366-04', 4);
INSERT INTO paginas (id_pag, pag_descrip, pag_ubicacion, pag_icono, estado, auditoria, id_mod) VALUES (2, 'Presupuesto del Proveedor', '/cuarto/compra/presupuesto', 'fa fa-shopping-cart', 'ACTIVO', 'INSERCION/ctorres/2021-08-03 13:59:18.194366-04', 1);


--
-- TOC entry 2363 (class 0 OID 44543)
-- Dependencies: 190
-- Data for Name: paises; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO paises (id_pais, pais_descrip, pais_gentilicio, pais_codigo, estado, auditoria) VALUES (4, 'URUGUAY', 'URUGUAYA', '+598', 'ACTIVO', 'INSERCION/ctorres/2021-07-27 19:24:14.950291-04');
INSERT INTO paises (id_pais, pais_descrip, pais_gentilicio, pais_codigo, estado, auditoria) VALUES (2, 'ARGENTINA', 'ARGENTINA', '+54', 'ACTIVO', 'INSERCION/ctorres/2021-07-27 19:24:44.846394-04
INACTIVACION/ctorres/2021-08-12 20:05:09.235931-04
ACTIVACION/ctorres/2021-08-12 20:05:12.316606-04
MODIFICACION/ctorres/2021-08-16 17:48:01.701444-04
MODIFICACION/ctorres/2021-08-16 17:48:28.467122-04');
INSERT INTO paises (id_pais, pais_descrip, pais_gentilicio, pais_codigo, estado, auditoria) VALUES (3, 'BRASIL', 'BRASILERA', '+55', 'ACTIVO', 'INSERCION/ctorres/2021-07-27 19:24:44.846394-04
ACTIVACION/ctorres/2021-08-16 17:48:33.04626-04');
INSERT INTO paises (id_pais, pais_descrip, pais_gentilicio, pais_codigo, estado, auditoria) VALUES (1, 'PARAGUAY', 'PARAGUAYO', '+595', 'ACTIVO', 'INSERCION/ctorres/2021-07-27 19:24:44.846394-04
INACTIVACION/ctorres/2021-08-12 20:05:03.74043-04
ACTIVACION/ctorres/2021-08-12 20:05:04.571026-04
INACTIVACION/ctorres/2021-08-12 20:05:05.248464-04
ACTIVACION/ctorres/2021-08-12 20:05:06.03299-04
INACTIVACION/ctorres/2021-08-12 20:05:06.770419-04
ACTIVACION/ctorres/2021-08-12 20:05:07.453039-04
INACTIVACION/ctorres/2021-08-12 20:05:10.915537-04
ACTIVACION/ctorres/2021-08-12 20:05:12.947551-04
INACTIVACION/ctorres/2021-08-16 17:47:15.268091-04
ACTIVACION/ctorres/2021-08-16 17:47:46.425364-04
INACTIVACION/ctorres/2021-08-16 17:47:47.492886-04
ACTIVACION/ctorres/2021-08-16 17:47:48.373058-04
INACTIVACION/ctorres/2021-08-16 17:52:20.409571-04
ACTIVACION/ctorres/2021-08-16 17:52:21.19396-04
INACTIVACION/ctorres/2021-08-16 18:32:46.472963-04
ACTIVACION/ctorres/2021-08-16 18:32:46.997405-04
INACTIVACION/ctorres/2021-08-16 18:32:47.697599-04
ACTIVACION/ctorres/2021-08-16 18:32:48.180093-04
INACTIVACION/ctorres/2021-08-16 18:54:03.169171-04
ACTIVACION/ctorres/2021-08-16 19:09:57.920041-04
ACTIVACION/ctorres/2021-08-16 19:09:58.913369-04
ACTIVACION/ctorres/2021-08-16 19:09:59.252004-04
ACTIVACION/ctorres/2021-08-16 19:10:00.250848-04
ACTIVACION/ctorres/2021-08-16 19:10:00.537915-04
ACTIVACION/ctorres/2021-08-16 19:10:01.187079-04
ACTIVACION/ctorres/2021-08-16 19:10:01.386324-04
ACTIVACION/ctorres/2021-08-16 19:10:01.525907-04
ACTIVACION/ctorres/2021-08-16 19:10:02.107918-04
ACTIVACION/ctorres/2021-08-16 19:10:02.30744-04
ACTIVACION/ctorres/2021-08-16 19:10:02.461549-04
INACTIVACION/ctorres/2021-08-16 19:10:15.19783-04
ACTIVACION/ctorres/2021-08-16 19:10:15.839966-04
INACTIVACION/ctorres/2021-08-16 19:10:31.091675-04
ACTIVACION/ctorres/2021-08-16 19:21:46.50694-04
INACTIVACION/ctorres/2021-08-16 19:34:38.724036-04
ACTIVACION/ctorres/2021-08-16 19:34:39.825865-04
INACTIVACION/ctorres/2021-08-16 19:34:40.709945-04
ACTIVACION/ctorres/2021-08-16 19:34:41.27741-04
INACTIVACION/ctorres/2021-08-16 19:43:00.136906-04
ACTIVACION/ctorres/2021-08-16 19:43:01.657123-04
INACTIVACION/ctorres/2021-08-16 19:43:02.393339-04
ACTIVACION/ctorres/2021-08-16 19:43:03.057285-04');
INSERT INTO paises (id_pais, pais_descrip, pais_gentilicio, pais_codigo, estado, auditoria) VALUES (0, 'NO DEFINIDO', 'NO DEFINIDO', 'NO DEFINIDO', 'ACTIVO', 'INSERCION/ctorres/2021-08-17 18:33:45.802476-04');


--
-- TOC entry 2364 (class 0 OID 44549)
-- Dependencies: 191
-- Data for Name: permisos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (1, 1, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (1, 2, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (1, 3, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (1, 4, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (1, 5, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (1, 6, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (1, 7, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (1, 8, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (1, 9, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (1, 10, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (2, 1, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (2, 2, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (2, 3, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:23:47.150466-04');
INSERT INTO permisos (id_gru, id_pag, id_ac, estado, auditoria) VALUES (2, 4, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-04 19:58:25.562017-04');


--
-- TOC entry 2365 (class 0 OID 44555)
-- Dependencies: 192
-- Data for Name: personas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO personas (id_per, per_ruc, per_ci, per_nombre, per_apellido, per_direccion, per_correo, per_fenaci, per_celular, persona_fisica, estado, auditoria, id_ciu, id_ec, id_gen) VALUES (4, '', '', '', '', '', '', '2021-08-20', '', true, 'ACTIVO', 'INSERCION/ctorres/2021-08-19 20:04:56.355945-04', 4, 1, 2);
INSERT INTO personas (id_per, per_ruc, per_ci, per_nombre, per_apellido, per_direccion, per_correo, per_fenaci, per_celular, persona_fisica, estado, auditoria, id_ciu, id_ec, id_gen) VALUES (2, '123456-7', '123456', 'JUAN', 'PEREZ', 'calle san roque', 'juanperez@gmail.com', '1996-11-02', '0985526589', true, 'ACTIVO', '
INACTIVACION/ctorres/2021-08-19 20:05:53.929554-04
ACTIVACION/ctorres/2021-08-19 20:05:54.615522-04', 1, 1, 1);
INSERT INTO personas (id_per, per_ruc, per_ci, per_nombre, per_apellido, per_direccion, per_correo, per_fenaci, per_celular, persona_fisica, estado, auditoria, id_ciu, id_ec, id_gen) VALUES (3, '123', '123', '123', '123', '123', '123', '2021-08-20', '123', true, 'ACTIVO', 'INSERCION/ctorres/2021-08-19 20:04:28.777517-04
INACTIVACION/ctorres/2021-08-19 20:05:55.288917-04
ACTIVACION/ctorres/2021-08-19 20:05:56.288905-04', 4, 1, 2);
INSERT INTO personas (id_per, per_ruc, per_ci, per_nombre, per_apellido, per_direccion, per_correo, per_fenaci, per_celular, persona_fisica, estado, auditoria, id_ciu, id_ec, id_gen) VALUES (6, '123456-7', '', 'ITAU S.A.', '', 'la calle', 'itau@itau.com', '2021-01-01', '021000000', false, 'ACTIVO', 'INSERCION/ctorres/2021-08-19 20:22:15.93146-04
MODIFICACION/ctorres/2021-08-23 19:13:54.13266-04', 0, 0, 0);
INSERT INTO personas (id_per, per_ruc, per_ci, per_nombre, per_apellido, per_direccion, per_correo, per_fenaci, per_celular, persona_fisica, estado, auditoria, id_ciu, id_ec, id_gen) VALUES (5, 'asasdf', '123456', 'ASDF', '', 'asdf', 'asdf', '2021-01-01', 'asdf', true, 'ACTIVO', 'INSERCION/ctorres/2021-08-19 20:09:03.184721-04
MODIFICACION/ctorres/2021-08-23 19:19:22.590744-04', 0, 0, 0);
INSERT INTO personas (id_per, per_ruc, per_ci, per_nombre, per_apellido, per_direccion, per_correo, per_fenaci, per_celular, persona_fisica, estado, auditoria, id_ciu, id_ec, id_gen) VALUES (1, '4580373-0', '4580373', 'CHRISTIAN DAVID', 'TORRES', 'calle san roque', 'christiantorres.cdt@gmail.com', '1996-11-02', '0985526589', true, 'ACTIVO', '
INACTIVACION/ctorres/2021-08-19 20:05:51.952043-04
ACTIVACION/ctorres/2021-08-19 20:05:52.765013-04
INACTIVACION/ctorres/2021-08-23 19:19:43.443806-04
ACTIVACION/ctorres/2021-08-23 19:19:45.575586-04', 1, 2, 1);


--
-- TOC entry 2374 (class 0 OID 45252)
-- Dependencies: 209
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO proveedores (id_pro, id_per, estado, auditoria) VALUES (1, 1, 'ACTIVO', 'INSERCION/ctorres/2021-08-25 20:08:10.988686-04');
INSERT INTO proveedores (id_pro, id_per, estado, auditoria) VALUES (2, 2, 'ACTIVO', 'INSERCION/ctorres/2021-08-25 20:08:10.988686-04');
INSERT INTO proveedores (id_pro, id_per, estado, auditoria) VALUES (3, 3, 'ACTIVO', 'INSERCION/ctorres/2021-08-25 20:08:10.988686-04');


--
-- TOC entry 2366 (class 0 OID 44561)
-- Dependencies: 193
-- Data for Name: sucursales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO sucursales (id_suc, suc_ruc, suc_nombre, suc_direccion, suc_correo, suc_celular, suc_ubicacion, suc_imagen, estado, auditoria) VALUES (1, '1234567-0', 'CASA MATRIZ', 'calle san roque', 'casamatriz@gmail.com', '0981000000', 'xy', '/cuarto/imagenes/sucursales/1.jpg', 'ACTIVO', NULL);
INSERT INTO sucursales (id_suc, suc_ruc, suc_nombre, suc_direccion, suc_correo, suc_celular, suc_ubicacion, suc_imagen, estado, auditoria) VALUES (2, '1234567-0', 'ÑEMBY', 'calle san roque', 'ñemby@gmail.com', '0981000001', 'xy', '/cuarto/imagenes/sucursales/2.jpg', 'ACTIVO', NULL);
INSERT INTO sucursales (id_suc, suc_ruc, suc_nombre, suc_direccion, suc_correo, suc_celular, suc_ubicacion, suc_imagen, estado, auditoria) VALUES (3, '1234567-0', 'FERNANDO DE LA MORA', 'calle san roque', 'fernando@gmail.com', '0981000002', 'xy', '/cuarto/imagenes/sucursales/3.jpg', 'ACTIVO', NULL);


--
-- TOC entry 2370 (class 0 OID 45184)
-- Dependencies: 202
-- Data for Name: tipos_articulos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tipos_articulos (id_ta, ta_descrip, estado, auditoria) VALUES (1, 'CHAMPION', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO tipos_articulos (id_ta, ta_descrip, estado, auditoria) VALUES (2, 'PERFUMES', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO tipos_articulos (id_ta, ta_descrip, estado, auditoria) VALUES (3, 'CAMISETAS', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO tipos_articulos (id_ta, ta_descrip, estado, auditoria) VALUES (4, 'ZAPATILLAS', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO tipos_articulos (id_ta, ta_descrip, estado, auditoria) VALUES (5, 'GORROS', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');
INSERT INTO tipos_articulos (id_ta, ta_descrip, estado, auditoria) VALUES (6, 'PELOTAS', 'ACTIVO', 'INSERCION/ctorres/2021-08-23 20:01:24.129567-04');


--
-- TOC entry 2367 (class 0 OID 44567)
-- Dependencies: 194
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO usuarios (id_usu, usu_login, usu_contrasena, usu_imagen, estado, auditoria, id_fun, id_gru, id_suc) VALUES (2, 'jperez', '202cb962ac59075b964b07152d234b70', '/cuarto/imagenes/usuarios/2.png', 'ACTIVO', NULL, 2, 2, 2);
INSERT INTO usuarios (id_usu, usu_login, usu_contrasena, usu_imagen, estado, auditoria, id_fun, id_gru, id_suc) VALUES (1, 'ctorres', '202cb962ac59075b964b07152d234b70', '/cuarto/imagenes/usuarios/1.png', 'ACTIVO', NULL, 1, 1, 1);


--
-- TOC entry 2368 (class 0 OID 44573)
-- Dependencies: 195
-- Data for Name: usuarios_sucursales; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2153 (class 2606 OID 44589)
-- Name: acciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY acciones
    ADD CONSTRAINT acciones_pkey PRIMARY KEY (id_ac);


--
-- TOC entry 2187 (class 2606 OID 45199)
-- Name: articulos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY articulos
    ADD CONSTRAINT articulos_pkey PRIMARY KEY (id_art);


--
-- TOC entry 2155 (class 2606 OID 44591)
-- Name: cargos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY (id_car);


--
-- TOC entry 2157 (class 2606 OID 44593)
-- Name: ciudades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ciudades
    ADD CONSTRAINT ciudades_pkey PRIMARY KEY (id_ciu);


--
-- TOC entry 2191 (class 2606 OID 45227)
-- Name: compras_pedidos_detalles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_pedidos_detalles
    ADD CONSTRAINT compras_pedidos_detalles_pkey PRIMARY KEY (id_cp, id_art);


--
-- TOC entry 2189 (class 2606 OID 45217)
-- Name: compras_pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_pedidos
    ADD CONSTRAINT compras_pedidos_pkey PRIMARY KEY (id_cp);


--
-- TOC entry 2197 (class 2606 OID 45287)
-- Name: compras_presupuestos_detalles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_presupuestos_detalles
    ADD CONSTRAINT compras_presupuestos_detalles_pkey PRIMARY KEY (id_cpre, id_art);


--
-- TOC entry 2199 (class 2606 OID 45317)
-- Name: compras_presupuestos_pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_presupuestos_pedidos
    ADD CONSTRAINT compras_presupuestos_pedidos_pkey PRIMARY KEY (id_cpre, id_cp, id_art);


--
-- TOC entry 2195 (class 2606 OID 45272)
-- Name: compras_presupuestos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_presupuestos
    ADD CONSTRAINT compras_presupuestos_pkey PRIMARY KEY (id_cpre);


--
-- TOC entry 2159 (class 2606 OID 44595)
-- Name: estados_civiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY estados_civiles
    ADD CONSTRAINT estados_civiles_pkey PRIMARY KEY (id_ec);


--
-- TOC entry 2161 (class 2606 OID 44597)
-- Name: funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (id_fun);


--
-- TOC entry 2163 (class 2606 OID 44599)
-- Name: generos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY generos
    ADD CONSTRAINT generos_pkey PRIMARY KEY (id_gen);


--
-- TOC entry 2165 (class 2606 OID 44601)
-- Name: grupos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos
    ADD CONSTRAINT grupos_pkey PRIMARY KEY (id_gru);


--
-- TOC entry 2183 (class 2606 OID 45183)
-- Name: marcas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY marcas
    ADD CONSTRAINT marcas_pkey PRIMARY KEY (id_mar);


--
-- TOC entry 2167 (class 2606 OID 44603)
-- Name: modulos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY modulos
    ADD CONSTRAINT modulos_pkey PRIMARY KEY (id_mod);


--
-- TOC entry 2169 (class 2606 OID 44605)
-- Name: paginas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY paginas
    ADD CONSTRAINT paginas_pkey PRIMARY KEY (id_pag);


--
-- TOC entry 2171 (class 2606 OID 44607)
-- Name: paises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY paises
    ADD CONSTRAINT paises_pkey PRIMARY KEY (id_pais);


--
-- TOC entry 2173 (class 2606 OID 44609)
-- Name: permisos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permisos
    ADD CONSTRAINT permisos_pkey PRIMARY KEY (id_gru, id_pag, id_ac);


--
-- TOC entry 2175 (class 2606 OID 44611)
-- Name: personas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT personas_pkey PRIMARY KEY (id_per);


--
-- TOC entry 2193 (class 2606 OID 45259)
-- Name: proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id_pro);


--
-- TOC entry 2177 (class 2606 OID 44613)
-- Name: sucursales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sucursales
    ADD CONSTRAINT sucursales_pkey PRIMARY KEY (id_suc);


--
-- TOC entry 2185 (class 2606 OID 45191)
-- Name: tipos_articulos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipos_articulos
    ADD CONSTRAINT tipos_articulos_pkey PRIMARY KEY (id_ta);


--
-- TOC entry 2179 (class 2606 OID 44615)
-- Name: usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usu);


--
-- TOC entry 2181 (class 2606 OID 44617)
-- Name: usuarios_sucursales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_sucursales
    ADD CONSTRAINT usuarios_sucursales_pkey PRIMARY KEY (id_usu, id_suc);


--
-- TOC entry 2215 (class 2606 OID 45200)
-- Name: articulos_id_mar_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY articulos
    ADD CONSTRAINT articulos_id_mar_fkey FOREIGN KEY (id_mar) REFERENCES marcas(id_mar);


--
-- TOC entry 2216 (class 2606 OID 45205)
-- Name: articulos_id_ta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY articulos
    ADD CONSTRAINT articulos_id_ta_fkey FOREIGN KEY (id_ta) REFERENCES tipos_articulos(id_ta);


--
-- TOC entry 2200 (class 2606 OID 44618)
-- Name: ciudades_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ciudades
    ADD CONSTRAINT ciudades_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES paises(id_pais);


--
-- TOC entry 2219 (class 2606 OID 45233)
-- Name: compras_pedidos_detalles_id_art_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_pedidos_detalles
    ADD CONSTRAINT compras_pedidos_detalles_id_art_fkey FOREIGN KEY (id_art) REFERENCES articulos(id_art);


--
-- TOC entry 2218 (class 2606 OID 45228)
-- Name: compras_pedidos_detalles_id_cp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_pedidos_detalles
    ADD CONSTRAINT compras_pedidos_detalles_id_cp_fkey FOREIGN KEY (id_cp) REFERENCES compras_pedidos(id_cp);


--
-- TOC entry 2217 (class 2606 OID 45218)
-- Name: compras_pedidos_id_suc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_pedidos
    ADD CONSTRAINT compras_pedidos_id_suc_fkey FOREIGN KEY (id_suc) REFERENCES sucursales(id_suc);


--
-- TOC entry 2224 (class 2606 OID 45293)
-- Name: compras_presupuestos_detalles_id_art_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_presupuestos_detalles
    ADD CONSTRAINT compras_presupuestos_detalles_id_art_fkey FOREIGN KEY (id_art) REFERENCES articulos(id_art);


--
-- TOC entry 2223 (class 2606 OID 45288)
-- Name: compras_presupuestos_detalles_id_cpre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_presupuestos_detalles
    ADD CONSTRAINT compras_presupuestos_detalles_id_cpre_fkey FOREIGN KEY (id_cpre) REFERENCES compras_presupuestos(id_cpre);


--
-- TOC entry 2222 (class 2606 OID 45278)
-- Name: compras_presupuestos_id_pro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_presupuestos
    ADD CONSTRAINT compras_presupuestos_id_pro_fkey FOREIGN KEY (id_pro) REFERENCES proveedores(id_pro);


--
-- TOC entry 2221 (class 2606 OID 45273)
-- Name: compras_presupuestos_id_suc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_presupuestos
    ADD CONSTRAINT compras_presupuestos_id_suc_fkey FOREIGN KEY (id_suc) REFERENCES sucursales(id_suc);


--
-- TOC entry 2226 (class 2606 OID 45323)
-- Name: compras_presupuestos_pedidos_id_cp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_presupuestos_pedidos
    ADD CONSTRAINT compras_presupuestos_pedidos_id_cp_fkey FOREIGN KEY (id_cp, id_art) REFERENCES compras_pedidos_detalles(id_cp, id_art);


--
-- TOC entry 2225 (class 2606 OID 45318)
-- Name: compras_presupuestos_pedidos_id_cpre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compras_presupuestos_pedidos
    ADD CONSTRAINT compras_presupuestos_pedidos_id_cpre_fkey FOREIGN KEY (id_cpre) REFERENCES compras_presupuestos(id_cpre);


--
-- TOC entry 2201 (class 2606 OID 44623)
-- Name: funcionarios_id_car_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY funcionarios
    ADD CONSTRAINT funcionarios_id_car_fkey FOREIGN KEY (id_car) REFERENCES cargos(id_car);


--
-- TOC entry 2202 (class 2606 OID 44628)
-- Name: funcionarios_id_per_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY funcionarios
    ADD CONSTRAINT funcionarios_id_per_fkey FOREIGN KEY (id_per) REFERENCES personas(id_per);


--
-- TOC entry 2203 (class 2606 OID 44633)
-- Name: paginas_id_mod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY paginas
    ADD CONSTRAINT paginas_id_mod_fkey FOREIGN KEY (id_mod) REFERENCES modulos(id_mod);


--
-- TOC entry 2204 (class 2606 OID 44638)
-- Name: permisos_id_ac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permisos
    ADD CONSTRAINT permisos_id_ac_fkey FOREIGN KEY (id_ac) REFERENCES acciones(id_ac);


--
-- TOC entry 2205 (class 2606 OID 44643)
-- Name: permisos_id_gru_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permisos
    ADD CONSTRAINT permisos_id_gru_fkey FOREIGN KEY (id_gru) REFERENCES grupos(id_gru);


--
-- TOC entry 2206 (class 2606 OID 44648)
-- Name: permisos_id_pag_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permisos
    ADD CONSTRAINT permisos_id_pag_fkey FOREIGN KEY (id_pag) REFERENCES paginas(id_pag);


--
-- TOC entry 2207 (class 2606 OID 44653)
-- Name: personas_id_ciu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT personas_id_ciu_fkey FOREIGN KEY (id_ciu) REFERENCES ciudades(id_ciu);


--
-- TOC entry 2208 (class 2606 OID 44658)
-- Name: personas_id_ec_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT personas_id_ec_fkey FOREIGN KEY (id_ec) REFERENCES estados_civiles(id_ec);


--
-- TOC entry 2209 (class 2606 OID 44663)
-- Name: personas_id_gen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT personas_id_gen_fkey FOREIGN KEY (id_gen) REFERENCES generos(id_gen);


--
-- TOC entry 2220 (class 2606 OID 45260)
-- Name: proveedores_id_per_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY proveedores
    ADD CONSTRAINT proveedores_id_per_fkey FOREIGN KEY (id_per) REFERENCES personas(id_per);


--
-- TOC entry 2210 (class 2606 OID 44668)
-- Name: usuarios_id_fun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_id_fun_fkey FOREIGN KEY (id_fun) REFERENCES funcionarios(id_fun);


--
-- TOC entry 2211 (class 2606 OID 44673)
-- Name: usuarios_id_gru_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_id_gru_fkey FOREIGN KEY (id_gru) REFERENCES grupos(id_gru);


--
-- TOC entry 2212 (class 2606 OID 44678)
-- Name: usuarios_id_suc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_id_suc_fkey FOREIGN KEY (id_suc) REFERENCES sucursales(id_suc);


--
-- TOC entry 2213 (class 2606 OID 44683)
-- Name: usuarios_sucursales_id_suc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_sucursales
    ADD CONSTRAINT usuarios_sucursales_id_suc_fkey FOREIGN KEY (id_suc) REFERENCES sucursales(id_suc);


--
-- TOC entry 2214 (class 2606 OID 44688)
-- Name: usuarios_sucursales_id_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_sucursales
    ADD CONSTRAINT usuarios_sucursales_id_usu_fkey FOREIGN KEY (id_usu) REFERENCES usuarios(id_usu);


--
-- TOC entry 2384 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2021-08-26 21:18:11

--
-- PostgreSQL database dump complete
--


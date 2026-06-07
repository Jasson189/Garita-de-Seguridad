--
-- PostgreSQL database dump
--

\restrict 0A3dZEfrgAzDkG2kwXa9I9ZfiyF7Cd2sSwadnIMLGiM3YbE7cxfsD4ZbFbeopYE

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2026-06-07 08:36:53

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 232 (class 1259 OID 65776)
-- Name: prerregistros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prerregistros (
    id_prerregistro integer NOT NULL,
    id_vecino integer NOT NULL,
    nombre_visitante character varying(150) NOT NULL,
    dpi_visitante character varying(30),
    telefono_visitante character varying(20),
    correo_visitante character varying(150),
    placa character varying(20),
    motivo text,
    fecha_visita date NOT NULL,
    hora_visita time without time zone,
    codigo_qr character varying(100) NOT NULL,
    estado_qr character varying(20) DEFAULT 'pendiente'::character varying,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento timestamp without time zone,
    usado boolean DEFAULT false
);


ALTER TABLE public.prerregistros OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 65775)
-- Name: prerregistros_id_prerregistro_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prerregistros_id_prerregistro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prerregistros_id_prerregistro_seq OWNER TO postgres;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 231
-- Name: prerregistros_id_prerregistro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prerregistros_id_prerregistro_seq OWNED BY public.prerregistros.id_prerregistro;


--
-- TOC entry 218 (class 1259 OID 57465)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id_rol integer NOT NULL,
    nombre_rol character varying(50) NOT NULL,
    descripcion character varying(150),
    estado boolean DEFAULT true NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 57464)
-- Name: roles_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_rol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_rol_seq OWNER TO postgres;

--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 217
-- Name: roles_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_rol_seq OWNED BY public.roles.id_rol;


--
-- TOC entry 220 (class 1259 OID 57475)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuarios integer NOT NULL,
    nombre_usuario character varying(50) NOT NULL,
    correo character varying(100) NOT NULL,
    contrasena_hash text NOT NULL,
    id_rol integer NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    debe_cambiar_contrasena boolean DEFAULT false
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 57474)
-- Name: usuarios_id_usuarios_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_usuarios_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_usuarios_seq OWNER TO postgres;

--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuarios_id_usuarios_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuarios_seq OWNED BY public.usuarios.id_usuarios;


--
-- TOC entry 224 (class 1259 OID 57504)
-- Name: vecinos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vecinos (
    id_vecino integer NOT NULL,
    id_usuario integer,
    id_vivienda integer NOT NULL,
    nombres character varying(80) NOT NULL,
    apellidos character varying(80) NOT NULL,
    dpi character varying(20),
    telefono character varying(20),
    correo character varying(100) NOT NULL,
    codigo_unico character varying(30) NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.vecinos OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 57503)
-- Name: vecinos_id_vecino_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vecinos_id_vecino_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vecinos_id_vecino_seq OWNER TO postgres;

--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 223
-- Name: vecinos_id_vecino_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vecinos_id_vecino_seq OWNED BY public.vecinos.id_vecino;


--
-- TOC entry 230 (class 1259 OID 65760)
-- Name: vehiculos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehiculos (
    id_vehiculo integer NOT NULL,
    id_vecino integer NOT NULL,
    placa character varying(20) NOT NULL,
    marca character varying(50),
    color character varying(30),
    modelo character varying(50),
    autorizado boolean DEFAULT true,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.vehiculos OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 65759)
-- Name: vehiculos_id_vehiculo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehiculos_id_vehiculo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vehiculos_id_vehiculo_seq OWNER TO postgres;

--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 229
-- Name: vehiculos_id_vehiculo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehiculos_id_vehiculo_seq OWNED BY public.vehiculos.id_vehiculo;


--
-- TOC entry 226 (class 1259 OID 57527)
-- Name: visitantes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visitantes (
    id_visitantes integer NOT NULL,
    nombres character varying(80) NOT NULL,
    apellidos character varying(80) NOT NULL,
    tipo_documento character varying(20),
    numero_documento character varying(30),
    telefono character varying(20),
    observaciones text,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    dpi_licencia character varying(30)
);


ALTER TABLE public.visitantes OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 57526)
-- Name: visitantes_id_visitantes_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visitantes_id_visitantes_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visitantes_id_visitantes_seq OWNER TO postgres;

--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 225
-- Name: visitantes_id_visitantes_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visitantes_id_visitantes_seq OWNED BY public.visitantes.id_visitantes;


--
-- TOC entry 228 (class 1259 OID 57537)
-- Name: visitas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visitas (
    id_visita integer NOT NULL,
    id_visitante integer NOT NULL,
    id_vecino integer NOT NULL,
    id_vivienda integer NOT NULL,
    id_usuario_agente integer NOT NULL,
    tipo_ingreso character varying(20) NOT NULL,
    fecha_ingreso date NOT NULL,
    hora_ingreso time without time zone NOT NULL,
    estado_visita character varying(20) DEFAULT 'activa'::character varying NOT NULL,
    observaciones text,
    fecha_salida date,
    hora_salida time without time zone,
    foto text,
    placa character varying(20),
    estado_autorizacion_vecino character varying(30) DEFAULT 'pendiente_vecino'::character varying,
    fecha_respuesta_vecino timestamp without time zone
);


ALTER TABLE public.visitas OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 57536)
-- Name: visitas_id_visita_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visitas_id_visita_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visitas_id_visita_seq OWNER TO postgres;

--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 227
-- Name: visitas_id_visita_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visitas_id_visita_seq OWNED BY public.visitas.id_visita;


--
-- TOC entry 222 (class 1259 OID 57495)
-- Name: viviendas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.viviendas (
    id_vivienda integer NOT NULL,
    numero_vivienda character varying(20) NOT NULL,
    sector character varying(50),
    direccion_referencia character varying(150),
    estado boolean DEFAULT true NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.viviendas OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 57494)
-- Name: viviendas_id_vivienda_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.viviendas_id_vivienda_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.viviendas_id_vivienda_seq OWNER TO postgres;

--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 221
-- Name: viviendas_id_vivienda_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.viviendas_id_vivienda_seq OWNED BY public.viviendas.id_vivienda;


--
-- TOC entry 4797 (class 2604 OID 65779)
-- Name: prerregistros id_prerregistro; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerregistros ALTER COLUMN id_prerregistro SET DEFAULT nextval('public.prerregistros_id_prerregistro_seq'::regclass);


--
-- TOC entry 4777 (class 2604 OID 57468)
-- Name: roles id_rol; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id_rol SET DEFAULT nextval('public.roles_id_rol_seq'::regclass);


--
-- TOC entry 4779 (class 2604 OID 57478)
-- Name: usuarios id_usuarios; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuarios SET DEFAULT nextval('public.usuarios_id_usuarios_seq'::regclass);


--
-- TOC entry 4786 (class 2604 OID 57507)
-- Name: vecinos id_vecino; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos ALTER COLUMN id_vecino SET DEFAULT nextval('public.vecinos_id_vecino_seq'::regclass);


--
-- TOC entry 4794 (class 2604 OID 65763)
-- Name: vehiculos id_vehiculo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehiculos ALTER COLUMN id_vehiculo SET DEFAULT nextval('public.vehiculos_id_vehiculo_seq'::regclass);


--
-- TOC entry 4789 (class 2604 OID 57530)
-- Name: visitantes id_visitantes; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitantes ALTER COLUMN id_visitantes SET DEFAULT nextval('public.visitantes_id_visitantes_seq'::regclass);


--
-- TOC entry 4791 (class 2604 OID 57540)
-- Name: visitas id_visita; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas ALTER COLUMN id_visita SET DEFAULT nextval('public.visitas_id_visita_seq'::regclass);


--
-- TOC entry 4783 (class 2604 OID 57498)
-- Name: viviendas id_vivienda; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viviendas ALTER COLUMN id_vivienda SET DEFAULT nextval('public.viviendas_id_vivienda_seq'::regclass);


--
-- TOC entry 5000 (class 0 OID 65776)
-- Dependencies: 232
-- Data for Name: prerregistros; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (78, 1, 'dasdasd', '6666', NULL, 'jelsonxlntres@gmail.com', '22', 'dejar un paquete', '2026-06-07', '07:21:37.47602', '018b5e6a-4cfc-4533-ba24-0c05bbd58887', 'pendiente', '2026-06-07 07:21:37.47602', NULL, false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (79, 1, 'dasdasd', '6666', NULL, 'jelsonxlntres@gmail.com', '22', 'dejar un paquete', '2026-06-07', '07:21:42.515973', '17e5fa01-756b-412a-87af-bd000ac4190c', 'usado', '2026-06-07 07:21:42.515973', NULL, false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (80, 1, 'Carlos', '6666', NULL, 'jelsonxlntres@gmail.com', 'P123ABC', 'familia', '2026-06-07', '07:35:09.938151', '5c996b0e-1a9f-4ab7-94cd-32087cf54f2a', 'usado', '2026-06-07 07:35:09.938151', NULL, false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (3, 1, 'Pedro Lopez', '123', NULL, NULL, 'P12C', 'Visita familiar', '2026-05-16', '23:17:39.423861', 'fb593bb2-cae5-4c3b-971e-223829df08ac', 'pendiente', '2026-05-16 23:17:39.423861', '2026-05-17 23:17:39.423861', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (4, 1, 'Mario', '11111', NULL, NULL, '3BHT57K', 'visita familiar ', '2026-05-16', '23:21:37.880645', '424b2a07-6b3d-450a-a784-7f3a148f5c80', 'pendiente', '2026-05-16 23:21:37.880645', '2026-05-17 23:21:37.880645', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (5, 1, 'ivan', '444', NULL, NULL, '12RTG3', 'repartidor ', '2026-05-16', '23:27:16.083272', '0eb1219c-9f2d-4cff-8b57-c9465dfd6ab4', 'pendiente', '2026-05-16 23:27:16.083272', '2026-05-17 23:27:16.083272', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (6, 1, 'Mario', '11111', NULL, NULL, '3BHT57K', 'visita familiar ', '2026-05-16', '23:35:20.970495', '0a94c3c6-c93d-4153-8446-86a23d423381', 'pendiente', '2026-05-16 23:35:20.970495', '2026-05-17 23:35:20.970495', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (7, 1, 'Mario', '11111', NULL, 'mario@gmail.com', '3BHT57K', 'visita familiar ', '2026-05-16', '23:41:35.003698', '304228fe-8811-4e87-ae87-8d6b10d57b3f', 'pendiente', '2026-05-16 23:41:35.003698', '2026-05-17 23:41:35.003698', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (51, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '18:11:44.286098', '5cec8836-8211-4c5d-8b6e-98fea280ab82', 'usado', '2026-05-21 18:11:44.286098', '2026-05-22 18:11:44.286098', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (52, 1, 'erick', '6666', NULL, 'garitas041@gmail.com', '1212122', 'dejar un paquete ', '2026-05-22', '12:25:40.136073', 'a5ec8218-759b-4735-b7ed-accddd6ca4f2', 'usado', '2026-05-22 12:25:40.136073', '2026-05-23 12:25:40.136073', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (53, 1, 'carlos ', '5555', NULL, 'garitas041@gmail.com', '888', 'prueba ', '2026-05-22', '13:42:46.00636', '2c1eb2ba-73ff-4ad1-91f8-bb578c87bd39', 'pendiente', '2026-05-22 13:42:46.00636', '2026-05-23 13:42:46.00636', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (54, 1, 'carlos ', '5555', NULL, 'garitas041@gmail.com', '888', 'prueba ', '2026-05-22', '13:43:04.208086', '7799f5cd-65a9-4e5b-8718-00a5672a0a3a', 'pendiente', '2026-05-22 13:43:04.208086', '2026-05-23 13:43:04.208086', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (55, 1, 'carlos ', '5555', NULL, 'garitas041@gmail.com', '888', 'prueba ', '2026-05-22', '13:45:43.968746', 'e6f9b9c9-b897-4459-940d-881c8c566794', 'pendiente', '2026-05-22 13:45:43.968746', '2026-05-23 13:45:43.968746', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (56, 1, 'Carlos ', '1111', NULL, 'garitas041@gmail.com', '888', 'preuba', '2026-05-22', '13:46:04.929539', '47bb0090-6c2b-427f-97b0-72c7d1036a4b', 'usado', '2026-05-22 13:46:04.929539', '2026-05-23 13:46:04.929539', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (49, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:59:45.902264', '518c2a06-1a07-4de4-b8e7-0039b5c0ce6f', 'usado', '2026-05-21 17:59:45.902264', '2026-05-22 17:59:45.902264', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (57, 1, 'erick', '6666', NULL, 'garitas041@gmail.com', 'SDADASDAS', 'preuba', '2026-05-22', '21:52:50.385277', 'd96e3201-847a-4a3f-a04b-9f43615815c0', 'usado', '2026-05-22 21:52:50.385277', '2026-05-23 21:52:50.385277', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (58, 1, 'erick', '6666', NULL, 'garitas041@gmail.com', 'SDADASDAS', 'preuba', '2026-05-22', '21:53:43.200096', 'ec025c6f-4bc8-4ea3-b4b4-e6ff7af038e0', 'usado', '2026-05-22 21:53:43.200096', '2026-05-23 21:53:43.200096', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (59, 1, 'pedor suya ', '1111', NULL, 'garitas041@gmail.com', '22', 'familia ', '2026-05-22', '22:29:29.474429', 'd398680b-a108-4849-9996-7bf76a193e3f', 'usado', '2026-05-22 22:29:29.474429', '2026-05-23 22:29:29.474429', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (60, 1, 'pedor suya ', '1111', NULL, 'garitas041@gmail.com', '22', 'familia ', '2026-05-22', '22:29:58.304108', 'ae937a00-e6e9-436a-87d8-16b495ae84db', 'usado', '2026-05-22 22:29:58.304108', '2026-05-23 22:29:58.304108', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (50, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '18:08:30.994047', '8a8ed040-ee20-409e-a2fe-f6a7cb2485f4', 'usado', '2026-05-21 18:08:30.994047', '2026-05-22 18:08:30.994047', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (61, 1, 'Carlos ', 'sdada', NULL, 'garitas041@gmail.com', '888', 'preuba', '2026-05-23', '18:07:39.161701', '6c923949-1264-4668-9b42-19e79739e27d', 'pendiente', '2026-05-23 18:07:39.161701', '2026-05-24 18:07:39.161701', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (62, 1, 'Carlos ', 'sdada', NULL, 'garitas041@gmail.com', '888', 'preuba', '2026-05-23', '18:07:41.108811', '30176352-e1f9-43d1-ba17-72b3271cbba8', 'pendiente', '2026-05-23 18:07:41.108811', '2026-05-24 18:07:41.108811', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (8, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:01:38.322694', 'a6ea42d6-fb26-41b7-a190-a75f78de9b07', 'pendiente', '2026-05-17 00:01:38.322694', '2026-05-18 00:01:38.322694', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (9, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:01:40.577633', 'c5291c1d-301c-4ccf-8bda-d1352059d043', 'pendiente', '2026-05-17 00:01:40.577633', '2026-05-18 00:01:40.577633', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (10, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:01:41.145182', 'c3e569cc-42d0-4913-8aea-1424a1b60b06', 'pendiente', '2026-05-17 00:01:41.145182', '2026-05-18 00:01:41.145182', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (11, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:01:41.343268', '6b73e1b8-3f43-4ade-ab98-f4d3999b3711', 'pendiente', '2026-05-17 00:01:41.343268', '2026-05-18 00:01:41.343268', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (12, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:01:41.540599', '8f8a746d-c0be-4da4-bb9a-0f11d0e1a416', 'pendiente', '2026-05-17 00:01:41.540599', '2026-05-18 00:01:41.540599', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (13, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:01:49.743305', 'cdbb070c-903b-4ed8-8b33-f63525a1e7be', 'pendiente', '2026-05-17 00:01:49.743305', '2026-05-18 00:01:49.743305', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (14, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:02:53.094867', 'a6b43510-381b-4f88-a450-1f734ee65703', 'pendiente', '2026-05-17 00:02:53.094867', '2026-05-18 00:02:53.094867', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (15, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:02:53.307118', '28adcb02-a237-414b-93f5-57fc27667748', 'pendiente', '2026-05-17 00:02:53.307118', '2026-05-18 00:02:53.307118', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (16, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:02:53.515949', '6be207cc-f0a5-4e77-b690-5c30ce1c99c3', 'pendiente', '2026-05-17 00:02:53.515949', '2026-05-18 00:02:53.515949', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (17, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:02:53.684943', 'd9025307-86c1-4408-bd8a-7c4569db195b', 'pendiente', '2026-05-17 00:02:53.684943', '2026-05-18 00:02:53.684943', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (18, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:06:12.810935', 'a705c241-8708-4f82-af73-a9952b3dff61', 'pendiente', '2026-05-17 00:06:12.810935', '2026-05-18 00:06:12.810935', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (19, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:06:13.685804', '91154c0d-c50d-4449-a8d3-5705dfa666be', 'pendiente', '2026-05-17 00:06:13.685804', '2026-05-18 00:06:13.685804', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (20, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:06:13.878655', '28ab4a89-8d2a-4601-a997-99b3a7e55e4a', 'pendiente', '2026-05-17 00:06:13.878655', '2026-05-18 00:06:13.878655', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (21, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:06:14.067534', '93c59ac5-d58f-4c50-9d5d-02d69bd68714', 'pendiente', '2026-05-17 00:06:14.067534', '2026-05-18 00:06:14.067534', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (22, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:06:14.23495', '8d036b8a-98f6-4267-b144-f140b87a0bdb', 'pendiente', '2026-05-17 00:06:14.23495', '2026-05-18 00:06:14.23495', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (23, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:06:14.414748', 'f10acb8f-731a-473c-a520-e9f3ea8be7aa', 'pendiente', '2026-05-17 00:06:14.414748', '2026-05-18 00:06:14.414748', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (24, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:13:45.788563', 'ef4c2fe7-5788-4a26-92c7-021900781beb', 'pendiente', '2026-05-17 00:13:45.788563', '2026-05-18 00:13:45.788563', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (25, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:13:47.079515', '93f6cc5c-5378-4c44-8029-a68ae4695296', 'pendiente', '2026-05-17 00:13:47.079515', '2026-05-18 00:13:47.079515', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (26, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:14:30.867037', 'f7619dbb-ff81-43cb-b670-c0b6e7d0e7af', 'pendiente', '2026-05-17 00:14:30.867037', '2026-05-18 00:14:30.867037', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (27, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:14:32.745456', 'acbfb173-ffd4-4735-9ded-7f61a3d57ad9', 'pendiente', '2026-05-17 00:14:32.745456', '2026-05-18 00:14:32.745456', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (28, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:14:32.936089', '7280c87b-7ae5-4c01-a85a-f7f79d786f69', 'pendiente', '2026-05-17 00:14:32.936089', '2026-05-18 00:14:32.936089', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (29, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:14:33.118198', '39f42eb3-7e3c-41cf-bc98-aab22979316c', 'pendiente', '2026-05-17 00:14:33.118198', '2026-05-18 00:14:33.118198', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (30, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:14:33.296255', 'a4a32354-66b0-412b-9c47-e40e6255160f', 'pendiente', '2026-05-17 00:14:33.296255', '2026-05-18 00:14:33.296255', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (31, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:14:33.476492', 'a409f65e-d761-44ff-99c5-b3cb71c4a0d6', 'pendiente', '2026-05-17 00:14:33.476492', '2026-05-18 00:14:33.476492', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (32, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:16:02.24431', 'cff4e63f-551f-49d5-96ad-05f06bca4cf1', 'pendiente', '2026-05-17 00:16:02.24431', '2026-05-18 00:16:02.24431', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (33, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '00:17:54.994192', '13c86ce9-d151-4b5e-ab64-37e63d41e549', 'pendiente', '2026-05-17 00:17:54.994192', '2026-05-18 00:17:54.994192', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (34, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-17', '08:57:40.119559', 'fafb9fa7-9135-4d59-9134-9a2d0319710a', 'pendiente', '2026-05-17 08:57:40.119559', '2026-05-18 08:57:40.119559', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (35, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-18', '22:22:50.130361', 'b1d51f9a-8c02-4595-aa5b-6f7dfc7676dc', 'pendiente', '2026-05-18 22:22:50.130361', '2026-05-19 22:22:50.130361', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (36, 1, 'garita ', '112222', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-18', '22:22:52.86475', 'ac78b092-0464-4c63-8e15-05af41cb7ed5', 'usado', '2026-05-18 22:22:52.86475', '2026-05-19 22:22:52.86475', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (37, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:22:55.768314', 'c391708f-5d8e-4469-8633-2bee284887f9', 'pendiente', '2026-05-21 17:22:55.768314', '2026-05-22 17:22:55.768314', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (38, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:22:58.271886', '5d3302f6-59f8-4dcf-b98a-7975616f508f', 'pendiente', '2026-05-21 17:22:58.271886', '2026-05-22 17:22:58.271886', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (39, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:22:58.686127', 'a42e9121-749f-4c20-8384-283d7485e4be', 'pendiente', '2026-05-21 17:22:58.686127', '2026-05-22 17:22:58.686127', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (40, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:22:58.892722', '75f4d0f8-db71-41bc-95b9-2ef8558005b5', 'pendiente', '2026-05-21 17:22:58.892722', '2026-05-22 17:22:58.892722', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (42, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:22:59.284068', '1b325c1f-5bde-4c6a-80f6-106f50fd0684', 'pendiente', '2026-05-21 17:22:59.284068', '2026-05-22 17:22:59.284068', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (43, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:40:08.47786', 'dbc48896-eedd-4bea-8d68-f37218491227', 'pendiente', '2026-05-21 17:40:08.47786', '2026-05-22 17:40:08.47786', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (44, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:40:08.889961', 'ca5d0479-b008-4304-9496-b0793d78dbab', 'pendiente', '2026-05-21 17:40:08.889961', '2026-05-22 17:40:08.889961', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (45, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:40:09.140377', '5315a503-16cd-4795-986a-687fdec822d0', 'pendiente', '2026-05-21 17:40:09.140377', '2026-05-22 17:40:09.140377', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (46, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:40:09.305175', '0632b2e8-e6dd-48bf-bcbe-0c932d182ec2', 'pendiente', '2026-05-21 17:40:09.305175', '2026-05-22 17:40:09.305175', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (47, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:41:54.325211', '750fb051-352f-4716-b389-9ca4da6d5287', 'pendiente', '2026-05-21 17:41:54.325211', '2026-05-22 17:41:54.325211', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (48, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:54:39.595289', 'a0751bc4-8072-4dde-808f-5e23bd253222', 'pendiente', '2026-05-21 17:54:39.595289', '2026-05-22 17:54:39.595289', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (41, 1, 'garita ', '4444444', NULL, 'garitas041@gmail.com', '3BHT57K', 'repartidor ', '2026-05-21', '17:22:59.082861', '96159cbe-2f35-4cf7-8383-73c4ebff5e34', 'usado', '2026-05-21 17:22:59.082861', '2026-05-22 17:22:59.082861', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (63, 1, 'Carlos ', 'sdada', NULL, 'garitas041@gmail.com', '888', 'preuba', '2026-05-23', '18:07:42.352223', '0c738b19-3ca4-4eae-a1e4-a9967fabc5df', 'pendiente', '2026-05-23 18:07:42.352223', '2026-05-24 18:07:42.352223', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (64, 1, 'Carlos ', 'sdada', NULL, 'garitas041@gmail.com', '888', 'preuba', '2026-05-23', '18:07:42.52714', '00555115-82b8-4154-9c68-371da16fc977', 'pendiente', '2026-05-23 18:07:42.52714', '2026-05-24 18:07:42.52714', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (65, 1, 'Carlos ', 'sdada', NULL, 'garitas041@gmail.com', '888', 'preuba', '2026-05-23', '18:07:42.731523', 'c23248a8-11bf-4f4f-95ba-a93724c8cfb5', 'pendiente', '2026-05-23 18:07:42.731523', '2026-05-24 18:07:42.731523', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (66, 1, 'Carlos ', 'sdada', NULL, 'garitas041@gmail.com', '888', 'preuba', '2026-05-23', '18:07:42.904073', '95cfdabd-eaf2-4e9a-b66e-abae2744ce62', 'usado', '2026-05-23 18:07:42.904073', '2026-05-24 18:07:42.904073', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (67, 1, 'Carlos ', 'sdada', NULL, 'garitas041@gmail.com', '888', 'preuba', '2026-05-23', '18:08:19.772761', '533ad35f-82c5-458e-a6c8-f507536b6f71', 'usado', '2026-05-23 18:08:19.772761', '2026-05-24 18:08:19.772761', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (68, 1, 'pedro', '6666', NULL, 'garitas041@gmail.com', '22', 'dejar un paquete ', '2026-05-23', '21:00:21.369067', 'cf98a79c-488d-4e98-bd34-5824c2d43924', 'pendiente', '2026-05-23 21:00:21.369067', '2026-05-24 21:00:21.369067', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (69, 1, 'pedro', '6666', NULL, 'garitas041@gmail.com', '22', 'dejar un paquete ', '2026-05-23', '21:00:25.834886', 'cd247c51-b6b2-45ff-b092-d81272998e15', 'usado', '2026-05-23 21:00:25.834886', '2026-05-24 21:00:25.834886', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (70, 1, 'pedro', '6666', NULL, 'garitas041@gmail.com', '22', 'dejar un paquete ', '2026-05-23', '21:00:33.586819', '501f2b1d-ee95-4d6f-9d61-beef92cf69f6', 'usado', '2026-05-23 21:00:33.586819', '2026-05-24 21:00:33.586819', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (71, 11, 'Carlos Lopez', '1234567890101', NULL, NULL, 'P123ABC', 'Visita familiar', '2026-05-24', '19:55:36.724286', '12258c34-a57c-450c-802a-32db66c66cd5', 'pendiente', '2026-05-24 19:55:36.724286', '2026-05-25 19:55:36.724286', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (72, 11, 'Carlos Lopez', '1234567890101', NULL, NULL, 'P123ABC', 'visita familiar', '2026-05-24', '20:19:23.388904', '43c04423-13a3-4080-b0fb-8cbb8ea47cd5', 'pendiente', '2026-05-24 20:19:23.388904', '2026-05-25 20:19:23.388904', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (73, 11, 'Carlos Lopez', '1234567890101', NULL, NULL, 'P123ABC', 'visita familiar', '2026-05-24', '20:25:13.291797', '8babd5e0-e1ad-432c-a9bf-488645e0657a', 'usado', '2026-05-24 20:25:13.291797', '2026-05-25 20:25:13.291797', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (75, 1, 'erick', 'sdada', NULL, 'jelsonxlntres@gmail.com', 'SDADASDAS', 'dejar un paquete', '2026-05-26', '23:02:15.218981', '371ab581-45ff-4e34-be32-af01ac2919a3', 'pendiente', '2026-05-26 23:02:15.218981', '2026-05-27 23:02:15.218981', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (74, 1, 'erick', '1111', NULL, 'jelsonxlntres@gmail.com', 'SDASD', 'dejar un paquete', '2026-05-26', '22:59:41.967895', '4aa7eda5-f9e9-48bd-91a0-04c4aff518dd', 'usado', '2026-05-26 22:59:41.967895', '2026-05-27 22:59:41.967895', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (76, 1, 'dasdasd', '1111', NULL, 'jelsonxlntres@gmail.com', '22', 'sdsdas', '2026-05-27', '21:32:48.881693', '46691b9a-eb8a-4f20-9cc4-c3fe5450e600', 'usado', '2026-05-27 21:32:48.881693', '2026-05-28 21:32:48.881693', false);
INSERT INTO public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion, fecha_vencimiento, usado) VALUES (77, 20, 'Carlos Lopez', '1234567890101', NULL, NULL, 'P123ABC', 'visita familiar', '2026-06-06', '22:21:20.988042', 'dd9c81a9-e897-4b23-8c2c-542857430644', 'pendiente', '2026-06-06 22:21:20.988042', '2026-06-07 22:21:20.988042', false);


--
-- TOC entry 4986 (class 0 OID 57465)
-- Dependencies: 218
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles (id_rol, nombre_rol, descripcion, estado) VALUES (1, 'Administrador', 'Control total del sistema', true);
INSERT INTO public.roles (id_rol, nombre_rol, descripcion, estado) VALUES (2, 'Agente', 'Encargado de registrar visitas', true);
INSERT INTO public.roles (id_rol, nombre_rol, descripcion, estado) VALUES (3, 'Vecino', 'Residente de la vivienda', true);


--
-- TOC entry 4988 (class 0 OID 57475)
-- Dependencies: 220
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuarios (id_usuarios, nombre_usuario, correo, contrasena_hash, id_rol, estado, fecha_creacion, debe_cambiar_contrasena) VALUES (1, 'admin', 'admin@garita.com', '1234', 1, true, '2026-05-13 23:45:15.203207', false);
INSERT INTO public.usuarios (id_usuarios, nombre_usuario, correo, contrasena_hash, id_rol, estado, fecha_creacion, debe_cambiar_contrasena) VALUES (2, 'vecino1', 'vecino1@gmail.com', '1234', 3, true, '2026-05-24 19:36:36.892289', false);
INSERT INTO public.usuarios (id_usuarios, nombre_usuario, correo, contrasena_hash, id_rol, estado, fecha_creacion, debe_cambiar_contrasena) VALUES (3, 'jose.sicay', 'joseloepz418@gmail.com', 'jose123', 3, true, '2026-06-06 22:09:31.748722', false);
INSERT INTO public.usuarios (id_usuarios, nombre_usuario, correo, contrasena_hash, id_rol, estado, fecha_creacion, debe_cambiar_contrasena) VALUES (4, 'jelson.sicay', 'jelson@gmail.com', 'Vecino0021', 3, true, '2026-06-07 07:34:29.338707', true);


--
-- TOC entry 4992 (class 0 OID 57504)
-- Dependencies: 224
-- Data for Name: vecinos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (14, NULL, 6, 'mario', 'lopez', NULL, '12343532', 'mario@gmail.com', 'VEC-0013', false, '2026-05-22 22:15:09.604693');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (4, 1, 1, 'jose', 'lopez', '111111', '55555', 'joselopez@gmail.com', 'VEC-0003', true, '2026-05-16 15:38:56.924521');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (15, 1, 1, 'Prueba', 'JWT', '1234567890101', '55550000', 'prueba.jwt@gmail.com', 'VEC-0015', true, '2026-05-23 14:51:38.007363');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (17, NULL, 6, 'ema', 'suya', NULL, '8745656', 'ema@gmail.com', 'VEC-0016', false, '2026-05-23 15:00:19.567671');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (18, NULL, 6, 'edson', 'lopez', NULL, '867867', 'edson@gmail.com', 'VEC-0018', true, '2026-05-23 18:02:46.998218');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (19, NULL, 3, 'gerson', 'suya', NULL, '999', 'gerson@gmail.com', 'VEC-0019', true, '2026-05-23 20:59:24.585161');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (11, 2, 1, 'pedro', 'sanches', '5678', '33583642', 'pedrosanchez@gmail.com', 'VEC-0009', true, '2026-05-22 16:56:02.451964');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (1, 1, 7, 'Juan luis', 'Perez lopez', NULL, '55554444', 'juan@gmail.com', 'CASA1-ABC', false, '2026-05-13 23:45:15.203207');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (2, 1, 5, 'jose', 'lopez', '888', '44444', 'joselopez@gmail.com', 'VEC-0002', false, '2026-05-16 15:35:07.046136');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (12, NULL, 5, 'Jelson', 'Sicay', NULL, '33583642', 'jelsonxlntres@gmail.com', 'VEC-0012', true, '2026-05-22 20:42:53.822055');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (20, 3, 10, 'Jose', 'sicay', '232311231231', '33583642', 'joseloepz418@gmail.com', 'VEC-0020', true, '2026-06-06 22:09:31.748722');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (8, 1, 1, 'jose', 'lopez', '1111', '555', 'joselopez@gmail.com', 'VEC-0005', true, '2026-05-16 16:04:05.901794');
INSERT INTO public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) VALUES (21, 4, 6, 'Jelson', 'Sicay', '34343', '33583642', 'jelson@gmail.com', 'VEC-0021', true, '2026-06-07 07:34:29.338707');


--
-- TOC entry 4998 (class 0 OID 65760)
-- Dependencies: 230
-- Data for Name: vehiculos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.vehiculos (id_vehiculo, id_vecino, placa, marca, color, modelo, autorizado, fecha_registro) VALUES (1, 1, 'P123ABC', 'Toyota', 'Negro', 'Corolla', true, '2026-05-16 21:21:15.456374');


--
-- TOC entry 4994 (class 0 OID 57527)
-- Dependencies: 226
-- Data for Name: visitantes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (2, 'garita ', '', NULL, NULL, '', NULL, '2026-05-21 18:12:02.328836', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (4, 'hector ', 'sanches', NULL, NULL, NULL, NULL, '2026-05-22 17:31:05.588091', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (3, 'erick', 'PEREZ', NULL, NULL, '', NULL, '2026-05-22 12:26:46.512777', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (5, 'pedro', 'SUYA ', NULL, NULL, NULL, NULL, '2026-05-22 22:11:38.056067', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (6, 'pedor suya ', '', NULL, NULL, '', NULL, '2026-05-22 22:29:47.063825', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (7, 'ema ', 'choc', NULL, NULL, NULL, NULL, '2026-05-23 17:31:39.859507', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (8, 'jairo', 'xd', NULL, NULL, NULL, NULL, '2026-05-23 17:45:09.185028', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (9, 'hector ', 'dsasda', NULL, NULL, NULL, NULL, '2026-05-23 18:03:13.349934', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (10, 'antony ', 'perez', NULL, NULL, NULL, NULL, '2026-05-23 20:59:56.027946', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (11, 'Carlos Lopez', '', NULL, NULL, '', NULL, '2026-05-24 20:29:49.282609', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (12, 'dasdasd', '', NULL, NULL, '', NULL, '2026-05-27 22:30:19.820865', NULL);
INSERT INTO public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) VALUES (1, 'Carlos', 'Méndez', 'DPI', '1234567890101', '55550000', NULL, '2026-05-13 23:45:15.203207', '00000');


--
-- TOC entry 4996 (class 0 OID 57537)
-- Dependencies: 228
-- Data for Name: visitas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (1, 1, 1, 1, 1, 'normal', '2026-05-14', '00:47:10.835932', 'finalizada', 'Registrado desde web', '2026-05-16', '14:25:56.84468', 'fotos/visita_1_1778741230.png', '1sthy4', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (2, 1, 1, 1, 1, 'normal', '2026-05-16', '14:23:25.262562', 'finalizada', 'Registrado desde web', '2026-05-16', '14:26:00.832364', 'fotos/visita_1_1778963005.png', 'SDADASDAS', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (3, 1, 1, 1, 1, 'normal', '2026-05-16', '15:07:02.253509', 'finalizada', 'Registrado desde web', '2026-05-16', '15:07:24.254475', NULL, '4TFDGSR', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (4, 1, 2, 1, 1, 'normal', '2026-05-16', '16:19:25.468762', 'finalizada', 'Registrado desde web', '2026-05-16', '21:49:54.908188', 'fotos/visita_1_1778969965.png', '6788', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (5, 1, 1, 1, 1, 'normal', '2026-05-16', '21:48:40.087364', 'finalizada', 'Registrado desde web', '2026-05-16', '21:53:21.950422', NULL, 'P123ABC', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (6, 1, 4, 1, 1, 'normal', '2026-05-16', '22:00:12.98579', 'finalizada', 'Registrado desde web', '2026-05-16', '22:00:23.831703', NULL, 'SDADASDAS', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (7, 1, 4, 1, 1, 'normal', '2026-05-17', '08:56:33.091262', 'finalizada', 'Registrado desde web', '2026-05-17', '08:56:45.474228', 'fotos/visita_1_1779029793.png', 'yhvjhhj', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (8, 1, 2, 1, 1, 'normal', '2026-05-19', '00:20:52.000046', 'finalizada', 'Registrado desde web', '2026-05-22', '12:32:40.636164', NULL, '44533454', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (41, 1, 8, 1, 1, 'normal', '2026-05-21', '17:15:20.323032', 'finalizada', 'Registrado desde web', '2026-05-22', '12:39:15.298951', 'fotos/visita_1_1779405320.png', 'ghjtrt34545', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (42, 2, 1, 1, 1, 'QR', '2026-05-21', '18:12:02.328836', 'finalizada', 'repartidor ', '2026-05-22', '12:40:16.939323', NULL, '3BHT57K', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (43, 3, 1, 1, 1, 'QR', '2026-05-22', '12:26:46.512777', 'finalizada', 'dejar un paquete ', '2026-05-22', '14:08:33.39638', NULL, '1212122', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (44, 1, 1, 1, 1, 'QR', '2026-05-22', '13:47:49.821216', 'finalizada', 'preuba', '2026-05-22', '14:08:47.503425', NULL, '888', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (45, 2, 1, 1, 1, 'QR', '2026-05-22', '14:01:48.259381', 'finalizada', 'repartidor ', '2026-05-22', '21:51:58.93754', NULL, '3BHT57K', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (46, 4, 12, 5, 1, 'normal', '2026-05-22', '21:51:49.023105', 'finalizada', 'Registrado desde web', '2026-05-22', '21:54:11.941291', 'fotos/visita_4_1779508308.png', 'sdasd', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (48, 3, 1, 2, 1, 'QR', '2026-05-22', '21:54:04.967258', 'finalizada', 'preuba', '2026-05-22', '21:54:17.920806', NULL, 'SDADASDAS', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (47, 3, 1, 2, 1, 'QR', '2026-05-22', '21:53:33.551347', 'finalizada', 'preuba', '2026-05-22', '23:20:18.61389', NULL, 'SDADASDAS', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (49, 5, 14, 6, 1, 'normal', '2026-05-22', '22:28:50.735001', 'finalizada', 'Registrado desde web', '2026-05-22', '23:22:44.589369', 'fotos/visita_5_1779510530.png', 'SAASADDAD', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (50, 6, 1, 7, 1, 'QR', '2026-05-22', '22:29:47.063825', 'finalizada', 'familia ', '2026-05-23', '17:51:30.948424', NULL, '22', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (51, 6, 1, 7, 1, 'QR', '2026-05-22', '22:30:24.368505', 'finalizada', 'familia ', '2026-05-23', '17:54:50.448111', NULL, '22', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (53, 2, 4, 1, 1, 'normal', '2026-05-23', '17:52:56.343825', 'finalizada', 'Registrado desde web', '2026-05-23', '17:54:51.423735', 'fotos/visita_2_1779580376.png', '22', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (52, 2, 1, 7, 1, 'QR', '2026-05-22', '23:07:56.251695', 'finalizada', 'repartidor ', '2026-05-23', '21:15:36.369716', NULL, '3BHT57K', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (54, 2, 15, 1, 1, 'normal', '2026-05-23', '18:01:09.432902', 'finalizada', 'Registrado desde web', '2026-05-23', '21:15:39.683242', 'fotos/visita_2_1779580869.png', '1212122', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (55, 1, 1, 7, 1, 'QR', '2026-05-23', '18:08:31.545911', 'finalizada', 'preuba', '2026-05-23', '21:15:44.472081', NULL, '888', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (56, 1, 1, 7, 1, 'QR', '2026-05-23', '18:08:46.945229', 'finalizada', 'preuba', '2026-05-23', '22:12:40.151058', NULL, '888', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (57, 3, 2, 5, 1, 'normal', '2026-05-23', '20:57:03.082544', 'finalizada', 'Registrado desde web', '2026-05-24', '08:52:55.673118', 'fotos/visita_3_1779591423.png', 'sdsdsddadasdasd', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (58, 5, 1, 7, 1, 'QR', '2026-05-23', '21:00:44.528341', 'finalizada', 'dejar un paquete ', '2026-05-26', '22:57:54.916723', NULL, '22', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (59, 5, 1, 7, 1, 'QR', '2026-05-23', '21:01:33.628626', 'finalizada', 'dejar un paquete ', '2026-05-26', '23:45:19.962164', NULL, '22', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (62, 3, 1, 7, 1, 'QR', '2026-05-26', '23:02:53.919216', 'finalizada', 'dejar un paquete', '2026-05-26', '23:57:19.237125', NULL, 'SDASD', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (63, 1, 12, 5, 1, 'normal', '2026-05-26', '23:52:09.563312', 'finalizada', 'Registrado desde web', '2026-05-26', '23:57:21.475936', NULL, 'P123ABC', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (66, 3, 12, 5, 1, 'normal', '2026-05-27', '22:01:04.242431', 'activa', 'Registrado desde web', NULL, NULL, 'fotos/visita_3_1779940864.png', 'P123ABC', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (67, 2, 1, 7, 1, 'QR', '2026-05-27', '22:07:37.545859', 'activa', 'repartidor ', NULL, NULL, NULL, '3BHT57K', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (64, 1, 12, 5, 1, 'normal', '2026-05-26', '23:52:28.973459', 'finalizada', 'Registrado desde web', '2026-05-27', '22:07:46.840692', 'fotos/visita_1_1779861148.png', NULL, 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (68, 1, 1, 7, 1, 'normal', '2026-05-27', '22:15:28.637205', 'finalizada', 'Registrado desde web', '2026-05-27', '22:29:58.327242', 'fotos/visita_1_1779941728.png', 'P123ABC', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (65, 2, 12, 5, 1, 'normal', '2026-05-26', '23:52:53.139662', 'finalizada', 'Registrado desde web', '2026-05-27', '22:30:00.697889', 'fotos/visita_2_1779861173.png', 'P123ABC', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (69, 12, 1, 7, 1, 'QR', '2026-05-27', '22:30:19.820865', 'activa', 'sdsdas', NULL, NULL, NULL, '22', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (70, 1, 2, 5, 1, 'normal', '2026-05-27', '23:13:42.112386', 'finalizada', 'visita de un amigo', '2026-05-27', '23:13:55.687622', 'fotos/visita_1_1779945222.png', 'P123', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (71, 1, 12, 5, 1, 'normal', '2026-05-27', '23:43:57.857308', 'finalizada', 'visita amigo', '2026-05-27', '23:44:38.596353', 'fotos/visita_1_1779947037.png', 'P123ABC', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (72, 11, 12, 5, 1, 'normal', '2026-06-06', '21:19:34.463107', 'activa', 'repartidor', NULL, NULL, NULL, 'P123ABC', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (73, 7, 12, 5, 1, 'normal', '2026-06-06', '21:27:22.78959', 'activa', 'repartidor de forza', NULL, NULL, NULL, 'P123ABC', 'pendiente_vecino', NULL);
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (61, 11, 11, 1, 1, 'QR', '2026-05-24', '20:29:49.282609', 'finalizada', 'visita familiar', '2026-05-26', '23:57:17.184672', NULL, 'P123ABC', 'autorizada', '2026-06-06 21:52:02.699084');
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (75, 6, 20, 10, 1, 'normal', '2026-06-06', '22:22:06.748418', 'activa', 'REPARTIDOR', NULL, NULL, NULL, 'P123ABC', 'rechazada', '2026-06-06 22:22:37.491989');
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (74, 11, 20, 10, 1, 'normal', '2026-06-06', '22:12:51.74126', 'finalizada', 'FAMILIA', '2026-06-06', '23:20:08.898716', NULL, 'P123ABC', 'autorizada', '2026-06-06 22:14:12.803888');
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (76, 2, 20, 10, 1, 'normal', '2026-06-06', '23:20:41.242113', 'activa', 'Registrado desde web', NULL, NULL, NULL, 'P123ABC', 'rechazada', '2026-06-06 23:22:15.99281');
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (78, 12, 1, 7, 1, 'QR', '2026-06-07', '07:23:14.623915', 'activa', 'dejar un paquete', NULL, NULL, NULL, '22', 'autorizada', '2026-06-07 07:23:14.623915');
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (77, 11, 20, 10, 1, 'normal', '2026-06-06', '23:21:51.798832', 'finalizada', 'ENTREGA', '2026-06-07', '07:19:32.410141', NULL, 'P123ABC', 'rechazada', '2026-06-07 07:32:51.922906');
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (79, 3, 20, 10, 1, 'normal', '2026-06-07', '07:30:04.492127', 'finalizada', 'FAMILIAR', '2026-06-07', '07:33:16.134212', 'fotos/visita_3_1780839004.png', 'P123ABC', 'autorizada', '2026-06-07 07:32:48.452654');
INSERT INTO public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa, estado_autorizacion_vecino, fecha_respuesta_vecino) VALUES (80, 1, 1, 7, 1, 'QR', '2026-06-07', '07:35:39.330717', 'activa', 'familia', NULL, NULL, NULL, 'P123ABC', 'autorizada', '2026-06-07 07:35:39.330717');


--
-- TOC entry 4990 (class 0 OID 57495)
-- Dependencies: 222
-- Data for Name: viviendas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) VALUES (4, 'casa 2', 'Sector B', '4 avenida', false, '2026-05-22 20:25:10.492979');
INSERT INTO public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) VALUES (5, 'casa 10', 'sector a', 'ULTIMO DE CAUADRA', true, '2026-05-22 20:37:13.811379');
INSERT INTO public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) VALUES (6, 'casa 5', 'sector z', '23', true, '2026-05-22 21:55:28.718632');
INSERT INTO public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) VALUES (7, 'casa 11', 'sector c', 'final de la cuadra', true, '2026-05-22 22:21:58.077095');
INSERT INTO public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) VALUES (8, 'casa 22', 'sector h', 'medio de todo', true, '2026-05-23 16:36:14.909967');
INSERT INTO public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) VALUES (2, 'Casa 2', 'Sector A', 'Cerca de la entrada', false, '2026-05-13 23:45:15.203207');
INSERT INTO public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) VALUES (9, 'casa 43', 'Sector A', 'orilla del muro', true, '2026-05-23 18:03:57.958886');
INSERT INTO public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) VALUES (10, 'casas 99', 'sector f', '5 piso', true, '2026-05-23 20:58:31.776008');
INSERT INTO public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) VALUES (3, 'A-101', 'A', 'Entrada principal', false, '2026-05-22 19:52:39.6559');
INSERT INTO public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) VALUES (1, 'Casa 1', 'Sector A', 'Frente al parque actualizado', true, '2026-05-13 23:45:15.203207');


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 231
-- Name: prerregistros_id_prerregistro_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prerregistros_id_prerregistro_seq', 80, true);


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 217
-- Name: roles_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_rol_seq', 3, true);


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuarios_id_usuarios_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuarios_seq', 4, true);


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 223
-- Name: vecinos_id_vecino_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vecinos_id_vecino_seq', 21, true);


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 229
-- Name: vehiculos_id_vehiculo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehiculos_id_vehiculo_seq', 1, true);


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 225
-- Name: visitantes_id_visitantes_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visitantes_id_visitantes_seq', 12, true);


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 227
-- Name: visitas_id_visita_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visitas_id_visita_seq', 80, true);


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 221
-- Name: viviendas_id_vivienda_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.viviendas_id_vivienda_seq', 10, true);


--
-- TOC entry 4828 (class 2606 OID 65787)
-- Name: prerregistros prerregistros_codigo_qr_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerregistros
    ADD CONSTRAINT prerregistros_codigo_qr_key UNIQUE (codigo_qr);


--
-- TOC entry 4830 (class 2606 OID 65785)
-- Name: prerregistros prerregistros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerregistros
    ADD CONSTRAINT prerregistros_pkey PRIMARY KEY (id_prerregistro);


--
-- TOC entry 4802 (class 2606 OID 57473)
-- Name: roles roles_nombre_rol_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_rol_key UNIQUE (nombre_rol);


--
-- TOC entry 4804 (class 2606 OID 57471)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_rol);


--
-- TOC entry 4806 (class 2606 OID 57488)
-- Name: usuarios usuarios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);


--
-- TOC entry 4808 (class 2606 OID 57486)
-- Name: usuarios usuarios_nombre_usuario_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_nombre_usuario_key UNIQUE (nombre_usuario);


--
-- TOC entry 4810 (class 2606 OID 57484)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuarios);


--
-- TOC entry 4814 (class 2606 OID 57515)
-- Name: vecinos vecinos_codigo_unico_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos
    ADD CONSTRAINT vecinos_codigo_unico_key UNIQUE (codigo_unico);


--
-- TOC entry 4816 (class 2606 OID 57513)
-- Name: vecinos vecinos_dpi_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos
    ADD CONSTRAINT vecinos_dpi_key UNIQUE (dpi);


--
-- TOC entry 4818 (class 2606 OID 57511)
-- Name: vecinos vecinos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos
    ADD CONSTRAINT vecinos_pkey PRIMARY KEY (id_vecino);


--
-- TOC entry 4824 (class 2606 OID 65767)
-- Name: vehiculos vehiculos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehiculos
    ADD CONSTRAINT vehiculos_pkey PRIMARY KEY (id_vehiculo);


--
-- TOC entry 4826 (class 2606 OID 65769)
-- Name: vehiculos vehiculos_placa_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehiculos
    ADD CONSTRAINT vehiculos_placa_key UNIQUE (placa);


--
-- TOC entry 4820 (class 2606 OID 57535)
-- Name: visitantes visitantes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitantes
    ADD CONSTRAINT visitantes_pkey PRIMARY KEY (id_visitantes);


--
-- TOC entry 4822 (class 2606 OID 57545)
-- Name: visitas visitas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas
    ADD CONSTRAINT visitas_pkey PRIMARY KEY (id_visita);


--
-- TOC entry 4812 (class 2606 OID 57502)
-- Name: viviendas viviendas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viviendas
    ADD CONSTRAINT viviendas_pkey PRIMARY KEY (id_vivienda);


--
-- TOC entry 4839 (class 2606 OID 65788)
-- Name: prerregistros fk_prerregistro_vecino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerregistros
    ADD CONSTRAINT fk_prerregistro_vecino FOREIGN KEY (id_vecino) REFERENCES public.vecinos(id_vecino);


--
-- TOC entry 4838 (class 2606 OID 65770)
-- Name: vehiculos fk_vehiculo_vecino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehiculos
    ADD CONSTRAINT fk_vehiculo_vecino FOREIGN KEY (id_vecino) REFERENCES public.vecinos(id_vecino);


--
-- TOC entry 4831 (class 2606 OID 57489)
-- Name: usuarios usuarios_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.roles(id_rol);


--
-- TOC entry 4832 (class 2606 OID 57516)
-- Name: vecinos vecinos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos
    ADD CONSTRAINT vecinos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuarios);


--
-- TOC entry 4833 (class 2606 OID 57521)
-- Name: vecinos vecinos_id_vivienda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos
    ADD CONSTRAINT vecinos_id_vivienda_fkey FOREIGN KEY (id_vivienda) REFERENCES public.viviendas(id_vivienda);


--
-- TOC entry 4834 (class 2606 OID 57561)
-- Name: visitas visitas_id_usuario_agente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas
    ADD CONSTRAINT visitas_id_usuario_agente_fkey FOREIGN KEY (id_usuario_agente) REFERENCES public.usuarios(id_usuarios);


--
-- TOC entry 4835 (class 2606 OID 57551)
-- Name: visitas visitas_id_vecino_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas
    ADD CONSTRAINT visitas_id_vecino_fkey FOREIGN KEY (id_vecino) REFERENCES public.vecinos(id_vecino);


--
-- TOC entry 4836 (class 2606 OID 57546)
-- Name: visitas visitas_id_visitante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas
    ADD CONSTRAINT visitas_id_visitante_fkey FOREIGN KEY (id_visitante) REFERENCES public.visitantes(id_visitantes);


--
-- TOC entry 4837 (class 2606 OID 57556)
-- Name: visitas visitas_id_vivienda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas
    ADD CONSTRAINT visitas_id_vivienda_fkey FOREIGN KEY (id_vivienda) REFERENCES public.viviendas(id_vivienda);


-- Completed on 2026-06-07 08:36:53

--
-- PostgreSQL database dump complete
--

\unrestrict 0A3dZEfrgAzDkG2kwXa9I9ZfiyF7Cd2sSwadnIMLGiM3YbE7cxfsD4ZbFbeopYE


--
-- PostgreSQL database dump
--

\restrict c5zepXozXt4LpUfCTThwF4Q6yv3fgr6PPjBbBtjZF9Xg11wRk1isGGZDzQe1a6d

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2026-05-28 00:14:59

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
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
-- TOC entry 5003 (class 0 OID 0)
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
-- TOC entry 5004 (class 0 OID 0)
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
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
-- TOC entry 5005 (class 0 OID 0)
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
-- TOC entry 5006 (class 0 OID 0)
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
-- TOC entry 5007 (class 0 OID 0)
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
-- TOC entry 5008 (class 0 OID 0)
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
    placa character varying(20)
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
-- TOC entry 5009 (class 0 OID 0)
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
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 221
-- Name: viviendas_id_vivienda_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.viviendas_id_vivienda_seq OWNED BY public.viviendas.id_vivienda;


--
-- TOC entry 4795 (class 2604 OID 65779)
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
-- TOC entry 4785 (class 2604 OID 57507)
-- Name: vecinos id_vecino; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos ALTER COLUMN id_vecino SET DEFAULT nextval('public.vecinos_id_vecino_seq'::regclass);


--
-- TOC entry 4792 (class 2604 OID 65763)
-- Name: vehiculos id_vehiculo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehiculos ALTER COLUMN id_vehiculo SET DEFAULT nextval('public.vehiculos_id_vehiculo_seq'::regclass);


--
-- TOC entry 4788 (class 2604 OID 57530)
-- Name: visitantes id_visitantes; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitantes ALTER COLUMN id_visitantes SET DEFAULT nextval('public.visitantes_id_visitantes_seq'::regclass);


--
-- TOC entry 4790 (class 2604 OID 57540)
-- Name: visitas id_visita; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas ALTER COLUMN id_visita SET DEFAULT nextval('public.visitas_id_visita_seq'::regclass);


--
-- TOC entry 4782 (class 2604 OID 57498)
-- Name: viviendas id_vivienda; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viviendas ALTER COLUMN id_vivienda SET DEFAULT nextval('public.viviendas_id_vivienda_seq'::regclass);


--
-- TOC entry 4997 (class 0 OID 65776)
-- Dependencies: 232
-- Data for Name: prerregistros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prerregistros (id_prerregistro, id_vecino, nombre_visitante, dpi_visitante, telefono_visitante, correo_visitante, placa, motivo, fecha_visita, hora_visita, codigo_qr, estado_qr, fecha_creacion) FROM stdin;
3	1	Pedro Lopez	123	\N	\N	P12C	Visita familiar	2026-05-16	23:17:39.423861	fb593bb2-cae5-4c3b-971e-223829df08ac	pendiente	2026-05-16 23:17:39.423861
4	1	Mario	11111	\N	\N	3BHT57K	visita familiar 	2026-05-16	23:21:37.880645	424b2a07-6b3d-450a-a784-7f3a148f5c80	pendiente	2026-05-16 23:21:37.880645
5	1	ivan	444	\N	\N	12RTG3	repartidor 	2026-05-16	23:27:16.083272	0eb1219c-9f2d-4cff-8b57-c9465dfd6ab4	pendiente	2026-05-16 23:27:16.083272
6	1	Mario	11111	\N	\N	3BHT57K	visita familiar 	2026-05-16	23:35:20.970495	0a94c3c6-c93d-4153-8446-86a23d423381	pendiente	2026-05-16 23:35:20.970495
7	1	Mario	11111	\N	mario@gmail.com	3BHT57K	visita familiar 	2026-05-16	23:41:35.003698	304228fe-8811-4e87-ae87-8d6b10d57b3f	pendiente	2026-05-16 23:41:35.003698
8	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:01:38.322694	a6ea42d6-fb26-41b7-a190-a75f78de9b07	pendiente	2026-05-17 00:01:38.322694
9	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:01:40.577633	c5291c1d-301c-4ccf-8bda-d1352059d043	pendiente	2026-05-17 00:01:40.577633
10	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:01:41.145182	c3e569cc-42d0-4913-8aea-1424a1b60b06	pendiente	2026-05-17 00:01:41.145182
11	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:01:41.343268	6b73e1b8-3f43-4ade-ab98-f4d3999b3711	pendiente	2026-05-17 00:01:41.343268
12	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:01:41.540599	8f8a746d-c0be-4da4-bb9a-0f11d0e1a416	pendiente	2026-05-17 00:01:41.540599
13	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:01:49.743305	cdbb070c-903b-4ed8-8b33-f63525a1e7be	pendiente	2026-05-17 00:01:49.743305
14	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:02:53.094867	a6b43510-381b-4f88-a450-1f734ee65703	pendiente	2026-05-17 00:02:53.094867
15	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:02:53.307118	28adcb02-a237-414b-93f5-57fc27667748	pendiente	2026-05-17 00:02:53.307118
16	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:02:53.515949	6be207cc-f0a5-4e77-b690-5c30ce1c99c3	pendiente	2026-05-17 00:02:53.515949
17	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:02:53.684943	d9025307-86c1-4408-bd8a-7c4569db195b	pendiente	2026-05-17 00:02:53.684943
18	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:06:12.810935	a705c241-8708-4f82-af73-a9952b3dff61	pendiente	2026-05-17 00:06:12.810935
19	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:06:13.685804	91154c0d-c50d-4449-a8d3-5705dfa666be	pendiente	2026-05-17 00:06:13.685804
20	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:06:13.878655	28ab4a89-8d2a-4601-a997-99b3a7e55e4a	pendiente	2026-05-17 00:06:13.878655
21	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:06:14.067534	93c59ac5-d58f-4c50-9d5d-02d69bd68714	pendiente	2026-05-17 00:06:14.067534
22	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:06:14.23495	8d036b8a-98f6-4267-b144-f140b87a0bdb	pendiente	2026-05-17 00:06:14.23495
23	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:06:14.414748	f10acb8f-731a-473c-a520-e9f3ea8be7aa	pendiente	2026-05-17 00:06:14.414748
24	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:13:45.788563	ef4c2fe7-5788-4a26-92c7-021900781beb	pendiente	2026-05-17 00:13:45.788563
25	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:13:47.079515	93f6cc5c-5378-4c44-8029-a68ae4695296	pendiente	2026-05-17 00:13:47.079515
26	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:14:30.867037	f7619dbb-ff81-43cb-b670-c0b6e7d0e7af	pendiente	2026-05-17 00:14:30.867037
27	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:14:32.745456	acbfb173-ffd4-4735-9ded-7f61a3d57ad9	pendiente	2026-05-17 00:14:32.745456
28	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:14:32.936089	7280c87b-7ae5-4c01-a85a-f7f79d786f69	pendiente	2026-05-17 00:14:32.936089
29	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:14:33.118198	39f42eb3-7e3c-41cf-bc98-aab22979316c	pendiente	2026-05-17 00:14:33.118198
30	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:14:33.296255	a4a32354-66b0-412b-9c47-e40e6255160f	pendiente	2026-05-17 00:14:33.296255
31	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:14:33.476492	a409f65e-d761-44ff-99c5-b3cb71c4a0d6	pendiente	2026-05-17 00:14:33.476492
32	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:16:02.24431	cff4e63f-551f-49d5-96ad-05f06bca4cf1	pendiente	2026-05-17 00:16:02.24431
33	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	00:17:54.994192	13c86ce9-d151-4b5e-ab64-37e63d41e549	pendiente	2026-05-17 00:17:54.994192
34	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-17	08:57:40.119559	fafb9fa7-9135-4d59-9134-9a2d0319710a	pendiente	2026-05-17 08:57:40.119559
35	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-18	22:22:50.130361	b1d51f9a-8c02-4595-aa5b-6f7dfc7676dc	pendiente	2026-05-18 22:22:50.130361
36	1	garita 	112222	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-18	22:22:52.86475	ac78b092-0464-4c63-8e15-05af41cb7ed5	usado	2026-05-18 22:22:52.86475
37	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:22:55.768314	c391708f-5d8e-4469-8633-2bee284887f9	pendiente	2026-05-21 17:22:55.768314
38	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:22:58.271886	5d3302f6-59f8-4dcf-b98a-7975616f508f	pendiente	2026-05-21 17:22:58.271886
39	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:22:58.686127	a42e9121-749f-4c20-8384-283d7485e4be	pendiente	2026-05-21 17:22:58.686127
40	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:22:58.892722	75f4d0f8-db71-41bc-95b9-2ef8558005b5	pendiente	2026-05-21 17:22:58.892722
42	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:22:59.284068	1b325c1f-5bde-4c6a-80f6-106f50fd0684	pendiente	2026-05-21 17:22:59.284068
43	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:40:08.47786	dbc48896-eedd-4bea-8d68-f37218491227	pendiente	2026-05-21 17:40:08.47786
44	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:40:08.889961	ca5d0479-b008-4304-9496-b0793d78dbab	pendiente	2026-05-21 17:40:08.889961
45	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:40:09.140377	5315a503-16cd-4795-986a-687fdec822d0	pendiente	2026-05-21 17:40:09.140377
46	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:40:09.305175	0632b2e8-e6dd-48bf-bcbe-0c932d182ec2	pendiente	2026-05-21 17:40:09.305175
47	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:41:54.325211	750fb051-352f-4716-b389-9ca4da6d5287	pendiente	2026-05-21 17:41:54.325211
48	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:54:39.595289	a0751bc4-8072-4dde-808f-5e23bd253222	pendiente	2026-05-21 17:54:39.595289
41	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:22:59.082861	96159cbe-2f35-4cf7-8383-73c4ebff5e34	usado	2026-05-21 17:22:59.082861
51	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	18:11:44.286098	5cec8836-8211-4c5d-8b6e-98fea280ab82	usado	2026-05-21 18:11:44.286098
52	1	erick	6666	\N	garitas041@gmail.com	1212122	dejar un paquete 	2026-05-22	12:25:40.136073	a5ec8218-759b-4735-b7ed-accddd6ca4f2	usado	2026-05-22 12:25:40.136073
53	1	carlos 	5555	\N	garitas041@gmail.com	888	prueba 	2026-05-22	13:42:46.00636	2c1eb2ba-73ff-4ad1-91f8-bb578c87bd39	pendiente	2026-05-22 13:42:46.00636
54	1	carlos 	5555	\N	garitas041@gmail.com	888	prueba 	2026-05-22	13:43:04.208086	7799f5cd-65a9-4e5b-8718-00a5672a0a3a	pendiente	2026-05-22 13:43:04.208086
55	1	carlos 	5555	\N	garitas041@gmail.com	888	prueba 	2026-05-22	13:45:43.968746	e6f9b9c9-b897-4459-940d-881c8c566794	pendiente	2026-05-22 13:45:43.968746
56	1	Carlos 	1111	\N	garitas041@gmail.com	888	preuba	2026-05-22	13:46:04.929539	47bb0090-6c2b-427f-97b0-72c7d1036a4b	usado	2026-05-22 13:46:04.929539
49	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	17:59:45.902264	518c2a06-1a07-4de4-b8e7-0039b5c0ce6f	usado	2026-05-21 17:59:45.902264
57	1	erick	6666	\N	garitas041@gmail.com	SDADASDAS	preuba	2026-05-22	21:52:50.385277	d96e3201-847a-4a3f-a04b-9f43615815c0	usado	2026-05-22 21:52:50.385277
58	1	erick	6666	\N	garitas041@gmail.com	SDADASDAS	preuba	2026-05-22	21:53:43.200096	ec025c6f-4bc8-4ea3-b4b4-e6ff7af038e0	usado	2026-05-22 21:53:43.200096
59	1	pedor suya 	1111	\N	garitas041@gmail.com	22	familia 	2026-05-22	22:29:29.474429	d398680b-a108-4849-9996-7bf76a193e3f	usado	2026-05-22 22:29:29.474429
60	1	pedor suya 	1111	\N	garitas041@gmail.com	22	familia 	2026-05-22	22:29:58.304108	ae937a00-e6e9-436a-87d8-16b495ae84db	usado	2026-05-22 22:29:58.304108
50	1	garita 	4444444	\N	garitas041@gmail.com	3BHT57K	repartidor 	2026-05-21	18:08:30.994047	8a8ed040-ee20-409e-a2fe-f6a7cb2485f4	usado	2026-05-21 18:08:30.994047
61	1	Carlos 	sdada	\N	garitas041@gmail.com	888	preuba	2026-05-23	18:07:39.161701	6c923949-1264-4668-9b42-19e79739e27d	pendiente	2026-05-23 18:07:39.161701
62	1	Carlos 	sdada	\N	garitas041@gmail.com	888	preuba	2026-05-23	18:07:41.108811	30176352-e1f9-43d1-ba17-72b3271cbba8	pendiente	2026-05-23 18:07:41.108811
63	1	Carlos 	sdada	\N	garitas041@gmail.com	888	preuba	2026-05-23	18:07:42.352223	0c738b19-3ca4-4eae-a1e4-a9967fabc5df	pendiente	2026-05-23 18:07:42.352223
64	1	Carlos 	sdada	\N	garitas041@gmail.com	888	preuba	2026-05-23	18:07:42.52714	00555115-82b8-4154-9c68-371da16fc977	pendiente	2026-05-23 18:07:42.52714
65	1	Carlos 	sdada	\N	garitas041@gmail.com	888	preuba	2026-05-23	18:07:42.731523	c23248a8-11bf-4f4f-95ba-a93724c8cfb5	pendiente	2026-05-23 18:07:42.731523
66	1	Carlos 	sdada	\N	garitas041@gmail.com	888	preuba	2026-05-23	18:07:42.904073	95cfdabd-eaf2-4e9a-b66e-abae2744ce62	usado	2026-05-23 18:07:42.904073
67	1	Carlos 	sdada	\N	garitas041@gmail.com	888	preuba	2026-05-23	18:08:19.772761	533ad35f-82c5-458e-a6c8-f507536b6f71	usado	2026-05-23 18:08:19.772761
68	1	pedro	6666	\N	garitas041@gmail.com	22	dejar un paquete 	2026-05-23	21:00:21.369067	cf98a79c-488d-4e98-bd34-5824c2d43924	pendiente	2026-05-23 21:00:21.369067
69	1	pedro	6666	\N	garitas041@gmail.com	22	dejar un paquete 	2026-05-23	21:00:25.834886	cd247c51-b6b2-45ff-b092-d81272998e15	usado	2026-05-23 21:00:25.834886
70	1	pedro	6666	\N	garitas041@gmail.com	22	dejar un paquete 	2026-05-23	21:00:33.586819	501f2b1d-ee95-4d6f-9d61-beef92cf69f6	usado	2026-05-23 21:00:33.586819
71	11	Carlos Lopez	1234567890101	\N	\N	P123ABC	Visita familiar	2026-05-24	19:55:36.724286	12258c34-a57c-450c-802a-32db66c66cd5	pendiente	2026-05-24 19:55:36.724286
72	11	Carlos Lopez	1234567890101	\N	\N	P123ABC	visita familiar	2026-05-24	20:19:23.388904	43c04423-13a3-4080-b0fb-8cbb8ea47cd5	pendiente	2026-05-24 20:19:23.388904
73	11	Carlos Lopez	1234567890101	\N	\N	P123ABC	visita familiar	2026-05-24	20:25:13.291797	8babd5e0-e1ad-432c-a9bf-488645e0657a	usado	2026-05-24 20:25:13.291797
75	1	erick	sdada	\N	jelsonxlntres@gmail.com	SDADASDAS	dejar un paquete	2026-05-26	23:02:15.218981	371ab581-45ff-4e34-be32-af01ac2919a3	pendiente	2026-05-26 23:02:15.218981
74	1	erick	1111	\N	jelsonxlntres@gmail.com	SDASD	dejar un paquete	2026-05-26	22:59:41.967895	4aa7eda5-f9e9-48bd-91a0-04c4aff518dd	usado	2026-05-26 22:59:41.967895
76	1	dasdasd	1111	\N	jelsonxlntres@gmail.com	22	sdsdas	2026-05-27	21:32:48.881693	46691b9a-eb8a-4f20-9cc4-c3fe5450e600	usado	2026-05-27 21:32:48.881693
\.


--
-- TOC entry 4983 (class 0 OID 57465)
-- Dependencies: 218
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id_rol, nombre_rol, descripcion, estado) FROM stdin;
1	Administrador	Control total del sistema	t
2	Agente	Encargado de registrar visitas	t
3	Vecino	Residente de la vivienda	t
\.


--
-- TOC entry 4985 (class 0 OID 57475)
-- Dependencies: 220
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id_usuarios, nombre_usuario, correo, contrasena_hash, id_rol, estado, fecha_creacion) FROM stdin;
1	admin	admin@garita.com	1234	1	t	2026-05-13 23:45:15.203207
2	vecino1	vecino1@gmail.com	1234	3	t	2026-05-24 19:36:36.892289
\.


--
-- TOC entry 4989 (class 0 OID 57504)
-- Dependencies: 224
-- Data for Name: vecinos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vecinos (id_vecino, id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico, estado, fecha_registro) FROM stdin;
2	1	5	jose	lopez	888	44444	joselopez@gmail.com	VEC-0002	t	2026-05-16 15:35:07.046136
12	\N	5	Jelson	Sicay	00000	33583642	jelson@gmail.com	VEC-0012	t	2026-05-22 20:42:53.822055
14	\N	6	mario	lopez	\N	12343532	mario@gmail.com	VEC-0013	f	2026-05-22 22:15:09.604693
4	1	1	jose	lopez	111111	55555	joselopez@gmail.com	VEC-0003	t	2026-05-16 15:38:56.924521
15	1	1	Prueba	JWT	1234567890101	55550000	prueba.jwt@gmail.com	VEC-0015	t	2026-05-23 14:51:38.007363
17	\N	6	ema	suya	\N	8745656	ema@gmail.com	VEC-0016	f	2026-05-23 15:00:19.567671
18	\N	6	edson	lopez	\N	867867	edson@gmail.com	VEC-0018	t	2026-05-23 18:02:46.998218
19	\N	3	gerson	suya	\N	999	gerson@gmail.com	VEC-0019	t	2026-05-23 20:59:24.585161
11	2	1	pedro	sanches	5678	33583642	pedrosanchez@gmail.com	VEC-0009	t	2026-05-22 16:56:02.451964
1	1	7	Juan luis	Perez lopez	\N	55554444	juan@gmail.com	CASA1-ABC	t	2026-05-13 23:45:15.203207
8	1	1	jose	lopez	1111	555	joselopez@gmail.com	VEC-0005	t	2026-05-16 16:04:05.901794
\.


--
-- TOC entry 4995 (class 0 OID 65760)
-- Dependencies: 230
-- Data for Name: vehiculos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehiculos (id_vehiculo, id_vecino, placa, marca, color, modelo, autorizado, fecha_registro) FROM stdin;
1	1	P123ABC	Toyota	Negro	Corolla	t	2026-05-16 21:21:15.456374
\.


--
-- TOC entry 4991 (class 0 OID 57527)
-- Dependencies: 226
-- Data for Name: visitantes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visitantes (id_visitantes, nombres, apellidos, tipo_documento, numero_documento, telefono, observaciones, fecha_registro, dpi_licencia) FROM stdin;
2	garita 		\N	\N		\N	2026-05-21 18:12:02.328836	\N
4	hector 	sanches	\N	\N	\N	\N	2026-05-22 17:31:05.588091	\N
3	erick	PEREZ	\N	\N		\N	2026-05-22 12:26:46.512777	\N
5	pedro	SUYA 	\N	\N	\N	\N	2026-05-22 22:11:38.056067	\N
6	pedor suya 		\N	\N		\N	2026-05-22 22:29:47.063825	\N
7	ema 	choc	\N	\N	\N	\N	2026-05-23 17:31:39.859507	\N
8	jairo	xd	\N	\N	\N	\N	2026-05-23 17:45:09.185028	\N
9	hector 	dsasda	\N	\N	\N	\N	2026-05-23 18:03:13.349934	\N
10	antony 	perez	\N	\N	\N	\N	2026-05-23 20:59:56.027946	\N
11	Carlos Lopez		\N	\N		\N	2026-05-24 20:29:49.282609	\N
12	dasdasd		\N	\N		\N	2026-05-27 22:30:19.820865	\N
1	Carlos	Méndez	DPI	1234567890101	55550000	\N	2026-05-13 23:45:15.203207	2231323
\.


--
-- TOC entry 4993 (class 0 OID 57537)
-- Dependencies: 228
-- Data for Name: visitas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visitas (id_visita, id_visitante, id_vecino, id_vivienda, id_usuario_agente, tipo_ingreso, fecha_ingreso, hora_ingreso, estado_visita, observaciones, fecha_salida, hora_salida, foto, placa) FROM stdin;
1	1	1	1	1	normal	2026-05-14	00:47:10.835932	finalizada	Registrado desde web	2026-05-16	14:25:56.84468	fotos/visita_1_1778741230.png	1sthy4
2	1	1	1	1	normal	2026-05-16	14:23:25.262562	finalizada	Registrado desde web	2026-05-16	14:26:00.832364	fotos/visita_1_1778963005.png	SDADASDAS
3	1	1	1	1	normal	2026-05-16	15:07:02.253509	finalizada	Registrado desde web	2026-05-16	15:07:24.254475	\N	4TFDGSR
4	1	2	1	1	normal	2026-05-16	16:19:25.468762	finalizada	Registrado desde web	2026-05-16	21:49:54.908188	fotos/visita_1_1778969965.png	6788
5	1	1	1	1	normal	2026-05-16	21:48:40.087364	finalizada	Registrado desde web	2026-05-16	21:53:21.950422	\N	P123ABC
6	1	4	1	1	normal	2026-05-16	22:00:12.98579	finalizada	Registrado desde web	2026-05-16	22:00:23.831703	\N	SDADASDAS
7	1	4	1	1	normal	2026-05-17	08:56:33.091262	finalizada	Registrado desde web	2026-05-17	08:56:45.474228	fotos/visita_1_1779029793.png	yhvjhhj
8	1	2	1	1	normal	2026-05-19	00:20:52.000046	finalizada	Registrado desde web	2026-05-22	12:32:40.636164	\N	44533454
41	1	8	1	1	normal	2026-05-21	17:15:20.323032	finalizada	Registrado desde web	2026-05-22	12:39:15.298951	fotos/visita_1_1779405320.png	ghjtrt34545
42	2	1	1	1	QR	2026-05-21	18:12:02.328836	finalizada	repartidor 	2026-05-22	12:40:16.939323	\N	3BHT57K
43	3	1	1	1	QR	2026-05-22	12:26:46.512777	finalizada	dejar un paquete 	2026-05-22	14:08:33.39638	\N	1212122
44	1	1	1	1	QR	2026-05-22	13:47:49.821216	finalizada	preuba	2026-05-22	14:08:47.503425	\N	888
45	2	1	1	1	QR	2026-05-22	14:01:48.259381	finalizada	repartidor 	2026-05-22	21:51:58.93754	\N	3BHT57K
46	4	12	5	1	normal	2026-05-22	21:51:49.023105	finalizada	Registrado desde web	2026-05-22	21:54:11.941291	fotos/visita_4_1779508308.png	sdasd
48	3	1	2	1	QR	2026-05-22	21:54:04.967258	finalizada	preuba	2026-05-22	21:54:17.920806	\N	SDADASDAS
47	3	1	2	1	QR	2026-05-22	21:53:33.551347	finalizada	preuba	2026-05-22	23:20:18.61389	\N	SDADASDAS
49	5	14	6	1	normal	2026-05-22	22:28:50.735001	finalizada	Registrado desde web	2026-05-22	23:22:44.589369	fotos/visita_5_1779510530.png	SAASADDAD
50	6	1	7	1	QR	2026-05-22	22:29:47.063825	finalizada	familia 	2026-05-23	17:51:30.948424	\N	22
51	6	1	7	1	QR	2026-05-22	22:30:24.368505	finalizada	familia 	2026-05-23	17:54:50.448111	\N	22
53	2	4	1	1	normal	2026-05-23	17:52:56.343825	finalizada	Registrado desde web	2026-05-23	17:54:51.423735	fotos/visita_2_1779580376.png	22
52	2	1	7	1	QR	2026-05-22	23:07:56.251695	finalizada	repartidor 	2026-05-23	21:15:36.369716	\N	3BHT57K
54	2	15	1	1	normal	2026-05-23	18:01:09.432902	finalizada	Registrado desde web	2026-05-23	21:15:39.683242	fotos/visita_2_1779580869.png	1212122
55	1	1	7	1	QR	2026-05-23	18:08:31.545911	finalizada	preuba	2026-05-23	21:15:44.472081	\N	888
56	1	1	7	1	QR	2026-05-23	18:08:46.945229	finalizada	preuba	2026-05-23	22:12:40.151058	\N	888
57	3	2	5	1	normal	2026-05-23	20:57:03.082544	finalizada	Registrado desde web	2026-05-24	08:52:55.673118	fotos/visita_3_1779591423.png	sdsdsddadasdasd
58	5	1	7	1	QR	2026-05-23	21:00:44.528341	finalizada	dejar un paquete 	2026-05-26	22:57:54.916723	\N	22
59	5	1	7	1	QR	2026-05-23	21:01:33.628626	finalizada	dejar un paquete 	2026-05-26	23:45:19.962164	\N	22
61	11	11	1	1	QR	2026-05-24	20:29:49.282609	finalizada	visita familiar	2026-05-26	23:57:17.184672	\N	P123ABC
62	3	1	7	1	QR	2026-05-26	23:02:53.919216	finalizada	dejar un paquete	2026-05-26	23:57:19.237125	\N	SDASD
63	1	12	5	1	normal	2026-05-26	23:52:09.563312	finalizada	Registrado desde web	2026-05-26	23:57:21.475936	\N	P123ABC
66	3	12	5	1	normal	2026-05-27	22:01:04.242431	activa	Registrado desde web	\N	\N	fotos/visita_3_1779940864.png	P123ABC
67	2	1	7	1	QR	2026-05-27	22:07:37.545859	activa	repartidor 	\N	\N	\N	3BHT57K
64	1	12	5	1	normal	2026-05-26	23:52:28.973459	finalizada	Registrado desde web	2026-05-27	22:07:46.840692	fotos/visita_1_1779861148.png	\N
68	1	1	7	1	normal	2026-05-27	22:15:28.637205	finalizada	Registrado desde web	2026-05-27	22:29:58.327242	fotos/visita_1_1779941728.png	P123ABC
65	2	12	5	1	normal	2026-05-26	23:52:53.139662	finalizada	Registrado desde web	2026-05-27	22:30:00.697889	fotos/visita_2_1779861173.png	P123ABC
69	12	1	7	1	QR	2026-05-27	22:30:19.820865	activa	sdsdas	\N	\N	\N	22
70	1	2	5	1	normal	2026-05-27	23:13:42.112386	finalizada	visita de un amigo	2026-05-27	23:13:55.687622	fotos/visita_1_1779945222.png	P123
71	1	12	5	1	normal	2026-05-27	23:43:57.857308	finalizada	visita amigo	2026-05-27	23:44:38.596353	fotos/visita_1_1779947037.png	P123ABC
\.


--
-- TOC entry 4987 (class 0 OID 57495)
-- Dependencies: 222
-- Data for Name: viviendas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.viviendas (id_vivienda, numero_vivienda, sector, direccion_referencia, estado, fecha_registro) FROM stdin;
3	A-101	A	Entrada principal	t	2026-05-22 19:52:39.6559
4	casa 2	Sector B	4 avenida	f	2026-05-22 20:25:10.492979
5	casa 10	sector a	ULTIMO DE CAUADRA	t	2026-05-22 20:37:13.811379
6	casa 5	sector z	23	t	2026-05-22 21:55:28.718632
7	casa 11	sector c	final de la cuadra	t	2026-05-22 22:21:58.077095
8	casa 22	sector h	medio de todo	t	2026-05-23 16:36:14.909967
2	Casa 2	Sector A	Cerca de la entrada	f	2026-05-13 23:45:15.203207
9	casa 43	Sector A	orilla del muro	t	2026-05-23 18:03:57.958886
10	casas 99	sector f	5 piso	t	2026-05-23 20:58:31.776008
1	Casa 1	Sector A	Frente al parque actualizado	f	2026-05-13 23:45:15.203207
\.


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 231
-- Name: prerregistros_id_prerregistro_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prerregistros_id_prerregistro_seq', 76, true);


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 217
-- Name: roles_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_rol_seq', 3, true);


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuarios_id_usuarios_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuarios_seq', 2, true);


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 223
-- Name: vecinos_id_vecino_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vecinos_id_vecino_seq', 19, true);


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 229
-- Name: vehiculos_id_vehiculo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehiculos_id_vehiculo_seq', 1, true);


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 225
-- Name: visitantes_id_visitantes_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visitantes_id_visitantes_seq', 12, true);


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 227
-- Name: visitas_id_visita_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visitas_id_visita_seq', 71, true);


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 221
-- Name: viviendas_id_vivienda_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.viviendas_id_vivienda_seq', 10, true);


--
-- TOC entry 4825 (class 2606 OID 65787)
-- Name: prerregistros prerregistros_codigo_qr_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerregistros
    ADD CONSTRAINT prerregistros_codigo_qr_key UNIQUE (codigo_qr);


--
-- TOC entry 4827 (class 2606 OID 65785)
-- Name: prerregistros prerregistros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerregistros
    ADD CONSTRAINT prerregistros_pkey PRIMARY KEY (id_prerregistro);


--
-- TOC entry 4799 (class 2606 OID 57473)
-- Name: roles roles_nombre_rol_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_rol_key UNIQUE (nombre_rol);


--
-- TOC entry 4801 (class 2606 OID 57471)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_rol);


--
-- TOC entry 4803 (class 2606 OID 57488)
-- Name: usuarios usuarios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);


--
-- TOC entry 4805 (class 2606 OID 57486)
-- Name: usuarios usuarios_nombre_usuario_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_nombre_usuario_key UNIQUE (nombre_usuario);


--
-- TOC entry 4807 (class 2606 OID 57484)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuarios);


--
-- TOC entry 4811 (class 2606 OID 57515)
-- Name: vecinos vecinos_codigo_unico_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos
    ADD CONSTRAINT vecinos_codigo_unico_key UNIQUE (codigo_unico);


--
-- TOC entry 4813 (class 2606 OID 57513)
-- Name: vecinos vecinos_dpi_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos
    ADD CONSTRAINT vecinos_dpi_key UNIQUE (dpi);


--
-- TOC entry 4815 (class 2606 OID 57511)
-- Name: vecinos vecinos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos
    ADD CONSTRAINT vecinos_pkey PRIMARY KEY (id_vecino);


--
-- TOC entry 4821 (class 2606 OID 65767)
-- Name: vehiculos vehiculos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehiculos
    ADD CONSTRAINT vehiculos_pkey PRIMARY KEY (id_vehiculo);


--
-- TOC entry 4823 (class 2606 OID 65769)
-- Name: vehiculos vehiculos_placa_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehiculos
    ADD CONSTRAINT vehiculos_placa_key UNIQUE (placa);


--
-- TOC entry 4817 (class 2606 OID 57535)
-- Name: visitantes visitantes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitantes
    ADD CONSTRAINT visitantes_pkey PRIMARY KEY (id_visitantes);


--
-- TOC entry 4819 (class 2606 OID 57545)
-- Name: visitas visitas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas
    ADD CONSTRAINT visitas_pkey PRIMARY KEY (id_visita);


--
-- TOC entry 4809 (class 2606 OID 57502)
-- Name: viviendas viviendas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viviendas
    ADD CONSTRAINT viviendas_pkey PRIMARY KEY (id_vivienda);


--
-- TOC entry 4836 (class 2606 OID 65788)
-- Name: prerregistros fk_prerregistro_vecino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerregistros
    ADD CONSTRAINT fk_prerregistro_vecino FOREIGN KEY (id_vecino) REFERENCES public.vecinos(id_vecino);


--
-- TOC entry 4835 (class 2606 OID 65770)
-- Name: vehiculos fk_vehiculo_vecino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehiculos
    ADD CONSTRAINT fk_vehiculo_vecino FOREIGN KEY (id_vecino) REFERENCES public.vecinos(id_vecino);


--
-- TOC entry 4828 (class 2606 OID 57489)
-- Name: usuarios usuarios_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.roles(id_rol);


--
-- TOC entry 4829 (class 2606 OID 57516)
-- Name: vecinos vecinos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos
    ADD CONSTRAINT vecinos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuarios);


--
-- TOC entry 4830 (class 2606 OID 57521)
-- Name: vecinos vecinos_id_vivienda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vecinos
    ADD CONSTRAINT vecinos_id_vivienda_fkey FOREIGN KEY (id_vivienda) REFERENCES public.viviendas(id_vivienda);


--
-- TOC entry 4831 (class 2606 OID 57561)
-- Name: visitas visitas_id_usuario_agente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas
    ADD CONSTRAINT visitas_id_usuario_agente_fkey FOREIGN KEY (id_usuario_agente) REFERENCES public.usuarios(id_usuarios);


--
-- TOC entry 4832 (class 2606 OID 57551)
-- Name: visitas visitas_id_vecino_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas
    ADD CONSTRAINT visitas_id_vecino_fkey FOREIGN KEY (id_vecino) REFERENCES public.vecinos(id_vecino);


--
-- TOC entry 4833 (class 2606 OID 57546)
-- Name: visitas visitas_id_visitante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas
    ADD CONSTRAINT visitas_id_visitante_fkey FOREIGN KEY (id_visitante) REFERENCES public.visitantes(id_visitantes);


--
-- TOC entry 4834 (class 2606 OID 57556)
-- Name: visitas visitas_id_vivienda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitas
    ADD CONSTRAINT visitas_id_vivienda_fkey FOREIGN KEY (id_vivienda) REFERENCES public.viviendas(id_vivienda);


-- Completed on 2026-05-28 00:15:00

--
-- PostgreSQL database dump complete
--

\unrestrict c5zepXozXt4LpUfCTThwF4Q6yv3fgr6PPjBbBtjZF9Xg11wRk1isGGZDzQe1a6d


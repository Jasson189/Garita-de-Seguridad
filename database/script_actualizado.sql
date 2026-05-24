--
-- PostgreSQL database dump
--

\restrict fpOgTV4RHh0yTEWzq9I0aBsjoTFmOLL8VTPYkGtXo0jnbqnc3BahpJqTymUehvn

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2026-05-23 21:38:52

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
-- TOC entry 4987 (class 0 OID 0)
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
-- TOC entry 4988 (class 0 OID 0)
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
-- TOC entry 4989 (class 0 OID 0)
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
-- TOC entry 4990 (class 0 OID 0)
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
-- TOC entry 4991 (class 0 OID 0)
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
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
-- TOC entry 4992 (class 0 OID 0)
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
-- TOC entry 4993 (class 0 OID 0)
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
-- TOC entry 4994 (class 0 OID 0)
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


-- Completed on 2026-05-23 21:38:52

--
-- PostgreSQL database dump complete
--

\unrestrict fpOgTV4RHh0yTEWzq9I0aBsjoTFmOLL8VTPYkGtXo0jnbqnc3BahpJqTymUehvn


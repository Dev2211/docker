--To Create the dump file from PG-ADMIN use Format:"Plain", Enable:"Pre-data", "Data", "Post-data", "Use Column Inserts", "Use Insert Commands"
-- PostgreSQL database dump
--

-- Dumped from database version 11.6
-- Dumped by pg_dump version 11.2

-- Started on 2020-07-31 19:23:28

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 16664)
-- Name: account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account (
    account_id integer NOT NULL,
    no_of_users bigint NOT NULL,
    sub_start_date date NOT NULL,
    sub_end_date date NOT NULL,
    account_key character varying(200) NOT NULL,
    account_name character varying(100),
    updated_time timestamp without time zone,
    updated_user bigint,
    is_active boolean
);


ALTER TABLE public.account OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16725)
-- Name: account_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_account_id_seq OWNER TO postgres;

--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 200
-- Name: account_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_account_id_seq OWNED BY public.account.account_id;


--
-- TOC entry 197 (class 1259 OID 16677)
-- Name: patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient (
    patient_id integer NOT NULL,
    phone character varying(100) NOT NULL,
    password character varying(200),
    salt character varying(100),
    "createdBy" character varying(100)
);


ALTER TABLE public.patient OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16729)
-- Name: patient_login_patient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patient_login_patient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patient_login_patient_id_seq OWNER TO postgres;

--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 201
-- Name: patient_login_patient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_login_patient_id_seq OWNED BY public.patient.patient_id;


--
-- TOC entry 205 (class 1259 OID 24608)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying,
    description character varying
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 24606)
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO postgres;

--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 204
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- TOC entry 202 (class 1259 OID 16731)
-- Name: player_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.player_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.player_id_seq OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 24619)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    id integer NOT NULL,
    "roleId" integer,
    "permissionId" integer
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 24617)
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 206
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- TOC entry 198 (class 1259 OID 16684)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    roles_id integer NOT NULL,
    roles character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16733)
-- Name: roles_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_roles_id_seq OWNER TO postgres;

--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 203
-- Name: roles_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_roles_id_seq OWNED BY public.roles.roles_id;


--
-- TOC entry 209 (class 1259 OID 24737)
-- Name: user_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_role (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint
);


ALTER TABLE public.user_role OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 24735)
-- Name: user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_role_id_seq OWNER TO postgres;

--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 208
-- Name: user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_role_id_seq OWNED BY public.user_role.id;


--
-- TOC entry 199 (class 1259 OID 16689)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(250) NOT NULL,
    email character varying(250) NOT NULL,
    password character varying(250) NOT NULL,
    salt character varying(250),
    account_id bigint,
    doctor_key character varying(200),
    is_active boolean,
    updated_time time without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3720 (class 2604 OID 16747)
-- Name: account account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account ALTER COLUMN account_id SET DEFAULT nextval('public.account_account_id_seq'::regclass);


--
-- TOC entry 3721 (class 2604 OID 16749)
-- Name: patient patient_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient ALTER COLUMN patient_id SET DEFAULT nextval('public.patient_login_patient_id_seq'::regclass);


--
-- TOC entry 3723 (class 2604 OID 24611)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3724 (class 2604 OID 24622)
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 16750)
-- Name: roles roles_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN roles_id SET DEFAULT nextval('public.roles_roles_id_seq'::regclass);


--
-- TOC entry 3725 (class 2604 OID 24740)
-- Name: user_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role ALTER COLUMN id SET DEFAULT nextval('public.user_role_id_seq'::regclass);


--
-- TOC entry 3869 (class 0 OID 16664)
-- Dependencies: 196
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.account VALUES (1, 6, '2020-02-03', '2020-02-03', 'Acc_1', 'Apollo Hospitals', NULL, NULL, NULL);
INSERT INTO public.account VALUES (2, 6, '2020-02-03', '2020-02-03', 'Acc_2', 'Dr Kamashi Memorial Hospital', NULL, NULL, NULL);
INSERT INTO public.account VALUES (3, 6, '2020-02-03', '2020-02-03', 'Acc_3', 'Dr Mehtas Hospital', NULL, NULL, NULL);
INSERT INTO public.account VALUES (4, 6, '2020-02-03', '2020-02-03', 'Acc_4', 'HCG Cancer Center', NULL, NULL, NULL);
INSERT INTO public.account VALUES (5, 6, '2020-02-03', '2020-02-03', 'Acc_5', 'Kauvery Hospital', NULL, NULL, NULL);
INSERT INTO public.account VALUES (6, 6, '2020-02-03', '2020-02-03', 'Acc_6', 'Frontier Lifeline Hospital', NULL, NULL, NULL);


--
-- TOC entry 3870 (class 0 OID 16677)
-- Dependencies: 197
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.patient VALUES (1, '9999999994', '$2b$10$AkjqDNrqBZPcNf3PP0.5/.wuXo01ol1./N.FnarBp4SdSCamdkdKS', '$2b$10$AkjqDNrqBZPcNf3PP0.5/.', NULL);
INSERT INTO public.patient VALUES (2, '9999999994', '$2b$10$5FIBLAhc8ZWPzzT3MVYNK.lur.6976HnuXQT.DrvNrM1ciey6FZ92', '$2b$10$5FIBLAhc8ZWPzzT3MVYNK.', NULL);
INSERT INTO public.patient VALUES (3, '9999999995', '$2b$10$Wek0rqGs9QkvLOyLvdz8X.dv87RD6UTr8tvuOQfTC/H8v.hM7Cd62', '$2b$10$Wek0rqGs9QkvLOyLvdz8X.', NULL);
INSERT INTO public.patient VALUES (4, '9999999995', '$2b$10$0GbIZnsPXhUJTX/EDIFGPuz0QcUI34m18emSQSnxxne1VzwcyfUCa', '$2b$10$0GbIZnsPXhUJTX/EDIFGPu', NULL);
INSERT INTO public.patient VALUES (5, '9999999996', '$2b$10$uURxkKPBX0sjopE6lfQwHeEZgUmhyAZqMb5NskDI8D.UkZAcbU0du', '$2b$10$uURxkKPBX0sjopE6lfQwHe', NULL);
INSERT INTO public.patient VALUES (6, '9999999992', '$2b$10$TP2dB6oh4oPiYDfUl/OJXu56LbgEj9w1G7LDHsE87pI8i4W0LrtjS', '$2b$10$TP2dB6oh4oPiYDfUl/OJXu', NULL);
INSERT INTO public.patient VALUES (7, '9999999992', '$2b$10$OKQ4DUQ67bukOaioxkK/pekQdo3E/pQgEJmSMk5zjoETc.L3luOty', '$2b$10$OKQ4DUQ67bukOaioxkK/pe', NULL);
INSERT INTO public.patient VALUES (8, '9999999992', '$2b$10$AMhkZkRI5Lo/HtFjJSqps.3hSK5CYRqmBf/yJ8GsRZV.Gls0Xr6su', '$2b$10$AMhkZkRI5Lo/HtFjJSqps.', NULL);
INSERT INTO public.patient VALUES (9, '9999999992', '$2b$10$oxEda8foMQw2QqCaCxM3felfd3KBuyGPrT6R85i4t3al5gFzI0Q3O', '$2b$10$oxEda8foMQw2QqCaCxM3fe', NULL);
INSERT INTO public.patient VALUES (10, '9999999982', '$2b$10$0aWK5LCkLqhXU7ZuuBip1OkcnJ0PWUBnz6YQ5HW1tg4nfvIgJ/b8K', '$2b$10$0aWK5LCkLqhXU7ZuuBip1O', NULL);
INSERT INTO public.patient VALUES (11, '9999999982', '$2b$10$yPx8lb3i8iiDAX3NZW5qWurw9paZuY9i6e9v5IGkQ5JBS5eHJvcrC', '$2b$10$yPx8lb3i8iiDAX3NZW5qWu', NULL);
INSERT INTO public.patient VALUES (12, '9999999982', '$2b$10$8y3jhizfqwBVO/GQgD7B8OUAHkMIuXJyagn1q/zm7U2XZQoMjrUvK', '$2b$10$8y3jhizfqwBVO/GQgD7B8O', NULL);
INSERT INTO public.patient VALUES (13, '9999999982', '$2b$10$s3lAaudz4J8Hjv6VOmYQk.jRamLw.peKdV1F.EwKy2oGWIpfR/Xy6', '$2b$10$s3lAaudz4J8Hjv6VOmYQk.', NULL);
INSERT INTO public.patient VALUES (14, '9999999982', '$2b$10$SjUd61A5Lzu3UU1jgEge7.tLcelOuZQ4HOF2VgZ8HYLLSp9bPPeie', '$2b$10$SjUd61A5Lzu3UU1jgEge7.', NULL);
INSERT INTO public.patient VALUES (15, '9999999982', '$2b$10$myIBzMa2/GMfrmGLxG0j5.WOsnB71T3pvWRTCCB0W4QvmBlUSRSYW', '$2b$10$myIBzMa2/GMfrmGLxG0j5.', NULL);
INSERT INTO public.patient VALUES (16, '9999999982', '$2b$10$YfHL0T9hVZaSBiPNBk32lOPXXOGItGKtSEzlKZpWyW.8va9J1Vfsa', '$2b$10$YfHL0T9hVZaSBiPNBk32lO', NULL);
INSERT INTO public.patient VALUES (17, '9999999982', '$2b$10$DvbTmMrREeo2HkTAp/bnA.4sxTtaMg/Z94KXLTC9P2hHXr88atrYG', '$2b$10$DvbTmMrREeo2HkTAp/bnA.', NULL);
INSERT INTO public.patient VALUES (18, '9999999982', '$2b$10$7SrFxxTUQHwAZFMcBN6XsuSuoQ8GZOv9YYEjLcEeSUyO7juMrOwf6', '$2b$10$7SrFxxTUQHwAZFMcBN6Xsu', NULL);
INSERT INTO public.patient VALUES (19, '9999999982', '$2b$10$4gMudTMve9w8XiPTTSurEeK/rxJQh6q//Bl9O9D7yT8MmjBwuTYp6', '$2b$10$4gMudTMve9w8XiPTTSurEe', NULL);
INSERT INTO public.patient VALUES (20, '9999999982', '$2b$10$d9VTNkhCyp6Os0FwImrMhOyE2qaY9FePY8SXLqLLDkwH2JBYcbaIO', '$2b$10$d9VTNkhCyp6Os0FwImrMhO', NULL);
INSERT INTO public.patient VALUES (21, '9999999982', '$2b$10$BimWh3GvukHzBAYIlZGCbOdbx0BMSVwWowaNmSvcvs6sRkTwVWuTO', '$2b$10$BimWh3GvukHzBAYIlZGCbO', NULL);
INSERT INTO public.patient VALUES (22, '9999999982', '$2b$10$xF9EerYBJjTtyXyL.1qPxu2sHACLzkUROYe3fE1/54UruQqZXcCVy', '$2b$10$xF9EerYBJjTtyXyL.1qPxu', NULL);
INSERT INTO public.patient VALUES (23, '9999999982', '$2b$10$FCDrKClhzWJyzItBESEEhuYJ55j1VWWBectw6xHVFbhTRREtHYSJi', '$2b$10$FCDrKClhzWJyzItBESEEhu', NULL);
INSERT INTO public.patient VALUES (24, '9999999982', '$2b$10$XOXFR1WRw1fCBo1opxH8SuVYhSSXvslU6dmEZRsWofRfAvro7DMNe', '$2b$10$XOXFR1WRw1fCBo1opxH8Su', NULL);
INSERT INTO public.patient VALUES (25, '9999999992', '$2b$10$AYxoA9uekhyWfEQrSt.T0OCwmG4gI2mbs4SyPRfxh.spp0nwXX/B.', '$2b$10$AYxoA9uekhyWfEQrSt.T0O', NULL);
INSERT INTO public.patient VALUES (26, '9999999992', '$2b$10$e0aKlLwJgPFftM4ZUo9r3OSEYAYEx/caHESwEm7CySmsCd2tjavHm', '$2b$10$e0aKlLwJgPFftM4ZUo9r3O', NULL);
INSERT INTO public.patient VALUES (27, '9999999992', '$2b$10$8Nx7PigpU46CKQT3RZfWYev31B7lAwF.K3sbFN62tlFSFjt9dX3x6', '$2b$10$8Nx7PigpU46CKQT3RZfWYe', NULL);
INSERT INTO public.patient VALUES (28, '9999999992', '$2b$10$XXngOXEGRVD5I/slueiTkOsXWCO9Qz1aXZCzMzkRtpg2Ibmbf2mCW', '$2b$10$XXngOXEGRVD5I/slueiTkO', NULL);
INSERT INTO public.patient VALUES (29, '9999999992', '$2b$10$X76Z5OflIkVMt7zF8CPMjeEnERtzuIx7VVIXu2uVxW2gS7YFSScOu', '$2b$10$X76Z5OflIkVMt7zF8CPMje', NULL);
INSERT INTO public.patient VALUES (30, '9999999992', '$2b$10$upakEsRq6bN.9zquu50gfexfXXYLumrPS2eMFGc1VLJgjun6QtB5q', '$2b$10$upakEsRq6bN.9zquu50gfe', NULL);
INSERT INTO public.patient VALUES (31, '9999999992', '$2b$10$0JEZaIsixsHfBAnOuQDdxeSMSiuPNJCb6DnZcDDSWp4DLRbqz2u/6', '$2b$10$0JEZaIsixsHfBAnOuQDdxe', NULL);
INSERT INTO public.patient VALUES (32, '9999999992', '$2b$10$Ky5gwXTzOpuIqBojnTnkT.YAzotzW3I6f9DO7BZGwWTTPclBn.HLu', '$2b$10$Ky5gwXTzOpuIqBojnTnkT.', NULL);
INSERT INTO public.patient VALUES (33, '9999999992', '$2b$10$vd/aYiiJpQcZLC7bbecUV.Mt4Y4RMWbwUGpy5Bo.ExukZ6q9lGEWm', '$2b$10$vd/aYiiJpQcZLC7bbecUV.', NULL);
INSERT INTO public.patient VALUES (34, '9999999992', '$2b$10$HS0F96ibu2/D4cOxEn8.rOuN6EjacJ40tamNkRyQYtJbClShQV7d6', '$2b$10$HS0F96ibu2/D4cOxEn8.rO', NULL);
INSERT INTO public.patient VALUES (35, '9999999992', '$2b$10$fhuxDS61BblMbF3JJ8QMt.KL0GrdUcPLPwYj8QKySs1borwKafFoC', '$2b$10$fhuxDS61BblMbF3JJ8QMt.', NULL);
INSERT INTO public.patient VALUES (36, '9999999992', '$2b$10$ZWJHo/y4vgSxUfgNXlP0qehSs0ByHA4bSea5Gmu.qA8nwg/e03mmq', '$2b$10$ZWJHo/y4vgSxUfgNXlP0qe', NULL);
INSERT INTO public.patient VALUES (37, '9999999992', '$2b$10$k3p4ENthET7Y2yOrAO6mmeIJ./xvKqhoOCSCgeUBz8iZ2Km5iwIhC', '$2b$10$k3p4ENthET7Y2yOrAO6mme', NULL);
INSERT INTO public.patient VALUES (38, '9999999992', '$2b$10$dUgDWPClinj9zxYlkAxJUevMPL7iW5SxYjnVZ17xI9y9h7fl6v5Ru', '$2b$10$dUgDWPClinj9zxYlkAxJUe', NULL);
INSERT INTO public.patient VALUES (39, '9999999992', '$2b$10$4S.DjIBGpJIFidpmr2RbzeXR3O/cEWDu87E0VlnSm57u4NpeVkjiC', '$2b$10$4S.DjIBGpJIFidpmr2Rbze', NULL);
INSERT INTO public.patient VALUES (40, '9999999992', '$2b$10$HQVDhdxISq702.PkUydpOeyaoQiFcMBVnUHEnu22Dc4n353sZ51vy', '$2b$10$HQVDhdxISq702.PkUydpOe', NULL);
INSERT INTO public.patient VALUES (41, '9999999992', '$2b$10$./hIb9r1AX1HwvBShf4koeKd2vewzEZPkdEEKdPRMBUydHuo6P8om', '$2b$10$./hIb9r1AX1HwvBShf4koe', NULL);
INSERT INTO public.patient VALUES (42, '9999999992', '$2b$10$.KpxfXoeE1We40vNGrCJxOQsukytHIflxK/wMZ.FW5Wniz.m/kt5O', '$2b$10$.KpxfXoeE1We40vNGrCJxO', NULL);
INSERT INTO public.patient VALUES (43, '9999999992', '$2b$10$Z/JnoZqLdQog73mlTeLszOK8VQPDICChA5qto91CAH5PwM4rCln3S', '$2b$10$Z/JnoZqLdQog73mlTeLszO', NULL);
INSERT INTO public.patient VALUES (44, '9999999992', '$2b$10$nR2ZIOYLW5m7SihYkXRYxO57YRZE1XL453j1bY4.sIY9IqVn4FAGS', '$2b$10$nR2ZIOYLW5m7SihYkXRYxO', NULL);
INSERT INTO public.patient VALUES (45, '9999999992', '$2b$10$lr7MTSvJGaobn.l5N.HyyetFA9r5yBV3M1o1huEVwrKCb3BggYriK', '$2b$10$lr7MTSvJGaobn.l5N.Hyye', NULL);
INSERT INTO public.patient VALUES (46, '9999999992', '$2b$10$BDkLaklEbF2b.YHzc0b6LOXz6pJiYemPa2XPxBYGEKfjXPUqLL6Ua', '$2b$10$BDkLaklEbF2b.YHzc0b6LO', NULL);
INSERT INTO public.patient VALUES (47, '9999999992', '$2b$10$1Tybcfr5PB7gJy1cgJnfA.sU1GFbWmokXxWYe4lAhze4NvdT9pFFy', '$2b$10$1Tybcfr5PB7gJy1cgJnfA.', NULL);
INSERT INTO public.patient VALUES (48, '9999999992', '$2b$10$P4gByxFZYWZTcvJsRy55ZOd3fHEp9bwyCKyPjObXQS4En9JkVnqWS', '$2b$10$P4gByxFZYWZTcvJsRy55ZO', NULL);
INSERT INTO public.patient VALUES (49, '9999999992', '$2b$10$43WY8iXfI1nDqNZ/HwRePuqnJZ9jlL484QNPaCvIkNehq4.t18p6a', '$2b$10$43WY8iXfI1nDqNZ/HwRePu', NULL);
INSERT INTO public.patient VALUES (50, '9999999992', '$2b$10$iPTg4csyDIzzuEd./fAGou9DNADplQ0sSGBysLXo2PxXykrzPUpIm', '$2b$10$iPTg4csyDIzzuEd./fAGou', NULL);
INSERT INTO public.patient VALUES (51, '9999999992', '$2b$10$aRP5ibF/XdZH2k9LFtBZ9eAy4hx/wnZ7cAhZ58SQYtbGQV92ADyFm', '$2b$10$aRP5ibF/XdZH2k9LFtBZ9e', NULL);
INSERT INTO public.patient VALUES (52, '9999999992', '$2b$10$RJNXCUbIR3XciEoFNPuxNOUvdLJ96JG/.D4DHLut4aMoW3oUGicrm', '$2b$10$RJNXCUbIR3XciEoFNPuxNO', NULL);
INSERT INTO public.patient VALUES (53, '9999999992', '$2b$10$dKPmYavNDMxhgEk03vRNd.8B87WvlqJoo6EzCAvtvzhOWw3H8s6bS', '$2b$10$dKPmYavNDMxhgEk03vRNd.', NULL);
INSERT INTO public.patient VALUES (54, '9999999992', '$2b$10$BW2rovV77fcZtJCIXCg8yeTuOKWBjnPE8krTz8/.IE3bumRpZ80lu', '$2b$10$BW2rovV77fcZtJCIXCg8ye', NULL);
INSERT INTO public.patient VALUES (55, '9999999992', '$2b$10$Z.oFMPZf3v305xq/JiVo8OiaIUm4Hh7FqNE5DnCSFwEHuYmiKv7Lq', '$2b$10$Z.oFMPZf3v305xq/JiVo8O', NULL);
INSERT INTO public.patient VALUES (56, '9999999992', '$2b$10$hWlqGTZnWL.NQYaqyzs3A.n8fLAwTVSDd0.pGVr73tCekevqFFSDK', '$2b$10$hWlqGTZnWL.NQYaqyzs3A.', NULL);
INSERT INTO public.patient VALUES (57, '9999999992', '$2b$10$i/S1S7LXlX.jLF9S8Hc6Ne.ejvD.Qsvpa0c1vzLEvJFAjO6rAkBni', '$2b$10$i/S1S7LXlX.jLF9S8Hc6Ne', NULL);
INSERT INTO public.patient VALUES (58, '9999999992', '$2b$10$tapqbhwlCHPT04BIEc3OIOgPzmDpE1zlra2WgayKzt8CT4cQ8L56m', '$2b$10$tapqbhwlCHPT04BIEc3OIO', NULL);
INSERT INTO public.patient VALUES (59, '9999999992', '$2b$10$SXkBk.SFfxk1dQUFwZmaVu.pvR4v5Z/3pIkCmiu91VWc95p3KoXvq', '$2b$10$SXkBk.SFfxk1dQUFwZmaVu', NULL);
INSERT INTO public.patient VALUES (60, '9999999992', '$2b$10$RcIcpAS0IduWaZey56AhNe3bOjplSRfUY6y3XWcP76Z3hQKTJ3TL6', '$2b$10$RcIcpAS0IduWaZey56AhNe', NULL);
INSERT INTO public.patient VALUES (61, '9999999992', '$2b$10$CZITQ1Bf2B4NdP58OC6aJuQE4I/At8XywkPGAMhHshpeSF0I3YULe', '$2b$10$CZITQ1Bf2B4NdP58OC6aJu', NULL);
INSERT INTO public.patient VALUES (62, '9999999992', '$2b$10$qgxyYcrLIGSwIE.IMO1koe2GxOmESTwKB2K5pGuWihCAGLN3gBqhC', '$2b$10$qgxyYcrLIGSwIE.IMO1koe', NULL);
INSERT INTO public.patient VALUES (63, '9999999992', '$2b$10$VuzBXyJtf3C3uFwEmVbdKOBB0xKMUBCH9KRxxdAe.1d7ei4Necniu', '$2b$10$VuzBXyJtf3C3uFwEmVbdKO', NULL);
INSERT INTO public.patient VALUES (64, '9999999992', '$2b$10$CopioVKvXm3o1RhmqORjV.yKRC0qTTVtlnUwSlM7s6YzZXCitvyG2', '$2b$10$CopioVKvXm3o1RhmqORjV.', NULL);
INSERT INTO public.patient VALUES (65, '9999999992', '$2b$10$x.3tu4h6wNSbChiYU1EnjuxbUIph5tphDJ97ccmEfKPRG3bBTJ/aK', '$2b$10$x.3tu4h6wNSbChiYU1Enju', NULL);
INSERT INTO public.patient VALUES (66, '9999999992', '$2b$10$ILhI6UgjNZndWwsMsThrGexZcpgkMaU6boeDZIFedmAXu78TM1uY2', '$2b$10$ILhI6UgjNZndWwsMsThrGe', NULL);
INSERT INTO public.patient VALUES (67, '9999999992', '$2b$10$U5yNHzmSqR1uHZBOdBbA4etWhdMguaz1ZSbj4RCj.Hn5ZTMVMJuhO', '$2b$10$U5yNHzmSqR1uHZBOdBbA4e', NULL);
INSERT INTO public.patient VALUES (68, '9999999992', '$2b$10$qSJDHrGNovQSf.8/sbb/guuPAKLqAYD2AiTNtHMjxymtZKLvMR1qG', '$2b$10$qSJDHrGNovQSf.8/sbb/gu', NULL);
INSERT INTO public.patient VALUES (69, '9999988992', '$2b$10$ZlEQhmFoZUtGo4PmZ9F9y.iqIZbDxsriMhHJTRNjixESmTnEnpXNS', '$2b$10$ZlEQhmFoZUtGo4PmZ9F9y.', NULL);
INSERT INTO public.patient VALUES (70, '9999988992', '$2b$10$1N8pvUGy5UMSdoFs2l0ZSey3l/bzgayMasKc5Y/Bp4F69K3SwVXuy', '$2b$10$1N8pvUGy5UMSdoFs2l0ZSe', NULL);
INSERT INTO public.patient VALUES (71, '9999988992', '$2b$10$qoI/GOr1pia3r7RG3uPd8eHbjy.kLuWkxMKg3HBYOG1ysb6CdMTBe', '$2b$10$qoI/GOr1pia3r7RG3uPd8e', NULL);
INSERT INTO public.patient VALUES (72, '9999988992', '$2b$10$jH53jcKfOdHDOXt7mbrQ8OwsF8loE6bbI4ZeF0.2xOj/7bjNVZOwO', '$2b$10$jH53jcKfOdHDOXt7mbrQ8O', NULL);
INSERT INTO public.patient VALUES (73, '9999988992', '$2b$10$jAO1PQHUv4D/XlzPtoNeWuJPSRbYXNCAVyO1giUW2EE4yJgJ1Lryi', '$2b$10$jAO1PQHUv4D/XlzPtoNeWu', NULL);
INSERT INTO public.patient VALUES (74, '9999988992', '$2b$10$YYbIB2vbb2bcKJbqY4nlQuSxmEBs2unuiriezpbmBDvjqQMnI5ROK', '$2b$10$YYbIB2vbb2bcKJbqY4nlQu', NULL);
INSERT INTO public.patient VALUES (75, '9999988992', '$2b$10$pcMm4b9M6a6fOa4AovPgnO/TtXTUmOaBELebI64C9xbfsp/w0SZee', '$2b$10$pcMm4b9M6a6fOa4AovPgnO', NULL);
INSERT INTO public.patient VALUES (76, '9999988992', '$2b$10$cNl2UIyZBJhdGmuxSBM4a.hNKfWh/tfvFDfNg3sqkFGO7xmxcRpJ6', '$2b$10$cNl2UIyZBJhdGmuxSBM4a.', NULL);
INSERT INTO public.patient VALUES (77, '9999999992', '$2b$10$2IDXlmo34gRVRShs5JolAeNThC083DSeYByATC0aAW1HZhBB4d8HK', '$2b$10$2IDXlmo34gRVRShs5JolAe', NULL);
INSERT INTO public.patient VALUES (78, '9999999992', '$2b$10$XhDdpSXj/qUAeb9lgot20Opsv.ly7jc1j/aG3JqQF8MszwMapAO3G', '$2b$10$XhDdpSXj/qUAeb9lgot20O', NULL);
INSERT INTO public.patient VALUES (79, '9999999992', '$2b$10$B/NTGwQE7gwNi7rnmYp6qecI/2EI6n3oBmATQcOtD8S.kpnBZRuPu', '$2b$10$B/NTGwQE7gwNi7rnmYp6qe', NULL);
INSERT INTO public.patient VALUES (80, '9999999993', '$2b$10$4B5D4NOpgJCp9lOaE03cKeKQTzXp9L6KpWkXc/XBcE32mzmNDjm2y', '$2b$10$4B5D4NOpgJCp9lOaE03cKe', NULL);
INSERT INTO public.patient VALUES (81, '9999299992', '$2b$10$A4tWIiXXPsXf7IWjes.XE.iCSOBodOqHU7v1mTEtSjSBcqK3of./G', '$2b$10$A4tWIiXXPsXf7IWjes.XE.', NULL);
INSERT INTO public.patient VALUES (82, '9999988888', '$2b$10$1j/bYLjQdZgkQIpDZjoQoe.oaBymGBZH9hE/BASZ1MgFrNTDrEJ0m', '$2b$10$1j/bYLjQdZgkQIpDZjoQoe', NULL);
INSERT INTO public.patient VALUES (83, '7777766666', '$2b$10$CUgPQtV9Zda8kuIw5ECnV.Mk1YwS6g/ilkbZlebb23IDvleALrwt2', '$2b$10$CUgPQtV9Zda8kuIw5ECnV.', NULL);
INSERT INTO public.patient VALUES (84, '6666688888', '$2b$10$T.UBgEbhtcB6kyf8Bj3ARuXrnnvPM4xo8FQl2lkEf9r7bwFWp03rq', '$2b$10$T.UBgEbhtcB6kyf8Bj3ARu', NULL);
INSERT INTO public.patient VALUES (85, '9999999999', '$2b$10$/Cp1fgkKZ/gDbMksRC5q9uuZ6uWnnC.3KsceVCsa5/tRLFo1Ww0OS', '$2b$10$/Cp1fgkKZ/gDbMksRC5q9u', NULL);
INSERT INTO public.patient VALUES (86, '9999999999', '$2b$10$rZ3/Xk0CFzjHgXc6NB5HjeLXqV1fBa/7Sir2xxXnzFzro8NzXG3tm', '$2b$10$rZ3/Xk0CFzjHgXc6NB5Hje', NULL);
INSERT INTO public.patient VALUES (87, '8594236789', '$2b$10$Bk5LmjOk57z8DdoH5EmB8euDbFWfTndRi.OkHEp0A4b3q9AH9.FPK', '$2b$10$Bk5LmjOk57z8DdoH5EmB8e', NULL);
INSERT INTO public.patient VALUES (88, '9543684236', '$2b$10$acnjJ3kba49go9.y.IJbNO.ja.QkohN8rmf8IdFZ/dbDv7NXnenqC', '$2b$10$acnjJ3kba49go9.y.IJbNO', NULL);
INSERT INTO public.patient VALUES (89, '6576579579', '$2b$10$cKztHiG.G6KS427ok3z2vuliTedi9FC0st05YD.In4lszxWfsNP3O', '$2b$10$cKztHiG.G6KS427ok3z2vu', NULL);
INSERT INTO public.patient VALUES (90, '8877665544', '$2b$10$nTd2s1LwO.Zoqj6baqslZuphw1SLyYwcpg53dcFZtdmZNnmA/aFaO', '$2b$10$nTd2s1LwO.Zoqj6baqslZu', NULL);
INSERT INTO public.patient VALUES (91, '7766554433', '$2b$10$VtEz41OvAPdMlA8d/PeHkea9zwGlhn6dZNcTU.P0of6HEH8bVqaZK', '$2b$10$VtEz41OvAPdMlA8d/PeHke', NULL);
INSERT INTO public.patient VALUES (92, '9888888888', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (93, '9191919191', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (94, '9999990000', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (95, '9999900000', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (96, '9999900001', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (97, '9999900002', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (98, '9999900003', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (99, '9999900004', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (100, '9999900005', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (101, '9999900006', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (102, '9999900007', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (103, '9999900008', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (104, '9666666666', NULL, NULL, NULL);
INSERT INTO public.patient VALUES (105, '9876543210', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (106, '9999900013', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (107, '9999900014', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (108, '9999900464', '$2b$10$j19EMIipze/Wdy3pmd3ZDuAV3FiQShNjaBUgOBk/vOgryy1BKBDt6', '$2b$10$j19EMIipze/Wdy3pmd3ZDu', 'PATIENT');
INSERT INTO public.patient VALUES (109, '9999900466', '$2b$10$TNrDnvpGbc1EAtFZ5VP4E.cQ0emg6eWdcdsG/Ke8FdBNtyCOdR2Za', '$2b$10$TNrDnvpGbc1EAtFZ5VP4E.', 'PATIENT');
INSERT INTO public.patient VALUES (110, '9999900015', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (111, '9999999461', '$2b$10$BIPbZ6Hg.Sd7Nfya/sigjuQ.eTMMkj19YAWYnvzJYA5GMHItwfhsS', '$2b$10$BIPbZ6Hg.Sd7Nfya/sigju', 'PATIENT');
INSERT INTO public.patient VALUES (112, '9999999980', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (113, '5456465456', '$2b$10$sTSDnmlCNcvtq0ufsEgSweBHRl4jVdCY0z3KZ60XOXWr2t0YeoKme', '$2b$10$sTSDnmlCNcvtq0ufsEgSwe', 'PATIENT');
INSERT INTO public.patient VALUES (114, '2342323434', '$2b$10$m1zYXlLpisd8QDJQGUXghOJH0pEqBBqA9hDYceWUF5WT6eGDNcqMW', '$2b$10$m1zYXlLpisd8QDJQGUXghO', 'PATIENT');
INSERT INTO public.patient VALUES (115, '2342342343', '$2b$10$wcCjzVhOnFvRGykMPOuLoOnIzWIjyHdwVxOs2dONPkWqycFTe9tWe', '$2b$10$wcCjzVhOnFvRGykMPOuLoO', 'PATIENT');
INSERT INTO public.patient VALUES (116, '2432342342', '$2b$10$sav79yctqC9znyaOvCG2HerSOp1FD7mah45t2lTDU0CwlKl5oZkha', '$2b$10$sav79yctqC9znyaOvCG2He', 'PATIENT');
INSERT INTO public.patient VALUES (117, '2342342333', '$2b$10$xWE0nbIUCjbYPhl/Qc6PEerYmUEtEWyC.bBTc7wIyow6G2u3Sape2', '$2b$10$xWE0nbIUCjbYPhl/Qc6PEe', 'PATIENT');
INSERT INTO public.patient VALUES (118, '2342342222', '$2b$10$0p8a5EY24RbXLi12CEP8qeibVApndmq53mDFeW4Gpa12EZasF1OJ6', '$2b$10$0p8a5EY24RbXLi12CEP8qe', 'PATIENT');
INSERT INTO public.patient VALUES (119, '7358916662', '$2b$10$y/7vkysqIhkYklChqV2xVuXnlsneycLauG3sKVkspfUIio10p.ucK', '$2b$10$y/7vkysqIhkYklChqV2xVu', 'PATIENT');
INSERT INTO public.patient VALUES (120, '7358916682', '$2b$10$GZnTnjt./6qHSq4FKzWqa.gGdI2t2TbDgESpfZ5mRBmsXP34IwqAS', '$2b$10$GZnTnjt./6qHSq4FKzWqa.', 'PATIENT');
INSERT INTO public.patient VALUES (121, '8499678498', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (122, '9875647499', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (123, '9867858989', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (124, '9879879876', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (125, '9634578524', '$2b$10$ZRDp9yjBGQbUOd9x/kDfkORmmewupOA7h89l2eAdxiHnZ8hbweBB6', '$2b$10$ZRDp9yjBGQbUOd9x/kDfkO', 'PATIENT');
INSERT INTO public.patient VALUES (126, '9999999997', '$2b$10$wuvrne5rnQK1zJp8w3kWqOpmKyBFW8AzCTitJNNgpYaBbuE4j0rRy', '$2b$10$wuvrne5rnQK1zJp8w3kWqO', 'PATIENT');
INSERT INTO public.patient VALUES (127, '9999999991', '$2b$10$PUl.aX.FgnyqG9puKI.Oz.oGOUYaN1Dzhgb0/7kGyUv88213cXBUi', '$2b$10$PUl.aX.FgnyqG9puKI.Oz.', 'PATIENT');
INSERT INTO public.patient VALUES (128, '9999999990', '$2b$10$ceV7EMjOkWg2QcwWJF9MKegv.5ax75La8j0xVjv67moSEIxZJ63RS', '$2b$10$ceV7EMjOkWg2QcwWJF9MKe', 'PATIENT');
INSERT INTO public.patient VALUES (129, '9999999998', '$2b$10$gBi25dPRl8uCvnMPKs5KFugRoiZ7Ev5CXYKADt9HCLy5lJYHHtbxe', '$2b$10$gBi25dPRl8uCvnMPKs5KFu', 'PATIENT');
INSERT INTO public.patient VALUES (130, '9999966666', '$2b$10$.dLJu9M9xbS16guSuwBFm.cIp9bUKpc10k.j6BTFpEcn3SlSAIJrK', '$2b$10$.dLJu9M9xbS16guSuwBFm.', 'PATIENT');
INSERT INTO public.patient VALUES (131, '9966884471', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (132, '9966448875', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (133, '9966884476', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (134, '9966884477', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (135, '7777788888', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (136, '6666655555', '$2b$10$v8Ea136rfkO2t1.NtewYSuxa5G6CauJrE91TScTYKRTJu0oAxkNcS', '$2b$10$v8Ea136rfkO2t1.NtewYSu', 'PATIENT');
INSERT INTO public.patient VALUES (137, '7766889944', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (138, '9638527410', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (139, '9898989898', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (140, '8978978971', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (141, '8798121212', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (142, '7896541230', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (143, '9996667777', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (144, '9873535252', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (145, '9898989891', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (146, '9111111111', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (147, '9895969595', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (148, '8527419632', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (149, '7893214562', NULL, NULL, 'DOCTOR');
INSERT INTO public.patient VALUES (150, '8682866222', '$2b$10$VIKEJMKNM5OxX/Es0vgTkuumI5b1oUxh2vAwqXKYgxzLVk5PqEuXm', '$2b$10$VIKEJMKNM5OxX/Es0vgTku', 'PATIENT');
INSERT INTO public.patient VALUES (151, '8870527821', '$2b$10$ODMdDbmu4/0XHghkI/Gzmu0w08tQlnoipkXbrqYogyIM1WOFOUwdS', '$2b$10$ODMdDbmu4/0XHghkI/Gzmu', 'PATIENT');
INSERT INTO public.patient VALUES (152, '9652147787', '$2b$10$HHbnY907/iksgGQemgBu1.jJGHWgasA7I/Ma2LqcAIMIYioRNIiZe', '$2b$10$HHbnY907/iksgGQemgBu1.', 'PATIENT');
INSERT INTO public.patient VALUES (153, '9398341783', '$2b$10$iDQLQeXG01VI.05I/qR2hOVm3rOSFtb5F4bxLIGua8uh20buuZud6', '$2b$10$iDQLQeXG01VI.05I/qR2hO', 'PATIENT');
INSERT INTO public.patient VALUES (154, '9398341784', '$2b$10$SPtmr2s3/MZG4s1PVq9KwewfPQaX4FXsfwClXqB.wdv7in8UocLx2', '$2b$10$SPtmr2s3/MZG4s1PVq9Kwe', 'PATIENT');
INSERT INTO public.patient VALUES (155, '9398341785', '$2b$10$HQEZ5rVMA4GxQKViNVW8LO7SgQ1JHWUz0egi1W9zx8UhxBc/DvUqW', '$2b$10$HQEZ5rVMA4GxQKViNVW8LO', 'PATIENT');
INSERT INTO public.patient VALUES (156, '9398341786', '$2b$10$sVtv1O4KPgq59o8v8.wnVulhixaax4dYVtxg3n9UOwelJYvVOOER.', '$2b$10$sVtv1O4KPgq59o8v8.wnVu', 'PATIENT');
INSERT INTO public.patient VALUES (157, '9398341787', '$2b$10$XRvCZ4GCYwWhl9A96xEDEeERkyJ9Y7O5utXCsGcrdBVp.bdFSF3BS', '$2b$10$XRvCZ4GCYwWhl9A96xEDEe', 'PATIENT');
INSERT INTO public.patient VALUES (158, '9398341788', '$2b$10$B6naJJQEnuQFpt2iORwGE.X701wfgnMZDfgqSYNEitJTXz23emEWe', '$2b$10$B6naJJQEnuQFpt2iORwGE.', 'PATIENT');
INSERT INTO public.patient VALUES (159, '9398341789', '$2b$10$AW8jKRIQ3JW6b5Re3U.Hsutw.3TznuaRsvGuejx/mgJYX31iHLY2W', '$2b$10$AW8jKRIQ3JW6b5Re3U.Hsu', 'PATIENT');


--
-- TOC entry 3878 (class 0 OID 24608)
-- Dependencies: 205
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.permissions VALUES (1, 'SELF_APPOINTMENT_READ', 'SELF_APPOINTMENT_READ');
INSERT INTO public.permissions VALUES (2, 'SELF_APPOINTMENT_WRITE', 'SELF_APPOINTMENT_WRITE');
INSERT INTO public.permissions VALUES (5, 'REPORTS', 'REPORTS');
INSERT INTO public.permissions VALUES (6, 'ACCOUNT_SETTINGS_READ', 'ACCOUNT_SETTINGS_READ');
INSERT INTO public.permissions VALUES (7, 'ACCOUNT_SETTINGS_WRITE', 'ACCOUNT_SETTINGS_WRITE');
INSERT INTO public.permissions VALUES (10, 'ACCOUNT_USERS_APPOINTMENT_READ', 'ACCOUNT_USERS_APPOINTMENT_READ');
INSERT INTO public.permissions VALUES (11, 'ACCOUNT_USERS_APPOINTMENT_WRITE', 'ACCOUNT_USERS_APPOINTMENT_WRITE');
INSERT INTO public.permissions VALUES (12, 'CUSTOMER', 'CUSTOMER');
INSERT INTO public.permissions VALUES (3, 'SELF_USER_SETTINGS_READ', 'SELF_USER_CONFIG_READ');
INSERT INTO public.permissions VALUES (4, 'SELF_USER_SETTINGS_WRITE', 'SELF_USER_CONFIG_WRITE');
INSERT INTO public.permissions VALUES (8, 'ACCOUNT_USERS_SETTINGS_READ', 'ACCOUNT_USERS_CONFIG_READ');
INSERT INTO public.permissions VALUES (9, 'ACCOUNT_USERS_SETTINGS_WRITE', 'ACCOUNT_USERS_CONFIG_WRITE');


--
-- TOC entry 3880 (class 0 OID 24619)
-- Dependencies: 207
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.role_permissions VALUES (1, 2, 1);
INSERT INTO public.role_permissions VALUES (2, 2, 2);
INSERT INTO public.role_permissions VALUES (3, 2, 3);
INSERT INTO public.role_permissions VALUES (4, 2, 4);
INSERT INTO public.role_permissions VALUES (5, 2, 6);
INSERT INTO public.role_permissions VALUES (6, 2, 8);
INSERT INTO public.role_permissions VALUES (7, 2, 10);
INSERT INTO public.role_permissions VALUES (8, 1, 5);
INSERT INTO public.role_permissions VALUES (9, 1, 6);
INSERT INTO public.role_permissions VALUES (10, 1, 7);
INSERT INTO public.role_permissions VALUES (11, 1, 8);
INSERT INTO public.role_permissions VALUES (12, 1, 9);
INSERT INTO public.role_permissions VALUES (13, 1, 10);
INSERT INTO public.role_permissions VALUES (14, 1, 11);
INSERT INTO public.role_permissions VALUES (15, 3, 6);
INSERT INTO public.role_permissions VALUES (16, 3, 8);
INSERT INTO public.role_permissions VALUES (17, 3, 10);
INSERT INTO public.role_permissions VALUES (18, 3, 11);
INSERT INTO public.role_permissions VALUES (19, 4, 12);


--
-- TOC entry 3871 (class 0 OID 16684)
-- Dependencies: 198
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles VALUES (1, 'ADMIN');
INSERT INTO public.roles VALUES (2, 'DOCTOR');
INSERT INTO public.roles VALUES (3, 'DOC_ASSISTANT');
INSERT INTO public.roles VALUES (4, 'PATIENT');


--
-- TOC entry 3882 (class 0 OID 24737)
-- Dependencies: 209
-- Data for Name: user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_role VALUES (1, 28, 2);
INSERT INTO public.user_role VALUES (2, 29, 2);
INSERT INTO public.user_role VALUES (3, 30, 2);
INSERT INTO public.user_role VALUES (4, 31, 2);
INSERT INTO public.user_role VALUES (5, 32, 2);
INSERT INTO public.user_role VALUES (6, 33, 2);
INSERT INTO public.user_role VALUES (7, 34, 2);
INSERT INTO public.user_role VALUES (8, 35, 2);
INSERT INTO public.user_role VALUES (9, 36, 2);
INSERT INTO public.user_role VALUES (10, 37, 2);
INSERT INTO public.user_role VALUES (11, 38, 2);
INSERT INTO public.user_role VALUES (12, 39, 2);
INSERT INTO public.user_role VALUES (13, 40, 2);
INSERT INTO public.user_role VALUES (14, 41, 2);
INSERT INTO public.user_role VALUES (15, 42, 2);
INSERT INTO public.user_role VALUES (16, 43, 2);
INSERT INTO public.user_role VALUES (17, 44, 2);
INSERT INTO public.user_role VALUES (18, 45, 2);
INSERT INTO public.user_role VALUES (19, 46, 2);
INSERT INTO public.user_role VALUES (20, 47, 2);
INSERT INTO public.user_role VALUES (21, 48, 2);
INSERT INTO public.user_role VALUES (22, 49, 2);
INSERT INTO public.user_role VALUES (23, 50, 2);
INSERT INTO public.user_role VALUES (24, 51, 2);
INSERT INTO public.user_role VALUES (25, 52, 2);
INSERT INTO public.user_role VALUES (26, 53, 1);
INSERT INTO public.user_role VALUES (27, 54, 1);
INSERT INTO public.user_role VALUES (28, 55, 1);
INSERT INTO public.user_role VALUES (29, 56, 1);
INSERT INTO public.user_role VALUES (30, 57, 1);
INSERT INTO public.user_role VALUES (31, 58, 1);
INSERT INTO public.user_role VALUES (32, 59, 3);
INSERT INTO public.user_role VALUES (33, 60, 4);
INSERT INTO public.user_role VALUES (34, 61, 4);
INSERT INTO public.user_role VALUES (35, 62, 4);


--
-- TOC entry 3872 (class 0 OID 16689)
-- Dependencies: 199
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (60, 'Nirmala Seetharaman', 'nirmala@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', NULL, NULL, NULL, NULL);
INSERT INTO public.users VALUES (54, 'T.G.Govindarajan', 'govindarajan@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 2, NULL, NULL, NULL);
INSERT INTO public.users VALUES (55, 'A.J.Mehta', 'mehta@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 3, NULL, NULL, NULL);
INSERT INTO public.users VALUES (56, 'B.S.Ajay Kumar', 'ajaykumar@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 4, NULL, NULL, NULL);
INSERT INTO public.users VALUES (57, 'S.Manivannan', 'manivannan@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 5, NULL, NULL, NULL);
INSERT INTO public.users VALUES (28, 'Adithya K', 'adithya@apollo.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_1', true, '16:11:11.550643');
INSERT INTO public.users VALUES (29, '"Prof Narendranath Kanna"', 'narendranath@apollo.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_2', true, '16:12:32.045519');
INSERT INTO public.users VALUES (32, 'Shalini shetty', 'test@apollo.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_5', true, '15:15:08.858754');
INSERT INTO public.users VALUES (61, 'Ashok Gajapathi raj', 'ashok@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', NULL, NULL, NULL, NULL);
INSERT INTO public.users VALUES (62, 'Shrushti Jayanth Deshmukh', 'shrushti@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', NULL, NULL, NULL, NULL);
INSERT INTO public.users VALUES (58, 'K.M.Cherian', 'cherian@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 6, NULL, NULL, NULL);
INSERT INTO public.users VALUES (30, 'Sheetal Desai', 'sheetal@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_3', true, '16:13:12.897447');
INSERT INTO public.users VALUES (53, 'Suneeta Reddy', 'admin2@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 1, NULL, NULL, NULL);
INSERT INTO public.users VALUES (43, 'Mahesh umar N Upasani', 'maheshkumar@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 4, 'Doc_16', true, '15:53:41.215366');
INSERT INTO public.users VALUES (31, ' Sree Kumar Reddy', 'sreekumarreddy@apollo.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_4', true, '16:14:28.233564');
INSERT INTO public.users VALUES (33, 'Sreeram Valluri', 'sreeram@apollo.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_6', true, '15:30:16.748709');
INSERT INTO public.users VALUES (34, 'Indhumathi R', 'indhumathir@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 2, 'Doc_7', true, '16:15:33.148347');
INSERT INTO public.users VALUES (36, 'Rajeshwari Ramachandran ', 'rajeshwari@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 2, 'Doc_9', true, '15:34:46.074008');
INSERT INTO public.users VALUES (37, 'Vijay Iyer', 'vijayiyer@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 2, 'Doc_10', true, '15:36:38.248111');
INSERT INTO public.users VALUES (38, 'Usha Shukla', 'ushashukla@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 3, 'Doc_11', true, '15:38:49.742536');
INSERT INTO public.users VALUES (39, 'Sarala Rajajee', 'saralarajajee@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 3, 'Doc_12', true, '15:48:30.22789');
INSERT INTO public.users VALUES (40, 'Parthasarathy Srinivasan', 'parthasarathy@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 3, 'Doc_13', true, '15:49:27.060239');
INSERT INTO public.users VALUES (41, 'K Kalai Selvi', 'kalaiselvi@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 3, 'Doc_14', true, '15:51:40.72794');
INSERT INTO public.users VALUES (42, 'S Jayaraman', 'jayaraman@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 3, 'Doc_15', true, '15:52:42.953132');
INSERT INTO public.users VALUES (44, 'Balaji J', 'balajij@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 4, 'Doc_17', true, '15:54:40.46253');
INSERT INTO public.users VALUES (45, 'Murugesh DMRT', 'murugesh@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 4, 'Doc_18', true, '15:56:17.651105');
INSERT INTO public.users VALUES (46, 'Mohammed Ibrahim', 'mohammedibrahim@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 4, 'Doc_19', true, '15:57:26.370248');
INSERT INTO public.users VALUES (47, 'Aravindan Selvaraj', 'aravindanselvaraj@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 5, 'Doc_20', true, '15:58:45.623112');
INSERT INTO public.users VALUES (35, 'Kumar Thulasi Dass', 'thulasidass@gmail.com', '123456', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 2, 'Doc_8', true, '16:16:03.452535');
INSERT INTO public.users VALUES (59, 'Doctor Assistant', 'docassistant2@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 1, NULL, NULL, NULL);
INSERT INTO public.users VALUES (48, 'Bala Murali', 'balamurali@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 5, 'Doc_21', true, '15:59:35.223995');
INSERT INTO public.users VALUES (49, 'Raghavan Subramaniyan', 'raghavansubramaniyan@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 6, 'Doc_22', true, '16:01:30.394299');
INSERT INTO public.users VALUES (50, 'Anto Sahayaraj', 'antosahayaraj@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 6, 'Doc_23', true, '16:02:31.236272');
INSERT INTO public.users VALUES (51, 'Sowmya Ramanan V', 'sowmyaramananv@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 6, 'Doc_24', true, '16:03:37.305415');
INSERT INTO public.users VALUES (52, 'Balaji Srimurugan', 'balajisrimurugan@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 6, 'Doc_25', true, '16:04:43.54432');


--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 200
-- Name: account_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_account_id_seq', 1, false);


--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 201
-- Name: patient_login_patient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_login_patient_id_seq', 159, true);


--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 204
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 11, true);


--
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 202
-- Name: player_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.player_id_seq', 28, true);


--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 206
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_permissions_id_seq', 9, true);


--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 203
-- Name: roles_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_roles_id_seq', 1, false);


--
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 208
-- Name: user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_role_id_seq', 35, true);


--
-- TOC entry 3727 (class 2606 OID 16701)
-- Name: account account_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_id PRIMARY KEY (account_id);


--
-- TOC entry 3729 (class 2606 OID 16705)
-- Name: patient patient_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_id PRIMARY KEY (patient_id);


--
-- TOC entry 3738 (class 2606 OID 24616)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3742 (class 2606 OID 24624)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3731 (class 2606 OID 16707)
-- Name: roles roles_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_id PRIMARY KEY (roles_id);


--
-- TOC entry 3744 (class 2606 OID 24742)
-- Name: user_role user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (id);


--
-- TOC entry 3734 (class 2606 OID 16709)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3736 (class 2606 OID 16711)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3739 (class 1259 OID 24754)
-- Name: fki_permissionId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_permissionId" ON public.role_permissions USING btree ("permissionId");


--
-- TOC entry 3740 (class 1259 OID 24748)
-- Name: fki_roleId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_roleId" ON public.role_permissions USING btree ("roleId");


--
-- TOC entry 3732 (class 1259 OID 16713)
-- Name: fki_user_to_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_user_to_account ON public.users USING btree (account_id);


--
-- TOC entry 3747 (class 2606 OID 24749)
-- Name: role_permissions permissionId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "permissionId" FOREIGN KEY ("permissionId") REFERENCES public.permissions(id) NOT VALID;


--
-- TOC entry 3746 (class 2606 OID 24743)
-- Name: role_permissions roleId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "roleId" FOREIGN KEY ("roleId") REFERENCES public.roles(roles_id) NOT VALID;


--
-- TOC entry 3745 (class 2606 OID 16719)
-- Name: users user_to_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_to_account FOREIGN KEY (account_id) REFERENCES public.account(account_id) NOT VALID;


--
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2020-07-31 19:23:53

--
-- PostgreSQL database dump complete
--


--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5
-- Dumped by pg_dump version 13.2

-- Started on 2021-06-21 18:59:27

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- TOC entry 202 (class 1259 OID 18241)
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
-- TOC entry 203 (class 1259 OID 18244)
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
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 203
-- Name: account_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_account_id_seq OWNED BY public.account.account_id;


--
-- TOC entry 204 (class 1259 OID 18246)
-- Name: patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient (
    patient_id integer NOT NULL,
    phone character varying(100) NOT NULL,
    password character varying(200),
    salt character varying(100),
    "createdBy" character varying(100),
    passcode character varying(100),
    time_zone character varying(20) DEFAULT '+05:30'::character varying NOT NULL
);


ALTER TABLE public.patient OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 18252)
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
-- TOC entry 3903 (class 0 OID 0)
-- Dependencies: 205
-- Name: patient_login_patient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_login_patient_id_seq OWNED BY public.patient.patient_id;


--
-- TOC entry 206 (class 1259 OID 18254)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying,
    description character varying
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 18260)
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
-- TOC entry 3904 (class 0 OID 0)
-- Dependencies: 207
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- TOC entry 208 (class 1259 OID 18262)
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
-- TOC entry 209 (class 1259 OID 18264)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    id integer NOT NULL,
    "roleId" integer,
    "permissionId" integer
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 18267)
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
-- TOC entry 3905 (class 0 OID 0)
-- Dependencies: 210
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- TOC entry 211 (class 1259 OID 18269)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    roles_id integer NOT NULL,
    roles character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 18272)
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
-- TOC entry 3906 (class 0 OID 0)
-- Dependencies: 212
-- Name: roles_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_roles_id_seq OWNED BY public.roles.roles_id;


--
-- TOC entry 213 (class 1259 OID 18274)
-- Name: user_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_role (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint
);


ALTER TABLE public.user_role OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 18277)
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
-- TOC entry 3907 (class 0 OID 0)
-- Dependencies: 214
-- Name: user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_role_id_seq OWNED BY public.user_role.id;


--
-- TOC entry 215 (class 1259 OID 18279)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    name character varying(250) NOT NULL,
    email character varying(250) NOT NULL,
    password character varying(250) NOT NULL,
    salt character varying(250),
    account_id bigint,
    doctor_key character varying(200),
    is_active boolean,
    updated_time time without time zone,
    passcode character varying(100),
    id integer NOT NULL,
    time_zone character varying(20) DEFAULT '+05:30'::character varying NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 18285)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3908 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3724 (class 2604 OID 18287)
-- Name: account account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account ALTER COLUMN account_id SET DEFAULT nextval('public.account_account_id_seq'::regclass);


--
-- TOC entry 3725 (class 2604 OID 18288)
-- Name: patient patient_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient ALTER COLUMN patient_id SET DEFAULT nextval('public.patient_login_patient_id_seq'::regclass);


--
-- TOC entry 3727 (class 2604 OID 18289)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3728 (class 2604 OID 18290)
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- TOC entry 3729 (class 2604 OID 18291)
-- Name: roles roles_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN roles_id SET DEFAULT nextval('public.roles_roles_id_seq'::regclass);


--
-- TOC entry 3730 (class 2604 OID 18292)
-- Name: user_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role ALTER COLUMN id SET DEFAULT nextval('public.user_role_id_seq'::regclass);


--
-- TOC entry 3731 (class 2604 OID 18293)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3881 (class 0 OID 18241)
-- Dependencies: 202
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (1, 2, '2021-06-09', '2022-06-30', 'Acc_1', 'Lamfer healthcare', NULL, NULL, true);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (2, 0, '2021-06-10', '2021-06-10', 'Acc_2', 'kalyani hospitals', '2021-06-10 16:03:29.334', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (3, 0, '2021-06-10', '2021-06-10', 'Acc_3', 'kalyani hospitals', '2021-06-10 16:18:25.981', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (4, 0, '2021-06-10', '2021-06-10', 'Acc_4', 'manikandhan ', '2021-06-10 17:10:08.716', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (5, 0, '2021-06-11', '2021-06-11', 'Acc_5', 'Helth care Hospitals', '2021-06-11 13:43:37.831', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (6, 0, '2021-06-11', '2021-06-11', 'Acc_6', 'ABC', '2021-06-11 14:11:42.866', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (7, 0, '2021-06-11', '2021-06-11', 'Acc_7', 'asd', '2021-06-11 15:34:17.487', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (8, 0, '2021-06-11', '2021-06-11', 'Acc_8', 'JKL', '2021-06-11 15:54:50.919', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (9, 0, '2021-06-11', '2021-06-11', 'Acc_9', 'apollo', '2021-06-11 16:31:19.879', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (10, 0, '2021-06-11', '2021-06-11', 'Acc_10', 'apollo', '2021-06-11 16:37:58.605', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (11, 0, '2021-06-11', '2021-06-11', 'Acc_11', 'Teja hospitals', '2021-06-11 16:42:03.727', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (12, 0, '2021-06-11', '2021-06-11', 'Acc_12', 'dsadsadsa', '2021-06-11 16:46:08.955', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (13, 0, '2021-06-11', '2021-06-11', 'Acc_13', 'apollo', '2021-06-11 16:49:16.697', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (14, 0, '2021-06-11', '2021-06-11', 'Acc_14', 'dsadsadsa', '2021-06-11 18:39:57.663', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (15, 0, '2021-06-15', '2021-06-15', 'Acc_15', 'apollo', '2021-06-15 15:10:01.178', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (16, 0, '2021-06-15', '2021-06-15', 'Acc_16', 'apollo', '2021-06-15 15:10:10.541', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (17, 0, '2021-06-15', '2021-06-15', 'Acc_17', 'Deactivated Clinic', '2021-06-15 16:44:05.94', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (18, 0, '2021-06-15', '2021-06-15', 'Acc_18', 'apollo', '2021-06-15 21:21:22.852', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (19, 0, '2021-06-16', '2021-06-16', 'Acc_19', '', '2021-06-16 01:48:46.136', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (20, 0, '2021-06-16', '2021-06-16', 'Acc_20', '', '2021-06-16 01:49:09.446', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (21, 0, '2021-06-16', '2021-06-16', 'Acc_21', '', '2021-06-16 01:49:17.569', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (22, 0, '2021-06-16', '2021-06-16', 'Acc_22', 'Invalid_Hospital2', '2021-06-16 09:08:07.005', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (23, 0, '2021-06-16', '2021-06-16', 'Acc_23', 'Invalid_Hospital2', '2021-06-16 09:08:44.39', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (24, 0, '2021-06-16', '2021-06-16', 'Acc_24', 'Appollo1', '2021-06-16 15:41:00.317', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (25, 0, '2021-06-17', '2021-06-17', 'Acc_25', 'Apollo', '2021-06-17 12:24:08.271', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (26, 0, '2021-06-17', '2021-06-17', 'Acc_26', 'apollo', '2021-06-17 14:07:24.904', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (27, 0, '2021-06-17', '2021-06-17', 'Acc_27', '', '2021-06-17 14:11:49.612', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (28, 0, '2021-06-17', '2021-06-17', 'Acc_28', '', '2021-06-17 14:11:59.442', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (29, 0, '2021-06-17', '2021-06-17', 'Acc_29', '', '2021-06-17 14:12:13.576', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (30, 0, '2021-06-17', '2021-06-17', 'Acc_30', 'apollo', '2021-06-17 14:12:28.321', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (31, 0, '2021-06-17', '2021-06-17', 'Acc_31', 'laxmi hospitals', '2021-06-17 14:55:02', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (32, 0, '2021-06-17', '2021-06-17', 'Acc_32', 'hosp1', '2021-06-17 15:05:32.886', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (33, 0, '2021-06-18', '2021-06-18', 'Acc_33', 'Deactivated Clinic', '2021-06-18 13:23:14.116', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (34, 0, '2021-06-18', '2021-06-18', 'Acc_34', 'arul hospitals', '2021-06-18 08:50:24.298', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (35, 0, '2021-06-18', '2021-06-18', 'Acc_35', 'arul hospitals', '2021-06-18 08:51:17.159', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (36, 0, '2021-06-18', '2021-06-18', 'Acc_36', 'arul hospitals', '2021-06-18 08:51:18.496', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (37, 0, '2021-06-18', '2021-06-18', 'Acc_37', 'arul hospitals', '2021-06-18 08:51:39.224', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (38, 0, '2021-06-18', '2021-06-18', 'Acc_38', 'apollo', '2021-06-18 14:31:24.268', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (39, 0, '2021-06-18', '2021-06-18', 'Acc_39', 'apollo', '2021-06-18 09:09:45.884', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (40, 0, '2021-06-18', '2021-06-18', 'Acc_40', 'apollo', '2021-06-18 09:09:56.002', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (41, 0, '2021-06-18', '2021-06-18', 'Acc_41', 'Appollo', '2021-06-18 09:13:07.311', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (42, 0, '2021-06-18', '2021-06-18', 'Acc_42', 'Kumar Hospital', '2021-06-18 15:25:22.812', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (43, 0, '2021-06-18', '2021-06-18', 'Acc_43', 'arul hospital', '2021-06-18 10:36:53.166', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (44, 0, '2021-06-18', '2021-06-18', 'Acc_44', 'apollo', '2021-06-18 10:44:15.192', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (45, 0, '2021-06-18', '2021-06-18', 'Acc_45', 'Laxmi', '2021-06-18 22:35:01.023', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (46, 0, '2021-06-18', '2021-06-18', 'Acc_46', 'Krishna', '2021-06-18 22:37:38.524', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (47, 0, '2021-06-19', '2021-06-19', 'Acc_47', 'apollo', '2021-06-19 05:54:06.424', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (48, 0, '2021-06-19', '2021-06-19', 'Acc_48', 'apollo', '2021-06-19 05:54:53.034', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (49, 0, '2021-06-19', '2021-06-19', 'Acc_49', 'munna clicnic', '2021-06-19 12:21:27.961', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (50, 0, '2021-06-19', '2021-06-19', 'Acc_50', 'Kauvery Hospital', '2021-06-19 20:44:46.715', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (51, 0, '2021-06-19', '2021-06-19', 'Acc_51', 'Kumar Hospital', '2021-06-19 20:13:47.709', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (52, 0, '2021-06-19', '2021-06-19', 'Acc_52', 'Appollo', '2021-06-19 20:15:20.579', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (53, 0, '2021-06-19', '2021-06-19', 'Acc_53', 'Appollo', '2021-06-19 20:16:08.824', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (54, 0, '2021-06-20', '2021-06-20', 'Acc_54', 'Siva clinic', '2021-06-20 09:02:12.34', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (55, 0, '2021-06-20', '2021-06-20', 'Acc_55', 'apollo', '2021-06-20 15:00:35.317', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (56, 0, '2021-06-20', '2021-06-20', 'Acc_56', 'apollo', '2021-06-20 15:00:46.943', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (57, 0, '2021-06-21', '2021-06-21', 'Acc_57', 'Cardiologist', '2021-06-21 13:06:24.631', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (58, 0, '2021-06-21', '2021-06-21', 'Acc_58', 'Kumar', '2021-06-21 13:09:18.564', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (59, 0, '2021-06-21', '2021-06-21', 'Acc_59', 'Softsuave', '2021-06-21 16:50:48.572', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (60, 0, '2021-06-22', '2021-06-22', 'Acc_60', 'apollo', '2021-06-22 10:08:55.254', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (61, 0, '2021-06-23', '2021-06-23', 'Acc_61', 'Apollo', '2021-06-23 08:48:26.421', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (62, 0, '2021-06-23', '2021-06-23', 'Acc_62', 'Apollo', '2021-06-23 09:29:43.749', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (63, 0, '2021-06-24', '2021-06-24', 'Acc_63', 'apollo', '2021-06-24 11:48:13.435', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (64, 0, '2021-06-25', '2021-06-25', 'Acc_64', 'apollo', '2021-06-25 11:28:01.387', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (65, 0, '2021-06-29', '2021-06-29', 'Acc_65', 'Apollo', '2021-06-29 08:46:17.847', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (66, 0, '2021-07-02', '2021-07-02', 'Acc_66', '', '2021-07-02 11:08:58.735', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (67, 0, '2021-07-02', '2021-07-02', 'Acc_67', '', '2021-07-02 11:09:50.287', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (68, 0, '2021-07-02', '2021-07-02', 'Acc_68', '', '2021-07-02 11:09:57.323', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (69, 0, '2021-07-02', '2021-07-02', 'Acc_69', '', '2021-07-02 11:10:05.943', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (70, 0, '2021-07-03', '2021-07-03', 'Acc_70', 'apollo', '2021-07-03 10:06:34.223', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (71, 0, '2021-07-07', '2021-07-07', 'Acc_71', 'qwert', '2021-07-07 18:11:44.999', NULL, false);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (72, 0, '2021-07-12', '2021-07-12', 'Acc_72', '', '2021-07-12 06:54:02.73', NULL, false);


--
-- TOC entry 3883 (class 0 OID 18246)
-- Dependencies: 204
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (1, '8682866222', '$2b$10$WLNIBYD6daNIrQ42i77H5OxkhyHuL4anwSf8mnik0TtWI4T1IT1h2', '$2b$10$WLNIBYD6daNIrQ42i77H5O', 'DOCTOR', '6837', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (5, '1112221112', '$2b$10$Z89sYOpLhdRB1AVSTdIZlubDd5qGUYiptIWKggbV5LQih.JBtali6', '$2b$10$Z89sYOpLhdRB1AVSTdIZlu', 'DOCTOR', '9147', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (6, '1251251254', '$2b$10$id2RcojOLTsXzg6gIJr0uOIRb93LjlzwcCfcMsC8jWPpsWyfSDPvC', '$2b$10$id2RcojOLTsXzg6gIJr0uO', 'ADMIN', '3147', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (7, '4567654567', '$2b$10$8hnpLCu12LXr5.p9xQNm6eR0xcha9CZNPggIcCp3VsIPVTdWE77lu', '$2b$10$8hnpLCu12LXr5.p9xQNm6e', 'ADMIN', '8560', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (32, '5678923458', '$2b$10$GawyupiOijqnACyvmUsAIecfn7p8CbGImU5B0scLnOnKCOxAolAkO', '$2b$10$GawyupiOijqnACyvmUsAIe', 'PATIENT', '3456', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (8, '9940411049', '$2b$10$VkyWYMgZiozGi7ReI.kss.04C4w18obybfixQaUuE7n/DAN55yLjS', '$2b$10$VkyWYMgZiozGi7ReI.kss.', 'PATIENT', '3930', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (4, '1251251253', '$2b$10$jldsQ8wwLfiveF5uq.yRHO7VAy4vHH0byFUaFvhbBzZVbKzWL.joO', '$2b$10$jldsQ8wwLfiveF5uq.yRHO', 'PATIENT', '2102', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (10, '4354644565', '$2b$10$rNl4JLJ9GBBT5oWXFlCMS.zuD3njG6OyTepR7HJ0GCgctx9rTNH8u', '$2b$10$rNl4JLJ9GBBT5oWXFlCMS.', 'PATIENT', '5413', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (11, '1111111111', '$2b$10$4pDDUPO4TXc6R7P7TdtihuFqN6JgszCrOKiiaxuXZggJWnFck6quu', '$2b$10$4pDDUPO4TXc6R7P7Tdtihu', 'PATIENT', '1843', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (12, '1111111112', '$2b$10$1QsGCltAu4k1ubFVYMJSDerhw298nJEmIm3YVB5J81tGdzDnuU2Nq', '$2b$10$1QsGCltAu4k1ubFVYMJSDe', 'PATIENT', '9904', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (13, '1231231231', '$2b$10$Z7C3O2lW7rn/75zRD4VXyeYMIHEc92vSgaeTQWFeftCG0QGUUJ76q', '$2b$10$Z7C3O2lW7rn/75zRD4VXye', 'PATIENT', '8083', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (14, '6360254461', '$2b$10$Bbfk7PuL2W8M1nv0QhMKA.4i5oK5P.psDCYlJUKy4PlsvYDLUA8Hq', '$2b$10$Bbfk7PuL2W8M1nv0QhMKA.', 'PATIENT', '5307', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (15, '6360254462', '$2b$10$fO9pt90bv1pesCslY3ud8uadHdIuIhI4kBpzGFU7ZDtQT6m.WuMv6', '$2b$10$fO9pt90bv1pesCslY3ud8u', 'PATIENT', '9146', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (16, '1251251256', '$2b$10$imFNtaFPv1TqX4uPNAF5eeUZRFg55RoQSaHzOQ5Nt07s91amtnL.q', '$2b$10$imFNtaFPv1TqX4uPNAF5ee', 'PATIENT', '5302', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (18, '4566544566', '$2b$10$XV/LSYWhAG3Pph9EM.hA4.LSS/rRB/ix43kuUiPWFr7vBm1cDKyGu', '$2b$10$XV/LSYWhAG3Pph9EM.hA4.', 'PATIENT', '7188', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (25, '6789012345', '$2b$10$S0q5MpeOLMpqx8dCOhrqjeCHEmXQyDnFXKeoao6CJU7SgXqAsdbgS', '$2b$10$S0q5MpeOLMpqx8dCOhrqje', 'PATIENT', '8437', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (19, '4566544566', '$2b$10$rXupDm2BIrkIDKMQ5oE/TO4aC/c4CjLpcgmHkTUgIbujFnOfwCQwC', '$2b$10$rXupDm2BIrkIDKMQ5oE/TO', 'PATIENT', '6052', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (20, '4566544566', '$2b$10$vIZ9lVPpKAnQ4gc2beLb9OIAOAi808SZAODPAKo/Bb3IFd3hAj6b.', '$2b$10$vIZ9lVPpKAnQ4gc2beLb9O', 'PATIENT', '9324', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (21, '4566544566', '$2b$10$uNHoVh93/Q4GpVW7ckKVVOxKSTAPB/EGm5FpspYbVayoRxA11uUHu', '$2b$10$uNHoVh93/Q4GpVW7ckKVVO', 'PATIENT', '2468', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (22, '4566544566', '$2b$10$dq73R52rz9eKhIE/TpvkueZMEeBiNwHCgKVB5LgrYp.v9FdFG1co.', '$2b$10$dq73R52rz9eKhIE/Tpvkue', 'PATIENT', '7804', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (24, '3425432543', '$2b$10$smoC7rGjHFxPqP5.5OsZs.rBzLRy2wnIxinLG62hdi4vTsOzsBPVy', '$2b$10$smoC7rGjHFxPqP5.5OsZs.', 'PATIENT', '7126', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (38, '8568568563', '$2b$10$.ZsAR.qw6KmdS4IRjVCct.qC7tus0KAq6y2B0KCgXmZ1cBgGHlS/C', '$2b$10$.ZsAR.qw6KmdS4IRjVCct.', 'PATIENT', '7328', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (3, '9884142042', '$2b$10$Mc8YToHv7gMNMrkIplBQn.tFlxDb1PQcKfc/tnXrEJZm1K7bp.km2', '$2b$10$Mc8YToHv7gMNMrkIplBQn.', 'PATIENT', '8683', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (33, '8754580078', '$2b$10$VlVwEeieGXa2bz/nBrvnpugD0JWQaB5/DnRs5HnKRjbMdbErH0xDa', '$2b$10$VlVwEeieGXa2bz/nBrvnpu', '{"ADMIN","DOCTOR"}', '3823', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (9, '9940411049', '$2b$10$aUjDKaNyc0pZHtqGspKY8OW490Nw9uDzz2FEsr9qWVmCZSGcgpBla', '$2b$10$aUjDKaNyc0pZHtqGspKY8O', 'PATIENT', '7934', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (34, '6789012323', '$2b$10$UUJ4D3AaE5QNSc6PQlt4BuwGC6/FNWR52V7uRir5wqsJsJXqUpRSG', '$2b$10$UUJ4D3AaE5QNSc6PQlt4Bu', '{"ADMIN","DOCTOR"}', '4748', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (35, '1452145212', '$2b$10$SH15v9UH8yD346DRtb3s/.wOEj6BcZDlgCOKFP6llOUShcWncQ3L6', '$2b$10$SH15v9UH8yD346DRtb3s/.', 'PATIENT', '9571', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (36, '6360254468', '$2b$10$90FXzuqLX3bYEoPFXMq7DOSuM2X1Udf57S040czgLVV1qr1oe7s8.', '$2b$10$90FXzuqLX3bYEoPFXMq7DO', 'PATIENT', '4751', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (23, '7897897895', '$2b$10$1hQg0KGiB3rAsoZ5b9bse.OtIMbWq8cC7RL78ogVLVGLXrQmnzxAS', '$2b$10$1hQg0KGiB3rAsoZ5b9bse.', 'PATIENT', '2847', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (26, '1471471471', '$2b$10$tStQMBtNNhxY2z5ifwYure5UUnR2WF25elL/jfWPDzX48R59Obqn6', '$2b$10$tStQMBtNNhxY2z5ifwYure', 'PATIENT', '7201', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (27, '1471471473', '$2b$10$w5JTdLGDZik5R6RRkx47ueVszlRiHnTEFySOiM0gcrMKisnkjgz1y', '$2b$10$w5JTdLGDZik5R6RRkx47ue', 'PATIENT', '3492', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (28, '4894894899', '$2b$10$X87mnyvQYWinOgwtrHkq0eSr6s4lJSXEf7LWqpawqHLy/fwx4nbQC', '$2b$10$X87mnyvQYWinOgwtrHkq0e', 'PATIENT', '4940', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (29, '8885310103', '$2b$10$wretKBQJ67/c66wZ0T90QOmO8M7H4Ghh6bnm5Y7QbU50M/qfTCNP2', '$2b$10$wretKBQJ67/c66wZ0T90QO', 'PATIENT', '9657', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (30, '9849770995', '$2b$10$NRSQ/CHymL3l.IrMs01WHe5YeBf5xqxsq32vmBCl6VBYd0TQwIEpq', '$2b$10$NRSQ/CHymL3l.IrMs01WHe', 'PATIENT', '2093', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (31, '5678923456', '$2b$10$Q4vYQfV4AUd0cVRrIi8NcuCPdinbxs/kqJEO7CLIzMQPE6E0LOlTW', '$2b$10$Q4vYQfV4AUd0cVRrIi8Ncu', 'PATIENT', '6577', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (37, '4564564566', '$2b$10$xhanYkq9kXLWhv7vBuq3DOwt4v4ZeBpqWmAZwCTkCKP/ZF0zqrHbC', '$2b$10$xhanYkq9kXLWhv7vBuq3DO', '{"DOCTOR"}', '5506', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (17, '4566544566', '$2b$10$k.JZNS3Mk4lwjTMtb2l6/uyXsOn34x8wB3uNZ3pZczAuh/NpypS/y', '$2b$10$k.JZNS3Mk4lwjTMtb2l6/u', 'PATIENT', '8512', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (39, '8568568562', '$2b$10$TMft0hNh5ggFuQSWljPi0u2HYkCElKQYaTI.gAU2bYv1ck4VGB/EO', '$2b$10$TMft0hNh5ggFuQSWljPi0u', 'PATIENT', '6833', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (41, '9791036048', '$2b$10$IEiXUH.zGRUfBLwSyeZy5.raDpsbcGWUew8NT6sCh5c9gSXnzYUqS', '$2b$10$IEiXUH.zGRUfBLwSyeZy5.', 'PATIENT', '3992', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (42, '9791036050', '$2b$10$lOJio/tEO.f.ORZ9ZgziKutq/oJPxse5VvnpX28OCe7Whedz412ZK', '$2b$10$lOJio/tEO.f.ORZ9ZgziKu', 'PATIENT', '9217', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (43, '9840981049', '$2b$10$o/PYaqVZZgsx1TBaCzvsIuMfLlro.9VBwvjFbIkUBYsKdfo5BUoOC', '$2b$10$o/PYaqVZZgsx1TBaCzvsIu', 'PATIENT', '5918', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (44, '9840880049', '$2b$10$E0CDB7estDrrcx/PkyzXIunCBzTUhNPYMRBaecZf3m0xRKiwwBk.O', '$2b$10$E0CDB7estDrrcx/PkyzXIu', 'PATIENT', '7612', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (45, '1234566543', '$2b$10$UiBew6WBDVAGiVqlOr1VY.lGyQuNMg6L8Sb3pd8YE4nsKW4ZxkVQi', '$2b$10$UiBew6WBDVAGiVqlOr1VY.', 'DOCTOR', '6538', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (46, '1245214512', '$2b$10$PT66dYT.Gpd4zNA7rzTU5e5IL55oc/w2EC2V3H5nes2/Bgpbx/BoO', '$2b$10$PT66dYT.Gpd4zNA7rzTU5e', 'DOCTOR', '4788', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (47, '9840104658', '$2b$10$lFq4PyPw7yhM1TaYxldhxeuScDTdkmi61rFQkPLbQUUn.riA1xjN6', '$2b$10$lFq4PyPw7yhM1TaYxldhxe', 'PATIENT', '7369', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (48, '9876543210', '$2b$10$OVEri1JKhvAfdNnbTm9On.H3UlAZuZrpzuii.cuqLgRjCqz1c7/wO', '$2b$10$OVEri1JKhvAfdNnbTm9On.', 'PATIENT', '1548', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (49, '9884618743', '$2b$10$lptBm0DaEiGjfWIFjtR7yuNel.5fxcz3tZvmFoT9ViIi4ZAwZuN8W', '$2b$10$lptBm0DaEiGjfWIFjtR7yu', 'PATIENT', '8508', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (50, '1234567890', '$2b$10$wbqL7hNf7CMKrc99sd3IQOtM9PIyXsLL9N8jZFvGONXhkIR6AD1O.', '$2b$10$wbqL7hNf7CMKrc99sd3IQO', 'PATIENT', '2774', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (51, '1251251259', '$2b$10$GWSwiEzA4V5/CoVXZucvB.g6xbPuJe9LSLspYub7ljb41Gqwu8cfm', '$2b$10$GWSwiEzA4V5/CoVXZucvB.', 'PATIENT', '2764', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (52, '3453453450', '$2b$10$CV25Yx.a98CX6Xoog6cG7Of.GrDfq83GQlpdapGi5Bpyc58JwXXje', '$2b$10$CV25Yx.a98CX6Xoog6cG7O', 'PATIENT', '1646', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (40, '9791036049', '$2b$10$ro38IVYl9FKtWLf/OZQYoOnD9W5eNmuj2qCyCbluZTqQuJWAJ7MPK', '$2b$10$ro38IVYl9FKtWLf/OZQYoO', 'PATIENT', '4086', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (2, '6360254465', '$2b$10$5stCwHSKUOccAPQBGYxlsOI7ZBC8FKSYDtlbACcGXEQ2bnldEigK.', '$2b$10$5stCwHSKUOccAPQBGYxlsO', 'PATIENT', '6890', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (53, '9519519510', '$2b$10$oiJk6d4m8emt6bzjkLxukePEakxHppSZTY5C2UKnv8tC7r/EndktC', '$2b$10$oiJk6d4m8emt6bzjkLxuke', 'PATIENT', '1073', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (54, '3213213210', '$2b$10$BWkgtIF36VfsSfM5zD2AV.LJoQtKtR7aEOoeSRlyRzLZ4ZhR7pOpW', '$2b$10$BWkgtIF36VfsSfM5zD2AV.', 'PATIENT', '6148', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (56, '1112223330', '$2b$10$yPewj32dOqI5uwE2vuBuy.qy1wci884C6BC3tVTm926H8odRiorWO', '$2b$10$yPewj32dOqI5uwE2vuBuy.', 'PATIENT', '1857', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (57, '2255882580', '$2b$10$YHiyOvPnVu6smt5sG8Uvxul3X3hxA2FU9JpU8YhUWb/KHQm2cNM/.', '$2b$10$YHiyOvPnVu6smt5sG8Uvxu', 'PATIENT', '3146', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (58, '1234560000', '$2b$10$CVUbQxEn6kyKZv6YE0j2IO5pZUhcaBx.ijQoSrHDLiWUwEiVsIuv6', '$2b$10$CVUbQxEn6kyKZv6YE0j2IO', 'PATIENT', '8683', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (59, '4584584589', '$2b$10$wFlMoaUc59zceMG2yR/dEe5x6pIk9Z7x5HqkmAuI7CFEjhKrrXWHa', '$2b$10$wFlMoaUc59zceMG2yR/dEe', 'PATIENT', '4680', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (86, '6360254469', '$2b$10$drFthvyFNT7SP/Zn0424yuHvfblP/6uauwWqhrrWh8hYiNq/2Rtua', '$2b$10$drFthvyFNT7SP/Zn0424yu', 'PATIENT', '9852', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (60, '6665554440', '$2b$10$3vJ.QNFYIMO0Iw/9vZc/YOcX.2q7FHbBg.SGCWMp6cH/oQNUi6Y0e', '$2b$10$3vJ.QNFYIMO0Iw/9vZc/YO', 'PATIENT', '7100', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (61, '4584584584', '$2b$10$e1umN5eH9iUk.8RoPdofKuBcCKdHwp5k6J4ViHVlMygEg08ILnl66', '$2b$10$e1umN5eH9iUk.8RoPdofKu', 'DOCTOR', '5478', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (62, '4584584585', '$2b$10$470bWJKAP3.5A1fDusQKROYPxAgI4lI/la5InxR.VzzjQlRGazZaW', '$2b$10$470bWJKAP3.5A1fDusQKRO', 'DOCTOR', '7716', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (63, '1234512345', '$2b$10$nC4xihzV862XVjshaK/nO.9QOdQ.HpFQJTS0Z8lVspSWHC6IcVnH6', '$2b$10$nC4xihzV862XVjshaK/nO.', 'DOCTOR', '8133', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (64, '4444444444', '$2b$10$7SqK74TlBqlopprbkNHk0eAaUQg5yBgkQEGUKwodV0WNEFxF124LG', '$2b$10$7SqK74TlBqlopprbkNHk0e', 'PATIENT', '5018', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (65, '8965312099', '$2b$10$ZWDLp198z1DlWaZOeilxQe4adcN/TTk3lLZK5fBcTftKSUFtlNN3G', '$2b$10$ZWDLp198z1DlWaZOeilxQe', 'PATIENT', '2832', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (66, '5435435435', '$2b$10$QuwCfMZ8L2AcnQffzAC/suVoqvWQ4MxtyDECpTwwIG2a1EkaFUI2q', '$2b$10$QuwCfMZ8L2AcnQffzAC/su', 'DOCTOR', '4648', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (68, '2343243432', '$2b$10$0Un8JeITu.OiXeu.KejY6eBjgRMS/PXCPxhYlvFiqQAykoeW5xpEu', '$2b$10$0Un8JeITu.OiXeu.KejY6e', 'PATIENT', '6489', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (69, '3213213211', '$2b$10$9fKQ6xXYVrHPJfQp3wCGne8oSk3xAQviOIQo1YfQoXqI3xHbGzGRq', '$2b$10$9fKQ6xXYVrHPJfQp3wCGne', 'PATIENT', '3055', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (93, '1234567895', '$2b$10$Fy0ZEhOUQ202GQLxyVEYxOovySm05hZqfgHX3sjnjXlSaEy5eJ3zW', '$2b$10$Fy0ZEhOUQ202GQLxyVEYxO', 'DOCTOR', '6156', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (73, '4564564564', '$2b$10$uHKdy5YCnb2FjatM4pI9eOuZ8bYRuYt.KY4RddeDViTON0Lh7EVfK', '$2b$10$uHKdy5YCnb2FjatM4pI9eO', 'PATIENT', '9048', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (55, '3332221110', '$2b$10$NNS.tmT2JYuTniLZYKD9ZOba/a93xbHUypDW7H56x.S2aM4XY.yq6', '$2b$10$NNS.tmT2JYuTniLZYKD9ZO', 'PATIENT', '8646', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (74, '1234567891', '$2b$10$4Ngg3GcHKq.CgXhZOSo8mOON/NS44q7jVUYfysxR6Z2A02t4bjLP6', '$2b$10$4Ngg3GcHKq.CgXhZOSo8mO', 'PATIENT', '6423', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (70, '3453456783', '$2b$10$2FG.EZg41rWjek7K6QuOk.whtXR5f03dRLGrm4pUnSiwcJ3G..tE.', '$2b$10$2FG.EZg41rWjek7K6QuOk.', 'DOCTOR', '5542', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (71, '4747474747', '$2b$10$.VpIrAv6hMuqOVyv/hWrSubzAqikWF5hV8Pz/vQ2/XzY9mCPW5nIa', '$2b$10$.VpIrAv6hMuqOVyv/hWrSu', 'DOCTOR', '6523', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (75, '1234567811', '$2b$10$gFMxZCDN0Ldx9KdgeDENRePAWpAAZzYiirxVU2y4vyeLWjanydOrS', '$2b$10$gFMxZCDN0Ldx9KdgeDENRe', 'PATIENT', '5806', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (72, '5656565656', '$2b$10$LHxvvbxe83GPDT90CMIWq.NbVyViaa4c3JR5ljUALXSbsEvMbUlZi', '$2b$10$LHxvvbxe83GPDT90CMIWq.', 'PATIENT', '6620', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (87, '8885310102', '$2b$10$3LCcgwhfbKEnmBcORoEQiuBenG/6mprxYOGyUWz/jganhGAgmySku', '$2b$10$3LCcgwhfbKEnmBcORoEQiu', 'PATIENT', '7432', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (76, '3453453459', '$2b$10$zY.OXtyBa52qIYv/jI9a4ObCqw7skpNT4NX02xMcdZbGjjfijE9Y2', '$2b$10$zY.OXtyBa52qIYv/jI9a4O', 'DOCTOR', '7415', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (77, '4234235645', '$2b$10$zNZKmstUuy5JVnshyrEPr.UmKaIDrqz7dhXVjnMbfwc9BaphuvhH.', '$2b$10$zNZKmstUuy5JVnshyrEPr.', 'PATIENT', '8930', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (79, '1421421422', '$2b$10$R.mcd3St/48qTCxpPLvBRekgeyGtWb0wletrqpdb/8M8tAl21/erq', '$2b$10$R.mcd3St/48qTCxpPLvBRe', 'DOCTOR', '7154', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (80, '1235612356', '$2b$10$yZ/TlAUZockDuWPf0igRb.fLgbIwCLt/6HJq.8JYfb08NVZz313X6', '$2b$10$yZ/TlAUZockDuWPf0igRb.', 'DOCTOR', '6684', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (81, '1451451475', '$2b$10$f9M5QM0yLlQBTOyWxpdr5ugNdhfUksyQ3enhYX/Jg70PYpGgcEzOC', '$2b$10$f9M5QM0yLlQBTOyWxpdr5u', 'DOCTOR', '6241', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (82, '1471471474', '$2b$10$1fSknckB8Ct5VAfNfiaoKeYyz1qOnCQKMqQBC/iO1gQHm/E1cg8r2', '$2b$10$1fSknckB8Ct5VAfNfiaoKe', 'DOCTOR', '4070', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (83, '1421421421', '$2b$10$TjN5GhO8GtEEQ9JmXpI2cu96Al8OMj.BQ0zITXlLy3fhiC4Ifg75q', '$2b$10$TjN5GhO8GtEEQ9JmXpI2cu', 'DOCTOR', '2073', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (84, '1481481489', '$2b$10$3hnNdZUaff8oUczJrWCx8O3aHRPJyQecEDwptGR5Wys./D3Ctb/WG', '$2b$10$3hnNdZUaff8oUczJrWCx8O', 'DOCTOR', '2373', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (85, '6360254460', '$2b$10$qS9ulhouzAW/jsQuPwSQiuA8t1gS9ojPdG1aGJ6Il9UHotwoTFANq', '$2b$10$qS9ulhouzAW/jsQuPwSQiu', 'PATIENT', '1428', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (88, '9030314066', '$2b$10$Y/xs/muhHaNO.LLCeKnwTuFkEk/AAa78.OCN40z4qJMXPRIgRgZ8i', '$2b$10$Y/xs/muhHaNO.LLCeKnwTu', 'PATIENT', '8488', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (89, '8528528523', '$2b$10$i9dM3C37bRATfuorv5fv2.it0HDFwlr.lpguir.2UzTdGU6Iom8zS', '$2b$10$i9dM3C37bRATfuorv5fv2.', 'PATIENT', '8950', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (90, '7847847848', '$2b$10$holp9Sb6yXGrZ.btGNIksOYVyRCB3WLvAp8U3Su.jUYzDmQRS8uC6', '$2b$10$holp9Sb6yXGrZ.btGNIksO', 'PATIENT', '6990', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (91, '4545454545', '$2b$10$vjgLsPe1o6QmDNa3ja5Kn.fveKTN/DsOQwTa9LV7qPocoGG9Av/9e', '$2b$10$vjgLsPe1o6QmDNa3ja5Kn.', 'PATIENT', '8901', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (92, '2512512513', '$2b$10$stD6rze8aIy5HHFR/zauXu.C0eC4U6bEO2t0Knb4mRzpzMMO3q2mC', '$2b$10$stD6rze8aIy5HHFR/zauXu', 'PATIENT', '4992', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (78, '9874563210', '$2b$10$mkyQXYh08UoFK6SprgyOZurQ.r8pw4bYsnfaDOhcH5bpO4OYnrbBe', '$2b$10$mkyQXYh08UoFK6SprgyOZu', 'PATIENT', '4996', '+05:30');
INSERT INTO public.patient (patient_id, phone, password, salt, "createdBy", passcode, time_zone) VALUES (67, '7418657774', '$2b$10$9NBXXGkKrpYgXzMkLT6d7ef0Oilt1Qo/iaUvC2K878weuFVbCifFO', '$2b$10$9NBXXGkKrpYgXzMkLT6d7e', 'PATIENT', '2790', '+05:30');


--
-- TOC entry 3885 (class 0 OID 18254)
-- Dependencies: 206
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.permissions (id, name, description) VALUES (1, 'SELF_APPOINTMENT_READ', 'SELF_APPOINTMENT_READ');
INSERT INTO public.permissions (id, name, description) VALUES (2, 'SELF_APPOINTMENT_WRITE', 'SELF_APPOINTMENT_WRITE');
INSERT INTO public.permissions (id, name, description) VALUES (5, 'REPORTS', 'REPORTS');
INSERT INTO public.permissions (id, name, description) VALUES (6, 'ACCOUNT_SETTINGS_READ', 'ACCOUNT_SETTINGS_READ');
INSERT INTO public.permissions (id, name, description) VALUES (7, 'ACCOUNT_SETTINGS_WRITE', 'ACCOUNT_SETTINGS_WRITE');
INSERT INTO public.permissions (id, name, description) VALUES (10, 'ACCOUNT_USERS_APPOINTMENT_READ', 'ACCOUNT_USERS_APPOINTMENT_READ');
INSERT INTO public.permissions (id, name, description) VALUES (11, 'ACCOUNT_USERS_APPOINTMENT_WRITE', 'ACCOUNT_USERS_APPOINTMENT_WRITE');
INSERT INTO public.permissions (id, name, description) VALUES (12, 'CUSTOMER', 'CUSTOMER');
INSERT INTO public.permissions (id, name, description) VALUES (3, 'SELF_USER_SETTINGS_READ', 'SELF_USER_CONFIG_READ');
INSERT INTO public.permissions (id, name, description) VALUES (4, 'SELF_USER_SETTINGS_WRITE', 'SELF_USER_CONFIG_WRITE');
INSERT INTO public.permissions (id, name, description) VALUES (8, 'ACCOUNT_USERS_SETTINGS_READ', 'ACCOUNT_USERS_CONFIG_READ');
INSERT INTO public.permissions (id, name, description) VALUES (9, 'ACCOUNT_USERS_SETTINGS_WRITE', 'ACCOUNT_USERS_CONFIG_WRITE');


--
-- TOC entry 3888 (class 0 OID 18264)
-- Dependencies: 209
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (1, 2, 1);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (2, 2, 2);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (3, 2, 3);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (4, 2, 4);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (5, 2, 6);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (6, 2, 8);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (7, 2, 10);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (8, 1, 5);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (9, 1, 6);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (10, 1, 7);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (11, 1, 8);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (12, 1, 9);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (13, 1, 10);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (14, 1, 11);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (15, 3, 6);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (16, 3, 8);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (17, 3, 10);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (18, 3, 11);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (19, 4, 12);


--
-- TOC entry 3890 (class 0 OID 18269)
-- Dependencies: 211
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles (roles_id, roles) VALUES (1, 'ADMIN');
INSERT INTO public.roles (roles_id, roles) VALUES (2, 'DOCTOR');
INSERT INTO public.roles (roles_id, roles) VALUES (3, 'DOC_ASSISTANT');
INSERT INTO public.roles (roles_id, roles) VALUES (4, 'PATIENT');


--
-- TOC entry 3892 (class 0 OID 18274)
-- Dependencies: 213
-- Data for Name: user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_role (id, user_id, role_id) VALUES (1, 1, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (2, 2, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (4, 4, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (5, 5, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (3, 3, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (6, 7, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (7, 8, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (8, 9, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (9, 10, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (10, 11, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (11, 12, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (12, 13, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (13, 14, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (14, 15, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (15, 14, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (16, 16, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (17, 17, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (18, 18, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (19, 19, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (20, 20, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (21, 21, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (22, 22, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (23, 23, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (24, 24, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (25, 25, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (26, 26, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (27, 26, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (28, 27, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (29, 27, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (30, 28, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (31, 28, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (33, 29, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (34, 29, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (35, 30, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (36, 30, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (37, 31, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (38, 31, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (39, 32, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (40, 33, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (41, 34, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (42, 34, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (43, 35, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (44, 35, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (45, 36, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (46, 36, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (47, 37, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (48, 37, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (49, 38, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (50, 38, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (51, 39, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (52, 39, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (53, 40, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (54, 40, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (55, 41, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (56, 41, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (57, 42, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (58, 42, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (59, 43, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (60, 43, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (61, 44, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (62, 44, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (63, 45, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (64, 45, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (65, 47, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (66, 47, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (67, 48, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (68, 48, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (69, 49, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (70, 49, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (71, 50, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (72, 50, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (73, 51, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (74, 51, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (75, 52, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (76, 52, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (77, 53, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (78, 53, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (79, 54, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (80, 54, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (81, 55, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (82, 55, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (83, 56, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (84, 56, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (85, 57, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (86, 57, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (87, 58, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (88, 58, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (91, 60, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (92, 60, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (93, 61, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (94, 61, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (95, 62, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (96, 62, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (97, 63, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (98, 63, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (99, 64, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (100, 64, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (101, 65, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (102, 65, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (103, 66, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (104, 66, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (105, 67, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (106, 67, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (107, 68, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (108, 68, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (109, 69, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (110, 69, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (111, 70, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (112, 70, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (113, 71, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (114, 71, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (115, 72, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (116, 72, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (117, 73, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (118, 73, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (119, 74, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (120, 74, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (121, 75, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (122, 75, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (123, 76, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (124, 76, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (125, 77, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (126, 77, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (127, 78, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (128, 78, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (129, 79, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (130, 79, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (135, 82, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (136, 82, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (90, 59, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (89, 3, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (131, 80, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (132, 80, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (133, 81, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (134, 81, 2);


--
-- TOC entry 3894 (class 0 OID 18279)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Lamfer healthcare', 'lamferhealthcare@gmail.com', '$2b$10$mO63E7u3UpDvYdNjW8BTAeDE4LzSITvwFKnTwN0eNDUk0zcJ8FFJa', '$2b$10$mO63E7u3UpDvYdNjW8BTAe', 1, NULL, true, NULL, NULL, 1, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Chenthil Perumal', 'chenthil@gmail.com', '$2b$10$mO63E7u3UpDvYdNjW8BTAeDE4LzSITvwFKnTwN0eNDUk0zcJ8FFJa', '$2b$10$mO63E7u3UpDvYdNjW8BTAe', 1, 'Doc_1', true, NULL, NULL, 2, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'rahul@softsuave.com', '$2b$10$JF/2TZFsp18i6X1gpzxZf.lWyRiC90aEhSKBz7Mp328rhXuE4KZJy', '$2b$10$JF/2TZFsp18i6X1gpzxZf.', 15, 'Doc_16', false, NULL, NULL, 25, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('kalyanimaganti', 'kalyani@gmail.com', '$2b$10$BXgOQJS4QftfbStqkMV8S.A9E4D.hI6xfCV1FOHd6aGUJgoNBpPwi', '$2b$10$BXgOQJS4QftfbStqkMV8S.', 3, NULL, true, NULL, NULL, 4, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Sreedhar Maganti', 'sreedhar1@softsuave.com', '$2b$10$B9XrGqpPM6j9zZJOGkOySOOQvu/W0yTub7dkeMLkWTrWypg5RXVUK', '$2b$10$B9XrGqpPM6j9zZJOGkOySO', 3, NULL, true, NULL, NULL, 3, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('manikandhankumar', 'manikandan@softsuave.com', '$2b$10$phqQwOs8LSJrD0NGR/tofOF1xoJM0f.LNV4E4ET9jxKGu4ONy.qoC', '$2b$10$phqQwOs8LSJrD0NGR/tofO', 4, NULL, true, NULL, NULL, 5, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('TestingLasghg', 'test568@gmail.com', '$2b$10$eR182WPSCoLwvnHDcwmUTelJrY0c9tQoreQbVaHxCYXtwdbfGRv8G', '$2b$10$eR182WPSCoLwvnHDcwmUTe', 2, NULL, true, NULL, NULL, 10, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('ManikA', 'test23@softsuave.com', '$2b$10$FUzHRB9r4AlH0kHsEayl2e8xjyyvlcofcDu6ouwXwA.6RI7ZWLeTi', '$2b$10$FUzHRB9r4AlH0kHsEayl2e', 2, NULL, true, NULL, NULL, 8, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('ManikA', 'test235@softsuave.com', '$2b$10$mQz8mXf9DdoSEgYh3au1Xu52oZihl8D5hkf3zvwUNCdm.o9gkQCaG', '$2b$10$mQz8mXf9DdoSEgYh3au1Xu', 2, NULL, true, NULL, NULL, 9, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('TestingLasghg', 'teut568@gmail.com', '$2b$10$jRKLtV8JvKbVpSZ2prIXx.qMenp6KDz3l1NUsJKBhIGzfjtuGhK96', '$2b$10$jRKLtV8JvKbVpSZ2prIXx.', 2, NULL, true, NULL, NULL, 11, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('SreekumarReddy', 'sreekumarreddy@apollo.com', '$2b$10$WLNIBYD6daNIrQ42i77H5OxkhyHuL4anwSf8mnik0TtWI4T1IT1h2', '$2b$10$WLNIBYD6daNIrQ42i77H5O', 2, 'Doc_3', true, NULL, NULL, 12, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('InValiddoctor', 'invaliddoctor1@gmail.com', '$2b$10$GYtv0dMgyP6Lq2NsLMUTpugL1RNzKenXVHftW94pVUuQbS80kDMRi', '$2b$10$GYtv0dMgyP6Lq2NsLMUTpu', 2, 'Doc_4', true, NULL, NULL, 13, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('madhukadiyala', 'madhu@gmail.com', '$2b$10$Y5c9J7rDnhjICYjcg8TlPub7c563drtzfBLvJJjUoiZHmDHfOeg0i', '$2b$10$Y5c9J7rDnhjICYjcg8TlPu', 5, 'Doc_5', true, NULL, NULL, 14, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('InValiddoctor', 'invaliddoctor2@gmail.com', '$2b$10$zG07Cw9OxdxEu/5VX2irmufwfWZg7zVzv8U.qojHk3md7Z1Jg6br6', '$2b$10$zG07Cw9OxdxEu/5VX2irmu', 2, 'Doc_8', true, NULL, NULL, 17, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('asdfgh', 'sivaji@softsuave.com', '$2b$10$H8vkyVejWPY7ZpCPEY9XKuzU9DBphR6KOtW1cB6CsGw8vdybAbeZW', '$2b$10$H8vkyVejWPY7ZpCPEY9XKu', 8, 'Doc_9', true, NULL, NULL, 18, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('prashanthR', 'demo123@softsuave.com', '$2b$10$DuNwy0nb6.XbmpRTxd3IwekYbNLzQEK1qnviU2PZajBakIAflNckm', '$2b$10$DuNwy0nb6.XbmpRTxd3Iwe', 9, 'Doc_10', true, NULL, NULL, 19, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('TejaBollineni', 'teja@gmail.com', '$2b$10$gZJ25YQspPzUpqFAm1xTcek8WMXUPUshHUhRSAqpCz14WntR1O0pi', '$2b$10$gZJ25YQspPzUpqFAm1xTce', 11, 'Doc_12', true, NULL, NULL, 21, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'sakjdksadjk@softsuave.coma', '$2b$10$B2SpRhjudEHR5uze0OIbVuC0hNN8Mbm3xuNKRHGxGa0ezBpPN3ina', '$2b$10$B2SpRhjudEHR5uze0OIbVu', 12, 'Doc_13', true, NULL, NULL, 22, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'dsafsdafsafdsaf@softsuave.com', '$2b$10$.pFfoNX.7RpSrFUWyMqIPeizMnGMCF6ATFUMeHt98Gc1bhjjoXIHS', '$2b$10$.pFfoNX.7RpSrFUWyMqIPe', 13, 'Doc_14', true, NULL, NULL, 23, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'hkkhjl@softsuave.com', '$2b$10$qru1w7x84ZY92RCcK5D1YeDaJZEcpqjQ32uG4RoPeaBBmKVUztNL2', '$2b$10$qru1w7x84ZY92RCcK5D1Ye', 14, 'Doc_15', true, NULL, NULL, 24, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'rahul123@softsuave.com', '$2b$10$LjYWsSvTCvP5hyeQ2YAi5uHzhyZ85bDdhJqVttbeZH01wctgERZC2', '$2b$10$LjYWsSvTCvP5hyeQ2YAi5u', 16, 'Doc_17', true, NULL, NULL, 26, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Deactivateddoctor', 'doctor@softsuave.com', '$2b$10$miZ6zhhrVyivGPmdO7ztXOiHW9VDRquGNdAx4xvBgCmSLNqRBkVe.', '$2b$10$miZ6zhhrVyivGPmdO7ztXO', 17, 'Doc_18', true, NULL, NULL, 27, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('sreedarR', 'sreedar@softsuave.com', '$2b$10$UE38oxP.71/eYCDSQb1XOe8I/d6RJVcbLK3swNBQRBdNhReAaXpp2', '$2b$10$UE38oxP.71/eYCDSQb1XOe', 18, 'Doc_19', true, NULL, NULL, 28, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('RaviR', 'ravi@softsuave.com', '$2b$10$wEgwBjqd9UyqZY48A0JPYOTMyhi0Yy1rusj4.jDLfZlg4PQMrkNr6', '$2b$10$wEgwBjqd9UyqZY48A0JPYO', 19, 'Doc_20', false, NULL, NULL, 29, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('RaviR', 'ravi123@softsuave.com', '$2b$10$4/g1CF8VunW7bLFQEBspeOVfZSlCExn5R4klpD1Jl/JSXwj5.oUA.', '$2b$10$4/g1CF8VunW7bLFQEBspeO', 20, 'Doc_21', false, NULL, NULL, 30, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('RaviR', 'dasdads@softsuave.com', '$2b$10$n8FPNLfMNth1JSAcRJzNZOOHcs.otN/EBRjQPc6lGkSP/QnbuQ.Yi', '$2b$10$n8FPNLfMNth1JSAcRJzNZO', 21, 'Doc_22', false, NULL, NULL, 31, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('TestTest', 'testdoctor@softsuave.com', '$2b$10$XmpIWEwJnp3BeecEhkYWS.ZpTDKjmSBd1IAceAd0Kdeoag4Z6a4vy', '$2b$10$XmpIWEwJnp3BeecEhkYWS.', 22, 'Doc_23', true, NULL, NULL, 32, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('TestTest', 'testdoctor1@softsuave.com', '$2b$10$oS9MUWGoNO/Wk2XYgNwPj.H6GRJ1jpL5wT6CuvvMd.motAySPhgui', '$2b$10$oS9MUWGoNO/Wk2XYgNwPj.', 23, 'Doc_24', true, NULL, NULL, 33, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('SivajiReddy', 'sivaji@apollo.com', '$2b$10$/.p33c4DTG0gB3mgvTA5MOR8paJZFksThC40dZtycXyC0RNEau.bu', '$2b$10$/.p33c4DTG0gB3mgvTA5MO', 24, 'Doc_25', false, NULL, NULL, 34, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'prashanthrajendiran@softsuave.com', '$2b$10$jJhaY/BY2KaWz2OOoQEZKeVpcbeCA6QIHnfX0aZs/PVNiGbXHY4be', '$2b$10$jJhaY/BY2KaWz2OOoQEZKe', 10, 'Doc_11', true, NULL, NULL, 20, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'dsadsads@softsuave.com', '$2b$10$xG.DBweCL5LZHGwKCMwfuuqNAX637gUWgeOcm/pvp6wB.3fJfEhS.', '$2b$10$xG.DBweCL5LZHGwKCMwfuu', 30, 'Doc_31', false, NULL, NULL, 40, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('sivatest', 'sivatest@softsuave.com', '$2b$10$QdV452xoPcid2V03lnp3HuCqKH9CCLFQe48qCOaEe4tG.mmj6fzJq', '$2b$10$QdV452xoPcid2V03lnp3Hu', 26, 'Doc_27', false, NULL, NULL, 36, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'rahultest12345@softsuave.com', '$2b$10$JnejDpXnYQ.l0Wh0H02/6uvsyotbo8f9mPsJQIMR1gsgsQrgXvtt.', '$2b$10$JnejDpXnYQ.l0Wh0H02/6u', 28, 'Doc_29', false, NULL, NULL, 38, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'rahulsalkd@softsuave.com', '$2b$10$DwSN4yfNjexK1wRlLLQQvu8Ta7XHkEGXlayV3vrReJSUTgCuYfnR6', '$2b$10$DwSN4yfNjexK1wRlLLQQvu', 29, 'Doc_30', false, NULL, NULL, 39, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'rahultest123@softsuave.com', '$2b$10$X.Ai3Rd758w/w8JYn5HBV.G.sM3L8Av3VkQt2cImsMCdTs4AAmGOS', '$2b$10$X.Ai3Rd758w/w8JYn5HBV.', 27, 'Doc_28', true, NULL, NULL, 37, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('laxminarahari', 'lakshmi.narasimhan@softsuave.com', '$2b$10$uzZ5QVdCxiOy.W.gkRx6iOu99TmKXgGyxTZgSgrg5TeJPkfDZu8JS', '$2b$10$uzZ5QVdCxiOy.W.gkRx6iO', 31, 'Doc_32', false, NULL, NULL, 41, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'sadsaddadsa@softsuave.com', '$2b$10$Zzd5C1DHJAEPYDGnS3jKEO6AGhDwUThwFl0HAVliIkqx7z6l5OUTO', '$2b$10$Zzd5C1DHJAEPYDGnS3jKEO', 32, 'Doc_33', false, NULL, NULL, 42, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Arulkumar', 'arul@gmail.com', '$2b$10$jSTI53yj6Dy35h0c9a7HGOYHE2mFolejlhOWjyh3Qw0Eytzs26ZYK', '$2b$10$jSTI53yj6Dy35h0c9a7HGO', 34, 'Doc_35', false, NULL, NULL, 44, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Prashatha', 'prasath@softsuave.com', '$2b$10$EN2dlTdlUQq9Hevj/dwlwOAoUiFmss.6GbiomfbtIKoCMDXbuevTe', '$2b$10$EN2dlTdlUQq9Hevj/dwlwO', 33, 'Doc_34', true, NULL, NULL, 43, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('qwerty', 'dharani@softsuave.com', '$2b$10$T7mAgBpxr2cNrDrHml5neuo3YyTrBYWK3KSpLq0FYzfZDrskwzchm', '$2b$10$T7mAgBpxr2cNrDrHml5neu', 7, 'Doc_7', true, NULL, NULL, 16, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Sreedhar Maganti', 'sreedhar@softsuave.com', '$2b$10$WLNIBYD6daNIrQ42i77H5O3QotoAXPdTr.RlHG0bwGRdR1YFeWWSC', '$2b$10$WLNIBYD6daNIrQ42i77H5O', 2, 'Doc_2', true, NULL, NULL, 7, '-04:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('abcxyz', 'chakkasai123abc@softsuave.com', '$2b$10$.m1E/cBHkPETdHFmLeOc/uYFpihUca/cO6mCC32JFdBn9aSIgm4.K', '$2b$10$.m1E/cBHkPETdHFmLeOc/u', 6, 'Doc_6', true, NULL, NULL, 15, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Arulkumar', 'krishna@gmail.com', '$2b$10$l/kBQMBjtiDsT0jZsDzE7O.69m0zWfrFavz5RG0b4ZirkXiShbvg6', '$2b$10$l/kBQMBjtiDsT0jZsDzE7O', 35, 'Doc_36', false, NULL, NULL, 45, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Arulkumar', 'bramha@softsuave.com', '$2b$10$xIvmTMyWuT2Zo4kKeW3xXOW509X7pNcCq0MKDHiBbg1L08VBr47PW', '$2b$10$xIvmTMyWuT2Zo4kKeW3xXO', 37, 'Doc_37', false, NULL, NULL, 47, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('ssss', 'sss@softsuave.com', '$2b$10$zxEB7/G1zybZnZnGy0nfaOgA6.fxdmnCP6la0.wURBx6UKyiluDBW', '$2b$10$zxEB7/G1zybZnZnGy0nfaO', 38, 'Doc_38', false, NULL, NULL, 48, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'ssssfds@softsuave.com', '$2b$10$lgtqFhFLNcuSDzzRdyRh.e0BlotDPVO2DGW8L2qZlL3Wlat7WeM1C', '$2b$10$lgtqFhFLNcuSDzzRdyRh.e', 39, 'Doc_39', false, NULL, NULL, 49, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'dasdssda@softsuave.com', '$2b$10$o6xX//4qAPocT6oTQFFi/eHXYZMAQxREbrkZIdCTpHHAT3r3HY056', '$2b$10$o6xX//4qAPocT6oTQFFi/e', 40, 'Doc_40', false, NULL, NULL, 50, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('SivaReddy', 'siva234@softsuave.com', '$2b$10$hx9xL7itwbiJR4x1tU2Jbu1whcixZ63mN2DpmT20J6c94i6ubEJ7K', '$2b$10$hx9xL7itwbiJR4x1tU2Jbu', 41, 'Doc_41', false, NULL, NULL, 51, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('TestReddy', 'sivaji345@apollo.com', '$2b$10$caZdnkT9UlyWYF3WjWCvyuQWY/uCjODDcVBA.ph5O/6zTPB3E1g1m', '$2b$10$caZdnkT9UlyWYF3WjWCvyu', 42, 'Doc_42', false, NULL, NULL, 52, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('arulkumar', 'sridhar@softsuave.com', '$2b$10$ygTJCXOpfxSh.m9cWw.f7exPG4c5rciVkgjBmSUGgM50aSdtX0tUa', '$2b$10$ygTJCXOpfxSh.m9cWw.f7e', 43, 'Doc_43', true, NULL, NULL, 53, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('testR', 'testr@softsuave.com', '$2b$10$6wJVnm/13bHCmfiIZsS9buaixvL.Erg8gv1AWJwAbakHvHh2zLQ/.', '$2b$10$6wJVnm/13bHCmfiIZsS9bu', 44, 'Doc_44', false, NULL, NULL, 54, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('LaxmiMaganti', 'laxmi@gmail.com', '$2b$10$wiEyJIx17VyPTBDUQgnv0O6UxASlFCQbNY4PwqUEWZezwCWeMYtrW', '$2b$10$wiEyJIx17VyPTBDUQgnv0O', 45, 'Doc_45', false, NULL, NULL, 55, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('KrishnaKumar', 'krishnan@gmail.com', '$2b$10$e0CToUKSwk3IuE3mqg8F8u8zI4Bb2/vlmECMDyzS27.SRafjayOSm', '$2b$10$e0CToUKSwk3IuE3mqg8F8u', 46, 'Doc_46', false, NULL, NULL, 56, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('munnabhai', 'munna@gmail.com', '$2b$10$3LGdIfEO3GaF9yrPF7OuL.SJBApXgxvKFdhwEnCJWN5R7Mvis/ET2', '$2b$10$3LGdIfEO3GaF9yrPF7OuL.', 49, 'Doc_49', true, NULL, NULL, 59, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('DharaniAntharvedi', 'dharani@gmail.com', '$2b$10$xkicxdTCA/UKgSOQV.vS5Op3vjefNRuUSrv0q4rj5mbCFSlYLhh02', '$2b$10$xkicxdTCA/UKgSOQV.vS5O', 50, 'Doc_50', false, NULL, NULL, 60, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('TestingReddy', 'manikandan1234@softsuave.com', '$2b$10$RQeYL7yQIH6tXmwcXPNPpO6wmOvZ/0hYV9gDkRNG8rel.zvwM0cf2', '$2b$10$RQeYL7yQIH6tXmwcXPNPpO', 51, 'Doc_51', false, NULL, NULL, 61, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('TestingReddy', 'manik@gmail.com', '$2b$10$G1ZPuhAC0R0RvfagsgXx.emAwAAUfF8arjPatPTuBpPLB40vu7hWm', '$2b$10$G1ZPuhAC0R0RvfagsgXx.e', 52, 'Doc_52', false, NULL, NULL, 62, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('SivaKumar', 'siva@gmail.com', '$2b$10$OLXSaJckW/k.LyTeHeBzQ.4TIHwgRxwcuzopjJvc2Ys7fDW4ID7Ea', '$2b$10$OLXSaJckW/k.LyTeHeBzQ.', 54, 'Doc_54', false, NULL, NULL, 64, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('asiqR', 'asiq@softsuave.com', '$2b$10$AqRaFvcWrlTDTLoYp4mAludvgRYsF9a9Fe9TLjqPAtCfsAZvsuqYq', '$2b$10$AqRaFvcWrlTDTLoYp4mAlu', 55, 'Doc_55', false, NULL, NULL, 65, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('asiqR', 'asiq123@softsuave.com', '$2b$10$gmxkqJuTuDlDYrb.Qe7YEedMsntd3w8GE3W4ApT48HYTIZs6.wofO', '$2b$10$gmxkqJuTuDlDYrb.Qe7YEe', 56, 'Doc_56', false, NULL, NULL, 66, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('TestingReddy', 'manik14@gmail.com', '$2b$10$jllcMT0Xzi3lrN5HxWyShuLlsMQPpLI9zaPF43j5fejjloUYaxpZq', '$2b$10$jllcMT0Xzi3lrN5HxWyShu', 53, 'Doc_53', true, NULL, NULL, 63, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('KumarKumar', 'kumar@softsuave.com', '$2b$10$Q9cZxmSOakgPElVpXGcoCugCa3dztWOfxDTnP5NmfujLB.uRbfILy', '$2b$10$Q9cZxmSOakgPElVpXGcoCu', 57, 'Doc_57', false, NULL, NULL, 67, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('kumarJi', 'kumar@gmail.com', '$2b$10$X5YofViApTFTzJJtpGprpecM442JyQoauHzvSmGjhUVArzG/1L8T2', '$2b$10$X5YofViApTFTzJJtpGprpe', 58, 'Doc_58', false, NULL, NULL, 68, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('MadhuK', 'madhu@softsuave.com', '$2b$10$gpAbzQiTIbxXI19vt7gP3uDtvVsNycBrfmdPofxJtvg3Svtg23ihi', '$2b$10$gpAbzQiTIbxXI19vt7gP3u', 59, 'Doc_59', true, NULL, NULL, 69, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('PrabhuDharmaraj', 'prabhu.dharmaraj@softsuave.com', '$2b$10$Mr6hf5hSQA/YlOkMvfcEc.Yjd9I9X.4AX6EdDI.wzuFw0jK4UtgTe', '$2b$10$Mr6hf5hSQA/YlOkMvfcEc.', 25, 'Doc_26', true, NULL, NULL, 35, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('vishwaR', 'vishwa@softsuave.com', '$2b$10$2iL0wQ.dOgVvWTf1RLnY6.S57OykK9y3TVS94YdGANLYBoivvSPy6', '$2b$10$2iL0wQ.dOgVvWTf1RLnY6.', 60, 'Doc_60', false, NULL, NULL, 70, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'rahul12345@softsuave.com', '$2b$10$ROWp/eIUJVjS9hFgM5h6tOex/Tq4TQlp/XG4Yzqm8puA0eChN5Y0C', '$2b$10$ROWp/eIUJVjS9hFgM5h6tO', 63, 'Doc_63', false, NULL, NULL, 73, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('JonJac', 'testing1245@gmail.com', '$2b$10$Y8xlPSpnxkU5zjT092sTSuZykPbCaaJ8IAXJv2baw4IAyAug8OhA2', '$2b$10$Y8xlPSpnxkU5zjT092sTSu', 61, 'Doc_61', false, NULL, NULL, 71, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'ytrrytr@softsuave.com', '$2b$10$LZOlY4NCGqEfMapRzAw9OeHqDMldOKZriX0J0nc9RF00eGr/5.DWK', '$2b$10$LZOlY4NCGqEfMapRzAw9Oe', 68, 'Doc_68', false, NULL, NULL, 78, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('NewDoctor', 'abcd@gmail.com', '$2b$10$GCh6eBB/l8cdaQZpRLJCIO.poRi2NXzo3iseRn4Rm4Oze5l6UPNWS', '$2b$10$GCh6eBB/l8cdaQZpRLJCIO', 64, 'Doc_64', false, NULL, NULL, 74, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'yyryryteryrer@softsuave.com', '$2b$10$XKX2c8YatYgdBq.B.3MBfuPXwKP1KWv4hsotEMhSkmnbIAUYmF5qu', '$2b$10$XKX2c8YatYgdBq.B.3MBfu', 69, 'Doc_69', false, NULL, NULL, 79, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('SSSS', 'chakkasai@softsuave.com', '$2b$10$rtI.BlDJf7yl8vfsQZ1QhuxfhaP93mXF6qX9PIydvGuNyvUtl.fKS', '$2b$10$rtI.BlDJf7yl8vfsQZ1Qhu', 72, 'Doc_72', false, NULL, NULL, 82, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('JohnJac', 'loyolaprabhu12345@gmail.com', '$2b$10$7fYuMTRWkvQJjEKXgA/vp.SHM0GRCqfYb6tW.2qB1Sk2sALp0UNla', '$2b$10$7fYuMTRWkvQJjEKXgA/vp.', 62, 'Doc_62', true, NULL, NULL, 72, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('JohnJack', 'loyolaprabhu@gmail.com', '$2b$10$PfBaXN2CQuEO6OXWkaL5ae7YyvyA9HnbMt8a/LlixCS1fjKt20f4y', '$2b$10$PfBaXN2CQuEO6OXWkaL5ae', 65, 'Doc_65', true, NULL, NULL, 75, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Abusid', 'sithik.softsuave@gmail.com', '$2b$10$a.JEbt/3c6FDrLiptMMf0OVYwsgNVMoZNmiyV3m1kKBsRzFOxGVDm', '$2b$10$a.JEbt/3c6FDrLiptMMf0O', 48, 'Doc_48', true, NULL, NULL, 58, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('no name', 'abubakker@softsuave.com', '$2b$10$GgiTIQu1kram6rs7ftd57OXdpLRSlQRvcxbAlb9AH.60BF/KYr67S', '$2b$10$GgiTIQu1kram6rs7ftd57O', 47, 'Doc_47', true, NULL, NULL, 57, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'rwerewrw@softsuave.com', '$2b$10$5S.VYVSsky4.cIpF/B3fPu1GwaCVsK3A.NsDuKOVXAsH4OC5sd46O', '$2b$10$5S.VYVSsky4.cIpF/B3fPu', 66, 'Doc_66', false, NULL, NULL, 76, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('rahulR', 'safsfsdffsafs@softsuave.com', '$2b$10$0Y7ynF28rJfL.357slJvMuankyLc2HKsqPZ0X6zP//.7hL5/1Dgc6', '$2b$10$0Y7ynF28rJfL.357slJvMu', 67, 'Doc_67', false, NULL, NULL, 77, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('Newdoctor', 'abubakker.hameed@softsuave.com', '$2b$10$DEfxP1GVN7dQlpC8QEadJOWTl5QeB1XAWQsME/pfE5OMAl/1lG8jK', '$2b$10$DEfxP1GVN7dQlpC8QEadJO', 70, 'Doc_70', true, NULL, NULL, 80, '+05:30');
INSERT INTO public.users (name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, id, time_zone) VALUES ('VigneshS', 'vignesh.sanmugam@softsuave.com', '$2b$10$lmuenFvO2jKF4C./Qd.hneE4tMuPiaeTMaFmAG8qjP8Lz8tlfduMi', '$2b$10$lmuenFvO2jKF4C./Qd.hne', 71, 'Doc_71', true, NULL, NULL, 81, '+05:30');


--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 203
-- Name: account_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_account_id_seq', 72, true);


--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 205
-- Name: patient_login_patient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_login_patient_id_seq', 93, true);


--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 207
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 11, true);


--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 208
-- Name: player_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.player_id_seq', 28, true);


--
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 210
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_permissions_id_seq', 1, false);


--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 212
-- Name: roles_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_roles_id_seq', 1, false);


--
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 214
-- Name: user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_role_id_seq', 136, true);


--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 82, true);


--
-- TOC entry 3734 (class 2606 OID 18295)
-- Name: account account_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_id PRIMARY KEY (account_id);


--
-- TOC entry 3736 (class 2606 OID 18297)
-- Name: patient patient_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_id PRIMARY KEY (patient_id);


--
-- TOC entry 3738 (class 2606 OID 18299)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3742 (class 2606 OID 18301)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3744 (class 2606 OID 18303)
-- Name: roles roles_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_id PRIMARY KEY (roles_id);


--
-- TOC entry 3746 (class 2606 OID 18305)
-- Name: user_role user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (id);


--
-- TOC entry 3749 (class 2606 OID 18307)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3751 (class 2606 OID 18309)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3739 (class 1259 OID 18310)
-- Name: fki_permissionId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_permissionId" ON public.role_permissions USING btree ("permissionId");


--
-- TOC entry 3740 (class 1259 OID 18311)
-- Name: fki_roleId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_roleId" ON public.role_permissions USING btree ("roleId");


--
-- TOC entry 3747 (class 1259 OID 18312)
-- Name: fki_user_to_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_user_to_account ON public.users USING btree (account_id);


--
-- TOC entry 3752 (class 2606 OID 18313)
-- Name: role_permissions permissionId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "permissionId" FOREIGN KEY ("permissionId") REFERENCES public.permissions(id) NOT VALID;


--
-- TOC entry 3753 (class 2606 OID 18318)
-- Name: role_permissions roleId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "roleId" FOREIGN KEY ("roleId") REFERENCES public.roles(roles_id) NOT VALID;


--
-- TOC entry 3754 (class 2606 OID 18323)
-- Name: users user_to_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_to_account FOREIGN KEY (account_id) REFERENCES public.account(account_id) NOT VALID;


--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2021-07-14 15:52:20

--
-- PostgreSQL database dump complete
--


--To Create the dump file from PG-ADMIN use Format:"Plain", Enable:"Pre-data", "Data", "Post-data", "Use Column Inserts", "Use Insert Commands"
-- PostgreSQL database dump
--

-- Dumped from database version 11.6
-- Dumped by pg_dump version 11.2

-- Started on 2020-07-31 19:25:54

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
-- TOC entry 4066 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 715 (class 1247 OID 24835)
-- Name: consultations; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.consultations AS ENUM (
    'online',
    'inHospital'
);


ALTER TYPE public.consultations OWNER TO postgres;

--
-- TOC entry 697 (class 1247 OID 24756)
-- Name: overbookingtype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.overbookingtype AS ENUM (
    'Per Hour',
    'Per day'
);


ALTER TYPE public.overbookingtype OWNER TO postgres;

--
-- TOC entry 712 (class 1247 OID 24827)
-- Name: payments; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payments AS ENUM (
    'onlineCollection',
    'directPayment',
    'notRequired'
);


ALTER TYPE public.payments OWNER TO postgres;

--
-- TOC entry 718 (class 1247 OID 24841)
-- Name: preconsultations; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.preconsultations AS ENUM (
    'on',
    'off'
);


ALTER TYPE public.preconsultations OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 197 (class 1259 OID 16489)
-- Name: account_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_details (
    account_key character varying(200) NOT NULL,
    hospital_name character varying(200) NOT NULL,
    street1 character varying(100),
    street2 character varying(100),
    city character varying(100),
    state character varying NOT NULL,
    pincode character varying(100) NOT NULL,
    phone bigint NOT NULL,
    support_email character varying(100),
    account_details_id integer NOT NULL,
    photo character varying(100)
);


ALTER TABLE public.account_details OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 16487)
-- Name: account_details_account_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_details_account_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_details_account_details_id_seq OWNER TO postgres;

--
-- TOC entry 4068 (class 0 OID 0)
-- Dependencies: 196
-- Name: account_details_account_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_details_account_details_id_seq OWNED BY public.account_details.account_details_id;


--
-- TOC entry 199 (class 1259 OID 16502)
-- Name: appointment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment (
    id integer NOT NULL,
    "doctorId" bigint NOT NULL,
    patient_id bigint NOT NULL,
    appointment_date date NOT NULL,
    "startTime" time without time zone NOT NULL,
    "endTime" time without time zone NOT NULL,
    payment_status boolean,
    is_active boolean,
    is_cancel boolean DEFAULT false,
    created_by character varying,
    created_id bigint,
    cancelled_by character varying(100),
    cancelled_id bigint,
    "slotTiming" bigint,
    paymentoption public.payments DEFAULT 'directPayment'::public.payments,
    consultationmode public.consultations DEFAULT 'online'::public.consultations
);


ALTER TABLE public.appointment OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16513)
-- Name: appointment_cancel_reschedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment_cancel_reschedule (
    appointment_cancel_reschedule_id integer NOT NULL,
    cancel_on date NOT NULL,
    cancel_by bigint NOT NULL,
    cancel_payment_status character varying(100) NOT NULL,
    cancel_by_id bigint NOT NULL,
    reschedule boolean NOT NULL,
    reschedule_appointment_id bigint NOT NULL,
    appointment_id bigint NOT NULL
);


ALTER TABLE public.appointment_cancel_reschedule OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16511)
-- Name: appointment_cancel_reschedule_appointment_cancel_reschedule_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq OWNER TO postgres;

--
-- TOC entry 4069 (class 0 OID 0)
-- Dependencies: 200
-- Name: appointment_cancel_reschedule_appointment_cancel_reschedule_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq OWNED BY public.appointment_cancel_reschedule.appointment_cancel_reschedule_id;


--
-- TOC entry 203 (class 1259 OID 16527)
-- Name: appointment_doc_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment_doc_config (
    appointment_doc_config_id integer NOT NULL,
    appointment_id bigint NOT NULL,
    consultation_cost real NOT NULL,
    is_preconsultation_allowed boolean,
    pre_consultation_hours integer,
    pre_consultation_mins integer,
    is_patient_cancellation_allowed boolean,
    cancellation_days character varying,
    cancellation_hours integer,
    cancellation_mins integer,
    is_patient_reschedule_allowed boolean,
    reschedule_days character varying,
    reschedule_hours integer,
    reschedule_mins integer,
    auto_cancel_days character varying(100),
    auto_cancel_hours integer,
    auto_cancel_mins integer
);


ALTER TABLE public.appointment_doc_config OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16525)
-- Name: appointment_doc_config_appointment_doc_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_doc_config_appointment_doc_config_id_seq OWNER TO postgres;

--
-- TOC entry 4070 (class 0 OID 0)
-- Dependencies: 202
-- Name: appointment_doc_config_appointment_doc_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq OWNED BY public.appointment_doc_config.appointment_doc_config_id;


--
-- TOC entry 198 (class 1259 OID 16500)
-- Name: appointment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_id_seq OWNER TO postgres;

--
-- TOC entry 4071 (class 0 OID 0)
-- Dependencies: 198
-- Name: appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_id_seq OWNED BY public.appointment.id;


--
-- TOC entry 216 (class 1259 OID 16751)
-- Name: appointment_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_seq OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24635)
-- Name: doc_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doc_config (
    id integer NOT NULL,
    doctor_key character varying,
    consultation_cost character varying DEFAULT 200,
    is_pre_consultation_allowed boolean DEFAULT true,
    "pre-consultation-hours" character varying DEFAULT 2,
    "pre-consultation-mins" character varying,
    is_patient_cancellation_allowed boolean DEFAULT true,
    cancellation_days character varying DEFAULT 5,
    cancellation_hours character varying DEFAULT 2,
    cancellation_mins character varying DEFAULT 30,
    is_patient_reschedule_allowed boolean DEFAULT true,
    reschedule_days character varying DEFAULT 6,
    reschedule_hours character varying DEFAULT 8,
    reschedule_mins character varying DEFAULT 40,
    auto_cancel_days character varying DEFAULT 5,
    auto_cancel_hours character varying DEFAULT 3,
    auto_cancel_mins character varying DEFAULT 15,
    "isActive" boolean DEFAULT false,
    created_on time with time zone,
    modified_on time with time zone,
    "overBookingCount" bigint,
    "overBookingEnabled" boolean DEFAULT false,
    "overBookingType" public.overbookingtype,
    "consultationSessionTimings" integer
);


ALTER TABLE public.doc_config OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16587)
-- Name: doctor_config_can_resch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_config_can_resch (
    doc_config_can_resch_id integer NOT NULL,
    doc_key character varying(200) NOT NULL,
    is_patient_cancellation_allowed boolean,
    cancellation_days character varying(100),
    cancellation_hours integer,
    cancellation_mins integer,
    is_patient_resch_allowed boolean,
    reschedule_days character varying(100),
    reschedule_hours integer,
    reschedule_mins integer,
    auto_cancel_days character varying(100),
    auto_cancel_hours integer,
    auto_cancel_mins integer,
    is_active boolean,
    created_on date,
    modified_on date
);


ALTER TABLE public.doctor_config_can_resch OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16753)
-- Name: doc_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doc_config_can_resch_doc_config_can_resch_id_seq OWNER TO postgres;

--
-- TOC entry 4072 (class 0 OID 0)
-- Dependencies: 217
-- Name: doc_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;


--
-- TOC entry 204 (class 1259 OID 16544)
-- Name: doc_config_schedule_day; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doc_config_schedule_day (
    doctor_id bigint NOT NULL,
    "dayOfWeek" character varying(50) NOT NULL,
    id integer NOT NULL,
    doctor_key character varying
);


ALTER TABLE public.doc_config_schedule_day OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24666)
-- Name: doc_config_schedule_day_doc_config_schedule_day_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doc_config_schedule_day_doc_config_schedule_day_id_seq OWNER TO postgres;

--
-- TOC entry 4073 (class 0 OID 0)
-- Dependencies: 222
-- Name: doc_config_schedule_day_doc_config_schedule_day_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq OWNED BY public.doc_config_schedule_day.id;


--
-- TOC entry 205 (class 1259 OID 16552)
-- Name: doc_config_schedule_interval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doc_config_schedule_interval (
    "startTime" time without time zone NOT NULL,
    "endTime" time without time zone NOT NULL,
    "docConfigScheduleDayId" bigint NOT NULL,
    id integer NOT NULL,
    doctorkey character varying
);


ALTER TABLE public.doc_config_schedule_interval OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24672)
-- Name: doc_config_schedule_interval_doc_config_schedule_interval_i_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq OWNER TO postgres;

--
-- TOC entry 4074 (class 0 OID 0)
-- Dependencies: 223
-- Name: doc_config_schedule_interval_doc_config_schedule_interval_i_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq OWNED BY public.doc_config_schedule_interval.id;


--
-- TOC entry 221 (class 1259 OID 24663)
-- Name: docconfigid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.docconfigid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.docconfigid_seq OWNER TO postgres;

--
-- TOC entry 4075 (class 0 OID 0)
-- Dependencies: 221
-- Name: docconfigid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.docconfigid_seq OWNED BY public.doc_config.id;


--
-- TOC entry 207 (class 1259 OID 16568)
-- Name: doctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor (
    "doctorId" integer NOT NULL,
    doctor_name character varying(100) NOT NULL,
    account_key character varying(200) NOT NULL,
    doctor_key character varying(200) NOT NULL,
    experience bigint NOT NULL,
    speciality character varying(200) NOT NULL,
    qualification character varying(500),
    photo character varying(500),
    number bigint,
    signature character varying(500),
    first_name character varying(100),
    last_name character varying(100),
    registration_number character varying(200),
    email character varying(200)
);


ALTER TABLE public.doctor OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 16585)
-- Name: doctor_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_config_can_resch_doc_config_can_resch_id_seq OWNER TO postgres;

--
-- TOC entry 4076 (class 0 OID 0)
-- Dependencies: 208
-- Name: doctor_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;


--
-- TOC entry 211 (class 1259 OID 16598)
-- Name: doctor_config_pre_consultation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_config_pre_consultation (
    doctor_config_id integer NOT NULL,
    doctor_key character varying NOT NULL,
    consultation_cost bigint,
    is_preconsultation_allowed boolean,
    preconsultation_hours integer,
    preconsultation_minutes integer,
    is_active boolean,
    created_on date,
    modified_on date
);


ALTER TABLE public.doctor_config_pre_consultation OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16596)
-- Name: doctor_config_pre_consultation_doctor_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_config_pre_consultation_doctor_config_id_seq OWNER TO postgres;

--
-- TOC entry 4077 (class 0 OID 0)
-- Dependencies: 210
-- Name: doctor_config_pre_consultation_doctor_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;


--
-- TOC entry 218 (class 1259 OID 16755)
-- Name: doctor_config_preconsultation_doctor_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_config_preconsultation_doctor_config_id_seq OWNER TO postgres;

--
-- TOC entry 4078 (class 0 OID 0)
-- Dependencies: 218
-- Name: doctor_config_preconsultation_doctor_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;


--
-- TOC entry 219 (class 1259 OID 16757)
-- Name: doctor_details_doctor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_details_doctor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_details_doctor_id_seq OWNER TO postgres;

--
-- TOC entry 4079 (class 0 OID 0)
-- Dependencies: 219
-- Name: doctor_details_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_details_doctor_id_seq OWNED BY public.doctor."doctorId";


--
-- TOC entry 206 (class 1259 OID 16566)
-- Name: doctor_doctor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_doctor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_doctor_id_seq OWNER TO postgres;

--
-- TOC entry 4080 (class 0 OID 0)
-- Dependencies: 206
-- Name: doctor_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_doctor_id_seq OWNED BY public.doctor."doctorId";


--
-- TOC entry 215 (class 1259 OID 16642)
-- Name: interval_days; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interval_days (
    interval_days_id integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    wrk_sched_id bigint NOT NULL
);


ALTER TABLE public.interval_days OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16640)
-- Name: interval_days_interval_days_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.interval_days_interval_days_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.interval_days_interval_days_id_seq OWNER TO postgres;

--
-- TOC entry 4081 (class 0 OID 0)
-- Dependencies: 214
-- Name: interval_days_interval_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.interval_days_interval_days_id_seq OWNED BY public.interval_days.interval_days_id;


--
-- TOC entry 231 (class 1259 OID 24773)
-- Name: openvidu_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.openvidu_session (
    openvidu_session_id integer NOT NULL,
    doctor_key character varying(100) NOT NULL,
    session_name character varying(100) NOT NULL,
    session_id character varying(100) NOT NULL
);


ALTER TABLE public.openvidu_session OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 24771)
-- Name: openvidu_session_openvidu_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.openvidu_session_openvidu_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.openvidu_session_openvidu_session_id_seq OWNER TO postgres;

--
-- TOC entry 4082 (class 0 OID 0)
-- Dependencies: 230
-- Name: openvidu_session_openvidu_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.openvidu_session_openvidu_session_id_seq OWNED BY public.openvidu_session.openvidu_session_id;


--
-- TOC entry 233 (class 1259 OID 24783)
-- Name: openvidu_session_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.openvidu_session_token (
    openvidu_session_token_id integer NOT NULL,
    openvidu_session_id bigint NOT NULL,
    token text NOT NULL,
    doctor_id bigint,
    patient_id bigint
);


ALTER TABLE public.openvidu_session_token OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 24781)
-- Name: openvidu_session_token_openvidu_session_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.openvidu_session_token_openvidu_session_token_id_seq OWNER TO postgres;

--
-- TOC entry 4083 (class 0 OID 0)
-- Dependencies: 232
-- Name: openvidu_session_token_openvidu_session_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq OWNED BY public.openvidu_session_token.openvidu_session_token_id;


--
-- TOC entry 225 (class 1259 OID 24691)
-- Name: patient_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_details (
    id integer NOT NULL,
    name character varying(100),
    landmark character varying(100),
    country character varying(100),
    registration_number character varying(200),
    address character varying(400),
    state character varying(100),
    pincode character varying(100),
    email character varying(100),
    photo character varying(100),
    phone character varying(100),
    patient_id bigint,
    "firstName" character varying(100),
    "lastName" character varying(100),
    "dateOfBirth" character varying(100),
    "alternateContact" character varying(100),
    age bigint
);


ALTER TABLE public.patient_details OWNER TO postgres;

-- updated patient_details table

CREATE TABLE public.patient_details
(
    id integer NOT NULL DEFAULT nextval('patient_details_patient_details_id_seq'::regclass),
    name character varying(100) COLLATE pg_catalog."default",
    landmark character varying(100) COLLATE pg_catalog."default",
    country character varying(100) COLLATE pg_catalog."default",
    registration_number character varying(200) COLLATE pg_catalog."default",
    address character varying(400) COLLATE pg_catalog."default",
    state character varying(100) COLLATE pg_catalog."default",
    pincode character varying(100) COLLATE pg_catalog."default",
    email character varying(100) COLLATE pg_catalog."default",
    photo character varying(600) COLLATE pg_catalog."default",
    phone character varying(100) COLLATE pg_catalog."default",
    patient_id bigint,
    "firstName" character varying(100) COLLATE pg_catalog."default",
    "lastName" character varying(100) COLLATE pg_catalog."default",
    "dateOfBirth" character varying(100) COLLATE pg_catalog."default",
    "alternateContact" character varying(100) COLLATE pg_catalog."default",
    age bigint,
    live_status live_statuses DEFAULT 'online'::live_statuses,
    last_active timestamp without time zone,
    city character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT patient_details_id PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE public.patient_details
    OWNER to postgres;
--
-- TOC entry 224 (class 1259 OID 24689)
-- Name: patient_details_patient_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patient_details_patient_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patient_details_patient_details_id_seq OWNER TO postgres;

--
-- TOC entry 4084 (class 0 OID 0)
-- Dependencies: 224
-- Name: patient_details_patient_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_details_patient_details_id_seq OWNED BY public.patient_details.id;


--
-- TOC entry 213 (class 1259 OID 16628)
-- Name: payment_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_details (
    id integer NOT NULL,
    appointment_id bigint NOT NULL,
    is_paid boolean DEFAULT false,
    refund character varying(100)
);


ALTER TABLE public.payment_details OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16626)
-- Name: payment_details_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_details_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_details_payment_id_seq OWNER TO postgres;

--
-- TOC entry 4085 (class 0 OID 0)
-- Dependencies: 212
-- Name: payment_details_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_details_payment_id_seq OWNED BY public.payment_details.id;


--
-- TOC entry 227 (class 1259 OID 24709)
-- Name: work_schedule_day; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_schedule_day (
    id integer NOT NULL,
    doctor_id bigint NOT NULL,
    date date NOT NULL,
    is_active boolean,
    doctor_key character varying(100)
);


ALTER TABLE public.work_schedule_day OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24707)
-- Name: work_schedule_day_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_schedule_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.work_schedule_day_id_seq OWNER TO postgres;

--
-- TOC entry 4086 (class 0 OID 0)
-- Dependencies: 226
-- Name: work_schedule_day_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.work_schedule_day_id_seq OWNED BY public.work_schedule_day.id;


--
-- TOC entry 229 (class 1259 OID 24717)
-- Name: work_schedule_interval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_schedule_interval (
    id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    work_schedule_day_id bigint,
    is_active boolean
);


ALTER TABLE public.work_schedule_interval OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24715)
-- Name: work_schedule_interval_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_schedule_interval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.work_schedule_interval_id_seq OWNER TO postgres;

--
-- TOC entry 4087 (class 0 OID 0)
-- Dependencies: 228
-- Name: work_schedule_interval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.work_schedule_interval_id_seq OWNED BY public.work_schedule_interval.id;


--
-- TOC entry 3808 (class 2604 OID 16764)
-- Name: account_details account_details_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details ALTER COLUMN account_details_id SET DEFAULT nextval('public.account_details_account_details_id_seq'::regclass);


--
-- TOC entry 3809 (class 2604 OID 16505)
-- Name: appointment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment ALTER COLUMN id SET DEFAULT nextval('public.appointment_id_seq'::regclass);


--
-- TOC entry 3813 (class 2604 OID 16765)
-- Name: appointment_cancel_reschedule appointment_cancel_reschedule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule ALTER COLUMN appointment_cancel_reschedule_id SET DEFAULT nextval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq'::regclass);


--
-- TOC entry 3814 (class 2604 OID 16766)
-- Name: appointment_doc_config appointment_doc_config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config ALTER COLUMN appointment_doc_config_id SET DEFAULT nextval('public.appointment_doc_config_appointment_doc_config_id_seq'::regclass);


--
-- TOC entry 3838 (class 2604 OID 24665)
-- Name: doc_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config ALTER COLUMN id SET DEFAULT nextval('public.docconfigid_seq'::regclass);


--
-- TOC entry 3815 (class 2604 OID 24668)
-- Name: doc_config_schedule_day id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq'::regclass);


--
-- TOC entry 3816 (class 2604 OID 24674)
-- Name: doc_config_schedule_interval id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq'::regclass);


--
-- TOC entry 3817 (class 2604 OID 16769)
-- Name: doctor doctorId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor ALTER COLUMN "doctorId" SET DEFAULT nextval('public.doctor_details_doctor_id_seq'::regclass);


--
-- TOC entry 3818 (class 2604 OID 16770)
-- Name: doctor_config_can_resch doc_config_can_resch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_can_resch ALTER COLUMN doc_config_can_resch_id SET DEFAULT nextval('public.doc_config_can_resch_doc_config_can_resch_id_seq'::regclass);


--
-- TOC entry 3819 (class 2604 OID 16771)
-- Name: doctor_config_pre_consultation doctor_config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_pre_consultation ALTER COLUMN doctor_config_id SET DEFAULT nextval('public.doctor_config_preconsultation_doctor_config_id_seq'::regclass);


--
-- TOC entry 3822 (class 2604 OID 16772)
-- Name: interval_days interval_days_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interval_days ALTER COLUMN interval_days_id SET DEFAULT nextval('public.interval_days_interval_days_id_seq'::regclass);


--
-- TOC entry 3843 (class 2604 OID 24776)
-- Name: openvidu_session openvidu_session_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session ALTER COLUMN openvidu_session_id SET DEFAULT nextval('public.openvidu_session_openvidu_session_id_seq'::regclass);


--
-- TOC entry 3844 (class 2604 OID 24786)
-- Name: openvidu_session_token openvidu_session_token_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session_token ALTER COLUMN openvidu_session_token_id SET DEFAULT nextval('public.openvidu_session_token_openvidu_session_token_id_seq'::regclass);


--
-- TOC entry 3840 (class 2604 OID 24694)
-- Name: patient_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_details ALTER COLUMN id SET DEFAULT nextval('public.patient_details_patient_details_id_seq'::regclass);


--
-- TOC entry 3820 (class 2604 OID 16773)
-- Name: payment_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details ALTER COLUMN id SET DEFAULT nextval('public.payment_details_payment_id_seq'::regclass);


--
-- TOC entry 3841 (class 2604 OID 24712)
-- Name: work_schedule_day id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_day_id_seq'::regclass);


--
-- TOC entry 3842 (class 2604 OID 24720)
-- Name: work_schedule_interval id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_interval_id_seq'::regclass);


--
-- TOC entry 4024 (class 0 OID 16489)
-- Dependencies: 197
-- Data for Name: account_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.account_details VALUES ('Acc_2', 'Dr Kamakshi Memorial Hospital', 'Kasturba Nagar', 'st Adyar', 'Chennai', 'Tamil Nadu', '600020', 9623456257, 'kamashimemorialhospital@gmail.com', 2, NULL);
INSERT INTO public.account_details VALUES ('Acc_3', 'Dr Mehtas Hospital', 'Nichols road', 'chetpet', 'Chennai', 'Tamil Nadu', '600031', 9623456258, 'drmehtashospital@gmail.com', 3, NULL);
INSERT INTO public.account_details VALUES ('Acc_4', 'HCG Cancer Centre', 'Luz church', 'mylapur', 'Chennai', 'Tamil Nadu', '600004', 9623456259, 'hcgcancercentre@gmail.com', 4, NULL);
INSERT INTO public.account_details VALUES ('Acc_5', 'Kauvery Hospital', 'TTK road', 'Alwarpet', 'Chennai', 'Tamil Nadu', '600018', 9623456270, 'kauveryhospital@gmail.com', 5, NULL);
INSERT INTO public.account_details VALUES ('Acc_6', 'Frontier Lifeline Hospital', 'Ambattur Industrial Estate Road', 'Mogappair', 'Chennai', 'Tamil Nadu', '600101', 9623656270, 'frontierlifeline@gmail.com', 6, NULL);
INSERT INTO public.account_details VALUES ('Acc_1', 'Apollo Hospital', 'Greams Lane', 'Thousand Lights', 'Chennai', 'Tamil Nadu', '600006', 9623456256, 'chennai@apollohospitals.com', 1, NULL);


--
-- TOC entry 4026 (class 0 OID 16502)
-- Dependencies: 199
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.appointment VALUES (114, 1, 1, '2020-07-22', '10:00:00', '12:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (118, 5, 1, '2020-07-24', '10:00:00', '11:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (120, 5, 3, '2020-07-23', '11:15:00', '11:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (116, 5, 1, '2020-07-23', '10:00:00', '11:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (126, 5, 1, '2020-07-25', '11:00:00', '11:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (135, 5, 3, '2020-07-23', '15:15:00', '16:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (137, 5, 3, '2020-07-23', '13:45:00', '14:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (139, 5, 2, '2020-07-22', '12:45:00', '13:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (140, 5, 1, '2020-07-23', '14:00:00', '15:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (142, 5, 2, '2020-07-23', '13:00:00', '14:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (143, 5, 2, '2020-07-23', '13:00:00', '14:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (145, 5, 3, '2020-07-29', '14:00:00', '15:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (191, 5, 104, '2020-07-28', '05:30:00', '06:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (151, 1, 1, '2020-07-28', '02:00:00', '02:30:00', NULL, true, false, 'PATIENT', 1, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (122, 5, 3, '2020-07-21', '01:10:00', '01:25:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (124, 5, 3, '2020-07-21', '02:23:00', '02:38:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (128, 5, 2, '2020-07-21', '10:45:00', '11:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (130, 5, 3, '2020-07-24', '14:15:00', '15:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (133, 5, 2, '2020-07-23', '10:00:00', '10:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (147, 5, 1, '2020-07-22', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (149, 5, 1, '2020-07-22', '11:00:00', '12:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (153, 5, 1, '2020-07-28', '03:00:00', '03:30:00', NULL, true, false, 'PATIENT', 1, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (155, 5, 1, '2020-07-28', '10:00:00', '10:30:00', NULL, true, false, 'PATIENT', 1, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (159, 5, 1, '2020-07-28', '14:30:00', '15:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (163, 5, 1, '2020-07-24', '10:30:00', '11:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (161, 5, 1, '2020-07-29', '02:00:00', '02:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (171, 5, 1, '2020-07-26', '10:00:00', '10:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (169, 5, 2, '2020-07-30', '10:30:00', '11:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (173, 5, 1, '2020-07-30', '15:00:00', '15:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (165, 5, 1, '2020-07-24', '11:30:00', '12:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (181, 5, 1, '2020-07-30', '14:00:00', '14:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (183, 5, 101, '2020-07-30', '02:00:00', '02:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (185, 5, 103, '2020-07-28', '02:00:00', '02:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (187, 5, 1, '2020-07-30', '11:30:00', '12:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (189, 5, 1, '2020-07-30', '13:30:00', '14:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (175, 5, 1, '2020-07-31', '10:00:00', '10:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (157, 5, 1, '2020-07-28', '03:30:00', '04:00:00', NULL, false, true, 'PATIENT', 1, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (177, 5, 93, '2020-07-29', '03:00:00', '03:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (193, 5, 105, '2020-07-28', '05:30:00', '06:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (167, 5, 1, '2020-08-04', '02:30:00', '03:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (197, 5, 110, '2020-07-31', '14:30:00', '15:15:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (195, 5, 112, '2020-07-28', '13:00:00', '13:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (199, 5, 112, '2020-07-28', '13:45:00', '14:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (201, 5, 1, '2020-07-29', '10:45:00', '11:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (203, 5, 3, '2020-07-29', '13:45:00', '14:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (205, 5, 1, '2020-07-28', '13:00:00', '13:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (207, 5, 1, '2020-07-29', '10:45:00', '11:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (209, 5, 1, '2020-07-29', '12:45:00', '13:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (217, 5, 122, '2020-07-31', '10:00:00', '10:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (221, 5, 124, '2020-07-28', '17:30:00', '18:15:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (219, 5, 1, '2020-07-28', '16:00:00', '16:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (211, 5, 60, '2020-07-29', '02:00:00', '02:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (215, 5, 60, '2020-07-30', '13:00:00', '13:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'onlineCollection', 'inHospital');
INSERT INTO public.appointment VALUES (223, 5, 1, '2020-07-30', '14:30:00', '15:15:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (225, 5, 50, '2020-07-28', '17:30:00', '18:15:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (213, 5, 121, '2020-07-29', '02:45:00', '03:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (227, 5, 1, '2020-07-28', '17:00:00', '18:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (229, 5, 131, '2020-07-28', '05:00:00', '06:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (231, 5, 64, '2020-07-30', '11:00:00', '12:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (232, 5, 132, '2020-07-28', '05:00:00', '06:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (179, 5, 61, '2020-07-29', '11:00:00', '11:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (115, 5, 1, '2020-07-22', '10:00:00', '11:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (119, 5, 1, '2020-08-12', '10:00:00', '11:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (129, 5, 2, '2020-07-22', '12:45:00', '13:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (125, 5, 1, '2020-07-23', '10:00:00', '10:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (132, 5, 1, '2020-07-24', '10:45:00', '11:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (127, 5, 3, '2020-07-22', '14:15:00', '15:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (134, 5, 3, '2020-07-22', '14:15:00', '15:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (136, 5, 3, '2020-07-30', '14:15:00', '15:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (138, 5, 3, '2020-07-22', '14:15:00', '15:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (141, 5, 1, '2020-07-23', '15:00:00', '16:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (117, 5, 1, '2020-07-24', '12:00:00', '11:00:00', NULL, true, true, 'DOCTOR', 32, NULL, NULL, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (150, 5, 1, '2020-07-24', '04:00:00', '05:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (121, 5, 3, '2020-07-21', '02:53:00', '03:07:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (123, 5, 3, '2020-07-21', '01:40:00', '01:55:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (146, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (148, 5, 1, '2020-07-22', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (158, 5, 1, '2020-07-28', '14:00:00', '14:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (160, 5, 1, '2020-07-28', '15:00:00', '15:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (162, 5, 1, '2020-07-28', '01:00:00', '01:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (131, 5, 1, '2020-07-24', '10:00:00', '10:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (172, 5, 2, '2020-07-25', '15:00:00', '15:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (170, 5, 1, '2020-07-30', '11:30:00', '12:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (111, 5, 1, '2020-07-20', '09:00:00', '09:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (174, 5, 1, '2020-07-30', '10:00:00', '10:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (152, 5, 1, '2020-07-28', '02:00:00', '02:30:00', NULL, false, true, 'PATIENT', 1, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (164, 5, 1, '2020-07-24', '11:00:00', '11:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (180, 5, 1, '2020-07-27', '10:30:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (156, 5, 1, '2020-07-28', '10:30:00', '11:00:00', NULL, false, true, 'PATIENT', 1, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (154, 5, 1, '2020-07-28', '02:30:00', '03:00:00', NULL, false, true, 'PATIENT', 1, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (186, 5, 1, '2020-07-28', '02:30:00', '03:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (184, 5, 102, '2020-07-30', '10:30:00', '11:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (182, 5, 1, '2020-07-30', '10:00:00', '10:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (190, 5, 1, '2020-07-30', '11:30:00', '12:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (188, 5, 1, '2020-07-30', '11:00:00', '11:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (192, 5, 1, '2020-07-26', '11:00:00', '11:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (166, 5, 1, '2020-08-04', '02:00:00', '02:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (194, 5, 110, '2020-07-28', '05:00:00', '05:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (196, 5, 110, '2020-07-30', '13:45:00', '14:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (168, 5, 2, '2020-07-29', '13:30:00', '14:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (198, 5, 2, '2020-07-28', '10:00:00', '10:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (200, 5, 1, '2020-07-28', '05:00:00', '05:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (202, 5, 1, '2020-07-28', '13:45:00', '14:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (144, 5, 3, '2020-07-29', '15:00:00', '16:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (204, 5, 1, '2020-07-28', '05:00:00', '05:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (208, 5, 1, '2020-07-26', '15:15:00', '16:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (206, 5, 1, '2020-07-28', '16:00:00', '16:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (216, 5, 60, '2020-07-30', '13:45:00', '14:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (222, 5, 124, '2020-07-26', '14:30:00', '15:15:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (212, 5, 60, '2020-07-30', '10:00:00', '10:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (113, 5, 1, '2020-07-22', '11:00:00', '11:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, NULL, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (218, 5, 123, '2020-07-28', '13:00:00', '13:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (224, 5, 56, '2020-07-28', '17:30:00', '18:15:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (214, 5, 73, '2020-07-30', '10:45:00', '11:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'notRequired', 'inHospital');
INSERT INTO public.appointment VALUES (210, 5, 1, '2020-07-28', '05:00:00', '05:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (226, 5, 95, '2020-07-28', '05:00:00', '06:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (228, 5, 63, '2020-07-28', '16:00:00', '17:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (230, 5, 96, '2020-07-28', '05:00:00', '06:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (233, 5, 97, '2020-07-28', '13:00:00', '14:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (178, 5, 60, '2020-07-29', '10:30:00', '11:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (176, 5, 92, '2020-07-29', '02:30:00', '03:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (234, 5, 65, '2020-07-29', '12:00:00', '13:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (235, 5, 133, '2020-07-28', '05:00:00', '06:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (236, 5, 134, '2020-07-28', '05:00:00', '06:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (237, 5, 99, '2020-07-29', '13:00:00', '14:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (238, 5, 135, '2020-07-29', '02:00:00', '03:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (240, 5, 23, '2020-07-30', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (220, 5, 50, '2020-07-28', '16:45:00', '17:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (239, 5, 100, '2020-07-29', '10:00:00', '11:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (242, 5, 1, '2020-07-28', '07:30:00', '08:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (243, 5, 92, '2020-07-28', '13:30:00', '14:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (245, 5, 1, '2020-07-28', '07:00:00', '07:10:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 10, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (244, 5, 137, '2020-07-28', '05:00:00', '05:10:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 10, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (247, 5, 1, '2020-07-28', '05:48:00', '05:58:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 10, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (248, 5, 1, '2020-07-28', '05:48:00', '05:58:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 10, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (241, 5, 60, '2020-07-28', '10:00:00', '10:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (246, 5, 1, '2020-07-29', '02:47:00', '02:57:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 10, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (249, 5, 1, '2020-07-29', '10:50:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 10, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (251, 5, 1, '2020-07-29', '10:00:00', '10:50:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 50, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (252, 5, 1, '2020-07-29', '15:50:00', '16:40:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 50, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (254, 5, 1, '2020-07-29', '10:45:00', '11:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (255, 5, 1, '2020-07-29', '15:00:00', '15:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (256, 5, 1, '2020-07-29', '15:45:00', '16:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (257, 5, 5, '2020-07-30', '13:00:00', '13:45:00', NULL, true, false, 'PATIENT', 5, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (259, 5, 1, '2020-07-29', '15:00:00', '15:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'onlineCollection', 'inHospital');
INSERT INTO public.appointment VALUES (260, 5, 140, '2020-07-29', '15:45:00', '16:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (261, 5, 1, '2020-08-05', '02:00:00', '02:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'notRequired', 'online');
INSERT INTO public.appointment VALUES (262, 5, 141, '2020-08-06', '10:00:00', '10:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (263, 5, 60, '2020-08-04', '09:00:00', '09:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (264, 5, 50, '2020-07-29', '16:30:00', '17:15:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'notRequired', 'inHospital');
INSERT INTO public.appointment VALUES (266, 5, 55, '2020-08-06', '10:45:00', '11:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (268, 5, 1, '2020-08-03', '12:00:00', '13:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (269, 5, 143, '2020-08-03', '13:00:00', '14:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (270, 5, 108, '2020-08-05', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'notRequired', 'online');
INSERT INTO public.appointment VALUES (267, 5, 142, '2020-07-29', '03:00:00', '03:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (271, 5, 142, '2020-07-30', '15:30:00', '16:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 30, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (274, 5, 109, '2020-08-04', '10:00:00', '10:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (273, 5, 109, '2020-08-03', '14:15:00', '15:00:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (275, 5, 109, '2020-07-29', '17:15:00', '18:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (276, 5, 144, '2020-08-04', '14:00:00', '14:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (277, 5, 145, '2020-08-05', '15:00:00', '15:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (278, 5, 146, '2020-08-03', '14:15:00', '15:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (279, 5, 111, '2020-08-06', '13:00:00', '13:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (280, 5, 111, '2020-08-06', '13:45:00', '14:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (253, 5, 139, '2020-07-29', '10:00:00', '10:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (250, 5, 1, '2020-07-29', '02:00:00', '02:50:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 50, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (281, 5, 1, '2020-07-30', '15:15:00', '16:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (282, 5, 61, '2020-08-10', '12:00:00', '12:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (258, 5, 50, '2020-08-04', '05:00:00', '05:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (283, 5, 147, '2020-07-29', '18:00:00', '18:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (285, 5, 58, '2020-07-29', '02:00:00', '02:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (286, 5, 84, '2020-07-29', '02:45:00', '03:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (265, 5, 1, '2020-08-04', '07:00:00', '07:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (288, 5, 1, '2020-08-11', '14:00:00', '14:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (289, 5, 148, '2020-08-11', '09:00:00', '09:45:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (290, 5, 2, '2020-08-06', '15:00:00', '16:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'onlineCollection', 'inHospital');
INSERT INTO public.appointment VALUES (291, 5, 63, '2020-08-10', '15:00:00', '16:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (292, 5, 149, '2020-08-04', '13:00:00', '14:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (293, 5, 150, '2020-08-10', '14:00:00', '15:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (294, 5, 150, '2020-08-12', '02:00:00', '03:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'onlineCollection', 'online');
INSERT INTO public.appointment VALUES (272, 5, 144, '2020-08-03', '15:00:00', '15:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (287, 5, 50, '2020-08-05', '15:45:00', '16:30:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (284, 5, 78, '2020-08-04', '07:00:00', '07:45:00', NULL, false, true, 'DOCTOR', 32, 'DOCTOR', 32, 45, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (295, 5, 115, '2020-08-17', '13:00:00', '14:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (296, 5, 116, '2020-08-04', '05:00:00', '06:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (297, 5, 116, '2020-08-04', '07:00:00', '08:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (298, 5, 116, '2020-08-05', '03:00:00', '04:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (299, 5, 5, '2020-08-03', '15:00:00', '16:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (300, 5, 152, '2020-08-04', '15:00:00', '16:00:00', NULL, true, false, 'PATIENT', 152, NULL, NULL, 60, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (301, 5, 116, '2020-08-10', '12:45:00', '13:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 15, 'directPayment', 'online');
INSERT INTO public.appointment VALUES (302, 5, 116, '2020-08-10', '13:00:00', '13:15:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL, 15, 'directPayment', 'online');


--
-- TOC entry 4028 (class 0 OID 16513)
-- Dependencies: 201
-- Data for Name: appointment_cancel_reschedule; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4030 (class 0 OID 16527)
-- Dependencies: 203
-- Data for Name: appointment_doc_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.appointment_doc_config VALUES (1, 251, 5000, NULL, 5, NULL, false, '2', 3, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (2, 252, 5000, NULL, 5, NULL, false, '2', 3, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (3, 253, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (4, 254, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (5, 255, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (6, 256, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (7, 258, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (8, 259, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (9, 260, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (10, 261, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (11, 262, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (12, 263, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (13, 264, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (14, 265, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (15, 266, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (16, 267, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (17, 268, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (18, 269, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (19, 270, 2000, NULL, 0, NULL, false, '0', 3, NULL, false, '0', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (20, 271, 5000, NULL, 1, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (21, 272, 5000, NULL, 1, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (22, 273, 5000, NULL, 1, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (23, 274, 5000, NULL, 1, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (24, 275, 5000, NULL, 1, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (25, 276, 5000, NULL, 1, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (26, 277, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (27, 278, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (28, 279, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (29, 280, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (30, 281, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (31, 282, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (32, 283, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (33, 284, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (34, 285, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (35, 286, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (36, 287, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (37, 288, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (38, 289, 5000, NULL, 0, NULL, true, '2', 3, NULL, true, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (39, 290, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (40, 291, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (41, 292, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (42, 293, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (43, 294, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (44, 295, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (45, 296, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (46, 297, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (47, 298, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (48, 299, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (49, 300, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (50, 301, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);
INSERT INTO public.appointment_doc_config VALUES (51, 302, 2000, NULL, 0, NULL, true, '3', 4, NULL, false, '2', 4, NULL, '1', 3, NULL);


--
-- TOC entry 4047 (class 0 OID 24635)
-- Dependencies: 220
-- Data for Name: doc_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doc_config VALUES (2, 'Doc_22', '200', true, '2', '12', false, '2', '2', '3', false, '3', '3', '4', '2', '3', '2', false, NULL, NULL, 4, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (3, 'Doc_23', '400', true, '2', '12', false, '2', '2', '21', false, '3', '2', '12', '1', '2', '12', false, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (4, 'Doc_24', '123', true, '5', '12', false, '2', '4', '21', false, '1', '12', '2', '5', '1', '12', false, NULL, NULL, 3, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (5, 'Doc_1', '2000', true, '2', '10', true, '3', '3', '20', true, '2', '10', '12', '1', '12', '10', true, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (10, 'Doc_7', '200', true, '1', '0', true, '0', '3', '10', true, '2', '20', '10', '0', '0', '20', true, NULL, NULL, 3, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (11, 'Doc_8', '500', true, '1', '20', true, '0', '2', '10', true, '10', '10', '1', '0', '1', '15', true, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (12, 'Doc_9', '150', true, '2', '10', true, '1', '0', '0', true, '1', '0', '0', '0', '1', '15', true, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (13, 'Doc_10', '500', true, '2', '10', true, '1', '0', '10', true, '6', '8', '40', '5', '3', '15', true, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (14, 'Doc_11', '100', true, '10', '0', true, '1', '10', '10', true, '0', '20', '10', '3', '3', '15', true, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (15, 'Doc_12', '500', true, '10', '1', true, '10', '10', '21', true, '1', '5', '0', '0', '0', '20', true, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (16, 'Doc_13', '200', true, '10', '1', true, '10', '10', '20', true, '1', '3', '0', '0', '0', '20', true, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (17, 'Doc_14', '200', true, '10', '1', false, '5', '2', '30', true, '1', '10', '10', '0', '1', '10', true, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (18, 'Doc_15', '200', true, '2', '0', false, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (19, 'Doc_16', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (20, 'Doc_17', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 3, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (21, 'Doc_18', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 3, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (22, 'Doc_19', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 3, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (23, 'Doc_20', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 3, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (24, 'Doc_21', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 3, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (25, 'Doc_25', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (9, 'Doc_6', '400', true, '2', '10', true, '1', '5', '10', true, '1', '1', '1', '0', '1', '10', true, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (8, 'Doc_4', '500', true, '2', '10', true, '4', '2', '30', true, '1', '1', '10', '0', '1', '10', false, NULL, NULL, 2, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (6, 'Doc_2', '30000', true, '23', '59', true, '00', '00', '00', true, '99', '23', '59', '00', '00', '00', false, NULL, NULL, NULL, true, 'Per Hour', 30);
INSERT INTO public.doc_config VALUES (1, 'Doc_5', '3500', true, '0', '35', true, '3', '4', '0', false, '2', '4', '0', '1', '3', '15', false, NULL, NULL, 5, false, 'Per Hour', 15);
INSERT INTO public.doc_config VALUES (7, 'Doc_3', '2000', true, '20', '10', true, '5', '2', '30', true, '1', '11', '10', '2', '11', '11', true, NULL, NULL, 4, true, 'Per day', 30);


--
-- TOC entry 4031 (class 0 OID 16544)
-- Dependencies: 204
-- Data for Name: doc_config_schedule_day; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doc_config_schedule_day VALUES (5, 'Monday', 1, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Tuesday', 2, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Wednesday', 3, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Thursday', 4, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Friday', 5, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Saturday', 6, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Sunday', 7, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Monday', 8, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Tuesday', 9, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Wednesday', 10, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Thursday', 11, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Friday', 12, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Saturday', 13, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Sunday', 14, 'Doc_1');


--
-- TOC entry 4032 (class 0 OID 16552)
-- Dependencies: 205
-- Data for Name: doc_config_schedule_interval; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doc_config_schedule_interval VALUES ('04:00:00', '07:00:00', 8, 104, 'Doc_1');
INSERT INTO public.doc_config_schedule_interval VALUES ('09:00:00', '12:00:00', 8, 105, 'Doc_1');
INSERT INTO public.doc_config_schedule_interval VALUES ('15:00:00', '19:00:00', 8, 106, 'Doc_1');
INSERT INTO public.doc_config_schedule_interval VALUES ('09:00:00', '11:00:00', 9, 107, 'Doc_1');
INSERT INTO public.doc_config_schedule_interval VALUES ('14:00:00', '18:00:00', 9, 108, 'Doc_1');
INSERT INTO public.doc_config_schedule_interval VALUES ('10:00:00', '12:00:00', 4, 72, 'Doc_5');
INSERT INTO public.doc_config_schedule_interval VALUES ('13:00:00', '16:00:00', 4, 73, 'Doc_5');
INSERT INTO public.doc_config_schedule_interval VALUES ('02:00:00', '06:00:00', 12, 109, 'Doc_1');
INSERT INTO public.doc_config_schedule_interval VALUES ('14:00:00', '16:00:00', 2, 131, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('12:00:00', '16:00:00', 1, 132, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('10:00:00', '12:00:00', 3, 67, 'Doc_5');
INSERT INTO public.doc_config_schedule_interval VALUES ('02:00:00', '04:00:00', 3, 78, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('15:00:00', '19:00:00', 3, 98, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('20:00:00', '22:00:00', 3, 99, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('05:00:00', '06:00:00', 2, 79, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('13:00:00', '14:00:00', 2, 82, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('16:00:00', '19:00:00', 2, 83, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('07:00:00', '08:00:00', 2, 127, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('09:00:00', '10:00:00', 2, 128, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('10:00:00', '11:00:00', 2, 129, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('11:10:00', '12:00:00', 2, 130, NULL);


--
-- TOC entry 4034 (class 0 OID 16568)
-- Dependencies: 207
-- Data for Name: doctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doctor VALUES (2, 'Prof Narendranath Kanna', 'Acc_1', 'Doc_2', 28, 'Cardiologist', 'MBBS MD Cardiology', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856325847, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Narendranath', 'kanna', 'RegD_2', 'narendranath@apollo.com');
INSERT INTO public.doctor VALUES (3, 'Sheetal Desai', 'Acc_1', 'Doc_3', 7, 'General Physician', 'MBBS', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856425847, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Sheetal', 'Desai', 'RegD_3', 'sheetaldesai@apollo.com');
INSERT INTO public.doctor VALUES (21, 'Balamurali', 'Acc_5', 'Doc_21', 11, 'Spine Surgery', 'MBBS.,MRCS.,MD.,FRCS', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556728999, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Bala', 'Murali', 'RegD_21', 'balamurali@gmail.com');
INSERT INTO public.doctor VALUES (24, 'Sowmya Ramanan V', 'Acc_6', 'Doc_24', 14, 'Paediatric Cardiac Surgery', 'MBBS, MS, M.Ch,MRCS', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556728901, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Sowmya', 'Ramanan V', 'RegD_24', 'sowmyaramananv@gmail.com');
INSERT INTO public.doctor VALUES (4, 'Sree Kumar Reddy', 'Acc_1', 'Doc_4', 26, 'Ophthamologist', 'MBBS MD Ophthamology', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856425887, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Sree Kumar', 'Reddy', 'RegD_4', 'sreekumarreddy@apollo.com');
INSERT INTO public.doctor VALUES (5, 'Shalini Shetty', 'Acc_1', 'Doc_5', 6, 'Ophthamologist', 'MBBS MD Ophthamology', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856425888, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Shalini', 'Shetty', 'RegD_5', 'test@apollo.com');
INSERT INTO public.doctor VALUES (16, 'Maheshkumar N Upasani', 'Acc_4', 'Doc_16', 20, 'Radiation oncologist', 'MD,PDCR', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556724899, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Maheshkumar N', 'Upasani', 'RegD_16', 'maheshkumar@gmail.com');
INSERT INTO public.doctor VALUES (17, 'Balaji.J', 'Acc_4', 'Doc_17', 21, 'Medical oncologist', 'DMRT, DNB(RT),DM (ONCOLOGY)', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556727899, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Balaji', 'J', 'RegD_17', 'balajij@gmail.com');
INSERT INTO public.doctor VALUES (8, 'Kumar ThulasiDass', 'Acc_2', 'Doc_8', 12, 'DIABETOLOGY & ENDOCRINOLOGIST', 'MBBS MD', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856425885, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Kumar', 'Thuasi Dass', 'RegD_8', 'thulasidass@gmail.com');
INSERT INTO public.doctor VALUES (9, 'Rajeshwari  Ramachandran', 'Acc_2', 'Doc_9', 17, 'NEUROLOGY', 'MBBS MD.DM', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856425889, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Rajeshwari', 'Ramachandran', 'RegD_9', 'rajeshwari@gmail.com');
INSERT INTO public.doctor VALUES (18, 'Murugesh	DMRT', 'Acc_4', 'Doc_18', 21, 'Radiation oncologist', 'DNB', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556728899, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Murugesh', 'DMRT', 'RegD_18', 'murugesh@gmail.com');
INSERT INTO public.doctor VALUES (14, 'K Kalaiselvi', 'Acc_3', 'Doc_14', 10, 'Oncology', 'MD DM', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556424899, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'KalaiSelvi', 'K', 'RegD_14', 'kalaiselvi@gmail.com');
INSERT INTO public.doctor VALUES (15, 'S Jayaraman', 'Acc_3', 'Doc_15', 10, 'Pulmonology', 'MBBS DTCD DNB', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556424899, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Jayaraman', 'S', 'RegD_15', 'jayaraman@gmail.com');
INSERT INTO public.doctor VALUES (11, 'Usha Shukla', 'Acc_3', 'Doc_11', 14, 'Family Medicine', 'MD', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856428879, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Usha', 'Shukla', 'RegD_11', 'ushashukla@gmail.com');
INSERT INTO public.doctor VALUES (12, ' Sarala Rajajee', 'Acc_3', 'Doc_12', 12, 'Paediatric Haematology', 'MD DCH DNB PhD', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856424879, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'sarala', 'Rajajee', 'RegD_12', 'saralarajajee@gmail.com');
INSERT INTO public.doctor VALUES (13, 'Parthasarathy Srinivasan', 'Acc_3', 'Doc_13', 10, 'Orthopaedics', 'D Ortho, DNB Ortho, FNB Spine', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556424879, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Parthasarathy', 'Srinivasan', 'RegD_13', 'parthasarathy@gmail.com');
INSERT INTO public.doctor VALUES (25, ' Balaji Srimurugan', 'Acc_6', 'Doc_25', 16, 'Staff Cardiac Surgeon', 'MBBS, MS, M.Ch', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556728906, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Balaji', 'Srimurugan', 'RegD_25', 'balajisrimurugan@gmail.com');
INSERT INTO public.doctor VALUES (1, 'Adithya K', 'Acc_1', 'Doc_1', 7, 'Cardiologist', 'MBBS MD Cardiology', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856325647, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Adithya', 'K', 'RegD_1', 'adithya@apollo.com');
INSERT INTO public.doctor VALUES (6, 'Sreeram Valluri', 'Acc_1', 'Doc_6', 7, 'ENT', 'MBBS MD ENT', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856425889, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'sreeram', 'valluri', 'RegD_6', 'sreeram@apollo.com');
INSERT INTO public.doctor VALUES (7, 'Indhumathi R', 'Acc_2', 'Doc_7', 7, 'Internal Medicine and masterhealth checkup', 'MBBS MD', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856425889, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'indhumathi', 'R', 'RegD_7', 'indhumathir@gmail.com');
INSERT INTO public.doctor VALUES (19, 'Mohammed Ibrahinm', 'Acc_4', 'Doc_19', 21, 'Surgical oncologist', 'MS(Gen.Surg.), DNB(Gen.Surg.), DNB(Surg.Oncology),MRCSEd(UK), FMAS', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556728899, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Mohammed', 'Ibrahim', 'RegD_19', 'mohammedibrahim@gmail.com');
INSERT INTO public.doctor VALUES (20, 'Aravindan Selvaraj', 'Acc_5', 'Doc_20', 11, 'Orthopaedic Surgery', 'MBBS.,MS.,FRCS( UK & IRELAND)', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556728899, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Aravindan', 'Selvaraj', 'RegD_20', 'aravindanselvaraj@gmail.com');
INSERT INTO public.doctor VALUES (22, 'Raghavan Subramanyan', 'Acc_6', 'Doc_22', 21, 'Sr Consultant Cardiologist', 'MBBS, MD, DM, FRCPI, FSCAI, FSCI', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556728909, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'raghavan', 'Subramanyan', 'RegD_22', 'raghavansubramaniyan@gmail.com');
INSERT INTO public.doctor VALUES (23, 'Anto sahayaraj. R', 'Acc_6', 'Doc_23', 15, 'Paediatric Cardiac Surgery', 'MBBS, MS, M.Ch', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9556728901, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Anto', 'Sahayaraj R', 'RegD_23', 'antosahayaraj@gmail.com');
INSERT INTO public.doctor VALUES (10, 'Vijay  Iyer', 'Acc_2', 'Doc_10', 20, 'NEURO SURGERY & TRAUMA CARE', 'MS Mch', 'https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6', 9856425879, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU', 'Vijay', 'Iyer', 'RegD_10', 'vijayiyer@gmail.com');


--
-- TOC entry 4036 (class 0 OID 16587)
-- Dependencies: 209
-- Data for Name: doctor_config_can_resch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doctor_config_can_resch VALUES (1, 'Doc_1', false, '1', 10, 10, false, '2', 2, 3, '0', 3, 10, false, NULL, '2020-06-08');
INSERT INTO public.doctor_config_can_resch VALUES (2, 'Doc_5', false, '1', 10, 10, false, '2', 2, 3, '0', 3, 10, false, NULL, '2020-06-20');


--
-- TOC entry 4038 (class 0 OID 16598)
-- Dependencies: 211
-- Data for Name: doctor_config_pre_consultation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doctor_config_pre_consultation VALUES (7, 'doc_1', 1000, false, 1, 10, true, NULL, '2020-06-08');
INSERT INTO public.doctor_config_pre_consultation VALUES (8, 'doc_1', 1000, false, 1, 10, true, NULL, '2020-06-08');
INSERT INTO public.doctor_config_pre_consultation VALUES (9, 'doc_1', 1000, false, 1, 10, true, NULL, '2020-06-08');


--
-- TOC entry 4042 (class 0 OID 16642)
-- Dependencies: 215
-- Data for Name: interval_days; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4058 (class 0 OID 24773)
-- Dependencies: 231
-- Data for Name: openvidu_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.openvidu_session VALUES (1, 'Doc_5', 'Shalini Shetty_Sat Jul 25 2020 20:06:08 GMT+0530 (India Standard Time)', 'ses_FITeCEbbM5');
INSERT INTO public.openvidu_session VALUES (3, 'Doc_5', 'Shalini Shetty_Sun Jul 26 2020 00:11:37 GMT+0530 (India Standard Time)', 'ses_HBnBgk2rif');
INSERT INTO public.openvidu_session VALUES (4, 'Doc_5', 'Shalini Shetty_Sun Jul 26 2020 00:24:16 GMT+0530 (India Standard Time)', 'ses_MqP6xQTw0G');
INSERT INTO public.openvidu_session VALUES (5, 'Doc_5', 'Shalini Shetty_Sun Jul 26 2020 00:25:13 GMT+0530 (India Standard Time)', 'ses_B35tt9HpOk');


--
-- TOC entry 4060 (class 0 OID 24783)
-- Dependencies: 233
-- Data for Name: openvidu_session_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.openvidu_session_token VALUES (2, 5, 'wss://devideo.virujh.com?sessionId=ses_B35tt9HpOk&token=tok_VmmFjpW7t6nNPKcz&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=P4QGIG&turnCredential=wej6tq', 5, NULL);


--
-- TOC entry 4052 (class 0 OID 24691)
-- Dependencies: 225
-- Data for Name: patient_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.patient_details VALUES (4, 'Amrutha', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 4, 'Amrutha', 'Akhila', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (1, 'name', 'landmark', 'country', 'Reg_1', 'address', 'state', '12346', 'nirmala123@gmail.com', 'testImageUrl', '9999999991', 1, 'Nirmala', 'Seetharaman', '26-10-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (8, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Suresh Antharvedi', 'Suresh Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (9, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'chaitanya', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (10, 'name', 'landmark', 'country', NULL, 'address', 'state', 'pincode', 'nirmala123@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 10, 'chaitanya', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (12, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'chaitanya', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (13, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'yogendra', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (14, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'yogendra', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (15, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'yogendra', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (16, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'yogendra', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (17, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Bunny', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (18, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Gopi', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (19, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Gopi', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (20, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Gopi', 'Gopi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (21, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'suresh', 'suresh', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (28, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 75, 'bhavya', 'bhavya', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (29, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 76, 'bhavya', 'bhavya', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (30, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 77, 'bhavya', 'bhavya', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (31, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 78, 'Dharani', 'Dharani', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (32, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 79, 'Dharani', 'Dharani', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (33, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Dharani', 'Dharani', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (34, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Dharani', 'Dharani', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (35, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'yamini', 'Dharani', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (36, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'yamini', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (37, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'yamini', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (38, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'yamini', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (39, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'yamini', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (40, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'kalyani', 'kalyani', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (41, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'kalyani', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (42, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'kalyani', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (5, 'name', 'landmark', 'country', NULL, 'address', 'state', 'pincode', 'chnadramukhi@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 5, 'Divya Gopi', 'Divya Gopi', 'dateOfBirth', NULL, NULL);
INSERT INTO public.patient_details VALUES (23, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 61, 'Cherry', 'Cherry', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (24, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 60, 'Cherry', 'Cherry', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (25, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 50, 'Cherry', 'Cherry', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (26, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 56, 'Cherry', 'Cherry', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (27, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 73, 'bhavya', 'bhavya', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (11, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 23, 'chaitanya', 'Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (22, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 64, 'suresh', 'suresh', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (43, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'kalyani', 'kalyani', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (44, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Thanu', 'Thanu', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (45, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Thanu', 'Thanu', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (46, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Thanu', 'Thanu', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (47, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL, 'Apple', 'Apple', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (50, NULL, NULL, NULL, NULL, '12, Grand street, ', NULL, NULL, NULL, NULL, '9999988888', 82, 'New', 'Test', '13-08-1989', '9988776655', 32);
INSERT INTO public.patient_details VALUES (51, NULL, NULL, NULL, NULL, '21, Get', NULL, NULL, NULL, NULL, '7777766666', 83, 'John', 'Carter', '16-11-1988', '8989898989', 34);
INSERT INTO public.patient_details VALUES (52, NULL, NULL, NULL, NULL, '12, Great Yard', NULL, NULL, NULL, NULL, '6666688888', 84, 'New', 'Test', '17-01-1985', '8888800000', 35);
INSERT INTO public.patient_details VALUES (53, NULL, NULL, NULL, NULL, 'Sgjvduob, fhklnv', NULL, NULL, NULL, NULL, '9999999999', 86, 'Fjk', 'Cjk', '01-09-2021', '', NULL);
INSERT INTO public.patient_details VALUES (54, NULL, NULL, NULL, NULL, 'Sgjvduob, fhklnv', NULL, NULL, NULL, NULL, '9999999999', 85, 'Fjk', 'Cjk', '01-09-2021', '', NULL);
INSERT INTO public.patient_details VALUES (55, NULL, NULL, NULL, NULL, 'Afjjv', NULL, NULL, NULL, NULL, '8594236789', 87, 'Dhkk', 'Chkl', '01-01-1985', '', NULL);
INSERT INTO public.patient_details VALUES (56, NULL, NULL, NULL, NULL, 'Jtxoudodu', NULL, NULL, NULL, NULL, '9543684236', 88, 'Txoyxkyx', 'Urzitxiiy', '01-01-1985', '', NULL);
INSERT INTO public.patient_details VALUES (57, NULL, NULL, NULL, NULL, 'Gdjgxkhxkhxx', NULL, NULL, NULL, NULL, '6576579579', 89, 'Tuwiydoudud', 'Utzjgxkyxk', '01-01-1985', '', NULL);
INSERT INTO public.patient_details VALUES (58, NULL, NULL, NULL, NULL, '12, wfhwjfh', NULL, NULL, NULL, NULL, '8877665544', 90, 'Thirunew', 'new', '16-01-1985', '2423434242', 35);
INSERT INTO public.patient_details VALUES (59, NULL, NULL, NULL, NULL, 'Eeeeeyyyy', NULL, NULL, NULL, NULL, '7766554433', 91, 'New', 'Thiru', '08-01-1985', '6325625362', 34);
INSERT INTO public.patient_details VALUES (48, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', '12345', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', '8524698522', 80, 'firstName', 'lastName', 'DOB', 'alternateContact', 21);
INSERT INTO public.patient_details VALUES (2, 'Ashok Gajapathi Raj', 'Mysore Palace', 'India', 'Reg_2', 'Bangalore', 'Karnataka', '530068', 'ashok@gmail.com', 'testImageUrl', '9999999992', 2, 'Ashok', 'Gajapathi Raj', '26-10-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (3, 'Shrushti Jayanth Deshmukh', 'Van Vihar National Park', 'India', 'Reg_3', 'Bhopal', 'Madhya Pradesh', '462023', 'shrushti@gmail.com', 'testImageUrl', '9999999993', 3, 'Shrushti Jayanth', 'Deshmukh', '26-10-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (6, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 6, 'Divya Gopi', 'Divya Gopi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (7, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 7, 'Suresh Antharvedi', 'Suresh Antharvedi', '26-08-1999', NULL, NULL);
INSERT INTO public.patient_details VALUES (60, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'john@gmail.com', NULL, '9888888888', 92, 'John', 'Wick', '1994-01-25', NULL, NULL);
INSERT INTO public.patient_details VALUES (61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wick@gmail.com', NULL, '9191919191', 93, 'Wick', 'John', '1994-01-29', NULL, NULL);
INSERT INTO public.patient_details VALUES (62, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999990000', 94, 'littleSingam', 'chotaBheem', '1999-10-26', NULL, NULL);
INSERT INTO public.patient_details VALUES (63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999900000', 95, 'littleSingam', 'chotaBheem', '1999-10-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999900001', 96, 'littleSingam', 'chotaBheem', '1999-10-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999900002', 97, 'littleSingam', 'chotaBheem', '1999-10-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999900003', 98, 'littleSingam', 'chotaBheem', '1999-10-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999900004', 99, 'littleSingam', 'chotaBheem', '1999-10-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999900005', 100, 'littleSingam', 'chotaBheem', '1999-10-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999900006', 101, 'littleSingam', 'chotaBheem', '1999-10-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (70, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999900007', 102, 'littleSingam', 'chotaBheem', '1999-10-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (71, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999900008', 103, 'littleSingam', 'chotaBheem', '1999-10-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'jack@gmail.com', NULL, '9666666666', 104, 'Jack', 'J', '1993-12-23', NULL, NULL);
INSERT INTO public.patient_details VALUES (73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'artemis@gmail.com', NULL, '9876543210', 105, 'Artemis', 'Fowl', '1994-01-11', NULL, NULL);
INSERT INTO public.patient_details VALUES (74, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirm8968@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', '9999900466', 109, 'firstName123', 'lastName', 'DOB', 'alternateContact', 21);
INSERT INTO public.patient_details VALUES (75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rudra@nobitha.com', NULL, '9999900015', 110, 'littleSingam', 'chotaBheem', '1999-10-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (76, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', '9999999461', 111, 'firstName', 'lastName', 'DOB', 'alternateContact', 21);
INSERT INTO public.patient_details VALUES (77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'email@gmail.com', NULL, '9999999980', 112, 'nirmala@gmail.com', 'lastName', '1999-10-26', NULL, NULL);
INSERT INTO public.patient_details VALUES (78, NULL, NULL, NULL, NULL, 'wall st', NULL, NULL, NULL, NULL, '5456465456', 113, 'asdfasd', '', '2020-07-15T20:13:00.000Z', '', 23);
INSERT INTO public.patient_details VALUES (79, NULL, NULL, NULL, NULL, 'sadf', NULL, NULL, NULL, NULL, '2342323434', 114, 'asfdasdf', 'sadfasdf', '2020-07-01T20:16:00.000Z', '', 234);
INSERT INTO public.patient_details VALUES (80, NULL, NULL, NULL, NULL, 'hdgfhdf', NULL, NULL, NULL, NULL, '2342342343', 115, 'asdfasdf', 'asdf', '2020-07-07T20:17:00.000Z', '', 23);
INSERT INTO public.patient_details VALUES (81, NULL, NULL, NULL, NULL, 'asdf', NULL, NULL, NULL, NULL, '2432342342', 116, 'dfsadfasfasd', '', '2020-07-08T20:19:00.000Z', '', 23);
INSERT INTO public.patient_details VALUES (82, NULL, NULL, NULL, NULL, 'asdfas', NULL, NULL, NULL, NULL, '2342342333', 117, 'asdfasdf', 'asdfasd', '2020-07-07T20:23:00.000Z', '', 23);
INSERT INTO public.patient_details VALUES (83, NULL, NULL, NULL, NULL, 'asdfa', NULL, NULL, NULL, NULL, '2342342222', 118, 'asdfasd', '', '2020-07-08T20:25:00.000Z', '', 23);
INSERT INTO public.patient_details VALUES (84, NULL, NULL, NULL, NULL, 'test1@apollo.com', NULL, NULL, NULL, NULL, '7358916662', 119, 'udhaya', 'Kumar', '2018-04-16T20:47:00.000Z', '7358916662', 12);
INSERT INTO public.patient_details VALUES (85, NULL, NULL, NULL, NULL, 'test2@apollo.com', NULL, NULL, NULL, NULL, '7358916682', 120, 'udhaya', 'Kumar', '2020-06-30T20:50:00.000Z', '7358916682', 12);
INSERT INTO public.patient_details VALUES (86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sunil@gmail.com', NULL, '8499678498', 121, 'sunil', 'kimar', '2020-07-29T14:37:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (87, 'sunil jay', NULL, NULL, NULL, NULL, NULL, NULL, 'jay@gmail.com', NULL, '9875647499', 122, 'sunil', 'jay', '2020-07-30T15:29:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (88, 'sijut tam', NULL, NULL, NULL, NULL, NULL, NULL, 'john@gmail.com', NULL, '9867858989', 123, 'sijut', 'tam', '2020-07-30T17:33:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (89, 'just once', NULL, NULL, NULL, NULL, NULL, NULL, 'just@gmail.com', NULL, '9879879876', 124, 'just', 'once', '2020-07-30T18:10:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (90, NULL, NULL, NULL, NULL, 'madiwala', NULL, NULL, NULL, NULL, '9634578524', 125, 'Dom', 'nic', '2020-07-27T08:36:00.000Z', '', 33);
INSERT INTO public.patient_details VALUES (91, NULL, NULL, NULL, NULL, 'Tirupati', NULL, NULL, NULL, NULL, '9999999997', 126, 'Win', 'Diesel', '2020-07-27T08:51:00.000Z', '', 33);
INSERT INTO public.patient_details VALUES (92, NULL, NULL, NULL, NULL, 'andhra', NULL, NULL, NULL, NULL, '9999999991', 127, 'domnick', '', '2020-07-14T08:57:00.000Z', '', 33);
INSERT INTO public.patient_details VALUES (93, NULL, NULL, NULL, NULL, 'Fxicoycoycpuv', NULL, NULL, NULL, NULL, '9999999990', 128, 'Ititxotxo', 'Ruogcoyc', '16-01-1985', '', 35);
INSERT INTO public.patient_details VALUES (94, NULL, NULL, NULL, NULL, 'Itcoycoyc', NULL, NULL, NULL, NULL, '9999999998', 129, 'Occp7c', 'Jf oy oy ', '23-01-1985', '', 35);
INSERT INTO public.patient_details VALUES (95, NULL, NULL, NULL, NULL, 'Skydluxlhx', NULL, NULL, NULL, NULL, '9999966666', 130, 'Jrzkyxkyd', 'Utzitdky', '16-01-1985', '', 35);
INSERT INTO public.patient_details VALUES (96, 'Dom Nick', NULL, NULL, NULL, NULL, NULL, NULL, 'dom@gmail.com', NULL, '9966884471', 131, 'Dom', 'Nick', '1994-01-28', NULL, NULL);
INSERT INTO public.patient_details VALUES (97, 'Win Diesel', NULL, NULL, NULL, NULL, NULL, NULL, 'win@gmail.com', NULL, '9966448875', 132, 'Win', 'Diesel', '1994-01-12', NULL, NULL);
INSERT INTO public.patient_details VALUES (98, 'The Rock', NULL, NULL, NULL, NULL, NULL, NULL, 'rock@gmail.com', NULL, '9966884476', 133, 'The', 'Rock', '1994-01-13', NULL, NULL);
INSERT INTO public.patient_details VALUES (99, 'Roman Reigns', NULL, NULL, NULL, NULL, NULL, NULL, 'roman@gmail.com', NULL, '9966884477', 134, 'Roman', 'Reigns', '1994-01-15', NULL, NULL);
INSERT INTO public.patient_details VALUES (100, 'Rock Man', NULL, NULL, NULL, NULL, NULL, NULL, 'rocker@gmail.com', NULL, '7777788888', 135, 'Rock', 'Man', '1994-01-12', NULL, NULL);
INSERT INTO public.patient_details VALUES (101, NULL, NULL, NULL, NULL, 'Oxoyxpucpu', NULL, NULL, NULL, NULL, '6666655555', 136, 'Tsodpuc', 'Izrxoyxl', '08-01-1985', '', 35);
INSERT INTO public.patient_details VALUES (102, 'Brock Lesnar', NULL, NULL, NULL, NULL, NULL, NULL, 'brock@gmail.com', NULL, '7766889944', 137, 'Brock', 'Lesnar', '1994-01-13', NULL, NULL);
INSERT INTO public.patient_details VALUES (103, 'Under Taker', NULL, NULL, NULL, NULL, NULL, NULL, 'taker@gmail.com', NULL, '9638527410', 138, 'Under', 'Taker', '1994-01-10', NULL, NULL);
INSERT INTO public.patient_details VALUES (104, 'arul prakash', NULL, NULL, NULL, NULL, NULL, NULL, 'arul@gmail.com', NULL, '9898989898', 139, 'arul', 'prakash', '2020-07-31T12:09:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (105, 'kavin kavin', NULL, NULL, NULL, NULL, NULL, NULL, 'kavin@gmail.com', NULL, '8978978971', 140, 'kavin', 'kavin', '2020-07-30T13:02:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (106, 'udhaya kumar', NULL, NULL, NULL, NULL, NULL, NULL, 'udhayakumar@softsuave.com', NULL, '8798121212', 141, 'udhaya', 'kumar', '2020-07-29T13:14:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (107, 'Dean Ambrose', NULL, NULL, NULL, NULL, NULL, NULL, 'dean@gmail.com', NULL, '7896541230', 142, 'Dean', 'Ambrose', '2021-10-20T15:34:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (108, 'Thiru Newupload', NULL, NULL, NULL, NULL, NULL, NULL, 'thiru@softsuave1.com', NULL, '9996667777', 143, 'Thiru', 'Newupload', '1994-01-13', NULL, NULL);
INSERT INTO public.patient_details VALUES (109, 'Dharani Antharvedi', NULL, NULL, NULL, NULL, NULL, NULL, 'dharan@softsuave.com', NULL, '9873535252', 144, 'Dharani', 'Antharvedi', '1994-01-19', NULL, NULL);
INSERT INTO public.patient_details VALUES (110, 'udhaya kumar', NULL, NULL, NULL, NULL, NULL, NULL, 'admin2@gmail.com', NULL, '9898989891', 145, 'udhaya', 'kumar', '2020-07-07T19:02:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (111, 'udhaya kumar', NULL, NULL, NULL, NULL, NULL, NULL, 'udhayakumar@softsuave.com', NULL, '9111111111', 146, 'udhaya', 'kumar', '2020-07-19T19:05:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (112, 'Harish Gowda', NULL, NULL, NULL, NULL, NULL, NULL, 'koustav@softsuave.com', NULL, '9895969595', 147, 'Harish', 'Gowda', '2020-07-28T19:28:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (113, 'Seth Rollins', NULL, NULL, NULL, NULL, NULL, NULL, 'rollins@gmail.com', NULL, '8527419632', 148, 'Seth', 'Rollins', '2019-12-27T08:14:00.000Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (114, 'Kim young', NULL, NULL, NULL, NULL, NULL, NULL, 'kim@gmail.com', NULL, '7893214562', 149, 'Kim', 'young', '2020-07-30T17:08:30.791Z', NULL, NULL);
INSERT INTO public.patient_details VALUES (115, 'Ramesh V', NULL, NULL, NULL, 'ewrere', NULL, NULL, 'ramesh@softsuave.com', NULL, '8682866222', 150, 'Ramesh', 'V', '16-01-1985', '', 33);
INSERT INTO public.patient_details VALUES (116, NULL, NULL, NULL, NULL, 'gnanaguru@softsuave.com', NULL, NULL, NULL, NULL, '8870527821', 151, 'guru', 'guru', '2020-07-06T20:11:00.000Z', '', 20);
INSERT INTO public.patient_details VALUES (117, NULL, 'HighSchool', 'India', NULL, 'Ganti', 'Andhra Pradesh', '533274', 'dharani@softsuave.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', '9652147787', 152, 'Dharani', 'Antharvedi', '26-10-1999', '9398341783', 21);
INSERT INTO public.patient_details VALUES (118, NULL, 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', '9398341783', 153, 'firstName', 'lastName', 'DOB', 'alternateContact', 21);
INSERT INTO public.patient_details VALUES (119, NULL, 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', '9398341784', 154, 'firstName', 'lastName', 'DOB', 'alternateContact', 21);
INSERT INTO public.patient_details VALUES (120, NULL, 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', '9398341785', 155, 'firstName', 'lastName', 'DOB', 'alternateContact', 21);
INSERT INTO public.patient_details VALUES (121, NULL, 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', '9398341786', 156, 'firstName', 'lastName', 'DOB', 'alternateContact', 21);
INSERT INTO public.patient_details VALUES (122, NULL, 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', '9398341787', 157, 'firstName', 'lastName', 'DOB', 'alternateContact', 21);
INSERT INTO public.patient_details VALUES (123, NULL, 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', '9398341789', 159, 'firstName', 'lastName', 'DOB', 'alternateContact', 21);


--
-- TOC entry 4040 (class 0 OID 16628)
-- Dependencies: 213
-- Data for Name: payment_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.payment_details VALUES (52, 113, false, NULL);
INSERT INTO public.payment_details VALUES (53, 114, false, NULL);
INSERT INTO public.payment_details VALUES (54, 115, false, NULL);
INSERT INTO public.payment_details VALUES (55, 116, false, NULL);
INSERT INTO public.payment_details VALUES (56, 117, false, NULL);
INSERT INTO public.payment_details VALUES (57, 118, false, NULL);
INSERT INTO public.payment_details VALUES (58, 119, false, NULL);
INSERT INTO public.payment_details VALUES (59, 120, false, NULL);
INSERT INTO public.payment_details VALUES (60, 121, false, NULL);
INSERT INTO public.payment_details VALUES (61, 122, false, NULL);
INSERT INTO public.payment_details VALUES (62, 123, false, NULL);
INSERT INTO public.payment_details VALUES (63, 124, false, NULL);
INSERT INTO public.payment_details VALUES (64, 125, false, NULL);
INSERT INTO public.payment_details VALUES (65, 126, false, NULL);
INSERT INTO public.payment_details VALUES (66, 127, false, NULL);
INSERT INTO public.payment_details VALUES (67, 128, false, NULL);
INSERT INTO public.payment_details VALUES (68, 129, false, NULL);
INSERT INTO public.payment_details VALUES (69, 130, false, NULL);
INSERT INTO public.payment_details VALUES (70, 131, false, NULL);
INSERT INTO public.payment_details VALUES (71, 132, false, NULL);
INSERT INTO public.payment_details VALUES (72, 133, false, NULL);
INSERT INTO public.payment_details VALUES (73, 134, false, NULL);
INSERT INTO public.payment_details VALUES (74, 135, false, NULL);
INSERT INTO public.payment_details VALUES (75, 136, false, NULL);
INSERT INTO public.payment_details VALUES (76, 137, false, NULL);
INSERT INTO public.payment_details VALUES (77, 138, false, NULL);
INSERT INTO public.payment_details VALUES (78, 139, false, NULL);
INSERT INTO public.payment_details VALUES (79, 140, false, NULL);
INSERT INTO public.payment_details VALUES (80, 141, false, NULL);
INSERT INTO public.payment_details VALUES (81, 142, false, NULL);
INSERT INTO public.payment_details VALUES (82, 143, false, NULL);
INSERT INTO public.payment_details VALUES (83, 144, false, NULL);
INSERT INTO public.payment_details VALUES (84, 145, false, NULL);
INSERT INTO public.payment_details VALUES (85, 146, false, NULL);
INSERT INTO public.payment_details VALUES (86, 147, false, NULL);
INSERT INTO public.payment_details VALUES (87, 148, false, NULL);
INSERT INTO public.payment_details VALUES (88, 149, false, NULL);
INSERT INTO public.payment_details VALUES (89, 150, false, NULL);
INSERT INTO public.payment_details VALUES (90, 151, false, NULL);
INSERT INTO public.payment_details VALUES (91, 152, false, NULL);
INSERT INTO public.payment_details VALUES (92, 153, false, NULL);
INSERT INTO public.payment_details VALUES (93, 154, false, NULL);
INSERT INTO public.payment_details VALUES (94, 155, false, NULL);
INSERT INTO public.payment_details VALUES (95, 156, false, NULL);
INSERT INTO public.payment_details VALUES (96, 157, false, NULL);
INSERT INTO public.payment_details VALUES (97, 158, false, NULL);
INSERT INTO public.payment_details VALUES (98, 159, false, NULL);
INSERT INTO public.payment_details VALUES (99, 160, false, NULL);
INSERT INTO public.payment_details VALUES (100, 161, false, NULL);
INSERT INTO public.payment_details VALUES (101, 162, false, NULL);
INSERT INTO public.payment_details VALUES (102, 163, false, NULL);
INSERT INTO public.payment_details VALUES (103, 164, false, NULL);
INSERT INTO public.payment_details VALUES (104, 165, false, NULL);
INSERT INTO public.payment_details VALUES (105, 166, false, NULL);
INSERT INTO public.payment_details VALUES (106, 167, false, NULL);
INSERT INTO public.payment_details VALUES (107, 168, false, NULL);
INSERT INTO public.payment_details VALUES (108, 169, false, NULL);
INSERT INTO public.payment_details VALUES (109, 170, false, NULL);
INSERT INTO public.payment_details VALUES (110, 171, false, NULL);
INSERT INTO public.payment_details VALUES (111, 172, false, NULL);
INSERT INTO public.payment_details VALUES (112, 173, false, NULL);
INSERT INTO public.payment_details VALUES (113, 174, false, NULL);
INSERT INTO public.payment_details VALUES (114, 175, false, NULL);
INSERT INTO public.payment_details VALUES (115, 176, false, NULL);
INSERT INTO public.payment_details VALUES (116, 177, false, NULL);
INSERT INTO public.payment_details VALUES (117, 178, false, NULL);
INSERT INTO public.payment_details VALUES (118, 179, false, NULL);
INSERT INTO public.payment_details VALUES (119, 180, false, NULL);
INSERT INTO public.payment_details VALUES (120, 181, false, NULL);
INSERT INTO public.payment_details VALUES (121, 182, false, NULL);
INSERT INTO public.payment_details VALUES (122, 183, false, NULL);
INSERT INTO public.payment_details VALUES (123, 184, false, NULL);
INSERT INTO public.payment_details VALUES (124, 185, false, NULL);
INSERT INTO public.payment_details VALUES (125, 186, false, NULL);
INSERT INTO public.payment_details VALUES (126, 187, false, NULL);
INSERT INTO public.payment_details VALUES (127, 188, false, NULL);
INSERT INTO public.payment_details VALUES (128, 189, false, NULL);
INSERT INTO public.payment_details VALUES (129, 190, false, NULL);
INSERT INTO public.payment_details VALUES (130, 191, false, NULL);
INSERT INTO public.payment_details VALUES (131, 192, false, NULL);
INSERT INTO public.payment_details VALUES (132, 193, false, NULL);
INSERT INTO public.payment_details VALUES (133, 194, false, NULL);
INSERT INTO public.payment_details VALUES (134, 195, false, NULL);
INSERT INTO public.payment_details VALUES (135, 196, false, NULL);
INSERT INTO public.payment_details VALUES (136, 197, false, NULL);
INSERT INTO public.payment_details VALUES (137, 198, false, NULL);
INSERT INTO public.payment_details VALUES (138, 199, false, NULL);
INSERT INTO public.payment_details VALUES (139, 200, false, NULL);
INSERT INTO public.payment_details VALUES (140, 201, false, NULL);
INSERT INTO public.payment_details VALUES (141, 202, false, NULL);
INSERT INTO public.payment_details VALUES (142, 203, false, NULL);
INSERT INTO public.payment_details VALUES (143, 204, false, NULL);
INSERT INTO public.payment_details VALUES (144, 205, false, NULL);
INSERT INTO public.payment_details VALUES (145, 206, false, NULL);
INSERT INTO public.payment_details VALUES (146, 207, false, NULL);
INSERT INTO public.payment_details VALUES (147, 208, false, NULL);
INSERT INTO public.payment_details VALUES (148, 209, false, NULL);
INSERT INTO public.payment_details VALUES (149, 210, false, NULL);
INSERT INTO public.payment_details VALUES (150, 211, false, NULL);
INSERT INTO public.payment_details VALUES (151, 212, false, NULL);
INSERT INTO public.payment_details VALUES (152, 213, false, NULL);
INSERT INTO public.payment_details VALUES (153, 214, false, NULL);
INSERT INTO public.payment_details VALUES (154, 215, false, NULL);
INSERT INTO public.payment_details VALUES (155, 216, false, NULL);
INSERT INTO public.payment_details VALUES (156, 217, false, NULL);
INSERT INTO public.payment_details VALUES (157, 218, false, NULL);
INSERT INTO public.payment_details VALUES (158, 219, false, NULL);
INSERT INTO public.payment_details VALUES (159, 220, false, NULL);
INSERT INTO public.payment_details VALUES (160, 221, false, NULL);
INSERT INTO public.payment_details VALUES (161, 222, false, NULL);
INSERT INTO public.payment_details VALUES (162, 223, false, NULL);
INSERT INTO public.payment_details VALUES (163, 224, false, NULL);
INSERT INTO public.payment_details VALUES (164, 225, false, NULL);
INSERT INTO public.payment_details VALUES (165, 226, false, NULL);
INSERT INTO public.payment_details VALUES (166, 227, false, NULL);
INSERT INTO public.payment_details VALUES (167, 228, false, NULL);
INSERT INTO public.payment_details VALUES (168, 229, false, NULL);
INSERT INTO public.payment_details VALUES (169, 230, false, NULL);
INSERT INTO public.payment_details VALUES (170, 231, false, NULL);
INSERT INTO public.payment_details VALUES (171, 232, false, NULL);
INSERT INTO public.payment_details VALUES (172, 233, false, NULL);
INSERT INTO public.payment_details VALUES (173, 234, false, NULL);
INSERT INTO public.payment_details VALUES (174, 235, false, NULL);
INSERT INTO public.payment_details VALUES (175, 236, false, NULL);
INSERT INTO public.payment_details VALUES (176, 237, false, NULL);
INSERT INTO public.payment_details VALUES (177, 238, false, NULL);
INSERT INTO public.payment_details VALUES (178, 239, false, NULL);
INSERT INTO public.payment_details VALUES (179, 240, false, NULL);
INSERT INTO public.payment_details VALUES (180, 241, false, NULL);
INSERT INTO public.payment_details VALUES (181, 242, false, NULL);
INSERT INTO public.payment_details VALUES (182, 243, false, NULL);
INSERT INTO public.payment_details VALUES (183, 244, false, NULL);
INSERT INTO public.payment_details VALUES (184, 245, false, NULL);
INSERT INTO public.payment_details VALUES (185, 246, false, NULL);
INSERT INTO public.payment_details VALUES (186, 247, false, NULL);
INSERT INTO public.payment_details VALUES (187, 248, false, NULL);
INSERT INTO public.payment_details VALUES (188, 249, false, NULL);
INSERT INTO public.payment_details VALUES (189, 250, false, NULL);
INSERT INTO public.payment_details VALUES (190, 251, false, NULL);
INSERT INTO public.payment_details VALUES (191, 252, false, NULL);
INSERT INTO public.payment_details VALUES (192, 253, false, NULL);
INSERT INTO public.payment_details VALUES (193, 254, false, NULL);
INSERT INTO public.payment_details VALUES (194, 255, false, NULL);
INSERT INTO public.payment_details VALUES (195, 256, false, NULL);
INSERT INTO public.payment_details VALUES (196, 257, true, NULL);
INSERT INTO public.payment_details VALUES (197, 258, false, NULL);
INSERT INTO public.payment_details VALUES (198, 259, false, NULL);
INSERT INTO public.payment_details VALUES (199, 260, false, NULL);
INSERT INTO public.payment_details VALUES (200, 261, false, NULL);
INSERT INTO public.payment_details VALUES (201, 262, false, NULL);
INSERT INTO public.payment_details VALUES (202, 263, false, NULL);
INSERT INTO public.payment_details VALUES (203, 264, false, NULL);
INSERT INTO public.payment_details VALUES (204, 265, false, NULL);
INSERT INTO public.payment_details VALUES (205, 266, false, NULL);
INSERT INTO public.payment_details VALUES (206, 267, false, NULL);
INSERT INTO public.payment_details VALUES (207, 268, false, NULL);
INSERT INTO public.payment_details VALUES (208, 269, false, NULL);
INSERT INTO public.payment_details VALUES (209, 270, false, NULL);
INSERT INTO public.payment_details VALUES (210, 271, false, NULL);
INSERT INTO public.payment_details VALUES (211, 272, false, NULL);
INSERT INTO public.payment_details VALUES (212, 273, false, NULL);
INSERT INTO public.payment_details VALUES (213, 274, false, NULL);
INSERT INTO public.payment_details VALUES (214, 275, false, NULL);
INSERT INTO public.payment_details VALUES (215, 276, false, NULL);
INSERT INTO public.payment_details VALUES (216, 277, false, NULL);
INSERT INTO public.payment_details VALUES (217, 278, false, NULL);
INSERT INTO public.payment_details VALUES (218, 279, false, NULL);
INSERT INTO public.payment_details VALUES (219, 280, false, NULL);
INSERT INTO public.payment_details VALUES (220, 281, false, NULL);
INSERT INTO public.payment_details VALUES (221, 282, false, NULL);
INSERT INTO public.payment_details VALUES (222, 283, false, NULL);
INSERT INTO public.payment_details VALUES (223, 284, false, NULL);
INSERT INTO public.payment_details VALUES (224, 285, false, NULL);
INSERT INTO public.payment_details VALUES (225, 286, false, NULL);
INSERT INTO public.payment_details VALUES (226, 287, false, NULL);
INSERT INTO public.payment_details VALUES (227, 288, false, NULL);
INSERT INTO public.payment_details VALUES (228, 289, false, NULL);
INSERT INTO public.payment_details VALUES (229, 290, false, NULL);
INSERT INTO public.payment_details VALUES (230, 291, false, NULL);
INSERT INTO public.payment_details VALUES (231, 292, false, NULL);
INSERT INTO public.payment_details VALUES (232, 293, false, NULL);
INSERT INTO public.payment_details VALUES (233, 294, false, NULL);
INSERT INTO public.payment_details VALUES (234, 295, false, NULL);
INSERT INTO public.payment_details VALUES (235, 296, false, NULL);
INSERT INTO public.payment_details VALUES (236, 297, false, NULL);
INSERT INTO public.payment_details VALUES (237, 298, false, NULL);
INSERT INTO public.payment_details VALUES (238, 299, false, NULL);
INSERT INTO public.payment_details VALUES (239, 300, true, NULL);
INSERT INTO public.payment_details VALUES (240, 301, false, NULL);
INSERT INTO public.payment_details VALUES (241, 302, false, NULL);


--
-- TOC entry 4054 (class 0 OID 24709)
-- Dependencies: 227
-- Data for Name: work_schedule_day; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4056 (class 0 OID 24717)
-- Dependencies: 229
-- Data for Name: work_schedule_interval; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4088 (class 0 OID 0)
-- Dependencies: 196
-- Name: account_details_account_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_details_account_details_id_seq', 1, false);


--
-- TOC entry 4089 (class 0 OID 0)
-- Dependencies: 200
-- Name: appointment_cancel_reschedule_appointment_cancel_reschedule_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq', 1, false);


--
-- TOC entry 4090 (class 0 OID 0)
-- Dependencies: 202
-- Name: appointment_doc_config_appointment_doc_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_doc_config_appointment_doc_config_id_seq', 51, true);


--
-- TOC entry 4091 (class 0 OID 0)
-- Dependencies: 198
-- Name: appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_id_seq', 302, true);


--
-- TOC entry 4092 (class 0 OID 0)
-- Dependencies: 216
-- Name: appointment_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_seq', 17, true);


--
-- TOC entry 4093 (class 0 OID 0)
-- Dependencies: 217
-- Name: doc_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_can_resch_doc_config_can_resch_id_seq', 2, true);


--
-- TOC entry 4094 (class 0 OID 0)
-- Dependencies: 222
-- Name: doc_config_schedule_day_doc_config_schedule_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq', 7, true);


--
-- TOC entry 4095 (class 0 OID 0)
-- Dependencies: 223
-- Name: doc_config_schedule_interval_doc_config_schedule_interval_i_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq', 141, true);


--
-- TOC entry 4096 (class 0 OID 0)
-- Dependencies: 221
-- Name: docconfigid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.docconfigid_seq', 25, true);


--
-- TOC entry 4097 (class 0 OID 0)
-- Dependencies: 208
-- Name: doctor_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_can_resch_doc_config_can_resch_id_seq', 1, false);


--
-- TOC entry 4098 (class 0 OID 0)
-- Dependencies: 210
-- Name: doctor_config_pre_consultation_doctor_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_pre_consultation_doctor_config_id_seq', 1, false);


--
-- TOC entry 4099 (class 0 OID 0)
-- Dependencies: 218
-- Name: doctor_config_preconsultation_doctor_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_preconsultation_doctor_config_id_seq', 9, true);


--
-- TOC entry 4100 (class 0 OID 0)
-- Dependencies: 219
-- Name: doctor_details_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_details_doctor_id_seq', 1, false);


--
-- TOC entry 4101 (class 0 OID 0)
-- Dependencies: 206
-- Name: doctor_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_doctor_id_seq', 1, false);


--
-- TOC entry 4102 (class 0 OID 0)
-- Dependencies: 214
-- Name: interval_days_interval_days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interval_days_interval_days_id_seq', 1, false);


--
-- TOC entry 4103 (class 0 OID 0)
-- Dependencies: 230
-- Name: openvidu_session_openvidu_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.openvidu_session_openvidu_session_id_seq', 5, true);


--
-- TOC entry 4104 (class 0 OID 0)
-- Dependencies: 232
-- Name: openvidu_session_token_openvidu_session_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.openvidu_session_token_openvidu_session_token_id_seq', 2, true);


--
-- TOC entry 4105 (class 0 OID 0)
-- Dependencies: 224
-- Name: patient_details_patient_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_details_patient_details_id_seq', 123, true);


--
-- TOC entry 4106 (class 0 OID 0)
-- Dependencies: 212
-- Name: payment_details_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_details_payment_id_seq', 241, true);


--
-- TOC entry 4107 (class 0 OID 0)
-- Dependencies: 226
-- Name: work_schedule_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_schedule_day_id_seq', 1, false);


--
-- TOC entry 4108 (class 0 OID 0)
-- Dependencies: 228
-- Name: work_schedule_interval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_schedule_interval_id_seq', 1, false);


--
-- TOC entry 3846 (class 2606 OID 16497)
-- Name: account_details account_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_details_pkey PRIMARY KEY (account_details_id);


--
-- TOC entry 3848 (class 2606 OID 16499)
-- Name: account_details account_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_key_unique UNIQUE (account_key);


--
-- TOC entry 3852 (class 2606 OID 16518)
-- Name: appointment_cancel_reschedule appointment_cancel_reschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT appointment_cancel_reschedule_pkey PRIMARY KEY (appointment_cancel_reschedule_id);


--
-- TOC entry 3855 (class 2606 OID 16535)
-- Name: appointment_doc_config appointment_doc_config_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT appointment_doc_config_id PRIMARY KEY (appointment_doc_config_id);


--
-- TOC entry 3850 (class 2606 OID 16510)
-- Name: appointment appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (id);


--
-- TOC entry 3870 (class 2606 OID 16595)
-- Name: doctor_config_can_resch doc_config_can_resch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_can_resch
    ADD CONSTRAINT doc_config_can_resch_pkey PRIMARY KEY (doc_config_can_resch_id);


--
-- TOC entry 3881 (class 2606 OID 24657)
-- Name: doc_config doc_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doc_config_pkey PRIMARY KEY (id);


--
-- TOC entry 3858 (class 2606 OID 24683)
-- Name: doc_config_schedule_day doc_config_schedule_day_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_config_schedule_day_id PRIMARY KEY (id);


--
-- TOC entry 3861 (class 2606 OID 24681)
-- Name: doc_config_schedule_interval doc_config_schedule_interval_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_config_schedule_interval_id PRIMARY KEY (id);


--
-- TOC entry 3872 (class 2606 OID 16606)
-- Name: doctor_config_pre_consultation doctor_config_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_pre_consultation
    ADD CONSTRAINT doctor_config_id PRIMARY KEY (doctor_config_id);


--
-- TOC entry 3865 (class 2606 OID 16576)
-- Name: doctor doctor_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_id PRIMARY KEY ("doctorId");


--
-- TOC entry 3867 (class 2606 OID 16578)
-- Name: doctor doctor_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_key_unique UNIQUE (doctor_key);


--
-- TOC entry 3879 (class 2606 OID 16647)
-- Name: interval_days interval_days_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interval_days
    ADD CONSTRAINT interval_days_id PRIMARY KEY (interval_days_id);


--
-- TOC entry 3890 (class 2606 OID 24778)
-- Name: openvidu_session openvidu_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session
    ADD CONSTRAINT openvidu_session_pkey PRIMARY KEY (openvidu_session_id);


--
-- TOC entry 3892 (class 2606 OID 24791)
-- Name: openvidu_session_token openvidu_session_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session_token
    ADD CONSTRAINT openvidu_session_token_pkey PRIMARY KEY (openvidu_session_token_id);


--
-- TOC entry 3883 (class 2606 OID 24699)
-- Name: patient_details patient_details_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_details
    ADD CONSTRAINT patient_details_id PRIMARY KEY (id);


--
-- TOC entry 3876 (class 2606 OID 16633)
-- Name: payment_details payment_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_id PRIMARY KEY (id);


--
-- TOC entry 3885 (class 2606 OID 24714)
-- Name: work_schedule_day work_schedule_day_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_day
    ADD CONSTRAINT work_schedule_day_pkey PRIMARY KEY (id);


--
-- TOC entry 3888 (class 2606 OID 24722)
-- Name: work_schedule_interval work_schedule_interval_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT work_schedule_interval_pkey PRIMARY KEY (id);


--
-- TOC entry 3856 (class 1259 OID 16541)
-- Name: fki_app_doc_con_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_app_doc_con_to_app_id ON public.appointment_doc_config USING btree (appointment_id);


--
-- TOC entry 3853 (class 1259 OID 16524)
-- Name: fki_can_resch_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_can_resch_to_app_id ON public.appointment_cancel_reschedule USING btree (appointment_id);


--
-- TOC entry 3873 (class 1259 OID 16607)
-- Name: fki_doc_config_to_doc_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doc_config_to_doc_key ON public.doctor_config_pre_consultation USING btree (doctor_key);


--
-- TOC entry 3859 (class 1259 OID 24706)
-- Name: fki_doc_sched_to_doc_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doc_sched_to_doc_id ON public.doc_config_schedule_day USING btree (doctor_id);


--
-- TOC entry 3868 (class 1259 OID 16584)
-- Name: fki_doctor_to_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doctor_to_account ON public.doctor USING btree (account_key);


--
-- TOC entry 3877 (class 1259 OID 16653)
-- Name: fki_int_days_to_wrk_sched_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_int_days_to_wrk_sched_id ON public.interval_days USING btree (wrk_sched_id);


--
-- TOC entry 3862 (class 1259 OID 16563)
-- Name: fki_interval_to_wrk_sched_con_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_interval_to_wrk_sched_con_id ON public.doc_config_schedule_interval USING btree ("docConfigScheduleDayId");


--
-- TOC entry 3863 (class 1259 OID 16564)
-- Name: fki_interval_to_wrk_sched_config_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_interval_to_wrk_sched_config_id ON public.doc_config_schedule_interval USING btree ("docConfigScheduleDayId");


--
-- TOC entry 3874 (class 1259 OID 16639)
-- Name: fki_payment_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_payment_to_app_id ON public.payment_details USING btree (appointment_id);


--
-- TOC entry 3886 (class 1259 OID 24728)
-- Name: fki_workScheduleIntervalToDay; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_workScheduleIntervalToDay" ON public.work_schedule_interval USING btree (work_schedule_day_id);


--
-- TOC entry 3894 (class 2606 OID 16536)
-- Name: appointment_doc_config app_doc_con_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT app_doc_con_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- TOC entry 3893 (class 2606 OID 16519)
-- Name: appointment_cancel_reschedule can_resch_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT can_resch_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- TOC entry 3896 (class 2606 OID 24684)
-- Name: doc_config_schedule_interval doc_sched_interval_to_day; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_sched_interval_to_day FOREIGN KEY ("docConfigScheduleDayId") REFERENCES public.doc_config_schedule_day(id) NOT VALID;


--
-- TOC entry 3895 (class 2606 OID 24701)
-- Name: doc_config_schedule_day doc_sched_to_doc_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_sched_to_doc_id FOREIGN KEY (doctor_id) REFERENCES public.doctor("doctorId") NOT VALID;


--
-- TOC entry 3899 (class 2606 OID 24658)
-- Name: doc_config doctor_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doctor_key FOREIGN KEY (doctor_key) REFERENCES public.doctor(doctor_key);


--
-- TOC entry 3897 (class 2606 OID 16579)
-- Name: doctor doctor_to_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_to_account FOREIGN KEY (account_key) REFERENCES public.account_details(account_key);


--
-- TOC entry 3901 (class 2606 OID 24792)
-- Name: openvidu_session_token openvidu_session_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session_token
    ADD CONSTRAINT openvidu_session_id FOREIGN KEY (openvidu_session_id) REFERENCES public.openvidu_session(openvidu_session_id);


--
-- TOC entry 3898 (class 2606 OID 16634)
-- Name: payment_details payment_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- TOC entry 3900 (class 2606 OID 24723)
-- Name: work_schedule_interval workScheduleIntervalToDay; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT "workScheduleIntervalToDay" FOREIGN KEY (work_schedule_day_id) REFERENCES public.work_schedule_day(id) NOT VALID;


--
-- TOC entry 4067 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2020-07-31 19:26:32

--
-- PostgreSQL database dump complete
--

-- Table: public.openvidu_session

-- DROP TABLE public.openvidu_session;

CREATE TABLE public.openvidu_session
(
    openvidu_session_id integer NOT NULL DEFAULT nextval('openvidu_session_openvidu_session_id_seq'::regclass),
    doctor_key character varying(100) COLLATE pg_catalog."default" NOT NULL,
    session_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    session_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT openvidu_session_pkey PRIMARY KEY (openvidu_session_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.openvidu_session
    OWNER to postgres;


-- Table: public.openvidu_session_token

-- DROP TABLE public.openvidu_session_token;

CREATE TABLE public.openvidu_session_token
(
    openvidu_session_token_id integer NOT NULL DEFAULT nextval('openvidu_session_token_openvidu_session_token_id_seq'::regclass),
    openvidu_session_id bigint NOT NULL,
    token text COLLATE pg_catalog."default" NOT NULL,
    doctor_id bigint,
    patient_id bigint,
    CONSTRAINT openvidu_session_token_pkey PRIMARY KEY (openvidu_session_token_id),
    CONSTRAINT openvidu_session_id FOREIGN KEY (openvidu_session_id)
        REFERENCES public.openvidu_session (openvidu_session_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.openvidu_session_token
    OWNER to postgres;

ALTER TABLE public.account_details
    RENAME photo TO hospital_photo;

ALTER TABLE public.account_details
    ALTER COLUMN hospital_photo TYPE character varying(500) COLLATE pg_catalog."default";


CREATE TYPE public.statuses AS ENUM ('completed','paused', 'notCompleted');
    ALTER TABLE public.appointment ADD status public.statuses default 'notCompleted';

ALTER TABLE public.appointment
ADD COLUMN "createdTime" timestamp without time zone;

CREATE TYPE public.live_statuses AS ENUM ('offline','online', 'videoSessionReady', 'inSession'); 
ALTER TABLE patient_details ADD live_status public.live_statuses default 'offline';

ALTER TABLE public.patient_details
ADD COLUMN last_active timestamp without time zone;

ALTER TABLE public.doctor ADD live_status public.live_statuses default 'offline';

ALTER TABLE public.doctor
ADD COLUMN last_active timestamp without time zone;

CREATE TABLE public.message_template
(
    id serial NOT NULL,
    sender character varying(200),
    subject character varying(200),
    body character varying(5000),
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.message_template
    OWNER to postgres;

CREATE TABLE public.message_type
(
    id serial NOT NULL,
    name character varying(200),
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.message_type
    OWNER to postgres;

CREATE TABLE public.communication_type
(
    id serial NOT NULL,
    name character varying(100),
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);


ALTER TABLE public.communication_type
    OWNER to postgres;

INSERT INTO public.communication_type (
id, name) VALUES (
'1'::integer, 'Email'::character varying)
 returning id;

 INSERT INTO public.communication_type (
id, name) VALUES (
'2'::integer, 'sms'::character varying)
 returning id;

CREATE TABLE public.message_template_placeholders
(
id serial NOT NULL,
message_template_id bigint,
placeholder_name character varying(200),
message_type_id bigint,
PRIMARY KEY (id),
CONSTRAINT message_template_id FOREIGN KEY (message_template_id)
REFERENCES public.message_template (id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION
NOT VALID,
CONSTRAINT message_type_id FOREIGN KEY (message_type_id)
REFERENCES public.message_type (id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION
NOT VALID
)
WITH (
OIDS = FALSE
);

ALTER TABLE public.message_template_placeholders
OWNER to postgres;


CREATE TABLE public.message_metadata
(
    id serial NOT NULL,
    message_type_id bigint,
    communication_type_id bigint,
    message_template_id bigint,
    PRIMARY KEY (id),
    CONSTRAINT message_type_id FOREIGN KEY (message_type_id)
        REFERENCES public.message_type (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT communication_type_id FOREIGN KEY (communication_type_id)
        REFERENCES public.communication_type (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT message_template_id FOREIGN KEY (message_template_id)
        REFERENCES public.message_template (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.message_metadata
    OWNER to postgres;

ALTER TABLE public.account_details
    ADD COLUMN country character varying(100);

ALTER TABLE public.account_details
    ADD COLUMN landmark character varying(100);

CREATE TABLE public.prescription
(
id serial NOT NULL,
appointment_id bigint NOT NULL,
appointment_date date,
hospital_logo character varying(500),
hospital_name character varying(100),
doctor_name character varying(200),
doctor_signature character varying(500),
patient_name character varying(200),
CONSTRAINT "appointmentId" FOREIGN KEY (appointment_id)
REFERENCES public.appointment (id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION
NOT VALID
)
WITH (
OIDS = FALSE
);

ALTER TABLE public.prescription
OWNER to postgres;

ALTER TABLE public.prescription
    ADD CONSTRAINT "prescriptionId" UNIQUE (id)
    INCLUDE (id);

CREATE TABLE public.medicine
(
    id serial NOT NULL,
    prescription_id bigint NOT NULL,
    name_of_medicine character varying,
    frequency_of_each_dose character varying,
    count_of_medicine_for_each_dose bigint,
    type_of_medicine character varying,
    dose_of_medicine character varying,
    count_of_days character varying,
    PRIMARY KEY (id),
    CONSTRAINT prescription_id_medicine FOREIGN KEY (prescription_id)
        REFERENCES public.prescription (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.medicine
    OWNER to postgres;

ALTER TABLE public.prescription
ADD COLUMN prescription_url character varying;

ALTER TABLE public.account_details DROP COLUMN street2;

ALTER TABLE public.account_details
    RENAME support_email TO "supportEmail";


ALTER TABLE public.account_details DROP COLUMN city;

ALTER TABLE public.account_details
    ADD COLUMN city character varying(100);

ALTER TABLE public.account_details
    ALTER COLUMN state DROP NOT NULL;

ALTER TABLE public.account_details
    ADD COLUMN "cityState" character varying;

CREATE TABLE public.patient_report
(
    id serial NOT NULL,
    patient_id bigint NOT NULL,
    appointment_id bigint,
    "file_name " character varying NOT NULL,
    file_type character varying NOT NULL,
    report_url character varying NOT NULL,
    comments character varying,
    report_date date,
    CONSTRAINT patient_report_id PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.patient_report
    OWNER to postgres;

ALTER TABLE public.patient_report
    RENAME "file_name " TO file_name;
ALTER TABLE public.appointment
    ADD COLUMN "hasConsultation" boolean NOT NULL DEFAULT False;

COMMENT ON COLUMN public.appointment."hasConsultation"
    IS 'true means consultation started';

ALTER TABLE public.patient_details
ADD COLUMN city character varying(100);

---Email template
ALTER TABLE public.message_template
    ALTER COLUMN body TYPE  character varying(500000);

INSERT INTO public.message_template (
id, sender, subject, body) VALUES (
'3'::integer, 'notifiaction@virujh.com'::character varying, 'Appointment Created'::character varying, ' <div style="height: 7px; background-color: #535353;"></div><div style="background-color:#E8E8E8; margin:0px; padding:20px 20px 40px 20px; font-family:Open Sans, Helvetica, sans-serif; font-size:12px; color:#535353;"><div style="text-align:center; font-size:24px; font-weight:bold; color:#535353;">New Appointment Created</div><div style="text-align:center; font-size:18px; font-weight:bold; color:#535353; padding: inherit">One user created appointment through VIRUJH. Please find the appointment details Below</div></div>
             <div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Created By</div><div style="display: inline-block;">: {role}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment Id</div><div style="display: inline-block;">: {appointmentId}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Doctor Name</div><div style="display: inline-block;">: {doctorFirstName} {doctorLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Patient Name</div><div style="display: inline-block;">: {patientFirstName} {patientLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment Date</div><div style="display: inline-block;">: {appointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment Start time</div><div style="display: inline-block;">: {startTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment End time</div><div style="display: inline-block;">: {endTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Email</div><div style="display: inline-block;">: {email}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div  class="reset_titles" style="display: inline-block;">Hospital</div><div style="display: inline-block;">: {hospital}</div></div><br>Thank you</div></div>  '::character varying)
 returning id;
 
INSERT INTO public.message_type (
id, name, description) VALUES (
'3'::integer, 'APPOINTMENT_CREATED'::character varying, 'Appointment Created'::character varying)
 returning id;

INSERT INTO public.message_metadata (
id, message_type_id, communication_type_id, message_template_id) VALUES (
'3'::integer, '3'::bigint, '1'::bigint, '3'::bigint)
 returning id;

INSERT INTO public.message_template (
id, sender, subject, body) VALUES (
'4'::integer, 'notifiaction@virujh.com'::character varying, 'Appointment Reschedule'::character varying, '<div style="height: 7px; background-color: #535353;"></div><div style="background-color:#E8E8E8; margin:0px; padding:20px 20px 40px 20px; font-family:Open Sans, Helvetica, sans-serif; font-size:12px; color:#535353;"><div style="text-align:center; font-size:24px; font-weight:bold; color:#535353;">Appointment Rescheduled</div><div style="text-align:center; font-size:18px; font-weight:bold; color:#535353; padding: inherit">One user rescheduled appointment through VIRUJH. Please find the appointment details Below</div></div>
         <div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Rescheduled By</div><div style="display: inline-block;">: {role}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Old Appointment Id</div><div style="display: inline-block;">: {appointmentId}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Doctor Name</div><div style="display: inline-block;">: {doctorFirstName} {doctorLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Patient Name</div><div style="display: inline-block;">: {patientFirstName} {patientLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment Date</div><div style="display: inline-block;">: {appointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment Start time</div><div style="display: inline-block;">: {startTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment End time</div><div style="display: inline-block;">: {endTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Rescheduled Appointment Date</div><div style="display: inline-block;">: {rescheduledAppointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Rescheduled Appointment Start time</div><div style="display: inline-block;">: {rescheduledStartTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Resheduled Appointment End time</div><div style="display: inline-block;">: {rescheduledEndTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Rescheduled On</div><div style="display: inline-block;">: {rescheduledOn}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div  class="reset_titles" style="display: inline-block;">Hospital</div><div style="display: inline-block;">: {hospital}</div></div><br>Thank you</div></div>  '::character varying)
 returning id;



INSERT INTO public.message_type (
id, name, description) VALUES (
'4'::integer, 'APPOINTMENT_RESCHEDULE'::character varying, 'Appointment Reschedule'::character varying)
 returning id;

INSERT INTO public.message_metadata (
id, message_type_id, communication_type_id, message_template_id) VALUES (
'4'::integer, '4'::bigint, '1'::bigint, '4'::bigint)
 returning id;


 INSERT INTO public.message_template (
id, sender, subject, body) VALUES (
'5'::integer, 'notifiaction@virujh.com'::character varying, 'Appointment Cancel'::character varying, ' <div style="height: 7px; background-color: #535353;"></div><div style="background-color:#E8E8E8; margin:0px; padding:20px 20px 40px 20px; font-family:Open Sans, Helvetica, sans-serif; font-size:12px; color:#535353;"><div style="text-align:center; font-size:24px; font-weight:bold; color:#535353;">Appointment Cancelled</div><div style="text-align:center; font-size:18px; font-weight:bold; color:#535353; padding: inherit">One user cancelled appointment through VIRUJH. Please find the appointment details Below</div></div>
      <div style="height: 7px; background-color: #535353;"></div><div style="background-color:#E8E8E8; margin:0px; padding:20px 20px 40px 20px; font-family:Open Sans, Helvetica, sans-serif; font-size:12px; color:#535353;"><div style="text-align:center; font-size:24px; font-weight:bold; color:#535353;">Appointment Cancelled</div><div style="text-align:center; font-size:18px; font-weight:bold; color:#535353; padding: inherit">One user cancelled appointment through VIRUJH. Please find the appointment details Below</div></div>
         <div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Cancelled By</div><div style="display: inline-block;">: {role}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment Id</div><div style="display: inline-block;">: {appointmentId}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Doctor Name</div><div style="display: inline-block;">: {doctorFirstName} {doctorLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Patient Name</div><div style="display: inline-block;">: {patientFirstName} {patientLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment Date</div><div style="display: inline-block;">: {appointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment Start time</div><div style="display: inline-block;">: {startTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Appointment End time</div><div style="display: inline-block;">: {endTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Email</div><div style="display: inline-block;">: {email}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div class="reset_titles" style="display: inline-block;">Cancelled On</div><div style="display: inline-block;">: {cancelledOn}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
<div  class="reset_titles" style="display: inline-block;">Hospital</div><div style="display: inline-block;">: {hospital}</div></div><br>Thank you</div></div> 
       '::character varying)
 returning id;



INSERT INTO public.message_type (
id, name, description) VALUES (
'5'::integer, 'APPOINTMENT_CANCEL'::character varying, 'Appointment Cancel '::character varying)
 returning id;

INSERT INTO public.message_metadata (
id, message_type_id, communication_type_id, message_template_id) VALUES (
'5'::integer, '5'::bigint, '1'::bigint, '5'::bigint)
 returning id;

 INSERT INTO public.message_template (
body, subject, sender, id) VALUES (
'<div><p>Hello {user_name},</p></div>
        <div><p>Your patient registration request has been process successfully.
      </p>
        </div>
        <div class="reset_titles" style="display: inline-block;">Email</div><div style="display: inline-block;">: {email}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
          <div class="reset_titles" style="display: inline-block;">Phone</div><div style="display: inline-block;">: {phone}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">
            <div class="reset_titles" style="display: inline-block;">Password</div>: <span style=" text-align: left; color: #0bb5ff; "><em><b> {password}</b></em></span>
        <br><br>
        <div><em>Thank You</em><div>
        <p><span>VIRUJH</span></p>'::character varying, 'Patient Registration'::character varying, 'notifiaction@virujh.com'::character varying, '6'::integer)
 returning id;

INSERT INTO public.message_type (
id, name, description) VALUES (
'6'::integer, 'PATIENT_REGISTRATION'::character varying, 'Patient Registration'::character varying)
 returning id;

INSERT INTO public.message_metadata (
id, message_type_id, communication_type_id, message_template_id) VALUES (
'6'::integer, '6'::bigint, '1'::bigint, '6'::bigint)
 returning id;


  INSERT INTO public.message_template (
body, subject, sender, id) VALUES (
'<div><p>Hello {user_name},</p></div>
        <div><p>Your registration has been process successfully.</p>
        </div>
        <br><br>
        <div><em>Thank You</em><div>
        <p><span>VIRUJH</span></p>'::character varying, 'Registration For Doctor'::character varying, 'notifiaction@virujh.com'::character varying, '2'::integer)
 returning id;


 INSERT INTO public.message_type (
id, name, description) VALUES (
'2'::integer, 'REGISTRATION_FOR_DOCTOR'::character varying, 'Registration For Doctor'::character varying)
 returning id;


 INSERT INTO public.message_metadata (
message_type_id, communication_type_id, message_template_id, id) VALUES (
'2'::bigint, '1'::bigint, '2'::bigint, '2'::integer)
 returning id;
 
 --- Advertisement table

 CREATE TABLE public.advertisement (
     id integer NOT NULL,
     name character varying(100) COLLATE pg_catalog."default",
     content character varying(5000) COLLATE pg_catalog."default",
     code character varying(1000)  COLLATE pg_catalog."default",
     "createdTime" timestamp without time zone,
     is_active boolean,
     CONSTRAINT advertisement_pkey PRIMARY KEY (id)
)
TABLESPACE pg_default;

ALTER TABLE public.advertisement 
    OWNER to postgres;
	
INSERT INTO public.advertisement values(1,'Medicine', 'Save 50% offer for acetaminophen medicine up to 24 hours', 'NB8ws6');

---Added description for message table
ALTER TABLE public.message_type
    ADD COLUMN description character varying;

--Updated email template body length and email template
ALTER TABLE public.message_template
    ALTER COLUMN body TYPE  character varying(500000);
    UPDATE public.message_template SET
body = '<html>
    <header>
        <meta name="viewport" content="width=device-width, initial-scale=1">
             
    </header>
    <body >
     <div style="padding-top:5px; width:720px; margin:10px auto">
    <div style="padding: 10px 20px 10px ; border:1px solid #ddd;">
        <div id="content-main" style="display: flex;justify-content: center;">
            <div id="center-box" style="position: relative; width: 100%;background: #ffffff;">
                <div class="app-logo" style="border-bottom: 3px solid #0BB5FF;text-align: center;padding: 6px;">
                    <img src="{virujh-logo}" class="logo-design" style="width: 117px; height: 89px;" />     
                    <img src="{corner-plus}" class="svg-top-right-design" style="position: absolute;right: 0;width: 76px;height: 91px;top: 0;z-index: 0;" />
                </div>
                <div class="content-box" style="padding: 20px;">
                    <h1 style="font-style: normal;font-weight: bold;font-size: 30px; text-align: center;color: #545454;margin: 0px;">Password Reset</h1>
                    <h1 style=" font-style: normal;font-weight: 600; font-size: 25px;line-height: 37px;
text-align: left; color: #000000;">Hi, {user_name}</h1>
                   <div  style="font-style: normal; font-weight: 500; font-size: 18px; color: #878787; text-align: left;"><p>Your reset password request has been process successfully. Your password is <span style="color: #0bb5ff;"><em><b>{password}</b></em></span></p>
        </div>
                    <h2 style="font-style: normal; font-weight: 500; font-size: 18px; color: #878787; text-align: left;">If you did not forget your password you safely ignore this email.</h2>
                </div>
                
            </div>
        </div>
           </div>
        </div>
    </body>
</html>
'::character varying WHERE
id = 1;
    UPDATE public.message_template SET
body = '<html>
    <header>
        <meta name="viewport" content="width=device-width, initial-scale=1">
             
    </header>
    <body>
     <div style="padding-top:5px; width:720px; margin:10px auto">
    <div style="padding: 10px 20px 10px ; border:1px solid #ddd;">
        <div id="content-main" style="display: flex;justify-content: center;">
            <div id="center-box" style="position: relative; width: 100%;background: #ffffff;">
                <div class="app-logo" style="border-bottom: 3px solid #0BB5FF;text-align: center;padding: 6px;">
                    <img src="{virujh-logo}" class="logo-design" style="width: 117px; height: 89px;" />     
                    <img src="{corner-plus}" class="svg-top-right-design" style="position: absolute;right: 0;width: 76px;height: 91px;top: 0;z-index: 0;" />
                </div>
                <div class="content-box" style="padding: 20px;">
                    <h1 style="font-style: normal;font-weight: bold;font-size: 30px; text-align: center;color: #545454;margin: 0px;">Doctor Registration</h1>
                    <h1 style=" font-style: normal;font-weight: 600; font-size: 25px;line-height: 37px;
text-align: left; color: #000000;">Hi, {user_name}</h1>
                   <h2 style="font-style: normal; font-weight: 500; font-size: 18px; color: #878787; text-align: left;">Your registration has been process successfully.</h2>
                </div>
                <h1 class="app-thank" style=" font-style: normal;font-weight: bold; font-size: 24px; text-align: center; color: #545454;">Thank You!</h1>
                
            </div>
        </div>
          </div>
        </div>
    </body>
</html>
'::character varying WHERE
id = 2;
UPDATE public.message_template SET
body = '<html>
    <header>
        <meta name="viewport" content="width=device-width, initial-scale=1">
             
    </header>
    <body >
    <div style="padding-top:5px; width:720px; margin:10px auto">
    <div style="padding: 10px 20px 10px ; border:1px solid #ddd;">
        <div id="content-main" style="display: flex; justify-content: center;">
            <div id="center-box" style="position: relative; width: 100%;background: #ffffff;">
                <div class="app-logo" style="border-bottom: 3px solid #0BB5FF;text-align: center;padding: 6px;">
                    <img src="{viruj-logo}" class="logo-design" style="width: 117px; height: 89px;" />     
                    <img src="{corner-plus}" class="svg-top-right-design" style="position: absolute;right: 0;width: 76px;height: 91px;top: 0;z-index: 0;" />
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                    <h1 class="header-1" style="font-family: Poppins;font-style: normal;font-weight: bold;font-size: 25px;text-align: center; color: #545454;">New Appointment Created</h1>
                    <h2 class="content-1" style="text-align: center; color: #878787; font-size: 20px; font-style: normal;font-weight: 500;">One user created appointment through VIRUJH<br>Please find the appointment detail below</h2>
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                    <h3 class="app-id" style="text-align: center;"><span class="app-id-name" style="font-style: normal;font-weight: 500;font-size: 25px;line-height: 37px;text-align: center;color: #4D4D4D;">Appointment id: </span><span class="app-id-number" style="font-style: normal;font-weight: 500;font-size: 25px; text-align: center;color: #0BB5FF;"> {appointmentId}</span></h3>
                </div>
                <div class="content-box text-center" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2); text-align: center;">
                    <h4 class="app-date-name" style="font-style: normal; font-weight: 500;font-size: 20px;color: #4D4D4D;">Appointment Date:</h4>
                    <h5 class="app-date-value" style="font-style: normal; font-weight: 600; font-size: 20px; color: #0BB5FF;">{appointmentDate}</h5>
                    <h3 class="app-start-time" style="font-style: normal; font-weight: 500;font-size: 25px; color: #4D4D4D;">Appointment Start Time</h3>
                    <h1 class="app-time" style="font-style: normal;font-weight: 500;font-size: 45px;color: #0BB5FF;">{startTime}</h1>
                    <h3 class="app-start-time" style="font-style: normal; font-weight: 500;font-size: 25px; color: #4D4D4D;">Appointment End Time </h3>
                    <h1 class="app-time" style="font-style: normal;font-weight: 500;font-size: 45px;color: #0BB5FF;">{endTime}</h1>
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                    <table class="app-table" style="width: 100%;">
                        <tr class="app-row">
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Doctor Name:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{doctorFirstName} {doctorLastName}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Hospital</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{hospital}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Email:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{email}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Patient Name:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{patientFirstName} {patientLastName}</td>
                        </tr>
                    </table>
                </div>
                <div>
                    <h1 class="app-thank" style="font-style: normal;font-weight: bold;font-size: 75px;text-align: center;color: #545454;">Thank You!</h1>
                    <div>  
                        <img src="{plus}" class="svg-bottom-design" style="position: absolute;bottom: 0; width: 115px;height: 113px;" />
                    </div>
                </div>
            </div>
        </div>
        </div>
        </div>
    </body>
</html>'::character varying WHERE
id = 3;
    UPDATE public.message_template SET
body = '<html>
    <header>
        <meta name="viewport" content="width=device-width, initial-scale=1">
             
    </header>
    <body>
     <div style="padding-top:5px; width:720px; margin:10px auto">
    <div style="padding: 10px 20px 10px ; border:1px solid #ddd;">
        <div id="content-main" style="display: flex;justify-content: center;">
            <div id="center-box" style="position: relative; width: 100%;background: #ffffff;">
                <div class="app-logo" style="border-bottom: 3px solid #0BB5FF;text-align: center;padding: 6px;">
                    <img src="{viruj-logo}" class="logo-design" style="width: 117px; height: 89px;" />     
                    <img src="{corner-plus}" class="svg-top-right-design" style="position: absolute;right: 0;width: 76px;height: 91px;top: 0;z-index: 0;" />
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                    <h1 class="header-1" style="font-family: Poppins;font-style: normal;font-weight: bold;font-size: 25px;text-align: center; color: #545454;">Appointment has been  Rescheduled</h1>
                    <h2 class="content-1" style="text-align: center; color: #878787; font-size: 20px; font-style: normal;font-weight: 500;">One user rescheduled appointment through VIRUJH<br>Please find the appointment detail below</h2>
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                
                    <h3 class="app-id" style="text-align: center;"><span class="app-id-name" style="font-style: normal;font-weight: 500;font-size: 25px;line-height: 37px;text-align: center;color: #4D4D4D;">Rescheduled By: </span><span class="app-id-number" style="font-style: normal;font-weight: 500;font-size: 25px; text-align: center;color: #0BB5FF;"> {role}</span></h3>
                    <h3 class="app-id" style="text-align: center;"><span class="app-id-name" style="font-style: normal;font-weight: 500;font-size: 25px;line-height: 37px;text-align: center;color: #4D4D4D;">Appointment id: </span><span class="app-id-number" style="font-style: normal;font-weight: 500;font-size: 25px; text-align: center;color: #0BB5FF;"> {appointmentId}</span></h3>
                </div>
                <div class="content-box text-center" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2); text-align: center;">
                    <h4 class="app-date-name" style="font-style: normal; font-weight: 500;font-size: 20px;color: #4D4D4D;">Rescheduled Appointment Date:</h4>
                    <h5 class="app-date-value" style="font-style: normal; font-weight: 600; font-size: 20px; color: #0BB5FF;">{rescheduledAppointmentDate}</h5>
                    <h3 class="app-start-time" style="font-style: normal; font-weight: 500;font-size: 25px; color: #4D4D4D;">Rescheduled Appointment Start Time</h3>
                    <h1 class="app-time" style="font-style: normal;font-weight: 500;font-size: 45px;color: #0BB5FF;">{rescheduledStartTime}</h1>
                    <h3 class="app-start-time" style="font-style: normal; font-weight: 500;font-size: 25px; color: #4D4D4D;">Rescheduled Appointment End Time </h3>
                    <h1 class="app-time" style="font-style: normal;font-weight: 500;font-size: 45px;color: #0BB5FF;">{rescheduledEndTime}</h1>
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                    <table class="app-table" style="width: 100%;">
                        <tr class="app-row">
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Doctor Name:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{doctorFirstName} {doctorLastName}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Hospital</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{hospital}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Email:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{email}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Patient Name:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{patientFirstName} {patientLastName}</td>
                        </tr>
                    </table>
                </div>
                <div>
                    <h1 class="app-thank" style="font-style: normal;font-weight: bold;font-size: 75px;text-align: center;color: #545454;">Thank You!</h1>
                    <div>  
                        <img src="{plus}" class="svg-bottom-design" style="position: absolute;bottom: 0; width: 115px;height: 113px;" />
                    </div>
                </div>
            </div>
        </div>
         </div>
        </div>
    </body>
</html>'::character varying WHERE
id = 4;
    UPDATE public.message_template SET
body = '<html>
    <header>
        <meta name="viewport" content="width=device-width, initial-scale=1">
             
    </header>
    <body >
     <div style="padding-top:5px; width:720px; margin:10px auto">
    <div style="padding: 10px 20px 10px ; border:1px solid #ddd;">
        <div id="content-main" style="display: flex;justify-content: center;">
            <div id="center-box" style="position: relative; width: 100%;background: #ffffff;">
                <div class="app-logo" style="border-bottom: 3px solid #0BB5FF;text-align: center;padding: 6px;">
                    <img src="{viruj-logo}" class="logo-design" style="width: 117px; height: 89px;" />     
                    <img src="{corner-plus}" class="svg-top-right-design" style="position: absolute;right: 0;width: 76px;height: 91px;top: 0;z-index: 0;" />
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                    <h1 class="header-1" style="font-family: Poppins;font-style: normal;font-weight: bold;font-size: 25px;text-align: center; color: #545454;">Appointment has been Cancelled</h1>
                    <h2 class="content-1" style="text-align: center; color: #878787; font-size: 20px; font-style: normal;font-weight: 500;">One user cancelled appointment through VIRUJH. Please find the appointment details Below</h2>
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                
                    <h3 class="app-id" style="text-align: center;"><span class="app-id-name" style="font-style: normal;font-weight: 500;font-size: 25px;line-height: 37px;text-align: center;color: #4D4D4D;">Cancelled By: </span><span class="app-id-number" style="font-style: normal;font-weight: 500;font-size: 25px; text-align: center;color: #0BB5FF;"> {role}</span></h3>
                    <h3 class="app-id" style="text-align: center;"><span class="app-id-name" style="font-style: normal;font-weight: 500;font-size: 25px;line-height: 37px;text-align: center;color: #4D4D4D;">Appointment id: </span><span class="app-id-number" style="font-style: normal;font-weight: 500;font-size: 25px; text-align: center;color: #0BB5FF;"> {appointmentId}</span></h3>
                </div>
                <div class="content-box text-center" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2); text-align: center;">
                    <h4 class="app-date-name" style="font-style: normal; font-weight: 500;font-size: 20px;color: #4D4D4D;">Appointment Date:</h4>
                    <h5 class="app-date-value" style="font-style: normal; font-weight: 600; font-size: 20px; color: #0BB5FF;">{appointmentDate}</h5>
                    <h3 class="app-start-time" style="font-style: normal; font-weight: 500;font-size: 25px; color: #4D4D4D;">Appointment Start Time</h3>
                    <h1 class="app-time" style="font-style: normal;font-weight: 500;font-size: 45px;color: #0BB5FF;">{startTime}</h1>
                    <h3 class="app-start-time" style="font-style: normal; font-weight: 500;font-size: 25px; color: #4D4D4D;">Appointment End Time </h3>
                    <h1 class="app-time" style="font-style: normal;font-weight: 500;font-size: 45px;color: #0BB5FF;">{endTime}</h1>
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                    <table class="app-table" style="width: 100%;">
                        <tr class="app-row">
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Doctor Name:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{doctorFirstName} {doctorLastName}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Hospital</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{hospital}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Email:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{email}</td>
                        </tr>
                            <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Cancelled On:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{cancelledOn}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Patient Name:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{patientFirstName} {patientLastName}</td>
                        </tr>
                     
                    </table>
                </div>
                <div>
                    <h1 class="app-thank" style="font-style: normal;font-weight: bold;font-size: 75px;text-align: center;color: #545454;">Thank You!</h1>
                    <div>  
                        <img src="{plus}" class="svg-bottom-design" style="position: absolute;bottom: 0; width: 115px;height: 113px;" />
                    </div>
                </div>
            </div>
        </div>
        </div>
        </div>
    </body>
</html>'::character varying WHERE
id = 5;
    UPDATE public.message_template SET
body = '<html>
    <header>
        <meta name="viewport" content="width=device-width, initial-scale=1">
             
    </header>
    <body >
     <div style="padding-top:5px; width:720px; margin:10px auto">
    <div style="padding: 10px 20px 10px ; border:1px solid #ddd;">
        <div id="content-main" style="display: flex;justify-content: center;">
            <div id="center-box" style="position: relative; width:100%;background: #ffffff;">
                <div class="app-logo" style="border-bottom: 3px solid #0BB5FF;text-align: center;padding: 6px;">
                    <img src="{viruj-logo}" class="logo-design" style="width: 117px; height: 89px;" />     
                    <img src="{corner-plus}" class="svg-top-right-design" style="position: absolute;right: 0;width: 76px;height: 91px;top: 0;z-index: 0;" />
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                 <h1 style="font-style: normal;font-weight: bold;font-size: 30px; text-align: center;color: #545454;margin: 0px;">Patient Registration</h1>
                 <h1 style=" font-style: normal;font-weight: 600; font-size: 25px;line-height: 37px;
text-align: left; color: #000000;">Hi, {user_name}</h1>
                    <table class="app-table" style="width: 100%;">
                        <tr class="app-row">
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Phone:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{phone}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Email:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{email}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Password:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;"><span style="color: #0bb5ff; "><em><b> {password}</b></em></span></td>
                        </tr>
                    </table>
                </div>
                <div>
                    <h1 class="app-thank" style="font-style: normal;font-weight: bold;font-size: 24px;text-align: center;color: #545454;">Thank You!</h1>
            
                </div>
            </div>
        </div>
         </div>
        </div>
    </body>
</html>'::character varying WHERE
id = 6;
ALTER TABLE public.patient_details ADD honorific varchar(10) NULL;
ALTER TABLE public.patient_report ADD isActive boolean;





INSERT INTO public.message_type (
id, name, description) VALUES (
'7'::integer, 'FORGOT_PASSWORD'::character varying, 'Forgot Password'::character varying)
 returning id;

  INSERT INTO public.message_template (
body, subject, sender, id) VALUES (
'<html>
    <header>
        <meta name="viewport" content="width=device-width, initial-scale=1">
             
    </header>
    <body >
     <div style="padding-top:5px; width:720px; margin:10px auto">
    <div style="padding: 10px 20px 10px ; border:1px solid #ddd;">
        <div id="content-main" style="display: flex;justify-content: center;">
            <div id="center-box" style="position: relative; width:100%;background: #ffffff;">
                <div class="app-logo" style="border-bottom: 3px solid #0BB5FF;text-align: center;padding: 6px;">
                    <img src="{viruj-logo}" class="logo-design" style="width: 117px; height: 89px;" />     
                    <img src="{corner-plus}" class="svg-top-right-design" style="position: absolute;right: 0;width: 76px;height: 91px;top: 0;z-index: 0;" />
                </div>
                <div class="content-box" style="border-bottom: 1px solid rgba(109, 109, 109, 0.2);">
                 <h1 style="font-style: normal;font-weight: bold;font-size: 30px; text-align: center;color: #545454;margin: 0px;">Forgot Password</h1>
                 <h1 style=" font-style: normal;font-weight: 600; font-size: 25px;line-height: 37px;
text-align: left; color: #000000;">Hi {user_name},</h1>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Your password has been reset successfully. Please find the below updated password.
      </p>
                    <table class="app-table" style="width: 100%;">
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Email:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{email}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Password:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;"><span style="color: #0bb5ff; "><em><b> {password}</b></em></span></td>
                        </tr>
                    </table>
                </div>
                <div>
                    <h1 class="app-thank" style="font-style: normal;font-weight: bold;font-size: 24px;text-align: center;color: #545454;">Thank You!</h1>
            
                </div>
            </div>
        </div>
         </div>
        </div>
    </body>
</html>'::character varying, 'Forgot Password'::character varying, 'notifiaction@virujh.com'::character varying, '7'::integer)
 returning id;


INSERT INTO public.message_metadata (
id, message_type_id, communication_type_id, message_template_id) VALUES (
'7'::integer, '7'::bigint, '1'::bigint, '7'::bigint)
 returning id;

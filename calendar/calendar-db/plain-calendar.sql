--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5
-- Dumped by pg_dump version 13.2

-- Started on 2021-06-21 20:01:44

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

--
-- TOC entry 592 (class 1247 OID 17793)
-- Name: consultations; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.consultations AS ENUM (
    'online',
    'inHospital'
);


ALTER TYPE public.consultations OWNER TO postgres;

--
-- TOC entry 595 (class 1247 OID 17798)
-- Name: live_statuses; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.live_statuses AS ENUM (
    'offline',
    'online',
    'videoSessionReady',
    'inSession'
);


ALTER TYPE public.live_statuses OWNER TO postgres;

--
-- TOC entry 683 (class 1247 OID 17808)
-- Name: overbookingtype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.overbookingtype AS ENUM (
    'Per Hour',
    'Per day'
);


ALTER TYPE public.overbookingtype OWNER TO postgres;

--
-- TOC entry 686 (class 1247 OID 17814)
-- Name: payment_statuses; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_statuses AS ENUM (
    'notPaid',
    'partiallyPaid',
    'fullyPaid',
    'refunded'
);


ALTER TYPE public.payment_statuses OWNER TO postgres;

--
-- TOC entry 689 (class 1247 OID 17824)
-- Name: payments; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payments AS ENUM (
    'onlineCollection',
    'directPayment',
    'notRequired'
);


ALTER TYPE public.payments OWNER TO postgres;

--
-- TOC entry 692 (class 1247 OID 17832)
-- Name: preconsultations; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.preconsultations AS ENUM (
    'on',
    'off'
);


ALTER TYPE public.preconsultations OWNER TO postgres;

--
-- TOC entry 695 (class 1247 OID 17838)
-- Name: statuses; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.statuses AS ENUM (
    'completed',
    'paused',
    'notCompleted'
);


ALTER TYPE public.statuses OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 17845)
-- Name: account_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_details (
    account_key character varying(200) NOT NULL,
    hospital_name character varying(200) NOT NULL,
    street1 character varying(100),
    state character varying,
    pincode character varying(100),
    phone bigint NOT NULL,
    "supportEmail" character varying(100),
    account_details_id integer NOT NULL,
    hospital_photo character varying(500),
    country character varying(100),
    landmark character varying(100),
    city character varying(100),
    "cityState" character varying
);


ALTER TABLE public.account_details OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 17851)
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
-- TOC entry 4208 (class 0 OID 0)
-- Dependencies: 203
-- Name: account_details_account_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_details_account_details_id_seq OWNED BY public.account_details.account_details_id;


--
-- TOC entry 204 (class 1259 OID 17853)
-- Name: advertisement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.advertisement (
    id integer NOT NULL,
    name character varying(100),
    content character varying(5000),
    code character varying(1000),
    "createdTime" timestamp without time zone,
    is_active boolean,
    url character varying(1000)
);


ALTER TABLE public.advertisement OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 17859)
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
    consultationmode public.consultations DEFAULT 'online'::public.consultations,
    status public.statuses DEFAULT 'notCompleted'::public.statuses,
    "createdTime" timestamp without time zone,
    "hasConsultation" boolean DEFAULT false NOT NULL,
    reportid character varying(100)
);


ALTER TABLE public.appointment OWNER TO postgres;

--
-- TOC entry 4209 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN appointment."hasConsultation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.appointment."hasConsultation" IS 'true means consultation started';


--
-- TOC entry 206 (class 1259 OID 17870)
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
-- TOC entry 207 (class 1259 OID 17873)
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
-- TOC entry 4210 (class 0 OID 0)
-- Dependencies: 207
-- Name: appointment_cancel_reschedule_appointment_cancel_reschedule_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq OWNED BY public.appointment_cancel_reschedule.appointment_cancel_reschedule_id;


--
-- TOC entry 208 (class 1259 OID 17875)
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
-- TOC entry 209 (class 1259 OID 17881)
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
-- TOC entry 4211 (class 0 OID 0)
-- Dependencies: 209
-- Name: appointment_doc_config_appointment_doc_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq OWNED BY public.appointment_doc_config.appointment_doc_config_id;


--
-- TOC entry 210 (class 1259 OID 17883)
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
-- TOC entry 4212 (class 0 OID 0)
-- Dependencies: 210
-- Name: appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_id_seq OWNED BY public.appointment.id;


--
-- TOC entry 211 (class 1259 OID 17885)
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
-- TOC entry 212 (class 1259 OID 17887)
-- Name: communication_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.communication_type (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.communication_type OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 17890)
-- Name: communication_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.communication_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.communication_type_id_seq OWNER TO postgres;

--
-- TOC entry 4213 (class 0 OID 0)
-- Dependencies: 213
-- Name: communication_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.communication_type_id_seq OWNED BY public.communication_type.id;


--
-- TOC entry 214 (class 1259 OID 17892)
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
-- TOC entry 215 (class 1259 OID 17914)
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
-- TOC entry 216 (class 1259 OID 17920)
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
-- TOC entry 4214 (class 0 OID 0)
-- Dependencies: 216
-- Name: doc_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;


--
-- TOC entry 217 (class 1259 OID 17922)
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
-- TOC entry 218 (class 1259 OID 17928)
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
-- TOC entry 4215 (class 0 OID 0)
-- Dependencies: 218
-- Name: doc_config_schedule_day_doc_config_schedule_day_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq OWNED BY public.doc_config_schedule_day.id;


--
-- TOC entry 219 (class 1259 OID 17930)
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
-- TOC entry 220 (class 1259 OID 17936)
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
-- TOC entry 4216 (class 0 OID 0)
-- Dependencies: 220
-- Name: doc_config_schedule_interval_doc_config_schedule_interval_i_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq OWNED BY public.doc_config_schedule_interval.id;


--
-- TOC entry 221 (class 1259 OID 17938)
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
-- TOC entry 4217 (class 0 OID 0)
-- Dependencies: 221
-- Name: docconfigid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.docconfigid_seq OWNED BY public.doc_config.id;


--
-- TOC entry 222 (class 1259 OID 17940)
-- Name: doctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor (
    "doctorId" integer NOT NULL,
    doctor_name character varying(100) NOT NULL,
    account_key character varying(200) NOT NULL,
    doctor_key character varying(200) NOT NULL,
    experience bigint,
    speciality character varying(200),
    qualification character varying(500),
    photo character varying(500),
    number bigint,
    signature character varying(500),
    first_name character varying(100),
    last_name character varying(100),
    registration_number character varying(200),
    email character varying(200),
    live_status public.live_statuses DEFAULT 'offline'::public.live_statuses,
    last_active timestamp without time zone,
    registration_id_proof character varying(500)
);


ALTER TABLE public.doctor OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17947)
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
-- TOC entry 4218 (class 0 OID 0)
-- Dependencies: 223
-- Name: doctor_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;


--
-- TOC entry 224 (class 1259 OID 17949)
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
-- TOC entry 225 (class 1259 OID 17955)
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
-- TOC entry 4219 (class 0 OID 0)
-- Dependencies: 225
-- Name: doctor_config_pre_consultation_doctor_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;


--
-- TOC entry 226 (class 1259 OID 17957)
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
-- TOC entry 4220 (class 0 OID 0)
-- Dependencies: 226
-- Name: doctor_config_preconsultation_doctor_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;


--
-- TOC entry 227 (class 1259 OID 17959)
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
-- TOC entry 4221 (class 0 OID 0)
-- Dependencies: 227
-- Name: doctor_details_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_details_doctor_id_seq OWNED BY public.doctor."doctorId";


--
-- TOC entry 228 (class 1259 OID 17961)
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
-- TOC entry 4222 (class 0 OID 0)
-- Dependencies: 228
-- Name: doctor_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_doctor_id_seq OWNED BY public.doctor."doctorId";


--
-- TOC entry 229 (class 1259 OID 17963)
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
-- TOC entry 230 (class 1259 OID 17966)
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
-- TOC entry 4223 (class 0 OID 0)
-- Dependencies: 230
-- Name: interval_days_interval_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.interval_days_interval_days_id_seq OWNED BY public.interval_days.interval_days_id;


--
-- TOC entry 231 (class 1259 OID 17968)
-- Name: medicine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicine (
    id integer NOT NULL,
    prescription_id bigint NOT NULL,
    name_of_medicine character varying,
    frequency_of_each_dose character varying,
    count_of_medicine_for_each_dose bigint,
    type_of_medicine character varying,
    dose_of_medicine character varying,
    count_of_days character varying
);


ALTER TABLE public.medicine OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17974)
-- Name: medicine_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medicine_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicine_id_seq OWNER TO postgres;

--
-- TOC entry 4224 (class 0 OID 0)
-- Dependencies: 232
-- Name: medicine_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medicine_id_seq OWNED BY public.medicine.id;


--
-- TOC entry 233 (class 1259 OID 17976)
-- Name: message_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_metadata (
    id integer NOT NULL,
    message_type_id bigint,
    communication_type_id bigint,
    message_template_id bigint
);


ALTER TABLE public.message_metadata OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17979)
-- Name: message_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_metadata_id_seq OWNER TO postgres;

--
-- TOC entry 4225 (class 0 OID 0)
-- Dependencies: 234
-- Name: message_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_metadata_id_seq OWNED BY public.message_metadata.id;


--
-- TOC entry 235 (class 1259 OID 17981)
-- Name: message_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_template (
    id integer NOT NULL,
    sender character varying(200),
    subject character varying(200),
    body character varying(500000)
);


ALTER TABLE public.message_template OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 17987)
-- Name: message_template_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_template_id_seq OWNER TO postgres;

--
-- TOC entry 4226 (class 0 OID 0)
-- Dependencies: 236
-- Name: message_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_template_id_seq OWNED BY public.message_template.id;


--
-- TOC entry 237 (class 1259 OID 17989)
-- Name: message_template_placeholders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_template_placeholders (
    id integer NOT NULL,
    message_template_id bigint,
    placeholder_name character varying(200),
    message_type_id bigint
);


ALTER TABLE public.message_template_placeholders OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17992)
-- Name: message_template_placeholders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_template_placeholders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_template_placeholders_id_seq OWNER TO postgres;

--
-- TOC entry 4227 (class 0 OID 0)
-- Dependencies: 238
-- Name: message_template_placeholders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_template_placeholders_id_seq OWNED BY public.message_template_placeholders.id;


--
-- TOC entry 239 (class 1259 OID 17994)
-- Name: message_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_type (
    id integer NOT NULL,
    name character varying(200),
    description character varying
);


ALTER TABLE public.message_type OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 18000)
-- Name: message_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_type_id_seq OWNER TO postgres;

--
-- TOC entry 4228 (class 0 OID 0)
-- Dependencies: 240
-- Name: message_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_type_id_seq OWNED BY public.message_type.id;


--
-- TOC entry 258 (class 1259 OID 16963)
-- Name: mobile_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mobile_version (
    id integer NOT NULL,
    android_version integer NOT NULL,
    ios_version integer NOT NULL
);


ALTER TABLE public.mobile_version OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 16961)
-- Name: mobile_version_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mobile_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mobile_version_id_seq OWNER TO postgres;

--
-- TOC entry 3410 (class 0 OID 0)
-- Dependencies: 257
-- Name: mobile_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mobile_version_id_seq OWNED BY public.mobile_version.id;

--
-- TOC entry 241 (class 1259 OID 18002)
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
-- TOC entry 242 (class 1259 OID 18005)
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
-- TOC entry 4229 (class 0 OID 0)
-- Dependencies: 242
-- Name: openvidu_session_openvidu_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.openvidu_session_openvidu_session_id_seq OWNED BY public.openvidu_session.openvidu_session_id;


--
-- TOC entry 243 (class 1259 OID 18007)
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
-- TOC entry 244 (class 1259 OID 18013)
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
-- TOC entry 4230 (class 0 OID 0)
-- Dependencies: 244
-- Name: openvidu_session_token_openvidu_session_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq OWNED BY public.openvidu_session_token.openvidu_session_token_id;


--
-- TOC entry 245 (class 1259 OID 18015)
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
    photo character varying(600),
    phone character varying(100),
    patient_id bigint,
    "firstName" character varying(100),
    "lastName" character varying(100),
    "dateOfBirth" character varying(100),
    "alternateContact" character varying(100),
    age bigint,
    live_status public.live_statuses DEFAULT 'online'::public.live_statuses,
    last_active timestamp without time zone,
    city character varying(100),
    honorific character varying(10),
    gender character varying(100)
);


ALTER TABLE public.patient_details OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 18022)
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
-- TOC entry 4231 (class 0 OID 0)
-- Dependencies: 246
-- Name: patient_details_patient_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_details_patient_details_id_seq OWNED BY public.patient_details.id;


--
-- TOC entry 247 (class 1259 OID 18024)
-- Name: patient_report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_report (
    id integer NOT NULL,
    patient_id bigint NOT NULL,
    appointment_id bigint,
    file_name character varying NOT NULL,
    file_type character varying NOT NULL,
    report_url character varying NOT NULL,
    comments character varying,
    report_date date,
    active boolean DEFAULT true
);


ALTER TABLE public.patient_report OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 18031)
-- Name: patient_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patient_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patient_report_id_seq OWNER TO postgres;

--
-- TOC entry 4232 (class 0 OID 0)
-- Dependencies: 248
-- Name: patient_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_report_id_seq OWNED BY public.patient_report.id;


--
-- TOC entry 249 (class 1259 OID 18033)
-- Name: payment_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_details (
    id integer NOT NULL,
    appointment_id bigint,
    order_id character varying(200),
    receipt_id character varying(200),
    amount character varying(100),
    payment_status public.payment_statuses DEFAULT 'notPaid'::public.payment_statuses
);


ALTER TABLE public.payment_details OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 18040)
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
-- TOC entry 4233 (class 0 OID 0)
-- Dependencies: 250
-- Name: payment_details_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_details_payment_id_seq OWNED BY public.payment_details.id;


--
-- TOC entry 251 (class 1259 OID 18042)
-- Name: prescription; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prescription (
    id integer NOT NULL,
    appointment_id bigint NOT NULL,
    appointment_date date,
    hospital_logo character varying(500),
    hospital_name character varying(100),
    doctor_name character varying(200),
    doctor_signature character varying(500),
    patient_name character varying(200),
    prescription_url character varying,
    remarks character varying(500),
    "hospitalAddress" character varying(200),
    diagnosis character varying(500)
);


ALTER TABLE public.prescription OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 18048)
-- Name: prescription_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prescription_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prescription_id_seq OWNER TO postgres;

--
-- TOC entry 4234 (class 0 OID 0)
-- Dependencies: 252
-- Name: prescription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prescription_id_seq OWNED BY public.prescription.id;


--
-- TOC entry 253 (class 1259 OID 18050)
-- Name: tabesample; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tabesample (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    place character varying(100)
);


ALTER TABLE public.tabesample OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 18053)
-- Name: tabesample_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tabesample_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tabesample_id_seq OWNER TO postgres;

--
-- TOC entry 4235 (class 0 OID 0)
-- Dependencies: 254
-- Name: tabesample_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tabesample_id_seq OWNED BY public.tabesample.id;


--
-- TOC entry 255 (class 1259 OID 18055)
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
-- TOC entry 256 (class 1259 OID 18058)
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
-- TOC entry 4236 (class 0 OID 0)
-- Dependencies: 256
-- Name: work_schedule_day_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.work_schedule_day_id_seq OWNED BY public.work_schedule_day.id;


--
-- TOC entry 257 (class 1259 OID 18060)
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
-- TOC entry 258 (class 1259 OID 18063)
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
-- TOC entry 4237 (class 0 OID 0)
-- Dependencies: 258
-- Name: work_schedule_interval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.work_schedule_interval_id_seq OWNED BY public.work_schedule_interval.id;


--
-- TOC entry 3884 (class 2604 OID 18065)
-- Name: account_details account_details_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details ALTER COLUMN account_details_id SET DEFAULT nextval('public.account_details_account_details_id_seq'::regclass);


--
-- TOC entry 3890 (class 2604 OID 18066)
-- Name: appointment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment ALTER COLUMN id SET DEFAULT nextval('public.appointment_id_seq'::regclass);


--
-- TOC entry 3891 (class 2604 OID 18067)
-- Name: appointment_cancel_reschedule appointment_cancel_reschedule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule ALTER COLUMN appointment_cancel_reschedule_id SET DEFAULT nextval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq'::regclass);


--
-- TOC entry 3892 (class 2604 OID 18068)
-- Name: appointment_doc_config appointment_doc_config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config ALTER COLUMN appointment_doc_config_id SET DEFAULT nextval('public.appointment_doc_config_appointment_doc_config_id_seq'::regclass);


--
-- TOC entry 3893 (class 2604 OID 18069)
-- Name: communication_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.communication_type ALTER COLUMN id SET DEFAULT nextval('public.communication_type_id_seq'::regclass);


--
-- TOC entry 3910 (class 2604 OID 18070)
-- Name: doc_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config ALTER COLUMN id SET DEFAULT nextval('public.docconfigid_seq'::regclass);


--
-- TOC entry 3912 (class 2604 OID 18071)
-- Name: doc_config_schedule_day id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq'::regclass);


--
-- TOC entry 3913 (class 2604 OID 18072)
-- Name: doc_config_schedule_interval id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq'::regclass);


--
-- TOC entry 3915 (class 2604 OID 18073)
-- Name: doctor doctorId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor ALTER COLUMN "doctorId" SET DEFAULT nextval('public.doctor_details_doctor_id_seq'::regclass);


--
-- TOC entry 3911 (class 2604 OID 18074)
-- Name: doctor_config_can_resch doc_config_can_resch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_can_resch ALTER COLUMN doc_config_can_resch_id SET DEFAULT nextval('public.doc_config_can_resch_doc_config_can_resch_id_seq'::regclass);


--
-- TOC entry 3916 (class 2604 OID 18075)
-- Name: doctor_config_pre_consultation doctor_config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_pre_consultation ALTER COLUMN doctor_config_id SET DEFAULT nextval('public.doctor_config_preconsultation_doctor_config_id_seq'::regclass);


--
-- TOC entry 3917 (class 2604 OID 18076)
-- Name: interval_days interval_days_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interval_days ALTER COLUMN interval_days_id SET DEFAULT nextval('public.interval_days_interval_days_id_seq'::regclass);


--
-- TOC entry 3918 (class 2604 OID 18077)
-- Name: medicine id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine ALTER COLUMN id SET DEFAULT nextval('public.medicine_id_seq'::regclass);


--
-- TOC entry 3919 (class 2604 OID 18078)
-- Name: message_metadata id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_metadata ALTER COLUMN id SET DEFAULT nextval('public.message_metadata_id_seq'::regclass);


--
-- TOC entry 3920 (class 2604 OID 18079)
-- Name: message_template id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template ALTER COLUMN id SET DEFAULT nextval('public.message_template_id_seq'::regclass);


--
-- TOC entry 3921 (class 2604 OID 18080)
-- Name: message_template_placeholders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template_placeholders ALTER COLUMN id SET DEFAULT nextval('public.message_template_placeholders_id_seq'::regclass);


--
-- TOC entry 3922 (class 2604 OID 18081)
-- Name: message_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_type ALTER COLUMN id SET DEFAULT nextval('public.message_type_id_seq'::regclass);

--
-- TOC entry 3108 (class 2604 OID 16966)
-- Name: mobile_version id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mobile_version ALTER COLUMN id SET DEFAULT nextval('public.mobile_version_id_seq'::regclass);

--
-- TOC entry 3923 (class 2604 OID 18082)
-- Name: openvidu_session openvidu_session_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session ALTER COLUMN openvidu_session_id SET DEFAULT nextval('public.openvidu_session_openvidu_session_id_seq'::regclass);


--
-- TOC entry 3924 (class 2604 OID 18083)
-- Name: openvidu_session_token openvidu_session_token_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session_token ALTER COLUMN openvidu_session_token_id SET DEFAULT nextval('public.openvidu_session_token_openvidu_session_token_id_seq'::regclass);


--
-- TOC entry 3926 (class 2604 OID 18084)
-- Name: patient_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_details ALTER COLUMN id SET DEFAULT nextval('public.patient_details_patient_details_id_seq'::regclass);


--
-- TOC entry 3928 (class 2604 OID 18085)
-- Name: patient_report id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_report ALTER COLUMN id SET DEFAULT nextval('public.patient_report_id_seq'::regclass);


--
-- TOC entry 3930 (class 2604 OID 18086)
-- Name: payment_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details ALTER COLUMN id SET DEFAULT nextval('public.payment_details_payment_id_seq'::regclass);


--
-- TOC entry 3931 (class 2604 OID 18087)
-- Name: prescription id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescription ALTER COLUMN id SET DEFAULT nextval('public.prescription_id_seq'::regclass);


--
-- TOC entry 3932 (class 2604 OID 18088)
-- Name: tabesample id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabesample ALTER COLUMN id SET DEFAULT nextval('public.tabesample_id_seq'::regclass);


--
-- TOC entry 3933 (class 2604 OID 18089)
-- Name: work_schedule_day id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_day_id_seq'::regclass);


--
-- TOC entry 3934 (class 2604 OID 18090)
-- Name: work_schedule_interval id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_interval_id_seq'::regclass);


--
-- TOC entry 4145 (class 0 OID 17845)
-- Dependencies: 202
-- Data for Name: account_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.account_details VALUES ('Acc_1', 'Lamfer healthcare', NULL, NULL, NULL, 9940027564, NULL, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_3', 'kalyani hospitals', NULL, NULL, '600000', 6360254465, NULL, 3, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_4', 'manikandhan ', NULL, NULL, '600000', 1233211231, NULL, 4, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_5', 'Helth care Hospitals', NULL, NULL, '600000', 6360254465, NULL, 5, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_8', 'JKL', NULL, NULL, '600000', 9876543212, NULL, 6, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_9', 'apollo', NULL, NULL, '600000', 1231231231, NULL, 7, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_10', 'apollo', NULL, NULL, '600000', 1111111111, NULL, 8, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_11', 'Teja hospitals', NULL, NULL, '600000', 6360254465, NULL, 9, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_12', 'dsadsadsa', NULL, NULL, '600000', 1111111111, NULL, 10, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_13', 'apollo', NULL, NULL, '600000', 1111111111, NULL, 11, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_14', 'dsadsadsa', NULL, NULL, '600000', 1111111111, NULL, 12, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_15', 'apollo', NULL, NULL, '600000', 1111111111, NULL, 13, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_17', 'Deactivated Clinic', NULL, NULL, '600000', 7894567235, NULL, 15, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_16', 'apollo', NULL, NULL, '600000', 1111111111, NULL, 14, 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_2', 'kalyani hospitals', NULL, NULL, '600000', 6360254465, NULL, 2, 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_18', 'apollo', NULL, NULL, '600000', 1111111111, NULL, 16, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_22', 'Invalid_Hospital2', NULL, NULL, '600000', 5678234598, NULL, 17, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_23', 'Invalid_Hospital2', NULL, NULL, '600000', 5678234598, NULL, 18, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_24', 'Appollo1', NULL, NULL, '600000', 8924678902, NULL, 19, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_26', 'apollo', NULL, NULL, '600000', 1111111111, NULL, 21, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_30', 'apollo', NULL, NULL, '600000', 1111111111, NULL, 22, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_31', 'laxmi hospitals', NULL, NULL, '600000', 4578457845, NULL, 23, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_32', 'hosp1', NULL, NULL, '600000', 1111111111, NULL, 24, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_33', 'Deactivated Clinic', NULL, NULL, '600000', 6789023456, NULL, 25, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_34', 'arul hospitals', NULL, NULL, '600000', 1571571576, NULL, 26, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_38', 'apollo', NULL, NULL, '600000', 1111111111, NULL, 27, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_39', 'apollo', NULL, NULL, '600000', 3252354353, NULL, 28, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_42', 'Kumar Hospital', NULL, NULL, '600000', 6789023123, NULL, 29, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_43', 'arul hospital', NULL, NULL, '600000', 1431431434, 'sreedhar@softsuave.com', 30, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_44', 'apollo', NULL, NULL, '600000', 3214321432, NULL, 31, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_25', 'Apollo', '1st street', NULL, '600125', 9940411049, NULL, 20, NULL, NULL, NULL, NULL, 'tamilnadu');
INSERT INTO public.account_details VALUES ('Acc_45', 'Laxmi', NULL, NULL, '600000', 6360254466, NULL, 32, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_46', 'Krishna', NULL, NULL, '600000', 6360254465, NULL, 33, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_49', 'munna clicnic', NULL, NULL, '600000', 6360254469, NULL, 34, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_50', 'Kauvery Hospital', NULL, NULL, '600000', 7845127845, NULL, 35, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_54', 'Siva clinic', NULL, NULL, '600000', 8568568563, NULL, 36, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_57', 'Cardiologist', NULL, NULL, '600000', 6360254465, NULL, 37, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.account_details VALUES ('Acc_58', 'Kumar', NULL, NULL, '600000', 1251251253, NULL, 38, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4147 (class 0 OID 17853)
-- Dependencies: 204
-- Data for Name: advertisement; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.advertisement VALUES (1, 'Medicine', 'Save 50% offer for acetaminophen medicine up to 24 hours', 'NB8ws6', NULL, NULL, NULL);
INSERT INTO public.advertisement VALUES (2, 'Medicare', 'Cashback 50% amount for first order', 'IGT675h', NULL, NULL, NULL);
INSERT INTO public.advertisement VALUES (3, '', '', '', '2021-02-12 11:22:23.6', true, 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/error.PNG');


--
-- TOC entry 4148 (class 0 OID 17859)
-- Dependencies: 205
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.appointment VALUES (1, 1, 1, '2021-06-13', '09:00:00', '09:15:00', NULL, true, false, 'DOCTOR', 2, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-09 15:36:46.932', false, NULL);
INSERT INTO public.appointment VALUES (2, 1, 2, '2021-06-13', '11:30:00', '11:45:00', NULL, true, false, 'PATIENT', 2, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-09 15:54:57.728', false, '2,1,3,4,5');
INSERT INTO public.appointment VALUES (3, 1, 3, '2021-06-09', '21:45:00', '22:00:00', NULL, true, false, 'DOCTOR', 2, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-09 15:57:40.676', false, NULL);
INSERT INTO public.appointment VALUES (4, 1, 2, '2021-06-09', '22:15:00', '22:30:00', NULL, true, false, 'PATIENT', 2, NULL, NULL, 15, 'directPayment', 'online', 'completed', '2021-06-09 15:59:49.95', false, NULL);
INSERT INTO public.appointment VALUES (5, 2, 4, '2021-06-11', '02:00:00', '02:15:00', NULL, false, true, 'PATIENT', 4, 'DOCTOR', 7, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 18:58:34.897', false, NULL);
INSERT INTO public.appointment VALUES (11, 1, 1, '2021-06-14', '09:15:00', '09:30:00', NULL, true, false, 'DOCTOR', 2, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 19:49:39.841', false, NULL);
INSERT INTO public.appointment VALUES (12, 1, 1, '2021-06-14', '09:30:00', '09:45:00', NULL, true, false, 'DOCTOR', 2, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 19:58:09.432', false, NULL);
INSERT INTO public.appointment VALUES (13, 1, 1, '2021-06-15', '10:30:00', '10:45:00', NULL, true, false, 'DOCTOR', 2, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 19:59:04.122', false, NULL);
INSERT INTO public.appointment VALUES (8, 2, 5, '2021-06-12', '00:15:00', '00:30:00', NULL, false, true, 'DOCTOR', 7, 'DOCTOR', 7, 15, 'notRequired', 'inHospital', 'notCompleted', '2021-06-10 19:19:10.756', false, NULL);
INSERT INTO public.appointment VALUES (9, 2, 4, '2021-06-11', '03:45:00', '04:00:00', NULL, false, true, 'PATIENT', 4, 'DOCTOR', 7, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 19:29:01.551', false, NULL);
INSERT INTO public.appointment VALUES (15, 2, 4, '2021-06-11', '04:30:00', '04:45:00', NULL, false, true, 'PATIENT', 4, 'DOCTOR', 7, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 20:03:32.492', false, NULL);
INSERT INTO public.appointment VALUES (7, 2, 4, '2021-06-12', '07:15:00', '07:30:00', NULL, false, true, 'PATIENT', 4, 'DOCTOR', 7, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 19:05:07.103', false, NULL);
INSERT INTO public.appointment VALUES (6, 2, 4, '2021-06-11', '08:30:00', '08:45:00', NULL, false, true, 'PATIENT', 4, 'DOCTOR', 7, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 19:00:28.405', false, NULL);
INSERT INTO public.appointment VALUES (10, 2, 4, '2021-06-11', '10:45:00', '11:00:00', NULL, false, true, 'PATIENT', 4, 'DOCTOR', 7, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 19:42:24.984', false, NULL);
INSERT INTO public.appointment VALUES (14, 2, 4, '2021-06-11', '14:15:00', '14:30:00', NULL, false, true, 'PATIENT', 4, 'DOCTOR', 7, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 19:59:52.439', false, NULL);
INSERT INTO public.appointment VALUES (16, 1, 3, '2021-06-14', '10:00:00', '10:15:00', NULL, true, false, 'DOCTOR', 2, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 20:08:41.047', false, NULL);
INSERT INTO public.appointment VALUES (17, 2, 4, '2021-06-11', '14:45:00', '15:00:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-10 20:13:23.477', false, NULL);
INSERT INTO public.appointment VALUES (18, 2, 4, '2021-06-14', '05:00:00', '05:15:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-11 14:59:42.478', false, NULL);
INSERT INTO public.appointment VALUES (19, 5, 4, '2021-06-11', '21:45:00', '22:00:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-11 15:55:17.533', false, NULL);
INSERT INTO public.appointment VALUES (20, 5, 6, '2021-06-11', '22:00:00', '22:15:00', NULL, true, false, 'ADMIN', 14, NULL, NULL, NULL, 'notRequired', 'inHospital', 'notCompleted', '2021-06-11 15:56:31.514', false, NULL);
INSERT INTO public.appointment VALUES (21, 12, 4, '2021-06-11', '22:30:00', '22:45:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'onlineCollection', 'online', 'paused', '2021-06-11 16:47:01.541', false, NULL);
INSERT INTO public.appointment VALUES (22, 5, 4, '2021-06-14', '23:45:00', '00:00:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 07:53:15.754', false, NULL);
INSERT INTO public.appointment VALUES (23, 5, 4, '2021-06-14', '23:30:00', '23:45:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 07:56:20.592', false, NULL);
INSERT INTO public.appointment VALUES (24, 5, 4, '2021-06-14', '23:15:00', '23:30:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 07:57:39.609', false, NULL);
INSERT INTO public.appointment VALUES (25, 5, 4, '2021-06-16', '23:45:00', '00:00:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 07:58:04.783', false, NULL);
INSERT INTO public.appointment VALUES (26, 5, 4, '2021-06-15', '22:30:00', '22:45:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 07:58:26.357', false, NULL);
INSERT INTO public.appointment VALUES (28, 2, 4, '2021-12-13', '08:00:00', '08:15:00', NULL, false, true, 'PATIENT', 4, 'PATIENT', NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 08:07:59.992', false, NULL);
INSERT INTO public.appointment VALUES (29, 2, 4, '2021-06-14', '20:45:00', '21:00:00', NULL, true, false, 'PATIENT', NULL, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 08:40:55.331', false, NULL);
INSERT INTO public.appointment VALUES (30, 2, 4, '2021-06-14', '14:30:00', '14:45:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 08:49:43.335', false, NULL);
INSERT INTO public.appointment VALUES (31, 2, 4, '2021-06-15', '03:00:00', '03:15:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 14:48:52.989', false, NULL);
INSERT INTO public.appointment VALUES (27, 12, 4, '2021-06-18', '22:15:00', '22:30:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 08:05:49.377', false, '7');
INSERT INTO public.appointment VALUES (32, 5, 4, '2021-06-14', '21:15:00', '21:30:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 15:06:35.578', false, NULL);
INSERT INTO public.appointment VALUES (33, 2, 4, '2021-06-14', '21:00:00', '21:15:00', NULL, true, false, 'DOCTOR', 7, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-14 15:11:27.102', false, NULL);
INSERT INTO public.appointment VALUES (34, 2, 7, '2021-06-15', '02:15:00', '02:30:00', NULL, true, false, 'ADMIN', 12, NULL, NULL, NULL, 'notRequired', 'inHospital', 'notCompleted', '2021-06-15 01:40:39.052', false, NULL);
INSERT INTO public.appointment VALUES (35, 19, 10, '2021-06-20', '00:23:00', '00:38:00', NULL, false, true, 'PATIENT', 10, 'ADMIN/DOCTOR', 28, 15, 'directPayment', 'online', 'notCompleted', '2021-06-16 00:09:35.12', false, NULL);
INSERT INTO public.appointment VALUES (36, 19, 10, '2021-06-20', '00:23:00', '00:38:00', NULL, false, true, 'PATIENT', 10, 'ADMIN/DOCTOR', 28, 15, 'directPayment', 'online', 'notCompleted', '2021-06-16 00:12:46.713', false, NULL);
INSERT INTO public.appointment VALUES (37, 19, 11, '2021-06-20', '01:38:00', '01:53:00', NULL, true, false, 'PATIENT', 11, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-16 00:39:21.775', false, NULL);
INSERT INTO public.appointment VALUES (44, 24, 25, '2021-06-18', '13:13:00', '13:28:00', NULL, true, false, 'PATIENT', 25, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-18 12:56:27.144', false, NULL);
INSERT INTO public.appointment VALUES (38, 1, 1, '2021-06-16', '21:30:00', '21:45:00', NULL, false, true, 'PATIENT', 1, 'DOCTOR', 2, 15, 'directPayment', 'online', 'completed', '2021-06-16 00:58:24.652', false, NULL);
INSERT INTO public.appointment VALUES (45, 34, 25, '2021-06-18', '15:30:00', '15:45:00', NULL, true, false, 'PATIENT', 25, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-18 13:46:46.096', false, NULL);
INSERT INTO public.appointment VALUES (39, 1, 1, '2021-06-16', '21:30:00', '21:45:00', NULL, false, true, 'PATIENT', 1, 'DOCTOR', 2, 15, 'directPayment', 'online', 'completed', '2021-06-16 01:14:02.347', false, NULL);
INSERT INTO public.appointment VALUES (40, 1, 1, '2021-06-16', '21:45:00', '22:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-16 01:29:56.553', false, NULL);
INSERT INTO public.appointment VALUES (41, 1, 8, '2021-06-20', '09:00:00', '09:15:00', NULL, true, false, 'PATIENT', 8, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-17 12:00:05.469', false, NULL);
INSERT INTO public.appointment VALUES (42, 26, 8, '2021-06-21', '09:30:00', '10:00:00', NULL, false, true, 'PATIENT', 8, 'PATIENT', NULL, 30, 'directPayment', 'online', 'notCompleted', '2021-06-17 13:12:00.09', false, '8');
INSERT INTO public.appointment VALUES (43, 26, 8, '2021-06-17', '19:00:00', '19:30:00', NULL, true, false, 'PATIENT', NULL, NULL, NULL, 30, 'directPayment', 'online', 'notCompleted', '2021-06-17 13:24:16.102', false, '8');
INSERT INTO public.appointment VALUES (47, 26, 33, '2021-06-20', '10:15:00', '10:30:00', NULL, false, true, '{"ADMIN","DOCTOR"}', 35, '{"ADMIN","DOCTOR"}', 35, 15, 'notRequired', 'online', 'notCompleted', '2021-06-18 10:46:33.973', false, NULL);
INSERT INTO public.appointment VALUES (48, 26, 8, '2021-06-18', '18:00:00', '18:15:00', NULL, true, false, '{"ADMIN","DOCTOR"}', 35, NULL, NULL, 15, 'notRequired', 'online', 'notCompleted', '2021-06-18 10:47:46.015', false, NULL);
INSERT INTO public.appointment VALUES (49, 26, 8, '2021-06-21', '16:00:00', '16:15:00', NULL, true, false, 'PATIENT', 8, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-18 12:29:00.922', false, NULL);
INSERT INTO public.appointment VALUES (46, 26, 8, '2021-06-20', '10:00:00', '10:15:00', NULL, false, true, '{"ADMIN","DOCTOR"}', 35, 'PATIENT', NULL, 15, 'directPayment', 'inHospital', 'notCompleted', '2021-06-18 10:46:02.128', false, NULL);
INSERT INTO public.appointment VALUES (50, 26, 8, '2022-06-19', '10:00:00', '10:15:00', NULL, true, false, 'PATIENT', 8, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-18 12:33:38.254', false, NULL);
INSERT INTO public.appointment VALUES (51, 5, 34, '2021-06-19', '21:00:00', '21:15:00', NULL, false, true, '{"ADMIN","DOCTOR"}', 14, '{"ADMIN","DOCTOR"}', 14, 15, 'notRequired', 'online', 'notCompleted', '2021-06-19 10:30:40.034', false, NULL);
INSERT INTO public.appointment VALUES (52, 5, 34, '2021-06-19', '22:15:00', '22:30:00', NULL, true, false, '{"ADMIN","DOCTOR"}', 14, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-19 10:32:27.905', false, NULL);
INSERT INTO public.appointment VALUES (83, 2, 4, '2021-06-21', '18:30:00', '18:45:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'paused', '2021-06-21 11:48:34.424', false, '181,180,179,178,177');
INSERT INTO public.appointment VALUES (68, 34, 25, '2021-06-20', '10:44:00', '10:59:00', NULL, true, false, '{"ADMIN","DOCTOR"}', 43, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-19 15:32:23.183', false, NULL);
INSERT INTO public.appointment VALUES (53, 2, 4, '2021-06-19', '16:15:00', '16:30:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'completed', '2021-06-19 10:44:48.067', false, '19,18,17,16');
INSERT INTO public.appointment VALUES (70, 2, 35, '2021-06-19', '22:00:00', '22:15:00', NULL, true, false, 'PATIENT', 35, NULL, NULL, 15, 'onlineCollection', 'online', 'completed', '2021-06-19 15:36:19.625', false, NULL);
INSERT INTO public.appointment VALUES (57, 2, 35, '2021-06-19', '18:30:00', '18:45:00', NULL, true, false, 'PATIENT', 35, NULL, NULL, 15, 'onlineCollection', 'online', 'paused', '2021-06-19 12:41:05.2', false, NULL);
INSERT INTO public.appointment VALUES (79, 2, 4, '2021-06-21', '17:15:00', '17:30:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'onlineCollection', 'online', 'paused', '2021-06-21 11:32:24.478', false, '');
INSERT INTO public.appointment VALUES (80, 2, 45, '2021-06-21', '17:30:00', '17:45:00', NULL, true, false, 'DOCTOR', 7, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-21 11:39:57.912', false, NULL);
INSERT INTO public.appointment VALUES (81, 2, 46, '2021-06-21', '17:45:00', '18:00:00', NULL, true, false, 'DOCTOR', 7, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-21 11:46:16.031', false, NULL);
INSERT INTO public.appointment VALUES (55, 2, 4, '2021-06-19', '17:15:00', '17:30:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'paused', '2021-06-19 10:46:22.735', false, '');
INSERT INTO public.appointment VALUES (56, 2, 4, '2021-06-19', '20:30:00', '20:45:00', NULL, false, true, 'PATIENT', 4, '{"DOCTOR"}', 7, 15, 'directPayment', 'online', 'notCompleted', '2021-06-19 12:16:35.957', false, NULL);
INSERT INTO public.appointment VALUES (59, 47, 35, '2030-04-20', '19:02:00', '19:17:00', NULL, true, false, 'PATIENT', 35, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-19 13:18:53.466', false, NULL);
INSERT INTO public.appointment VALUES (60, 47, 35, '2021-06-19', '21:02:00', '21:17:00', NULL, true, false, 'PATIENT', 35, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-19 13:22:46.256', false, '23,24,25');
INSERT INTO public.appointment VALUES (67, 2, 4, '2021-06-19', '21:45:00', '22:00:00', NULL, true, false, '{"DOCTOR"}', 7, NULL, NULL, 15, 'directPayment', 'online', 'paused', '2021-06-19 15:29:34.391', false, '31,32,33,34');
INSERT INTO public.appointment VALUES (54, 2, 4, '2021-06-19', '16:30:00', '16:45:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'paused', '2021-06-19 10:45:08.106', false, '34,33,32,31');
INSERT INTO public.appointment VALUES (71, 2, 4, '2021-06-19', '22:15:00', '22:30:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-19 16:36:53.565', false, NULL);
INSERT INTO public.appointment VALUES (69, 34, 25, '2021-06-19', '21:17:00', '21:32:00', NULL, true, false, '{"ADMIN","DOCTOR"}', 43, NULL, NULL, 15, 'directPayment', 'online', 'completed', '2021-06-19 15:33:18.746', false, NULL);
INSERT INTO public.appointment VALUES (72, 2, 4, '2021-06-20', '21:05:00', '21:20:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'onlineCollection', 'online', 'notCompleted', '2021-06-20 05:32:24.074', false, NULL);
INSERT INTO public.appointment VALUES (58, 2, 4, '2021-06-19', '19:00:00', '19:15:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'paused', '2021-06-19 13:03:38.6', false, '28,27,26');
INSERT INTO public.appointment VALUES (61, 2, 4, '2021-06-19', '20:15:00', '20:30:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'onlineCollection', 'online', 'notCompleted', '2021-06-19 14:30:45.155', false, NULL);
INSERT INTO public.appointment VALUES (62, 2, 4, '2021-06-19', '20:45:00', '21:00:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'onlineCollection', 'online', 'notCompleted', '2021-06-19 15:12:34.58', false, NULL);
INSERT INTO public.appointment VALUES (74, 2, 4, '2021-06-20', '21:20:00', '21:35:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'onlineCollection', 'online', 'notCompleted', '2021-06-20 08:38:51.242', false, NULL);
INSERT INTO public.appointment VALUES (63, 2, 4, '2021-06-19', '21:45:00', '22:00:00', NULL, false, true, 'PATIENT', 4, 'PATIENT', NULL, 15, 'onlineCollection', 'online', 'notCompleted', '2021-06-19 15:14:53.669', false, NULL);
INSERT INTO public.appointment VALUES (65, 2, 37, '2021-06-19', '21:45:00', '22:00:00', NULL, false, true, '{"DOCTOR"}', 7, '{"DOCTOR"}', 7, 15, 'directPayment', 'online', 'notCompleted', '2021-06-19 15:15:50.887', false, NULL);
INSERT INTO public.appointment VALUES (73, 2, 4, '2021-06-20', '21:35:00', '21:50:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'onlineCollection', 'online', 'paused', '2021-06-20 05:32:50.508', false, '58,59,60,61,62');
INSERT INTO public.appointment VALUES (84, 1, 1, '2021-06-23', '21:00:00', '21:15:00', NULL, true, false, 'DOCTOR', 2, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-21 12:21:25.304', false, NULL);
INSERT INTO public.appointment VALUES (75, 2, 38, '2021-06-20', '21:50:00', '22:05:00', NULL, true, false, 'PATIENT', 38, NULL, NULL, 15, 'onlineCollection', 'online', 'paused', '2021-06-20 09:03:53.458', false, '69,68,67,66,65');
INSERT INTO public.appointment VALUES (64, 2, 4, '2021-06-19', '21:30:00', '21:45:00', NULL, true, false, 'PATIENT', NULL, NULL, NULL, 15, 'directPayment', 'online', NULL, '2021-06-19 15:15:00.386', false, '34,33,32,31');
INSERT INTO public.appointment VALUES (66, 2, 37, '2021-06-19', '21:15:00', '21:30:00', NULL, true, false, '{"DOCTOR"}', 7, NULL, NULL, 15, 'directPayment', 'online', NULL, '2021-06-19 15:16:14.795', false, NULL);
INSERT INTO public.appointment VALUES (76, 34, 25, '2021-06-21', '13:44:00', '13:59:00', NULL, false, true, 'PATIENT', 25, '{"ADMIN","DOCTOR"}', 43, 15, 'directPayment', 'online', 'paused', '2021-06-21 05:08:18.381', false, NULL);
INSERT INTO public.appointment VALUES (77, 34, 25, '2021-06-21', '13:59:00', '14:14:00', NULL, true, false, '{"ADMIN","DOCTOR"}', 43, NULL, NULL, 15, 'directPayment', 'online', 'notCompleted', '2021-06-21 05:50:25.22', false, NULL);
INSERT INTO public.appointment VALUES (85, 1, 1, '2021-06-21', '23:30:00', '23:45:00', NULL, true, false, 'DOCTOR', 2, NULL, NULL, 15, 'directPayment', 'online', NULL, '2021-06-21 12:22:45.969', false, NULL);
INSERT INTO public.appointment VALUES (78, 2, 4, '2021-06-21', '14:00:00', '14:15:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'onlineCollection', 'online', 'paused', '2021-06-21 08:20:43.573', false, NULL);
INSERT INTO public.appointment VALUES (87, 2, 51, '2021-06-21', '19:00:00', '19:15:00', NULL, true, false, 'PATIENT', 51, NULL, NULL, 15, 'onlineCollection', 'online', 'notCompleted', '2021-06-21 13:22:00.454', false, '184,183,182');
INSERT INTO public.appointment VALUES (82, 2, 4, '2021-06-21', '18:00:00', '18:15:00', NULL, true, false, 'PATIENT', 4, NULL, NULL, 15, 'directPayment', 'online', 'paused', '2021-06-21 11:47:56.856', false, '171,170,169,172,173');
INSERT INTO public.appointment VALUES (86, 1, 1, '2021-06-21', '23:15:00', '23:30:00', NULL, true, false, 'DOCTOR', 2, NULL, NULL, 15, 'directPayment', 'online', 'completed', '2021-06-21 12:26:43.381', false, NULL);


--
-- TOC entry 4149 (class 0 OID 17870)
-- Dependencies: 206
-- Data for Name: appointment_cancel_reschedule; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4151 (class 0 OID 17875)
-- Dependencies: 208
-- Data for Name: appointment_doc_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.appointment_doc_config VALUES (1, 1, 5, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (2, 2, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (3, 3, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (4, 4, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (5, 5, 0, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (6, 6, 0, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (7, 7, 0, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (8, 8, 0, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (9, 9, 0, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (10, 10, 0, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (11, 11, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (12, 12, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (13, 13, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (14, 14, 0, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (15, 15, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (16, 16, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (17, 17, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (18, 18, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (19, 19, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (20, 20, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (21, 21, 0, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (22, 22, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (23, 23, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (24, 24, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (25, 25, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (26, 26, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (27, 27, 0, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (28, 28, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (29, 29, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (30, 30, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (31, 31, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (32, 32, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (33, 33, 1, true, 2, NULL, true, '0', 0, 10, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (34, 34, 1, true, 2, NULL, true, '0', 0, 10, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (35, 35, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (36, 36, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (37, 37, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (38, 38, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (39, 39, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (40, 40, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (41, 41, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (42, 42, 1000, false, 2, NULL, true, '0', 1, 0, true, '0', 1, 0, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (43, 43, 1000, false, 2, NULL, true, '0', 1, 0, true, '0', 1, 0, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (44, 44, 10, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (45, 45, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (46, 46, 1000, false, 2, NULL, true, '0', 1, 0, true, '0', 1, 0, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (47, 47, 1000, false, 2, NULL, true, '0', 1, 0, true, '0', 1, 0, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (48, 48, 1000, false, 2, NULL, true, '0', 1, 0, true, '0', 1, 0, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (49, 49, 1000, false, 2, NULL, true, '0', 1, 0, true, '0', 1, 0, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (50, 50, 1000, false, 2, NULL, true, '0', 1, 0, true, '0', 1, 0, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (51, 51, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (52, 52, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (53, 53, 1, true, 2, NULL, true, '0', 0, 10, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (54, 54, 1, true, 2, NULL, true, '0', 0, 10, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (55, 55, 1, true, 2, NULL, true, '0', 0, 10, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (56, 56, 1, true, 2, NULL, true, '0', 0, 10, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (57, 57, 1, true, 2, NULL, true, '0', 0, 10, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (58, 58, 1, true, 2, NULL, true, '0', 0, 10, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (59, 59, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (60, 60, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (61, 61, 1, true, 2, NULL, true, '0', 0, 10, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (62, 62, 1, true, 2, NULL, true, '0', 0, 10, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (63, 63, 1, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (64, 64, 1, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (65, 65, 1, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (66, 66, 1, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (67, 67, 1, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (68, 68, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (69, 69, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (70, 70, 1, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (71, 71, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (72, 72, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (73, 73, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (74, 74, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (75, 75, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (76, 76, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (77, 77, 100, false, 2, NULL, false, '5', 2, 30, false, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (78, 78, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (79, 79, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (80, 80, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (81, 81, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (82, 82, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (83, 83, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (84, 84, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (85, 85, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (86, 86, 1, true, 2, NULL, true, '5', 2, 30, true, '6', 8, 40, '5', 3, 15);
INSERT INTO public.appointment_doc_config VALUES (87, 87, 0, true, 2, NULL, true, '0', 0, 10, true, '0', 0, 10, '5', 3, 15);


--
-- TOC entry 4155 (class 0 OID 17887)
-- Dependencies: 212
-- Data for Name: communication_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.communication_type VALUES (1, 'Email');


--
-- TOC entry 4157 (class 0 OID 17892)
-- Dependencies: 214
-- Data for Name: doc_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doc_config VALUES (1, 'Doc_1', '1', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (5, 'Doc_5', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (6, 'Doc_8', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (7, 'Doc_9', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (8, 'Doc_10', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (9, 'Doc_11', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (10, 'Doc_12', '0', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (11, 'Doc_13', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (12, 'Doc_14', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (13, 'Doc_15', '100', false, '2', NULL, false, '0', '0', '10', false, '0', '0', '10', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (14, 'Doc_16', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (16, 'Doc_18', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (4, 'Doc_4', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (15, 'Doc_17', '400', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (17, 'Doc_19', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (3, 'Doc_3', '500', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (18, 'Doc_23', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (20, 'Doc_25', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (22, 'Doc_27', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (23, 'Doc_31', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (24, 'Doc_32', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (25, 'Doc_33', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (19, 'Doc_24', '10', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (26, 'Doc_34', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (27, 'Doc_38', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (28, 'Doc_35', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (29, 'Doc_42', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (30, 'Doc_39', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (31, 'Doc_43', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (21, 'Doc_26', '1000', false, '2', NULL, true, '0', '1', '0', true, '0', '1', '0', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (32, 'Doc_44', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (33, 'Doc_45', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (34, 'Doc_46', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (35, 'Doc_49', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (36, 'Doc_50', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (2, 'Doc_2', '0', true, '2', NULL, true, '0', '0', '10', true, '0', '0', '10', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (37, 'Doc_54', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (38, 'Doc_57', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);
INSERT INTO public.doc_config VALUES (39, 'Doc_58', '100', false, '2', NULL, false, '5', '2', '30', false, '6', '8', '40', '5', '3', '15', false, NULL, NULL, NULL, false, NULL, 15);


--
-- TOC entry 4160 (class 0 OID 17922)
-- Dependencies: 217
-- Data for Name: doc_config_schedule_day; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doc_config_schedule_day VALUES (1, 'Monday', 1, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Tuesday', 2, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Wednesday', 3, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Thursday', 4, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Friday', 5, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Saturday', 6, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (1, 'Sunday', 7, 'Doc_1');
INSERT INTO public.doc_config_schedule_day VALUES (2, 'Monday', 8, 'Doc_2');
INSERT INTO public.doc_config_schedule_day VALUES (2, 'Tuesday', 9, 'Doc_2');
INSERT INTO public.doc_config_schedule_day VALUES (2, 'Wednesday', 10, 'Doc_2');
INSERT INTO public.doc_config_schedule_day VALUES (2, 'Thursday', 11, 'Doc_2');
INSERT INTO public.doc_config_schedule_day VALUES (2, 'Friday', 12, 'Doc_2');
INSERT INTO public.doc_config_schedule_day VALUES (2, 'Saturday', 13, 'Doc_2');
INSERT INTO public.doc_config_schedule_day VALUES (2, 'Sunday', 14, 'Doc_2');
INSERT INTO public.doc_config_schedule_day VALUES (3, 'Monday', 15, 'Doc_3');
INSERT INTO public.doc_config_schedule_day VALUES (3, 'Tuesday', 16, 'Doc_3');
INSERT INTO public.doc_config_schedule_day VALUES (3, 'Wednesday', 17, 'Doc_3');
INSERT INTO public.doc_config_schedule_day VALUES (3, 'Thursday', 18, 'Doc_3');
INSERT INTO public.doc_config_schedule_day VALUES (3, 'Friday', 19, 'Doc_3');
INSERT INTO public.doc_config_schedule_day VALUES (3, 'Saturday', 20, 'Doc_3');
INSERT INTO public.doc_config_schedule_day VALUES (3, 'Sunday', 21, 'Doc_3');
INSERT INTO public.doc_config_schedule_day VALUES (4, 'Sunday', 22, 'Doc_4');
INSERT INTO public.doc_config_schedule_day VALUES (4, 'Monday', 23, 'Doc_4');
INSERT INTO public.doc_config_schedule_day VALUES (4, 'Tuesday', 24, 'Doc_4');
INSERT INTO public.doc_config_schedule_day VALUES (4, 'Wednesday', 25, 'Doc_4');
INSERT INTO public.doc_config_schedule_day VALUES (4, 'Thursday', 26, 'Doc_4');
INSERT INTO public.doc_config_schedule_day VALUES (4, 'Friday', 27, 'Doc_4');
INSERT INTO public.doc_config_schedule_day VALUES (4, 'Saturday', 28, 'Doc_4');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Sunday', 29, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Monday', 30, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Tuesday', 31, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Wednesday', 32, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Thursday', 33, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Friday', 34, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (5, 'Saturday', 35, 'Doc_5');
INSERT INTO public.doc_config_schedule_day VALUES (8, 'Sunday', 36, 'Doc_8');
INSERT INTO public.doc_config_schedule_day VALUES (8, 'Monday', 37, 'Doc_8');
INSERT INTO public.doc_config_schedule_day VALUES (8, 'Tuesday', 38, 'Doc_8');
INSERT INTO public.doc_config_schedule_day VALUES (8, 'Wednesday', 39, 'Doc_8');
INSERT INTO public.doc_config_schedule_day VALUES (8, 'Thursday', 40, 'Doc_8');
INSERT INTO public.doc_config_schedule_day VALUES (8, 'Friday', 41, 'Doc_8');
INSERT INTO public.doc_config_schedule_day VALUES (8, 'Saturday', 42, 'Doc_8');
INSERT INTO public.doc_config_schedule_day VALUES (9, 'Sunday', 43, 'Doc_9');
INSERT INTO public.doc_config_schedule_day VALUES (9, 'Monday', 44, 'Doc_9');
INSERT INTO public.doc_config_schedule_day VALUES (9, 'Tuesday', 45, 'Doc_9');
INSERT INTO public.doc_config_schedule_day VALUES (9, 'Wednesday', 46, 'Doc_9');
INSERT INTO public.doc_config_schedule_day VALUES (9, 'Thursday', 47, 'Doc_9');
INSERT INTO public.doc_config_schedule_day VALUES (9, 'Friday', 48, 'Doc_9');
INSERT INTO public.doc_config_schedule_day VALUES (9, 'Saturday', 49, 'Doc_9');
INSERT INTO public.doc_config_schedule_day VALUES (10, 'Sunday', 50, 'Doc_10');
INSERT INTO public.doc_config_schedule_day VALUES (10, 'Monday', 51, 'Doc_10');
INSERT INTO public.doc_config_schedule_day VALUES (10, 'Tuesday', 52, 'Doc_10');
INSERT INTO public.doc_config_schedule_day VALUES (10, 'Wednesday', 53, 'Doc_10');
INSERT INTO public.doc_config_schedule_day VALUES (10, 'Thursday', 54, 'Doc_10');
INSERT INTO public.doc_config_schedule_day VALUES (10, 'Friday', 55, 'Doc_10');
INSERT INTO public.doc_config_schedule_day VALUES (10, 'Saturday', 56, 'Doc_10');
INSERT INTO public.doc_config_schedule_day VALUES (11, 'Sunday', 57, 'Doc_11');
INSERT INTO public.doc_config_schedule_day VALUES (11, 'Monday', 58, 'Doc_11');
INSERT INTO public.doc_config_schedule_day VALUES (11, 'Tuesday', 59, 'Doc_11');
INSERT INTO public.doc_config_schedule_day VALUES (11, 'Wednesday', 60, 'Doc_11');
INSERT INTO public.doc_config_schedule_day VALUES (11, 'Thursday', 61, 'Doc_11');
INSERT INTO public.doc_config_schedule_day VALUES (11, 'Friday', 62, 'Doc_11');
INSERT INTO public.doc_config_schedule_day VALUES (11, 'Saturday', 63, 'Doc_11');
INSERT INTO public.doc_config_schedule_day VALUES (12, 'Sunday', 64, 'Doc_12');
INSERT INTO public.doc_config_schedule_day VALUES (12, 'Monday', 65, 'Doc_12');
INSERT INTO public.doc_config_schedule_day VALUES (12, 'Tuesday', 66, 'Doc_12');
INSERT INTO public.doc_config_schedule_day VALUES (12, 'Wednesday', 67, 'Doc_12');
INSERT INTO public.doc_config_schedule_day VALUES (12, 'Thursday', 68, 'Doc_12');
INSERT INTO public.doc_config_schedule_day VALUES (12, 'Friday', 69, 'Doc_12');
INSERT INTO public.doc_config_schedule_day VALUES (12, 'Saturday', 70, 'Doc_12');
INSERT INTO public.doc_config_schedule_day VALUES (13, 'Sunday', 71, 'Doc_13');
INSERT INTO public.doc_config_schedule_day VALUES (13, 'Monday', 72, 'Doc_13');
INSERT INTO public.doc_config_schedule_day VALUES (13, 'Tuesday', 73, 'Doc_13');
INSERT INTO public.doc_config_schedule_day VALUES (13, 'Wednesday', 74, 'Doc_13');
INSERT INTO public.doc_config_schedule_day VALUES (13, 'Thursday', 75, 'Doc_13');
INSERT INTO public.doc_config_schedule_day VALUES (13, 'Friday', 76, 'Doc_13');
INSERT INTO public.doc_config_schedule_day VALUES (13, 'Saturday', 77, 'Doc_13');
INSERT INTO public.doc_config_schedule_day VALUES (14, 'Sunday', 78, 'Doc_14');
INSERT INTO public.doc_config_schedule_day VALUES (14, 'Monday', 79, 'Doc_14');
INSERT INTO public.doc_config_schedule_day VALUES (14, 'Tuesday', 80, 'Doc_14');
INSERT INTO public.doc_config_schedule_day VALUES (14, 'Wednesday', 81, 'Doc_14');
INSERT INTO public.doc_config_schedule_day VALUES (14, 'Thursday', 82, 'Doc_14');
INSERT INTO public.doc_config_schedule_day VALUES (14, 'Friday', 83, 'Doc_14');
INSERT INTO public.doc_config_schedule_day VALUES (14, 'Saturday', 84, 'Doc_14');
INSERT INTO public.doc_config_schedule_day VALUES (15, 'Sunday', 85, 'Doc_15');
INSERT INTO public.doc_config_schedule_day VALUES (15, 'Monday', 86, 'Doc_15');
INSERT INTO public.doc_config_schedule_day VALUES (15, 'Tuesday', 87, 'Doc_15');
INSERT INTO public.doc_config_schedule_day VALUES (15, 'Wednesday', 88, 'Doc_15');
INSERT INTO public.doc_config_schedule_day VALUES (15, 'Thursday', 89, 'Doc_15');
INSERT INTO public.doc_config_schedule_day VALUES (15, 'Friday', 90, 'Doc_15');
INSERT INTO public.doc_config_schedule_day VALUES (15, 'Saturday', 91, 'Doc_15');
INSERT INTO public.doc_config_schedule_day VALUES (16, 'Sunday', 92, 'Doc_16');
INSERT INTO public.doc_config_schedule_day VALUES (16, 'Monday', 93, 'Doc_16');
INSERT INTO public.doc_config_schedule_day VALUES (16, 'Tuesday', 94, 'Doc_16');
INSERT INTO public.doc_config_schedule_day VALUES (16, 'Wednesday', 95, 'Doc_16');
INSERT INTO public.doc_config_schedule_day VALUES (16, 'Thursday', 96, 'Doc_16');
INSERT INTO public.doc_config_schedule_day VALUES (16, 'Friday', 97, 'Doc_16');
INSERT INTO public.doc_config_schedule_day VALUES (16, 'Saturday', 98, 'Doc_16');
INSERT INTO public.doc_config_schedule_day VALUES (17, 'Sunday', 99, 'Doc_17');
INSERT INTO public.doc_config_schedule_day VALUES (17, 'Monday', 100, 'Doc_17');
INSERT INTO public.doc_config_schedule_day VALUES (17, 'Tuesday', 101, 'Doc_17');
INSERT INTO public.doc_config_schedule_day VALUES (17, 'Wednesday', 102, 'Doc_17');
INSERT INTO public.doc_config_schedule_day VALUES (17, 'Thursday', 103, 'Doc_17');
INSERT INTO public.doc_config_schedule_day VALUES (17, 'Friday', 104, 'Doc_17');
INSERT INTO public.doc_config_schedule_day VALUES (17, 'Saturday', 105, 'Doc_17');
INSERT INTO public.doc_config_schedule_day VALUES (18, 'Sunday', 106, 'Doc_18');
INSERT INTO public.doc_config_schedule_day VALUES (18, 'Monday', 107, 'Doc_18');
INSERT INTO public.doc_config_schedule_day VALUES (18, 'Tuesday', 108, 'Doc_18');
INSERT INTO public.doc_config_schedule_day VALUES (18, 'Wednesday', 109, 'Doc_18');
INSERT INTO public.doc_config_schedule_day VALUES (18, 'Thursday', 110, 'Doc_18');
INSERT INTO public.doc_config_schedule_day VALUES (18, 'Friday', 111, 'Doc_18');
INSERT INTO public.doc_config_schedule_day VALUES (18, 'Saturday', 112, 'Doc_18');
INSERT INTO public.doc_config_schedule_day VALUES (19, 'Sunday', 113, 'Doc_19');
INSERT INTO public.doc_config_schedule_day VALUES (19, 'Monday', 114, 'Doc_19');
INSERT INTO public.doc_config_schedule_day VALUES (19, 'Tuesday', 115, 'Doc_19');
INSERT INTO public.doc_config_schedule_day VALUES (19, 'Wednesday', 116, 'Doc_19');
INSERT INTO public.doc_config_schedule_day VALUES (19, 'Thursday', 117, 'Doc_19');
INSERT INTO public.doc_config_schedule_day VALUES (19, 'Friday', 118, 'Doc_19');
INSERT INTO public.doc_config_schedule_day VALUES (19, 'Saturday', 119, 'Doc_19');
INSERT INTO public.doc_config_schedule_day VALUES (23, 'Sunday', 120, 'Doc_23');
INSERT INTO public.doc_config_schedule_day VALUES (23, 'Monday', 121, 'Doc_23');
INSERT INTO public.doc_config_schedule_day VALUES (23, 'Tuesday', 122, 'Doc_23');
INSERT INTO public.doc_config_schedule_day VALUES (23, 'Wednesday', 123, 'Doc_23');
INSERT INTO public.doc_config_schedule_day VALUES (23, 'Thursday', 124, 'Doc_23');
INSERT INTO public.doc_config_schedule_day VALUES (23, 'Friday', 125, 'Doc_23');
INSERT INTO public.doc_config_schedule_day VALUES (23, 'Saturday', 126, 'Doc_23');
INSERT INTO public.doc_config_schedule_day VALUES (24, 'Sunday', 127, 'Doc_24');
INSERT INTO public.doc_config_schedule_day VALUES (24, 'Monday', 128, 'Doc_24');
INSERT INTO public.doc_config_schedule_day VALUES (24, 'Tuesday', 129, 'Doc_24');
INSERT INTO public.doc_config_schedule_day VALUES (24, 'Wednesday', 130, 'Doc_24');
INSERT INTO public.doc_config_schedule_day VALUES (24, 'Thursday', 131, 'Doc_24');
INSERT INTO public.doc_config_schedule_day VALUES (24, 'Friday', 132, 'Doc_24');
INSERT INTO public.doc_config_schedule_day VALUES (24, 'Saturday', 133, 'Doc_24');
INSERT INTO public.doc_config_schedule_day VALUES (25, 'Sunday', 134, 'Doc_25');
INSERT INTO public.doc_config_schedule_day VALUES (25, 'Monday', 135, 'Doc_25');
INSERT INTO public.doc_config_schedule_day VALUES (25, 'Tuesday', 136, 'Doc_25');
INSERT INTO public.doc_config_schedule_day VALUES (25, 'Wednesday', 137, 'Doc_25');
INSERT INTO public.doc_config_schedule_day VALUES (25, 'Thursday', 138, 'Doc_25');
INSERT INTO public.doc_config_schedule_day VALUES (25, 'Friday', 139, 'Doc_25');
INSERT INTO public.doc_config_schedule_day VALUES (25, 'Saturday', 140, 'Doc_25');
INSERT INTO public.doc_config_schedule_day VALUES (26, 'Sunday', 141, 'Doc_26');
INSERT INTO public.doc_config_schedule_day VALUES (26, 'Monday', 142, 'Doc_26');
INSERT INTO public.doc_config_schedule_day VALUES (26, 'Tuesday', 143, 'Doc_26');
INSERT INTO public.doc_config_schedule_day VALUES (26, 'Wednesday', 144, 'Doc_26');
INSERT INTO public.doc_config_schedule_day VALUES (26, 'Thursday', 145, 'Doc_26');
INSERT INTO public.doc_config_schedule_day VALUES (26, 'Friday', 146, 'Doc_26');
INSERT INTO public.doc_config_schedule_day VALUES (26, 'Saturday', 147, 'Doc_26');
INSERT INTO public.doc_config_schedule_day VALUES (27, 'Sunday', 148, 'Doc_27');
INSERT INTO public.doc_config_schedule_day VALUES (27, 'Monday', 149, 'Doc_27');
INSERT INTO public.doc_config_schedule_day VALUES (27, 'Tuesday', 150, 'Doc_27');
INSERT INTO public.doc_config_schedule_day VALUES (27, 'Wednesday', 151, 'Doc_27');
INSERT INTO public.doc_config_schedule_day VALUES (27, 'Thursday', 152, 'Doc_27');
INSERT INTO public.doc_config_schedule_day VALUES (27, 'Friday', 153, 'Doc_27');
INSERT INTO public.doc_config_schedule_day VALUES (27, 'Saturday', 154, 'Doc_27');
INSERT INTO public.doc_config_schedule_day VALUES (31, 'Sunday', 155, 'Doc_31');
INSERT INTO public.doc_config_schedule_day VALUES (31, 'Monday', 156, 'Doc_31');
INSERT INTO public.doc_config_schedule_day VALUES (31, 'Tuesday', 157, 'Doc_31');
INSERT INTO public.doc_config_schedule_day VALUES (31, 'Wednesday', 158, 'Doc_31');
INSERT INTO public.doc_config_schedule_day VALUES (31, 'Thursday', 159, 'Doc_31');
INSERT INTO public.doc_config_schedule_day VALUES (31, 'Friday', 160, 'Doc_31');
INSERT INTO public.doc_config_schedule_day VALUES (31, 'Saturday', 161, 'Doc_31');
INSERT INTO public.doc_config_schedule_day VALUES (32, 'Sunday', 162, 'Doc_32');
INSERT INTO public.doc_config_schedule_day VALUES (32, 'Monday', 163, 'Doc_32');
INSERT INTO public.doc_config_schedule_day VALUES (32, 'Tuesday', 164, 'Doc_32');
INSERT INTO public.doc_config_schedule_day VALUES (32, 'Wednesday', 165, 'Doc_32');
INSERT INTO public.doc_config_schedule_day VALUES (32, 'Thursday', 166, 'Doc_32');
INSERT INTO public.doc_config_schedule_day VALUES (32, 'Friday', 167, 'Doc_32');
INSERT INTO public.doc_config_schedule_day VALUES (32, 'Saturday', 168, 'Doc_32');
INSERT INTO public.doc_config_schedule_day VALUES (33, 'Sunday', 169, 'Doc_33');
INSERT INTO public.doc_config_schedule_day VALUES (33, 'Monday', 170, 'Doc_33');
INSERT INTO public.doc_config_schedule_day VALUES (33, 'Tuesday', 171, 'Doc_33');
INSERT INTO public.doc_config_schedule_day VALUES (33, 'Wednesday', 172, 'Doc_33');
INSERT INTO public.doc_config_schedule_day VALUES (33, 'Thursday', 173, 'Doc_33');
INSERT INTO public.doc_config_schedule_day VALUES (33, 'Friday', 174, 'Doc_33');
INSERT INTO public.doc_config_schedule_day VALUES (33, 'Saturday', 175, 'Doc_33');
INSERT INTO public.doc_config_schedule_day VALUES (34, 'Sunday', 176, 'Doc_34');
INSERT INTO public.doc_config_schedule_day VALUES (34, 'Monday', 177, 'Doc_34');
INSERT INTO public.doc_config_schedule_day VALUES (34, 'Tuesday', 178, 'Doc_34');
INSERT INTO public.doc_config_schedule_day VALUES (34, 'Wednesday', 179, 'Doc_34');
INSERT INTO public.doc_config_schedule_day VALUES (34, 'Thursday', 180, 'Doc_34');
INSERT INTO public.doc_config_schedule_day VALUES (34, 'Friday', 181, 'Doc_34');
INSERT INTO public.doc_config_schedule_day VALUES (34, 'Saturday', 182, 'Doc_34');
INSERT INTO public.doc_config_schedule_day VALUES (35, 'Sunday', 183, 'Doc_35');
INSERT INTO public.doc_config_schedule_day VALUES (38, 'Sunday', 184, 'Doc_38');
INSERT INTO public.doc_config_schedule_day VALUES (38, 'Monday', 185, 'Doc_38');
INSERT INTO public.doc_config_schedule_day VALUES (38, 'Tuesday', 186, 'Doc_38');
INSERT INTO public.doc_config_schedule_day VALUES (38, 'Wednesday', 187, 'Doc_38');
INSERT INTO public.doc_config_schedule_day VALUES (38, 'Thursday', 188, 'Doc_38');
INSERT INTO public.doc_config_schedule_day VALUES (38, 'Friday', 189, 'Doc_38');
INSERT INTO public.doc_config_schedule_day VALUES (38, 'Saturday', 190, 'Doc_38');
INSERT INTO public.doc_config_schedule_day VALUES (35, 'Monday', 191, 'Doc_35');
INSERT INTO public.doc_config_schedule_day VALUES (35, 'Tuesday', 192, 'Doc_35');
INSERT INTO public.doc_config_schedule_day VALUES (35, 'Wednesday', 193, 'Doc_35');
INSERT INTO public.doc_config_schedule_day VALUES (35, 'Thursday', 194, 'Doc_35');
INSERT INTO public.doc_config_schedule_day VALUES (35, 'Friday', 195, 'Doc_35');
INSERT INTO public.doc_config_schedule_day VALUES (35, 'Saturday', 196, 'Doc_35');
INSERT INTO public.doc_config_schedule_day VALUES (39, 'Sunday', 197, 'Doc_39');
INSERT INTO public.doc_config_schedule_day VALUES (39, 'Monday', 198, 'Doc_39');
INSERT INTO public.doc_config_schedule_day VALUES (39, 'Tuesday', 199, 'Doc_39');
INSERT INTO public.doc_config_schedule_day VALUES (39, 'Wednesday', 200, 'Doc_39');
INSERT INTO public.doc_config_schedule_day VALUES (39, 'Thursday', 201, 'Doc_39');
INSERT INTO public.doc_config_schedule_day VALUES (39, 'Friday', 202, 'Doc_39');
INSERT INTO public.doc_config_schedule_day VALUES (39, 'Saturday', 203, 'Doc_39');
INSERT INTO public.doc_config_schedule_day VALUES (42, 'Sunday', 204, 'Doc_42');
INSERT INTO public.doc_config_schedule_day VALUES (42, 'Monday', 205, 'Doc_42');
INSERT INTO public.doc_config_schedule_day VALUES (42, 'Tuesday', 206, 'Doc_42');
INSERT INTO public.doc_config_schedule_day VALUES (42, 'Wednesday', 207, 'Doc_42');
INSERT INTO public.doc_config_schedule_day VALUES (42, 'Thursday', 208, 'Doc_42');
INSERT INTO public.doc_config_schedule_day VALUES (42, 'Friday', 209, 'Doc_42');
INSERT INTO public.doc_config_schedule_day VALUES (42, 'Saturday', 210, 'Doc_42');
INSERT INTO public.doc_config_schedule_day VALUES (43, 'Sunday', 211, 'Doc_43');
INSERT INTO public.doc_config_schedule_day VALUES (43, 'Monday', 212, 'Doc_43');
INSERT INTO public.doc_config_schedule_day VALUES (43, 'Tuesday', 213, 'Doc_43');
INSERT INTO public.doc_config_schedule_day VALUES (43, 'Wednesday', 214, 'Doc_43');
INSERT INTO public.doc_config_schedule_day VALUES (43, 'Thursday', 215, 'Doc_43');
INSERT INTO public.doc_config_schedule_day VALUES (43, 'Friday', 216, 'Doc_43');
INSERT INTO public.doc_config_schedule_day VALUES (43, 'Saturday', 217, 'Doc_43');
INSERT INTO public.doc_config_schedule_day VALUES (44, 'Sunday', 218, 'Doc_44');
INSERT INTO public.doc_config_schedule_day VALUES (44, 'Monday', 219, 'Doc_44');
INSERT INTO public.doc_config_schedule_day VALUES (44, 'Tuesday', 220, 'Doc_44');
INSERT INTO public.doc_config_schedule_day VALUES (44, 'Wednesday', 221, 'Doc_44');
INSERT INTO public.doc_config_schedule_day VALUES (44, 'Thursday', 222, 'Doc_44');
INSERT INTO public.doc_config_schedule_day VALUES (44, 'Friday', 223, 'Doc_44');
INSERT INTO public.doc_config_schedule_day VALUES (44, 'Saturday', 224, 'Doc_44');
INSERT INTO public.doc_config_schedule_day VALUES (45, 'Sunday', 225, 'Doc_45');
INSERT INTO public.doc_config_schedule_day VALUES (45, 'Monday', 226, 'Doc_45');
INSERT INTO public.doc_config_schedule_day VALUES (45, 'Tuesday', 227, 'Doc_45');
INSERT INTO public.doc_config_schedule_day VALUES (45, 'Wednesday', 228, 'Doc_45');
INSERT INTO public.doc_config_schedule_day VALUES (45, 'Thursday', 229, 'Doc_45');
INSERT INTO public.doc_config_schedule_day VALUES (45, 'Friday', 230, 'Doc_45');
INSERT INTO public.doc_config_schedule_day VALUES (45, 'Saturday', 231, 'Doc_45');
INSERT INTO public.doc_config_schedule_day VALUES (46, 'Sunday', 232, 'Doc_46');
INSERT INTO public.doc_config_schedule_day VALUES (46, 'Monday', 233, 'Doc_46');
INSERT INTO public.doc_config_schedule_day VALUES (46, 'Tuesday', 234, 'Doc_46');
INSERT INTO public.doc_config_schedule_day VALUES (46, 'Wednesday', 235, 'Doc_46');
INSERT INTO public.doc_config_schedule_day VALUES (46, 'Thursday', 236, 'Doc_46');
INSERT INTO public.doc_config_schedule_day VALUES (46, 'Friday', 237, 'Doc_46');
INSERT INTO public.doc_config_schedule_day VALUES (46, 'Saturday', 238, 'Doc_46');
INSERT INTO public.doc_config_schedule_day VALUES (47, 'Sunday', 239, 'Doc_49');
INSERT INTO public.doc_config_schedule_day VALUES (47, 'Monday', 240, 'Doc_49');
INSERT INTO public.doc_config_schedule_day VALUES (47, 'Tuesday', 241, 'Doc_49');
INSERT INTO public.doc_config_schedule_day VALUES (47, 'Wednesday', 242, 'Doc_49');
INSERT INTO public.doc_config_schedule_day VALUES (47, 'Thursday', 243, 'Doc_49');
INSERT INTO public.doc_config_schedule_day VALUES (47, 'Friday', 244, 'Doc_49');
INSERT INTO public.doc_config_schedule_day VALUES (47, 'Saturday', 245, 'Doc_49');
INSERT INTO public.doc_config_schedule_day VALUES (48, 'Sunday', 246, 'Doc_50');
INSERT INTO public.doc_config_schedule_day VALUES (48, 'Monday', 247, 'Doc_50');
INSERT INTO public.doc_config_schedule_day VALUES (48, 'Tuesday', 248, 'Doc_50');
INSERT INTO public.doc_config_schedule_day VALUES (48, 'Wednesday', 249, 'Doc_50');
INSERT INTO public.doc_config_schedule_day VALUES (48, 'Thursday', 250, 'Doc_50');
INSERT INTO public.doc_config_schedule_day VALUES (48, 'Friday', 251, 'Doc_50');
INSERT INTO public.doc_config_schedule_day VALUES (48, 'Saturday', 252, 'Doc_50');
INSERT INTO public.doc_config_schedule_day VALUES (52, 'Sunday', 253, 'Doc_54');
INSERT INTO public.doc_config_schedule_day VALUES (52, 'Monday', 254, 'Doc_54');
INSERT INTO public.doc_config_schedule_day VALUES (52, 'Tuesday', 255, 'Doc_54');
INSERT INTO public.doc_config_schedule_day VALUES (52, 'Wednesday', 256, 'Doc_54');
INSERT INTO public.doc_config_schedule_day VALUES (52, 'Thursday', 257, 'Doc_54');
INSERT INTO public.doc_config_schedule_day VALUES (52, 'Friday', 258, 'Doc_54');
INSERT INTO public.doc_config_schedule_day VALUES (52, 'Saturday', 259, 'Doc_54');
INSERT INTO public.doc_config_schedule_day VALUES (53, 'Sunday', 260, 'Doc_57');
INSERT INTO public.doc_config_schedule_day VALUES (53, 'Monday', 261, 'Doc_57');
INSERT INTO public.doc_config_schedule_day VALUES (53, 'Tuesday', 262, 'Doc_57');
INSERT INTO public.doc_config_schedule_day VALUES (53, 'Wednesday', 263, 'Doc_57');
INSERT INTO public.doc_config_schedule_day VALUES (53, 'Thursday', 264, 'Doc_57');
INSERT INTO public.doc_config_schedule_day VALUES (53, 'Friday', 265, 'Doc_57');
INSERT INTO public.doc_config_schedule_day VALUES (53, 'Saturday', 266, 'Doc_57');
INSERT INTO public.doc_config_schedule_day VALUES (54, 'Sunday', 267, 'Doc_58');
INSERT INTO public.doc_config_schedule_day VALUES (54, 'Monday', 268, 'Doc_58');
INSERT INTO public.doc_config_schedule_day VALUES (54, 'Tuesday', 269, 'Doc_58');
INSERT INTO public.doc_config_schedule_day VALUES (54, 'Wednesday', 270, 'Doc_58');
INSERT INTO public.doc_config_schedule_day VALUES (54, 'Thursday', 271, 'Doc_58');
INSERT INTO public.doc_config_schedule_day VALUES (54, 'Friday', 272, 'Doc_58');
INSERT INTO public.doc_config_schedule_day VALUES (54, 'Saturday', 273, 'Doc_58');


--
-- TOC entry 4162 (class 0 OID 17930)
-- Dependencies: 219
-- Data for Name: doc_config_schedule_interval; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doc_config_schedule_interval VALUES ('09:00:00', '12:00:00', 7, 1, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:00:00', '00:00:00', 3, 3, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:00:00', '00:00:00', 29, 11, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:00:00', '00:00:00', 30, 12, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:00:00', '23:00:00', 31, 13, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:00:00', '00:00:00', 32, 14, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:00:00', '00:00:00', 33, 15, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:00:00', '00:00:00', 35, 17, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:00:00', '00:00:00', 34, 16, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('22:00:00', '00:00:00', 70, 18, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('22:15:00', '00:00:00', 69, 19, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:44:00', '09:44:00', 15, 20, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('00:08:00', '12:08:00', 113, 21, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('01:57:00', '00:05:00', 107, 22, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('19:21:00', '19:21:00', 143, 188, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('19:21:00', '19:21:00', 142, 187, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('19:21:00', '19:21:00', 142, 189, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('19:20:00', '19:20:00', 142, 186, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('18:47:00', '22:00:00', 245, 190, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:02:00', '23:30:00', 182, 191, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:05:00', '00:00:00', 14, 192, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('21:00:00', '00:00:00', 13, 5, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('13:00:00', '14:15:00', 177, 81, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('15:44:00', '16:44:00', 178, 82, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('15:44:00', '16:44:00', 179, 84, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('09:45:00', '10:45:00', 180, 85, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('14:45:00', '15:45:00', 181, 86, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('00:00:00', '23:00:00', 8, 193, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('09:48:00', '23:00:00', 9, 194, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('07:48:00', '23:00:00', 10, 195, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('06:49:00', '23:34:00', 11, 196, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('09:00:00', '12:00:00', 1, 2, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('18:00:00', '23:52:00', 1, 197, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('18:53:00', '18:53:00', 147, 177, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('12:41:00', '02:41:00', 128, 74, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('12:42:00', '01:42:00', 127, 75, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('08:42:00', '17:42:00', 129, 76, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('08:42:00', '15:42:00', 130, 77, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('08:42:00', '17:42:00', 131, 78, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('09:43:00', '16:43:00', 132, 79, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('20:43:00', '16:43:00', 133, 80, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('10:44:00', '16:44:00', 176, 83, NULL);
INSERT INTO public.doc_config_schedule_interval VALUES ('19:16:00', '19:16:00', 146, 185, NULL);


--
-- TOC entry 4165 (class 0 OID 17940)
-- Dependencies: 222
-- Data for Name: doctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doctor VALUES (8, 'InValid doctor', 'Acc_2', 'Doc_8', 4, 'General Surgeon', 'MBBS', NULL, 8986579054, NULL, 'InValid', 'doctor', 'RegD_6', 'invaliddoctor2@gmail.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (32, 'laxmi narahari', 'Acc_31', 'Doc_32', 10, 'General Surgeon', 'MS - General Surgery, MBBS', NULL, 4578457845, NULL, 'laxmi', 'narahari', 'RegD_24', 'lakshmi.narasimhan@softsuave.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (46, 'Krishna Kumar', 'Acc_46', 'Doc_46', 10, 'cardiologist', 'Mbbs', NULL, 6360254465, NULL, 'Krishna', 'Kumar', 'RegD_34', 'krishnan@gmail.com', 'offline', NULL, 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/registrationIdProof/prescription-729%20%281%29.pdf');
INSERT INTO public.doctor VALUES (9, 'asd fgh', 'Acc_8', 'Doc_9', 2, 'cardiologist', 'MD', NULL, 9876543212, NULL, 'asd', 'fgh', 'RegD_7', 'sivaji@softsuave.com', 'offline', '2021-06-11 16:18:52.886', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/registrationIdProof/White%20171%20%281%29.png');
INSERT INTO public.doctor VALUES (17, 'rahul R', 'Acc_16', 'Doc_17', 1, 'Child', 'MBBS', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', 1111111111, NULL, 'rahul', 'R', 'RegD_15', 'rahul123@softsuave.com', 'online', '2021-06-15 23:44:03.002', NULL);
INSERT INTO public.doctor VALUES (35, 'Arul kumar', 'Acc_34', 'Doc_35', 10, 'mbbs ', 'mbbs', NULL, 1571571576, NULL, 'Arul', 'kumar', 'RegD_27', 'arul@gmail.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (39, 'rahul R', 'Acc_39', 'Doc_39', 1, 'Child', 'MBBS', NULL, 3252354353, NULL, 'rahul', 'R', 'RegD_29', 'ssssfds@softsuave.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (42, 'Test Reddy', 'Acc_42', 'Doc_42', 7, 'child specialist', 'MBBS', NULL, 6789023123, NULL, 'Test', 'Reddy', 'RegD_30', 'sivaji345@apollo.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (10, 'prashanth R', 'Acc_9', 'Doc_10', 1, 'child', 'MBBS', NULL, 1231231231, NULL, 'prashanth', 'R', 'RegD_8', 'demo123@softsuave.com', 'offline', '2021-06-11 16:35:35.975', NULL);
INSERT INTO public.doctor VALUES (11, 'rahul R', 'Acc_10', 'Doc_11', 1, '12312321', '3123123', NULL, 1111111111, NULL, 'rahul', 'R', 'RegD_9', 'prashanthrajendiran@softsuave.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (33, 'rahul R', 'Acc_32', 'Doc_33', 1, 'Child', 'MBBS', NULL, 1111111111, NULL, 'rahul', 'R', 'RegD_25', 'sadsaddadsa@softsuave.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (52, 'Siva Kumar', 'Acc_54', 'Doc_54', 10, 'Cardiologist', 'Mbbs', NULL, 8568568563, NULL, 'Siva', 'Kumar', 'RegD_37', 'siva@gmail.com', 'offline', NULL, 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/registrationIdProof/file_1621968367523.jpg');
INSERT INTO public.doctor VALUES (18, 'Deactivated doctor', 'Acc_17', 'Doc_18', 5, 'General Surgeon', 'MBBS', NULL, 7894567235, NULL, 'Deactivated', 'doctor', 'RegD_16', 'doctor@softsuave.com', 'offline', '2021-06-16 02:08:25.882', NULL);
INSERT INTO public.doctor VALUES (13, 'rahul R', 'Acc_12', 'Doc_13', 1, 'Child', 'MBBS', NULL, 1111111111, NULL, 'rahul', 'R', 'RegD_11', 'sakjdksadjk@softsuave.coma', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (3, 'Sreekumar Reddy', 'Acc_2', 'Doc_3', 5, 'General Surgeon', 'MBBS', NULL, 9876534567, NULL, 'Sreekumar', 'Reddy', 'RegD_3', 'sreekumarreddy@apollo.com', 'offline', '2021-06-15 23:44:03.001', NULL);
INSERT INTO public.doctor VALUES (5, 'madhu kadiyala', 'Acc_5', 'Doc_5', 10, 'cardiologist', 'MS - General Surgery, MBBS', NULL, 6360254465, NULL, 'madhu', 'kadiyala', 'RegD_5', 'madhu@gmail.com', 'online', '2021-06-19 11:52:01.802', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/registrationIdProof/prescription-726%20%282%29.pdf');
INSERT INTO public.doctor VALUES (2, 'Sreedhar Maganti', 'Acc_2', 'Doc_2', 7, 'General', 'MBBS', NULL, 6360254465, NULL, 'Sreedhar', 'Maganti', 'RegD_2', 'sreedhar@softsuave.com', 'offline', '2021-06-21 13:20:08.249', NULL);
INSERT INTO public.doctor VALUES (19, 'sreedar R', 'Acc_18', 'Doc_19', 1, 'Child', 'MBBS', NULL, 1111111111, NULL, 'sreedar', 'R', 'RegD_17', 'sreedar@softsuave.com', 'offline', '2021-06-16 01:27:23.368', NULL);
INSERT INTO public.doctor VALUES (24, 'Test Test', 'Acc_23', 'Doc_24', 4, 'General Surgeon', 'MBBS', NULL, 5678234598, NULL, 'Test', 'Test', 'RegD_19', 'testdoctor1@softsuave.com', 'offline', '2021-06-18 13:10:33.177', NULL);
INSERT INTO public.doctor VALUES (1, 'Chenthil Perumal', 'Acc_1', 'Doc_1', 11, 'General Surgeon', 'MBBS', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/doctor%20live.jpg', 9940027564, NULL, 'Chenthil', 'Perumal', 'RegD_1', 'chenthil@gmail.com', 'offline', '2021-06-21 12:30:18.989', NULL);
INSERT INTO public.doctor VALUES (14, 'rahul R', 'Acc_13', 'Doc_14', 1, 'Child', 'MBBS', NULL, 1111111111, NULL, 'rahul', 'R', 'RegD_12', 'dsafsdafsafdsaf@softsuave.com', 'offline', NULL, 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/registrationIdProof/1622906542037.jpg');
INSERT INTO public.doctor VALUES (27, 'siva test', 'Acc_26', 'Doc_27', 1, 'Child', 'MBBS', NULL, 1111111111, NULL, 'siva', 'test', 'RegD_22', 'sivatest@softsuave.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (16, 'rahul R', 'Acc_15', 'Doc_16', 1, 'Child', 'MBBS', NULL, 1111111111, NULL, 'rahul', 'R', 'RegD_14', 'rahul@softsuave.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (15, 'rahul R', 'Acc_14', 'Doc_15', 1, 'Child', 'MBBS', NULL, 1111111111, NULL, 'rahul', 'R', 'RegD_13', 'hkkhjl@softsuave.com', 'offline', '2021-06-14 09:40:06.538', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/registrationIdProof/1622906542037.jpg');
INSERT INTO public.doctor VALUES (12, 'Teja Bollineni', 'Acc_11', 'Doc_12', 10, 'Cardiolagist', 'Mbbs', NULL, 6360254465, NULL, 'Teja', 'Bollineni', 'RegD_10', 'teja@gmail.com', 'offline', '2021-06-11 16:49:30.209', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/registrationIdProof/images%20%281%29.jpeg');
INSERT INTO public.doctor VALUES (54, 'kumar Ji', 'Acc_58', 'Doc_58', 10, 'Cardiologisr', 'Mbbs', NULL, 1251251253, NULL, 'kumar', 'Ji', 'RegD_39', 'kumar@gmail.com', 'offline', NULL, 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/registrationIdProof/file_1621968367523.jpg');
INSERT INTO public.doctor VALUES (4, 'InValid doctor', 'Acc_2', 'Doc_4', 4, 'General Surgeon', 'MBBS', NULL, 8986579054, 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/signature/1622906542037.jpg', 'InValid', 'doctor', 'RegD_4', 'invaliddoctor1@gmail.com', 'offline', '2021-06-15 23:38:15.964', NULL);
INSERT INTO public.doctor VALUES (48, 'Dharani Antharvedi', 'Acc_50', 'Doc_50', 5, NULL, 'MBBS', NULL, 7845127845, NULL, 'Dharani', 'Antharvedi', 'RegD_36', 'dharani@gmail.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (31, 'rahul R', 'Acc_30', 'Doc_31', 1, 'Child', 'MBBS', NULL, 1111111111, NULL, 'rahul', 'R', 'RegD_23', 'dsadsads@softsuave.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (44, 'test R', 'Acc_44', 'Doc_44', 1, 'Child', 'MBBS', NULL, 3214321432, NULL, 'test', 'R', 'RegD_32', 'testr@softsuave.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (23, 'Test Test', 'Acc_22', 'Doc_23', 4, 'General Surgeon', 'MBBS', NULL, 5678234598, NULL, 'Test', 'Test', 'RegD_18', 'testdoctor@softsuave.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (25, 'Sivaji Reddy', 'Acc_24', 'Doc_25', 7, 'General Surgeon', 'MBBS', NULL, 8924678902, NULL, 'Sivaji', 'Reddy', 'RegD_20', 'sivaji@apollo.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (53, 'Kumar Kumar', 'Acc_57', 'Doc_57', 10, 'Cardiologist', 'Mbbs', NULL, 6360254465, NULL, 'Kumar', 'Kumar', 'RegD_38', 'kumar@softsuave.com', 'offline', NULL, 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/registrationIdProof/file_1621968367523.jpg');
INSERT INTO public.doctor VALUES (34, 'Prashath a', 'Acc_33', 'Doc_34', 5, 'General Surgeon', 'MBBS', NULL, 6789023456, NULL, 'Prashath', 'a', 'RegD_26', 'prasath@softsuave.com', 'offline', '2021-06-21 14:12:00.103', NULL);
INSERT INTO public.doctor VALUES (26, 'Prabhu Dharmaraj', 'Acc_25', 'Doc_26', 10, 'General', 'MBBS', NULL, 994041104, 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/signature/icici.jpg', 'Prabhu', 'Dharmaraj', 'RegD_21', 'prabhu.dharmaraj@softsuave.com', 'online', '2021-06-21 14:14:12.691', 'https://virujh-cloud.s3.amazonaws.com/virujh/registrationIdProof/icici.jpg');
INSERT INTO public.doctor VALUES (43, 'arul kumar', 'Acc_43', 'Doc_43', 10, 'General Surgeon', 'mbbs', NULL, 1431431434, NULL, 'arul', 'kumar', 'RegD_31', 'sridhar@softsuave.com', 'offline', '2021-06-18 10:40:06.317', NULL);
INSERT INTO public.doctor VALUES (47, 'munna bhai', 'Acc_49', 'Doc_49', 10, 'cardiologist', 'mbbs', NULL, 6360254469, NULL, 'munna', 'bhai', 'RegD_35', 'munna@gmail.com', 'offline', '2021-06-19 13:25:23.343', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/registrationIdProof/prescription-6%20%281%29.pdf');
INSERT INTO public.doctor VALUES (38, 'sss s', 'Acc_38', 'Doc_38', 1, 'Child', 'MBBS', NULL, 1111111111, NULL, 'sss', 's', 'RegD_28', 'sss@softsuave.com', 'offline', NULL, NULL);
INSERT INTO public.doctor VALUES (45, 'Laxmi Maganti', 'Acc_45', 'Doc_45', 10, 'Cardiologost', 'Mbbs', NULL, 6360254466, NULL, 'Laxmi', 'Maganti', 'RegD_33', 'laxmi@gmail.com', 'offline', NULL, NULL);


--
-- TOC entry 4158 (class 0 OID 17914)
-- Dependencies: 215
-- Data for Name: doctor_config_can_resch; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4167 (class 0 OID 17949)
-- Dependencies: 224
-- Data for Name: doctor_config_pre_consultation; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4172 (class 0 OID 17963)
-- Dependencies: 229
-- Data for Name: interval_days; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4174 (class 0 OID 17968)
-- Dependencies: 231
-- Data for Name: medicine; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medicine VALUES (1, 1, 'Chrocin', NULL, 0, NULL, '1-0-1', '1');
INSERT INTO public.medicine VALUES (2, 2, 'chro', NULL, 0, NULL, '1-0-1', '3');
INSERT INTO public.medicine VALUES (3, 3, 'testing', NULL, 0, NULL, 'jj', '7');
INSERT INTO public.medicine VALUES (4, 3, 'gfsdgfsg', NULL, 0, NULL, 'fdsgfd', 'fdgfdsg');
INSERT INTO public.medicine VALUES (5, 4, 'dev_appointment', NULL, 0, NULL, 'kgkjgjkgjkjjkjjk', '8');
INSERT INTO public.medicine VALUES (6, 4, 'jhfjhfhjhfhjf vjgjkkgjk', NULL, 0, NULL, 'jkgjkgjkgkj', '9');
INSERT INTO public.medicine VALUES (7, 4, 'jkgkjgjkgkj', NULL, 0, NULL, 'kjgkjgjkgjk', '6');
INSERT INTO public.medicine VALUES (8, 4, 'jgkjgjkgjkgjk', NULL, 0, NULL, 'kjfjkfjkgjk', '4');
INSERT INTO public.medicine VALUES (9, 5, 'paracetmal', NULL, 0, NULL, 'fghfghfgh', 'dfgfgh');
INSERT INTO public.medicine VALUES (10, 5, 'fghfgh', NULL, 0, NULL, 'fghfgh', 'fghfgh');
INSERT INTO public.medicine VALUES (11, 5, 'fghfgh', NULL, 0, NULL, 'fghfgh', 'fghfgh');
INSERT INTO public.medicine VALUES (12, 5, 'fghfgh', NULL, 0, NULL, 'fghfghfgh', 'fghfgh');
INSERT INTO public.medicine VALUES (13, 6, 'paracetmal', NULL, 0, NULL, 'jdfbjidsfdfg', '10');
INSERT INTO public.medicine VALUES (14, 6, 'jghjghjghj', NULL, 0, NULL, 'ghjghjghj', 'ghjghjghj');
INSERT INTO public.medicine VALUES (15, 6, 'ghjghjgh', NULL, 0, NULL, 'jghjghjghj', 'jghjghjgh');
INSERT INTO public.medicine VALUES (16, 6, 'ghjghjghj', NULL, 0, NULL, 'ghjghj', 'ghjghjghj');
INSERT INTO public.medicine VALUES (17, 7, 'asas', NULL, 0, NULL, 'sasa', '12');
INSERT INTO public.medicine VALUES (18, 8, 'Paracetmal', NULL, 0, NULL, 'Hsjsusi', '10');
INSERT INTO public.medicine VALUES (19, 9, 'Hdhdud', NULL, 0, NULL, 'Gdhsud', '646');
INSERT INTO public.medicine VALUES (20, 9, 'Nxjzjs', NULL, 0, NULL, 'Hsusus', '976767');
INSERT INTO public.medicine VALUES (21, 10, 'Fghc', NULL, 0, NULL, 'Vbj', '88');
INSERT INTO public.medicine VALUES (22, 10, 'Vvb', NULL, 0, NULL, 'Ghh', '899');
INSERT INTO public.medicine VALUES (23, 11, 'Testing', NULL, 0, NULL, 'hfhjh', '8');
INSERT INTO public.medicine VALUES (24, 11, 'test files', NULL, 0, NULL, 'jfjhfjhf', '9');
INSERT INTO public.medicine VALUES (25, 12, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (26, 12, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (27, 13, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (28, 14, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (29, 15, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (30, 14, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (31, 15, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (32, 16, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (33, 17, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (34, 17, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (35, 18, 'syrup', NULL, 0, NULL, '10 ml', '30');
INSERT INTO public.medicine VALUES (36, 19, 'syrup', NULL, 0, NULL, '10 ml', '3');
INSERT INTO public.medicine VALUES (37, 19, 'syrup', NULL, 0, NULL, '10 ml', '40');
INSERT INTO public.medicine VALUES (38, 20, 'syrup', NULL, 0, NULL, '10 ml', '3');
INSERT INTO public.medicine VALUES (39, 20, 'syrup', NULL, 0, NULL, '10 ml', '40');
INSERT INTO public.medicine VALUES (40, 21, 'syrup', NULL, 0, NULL, '10 ml', '7');
INSERT INTO public.medicine VALUES (41, 22, 'Gzhz', NULL, 0, NULL, 'Vzdgh', '94');
INSERT INTO public.medicine VALUES (42, 23, 'sgefisgf', NULL, 0, NULL, 'bjbojbol', 'bjo');
INSERT INTO public.medicine VALUES (43, 23, 'nfgh', NULL, 0, NULL, 'fghfgh', 'fgfghfgh');
INSERT INTO public.medicine VALUES (44, 23, 'fghfgh', NULL, 0, NULL, 'fghfgh', 'fghfgh');
INSERT INTO public.medicine VALUES (45, 23, 'fghfgh', NULL, 0, NULL, 'fghfgh', 'fghfgh');
INSERT INTO public.medicine VALUES (46, 24, 'chrocin', NULL, 0, NULL, '1-0-1', '1');
INSERT INTO public.medicine VALUES (47, 25, 'Fvjj', NULL, 0, NULL, 'Fhjhf', '588');


--
-- TOC entry 4176 (class 0 OID 17976)
-- Dependencies: 233
-- Data for Name: message_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.message_metadata VALUES (3, 3, 1, 3);
INSERT INTO public.message_metadata VALUES (4, 4, 1, 4);
INSERT INTO public.message_metadata VALUES (5, 5, 1, 5);
INSERT INTO public.message_metadata VALUES (6, 6, 1, 6);
INSERT INTO public.message_metadata VALUES (2, 2, 1, 2);
INSERT INTO public.message_metadata VALUES (7, 7, 1, 7);
INSERT INTO public.message_metadata VALUES (1, 1, 1, 1);


--
-- TOC entry 4178 (class 0 OID 17981)
-- Dependencies: 235
-- Data for Name: message_template; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.message_template VALUES (2, 'notifiaction@virujh.com', 'Registration For Doctor', '<html>
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
');
INSERT INTO public.message_template VALUES (3, 'notifiaction@virujh.com', 'Appointment Created', '<html>
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
</html>');
INSERT INTO public.message_template VALUES (4, 'notifiaction@virujh.com', 'Appointment Reschedule', '<html>
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
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Doctor Email:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{doctorEmail}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Hospital</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{hospital}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Patient Name:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{patientFirstName} {patientLastName}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Patient Email:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{patientEmail}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Patient Phone:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{patientPhone}</td>
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
</html>');
INSERT INTO public.message_template VALUES (5, 'notifiaction@virujh.com', 'Appointment Cancel', '<html>
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
</html>');
INSERT INTO public.message_template VALUES (6, 'notifiaction@virujh.com', 'Patient Registration', '<html>
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
</html>');
INSERT INTO public.message_template VALUES (7, 'notifiaction@virujh.com', 'Forgot Password', '<html>
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
</html>');
INSERT INTO public.message_template VALUES (1, 'notifiaction@virujh.com', 'Doctor Registration Update To Admin', '<html>
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
                 <h1 style="font-style: normal;font-weight: bold;font-size: 30px; text-align: center;color: #545454;margin: 0px;">Doctor Registration</h1>
                 <h1 style=" font-style: normal;font-weight: 600; font-size: 25px;line-height: 37px;
text-align: left; color: #000000;">Hi, New doctor has registered with us!. Please check and accept the invitation</h1>
                    <table class="app-table" style="width: 100%;">
                    	<tr class="app-row">
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Doctor Name:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{user_name}</td>
                        </tr>
                        <tr class="app-row">
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Phone:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{phone}</td>
                        </tr>
                        <tr>
                            <td class="app-td-name" style="font-style: normal;font-weight: 500;font-size: 18px; color: #4D4D4D; padding-left: 5vh;">Email:</td>
                            <td class="app-td-value" style="font-style: normal;font-weight: 500; font-size: 18px; line-height: 27px; text-align: left; color: #0BB5FF;">{email}</td>
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
</html>');


--
-- TOC entry 4180 (class 0 OID 17989)
-- Dependencies: 237
-- Data for Name: message_template_placeholders; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4182 (class 0 OID 17994)
-- Dependencies: 239
-- Data for Name: message_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.message_type VALUES (3, 'APPOINTMENT_CREATED', 'Appointment Created');
INSERT INTO public.message_type VALUES (4, 'APPOINTMENT_RESCHEDULE', 'Appointment Reschedule');
INSERT INTO public.message_type VALUES (5, 'APPOINTMENT_CANCEL', 'Appointment Cancel ');
INSERT INTO public.message_type VALUES (6, 'PATIENT_REGISTRATION', 'Patient Registration');
INSERT INTO public.message_type VALUES (2, 'REGISTRATION_FOR_DOCTOR', 'Registration For Doctor');
INSERT INTO public.message_type VALUES (7, 'FORGOT_PASSWORD', 'Forgot Password');
INSERT INTO public.message_type VALUES (1, 'UPDATE_DOCTOR_REGISTRATION_TO_ADMIN', 'Update Doctor Registration ToAdmin');

--
-- TOC entry 3383 (class 0 OID 16963)
-- Dependencies: 258
-- Data for Name: mobile_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.mobile_version (id, android_version, ios_version) VALUES (1, 1, 1);

--
-- TOC entry 4184 (class 0 OID 18002)
-- Dependencies: 241
-- Data for Name: openvidu_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.openvidu_session VALUES (490, 'Doc_24', 'Test Test_1624002004863', 'ses_QRhdKmBImF');
INSERT INTO public.openvidu_session VALUES (106, 'Doc_10', 'prashanth R_1623429146927', 'ses_TdATUlmG8q');
INSERT INTO public.openvidu_session VALUES (107, 'Doc_12', 'Teja Bollineni_1623430040098', 'ses_ZK82onTsQA');
INSERT INTO public.openvidu_session VALUES (555, 'Doc_26', 'Prabhu Dharmaraj_1624022243271', 'ses_JLaNGfYIeC');
INSERT INTO public.openvidu_session VALUES (507, 'Doc_43', 'arul kumar_1624012801078', 'ses_WVBlIrXhCs');
INSERT INTO public.openvidu_session VALUES (365, 'Doc_19', 'sreedar R_1623786952192', 'ses_KSrT9d0Q61');
INSERT INTO public.openvidu_session VALUES (129, 'Doc_15', 'rahul R_1623662898136', 'ses_UuwS5zm22j');
INSERT INTO public.openvidu_session VALUES (324, 'Doc_3', 'Sreekumar Reddy_1623780482214', 'ses_Zs8Jz6az2B');
INSERT INTO public.openvidu_session VALUES (575, 'Doc_5', 'madhu kadiyala_1624083734587', 'ses_DGCGdNPDxn');
INSERT INTO public.openvidu_session VALUES (327, 'Doc_17', 'rahul R_1623780566104', 'ses_Pqd759V8e0');
INSERT INTO public.openvidu_session VALUES (381, 'Doc_18', 'Deactivated doctor_1623788826964', 'ses_Ke6BqpCBnf');
INSERT INTO public.openvidu_session VALUES (788, 'Doc_1', 'Chenthil Perumal_1624278612902', 'ses_YCGNxauFsE');
INSERT INTO public.openvidu_session VALUES (791, 'Doc_2', 'Sreedhar Maganti_1624281569812', 'ses_AA2l6MJ0Ql');
INSERT INTO public.openvidu_session VALUES (638, 'Doc_49', 'munna bhai_1624109073676', 'ses_SJ9ok75FcE');
INSERT INTO public.openvidu_session VALUES (792, 'Doc_34', 'Prashath a_1624284114845', 'ses_OKULwO4NyE');


--
-- TOC entry 4186 (class 0 OID 18007)
-- Dependencies: 243
-- Data for Name: openvidu_session_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.openvidu_session_token VALUES (571, 555, 'wss://dev.virujh.com?sessionId=ses_JLaNGfYIeC&token=tok_OyqRJov9Hl8OgckR', 26, NULL);
INSERT INTO public.openvidu_session_token VALUES (523, 507, 'wss://dev.virujh.com?sessionId=ses_WVBlIrXhCs&token=tok_C3ojXKL23o7IYJsI', 43, NULL);
INSERT INTO public.openvidu_session_token VALUES (107, 106, 'wss://dev.virujh.com?sessionId=ses_TdATUlmG8q&token=tok_DZsAdTOhlwgyTyly', 10, NULL);
INSERT INTO public.openvidu_session_token VALUES (108, 107, 'wss://dev.virujh.com?sessionId=ses_ZK82onTsQA&token=tok_ZxIxmpcXg65Qhbyd', 12, NULL);
INSERT INTO public.openvidu_session_token VALUES (372, 365, 'wss://dev.virujh.com?sessionId=ses_KSrT9d0Q61&token=tok_YKI9v9YZHST6Q7Df', 19, NULL);
INSERT INTO public.openvidu_session_token VALUES (328, 324, 'wss://dev.virujh.com?sessionId=ses_Zs8Jz6az2B&token=tok_ZSFo9mPXVElqq4Kx', 3, NULL);
INSERT INTO public.openvidu_session_token VALUES (331, 327, 'wss://dev.virujh.com?sessionId=ses_Pqd759V8e0&token=tok_AhntYixnRsXti8j1', 17, NULL);
INSERT INTO public.openvidu_session_token VALUES (591, 575, 'wss://dev.virujh.com?sessionId=ses_DGCGdNPDxn&token=tok_N0CkjnZ3no5UDAYD', 5, NULL);
INSERT INTO public.openvidu_session_token VALUES (131, 129, 'wss://dev.virujh.com?sessionId=ses_UuwS5zm22j&token=tok_XBHuO81hlkV2W9k3', 15, NULL);
INSERT INTO public.openvidu_session_token VALUES (393, 381, 'wss://dev.virujh.com?sessionId=ses_Ke6BqpCBnf&token=tok_E6SlxVwbqADsZwKm', 18, NULL);
INSERT INTO public.openvidu_session_token VALUES (503, 490, 'wss://dev.virujh.com?sessionId=ses_QRhdKmBImF&token=tok_FHgbS5KFrZQrQI1Z', 24, NULL);
INSERT INTO public.openvidu_session_token VALUES (868, 788, 'wss://dev.virujh.com?sessionId=ses_YCGNxauFsE&token=tok_ENX3OqeBKbQ9UxYC', 1, NULL);
INSERT INTO public.openvidu_session_token VALUES (666, 638, 'wss://dev.virujh.com?sessionId=ses_SJ9ok75FcE&token=tok_EBh0XTwigTolv39a', 47, NULL);
INSERT INTO public.openvidu_session_token VALUES (872, 791, 'wss://dev.virujh.com?sessionId=ses_AA2l6MJ0Ql&token=tok_WLmMokQnHuza37zi', 2, NULL);
INSERT INTO public.openvidu_session_token VALUES (873, 792, 'wss://dev.virujh.com?sessionId=ses_OKULwO4NyE&token=tok_XELV4VqudzAZyM8n', 34, NULL);


--
-- TOC entry 4188 (class 0 OID 18015)
-- Dependencies: 245
-- Data for Name: patient_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.patient_details VALUES (34, 'asdad asdasd', NULL, NULL, NULL, NULL, NULL, NULL, 'asdad@gmail.com', NULL, '6789012323', 34, 'asdad', 'asdasd', '2021-06-05T05:00:00.000Z', NULL, NULL, 'online', NULL, NULL, NULL, NULL);
INSERT INTO public.patient_details VALUES (26, 'madhu kadiyala', NULL, 'india', NULL, 'madhanandapuram', 'tamilnadu', '524201', 'sreedhar@softsuave.com', NULL, '1471471471', 26, 'madhu', 'kadiyala', '1990-06-18T08:15:00.000Z', '1471471472', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (6, 'arul kumar', NULL, NULL, NULL, NULL, NULL, NULL, 'sreedhar@softsuave.com', NULL, '1251251254', 6, 'arul', 'kumar', '2001-06-11T15:55:00.000Z', NULL, NULL, 'online', NULL, NULL, NULL, NULL);
INSERT INTO public.patient_details VALUES (37, 'BNa Bsbsj', NULL, NULL, NULL, NULL, NULL, NULL, 'sreedhar@softsuave.com', NULL, '4564564566', 37, 'BNa', 'Bsbsj', '2021-01-21', NULL, NULL, 'online', NULL, NULL, NULL, NULL);
INSERT INTO public.patient_details VALUES (3, 'OldRam OldV', NULL, 'India', NULL, 'Devika Ammal Street', 'TN', '600116', 'rameshv1210@gmail.com', NULL, '9884142042', 3, 'OldRam', 'OldV', '1985-06-01T11:43:00.000Z', '', 36, 'offline', '2021-06-17 11:48:16.524', 'Chennai', NULL, NULL);
INSERT INTO public.patient_details VALUES (2, 'sreedhar maganti', NULL, 'india', NULL, 'madhanandapuram', 'tamilnadu', '524201', 'sreedhar@softsuave.com', NULL, '6360254465', 2, 'sreedhar', 'maganti', '1990-03-08T15:44:00.000Z', '8885310100', 31, 'offline', '2021-06-10 16:58:57.549', 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (50, 'ABC XYZ', NULL, 'india', NULL, 'dfgtesd345sfd', 'tamilnadu', '600125', 'loyolaprabhu@gmail.com', NULL, '1234567890', 50, 'ABC', 'XYZ', '1971-06-20T12:56:00.000Z', '', 50, 'offline', '2021-06-21 12:58:17.138', 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (5, 'manikandan mani', NULL, NULL, NULL, NULL, NULL, NULL, 'sreedhar@softsuave.com', NULL, '1112221112', 5, 'manikandan', 'mani', '2000-06-10T19:18:35.154Z', NULL, NULL, 'online', NULL, NULL, NULL, NULL);
INSERT INTO public.patient_details VALUES (10, 'rahul R', NULL, 'fsdafdsaf', NULL, 'hgfhgfh', 'Virginia', '30003', 'rahul@softsuave.com', NULL, '4354644565', 10, 'rahul', 'R', '2009-06-17T15:43:00.000Z', '', 11, 'offline', '2021-06-16 00:56:22.262', 'Atlanta', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (22, 'kiran rao', NULL, 'india', NULL, 'annaivelankini nagar', 'tamilnadu', '600116', 'kiranrao@gmail.com', NULL, '4566544566', 18, 'kiran', 'rao', '1990-06-17T07:16:00.000Z', '8885310100', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (52, 'dfssdfsd dsfs', NULL, 'India', NULL, 'sdfsdfsdcv', 'Tamilnadu', '600116', 'loyolaprabhu@gmail.com', NULL, '3453453450', 52, 'dfssdfsd', 'dsfs', '1981-06-04T13:24:00.000Z', '', 40, 'offline', '2021-06-21 13:26:21.573', 'chennai', 'Ms', 'Female');
INSERT INTO public.patient_details VALUES (41, 'Jac John', NULL, 'India', NULL, '1st street, porur', 'TN', '600125', 'loyolaprabhu@gmail.com', NULL, '9791036048', 41, 'Jac', 'John', '2003-06-20T08:19:00.000Z', '9791036049', 18, 'offline', '2021-06-21 08:20:34.951', 'Chennai', 'Mr', 'Female');
INSERT INTO public.patient_details VALUES (1, 'Ramesh Vayavuru', NULL, NULL, NULL, NULL, NULL, NULL, 'ramesh@softsuave.com', NULL, '8682866222', 1, 'Ramesh', 'Vayavuru', '1986-03-09T15:36:00.000Z', NULL, NULL, 'online', '2021-06-21 13:40:26.837', NULL, NULL, NULL);
INSERT INTO public.patient_details VALUES (40, 'John Jac', NULL, 'India', NULL, '# 36, house # 7/100, 1st street, porur', 'TamilNadu', '600116', 'loyolaprabhu@gmail.com', NULL, '9791036049', 40, 'John', 'Jac', '1985-09-24T08:11:00.000Z', '9940411049', 35, 'offline', '2021-06-21 13:55:43.364', 'Chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (39, 'sindu Chowdary', NULL, 'India', NULL, 'Madhanandapuram', 'Tamilnadu', '524201', NULL, NULL, '8568568562', 39, 'sindu', 'Chowdary', '01-01-1985', '8568568563', 36, 'offline', '2021-06-21 08:22:11.638', 'Chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (55, 'sdfxfcv xcvxcvcx', NULL, 'india', NULL, '24sfds', 'tamilnadu', '623623', 'loyolaprabhu@gmail.com', NULL, '3332221110', 55, 'sdfxfcv', 'xcvxcvcx', '1953-06-21T14:06:00.000Z', '', 68, 'offline', '2021-06-21 14:08:23.692', 'chennai', 'Mr', 'Others');
INSERT INTO public.patient_details VALUES (11, 'Sreekumar R', NULL, 'fdsafdsafdsa', NULL, 'fdasfds', 'fdasfdsafsa', '423424', 'test2345@softsuave.com', NULL, '1111111111', 11, 'Sreekumar', 'R', '2021-06-15T19:07:00.000Z', '', 0, 'offline', '2021-06-16 01:39:08.902', 'fdsadsadasf', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (12, 'sri R', NULL, 'dsafdsafsda', NULL, 'dasfdsa', 'dsafsafadsfsa', '30003', 'sri@softsuave.com', NULL, '1231231231', 13, 'sri', 'R', '1998-06-09T19:14:00.000Z', '', 23, 'online', NULL, 'fsadfdsa', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (27, 'madhu kadiyala', NULL, 'india', NULL, 'madhanandapuram', 'tamilnadu', '524201', 'madhukadiyala@gmail.com', NULL, '1471471473', 27, 'madhu', 'kadiyala', '1990-06-18T08:15:00.000Z', '1471471472', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (4, 'Ramakrishna maganti', 'softsuave', 'india', '-f54fg', 'kundranthu main road', 'tamilnadu', '524201', 'sreedhar@softsuave.com', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/icici.jpg', '1251251253', 4, 'Ramakrishna', 'maganti', '1990-06-08T16:49:00.000Z', '8885310100', 31, 'offline', '2021-06-21 13:16:49.958', 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (47, 'Prabhu D', NULL, 'India', NULL, '1st street, porur', 'TamilNadu', '600125', 'loyolaprabhu@gmail.com', NULL, '9840104658', 47, 'Prabhu', 'D', '1987-06-22T12:21:00.000Z', '9940411049', 33, 'offline', '2021-06-21 12:23:18.781', 'Chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (23, 'laxmi narahari', NULL, 'india', NULL, 'madhanadapuram', 'tamilnadu', '524201', 'sreedhar@softsuave.com', NULL, '7897897895', 23, 'laxmi', 'narahari', '2018-06-17T10:53:34.841Z', '7897897896', 3, 'offline', '2021-06-17 11:18:36.75', 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (24, 'rahul R', NULL, 'dassadsa', NULL, 'hgfhgfh', 'Virginia', '30003', 'prashanthrajendiran@softsuave.com', NULL, '3425432543', 24, 'rahul', 'R', '2021-06-17T17:28:00.000Z', '', 0, 'online', '2021-06-17 18:39:45.419', 'Atlanta', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (42, 'Arul Doss', NULL, 'india', NULL, '2342,gfd', 'TN', '600125', 'loyolaprabhu@gmail.com', NULL, '9791036050', 42, 'Arul', 'Doss', '2000-06-20T08:41:00.000Z', '9791036049', 21, 'offline', '2021-06-21 08:45:55.94', 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (51, 'Keerthi Chowdary', NULL, 'India', NULL, 'Madhanandapuram', 'Tamilnadu', '524201', NULL, NULL, '1251251259', 51, 'Keerthi', 'Chowdary', '01-01-1985', '1251251256', 36, 'offline', '2021-06-21 13:26:05.322', 'Chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (53, 'sdfdssddsfsdf sdfsdfds', NULL, 'india', NULL, 'sdfsdf', 'Tamilnadu', '612345', 'loyolaprabhu@gmail.com', NULL, '9519519510', 53, 'sdfdssddsfsdf', 'sdfsdfds', '2013-06-21T13:36:00.000Z', '', 8, 'offline', '2021-06-21 13:38:16.284', 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (13, 'sri R', NULL, 'dsafdsafsda', NULL, 'dasfdsa', 'dsafsafadsfsa', '30003', 'sri@softsuave.com', NULL, '1111111112', 12, 'sri', 'R', '1998-06-09T19:14:00.000Z', '', 23, 'online', NULL, 'fsadfdsa', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (54, 'sdfdssddsfsdf sdfsdfds', NULL, 'india', NULL, 'sdfsdf', 'Tamilnadu', '612345', 'loyolaprabhu@gmail.com', NULL, '3213213210', 54, 'sdfdssddsfsdf', 'sdfsdfds', '2013-06-21T13:42:00.000Z', '', 8, 'offline', '2021-06-21 13:43:29.118', 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (38, 'sekhar Kasi', NULL, 'India', NULL, 'Madhanandapuram', 'Tamilnadu', '524201', NULL, NULL, '8568568563', 38, 'sekhar', 'Kasi', '01-01-1985', '8568568562', 36, 'offline', '2021-06-20 09:07:01.993', 'Chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (43, 'Fio Prabhu', NULL, 'India', NULL, '36, 1st street, porur', 'Tamilnadu', '600125', 'loyolaprabhu@gmail.com', NULL, '9840981049', 43, 'Fio', 'Prabhu', '1981-06-22T08:52:00.000Z', '9791036049', 39, 'offline', '2021-06-21 08:59:58.476', 'chennai', 'Mr', 'Female');
INSERT INTO public.patient_details VALUES (49, 'Fio C', NULL, 'India', NULL, '1st street', 'Tamilnadu', '600116', 'loyolaprabhu@gmail.com', NULL, '9884618743', 49, 'Fio', 'C', '1980-06-21T12:32:00.000Z', '', 41, 'online', '2021-06-21 12:43:47.056', 'Chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (28, 'madhu kadiyala', NULL, 'india', NULL, 'madhanandapuram', 'tamilnadu', '524201', 'madhukadiyala@gmail.com', NULL, '4894894899', 28, 'madhu', 'kadiyala', '1990-06-18T08:15:00.000Z', '1471471472', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (16, 'madhu kadiyala', NULL, 'India', NULL, 'madhanandapuram', 'tamilnadu', '524201', 'sreedhar@softsuve.com', NULL, '1251251256', 16, 'madhu', 'kadiyala', '1990-03-08T11:46:00.000Z', '8885310100', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (14, 'madhu kadiyala', NULL, 'India', NULL, 'madhanandapuram', 'tamilnadu', '524201', 'sreedhar@softsuve.com', NULL, '6360254461', 14, 'madhu', 'kadiyala', '1990-03-08T11:46:00.000Z', '8885310100', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (29, 'madhu kadiyala', NULL, 'india', NULL, 'madhanandapuram', 'tamilnadu', '524201', 'madhukadiyala@gmail.com', NULL, '8885310103', 29, 'madhu', 'kadiyala', '1990-06-18T08:15:00.000Z', '1471471472', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (44, 'Fiona Prabhu', NULL, 'India', NULL, '36, 1st street, porur', 'Tamilnadu', '600125', 'loyolaprabhu@gmail.com', NULL, '9840880049', 44, 'Fiona', 'Prabhu', '1981-06-22T09:33:00.000Z', '9791036049', 39, 'offline', '2021-06-21 09:37:39.437', 'chennai', 'Mr', 'Female');
INSERT INTO public.patient_details VALUES (15, 'madhu kadiyala', NULL, 'India', NULL, 'madhanandapuram', 'tamilnadu', '524201', 'sreedhar@softsuve.com', NULL, '6360254462', 15, 'madhu', 'kadiyala', '1990-03-08T11:46:00.000Z', '8885310100', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (30, 'madhu kadiyala', NULL, 'india', NULL, 'madhanandapuram', 'tamilnadu', '524201', 'madhukadiyala@gmail.com', NULL, '9849770995', 30, 'madhu', 'kadiyala', '1990-06-18T08:15:00.000Z', '1471471472', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (45, 'Hshs Hdhdh', NULL, NULL, NULL, NULL, NULL, NULL, 'sreedhar@softsuave.com', NULL, '1234566543', 45, 'Hshs', 'Hdhdh', '2021-06-07', NULL, NULL, 'online', NULL, NULL, NULL, NULL);
INSERT INTO public.patient_details VALUES (48, 'Fiona Christine', NULL, 'India', NULL, '1st street, porur', 'TamilNadu', '600125', 'loyolaprabhu@gmail.com', NULL, '9876543210', 48, 'Fiona', 'Christine', '1988-06-21T12:25:00.000Z', '', 32, 'offline', '2021-06-21 12:27:27.239', 'Chennai', 'Mr', 'Female');
INSERT INTO public.patient_details VALUES (31, 'Testing Reddy', NULL, 'Chennai', NULL, 'Chennai', 'Chennai', '567345', 'test23@softsuave.com', NULL, '5678923456', 31, 'Testing', 'Reddy', '2009-06-18T09:17:00.000Z', '5678923455', 12, 'online', '2021-06-21 07:43:13.809', 'Chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (17, 'kiran rao', NULL, 'india', NULL, 'annaivelankini nagar', 'tamilnadu', '600116', 'kiranrao@gmail.com', NULL, '4566544566', 20, 'kiran', 'rao', '1990-06-17T07:16:00.000Z', '8885310100', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (25, 'Prabha a', NULL, 'Chennai', NULL, 'Chennai', 'Chennai', '890345', 'prasathpatient@softsuave.com', NULL, '6789012345', 25, 'Prabha', 'a', '2003-06-18T07:14:00.000Z', '6789012348', 18, 'offline', '2021-06-21 08:36:47.104', 'Chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (46, 'dgdfgh dfhdfh', NULL, NULL, NULL, NULL, NULL, NULL, 'sreedhar@softsuave.com', NULL, '1245214512', 46, 'dgdfgh', 'dfhdfh', '2019-06-21T11:45:59.646Z', NULL, NULL, 'online', NULL, NULL, NULL, NULL);
INSERT INTO public.patient_details VALUES (36, 'Laxmi Maganti', NULL, 'India', NULL, 'Madhanandapuram', 'Tamilnadu', '524201', NULL, NULL, '6360254468', 36, 'Laxmi', 'Maganti', '01-01-1986', '8885310100', 35, 'offline', '2021-06-19 13:43:07.486', 'Chennai', 'Ms', 'Female');
INSERT INTO public.patient_details VALUES (32, 'Manik A', NULL, 'Chennai', NULL, 'Chennai', 'Chennai', '600000', 'sivaji@apollo.com', NULL, '5678923458', 32, 'Manik', 'A', '2006-06-18T09:57:00.000Z', '5678923452', 15, 'offline', '2021-06-18 15:41:24.623', 'Chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (18, 'kiran rao', NULL, 'india', NULL, 'annaivelankini nagar', 'tamilnadu', '600116', 'kiranrao@gmail.com', NULL, '4566544566', 21, 'kiran', 'rao', '1990-06-17T07:16:00.000Z', '8885310100', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (7, 'Testing test', NULL, NULL, NULL, NULL, NULL, NULL, 'test@softsuave.com', NULL, '4567654567', 7, 'Testing', 'test', '2021-06-14T20:10:03.674Z', NULL, NULL, 'online', NULL, NULL, NULL, NULL);
INSERT INTO public.patient_details VALUES (19, 'kiran rao', NULL, 'india', NULL, 'annaivelankini nagar', 'tamilnadu', '600116', 'kiranrao@gmail.com', NULL, '4566544566', 22, 'kiran', 'rao', '1990-06-17T07:16:00.000Z', '8885310100', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (33, 'sdfgdg dgdf', NULL, NULL, NULL, NULL, NULL, NULL, 'dfgd@gmail.com', NULL, '8754580078', 33, 'sdfgdg', 'dgdf', '1982-06-17T10:46:00.000Z', NULL, NULL, 'online', NULL, NULL, NULL, NULL);
INSERT INTO public.patient_details VALUES (20, 'kiran rao', NULL, 'india', NULL, 'annaivelankini nagar', 'tamilnadu', '600116', 'kiranrao@gmail.com', NULL, '4566544566', 19, 'kiran', 'rao', '1990-06-17T07:16:00.000Z', '8885310100', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (8, 'Prabhu Dharmaraj', '-35434bffj', 'India', '-gdgfdg', '@36, 1st floor, ', 'TNfghfghfghfghfghfg', '987654', 'loyolaprabhu@gmail.com', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/build-product-01.jpg', '9940411049', 8, 'Prabhu', 'Dharmaraj', '1985-09-24T09:22:00.000Z', '8754580078', 35, 'offline', '2021-06-21 13:57:17.86', 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (21, 'kiran rao', NULL, 'india', NULL, 'annaivelankini nagar', 'tamilnadu', '600116', 'kiranrao@gmail.com', NULL, '4566544566', 17, 'kiran', 'rao', '1990-06-17T07:16:00.000Z', '8885310100', 31, 'online', NULL, 'chennai', 'Mr', 'Male');
INSERT INTO public.patient_details VALUES (35, 'mounika mounika', NULL, 'india', NULL, 'madhanandapuram', 'tamilnadu', '524201', 'sreedhar@softsuave.com', NULL, '1452145212', 35, 'mounika', 'mounika', '2016-06-19T12:18:00.000Z', '6360254465', 4, 'offline', '2021-06-19 15:39:51.774', 'chennai', 'Ms', 'Female');
INSERT INTO public.patient_details VALUES (9, 'Prabhu Dharmaraj', NULL, 'India', NULL, '@36, 1st floor, ', 'TN', '52420', 'loyolaprabhu@gmail.com', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/icici.jpg', '9940411049', 9, 'Prabhu', 'Dharmaraj', '1985-09-24T09:22:00.000Z', '8754580078', 35, 'online', '2021-06-15 12:54:15.41', 'chennai', 'Mr', 'Male');


--
-- TOC entry 4190 (class 0 OID 18024)
-- Dependencies: 247
-- Data for Name: patient_report; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.patient_report VALUES (1, 2, NULL, 'Report 3.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%203.pdf', 'bijdsbgijbg dfgdgdg', '2021-06-09', true);
INSERT INTO public.patient_report VALUES (2, 2, NULL, 'Report 2.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%202.pdf', 'bijdsbgijbg dfgdgdg', '2021-06-09', true);
INSERT INTO public.patient_report VALUES (3, 2, NULL, 'Report 5.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%205.pdf', 'bijdsbgijbg dfgdgdg', '2021-06-09', true);
INSERT INTO public.patient_report VALUES (4, 2, NULL, 'Report 1.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%201.pdf', 'bijdsbgijbg dfgdgdg', '2021-06-09', true);
INSERT INTO public.patient_report VALUES (5, 2, NULL, 'Report  4.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%20%204.pdf', 'bijdsbgijbg dfgdgdg', '2021-06-09', true);
INSERT INTO public.patient_report VALUES (6, 4, NULL, 'icici.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/icici.jpg', 'general health checkup', '2021-06-11', false);
INSERT INTO public.patient_report VALUES (8, 8, 42, 'icici.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/icici.jpg', 'xsdf', '2021-06-17', true);
INSERT INTO public.patient_report VALUES (9, 24, NULL, '1622906542037.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/1622906542037.jpg', ' rtqewagfsdf', '2021-06-17', true);
INSERT INTO public.patient_report VALUES (10, 24, NULL, '1622906542037.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/1622906542037.jpg', 'sfadasfsa', '2021-06-17', true);
INSERT INTO public.patient_report VALUES (11, 25, 44, 'package.json', 'application/json', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/package.json', NULL, '2021-06-18', true);
INSERT INTO public.patient_report VALUES (12, 1, NULL, 'ss-roles-2.PNG', 'image/png', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/ss-roles-2.PNG', 'Test1', '2021-06-18', true);
INSERT INTO public.patient_report VALUES (13, 1, NULL, 'action-planner-roles.PNG', 'image/png', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/action-planner-roles.PNG', 'Test 2', '2021-06-18', true);
INSERT INTO public.patient_report VALUES (14, 8, NULL, 'Playdate_Notes.txt', 'text/plain', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Playdate_Notes.txt', 'Test', '2021-06-18', true);
INSERT INTO public.patient_report VALUES (15, 8, 48, 'Virujh_addNew_admin_doctor_query.txt', 'text/plain', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Virujh_addNew_admin_doctor_query.txt', NULL, '2021-06-18', true);
INSERT INTO public.patient_report VALUES (7, 4, 27, '1621845248337.JPEG', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/1621845248337.JPEG', NULL, '2021-06-14', false);
INSERT INTO public.patient_report VALUES (19, 4, NULL, 'prescription-723.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-723.pdf', 'gere i am attaching lab reports', '2021-06-19', false);
INSERT INTO public.patient_report VALUES (18, 4, NULL, 'prescription-726.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726.pdf', 'gere i am attaching lab reports', '2021-06-19', false);
INSERT INTO public.patient_report VALUES (17, 4, NULL, 'prescription-726 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726%20%281%29.pdf', 'gere i am attaching lab reports', '2021-06-19', false);
INSERT INTO public.patient_report VALUES (16, 4, NULL, 'prescription-726 (2).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726%20%282%29.pdf', 'gere i am attaching lab reports', '2021-06-19', false);
INSERT INTO public.patient_report VALUES (20, 4, NULL, 'prescription-6 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6%20%281%29.pdf', 'hegfyhgewfre', '2021-06-19', false);
INSERT INTO public.patient_report VALUES (21, 4, NULL, 'prescription-6.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6.pdf', 'hegfyhgewfre', '2021-06-19', false);
INSERT INTO public.patient_report VALUES (22, 4, NULL, 'prescription-5.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-5.pdf', 'hegfyhgewfre', '2021-06-19', false);
INSERT INTO public.patient_report VALUES (23, 35, NULL, 'prescription-6 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6%20%281%29.pdf', NULL, '2021-06-19', true);
INSERT INTO public.patient_report VALUES (24, 35, NULL, 'prescription-5.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-5.pdf', NULL, '2021-06-19', true);
INSERT INTO public.patient_report VALUES (25, 35, NULL, 'prescription-6.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6.pdf', NULL, '2021-06-19', true);
INSERT INTO public.patient_report VALUES (26, 4, NULL, 'prescription-6 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6%20%281%29.pdf', NULL, '2021-06-19', false);
INSERT INTO public.patient_report VALUES (27, 4, NULL, 'prescription-6.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6.pdf', NULL, '2021-06-19', false);
INSERT INTO public.patient_report VALUES (28, 4, NULL, 'prescription-5.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-5.pdf', NULL, '2021-06-19', false);
INSERT INTO public.patient_report VALUES (29, 4, 0, 'image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', NULL, '2021-06-19', false);
INSERT INTO public.patient_report VALUES (30, 4, 0, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', NULL, '2021-06-19', false);
INSERT INTO public.patient_report VALUES (31, 4, 0, 'image-131cea33-50d4-4d6c-8794-28da16086867.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-131cea33-50d4-4d6c-8794-28da16086867.jpg', NULL, '2021-06-19', false);
INSERT INTO public.patient_report VALUES (32, 4, 0, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', NULL, '2021-06-19', false);
INSERT INTO public.patient_report VALUES (33, 4, 0, 'image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', NULL, '2021-06-19', false);
INSERT INTO public.patient_report VALUES (34, 4, 0, '1624115926746.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/1624115926746.jpg', NULL, '2021-06-19', false);
INSERT INTO public.patient_report VALUES (35, 4, 0, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (36, 4, 0, 'image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (37, 4, 0, 'image-131cea33-50d4-4d6c-8794-28da16086867.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-131cea33-50d4-4d6c-8794-28da16086867.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (39, 4, 0, 'image-131cea33-50d4-4d6c-8794-28da16086867.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-131cea33-50d4-4d6c-8794-28da16086867.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (76, 4, 0, 'IMG_20210621_112005.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112005.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (38, 4, 0, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (40, 4, 0, 'image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (41, 4, 0, 'image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (42, 4, 0, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (43, 4, 0, 'image-11438211-df24-4534-9692-14b87379d1e5.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-11438211-df24-4534-9692-14b87379d1e5.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (49, 4, 73, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (50, 4, 73, 'image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (51, 4, 73, 'image-11438211-df24-4534-9692-14b87379d1e5.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-11438211-df24-4534-9692-14b87379d1e5.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (52, 4, 73, 'image-17162652-ff6f-45d7-a30a-f1f543836148.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-17162652-ff6f-45d7-a30a-f1f543836148.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (47, 4, 0, 'image-11438211-df24-4534-9692-14b87379d1e5.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-11438211-df24-4534-9692-14b87379d1e5.jpg', 'Hi', '2021-06-20', false);
INSERT INTO public.patient_report VALUES (48, 4, 73, '1624178631938.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/1624178631938.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (45, 4, 0, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'Hi', '2021-06-20', false);
INSERT INTO public.patient_report VALUES (46, 4, 0, 'image-17162652-ff6f-45d7-a30a-f1f543836148.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-17162652-ff6f-45d7-a30a-f1f543836148.jpg', 'Hi', '2021-06-20', false);
INSERT INTO public.patient_report VALUES (44, 4, 0, 'image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'Hi', '2021-06-20', false);
INSERT INTO public.patient_report VALUES (53, 4, 73, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (54, 4, 73, 'image-11438211-df24-4534-9692-14b87379d1e5.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-11438211-df24-4534-9692-14b87379d1e5.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (55, 4, 73, 'image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (56, 4, 73, 'image-17162652-ff6f-45d7-a30a-f1f543836148.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-17162652-ff6f-45d7-a30a-f1f543836148.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (57, 4, 73, '1624178750479.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/1624178750479.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (58, 4, 73, '1624178760567.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/1624178760567.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (59, 4, 73, '1624178784691.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/1624178784691.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (63, 38, 0, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (64, 38, 0, 'image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (65, 38, 0, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', NULL, '2021-06-20', true);
INSERT INTO public.patient_report VALUES (66, 38, 0, 'image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-192b9f0c-d5a7-414f-bda4-12c1ec7044d2.jpg', NULL, '2021-06-20', true);
INSERT INTO public.patient_report VALUES (67, 38, 0, 'image-17162652-ff6f-45d7-a30a-f1f543836148.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-17162652-ff6f-45d7-a30a-f1f543836148.jpg', NULL, '2021-06-20', true);
INSERT INTO public.patient_report VALUES (68, 38, 0, 'image-11438211-df24-4534-9692-14b87379d1e5.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-11438211-df24-4534-9692-14b87379d1e5.jpg', NULL, '2021-06-20', true);
INSERT INTO public.patient_report VALUES (69, 38, 0, 'image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/image-c446116d-f1a7-4e81-86dc-7cd69e2b00c6.jpg', NULL, '2021-06-20', true);
INSERT INTO public.patient_report VALUES (70, 39, 0, 'file_1621968358892.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/file_1621968358892.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (71, 39, 0, 'file_1621968367523.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/file_1621968367523.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (72, 39, 0, 'file_1620327006065.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/file_1620327006065.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (73, 39, 0, 'file_1621968359358.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/file_1621968359358.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (62, 4, 73, '1624178823425.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/1624178823425.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (61, 4, 73, '1624178814197.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/1624178814197.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (60, 4, 73, '1624178803598.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/1624178803598.jpg', NULL, '2021-06-20', false);
INSERT INTO public.patient_report VALUES (74, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (75, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (77, 4, 0, 'IMG_20210621_112014.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112014.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (78, 4, 0, 'IMG_20210621_111955.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_111955.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (97, 4, 0, 'IMG_20210621_112014.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112014.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (80, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (79, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (81, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (84, 4, 0, 'IMG_20210621_112014.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112014.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (83, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (82, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (87, 4, 0, 'IMG_20210621_112014.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112014.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (86, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (85, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (91, 4, 0, 'IMG_20210621_112014.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112014.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (90, 4, 0, 'IMG_20210621_112005.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112005.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (89, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (88, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (96, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (95, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (94, 4, 0, 'IMG_20210621_112014.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112014.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (93, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (92, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (100, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (99, 4, 0, 'IMG_20210621_112014.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/IMG_20210621_112014.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (98, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (102, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (101, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (104, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (103, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (106, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (105, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (110, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (108, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (107, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (109, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (112, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (111, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (114, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (113, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (115, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (116, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (119, 4, NULL, 'prescription-5.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-5.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (118, 4, NULL, 'prescription-6 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (117, 4, NULL, 'prescription-6.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (123, 4, NULL, 'prescription-5.pdf', 'application/pdf', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/prescription-5.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (122, 4, NULL, 'prescription-6 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/prescription-6%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (121, 4, NULL, 'prescription-4 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/prescription-4%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (120, 4, NULL, 'prescription-6.pdf', 'application/pdf', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/prescription-6.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (124, 4, NULL, 'prescription-6 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (125, 4, NULL, 'prescription-5.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-5.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (126, 4, NULL, 'prescription-6.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (127, 4, NULL, 'prescription-4 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-4%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (128, 4, NULL, 'prescription-4.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-4.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (138, 4, NULL, 'prescription-723.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-723.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (131, 4, NULL, 'prescription-6.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (130, 4, NULL, 'prescription-6 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (129, 4, NULL, 'prescription-5.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-5.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (137, 4, NULL, 'prescription-726.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (132, 4, NULL, 'prescription-4 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-4%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (136, 4, NULL, 'prescription-726 (2).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726%20%282%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (135, 4, NULL, 'prescription-726 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (134, 4, NULL, 'prescription-723 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-723%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (133, 4, NULL, 'prescription-723 (2).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-723%20%282%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (142, 4, NULL, 'prescription-718.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-718.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (141, 4, NULL, 'prescription-718 (2).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-718%20%282%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (140, 4, NULL, 'prescription-718 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-718%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (139, 4, NULL, 'prescription-718 (3).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-718%20%283%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (143, 4, NULL, 'prescription-726 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (144, 4, NULL, 'prescription-726.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (145, 4, NULL, 'prescription-726 (2).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726%20%282%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (146, 4, NULL, 'prescription-723.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-723.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (147, 4, NULL, 'prescription-718 (2).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-718%20%282%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (148, 4, NULL, 'prescription-718 (3).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-718%20%283%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (149, 4, NULL, 'prescription-718.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-718.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (150, 4, NULL, 'prescription-235 (2).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-235%20%282%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (151, 4, NULL, 'prescription-237.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-237.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (157, 4, NULL, 'prescription-718 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-718%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (156, 4, NULL, 'Report 5 (5).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%205%20%285%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (155, 4, NULL, 'prescription-233.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-233.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (154, 4, NULL, 'prescription-235.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-235.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (153, 4, NULL, 'prescription-225 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-225%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (152, 4, NULL, 'prescription-235 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-235%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (161, 4, NULL, 'prescription-5.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-5.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (160, 4, NULL, 'prescription-6.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (159, 4, NULL, 'prescription-4 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-4%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (158, 4, NULL, 'prescription-6 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (162, 4, NULL, 'Report  4.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%20%204.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (163, 4, NULL, 'Report 2.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%202.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (164, 4, NULL, 'Report 3.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%203.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (165, 4, NULL, 'Report 1.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%201.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (166, 4, NULL, 'Report 5.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/Report%205.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (173, 4, NULL, 'prescription-718 (3).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-718%20%283%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (172, 4, NULL, 'prescription-726.pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (171, 4, NULL, 'prescription-723 (2).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-723%20%282%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (170, 4, NULL, 'prescription-6 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-6%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (169, 4, NULL, 'prescription-726 (2).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-726%20%282%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (168, 4, NULL, 'prescription-5 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-5%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (167, 4, NULL, 'prescription-4 (1).pdf', 'application/pdf', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/prescription-4%20%281%29.pdf', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (174, 4, 0, 'IMG_20210621_112030.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112030.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (175, 4, 0, 'IMG_20210621_112026.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/IMG_20210621_112026.jpg', NULL, '2021-06-21', false);
INSERT INTO public.patient_report VALUES (176, 4, 0, '1624280123359.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/1624280123359.jpg', NULL, '2021-06-21', true);
INSERT INTO public.patient_report VALUES (177, 4, 0, 'file_1621968367523.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/file_1621968367523.jpg', NULL, '2021-06-21', true);
INSERT INTO public.patient_report VALUES (178, 4, 0, 'file_1621968358892.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/file_1621968358892.jpg', NULL, '2021-06-21', true);
INSERT INTO public.patient_report VALUES (179, 4, 0, 'file_1621968359358.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/file_1621968359358.jpg', NULL, '2021-06-21', true);
INSERT INTO public.patient_report VALUES (180, 4, 0, 'file_1620327006065.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/file_1620327006065.jpg', NULL, '2021-06-21', true);
INSERT INTO public.patient_report VALUES (181, 4, 0, 'file_1620327001176.jpg', 'image/jpeg', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/report/file_1620327001176.jpg', NULL, '2021-06-21', true);
INSERT INTO public.patient_report VALUES (182, 51, 87, 'file_1621968367523.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/file_1621968367523.jpg', NULL, '2021-06-21', true);
INSERT INTO public.patient_report VALUES (183, 51, 87, 'file_1621968358892.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/file_1621968358892.jpg', NULL, '2021-06-21', true);
INSERT INTO public.patient_report VALUES (184, 51, 87, 'file_1621968359358.jpg', 'image/jpeg', 'https://virujh-cloud.s3.amazonaws.com/virujh/report/file_1621968359358.jpg', NULL, '2021-06-21', true);


--
-- TOC entry 4192 (class 0 OID 18033)
-- Dependencies: 249
-- Data for Name: payment_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.payment_details VALUES (1, 1, NULL, NULL, '5', 'fullyPaid');
INSERT INTO public.payment_details VALUES (2, 2, 'order_HL190ZLx3yxsZO', 'tgZUGwMUK', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (3, 3, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (4, NULL, 'order_HL1E3T95V7gv9L', '2fkrXc6FS', '1', 'notPaid');
INSERT INTO public.payment_details VALUES (5, NULL, 'order_HL1ENUPdXFyK62', 'rAHn5sueQ', '1', 'notPaid');
INSERT INTO public.payment_details VALUES (6, NULL, 'order_HL1ETIIsbHTnLY', '5gUTgCVbb', '1', 'notPaid');
INSERT INTO public.payment_details VALUES (7, 4, 'order_HL1EaS3FuANDxY', 'XjXevB-u_', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (8, 8, NULL, NULL, '0', 'fullyPaid');
INSERT INTO public.payment_details VALUES (9, 11, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (10, 12, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (11, 13, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (12, 15, 'order_HLTuuBn0zqOlQk', 'vteHFc198', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (13, 16, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (14, NULL, 'order_HLU5cIorliTPfV', 'bE3Pj8rKX', '1', 'notPaid');
INSERT INTO public.payment_details VALUES (48, 50, 'order_HOWXBSzOtZRLuE', 'TZ5ZVM_2Y', '1000', 'fullyPaid');
INSERT INTO public.payment_details VALUES (15, 17, 'order_HLU5clAWaSJeqc', 'ujsupAR5s', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (49, NULL, 'order_HOXHeLbAsFko9d', 'LoEKOX3uH', '1000', 'notPaid');
INSERT INTO public.payment_details VALUES (16, 18, 'order_HLnFmt6AMxNCz6', 'otmrScBG6', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (50, NULL, 'order_HOXHnC0vhiFNVV', 'CQEZOXUhN', '1000', 'notPaid');
INSERT INTO public.payment_details VALUES (17, 19, 'order_HLoE6nbSrv1aiW', '9KkZOnWaB', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (18, 20, NULL, NULL, '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (51, NULL, 'order_HOXI3KCbx2vbCC', 'WcJyu9qUz', '1000', 'notPaid');
INSERT INTO public.payment_details VALUES (19, 22, 'order_HMrcGyrE2Hrejx', 'TxkqTkLTD', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (52, NULL, 'order_HOXStcwMGLO8Iw', 'Z0MZWDFIu', '100', 'notPaid');
INSERT INTO public.payment_details VALUES (20, 23, 'order_HMrfm8sTLreLkf', 'iWBSAmK8B', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (53, NULL, 'order_HOXVxSB5Ic7k2A', 'la3E9ldF_', '1000', 'notPaid');
INSERT INTO public.payment_details VALUES (21, 24, 'order_HMrhBnSQ3XfPrV', '_cMv50nY3', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (54, NULL, 'order_HOXYiXthcnYoxD', 'CuxVGk_ru', '1000', 'notPaid');
INSERT INTO public.payment_details VALUES (22, 25, 'order_HMrhd1Q9Ez6A0D', 'mLLzn5hIV', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (23, 26, 'order_HMri0kEf5QvCAi', 'WKSLqsCrm', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (24, NULL, 'order_HMrlgsvqPHv8uS', 'sKVXpR2DG', '1', 'notPaid');
INSERT INTO public.payment_details VALUES (25, NULL, 'order_HMrpI7GP41AitU', 'ipWCKSp-N', '1', 'notPaid');
INSERT INTO public.payment_details VALUES (26, NULL, 'order_HMrpSahXOu1rVi', '8yszHv3Ka', '1', 'notPaid');
INSERT INTO public.payment_details VALUES (55, 52, NULL, NULL, '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (27, 29, 'order_HMrs2fAEOl7Ir7', 'twSiRxqys', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (28, 30, 'order_HMsZuZ355d7fyA', '6nOz5OkVZ', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (71, 66, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (29, 31, 'order_HMyhT7q55njTNA', 'K3pejJY4W', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (56, 53, 'order_HOtBu5lYmrkDFv', 'vp7O8nsFf', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (30, 32, 'order_HMyzwbZHO31W8E', 'AKpb7Nq7g', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (31, 33, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (32, 34, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (33, NULL, 'order_HNRAJobNSyDVTe', 'st5e20018', '100', 'notPaid');
INSERT INTO public.payment_details VALUES (34, 35, 'order_HNRAJpHVvzieDC', 'n8BjUnNiT', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (72, NULL, 'order_HOxzabxgmATfRf', 'QJYN0sLN-', '1', 'notPaid');
INSERT INTO public.payment_details VALUES (35, 36, 'order_HNRDdaR4CqlwXj', 'i2kdPdzvE', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (57, 54, 'order_HOtDfkC3IQPqza', 'fALDenZRo', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (36, 37, 'order_HNRfk03tQJdzpa', 'HEVqKEDFt', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (37, 38, 'order_HNRzrvoeFheXRH', 'LIabnTQPK', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (73, 67, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (38, 39, 'order_HNSG8olxpx83fC', 'qF2fbmA2Z', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (58, 55, 'order_HOtF0YeNuGqy6g', 'oFSCNbqCP', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (39, 40, 'order_HNSX9O4CiowAQ8', 'MXVe7ZKO3', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (40, 41, 'order_HO7QOQmLGgGi1q', 'dZMJHE9Y4', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (74, 68, NULL, NULL, '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (41, 43, 'order_HO8ea9riZCbKzA', 'YY67U6y3w', '1000', 'fullyPaid');
INSERT INTO public.payment_details VALUES (59, 56, 'order_HOulx8Kr0l5fRb', 'scOLPRI8O', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (42, 44, 'order_HORIRvUgwoRRKQ', 'olki_udKJ', '10', 'fullyPaid');
INSERT INTO public.payment_details VALUES (43, 45, 'order_HOS9bOJot5Iu1y', '8B86YQcHF', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (44, 46, NULL, NULL, '1000', 'fullyPaid');
INSERT INTO public.payment_details VALUES (45, 47, NULL, NULL, '1000', 'fullyPaid');
INSERT INTO public.payment_details VALUES (46, 48, NULL, NULL, '1000', 'fullyPaid');
INSERT INTO public.payment_details VALUES (75, 69, NULL, NULL, '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (47, 49, 'order_HOWS0N6Ut6F8Ze', 'qW36HGPT6', '1000', 'fullyPaid');
INSERT INTO public.payment_details VALUES (60, 57, 'order_HOvBFWmYU34AQC', 'WQ91GwhAL', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (61, 58, 'order_HOvZeMnykpBevW', 'rChiRF0GR', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (62, NULL, 'order_HOvpUNZNQ3b6VM', 'jdlZk1nS0J', '100', 'notPaid');
INSERT INTO public.payment_details VALUES (63, NULL, 'order_HOvpUhKrWPFAeY', 'qTQephTi-2', '100', 'notPaid');
INSERT INTO public.payment_details VALUES (64, NULL, 'order_HOvpV0gWPmVFMj', '1yhCNN46LB', '100', 'notPaid');
INSERT INTO public.payment_details VALUES (65, NULL, 'order_HOvpVNHOxoxxPG', 'DQdbrRGgg', '100', 'notPaid');
INSERT INTO public.payment_details VALUES (66, 59, 'order_HOvptmUlfXVi0q', 'dyRqbSGLs', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (76, 70, 'order_HOyBFUqxrm4AEN', 'EZba6hnzS', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (67, 60, 'order_HOvuDKB2so4MU7', 'GpYAIawZK', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (68, 61, 'order_HOx3xEBd6Eyraw', 'dISQ3dkYz', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (69, 62, 'order_HOxmBDP2Q7rKFz', 'sCM9pMGI6', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (70, 64, 'order_HOxoc8m4eIshoF', 'gn4ziBG8v', '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (77, 77, 'order_HPaXu3NpkjYAEp', 'oSbmtEwI0', '100', 'fullyPaid');
INSERT INTO public.payment_details VALUES (78, NULL, 'order_HPdBvJyoeJTvGC', 'qwcUNR_RL', '100', 'notPaid');
INSERT INTO public.payment_details VALUES (79, 80, NULL, NULL, '0', 'fullyPaid');
INSERT INTO public.payment_details VALUES (80, 81, NULL, NULL, '0', 'fullyPaid');
INSERT INTO public.payment_details VALUES (81, 84, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (82, 85, NULL, NULL, '1', 'fullyPaid');
INSERT INTO public.payment_details VALUES (83, 86, NULL, NULL, '1', 'fullyPaid');


--
-- TOC entry 4194 (class 0 OID 18042)
-- Dependencies: 251
-- Data for Name: prescription; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.prescription VALUES (1, 4, '2021-06-09', NULL, 'Lamfer healthcare', 'Dr. Chenthil Perumal', NULL, 'sreedhar maganti', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/sreedhar%20maganti/prescription/prescription-1.pdf', 'All good', 'null, null, null, null, null', 'Fever');
INSERT INTO public.prescription VALUES (2, 33, '2021-06-14', NULL, 'kalyani hospitals', 'Dr. Sreedhar Maganti', NULL, 'Ramakrishna maganti', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramakrishna%20maganti/prescription/prescription-2.pdf', 'Good', 'null, null, null, null, 600000', 'Fever');
INSERT INTO public.prescription VALUES (3, 40, '2021-06-16', NULL, 'Lamfer healthcare', 'Dr. Chenthil Perumal', NULL, 'Ramesh Vayavuru', 'https://virujh-cloud.s3.amazonaws.com/virujh/Ramesh%20Vayavuru/prescription/prescription-3.pdf', '34566sdfgfsdgdfgfdg', 'null, null, null, null, null', 'testing 1234gfdsgfsdg');
INSERT INTO public.prescription VALUES (4, 45, '2021-06-18', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', 'https://virujh-cloud.s3.amazonaws.com/virujh/Prabha%20a/prescription/prescription-4.pdf', 'mnnnnnnnnnnvnbvhgchgchhhhhhhhhhhhhhh', 'null, null, null, null, 600000', 'mnvjhvhvjjjjjjjjjjjjj vjhvhycytdtydtrdtrdtdtydt');
INSERT INTO public.prescription VALUES (5, 53, '2021-06-19', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', 'kalyani hospitals', 'Dr. Sreedhar Maganti', NULL, 'Ramakrishna maganti', 'https://virujh-cloud.s3.amazonaws.com/virujh/Ramakrishna%20maganti/prescription/prescription-5.pdf', 'fghfgh nshdsgh gndbgid ggbdg dgd g dgudg gdghvgdsr 7rtvb gdsg vdgb dfughvg dfgdfgdfgdfgdfgdfg fghfgh nshdsgh gndbgid ggbdg dgd g dgudg gdghvgdsr 7rtvb gdsg vdgb ', 'null, null, null, null, 600000', 'fghfgh nshdsgh gndbgid ggbdg dgd g dgudg gdghvgdsr 7rtvb gdsg vdgb dfughvg dfgdfgdfgdfgdfgdfg fghfgh nshdsgh gndbgid ggbdg dgd g dgudg gdghvgdsr 7rtvb gdsg vdgb dfughvg dfgdfgdfgdfgdfgdfg fghfgh nshdsgh gndbgid ggbdg dgd g dgudg gdghvgdsr 7rtvb ');
INSERT INTO public.prescription VALUES (6, 55, '2021-06-19', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', 'kalyani hospitals', 'Dr. Sreedhar Maganti', NULL, 'Ramakrishna maganti', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramakrishna%20maganti/prescription/prescription-6.pdf', 'sreedhar maganti softsuave', 'null, null, null, null, 600000', 'hjghjghjgh fuygytu tuytruytryr');
INSERT INTO public.prescription VALUES (7, 70, '2021-06-19', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', 'kalyani hospitals', 'Dr. Sreedhar Maganti', NULL, 'mounika mounika', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/mounika%20mounika/prescription/prescription-7.pdf', NULL, 'null, null, null, null, 600000', NULL);
INSERT INTO public.prescription VALUES (8, 67, '2021-06-19', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', 'kalyani hospitals', 'Dr. Sreedhar Maganti', NULL, 'Ramakrishna maganti', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramakrishna%20maganti/prescription/prescription-8.pdf', NULL, 'null, null, null, null, 600000', NULL);
INSERT INTO public.prescription VALUES (9, 67, '2021-06-19', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', 'kalyani hospitals', 'Dr. Sreedhar Maganti', NULL, 'Ramakrishna maganti', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramakrishna%20maganti/prescription/prescription-9.pdf', NULL, 'null, null, null, null, 600000', NULL);
INSERT INTO public.prescription VALUES (10, 73, '2021-06-20', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', 'kalyani hospitals', 'Dr. Sreedhar Maganti', NULL, 'Ramakrishna maganti', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramakrishna%20maganti/prescription/prescription-10.pdf', NULL, 'null, null, null, null, 600000', NULL);
INSERT INTO public.prescription VALUES (11, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', 'https://virujh-cloud.s3.amazonaws.com/virujh/Prabha%20a/prescription/prescription-11.pdf', 'jkgkjbj jkbkbkbkb', 'null, null, null, null, 600000', 'kgkgkj kbjbjv');
INSERT INTO public.prescription VALUES (12, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', 'https://virujh-cloud.s3.amazonaws.com/virujh/Prabha%20a/prescription/prescription-12.pdf', 'take medicine', 'null, null, null, null, 600000', 'Problems');
INSERT INTO public.prescription VALUES (13, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Prabha%20a/prescription/prescription-13.pdf', 'take medicine', 'null, null, null, null, 600000', 'Problems');
INSERT INTO public.prescription VALUES (14, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', NULL, 'take medicine', 'null, null, null, null, 600000', 'Problems');
INSERT INTO public.prescription VALUES (15, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', 'https://virujh-cloud.s3.amazonaws.com/virujh/Prabha%20a/prescription/prescription-15.pdf', 'take medicine', 'null, null, null, null, 600000', 'Problems');
INSERT INTO public.prescription VALUES (16, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Prabha%20a/prescription/prescription-16.pdf', 'take medicine', 'null, null, null, null, 600000', 'Problems');
INSERT INTO public.prescription VALUES (17, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', 'https://virujh-cloud.s3.amazonaws.com/virujh/Prabha%20a/prescription/prescription-17.pdf', 'take medicine', 'null, null, null, null, 600000', 'Problems');
INSERT INTO public.prescription VALUES (18, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Prabha%20a/prescription/prescription-18.pdf', 'take medicine', 'null, null, null, null, 600000', 'Problems');
INSERT INTO public.prescription VALUES (20, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', NULL, 'take medicine', 'null, null, null, null, 600000', 'Problems');
INSERT INTO public.prescription VALUES (19, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', 'https://virujh-cloud.s3.amazonaws.com/virujh/Prabha%20a/prescription/prescription-19.pdf', 'take medicine', '600000', 'Problems');
INSERT INTO public.prescription VALUES (21, 76, '2021-06-21', NULL, 'Deactivated Clinic', 'Dr. Prashath a', NULL, 'Prabha a', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Prabha%20a/prescription/prescription-21.pdf', 'take medicine', '600000', 'Problems');
INSERT INTO public.prescription VALUES (22, 79, '2021-06-21', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', 'kalyani hospitals', 'Dr. Sreedhar Maganti', NULL, 'Ramakrishna maganti', 'https://virujh-cloud.s3.amazonaws.com/virujh/Ramakrishna%20maganti/prescription/prescription-22.pdf', NULL, '600000', NULL);
INSERT INTO public.prescription VALUES (23, 83, '2021-06-21', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', 'kalyani hospitals', 'Dr. Sreedhar Maganti', NULL, 'Ramakrishna maganti', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramakrishna%20maganti/prescription/prescription-23.pdf', 'hfhfghfgh fhfhy  bjdgfiujdg nbdhbgd gnbgid gndbfigbfgdgf ', '600000', 'hfhfghfgh fhfhy  bjdgfiujdg nbdhbgd gnbgid gndbfigbfgdgf ');
INSERT INTO public.prescription VALUES (24, 86, '2021-06-21', NULL, 'Lamfer healthcare', 'Dr. Chenthil Perumal', NULL, 'Ramesh Vayavuru', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramesh%20Vayavuru/prescription/prescription-24.pdf', 'Test', NULL, 'Test');
INSERT INTO public.prescription VALUES (25, 83, '2021-06-21', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/files/profile.785e2362.png', 'kalyani hospitals', 'Dr. Sreedhar Maganti', NULL, 'Ramakrishna maganti', 'https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramakrishna%20maganti/prescription/prescription-25.pdf', NULL, '600000', NULL);


--
-- TOC entry 4196 (class 0 OID 18050)
-- Dependencies: 253
-- Data for Name: tabesample; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4198 (class 0 OID 18055)
-- Dependencies: 255
-- Data for Name: work_schedule_day; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4200 (class 0 OID 18060)
-- Dependencies: 257
-- Data for Name: work_schedule_interval; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4238 (class 0 OID 0)
-- Dependencies: 203
-- Name: account_details_account_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_details_account_details_id_seq', 1, false);


--
-- TOC entry 4239 (class 0 OID 0)
-- Dependencies: 207
-- Name: appointment_cancel_reschedule_appointment_cancel_reschedule_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq', 1, false);


--
-- TOC entry 4240 (class 0 OID 0)
-- Dependencies: 209
-- Name: appointment_doc_config_appointment_doc_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_doc_config_appointment_doc_config_id_seq', 87, true);


--
-- TOC entry 4241 (class 0 OID 0)
-- Dependencies: 210
-- Name: appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_id_seq', 87, true);


--
-- TOC entry 4242 (class 0 OID 0)
-- Dependencies: 211
-- Name: appointment_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_seq', 17, true);


--
-- TOC entry 4243 (class 0 OID 0)
-- Dependencies: 213
-- Name: communication_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.communication_type_id_seq', 1, true);


--
-- TOC entry 4244 (class 0 OID 0)
-- Dependencies: 216
-- Name: doc_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_can_resch_doc_config_can_resch_id_seq', 1, false);


--
-- TOC entry 4245 (class 0 OID 0)
-- Dependencies: 218
-- Name: doc_config_schedule_day_doc_config_schedule_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq', 273, true);


--
-- TOC entry 4246 (class 0 OID 0)
-- Dependencies: 220
-- Name: doc_config_schedule_interval_doc_config_schedule_interval_i_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq', 197, true);


--
-- TOC entry 4247 (class 0 OID 0)
-- Dependencies: 221
-- Name: docconfigid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.docconfigid_seq', 39, true);


--
-- TOC entry 4248 (class 0 OID 0)
-- Dependencies: 223
-- Name: doctor_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_can_resch_doc_config_can_resch_id_seq', 1, false);


--
-- TOC entry 4249 (class 0 OID 0)
-- Dependencies: 225
-- Name: doctor_config_pre_consultation_doctor_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_pre_consultation_doctor_config_id_seq', 1, false);


--
-- TOC entry 4250 (class 0 OID 0)
-- Dependencies: 226
-- Name: doctor_config_preconsultation_doctor_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_preconsultation_doctor_config_id_seq', 1, false);


--
-- TOC entry 4251 (class 0 OID 0)
-- Dependencies: 227
-- Name: doctor_details_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_details_doctor_id_seq', 54, true);


--
-- TOC entry 4252 (class 0 OID 0)
-- Dependencies: 228
-- Name: doctor_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_doctor_id_seq', 48, true);


--
-- TOC entry 4253 (class 0 OID 0)
-- Dependencies: 230
-- Name: interval_days_interval_days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interval_days_interval_days_id_seq', 1, false);


--
-- TOC entry 4254 (class 0 OID 0)
-- Dependencies: 232
-- Name: medicine_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medicine_id_seq', 47, true);


--
-- TOC entry 4255 (class 0 OID 0)
-- Dependencies: 234
-- Name: message_metadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_metadata_id_seq', 1, false);


--
-- TOC entry 4256 (class 0 OID 0)
-- Dependencies: 236
-- Name: message_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_template_id_seq', 1, false);


--
-- TOC entry 4257 (class 0 OID 0)
-- Dependencies: 238
-- Name: message_template_placeholders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_template_placeholders_id_seq', 1, false);


--
-- TOC entry 4258 (class 0 OID 0)
-- Dependencies: 240
-- Name: message_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_type_id_seq', 1, false);


--
-- TOC entry 4259 (class 0 OID 0)
-- Dependencies: 242
-- Name: openvidu_session_openvidu_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.openvidu_session_openvidu_session_id_seq', 792, true);


--
-- TOC entry 4260 (class 0 OID 0)
-- Dependencies: 244
-- Name: openvidu_session_token_openvidu_session_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.openvidu_session_token_openvidu_session_token_id_seq', 873, true);


--
-- TOC entry 4261 (class 0 OID 0)
-- Dependencies: 246
-- Name: patient_details_patient_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_details_patient_details_id_seq', 55, true);


--
-- TOC entry 4262 (class 0 OID 0)
-- Dependencies: 248
-- Name: patient_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_report_id_seq', 184, true);


--
-- TOC entry 4263 (class 0 OID 0)
-- Dependencies: 250
-- Name: payment_details_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_details_payment_id_seq', 83, true);


--
-- TOC entry 4264 (class 0 OID 0)
-- Dependencies: 252
-- Name: prescription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prescription_id_seq', 25, true);


--
-- TOC entry 4265 (class 0 OID 0)
-- Dependencies: 254
-- Name: tabesample_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tabesample_id_seq', 1, false);


--
-- TOC entry 4266 (class 0 OID 0)
-- Dependencies: 256
-- Name: work_schedule_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_schedule_day_id_seq', 1, false);


--
-- TOC entry 4267 (class 0 OID 0)
-- Dependencies: 258
-- Name: work_schedule_interval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_schedule_interval_id_seq', 1, false);


--
-- TOC entry 3936 (class 2606 OID 18093)
-- Name: account_details account_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_details_pkey PRIMARY KEY (account_details_id);


--
-- TOC entry 3938 (class 2606 OID 18095)
-- Name: account_details account_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_key_unique UNIQUE (account_key);


--
-- TOC entry 3940 (class 2606 OID 18097)
-- Name: advertisement advertisement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisement
    ADD CONSTRAINT advertisement_pkey PRIMARY KEY (id);


--
-- TOC entry 3944 (class 2606 OID 18099)
-- Name: appointment_cancel_reschedule appointment_cancel_reschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT appointment_cancel_reschedule_pkey PRIMARY KEY (appointment_cancel_reschedule_id);


--
-- TOC entry 3947 (class 2606 OID 18101)
-- Name: appointment_doc_config appointment_doc_config_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT appointment_doc_config_id PRIMARY KEY (appointment_doc_config_id);


--
-- TOC entry 3942 (class 2606 OID 18103)
-- Name: appointment appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (id);


--
-- TOC entry 3950 (class 2606 OID 18105)
-- Name: communication_type communication_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.communication_type
    ADD CONSTRAINT communication_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3954 (class 2606 OID 18107)
-- Name: doctor_config_can_resch doc_config_can_resch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_can_resch
    ADD CONSTRAINT doc_config_can_resch_pkey PRIMARY KEY (doc_config_can_resch_id);


--
-- TOC entry 3952 (class 2606 OID 18109)
-- Name: doc_config doc_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doc_config_pkey PRIMARY KEY (id);


--
-- TOC entry 3956 (class 2606 OID 18111)
-- Name: doc_config_schedule_day doc_config_schedule_day_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_config_schedule_day_id PRIMARY KEY (id);


--
-- TOC entry 3959 (class 2606 OID 18113)
-- Name: doc_config_schedule_interval doc_config_schedule_interval_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_config_schedule_interval_id PRIMARY KEY (id);


--
-- TOC entry 3968 (class 2606 OID 18115)
-- Name: doctor_config_pre_consultation doctor_config_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_pre_consultation
    ADD CONSTRAINT doctor_config_id PRIMARY KEY (doctor_config_id);


--
-- TOC entry 3963 (class 2606 OID 18117)
-- Name: doctor doctor_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_id PRIMARY KEY ("doctorId");


--
-- TOC entry 3965 (class 2606 OID 18119)
-- Name: doctor doctor_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_key_unique UNIQUE (doctor_key);


--
-- TOC entry 3972 (class 2606 OID 18121)
-- Name: interval_days interval_days_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interval_days
    ADD CONSTRAINT interval_days_id PRIMARY KEY (interval_days_id);


--
-- TOC entry 3974 (class 2606 OID 18123)
-- Name: medicine medicine_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine
    ADD CONSTRAINT medicine_pkey PRIMARY KEY (id);


--
-- TOC entry 3976 (class 2606 OID 18125)
-- Name: message_metadata message_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_metadata_pkey PRIMARY KEY (id);


--
-- TOC entry 3978 (class 2606 OID 18127)
-- Name: message_template message_template_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template
    ADD CONSTRAINT message_template_pkey PRIMARY KEY (id);


--
-- TOC entry 3980 (class 2606 OID 18129)
-- Name: message_template_placeholders message_template_placeholders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_template_placeholders_pkey PRIMARY KEY (id);


--
-- TOC entry 3982 (class 2606 OID 18131)
-- Name: message_type message_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_type
    ADD CONSTRAINT message_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3984 (class 2606 OID 18133)
-- Name: openvidu_session openvidu_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session
    ADD CONSTRAINT openvidu_session_pkey PRIMARY KEY (openvidu_session_id);


--
-- TOC entry 3986 (class 2606 OID 18135)
-- Name: openvidu_session_token openvidu_session_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session_token
    ADD CONSTRAINT openvidu_session_token_pkey PRIMARY KEY (openvidu_session_token_id);


--
-- TOC entry 3988 (class 2606 OID 18137)
-- Name: patient_details patient_details_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_details
    ADD CONSTRAINT patient_details_id PRIMARY KEY (id);


--
-- TOC entry 3990 (class 2606 OID 18139)
-- Name: patient_report patient_report_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_report
    ADD CONSTRAINT patient_report_id PRIMARY KEY (id);


--
-- TOC entry 3993 (class 2606 OID 18141)
-- Name: payment_details payment_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_id PRIMARY KEY (id);


--
-- TOC entry 3995 (class 2606 OID 18143)
-- Name: prescription prescriptionId; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescription
    ADD CONSTRAINT "prescriptionId" UNIQUE (id) INCLUDE (id);


--
-- TOC entry 3997 (class 2606 OID 18145)
-- Name: tabesample tabesample_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabesample
    ADD CONSTRAINT tabesample_pkey PRIMARY KEY (id);


--
-- TOC entry 3999 (class 2606 OID 18147)
-- Name: work_schedule_day work_schedule_day_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_day
    ADD CONSTRAINT work_schedule_day_pkey PRIMARY KEY (id);


--
-- TOC entry 4002 (class 2606 OID 18149)
-- Name: work_schedule_interval work_schedule_interval_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT work_schedule_interval_pkey PRIMARY KEY (id);


--
-- TOC entry 3948 (class 1259 OID 18150)
-- Name: fki_app_doc_con_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_app_doc_con_to_app_id ON public.appointment_doc_config USING btree (appointment_id);


--
-- TOC entry 3945 (class 1259 OID 18151)
-- Name: fki_can_resch_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_can_resch_to_app_id ON public.appointment_cancel_reschedule USING btree (appointment_id);


--
-- TOC entry 3969 (class 1259 OID 18152)
-- Name: fki_doc_config_to_doc_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doc_config_to_doc_key ON public.doctor_config_pre_consultation USING btree (doctor_key);


--
-- TOC entry 3957 (class 1259 OID 18153)
-- Name: fki_doc_sched_to_doc_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doc_sched_to_doc_id ON public.doc_config_schedule_day USING btree (doctor_id);


--
-- TOC entry 3966 (class 1259 OID 18154)
-- Name: fki_doctor_to_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doctor_to_account ON public.doctor USING btree (account_key);


--
-- TOC entry 3970 (class 1259 OID 18155)
-- Name: fki_int_days_to_wrk_sched_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_int_days_to_wrk_sched_id ON public.interval_days USING btree (wrk_sched_id);


--
-- TOC entry 3960 (class 1259 OID 18156)
-- Name: fki_interval_to_wrk_sched_con_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_interval_to_wrk_sched_con_id ON public.doc_config_schedule_interval USING btree ("docConfigScheduleDayId");


--
-- TOC entry 3961 (class 1259 OID 18157)
-- Name: fki_interval_to_wrk_sched_config_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_interval_to_wrk_sched_config_id ON public.doc_config_schedule_interval USING btree ("docConfigScheduleDayId");


--
-- TOC entry 3991 (class 1259 OID 18158)
-- Name: fki_payment_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_payment_to_app_id ON public.payment_details USING btree (appointment_id);


--
-- TOC entry 4000 (class 1259 OID 18159)
-- Name: fki_workScheduleIntervalToDay; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_workScheduleIntervalToDay" ON public.work_schedule_interval USING btree (work_schedule_day_id);


--
-- TOC entry 4004 (class 2606 OID 18160)
-- Name: appointment_doc_config app_doc_con_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT app_doc_con_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- TOC entry 4017 (class 2606 OID 18165)
-- Name: prescription appointmentId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescription
    ADD CONSTRAINT "appointmentId" FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- TOC entry 4003 (class 2606 OID 18170)
-- Name: appointment_cancel_reschedule can_resch_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT can_resch_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- TOC entry 4010 (class 2606 OID 18175)
-- Name: message_metadata communication_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT communication_type_id FOREIGN KEY (communication_type_id) REFERENCES public.communication_type(id);


--
-- TOC entry 4007 (class 2606 OID 18180)
-- Name: doc_config_schedule_interval doc_sched_interval_to_day; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_sched_interval_to_day FOREIGN KEY ("docConfigScheduleDayId") REFERENCES public.doc_config_schedule_day(id) NOT VALID;


--
-- TOC entry 4006 (class 2606 OID 18185)
-- Name: doc_config_schedule_day doc_sched_to_doc_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_sched_to_doc_id FOREIGN KEY (doctor_id) REFERENCES public.doctor("doctorId") NOT VALID;


--
-- TOC entry 4005 (class 2606 OID 18190)
-- Name: doc_config doctor_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doctor_key FOREIGN KEY (doctor_key) REFERENCES public.doctor(doctor_key);


--
-- TOC entry 4008 (class 2606 OID 18195)
-- Name: doctor doctor_to_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_to_account FOREIGN KEY (account_key) REFERENCES public.account_details(account_key);


--
-- TOC entry 4013 (class 2606 OID 18200)
-- Name: message_template_placeholders message_template_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_template_id FOREIGN KEY (message_template_id) REFERENCES public.message_template(id);


--
-- TOC entry 4011 (class 2606 OID 18205)
-- Name: message_metadata message_template_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_template_id FOREIGN KEY (message_template_id) REFERENCES public.message_template(id);


--
-- TOC entry 4014 (class 2606 OID 18210)
-- Name: message_template_placeholders message_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_type_id FOREIGN KEY (message_type_id) REFERENCES public.message_type(id);


--
-- TOC entry 4012 (class 2606 OID 18215)
-- Name: message_metadata message_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_type_id FOREIGN KEY (message_type_id) REFERENCES public.message_type(id);


--
-- TOC entry 4015 (class 2606 OID 18220)
-- Name: openvidu_session_token openvidu_session_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session_token
    ADD CONSTRAINT openvidu_session_id FOREIGN KEY (openvidu_session_id) REFERENCES public.openvidu_session(openvidu_session_id);


--
-- TOC entry 4016 (class 2606 OID 18225)
-- Name: payment_details payment_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- TOC entry 4009 (class 2606 OID 18230)
-- Name: medicine prescription_id_medicine; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine
    ADD CONSTRAINT prescription_id_medicine FOREIGN KEY (prescription_id) REFERENCES public.prescription(id);


--
-- TOC entry 4018 (class 2606 OID 18235)
-- Name: work_schedule_interval workScheduleIntervalToDay; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT "workScheduleIntervalToDay" FOREIGN KEY (work_schedule_day_id) REFERENCES public.work_schedule_day(id) NOT VALID;


--
-- TOC entry 4207 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2021-06-21 20:02:06

--
-- PostgreSQL database dump complete
--


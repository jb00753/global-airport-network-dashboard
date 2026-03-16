--
-- PostgreSQL database dump
--

\restrict EyaPe2tnvJ958DuASvpRVUMfvaqObNFdxZapbbYebQidRlDhdokqhwv0Far6oId

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-03-15 22:26:00

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
-- TOC entry 225 (class 1259 OID 16734)
-- Name: airlines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airlines (
    airline_id integer NOT NULL,
    name character varying(255) NOT NULL,
    alias character varying(100),
    iata character(2),
    icao character(3),
    callsign character varying(50),
    country character varying(100),
    active boolean NOT NULL,
    CONSTRAINT valid_iata_length CHECK (((iata IS NULL) OR (length(iata) = 2))),
    CONSTRAINT valid_icao_length CHECK (((icao IS NULL) OR (length(icao) = 3)))
);


ALTER TABLE public.airlines OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16673)
-- Name: airports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airports (
    airport_id integer NOT NULL,
    name character varying(255) NOT NULL,
    city character varying(100),
    country character varying(100) NOT NULL,
    iata character(3),
    icao character varying(5) NOT NULL,
    latitude numeric(10,6) NOT NULL,
    longitude numeric(10,6) NOT NULL,
    altitude integer,
    timezone_offset numeric(4,1),
    dst character(1),
    tz_database_timezone character varying(50),
    source character varying(20),
    CONSTRAINT valid_iata_length CHECK (((iata IS NULL) OR (length(iata) = 3))),
    CONSTRAINT valid_icao_length CHECK (((length(TRIM(BOTH FROM icao)) >= 3) AND (length(TRIM(BOTH FROM icao)) <= 5))),
    CONSTRAINT valid_latitude CHECK (((latitude >= ('-90'::integer)::numeric) AND (latitude <= (90)::numeric))),
    CONSTRAINT valid_longitude CHECK (((longitude >= ('-180'::integer)::numeric) AND (longitude <= (180)::numeric)))
);


ALTER TABLE public.airports OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16749)
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    iso_code character(2) NOT NULL,
    name character varying(100) NOT NULL,
    dafif_code character(2),
    CONSTRAINT valid_iso_length CHECK ((length(iso_code) = 2))
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16777)
-- Name: planes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.planes (
    icao_code character(4) NOT NULL,
    name character varying(100) NOT NULL,
    iata_code character(4),
    CONSTRAINT valid_iata_length CHECK (((iata_code IS NULL) OR ((length(iata_code) >= 3) AND (length(iata_code) <= 4)))),
    CONSTRAINT valid_icao_length CHECK (((length(icao_code) >= 3) AND (length(icao_code) <= 4)))
);


ALTER TABLE public.planes OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16809)
-- Name: routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routes (
    route_id integer NOT NULL,
    airline_id integer NOT NULL,
    source_airport_id integer NOT NULL,
    destination_airport_id integer NOT NULL,
    codeshare character varying(10),
    stops integer DEFAULT 0 NOT NULL,
    equipment text,
    CONSTRAINT different_airports CHECK ((source_airport_id <> destination_airport_id)),
    CONSTRAINT valid_stops CHECK ((stops >= 0))
);


ALTER TABLE public.routes OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16808)
-- Name: routes_route_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.routes_route_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.routes_route_id_seq OWNER TO postgres;

--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 228
-- Name: routes_route_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.routes_route_id_seq OWNED BY public.routes.route_id;


--
-- TOC entry 221 (class 1259 OID 16702)
-- Name: staging_airlines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staging_airlines (
    airline_id integer NOT NULL,
    name text,
    alias text,
    iata text,
    icao text,
    callsign text,
    country text,
    active text
);


ALTER TABLE public.staging_airlines OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16620)
-- Name: staging_airports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staging_airports (
    airport_id text,
    name text,
    city text,
    country text,
    iata text,
    icao text,
    latitude text,
    longitude text,
    altitude text,
    timezone_offset text,
    dst text,
    tz_database_timezone text,
    airport_type text,
    source text
);


ALTER TABLE public.staging_airports OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16729)
-- Name: staging_countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staging_countries (
    name text,
    iso_code text,
    dafif_code text
);


ALTER TABLE public.staging_countries OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16720)
-- Name: staging_planes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staging_planes (
    name text,
    iata text,
    icao text
);


ALTER TABLE public.staging_planes OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16715)
-- Name: staging_routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staging_routes (
    airline text,
    airline_id text,
    source_airport text,
    source_airport_id text,
    destination_airport text,
    destination_airport_id text,
    codeshare text,
    stops text,
    equipment text
);


ALTER TABLE public.staging_routes OWNER TO postgres;

--
-- TOC entry 4892 (class 2604 OID 16812)
-- Name: routes route_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes ALTER COLUMN route_id SET DEFAULT nextval('public.routes_route_id_seq'::regclass);


--
-- TOC entry 4910 (class 2606 OID 16745)
-- Name: airlines airlines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_pkey PRIMARY KEY (airline_id);


--
-- TOC entry 4906 (class 2606 OID 16689)
-- Name: airports airports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airports
    ADD CONSTRAINT airports_pkey PRIMARY KEY (airport_id);


--
-- TOC entry 4912 (class 2606 OID 16756)
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (iso_code);


--
-- TOC entry 4916 (class 2606 OID 16785)
-- Name: planes planes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planes
    ADD CONSTRAINT planes_pkey PRIMARY KEY (icao_code);


--
-- TOC entry 4922 (class 2606 OID 16824)
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (route_id);


--
-- TOC entry 4908 (class 2606 OID 16709)
-- Name: staging_airlines staging_airlines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staging_airlines
    ADD CONSTRAINT staging_airlines_pkey PRIMARY KEY (airline_id);


--
-- TOC entry 4914 (class 2606 OID 16758)
-- Name: countries unique_country_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT unique_country_name UNIQUE (name);


--
-- TOC entry 4917 (class 1259 OID 16840)
-- Name: idx_routes_airline; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_routes_airline ON public.routes USING btree (airline_id);


--
-- TOC entry 4918 (class 1259 OID 16842)
-- Name: idx_routes_dest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_routes_dest ON public.routes USING btree (destination_airport_id);


--
-- TOC entry 4919 (class 1259 OID 16841)
-- Name: idx_routes_source; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_routes_source ON public.routes USING btree (source_airport_id);


--
-- TOC entry 4920 (class 1259 OID 16843)
-- Name: idx_routes_source_dest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_routes_source_dest ON public.routes USING btree (source_airport_id, destination_airport_id);


--
-- TOC entry 4923 (class 2606 OID 16825)
-- Name: routes routes_airline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_airline_id_fkey FOREIGN KEY (airline_id) REFERENCES public.airlines(airline_id) ON DELETE CASCADE;


--
-- TOC entry 4924 (class 2606 OID 16835)
-- Name: routes routes_destination_airport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_destination_airport_id_fkey FOREIGN KEY (destination_airport_id) REFERENCES public.airports(airport_id) ON DELETE CASCADE;


--
-- TOC entry 4925 (class 2606 OID 16830)
-- Name: routes routes_source_airport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_source_airport_id_fkey FOREIGN KEY (source_airport_id) REFERENCES public.airports(airport_id) ON DELETE CASCADE;


-- Completed on 2026-03-15 22:26:00

--
-- PostgreSQL database dump complete
--

\unrestrict EyaPe2tnvJ958DuASvpRVUMfvaqObNFdxZapbbYebQidRlDhdokqhwv0Far6oId


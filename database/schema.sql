--
-- PostgreSQL database dump
--

\restrict SF7kKPM8dYWzUgB3hUOR4kZLgShvf2XDH8siTaAGKOGnColOpZXYNf91zUvjN1M

-- Dumped from database version 18.7
-- Dumped by pg_dump version 18.7

-- Started on 2026-11-15 17:13:18

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

--
-- TOC entry 2 (class 3079 OID 16390)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 5944 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- TOC entry 1680 (class 1247 OID 17517)
-- Name: destination_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.destination_status AS ENUM (
    'draft',
    'pending',
    'approved',
    'rejected'
);


ALTER TYPE public.destination_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 17565)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    slug character varying(60) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17564)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO postgres;

--
-- TOC entry 5945 (class 0 OID 0)
-- Dependencies: 229
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- TOC entry 233 (class 1259 OID 17600)
-- Name: destinations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.destinations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(200) NOT NULL,
    slug character varying(250) NOT NULL,
    province_id integer NOT NULL,
    regency_id integer NOT NULL,
    district_id integer,
    category_id integer NOT NULL,
    subcategory_id integer,
    coordinates public.geometry(Point,4326) NOT NULL,
    latitude double precision GENERATED ALWAYS AS (public.st_y(coordinates)) STORED,
    longitude double precision GENERATED ALWAYS AS (public.st_x(coordinates)) STORED,
    address text,
    description text,
    facilities jsonb,
    operating_hours jsonb,
    status public.destination_status DEFAULT 'draft'::public.destination_status NOT NULL,
    rating_avg numeric(3,2),
    review_count integer DEFAULT 0 NOT NULL,
    submitted_by_user_id uuid,
    managed_by_partner_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT destinations_rating_avg_check CHECK (((rating_avg >= (0)::numeric) AND (rating_avg <= (5)::numeric))),
    CONSTRAINT destinations_review_count_check CHECK ((review_count >= 0))
);


ALTER TABLE public.destinations OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17549)
-- Name: districts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.districts (
    id integer NOT NULL,
    regency_id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.districts OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17525)
-- Name: provinces; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provinces (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.provinces OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17534)
-- Name: regencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regencies (
    id integer NOT NULL,
    province_id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.regencies OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17579)
-- Name: subcategories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subcategories (
    id integer NOT NULL,
    category_id integer NOT NULL,
    name character varying(80) NOT NULL,
    slug character varying(90) NOT NULL
);


ALTER TABLE public.subcategories OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17578)
-- Name: subcategories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subcategories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subcategories_id_seq OWNER TO postgres;

--
-- TOC entry 5946 (class 0 OID 0)
-- Dependencies: 231
-- Name: subcategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subcategories_id_seq OWNED BY public.subcategories.id;


--
-- TOC entry 5728 (class 2604 OID 17568)
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- TOC entry 5729 (class 2604 OID 17582)
-- Name: subcategories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subcategories ALTER COLUMN id SET DEFAULT nextval('public.subcategories_id_seq'::regclass);


--
-- TOC entry 5755 (class 2606 OID 17575)
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- TOC entry 5757 (class 2606 OID 17573)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 5759 (class 2606 OID 17577)
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- TOC entry 5769 (class 2606 OID 17626)
-- Name: destinations destinations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_pkey PRIMARY KEY (id);


--
-- TOC entry 5771 (class 2606 OID 17628)
-- Name: destinations destinations_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_slug_key UNIQUE (slug);


--
-- TOC entry 5751 (class 2606 OID 17556)
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- TOC entry 5743 (class 2606 OID 17533)
-- Name: provinces provinces_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_name_key UNIQUE (name);


--
-- TOC entry 5745 (class 2606 OID 17531)
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);


--
-- TOC entry 5747 (class 2606 OID 17541)
-- Name: regencies regencies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regencies
    ADD CONSTRAINT regencies_pkey PRIMARY KEY (id);


--
-- TOC entry 5761 (class 2606 OID 17588)
-- Name: subcategories subcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subcategories
    ADD CONSTRAINT subcategories_pkey PRIMARY KEY (id);


--
-- TOC entry 5763 (class 2606 OID 17590)
-- Name: subcategories subcategories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subcategories
    ADD CONSTRAINT subcategories_slug_key UNIQUE (slug);


--
-- TOC entry 5753 (class 2606 OID 17558)
-- Name: districts unique_district_regency; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT unique_district_regency UNIQUE (id, regency_id);


--
-- TOC entry 5749 (class 2606 OID 17543)
-- Name: regencies unique_regency_province; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regencies
    ADD CONSTRAINT unique_regency_province UNIQUE (id, province_id);


--
-- TOC entry 5765 (class 2606 OID 17592)
-- Name: subcategories unique_subcategory_category; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subcategories
    ADD CONSTRAINT unique_subcategory_category UNIQUE (category_id, name);


--
-- TOC entry 5767 (class 2606 OID 17594)
-- Name: subcategories unique_subcategory_id_category; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subcategories
    ADD CONSTRAINT unique_subcategory_id_category UNIQUE (id, category_id);


--
-- TOC entry 5772 (class 1259 OID 17657)
-- Name: idx_destinations_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_destinations_category ON public.destinations USING btree (category_id);


--
-- TOC entry 5773 (class 1259 OID 17654)
-- Name: idx_destinations_coordinates_gist; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_destinations_coordinates_gist ON public.destinations USING gist (coordinates);


--
-- TOC entry 5774 (class 1259 OID 17660)
-- Name: idx_destinations_geography_gist; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_destinations_geography_gist ON public.destinations USING gist (((coordinates)::public.geography));


--
-- TOC entry 5775 (class 1259 OID 17655)
-- Name: idx_destinations_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_destinations_province ON public.destinations USING btree (province_id);


--
-- TOC entry 5776 (class 1259 OID 17656)
-- Name: idx_destinations_regency; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_destinations_regency ON public.destinations USING btree (regency_id);


--
-- TOC entry 5777 (class 1259 OID 17659)
-- Name: idx_destinations_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_destinations_status ON public.destinations USING btree (status);


--
-- TOC entry 5778 (class 1259 OID 17658)
-- Name: idx_destinations_subcategory; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_destinations_subcategory ON public.destinations USING btree (subcategory_id);


--
-- TOC entry 5782 (class 2606 OID 17644)
-- Name: destinations fk_destination_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT fk_destination_category FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- TOC entry 5783 (class 2606 OID 17639)
-- Name: destinations fk_destination_district; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT fk_destination_district FOREIGN KEY (district_id, regency_id) REFERENCES public.districts(id, regency_id);


--
-- TOC entry 5784 (class 2606 OID 17629)
-- Name: destinations fk_destination_province; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT fk_destination_province FOREIGN KEY (province_id) REFERENCES public.provinces(id);


--
-- TOC entry 5785 (class 2606 OID 17634)
-- Name: destinations fk_destination_regency; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT fk_destination_regency FOREIGN KEY (regency_id, province_id) REFERENCES public.regencies(id, province_id);


--
-- TOC entry 5786 (class 2606 OID 17649)
-- Name: destinations fk_destination_subcategory; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT fk_destination_subcategory FOREIGN KEY (subcategory_id, category_id) REFERENCES public.subcategories(id, category_id);


--
-- TOC entry 5780 (class 2606 OID 17559)
-- Name: districts fk_district_regency; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT fk_district_regency FOREIGN KEY (regency_id) REFERENCES public.regencies(id);


--
-- TOC entry 5779 (class 2606 OID 17544)
-- Name: regencies fk_regency_province; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regencies
    ADD CONSTRAINT fk_regency_province FOREIGN KEY (province_id) REFERENCES public.provinces(id);


--
-- TOC entry 5781 (class 2606 OID 17595)
-- Name: subcategories fk_subcategory_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subcategories
    ADD CONSTRAINT fk_subcategory_category FOREIGN KEY (category_id) REFERENCES public.categories(id);


-- Completed on 2026-11-15 17:13:19

--
-- PostgreSQL database dump complete
--

\unrestrict SF7kKPM8dYWzUgB3hUOR4kZLgShvf2XDH8siTaAGKOGnColOpZXYNf91zUvjN1M


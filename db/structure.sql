--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- Name: ghstore; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ghstore;


--
-- Name: ghstore_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_in(cstring) RETURNS ghstore
    LANGUAGE c STRICT
    AS '$libdir/hstore', 'ghstore_in';


--
-- Name: ghstore_out(ghstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_out(ghstore) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/hstore', 'ghstore_out';


--
-- Name: ghstore; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE ghstore (
    INTERNALLENGTH = variable,
    INPUT = ghstore_in,
    OUTPUT = ghstore_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


--
-- Name: hstore; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE hstore;


--
-- Name: hstore_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hstore_in(cstring) RETURNS hstore
    LANGUAGE c STRICT
    AS '$libdir/hstore', 'hstore_in';


--
-- Name: hstore_out(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hstore_out(hstore) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/hstore', 'hstore_out';


--
-- Name: hstore; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE hstore (
    INTERNALLENGTH = variable,
    INPUT = hstore_in,
    OUTPUT = hstore_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


--
-- Name: akeys(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION akeys(hstore) RETURNS text[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'akeys';


--
-- Name: avals(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION avals(hstore) RETURNS text[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'avals';


--
-- Name: defined(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION defined(hstore, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'defined';


--
-- Name: delete(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION delete(hstore, text) RETURNS hstore
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'delete';


--
-- Name: each(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION each(hs hstore, OUT key text, OUT value text) RETURNS SETOF record
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'each';


--
-- Name: exist(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION exist(hstore, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'exists';


--
-- Name: fetchval(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fetchval(hstore, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'fetchval';


--
-- Name: ghstore_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_compress';


--
-- Name: ghstore_consistent(internal, internal, integer, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_consistent(internal, internal, integer, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_consistent';


--
-- Name: ghstore_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_decompress';


--
-- Name: ghstore_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_penalty';


--
-- Name: ghstore_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_picksplit';


--
-- Name: ghstore_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_same';


--
-- Name: ghstore_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ghstore_union(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'ghstore_union';


--
-- Name: gin_consistent_hstore(internal, smallint, internal, integer, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gin_consistent_hstore(internal, smallint, internal, integer, internal, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'gin_consistent_hstore';


--
-- Name: gin_extract_hstore(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gin_extract_hstore(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'gin_extract_hstore';


--
-- Name: gin_extract_hstore_query(internal, internal, smallint, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gin_extract_hstore_query(internal, internal, smallint, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'gin_extract_hstore_query';


--
-- Name: hs_concat(hstore, hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hs_concat(hstore, hstore) RETURNS hstore
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'hs_concat';


--
-- Name: hs_contained(hstore, hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hs_contained(hstore, hstore) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'hs_contained';


--
-- Name: hs_contains(hstore, hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hs_contains(hstore, hstore) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'hs_contains';


--
-- Name: isdefined(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isdefined(hstore, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'defined';


--
-- Name: isexists(hstore, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isexists(hstore, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'exists';


--
-- Name: skeys(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION skeys(hstore) RETURNS SETOF text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'skeys';


--
-- Name: svals(hstore); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION svals(hstore) RETURNS SETOF text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/hstore', 'svals';


--
-- Name: tconvert(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tconvert(text, text) RETURNS hstore
    LANGUAGE c IMMUTABLE
    AS '$libdir/hstore', 'tconvert';


--
-- Name: ->; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR -> (
    PROCEDURE = fetchval,
    LEFTARG = hstore,
    RIGHTARG = text
);


--
-- Name: <@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <@ (
    PROCEDURE = hs_contained,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: =>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR => (
    PROCEDURE = tconvert,
    LEFTARG = text,
    RIGHTARG = text
);


--
-- Name: ?; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ? (
    PROCEDURE = exist,
    LEFTARG = hstore,
    RIGHTARG = text,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: @; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @ (
    PROCEDURE = hs_contains,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: @>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @> (
    PROCEDURE = hs_contains,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = hs_concat,
    LEFTARG = hstore,
    RIGHTARG = hstore
);


--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = hs_contained,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: gin_hstore_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gin_hstore_ops
    DEFAULT FOR TYPE hstore USING gin AS
    STORAGE text ,
    OPERATOR 7 @>(hstore,hstore) ,
    OPERATOR 9 ?(hstore,text) ,
    FUNCTION 1 bttextcmp(text,text) ,
    FUNCTION 2 gin_extract_hstore(internal,internal) ,
    FUNCTION 3 gin_extract_hstore_query(internal,internal,smallint,internal,internal) ,
    FUNCTION 4 gin_consistent_hstore(internal,smallint,internal,integer,internal,internal);


--
-- Name: gist_hstore_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gist_hstore_ops
    DEFAULT FOR TYPE hstore USING gist AS
    STORAGE ghstore ,
    OPERATOR 7 @>(hstore,hstore) ,
    OPERATOR 9 ?(hstore,text) ,
    OPERATOR 13 @(hstore,hstore) ,
    FUNCTION 1 ghstore_consistent(internal,internal,integer,oid,internal) ,
    FUNCTION 2 ghstore_union(internal,internal) ,
    FUNCTION 3 ghstore_compress(internal) ,
    FUNCTION 4 ghstore_decompress(internal) ,
    FUNCTION 5 ghstore_penalty(internal,internal,internal) ,
    FUNCTION 6 ghstore_picksplit(internal,internal) ,
    FUNCTION 7 ghstore_same(internal,internal,internal);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: adozioni; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE adozioni (
    id integer NOT NULL,
    classe_id integer,
    libro_id integer,
    materia_id integer,
    nr_copie integer DEFAULT 0,
    nr_sezioni integer DEFAULT 0,
    anno character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: adozioni_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE adozioni_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adozioni_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE adozioni_id_seq OWNED BY adozioni.id;


--
-- Name: appunti; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE appunti (
    id integer NOT NULL,
    destinatario character varying(255),
    note text,
    stato character varying(255) DEFAULT ''::character varying NOT NULL,
    scadenza date,
    cliente_id integer,
    user_id integer,
    "position" integer,
    telefono character varying(255),
    email character varying(255),
    totale_copie integer DEFAULT 0,
    totale_importo double precision DEFAULT 0.0,
    latitude double precision,
    longitude double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: appunti_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE appunti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appunti_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE appunti_id_seq OWNED BY appunti.id;


--
-- Name: classi; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE classi (
    id integer NOT NULL,
    classe integer,
    sezione character varying(255),
    nr_alunni integer DEFAULT 0,
    cliente_id integer,
    spec_id character varying(255),
    sper_id character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: classi_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE classi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE classi_id_seq OWNED BY classi.id;


--
-- Name: clienti; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clienti (
    id integer NOT NULL,
    titolo character varying(255),
    cliente_tipo character varying(255),
    nome character varying(255),
    cognome character varying(255),
    ragione_sociale character varying(255),
    abbr character varying(255),
    codice_fiscale character varying(255),
    partita_iva character varying(255),
    indirizzo character varying(255),
    cap character varying(255),
    frazione character varying(255),
    comune character varying(255),
    provincia character varying(255),
    telefono character varying(255),
    telefono_2 character varying(255),
    fax character varying(255),
    cellulare character varying(255),
    email character varying(255),
    url character varying(255),
    gmaps boolean,
    longitude double precision,
    latitude double precision,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ancestry character varying(255),
    slug character varying(255),
    properties hstore
);


--
-- Name: clienti_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clienti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clienti_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clienti_id_seq OWNED BY clienti.id;


--
-- Name: comuni; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comuni (
    id integer NOT NULL,
    istat character varying(255),
    comune character varying(255),
    provincia character varying(255),
    regione character varying(255),
    prefisso character varying(255),
    cap character varying(255),
    codfisco character varying(255),
    abitanti integer,
    link character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: comuni_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comuni_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comuni_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comuni_id_seq OWNED BY comuni.id;


--
-- Name: fatture; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fatture (
    id integer NOT NULL,
    numero integer,
    data date,
    cliente_id integer,
    user_id integer,
    causale_id integer,
    condizioni_pagamento character varying(255),
    pagata boolean,
    totale_copie integer DEFAULT 0,
    importo_fattura numeric(9,2),
    totale_iva numeric(9,2) DEFAULT 0.0,
    spese numeric(9,2) DEFAULT 0.0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255)
);


--
-- Name: fatture_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fatture_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fatture_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fatture_id_seq OWNED BY fatture.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(40),
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: indirizzi; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE indirizzi (
    id integer NOT NULL,
    destinatario character varying(255),
    indirizzo character varying(255),
    cap character varying(255),
    citta character varying(255),
    provincia character varying(255),
    tipo character varying(255),
    indirizzable_id integer,
    indirizzable_type character varying(255),
    gmaps boolean,
    latitude double precision,
    longitude double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: indirizzi_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE indirizzi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: indirizzi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE indirizzi_id_seq OWNED BY indirizzi.id;


--
-- Name: libri; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE libri (
    id integer NOT NULL,
    autore character varying(255),
    titolo character varying(255),
    sigla character varying(255),
    prezzo_copertina numeric(8,2),
    prezzo_consigliato numeric(8,2),
    coefficente numeric(2,1),
    cm character varying(255),
    ean character varying(255),
    old_id character varying(255),
    settore character varying(255),
    materia_id integer,
    image character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255)
);


--
-- Name: libri_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE libri_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: libri_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE libri_id_seq OWNED BY libri.id;


--
-- Name: materie; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE materie (
    id integer NOT NULL,
    materia character varying(255)
);


--
-- Name: materie_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE materie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: materie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE materie_id_seq OWNED BY materie.id;


--
-- Name: righe; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE righe (
    id integer NOT NULL,
    libro_id integer,
    quantita integer,
    prezzo_unitario numeric(9,3),
    sconto numeric(5,2) DEFAULT 0.0,
    consegnato boolean,
    pagato boolean,
    appunto_id integer,
    fattura_id integer,
    magazzino_id integer,
    causale_id integer,
    movimento integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: righe_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE righe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: righe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE righe_id_seq OWNED BY righe.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: searches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE searches (
    id integer NOT NULL,
    title character varying(255),
    model character varying(255),
    keywords character varying(255),
    destinatario character varying(255),
    note character varying(255),
    stato character varying(255),
    scuola character varying(255),
    citta character varying(255),
    provincia character varying(255),
    zona character varying(255),
    tag_list character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE searches_id_seq OWNED BY searches.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(128) DEFAULT ''::character varying NOT NULL,
    username character varying(255),
    avatar character varying(255),
    telefono character varying(255),
    web_site character varying(255),
    nome_completo character varying(255),
    codice_fiscale character varying(255),
    partita_iva character varying(255),
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: visita_appunti; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visita_appunti (
    id integer NOT NULL,
    visita_id integer,
    appunto_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: visita_appunti_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visita_appunti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visita_appunti_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visita_appunti_id_seq OWNED BY visita_appunti.id;


--
-- Name: visite; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visite (
    id integer NOT NULL,
    cliente_id integer,
    titolo character varying(255),
    start timestamp without time zone,
    "end" timestamp without time zone,
    all_day boolean,
    baule boolean,
    scopo character varying(255),
    giro_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: visite_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visite_id_seq OWNED BY visite.id;


--
-- Name: will_filter_filters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE will_filter_filters (
    id integer NOT NULL,
    type character varying(255),
    name character varying(255),
    data text,
    user_id integer,
    model_class_name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: will_filter_filters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE will_filter_filters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: will_filter_filters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE will_filter_filters_id_seq OWNED BY will_filter_filters.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE adozioni ALTER COLUMN id SET DEFAULT nextval('adozioni_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE appunti ALTER COLUMN id SET DEFAULT nextval('appunti_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE classi ALTER COLUMN id SET DEFAULT nextval('classi_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE clienti ALTER COLUMN id SET DEFAULT nextval('clienti_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE comuni ALTER COLUMN id SET DEFAULT nextval('comuni_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE fatture ALTER COLUMN id SET DEFAULT nextval('fatture_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE indirizzi ALTER COLUMN id SET DEFAULT nextval('indirizzi_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE libri ALTER COLUMN id SET DEFAULT nextval('libri_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE materie ALTER COLUMN id SET DEFAULT nextval('materie_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE righe ALTER COLUMN id SET DEFAULT nextval('righe_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE searches ALTER COLUMN id SET DEFAULT nextval('searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE visita_appunti ALTER COLUMN id SET DEFAULT nextval('visita_appunti_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE visite ALTER COLUMN id SET DEFAULT nextval('visite_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE will_filter_filters ALTER COLUMN id SET DEFAULT nextval('will_filter_filters_id_seq'::regclass);


--
-- Name: adozioni_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY adozioni
    ADD CONSTRAINT adozioni_pkey PRIMARY KEY (id);


--
-- Name: appunti_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY appunti
    ADD CONSTRAINT appunti_pkey PRIMARY KEY (id);


--
-- Name: classi_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY classi
    ADD CONSTRAINT classi_pkey PRIMARY KEY (id);


--
-- Name: clienti_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY clienti
    ADD CONSTRAINT clienti_pkey PRIMARY KEY (id);


--
-- Name: comuni_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comuni
    ADD CONSTRAINT comuni_pkey PRIMARY KEY (id);


--
-- Name: fatture_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fatture
    ADD CONSTRAINT fatture_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: indirizzi_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY indirizzi
    ADD CONSTRAINT indirizzi_pkey PRIMARY KEY (id);


--
-- Name: libri_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY libri
    ADD CONSTRAINT libri_pkey PRIMARY KEY (id);


--
-- Name: materie_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY materie
    ADD CONSTRAINT materie_pkey PRIMARY KEY (id);


--
-- Name: righe_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY righe
    ADD CONSTRAINT righe_pkey PRIMARY KEY (id);


--
-- Name: searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT searches_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visita_appunti_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visita_appunti
    ADD CONSTRAINT visita_appunti_pkey PRIMARY KEY (id);


--
-- Name: visite_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visite
    ADD CONSTRAINT visite_pkey PRIMARY KEY (id);


--
-- Name: will_filter_filters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY will_filter_filters
    ADD CONSTRAINT will_filter_filters_pkey PRIMARY KEY (id);


--
-- Name: clienti_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX clienti_properties ON clienti USING gin (properties);


--
-- Name: index_adozioni_on_classe_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_adozioni_on_classe_id ON adozioni USING btree (classe_id);


--
-- Name: index_adozioni_on_libro_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_adozioni_on_libro_id ON adozioni USING btree (libro_id);


--
-- Name: index_adozioni_on_materia_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_adozioni_on_materia_id ON adozioni USING btree (materia_id);


--
-- Name: index_appunti_on_cliente_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_appunti_on_cliente_id ON appunti USING btree (cliente_id);


--
-- Name: index_appunti_on_stato; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_appunti_on_stato ON appunti USING btree (stato);


--
-- Name: index_appunti_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_appunti_on_user_id ON appunti USING btree (user_id);


--
-- Name: index_classi_on_cliente_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classi_on_cliente_id ON classi USING btree (cliente_id);


--
-- Name: index_classi_on_scuola_id_and_classe_and_sezione; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_classi_on_scuola_id_and_classe_and_sezione ON classi USING btree (cliente_id, classe, sezione);


--
-- Name: index_clienti_on_cliente_tipo; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_clienti_on_cliente_tipo ON clienti USING btree (cliente_tipo);


--
-- Name: index_clienti_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_clienti_on_user_id ON clienti USING btree (user_id);


--
-- Name: index_fatture_on_causale_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fatture_on_causale_id ON fatture USING btree (causale_id);


--
-- Name: index_fatture_on_scuola_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fatture_on_scuola_id ON fatture USING btree (cliente_id);


--
-- Name: index_fatture_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fatture_on_user_id ON fatture USING btree (user_id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_libri_on_materia_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_libri_on_materia_id ON libri USING btree (materia_id);


--
-- Name: index_libri_on_settore; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_libri_on_settore ON libri USING btree (settore);


--
-- Name: index_libri_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_libri_on_slug ON libri USING btree (slug);


--
-- Name: index_libri_on_titolo; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_libri_on_titolo ON libri USING btree (titolo);


--
-- Name: index_righe_on_appunto_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_righe_on_appunto_id ON righe USING btree (appunto_id);


--
-- Name: index_righe_on_causale_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_righe_on_causale_id ON righe USING btree (causale_id);


--
-- Name: index_righe_on_fattura_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_righe_on_fattura_id ON righe USING btree (fattura_id);


--
-- Name: index_righe_on_libro_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_righe_on_libro_id ON righe USING btree (libro_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: index_visita_appunti_on_visita_id_and_appunto_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visita_appunti_on_visita_id_and_appunto_id ON visita_appunti USING btree (visita_id, appunto_id);


--
-- Name: index_visite_on_cliente_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visite_on_cliente_id ON visite USING btree (cliente_id);


--
-- Name: index_will_filter_filters_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_will_filter_filters_on_user_id ON will_filter_filters USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20111110195410');

INSERT INTO schema_migrations (version) VALUES ('20111117162727');

INSERT INTO schema_migrations (version) VALUES ('20111126070612');

INSERT INTO schema_migrations (version) VALUES ('20111204094245');

INSERT INTO schema_migrations (version) VALUES ('20111204101411');

INSERT INTO schema_migrations (version) VALUES ('20120114131156');

INSERT INTO schema_migrations (version) VALUES ('20120117192534');

INSERT INTO schema_migrations (version) VALUES ('20120119112950');

INSERT INTO schema_migrations (version) VALUES ('20120130120547');

INSERT INTO schema_migrations (version) VALUES ('20120304222429');

INSERT INTO schema_migrations (version) VALUES ('20120305194741');

INSERT INTO schema_migrations (version) VALUES ('20120305201856');

INSERT INTO schema_migrations (version) VALUES ('20120309134257');

INSERT INTO schema_migrations (version) VALUES ('20120407052912');

INSERT INTO schema_migrations (version) VALUES ('20120407055016');

INSERT INTO schema_migrations (version) VALUES ('20120407181944');

INSERT INTO schema_migrations (version) VALUES ('20120407182007');

INSERT INTO schema_migrations (version) VALUES ('20120408064626');

INSERT INTO schema_migrations (version) VALUES ('20120413152125');

INSERT INTO schema_migrations (version) VALUES ('20120501082549');

INSERT INTO schema_migrations (version) VALUES ('20120501082649');

INSERT INTO schema_migrations (version) VALUES ('20120501082725');
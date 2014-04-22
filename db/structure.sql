--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


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
    FUNCTION 1 (hstore, hstore) bttextcmp(text,text) ,
    FUNCTION 2 (hstore, hstore) gin_extract_hstore(internal,internal) ,
    FUNCTION 3 (hstore, hstore) gin_extract_hstore_query(internal,internal,smallint,internal,internal) ,
    FUNCTION 4 (hstore, hstore) gin_consistent_hstore(internal,smallint,internal,integer,internal,internal);


--
-- Name: gist_hstore_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gist_hstore_ops
    DEFAULT FOR TYPE hstore USING gist AS
    STORAGE ghstore ,
    OPERATOR 7 @>(hstore,hstore) ,
    OPERATOR 9 ?(hstore,text) ,
    OPERATOR 13 @(hstore,hstore) ,
    FUNCTION 1 (hstore, hstore) ghstore_consistent(internal,internal,integer,oid,internal) ,
    FUNCTION 2 (hstore, hstore) ghstore_union(internal,internal) ,
    FUNCTION 3 (hstore, hstore) ghstore_compress(internal) ,
    FUNCTION 4 (hstore, hstore) ghstore_decompress(internal) ,
    FUNCTION 5 (hstore, hstore) ghstore_penalty(internal,internal,internal) ,
    FUNCTION 6 (hstore, hstore) ghstore_picksplit(internal,internal) ,
    FUNCTION 7 (hstore, hstore) ghstore_same(internal,internal,internal);


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
    updated_at timestamp without time zone NOT NULL,
    kit_1 character varying(255),
    kit_2 character varying(255)
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
    updated_at timestamp without time zone NOT NULL,
    uuid uuid,
    deleted_at timestamp without time zone,
    completed_at timestamp without time zone
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
-- Name: appunto_events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE appunto_events (
    id integer NOT NULL,
    appunto_id integer,
    state character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: appunto_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE appunto_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appunto_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE appunto_events_id_seq OWNED BY appunto_events.id;


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
    updated_at timestamp without time zone NOT NULL,
    insegnanti character varying(255),
    note text,
    libro_1 character varying(255),
    libro_2 character varying(255),
    libro_3 character varying(255),
    libro_4 character varying(255),
    anno character varying(255)
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
    properties hstore,
    uuid uuid,
    deleted_at timestamp without time zone
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
    slug character varying(255),
    status character varying(255)
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
    slug character varying(255),
    iva character varying(255),
    classe integer
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
-- Name: oauth_access_grants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_access_grants (
    id integer NOT NULL,
    resource_owner_id integer NOT NULL,
    application_id integer NOT NULL,
    token character varying(255) NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying(255)
);


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_access_grants_id_seq OWNED BY oauth_access_grants.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_access_tokens (
    id integer NOT NULL,
    resource_owner_id integer,
    application_id integer NOT NULL,
    token character varying(255) NOT NULL,
    refresh_token character varying(255),
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying(255)
);


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_access_tokens_id_seq OWNED BY oauth_access_tokens.id;


--
-- Name: oauth_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_applications (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    uid character varying(255) NOT NULL,
    secret character varying(255) NOT NULL,
    redirect_uri character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_applications_id_seq OWNED BY oauth_applications.id;


--
-- Name: propa2014s; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE propa2014s (
    id integer NOT NULL,
    cliente_id integer,
    data_visita date,
    data_ritiro date,
    data_interclasse date,
    data_collegio date,
    kit_123 character varying(255),
    nr_123 integer,
    kit_45 character varying(255),
    nr_45 integer,
    kit_123_ing character varying(255),
    nr_45_ing integer,
    kit_123_rel character varying(255),
    nr_123_rel integer,
    kit_45_rel character varying(255),
    nr_45_rel integer,
    vac_1 character varying(255),
    vac_2 character varying(255),
    vac_3 character varying(255),
    vac_4 character varying(255),
    vac_5 character varying(255),
    nr_vac_1 integer,
    nr_vac_2 integer,
    nr_vac_3 integer,
    nr_vac_4 integer,
    nr_vac_5 integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data_vacanze date
);


--
-- Name: propa2014s_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE propa2014s_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: propa2014s_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE propa2014s_id_seq OWNED BY propa2014s.id;


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
    updated_at timestamp without time zone NOT NULL,
    uuid uuid
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
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    tagger_id integer,
    tagger_type character varying(255),
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


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
    updated_at timestamp without time zone NOT NULL,
    properties hstore
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

ALTER TABLE ONLY adozioni ALTER COLUMN id SET DEFAULT nextval('adozioni_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY appunti ALTER COLUMN id SET DEFAULT nextval('appunti_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY appunto_events ALTER COLUMN id SET DEFAULT nextval('appunto_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY classi ALTER COLUMN id SET DEFAULT nextval('classi_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clienti ALTER COLUMN id SET DEFAULT nextval('clienti_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comuni ALTER COLUMN id SET DEFAULT nextval('comuni_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fatture ALTER COLUMN id SET DEFAULT nextval('fatture_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY indirizzi ALTER COLUMN id SET DEFAULT nextval('indirizzi_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY libri ALTER COLUMN id SET DEFAULT nextval('libri_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY materie ALTER COLUMN id SET DEFAULT nextval('materie_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('oauth_access_grants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('oauth_access_tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_applications ALTER COLUMN id SET DEFAULT nextval('oauth_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY propa2014s ALTER COLUMN id SET DEFAULT nextval('propa2014s_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY righe ALTER COLUMN id SET DEFAULT nextval('righe_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches ALTER COLUMN id SET DEFAULT nextval('searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visita_appunti ALTER COLUMN id SET DEFAULT nextval('visita_appunti_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visite ALTER COLUMN id SET DEFAULT nextval('visite_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY will_filter_filters ALTER COLUMN id SET DEFAULT nextval('will_filter_filters_id_seq'::regclass);


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
-- Name: appunto_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY appunto_events
    ADD CONSTRAINT appunto_events_pkey PRIMARY KEY (id);


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
-- Name: oauth_access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);


--
-- Name: propa2014s_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY propa2014s
    ADD CONSTRAINT propa2014s_pkey PRIMARY KEY (id);


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
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


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
-- Name: index_appunto_events_on_appunto_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_appunto_events_on_appunto_id ON appunto_events USING btree (appunto_id);


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
-- Name: index_oauth_access_grants_on_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON oauth_access_grants USING btree (token);


--
-- Name: index_oauth_access_tokens_on_refresh_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON oauth_access_tokens USING btree (refresh_token);


--
-- Name: index_oauth_access_tokens_on_resource_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON oauth_access_tokens USING btree (resource_owner_id);


--
-- Name: index_oauth_access_tokens_on_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON oauth_access_tokens USING btree (token);


--
-- Name: index_oauth_applications_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_oauth_applications_on_uid ON oauth_applications USING btree (uid);


--
-- Name: index_propa2014s_on_cliente_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_propa2014s_on_cliente_id ON propa2014s USING btree (cliente_id);


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
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING btree (taggable_id, taggable_type, context);


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
-- Name: users_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_properties ON users USING gin (properties);


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

INSERT INTO schema_migrations (version) VALUES ('20120505083439');

INSERT INTO schema_migrations (version) VALUES ('20120513065513');

INSERT INTO schema_migrations (version) VALUES ('20120513065543');

INSERT INTO schema_migrations (version) VALUES ('20120513083751');

INSERT INTO schema_migrations (version) VALUES ('20120901074823');

INSERT INTO schema_migrations (version) VALUES ('20120928162757');

INSERT INTO schema_migrations (version) VALUES ('20121121122824');

INSERT INTO schema_migrations (version) VALUES ('20121209194003');

INSERT INTO schema_migrations (version) VALUES ('20130414143827');

INSERT INTO schema_migrations (version) VALUES ('20130710125622');

INSERT INTO schema_migrations (version) VALUES ('20131103134609');

INSERT INTO schema_migrations (version) VALUES ('20140323123526');

INSERT INTO schema_migrations (version) VALUES ('20140421081711');
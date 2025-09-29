--
-- PostgreSQL database dump
--

\restrict AO0EfGE6PHeahpIR6wZrhrxYi81It5bAk0DsnvNmoKQZL7EQyOkXxKFA7j2Iw2T

-- Dumped from database version 16.9
-- Dumped by pg_dump version 17.6 (Debian 17.6-1.pgdg12+1)

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
-- Name: add_removal_type_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.add_removal_type_enum AS ENUM (
    'ALTA',
    'BAJA'
);


ALTER TYPE public.add_removal_type_enum OWNER TO esc;

--
-- Name: admission_has_inventory_status_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.admission_has_inventory_status_enum AS ENUM (
    'ADMISSION',
    'DISCHARGE',
    'REMOVE',
    'ADD'
);


ALTER TYPE public.admission_has_inventory_status_enum OWNER TO esc;

--
-- Name: admissions_discharges_type_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.admissions_discharges_type_enum AS ENUM (
    'ADMISSION',
    'DISCHARGE',
    'REMOVE',
    'ADD'
);


ALTER TYPE public.admissions_discharges_type_enum OWNER TO esc;

--
-- Name: assignments_returns_type_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.assignments_returns_type_enum AS ENUM (
    'ASIGNACION',
    'DEVOLUCION'
);


ALTER TYPE public.assignments_returns_type_enum OWNER TO esc;

--
-- Name: employees_blood_type_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.employees_blood_type_enum AS ENUM (
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
    'Desconocido'
);


ALTER TYPE public.employees_blood_type_enum OWNER TO esc;

--
-- Name: employees_gender_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.employees_gender_enum AS ENUM (
    'Femenino',
    'Masculino'
);


ALTER TYPE public.employees_gender_enum OWNER TO esc;

--
-- Name: employees_nacionality_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.employees_nacionality_enum AS ENUM (
    'Mexicana',
    'Extranjera'
);


ALTER TYPE public.employees_nacionality_enum OWNER TO esc;

--
-- Name: employees_status_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.employees_status_enum AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'PERMISSION',
    'DELETED',
    'DISMISSAL'
);


ALTER TYPE public.employees_status_enum OWNER TO esc;

--
-- Name: employment_record_status_civil_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.employment_record_status_civil_enum AS ENUM (
    'Soltero/a',
    'Casado/a',
    'Divorciado/a',
    'Viudo/a',
    'Separado/a',
    'Concubino/a'
);


ALTER TYPE public.employment_record_status_civil_enum OWNER TO esc;

--
-- Name: inventory_has_assigment_type_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.inventory_has_assigment_type_enum AS ENUM (
    'ASIGNACION',
    'DEVOLUCION'
);


ALTER TYPE public.inventory_has_assigment_type_enum OWNER TO esc;

--
-- Name: inventory_has_maintenances_maintenancetype_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.inventory_has_maintenances_maintenancetype_enum AS ENUM (
    'CORRECTIVO',
    'PREVENTIVO'
);


ALTER TYPE public.inventory_has_maintenances_maintenancetype_enum OWNER TO esc;

--
-- Name: inventory_has_maintenances_status_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.inventory_has_maintenances_status_enum AS ENUM (
    'EN_OPERACION',
    'EN_ALMACEN'
);


ALTER TYPE public.inventory_has_maintenances_status_enum OWNER TO esc;

--
-- Name: inventory_status_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.inventory_status_enum AS ENUM (
    'IN_TRANSIT',
    'AVAILABLE',
    'IN_USE',
    'OUT_OF_SERVICE',
    'IN_MAINTENANCE',
    'IN_WAREHOUSE'
);


ALTER TYPE public.inventory_status_enum OWNER TO esc;

--
-- Name: maintenances_maintenancetype_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.maintenances_maintenancetype_enum AS ENUM (
    'CORRECTIVO',
    'PREVENTIVO'
);


ALTER TYPE public.maintenances_maintenancetype_enum OWNER TO esc;

--
-- Name: maintenances_status_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.maintenances_status_enum AS ENUM (
    'EN_OPERACION',
    'EN_ALMACEN'
);


ALTER TYPE public.maintenances_status_enum OWNER TO esc;

--
-- Name: resource_type_enum; Type: TYPE; Schema: public; Owner: esc
--

CREATE TYPE public.resource_type_enum AS ENUM (
    'INVENTARIO',
    'ACCESORIO'
);


ALTER TYPE public.resource_type_enum OWNER TO esc;

--
-- Name: after_approve_vacation(); Type: FUNCTION; Schema: public; Owner: esc
--

CREATE FUNCTION public.after_approve_vacation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        IF (TG_OP = 'INSERT' AND NEW.status = 'APPROVED')
           OR (TG_OP = 'UPDATE' AND NEW.status = 'APPROVED' AND OLD.status IS DISTINCT FROM 'APPROVED') THEN

          INSERT INTO presences (date, reason, staff_id, check_in, check_out)
          SELECT d::date, 'VACATIONS', s.id, '00:00:00', '00:00:00'
          FROM generate_series(NEW."startDate", NEW."endDate", interval '1 day') d
          JOIN employee_has_positions ehp ON ehp.employee_id = NEW.employee_id
          JOIN staff s ON s.employee_has_positions_id = ehp.id
          WHERE EXTRACT(DOW FROM d) NOT IN (0,6)
            AND NOT EXISTS (SELECT 1 FROM holidays h
                            WHERE h.holiday_date = d
                              AND h.deleted_at IS NULL)
            AND s.deleted_at IS NULL
            AND NOT EXISTS (
              SELECT 1 FROM presences p
              WHERE p.date = d
                AND p.staff_id = s.id
                AND p.reason = 'VACATIONS'
            );

        END IF;

        RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.after_approve_vacation() OWNER TO esc;

--
-- Name: after_delete_vacation(); Type: FUNCTION; Schema: public; Owner: esc
--

CREATE FUNCTION public.after_delete_vacation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        -- Solo cuando se soft-deleted (cambio de NULL a fecha en deleted_at)
        IF (TG_OP = 'UPDATE' AND OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL) THEN

          DELETE FROM presences p
          USING employee_has_positions ehp, staff s
          WHERE ehp.employee_id = NEW.employee_id
            AND s.employee_has_positions_id = ehp.id
            AND p.staff_id = s.id
            AND p.reason = 'VACATIONS'
            AND p.date BETWEEN NEW."startDate" AND NEW."endDate";

        END IF;

        RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.after_delete_vacation() OWNER TO esc;

--
-- Name: after_dismissal_update(); Type: FUNCTION; Schema: public; Owner: esc
--

CREATE FUNCTION public.after_dismissal_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        -- Marcar staff relacionado como eliminado
        UPDATE staff s
        SET deleted_at = NOW(),
            available = FALSE
        FROM employee_has_positions ehp
        WHERE s.employee_has_positions_id = ehp.id
          AND ehp.employee_id = NEW.employee_id
          AND s.deleted_at IS NULL;
        
        -- Marcar posiciones del empleado como eliminadas
        UPDATE employee_has_positions ehp
        SET deleted_at = NOW(),
            available = FALSE
        WHERE ehp.employee_id = NEW.employee_id
          AND ehp.deleted_at IS NULL;

        -- Cambiar estado del empleado
        update employees e
        set
          status = 'DISMISSAL'
        where
        e.id = NEW.employee_id
        and e.status <> 'DISMISSAL';

        return new;
      end;

      $$;


ALTER FUNCTION public.after_dismissal_update() OWNER TO esc;

--
-- Name: findmaxandregistered(integer, integer); Type: FUNCTION; Schema: public; Owner: esc
--

CREATE FUNCTION public.findmaxandregistered(p_headquarter_id integer, p_position_id integer) RETURNS TABLE(max_employee integer, registrados integer, boss_position_id integer, boss_staff_id integer[], required_boss boolean, is_external boolean)
    LANGUAGE plpgsql
    AS $$
      BEGIN
        RETURN QUERY
        WITH max_quota AS (
        -- Buscar el maximo de empleados permitidos en la sede
          SELECT COALESCE(hpq.max_employee, 0) AS max_employee
          FROM "headquarters_position_quota" hpq
          WHERE hpq.headquarter_id = p_headquarter_id
            AND hpq.position_id = p_position_id
        ),
        registered AS (
        -- Buscar los staff registrados en la sede con la posición
          SELECT COUNT(DISTINCT s.id) AS registrados
          FROM staff s
          JOIN "employee_has_positions" ehp
            ON s.employee_has_positions_id = ehp.id
          WHERE s.headquarter_id = p_headquarter_id
            AND ehp.position_id = p_position_id
        ),
        boss_pos AS (
        -- Buscar la positionId que debe tener el parent
          SELECT p."parentId" AS boss_position_id,
          p."requiredBoss" as required_boss
          FROM positions p
          WHERE p.id = p_position_id
        ),
        boss_staff AS (
        -- Buscar el maximo de empleados permitidos en la sede
          SELECT COALESCE(array_agg(s.id), '{}') AS boss_staff_id
          FROM staff s
          JOIN "employee_has_positions" ehp
            ON s.employee_has_positions_id = ehp.id
          WHERE s.headquarter_id = p_headquarter_id
            AND ehp.position_id = (
              SELECT p."parentId"
              FROM positions p
              WHERE p.id = p_position_id
            ) LIMIT 1
        ),
        external_project AS (
          SELECT pj."isExternal" as is_external
        	FROM headquarters hq
          JOIN projects pj
          on pj.id = hq.project_id
          WHERE hq.id = p_headquarter_id
        )

        SELECT
          coalesce(mq.max_employee::INTEGER, 0),
          coalesce(r.registrados::INTEGER, 0),
          coalesce(bp.boss_position_id, 0),
          COALESCE(bs.boss_staff_id::INTEGER[], '{}'),
          coalesce(bp.required_boss::BOOL, false),
          coalesce(ep.is_external::BOOL, false)
        FROM (SELECT 1) base
        LEFT JOIN max_quota mq ON true
        LEFT JOIN registered r ON true
        LEFT JOIN boss_pos bp ON true
        LEFT JOIN boss_staff bs ON true
       	LEFT JOIN external_project ep ON TRUE;
       	END;
      $$;


ALTER FUNCTION public.findmaxandregistered(p_headquarter_id integer, p_position_id integer) OWNER TO esc;

--
-- Name: findstafftree(integer, integer); Type: FUNCTION; Schema: public; Owner: esc
--

CREATE FUNCTION public.findstafftree(p_project_id integer DEFAULT NULL::integer, p_headquarter_id integer DEFAULT NULL::integer) RETURNS TABLE(project_id integer, project_name text, project_available boolean, project_contract_number text, project_description text, project_number_expedients integer, project_number_images integer, project_production_days integer, project_sum_productions integer, project_start_date date, project_end_date date, project_status text, project_created_at timestamp without time zone, project_updated_at timestamp without time zone, headquarter_id integer, headquarter_name text, headquarter_address text, headquarter_available boolean, headquarter_postal_code text, headquarter_city text, headquarter_expedients integer, headquarter_production_days integer, headquarter_sum_productions integer, headquarter_start_date date, headquarter_end_date date, headquarter_status text, headquarter_created_at timestamp without time zone, headquarter_updated_at timestamp without time zone, staff_id integer, staff_parent integer, staff_available boolean, staff_created_at timestamp without time zone, staff_deleted_at timestamp without time zone, ehp_id integer, ehp_available boolean, ehp_created_at timestamp without time zone, ehp_updated_at timestamp without time zone, position_id integer, position_name text, position_available boolean, position_salary integer, position_created_at timestamp without time zone, position_updated_at timestamp without time zone, salary_id integer, salary_available boolean, salary_amount numeric, salary_in_words text, employee_id integer, employee_name text, employee_date_birth date, employee_year_old numeric, employee_email text, employee_telephone text, employee_address text, employee_gender public.employees_gender_enum, employee_alergy text, employee_nacionality public.employees_nacionality_enum, employee_blood_type public.employees_blood_type_enum)
    LANGUAGE plpgsql
    AS $$
        BEGIN
          RETURN QUERY
          with recursive staff_tree_by_project as (
          select
          		p.id as project_id,
          		p.name::TEXT as project_name,
          		p.available as project_available,
          		p.contract_number::TEXT as project_contract_number,
          		p.description::TEXT as project_decription,
          		p.number_expedients as project_number_expedients,
          		p.number_images as project_number_images,
          		p.productions_days as project_production_days,
          		p.sum_productions as project_sum_productions,
          		p.start_date as project_start_date,
          		p.end_date as project_end_date,
          		p.status::TEXT as project_status,
          		p.created_at as project_created_at,
          		p.updated_at as project_updated_at,
          		h.id as headquarter_id,
          		h.name::TEXT as headquarter_name,
          		h.address::TEXT as headquarter_address,
          		h.available as headquarter_available,
          		h.postal_code::TEXT as headquarter_code_postal,
          		h.city::TEXT as headquarter_city,
          		h.number_expedients as headquarter_expedients,
          		h.production_days as headquarter_production_days,
          		h.sum_productions as headquarter_sum_productions,
          		h.start_date as headquarter_start_date,
          		h.end_date as headquarter_end_date,
          		h.status::TEXT as headquarter_status,
          		h.created_at as headquarter_created_at,
          		h.updated_at as headquarter_updated_at,
          		s.id as staff_id,
          		s."parentId" as staff_parent,
          		s.available as staff_available,
          		s.created_at as staff_created_at,
          		s.deleted_at as staff_updated_at,
          		ehp.id as ehp_id,
          		ehp.available as ehp_available,
          		ehp.created_at as ehp_created_at,
          		ehp.updated_at as ehp_updated_at,
          		p2.id as position_id,
          		p2.name::TEXT as position_name,
          		p2.available as position_available,
          		p2.salary_id as position_salary,
          		p2.created_at as position_created_at,
          		p2.updated_at as position_upated_at,
          		sl.id as salary_id,
          		sl.available as salary_available,
          		sl.amount::NUMERIC as salary_amound,
          		sl.salary_in_words::TEXT as salary_salary_in_words,
          		em.id as employee_id,
          		concat(em.names, ' ', em.first_last_name, ' ', em.second_last_name)::text as employee_name,
          		em.date_birth as employee_date_birth,
          		em.year_old::numeric as employee_year_old,
          		em.email::text as employee_email,
          		em.telephone::text as employee_telephone,
          		em.address::text as employee_address,
          		em.gender as employee_gender,
          		em.alergy::text as employee_alergy,
          		em.nacionality as employee_nacionality,
          		em.blood_type as employee_blood_type
         	from staff s
         	inner join headquarters h
         	on h.id = s.headquarter_id
         	inner join employee_has_positions ehp
         	on ehp.id = s.employee_has_positions_id
         	inner join positions p2
         	on p2.id = ehp.employee_id
         	inner join salary sl
         	on sl.id = p2.salary_id
         	inner join employees em
         	on em.id = ehp.employee_id
         	inner join projects p
         	on p.id = h.project_id
         	WHERE s."parentId" IS NULL AND s.deleted_at IS NULL
            AND (
              (p_project_id IS NOT NULL AND p.id = p_project_id)
              OR
              (p_headquarter_id IS NOT NULL AND h.id = p_headquarter_id)
            )

          union all

         	select
          		st.project_id,
          		st.project_name,
          		st.project_available,
          		st.project_contract_number,
          		st.project_decription,
          		st.project_number_expedients,
          		st.project_number_images,
          		st.project_production_days,
          		st.project_sum_productions,
          		st.project_start_date,
          		st.project_end_date,
          		st.project_status,
          		st.project_created_at,
          		st.project_updated_at,
          		st.headquarter_id,
          		st.headquarter_name,
          		st.headquarter_address,
          		st.headquarter_available,
          		st.headquarter_code_postal,
          		st.headquarter_city,
          		st.headquarter_expedients,
          		st.headquarter_production_days,
          		st.headquarter_sum_productions,
          		st.headquarter_start_date,
          		st.headquarter_end_date,
          		st.headquarter_status,
          		st.headquarter_created_at,
          		st.headquarter_updated_at,
          		child.id as staff_id,
          		child."parentId" as staff_parent,
          		child.available as staff_available,
          		child.created_at as staff_created_at,
          		child.deleted_at as staff_updated_at,
          		ehp.id as ehp_id,
          		ehp.available as ehp_available,
          		ehp.created_at as ehp_created_at,
          		ehp.updated_at as ehp_updated_at,
          		p2.id as position_id,
          		p2.name::TEXT as position_name,
          		p2.available as position_available,
          		p2.salary_id as position_salary,
          		p2.created_at as position_created_at,
          		p2.updated_at as position_upated_at,
          		sl.id as salary_id,
          		sl.available as salary_available,
          		sl.amount::NUMERIC as salary_amound,
          		sl.salary_in_words::TEXT as salary_salary_in_words,
          		em.id as employee_id,
          		concat(em.names, ' ', em.first_last_name, ' ', em.second_last_name) as employee_name,
          		em.date_birth as employee_date_birth,
          		em.year_old as employee_year_old,
          		em.email as employee_email,
          		em.telephone as employee_telephone,
          		em.address as employee_address,
          		em.gender as employee_gender,
          		em.alergy as employee_alergy,
          		em.nacionality as employee_nacionality,
          		em.blood_type as employee_blood_type
         	from staff child
         	inner join staff_tree_by_project st on child."parentId" = st.staff_id
         	inner join employee_has_positions ehp
         	on ehp.id = child.employee_has_positions_id
         	inner join positions p2
         	on p2.id = ehp.position_id
         	inner join salary sl
         	on sl.id = p2.salary_id
         	inner join employees em
         	on em.id = ehp.employee_id
         	where child.deleted_at IS NULL
         	)

          select st.*
         	from staff_tree_by_project st
         	ORDER BY staff_parent NULLS FIRST, staff_id;

          end;

      $$;


ALTER FUNCTION public.findstafftree(p_project_id integer, p_headquarter_id integer) OWNER TO esc;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: add_removal; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.add_removal (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    motive text,
    observations text,
    type public.add_removal_type_enum,
    factura text
);


ALTER TABLE public.add_removal OWNER TO esc;

--
-- Name: add_removal_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.add_removal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.add_removal_id_seq OWNER TO esc;

--
-- Name: add_removal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.add_removal_id_seq OWNED BY public.add_removal.id;


--
-- Name: admission_has_inventory; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.admission_has_inventory (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    status public.admission_has_inventory_status_enum,
    "inventoryId" integer,
    "admissionsDischargesId" integer
);


ALTER TABLE public.admission_has_inventory OWNER TO esc;

--
-- Name: admission_has_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.admission_has_inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admission_has_inventory_id_seq OWNER TO esc;

--
-- Name: admission_has_inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.admission_has_inventory_id_seq OWNED BY public.admission_has_inventory.id;


--
-- Name: admissions_discharges; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.admissions_discharges (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    reason text,
    observations text,
    date character varying,
    project_id integer,
    user_id integer,
    type public.admissions_discharges_type_enum
);


ALTER TABLE public.admissions_discharges OWNER TO esc;

--
-- Name: admissions_discharges_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.admissions_discharges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admissions_discharges_id_seq OWNER TO esc;

--
-- Name: admissions_discharges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.admissions_discharges_id_seq OWNED BY public.admissions_discharges.id;


--
-- Name: assignments_returns; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.assignments_returns (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    date character varying,
    comments text,
    user_id integer,
    type public.assignments_returns_type_enum,
    project_id integer
);


ALTER TABLE public.assignments_returns OWNER TO esc;

--
-- Name: assignments_returns_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.assignments_returns_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assignments_returns_id_seq OWNER TO esc;

--
-- Name: assignments_returns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.assignments_returns_id_seq OWNED BY public.assignments_returns.id;


--
-- Name: attendance_permission; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.attendance_permission (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    permission_type character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    reason text NOT NULL,
    status character varying DEFAULT 'PENDING'::character varying NOT NULL,
    requested_at integer NOT NULL,
    approved_by character varying NOT NULL,
    approved_at character varying NOT NULL
);


ALTER TABLE public.attendance_permission OWNER TO esc;

--
-- Name: attendance_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.attendance_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_permission_id_seq OWNER TO esc;

--
-- Name: attendance_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.attendance_permission_id_seq OWNED BY public.attendance_permission.id;


--
-- Name: banks; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.banks (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(50) NOT NULL
);


ALTER TABLE public.banks OWNER TO esc;

--
-- Name: banks_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.banks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.banks_id_seq OWNER TO esc;

--
-- Name: banks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.banks_id_seq OWNED BY public.banks.id;


--
-- Name: bond_has_employee; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.bond_has_employee (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    date_assigned date NOT NULL,
    date_limit date NOT NULL,
    employment_record_id integer,
    bond_id integer
);


ALTER TABLE public.bond_has_employee OWNER TO esc;

--
-- Name: bond_has_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.bond_has_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bond_has_employee_id_seq OWNER TO esc;

--
-- Name: bond_has_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.bond_has_employee_id_seq OWNED BY public.bond_has_employee.id;


--
-- Name: bonds; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.bonds (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    amount numeric(10,2) NOT NULL,
    type_id integer,
    description_id integer
);


ALTER TABLE public.bonds OWNER TO esc;

--
-- Name: bonds_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.bonds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bonds_id_seq OWNER TO esc;

--
-- Name: bonds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.bonds_id_seq OWNED BY public.bonds.id;


--
-- Name: brand; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.brand (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(100) NOT NULL
);


ALTER TABLE public.brand OWNER TO esc;

--
-- Name: brand_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.brand_id_seq OWNER TO esc;

--
-- Name: brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.brand_id_seq OWNED BY public.brand.id;


--
-- Name: clasification; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.clasification (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(100) NOT NULL
);


ALTER TABLE public.clasification OWNER TO esc;

--
-- Name: clasification_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.clasification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clasification_id_seq OWNER TO esc;

--
-- Name: clasification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.clasification_id_seq OWNED BY public.clasification.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(100) NOT NULL,
    abreviation character varying(10)
);


ALTER TABLE public.departments OWNER TO esc;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_id_seq OWNER TO esc;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: description_bonds; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.description_bonds (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    description character varying(100) NOT NULL
);


ALTER TABLE public.description_bonds OWNER TO esc;

--
-- Name: description_bonds_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.description_bonds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.description_bonds_id_seq OWNER TO esc;

--
-- Name: description_bonds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.description_bonds_id_seq OWNED BY public.description_bonds.id;


--
-- Name: dismissal; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.dismissal (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    comment text NOT NULL,
    reason text NOT NULL,
    date date NOT NULL,
    employee_id integer
);


ALTER TABLE public.dismissal OWNER TO esc;

--
-- Name: dismissal_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.dismissal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dismissal_id_seq OWNER TO esc;

--
-- Name: dismissal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.dismissal_id_seq OWNED BY public.dismissal.id;


--
-- Name: document; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.document (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    url_file text NOT NULL,
    size integer DEFAULT 0,
    name character varying(100) NOT NULL,
    type_id integer,
    employee_id integer
);


ALTER TABLE public.document OWNER TO esc;

--
-- Name: document_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.document_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.document_id_seq OWNER TO esc;

--
-- Name: document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.document_id_seq OWNED BY public.document.id;


--
-- Name: emails; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.emails (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    email character varying(100) NOT NULL,
    status boolean DEFAULT false NOT NULL,
    required_access boolean DEFAULT false NOT NULL,
    user_id integer,
    employee_id integer
);


ALTER TABLE public.emails OWNER TO esc;

--
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.emails_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.emails_id_seq OWNER TO esc;

--
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.emails_id_seq OWNED BY public.emails.id;


--
-- Name: employee_has_attendancePermission; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public."employee_has_attendancePermission" (
    attendance_permission_id integer NOT NULL,
    employment_record_id integer NOT NULL
);


ALTER TABLE public."employee_has_attendancePermission" OWNER TO esc;

--
-- Name: employee_has_positions; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.employee_has_positions (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    employee_id integer,
    position_id integer
);


ALTER TABLE public.employee_has_positions OWNER TO esc;

--
-- Name: employee_has_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.employee_has_positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_has_positions_id_seq OWNER TO esc;

--
-- Name: employee_has_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.employee_has_positions_id_seq OWNED BY public.employee_has_positions.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    names character varying(100) NOT NULL,
    first_last_name character varying(100) NOT NULL,
    second_last_name character varying(100),
    date_birth date NOT NULL,
    year_old integer NOT NULL,
    gender public.employees_gender_enum NOT NULL,
    curp character varying(18) NOT NULL,
    rfc character varying(13) NOT NULL,
    nss character varying(11) NOT NULL,
    ine_number character varying(13) NOT NULL,
    alergy character varying(200),
    nacionality public.employees_nacionality_enum DEFAULT 'Mexicana'::public.employees_nacionality_enum NOT NULL,
    status public.employees_status_enum DEFAULT 'ACTIVE'::public.employees_status_enum NOT NULL,
    blood_type public.employees_blood_type_enum
);


ALTER TABLE public.employees OWNER TO esc;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_id_seq OWNER TO esc;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: employment_record; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.employment_record (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    date_register date NOT NULL,
    date_end date,
    reason text,
    comment text,
    email character varying(100) NOT NULL,
    telephone character varying(15),
    address character varying(200),
    emergency_contact json,
    status_civil public.employment_record_status_civil_enum,
    number_account_bank character varying(20),
    type_contract_id integer,
    bank_id integer,
    "employeeId" integer
);


ALTER TABLE public.employment_record OWNER TO esc;

--
-- Name: employment_record_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.employment_record_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employment_record_id_seq OWNER TO esc;

--
-- Name: employment_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.employment_record_id_seq OWNED BY public.employment_record.id;


--
-- Name: extension; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.extension (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    number_expedients integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    project_id integer
);


ALTER TABLE public.extension OWNER TO esc;

--
-- Name: extension_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.extension_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.extension_id_seq OWNER TO esc;

--
-- Name: extension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.extension_id_seq OWNED BY public.extension.id;


--
-- Name: habilitations; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.habilitations (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    fecha timestamp with time zone,
    name character varying NOT NULL,
    "isRed" boolean DEFAULT false NOT NULL,
    "isLuz" boolean DEFAULT false NOT NULL,
    "isExtra" boolean DEFAULT false NOT NULL,
    "singClient" character varying(255) NOT NULL
);


ALTER TABLE public.habilitations OWNER TO esc;

--
-- Name: habilitations_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.habilitations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.habilitations_id_seq OWNER TO esc;

--
-- Name: habilitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.habilitations_id_seq OWNED BY public.habilitations.id;


--
-- Name: headquarters; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.headquarters (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(100) NOT NULL,
    address character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    postal_code character varying(6) DEFAULT '0'::character varying NOT NULL,
    phone character varying(15),
    start_date date NOT NULL,
    end_date date NOT NULL,
    production_days integer DEFAULT 0 NOT NULL,
    number_expedients integer NOT NULL,
    sum_productions integer DEFAULT 0 NOT NULL,
    status character varying DEFAULT 'EVALUATION'::character varying NOT NULL,
    project_id integer
);


ALTER TABLE public.headquarters OWNER TO esc;

--
-- Name: headquarters_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.headquarters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.headquarters_id_seq OWNER TO esc;

--
-- Name: headquarters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.headquarters_id_seq OWNED BY public.headquarters.id;


--
-- Name: headquarters_position_quota; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.headquarters_position_quota (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    max_employee integer DEFAULT 0 NOT NULL,
    position_id integer NOT NULL,
    headquarter_id integer
);


ALTER TABLE public.headquarters_position_quota OWNER TO esc;

--
-- Name: headquarters_position_quota_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.headquarters_position_quota_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.headquarters_position_quota_id_seq OWNER TO esc;

--
-- Name: headquarters_position_quota_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.headquarters_position_quota_id_seq OWNED BY public.headquarters_position_quota.id;


--
-- Name: holidays; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.holidays (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    holiday_date date NOT NULL,
    description character varying(255)
);


ALTER TABLE public.holidays OWNER TO esc;

--
-- Name: holidays_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.holidays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.holidays_id_seq OWNER TO esc;

--
-- Name: holidays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.holidays_id_seq OWNED BY public.holidays.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.images (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    path text NOT NULL,
    originalname text NOT NULL,
    mimetype text DEFAULT ''::text NOT NULL,
    size double precision DEFAULT '0'::double precision
);


ALTER TABLE public.images OWNER TO esc;

--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.images_id_seq OWNER TO esc;

--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: inspections; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.inspections (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    fecha timestamp with time zone,
    "statusEquipo" character varying NOT NULL,
    "isClean" boolean DEFAULT false NOT NULL,
    "isDepuracion" boolean DEFAULT false NOT NULL,
    "isDesfragment" boolean DEFAULT false NOT NULL,
    "statusTerminales" boolean DEFAULT false NOT NULL,
    "singClient" character varying(255) NOT NULL,
    "isConection" boolean NOT NULL,
    "isVirus" boolean NOT NULL,
    "Comments" text NOT NULL
);


ALTER TABLE public.inspections OWNER TO esc;

--
-- Name: inspections_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.inspections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inspections_id_seq OWNER TO esc;

--
-- Name: inspections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.inspections_id_seq OWNED BY public.inspections.id;


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.inventory (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "idName" character varying(100),
    "serialNumber" character varying(100),
    user_id integer,
    status public.inventory_status_enum,
    "stateId" integer,
    "resourceId" integer,
    "ubicationsId" integer
);


ALTER TABLE public.inventory OWNER TO esc;

--
-- Name: inventory_has_add_removal; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.inventory_has_add_removal (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "inventoryId" integer,
    "addRemovalId" integer
);


ALTER TABLE public.inventory_has_add_removal OWNER TO esc;

--
-- Name: inventory_has_add_removal_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.inventory_has_add_removal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_has_add_removal_id_seq OWNER TO esc;

--
-- Name: inventory_has_add_removal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.inventory_has_add_removal_id_seq OWNED BY public.inventory_has_add_removal.id;


--
-- Name: inventory_has_assigment; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.inventory_has_assigment (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    type public.inventory_has_assigment_type_enum,
    "inventoryId" integer,
    "assignmentsReturnsId" integer
);


ALTER TABLE public.inventory_has_assigment OWNER TO esc;

--
-- Name: inventory_has_assigment_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.inventory_has_assigment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_has_assigment_id_seq OWNER TO esc;

--
-- Name: inventory_has_assigment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.inventory_has_assigment_id_seq OWNED BY public.inventory_has_assigment.id;


--
-- Name: inventory_has_habilitations; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.inventory_has_habilitations (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "inventoryId" integer,
    "habilitationsId" integer
);


ALTER TABLE public.inventory_has_habilitations OWNER TO esc;

--
-- Name: inventory_has_habilitations_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.inventory_has_habilitations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_has_habilitations_id_seq OWNER TO esc;

--
-- Name: inventory_has_habilitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.inventory_has_habilitations_id_seq OWNED BY public.inventory_has_habilitations.id;


--
-- Name: inventory_has_inspections; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.inventory_has_inspections (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "inspectionsId" integer,
    "inventoryId" integer
);


ALTER TABLE public.inventory_has_inspections OWNER TO esc;

--
-- Name: inventory_has_inspections_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.inventory_has_inspections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_has_inspections_id_seq OWNER TO esc;

--
-- Name: inventory_has_inspections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.inventory_has_inspections_id_seq OWNED BY public.inventory_has_inspections.id;


--
-- Name: inventory_has_maintenances; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.inventory_has_maintenances (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    observations character varying NOT NULL,
    "startDate" timestamp with time zone,
    "endDate" timestamp with time zone,
    description text,
    observation text,
    "maintenanceType" public.inventory_has_maintenances_maintenancetype_enum DEFAULT 'PREVENTIVO'::public.inventory_has_maintenances_maintenancetype_enum NOT NULL,
    status public.inventory_has_maintenances_status_enum DEFAULT 'EN_ALMACEN'::public.inventory_has_maintenances_status_enum NOT NULL,
    "maintenancesId" integer,
    "inventoryId" integer
);


ALTER TABLE public.inventory_has_maintenances OWNER TO esc;

--
-- Name: inventory_has_maintenances_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.inventory_has_maintenances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_has_maintenances_id_seq OWNER TO esc;

--
-- Name: inventory_has_maintenances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.inventory_has_maintenances_id_seq OWNED BY public.inventory_has_maintenances.id;


--
-- Name: inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_id_seq OWNER TO esc;

--
-- Name: inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.inventory_id_seq OWNED BY public.inventory.id;


--
-- Name: maintenances; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.maintenances (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    observations character varying NOT NULL,
    "startDate" timestamp with time zone,
    "endDate" timestamp with time zone,
    description text,
    observation text,
    "maintenanceType" public.maintenances_maintenancetype_enum DEFAULT 'PREVENTIVO'::public.maintenances_maintenancetype_enum NOT NULL,
    status public.maintenances_status_enum DEFAULT 'EN_ALMACEN'::public.maintenances_status_enum NOT NULL
);


ALTER TABLE public.maintenances OWNER TO esc;

--
-- Name: maintenances_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.maintenances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.maintenances_id_seq OWNER TO esc;

--
-- Name: maintenances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.maintenances_id_seq OWNED BY public.maintenances.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.migrations OWNER TO esc;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO esc;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: model; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.model (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(100) NOT NULL,
    "brandId" integer
);


ALTER TABLE public.model OWNER TO esc;

--
-- Name: model_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.model_id_seq OWNER TO esc;

--
-- Name: model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.model_id_seq OWNED BY public.model.id;


--
-- Name: module; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.module (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(100) NOT NULL,
    description character varying(100) DEFAULT ''::character varying
);


ALTER TABLE public.module OWNER TO esc;

--
-- Name: module_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.module_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.module_id_seq OWNER TO esc;

--
-- Name: module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.module_id_seq OWNED BY public.module.id;


--
-- Name: permission; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.permission (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(100) NOT NULL,
    description character varying(100) DEFAULT ''::character varying
);


ALTER TABLE public.permission OWNER TO esc;

--
-- Name: permission_has_module; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.permission_has_module (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    permission_id integer,
    module_id integer
);


ALTER TABLE public.permission_has_module OWNER TO esc;

--
-- Name: permission_has_module_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.permission_has_module_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permission_has_module_id_seq OWNER TO esc;

--
-- Name: permission_has_module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.permission_has_module_id_seq OWNED BY public.permission_has_module.id;


--
-- Name: permission_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permission_id_seq OWNER TO esc;

--
-- Name: permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.permission_id_seq OWNED BY public.permission.id;


--
-- Name: positions; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.positions (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "requiredBoss" boolean DEFAULT false NOT NULL,
    name character varying(100) NOT NULL,
    salary_id integer NOT NULL,
    department_id integer,
    "parentId" integer
);


ALTER TABLE public.positions OWNER TO esc;

--
-- Name: positions_closure; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.positions_closure (
    id_ancestor integer NOT NULL,
    id_descendant integer NOT NULL
);


ALTER TABLE public.positions_closure OWNER TO esc;

--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.positions_id_seq OWNER TO esc;

--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.positions_id_seq OWNED BY public.positions.id;


--
-- Name: presences; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.presences (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    date date NOT NULL,
    check_in time without time zone,
    check_out time without time zone,
    reason character varying DEFAULT 'PRESENCE'::character varying NOT NULL,
    staff_id integer
);


ALTER TABLE public.presences OWNER TO esc;

--
-- Name: presences_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.presences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.presences_id_seq OWNER TO esc;

--
-- Name: presences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.presences_id_seq OWNED BY public.presences.id;


--
-- Name: profile_has_modulePermission; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public."profile_has_modulePermission" (
    "permissionHasModuleId" integer NOT NULL,
    "profilesId" integer NOT NULL
);


ALTER TABLE public."profile_has_modulePermission" OWNER TO esc;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.profiles (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(50) DEFAULT ''::character varying NOT NULL,
    saved boolean DEFAULT false NOT NULL
);


ALTER TABLE public.profiles OWNER TO esc;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profiles_id_seq OWNER TO esc;

--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "isExternal" boolean DEFAULT false NOT NULL,
    contract_number character varying(50) DEFAULT ''::character varying NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(100) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    number_expedients integer,
    number_images integer DEFAULT 0 NOT NULL,
    productions_days integer NOT NULL,
    sum_productions integer NOT NULL,
    status character varying DEFAULT 'EVALUATION'::character varying NOT NULL
);


ALTER TABLE public.projects OWNER TO esc;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projects_id_seq OWNER TO esc;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: report_type; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.report_type (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(80) NOT NULL
);


ALTER TABLE public.report_type OWNER TO esc;

--
-- Name: report_type_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.report_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.report_type_id_seq OWNER TO esc;

--
-- Name: report_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.report_type_id_seq OWNED BY public.report_type.id;


--
-- Name: resource; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.resource (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(100) NOT NULL,
    quatity integer DEFAULT 0,
    especifications text,
    description text,
    type public.resource_type_enum,
    "clasificationId" integer,
    "modelId" integer
);


ALTER TABLE public.resource OWNER TO esc;

--
-- Name: resource_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resource_id_seq OWNER TO esc;

--
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.resource_id_seq OWNED BY public.resource.id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.role (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    type character varying NOT NULL
);


ALTER TABLE public.role OWNER TO esc;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_id_seq OWNER TO esc;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- Name: salary; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.salary (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    amount money NOT NULL,
    salary_in_words character varying(100) NOT NULL
);


ALTER TABLE public.salary OWNER TO esc;

--
-- Name: salary_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.salary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.salary_id_seq OWNER TO esc;

--
-- Name: salary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.salary_id_seq OWNED BY public.salary.id;


--
-- Name: signature; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.signature (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    type_signature_id integer,
    staff_id integer
);


ALTER TABLE public.signature OWNER TO esc;

--
-- Name: signature_has_reports; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.signature_has_reports (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    reference integer NOT NULL,
    "signatureId" integer,
    type_report_id integer,
    status_application_id integer
);


ALTER TABLE public.signature_has_reports OWNER TO esc;

--
-- Name: signature_has_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.signature_has_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.signature_has_reports_id_seq OWNER TO esc;

--
-- Name: signature_has_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.signature_has_reports_id_seq OWNED BY public.signature_has_reports.id;


--
-- Name: signature_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.signature_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.signature_id_seq OWNER TO esc;

--
-- Name: signature_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.signature_id_seq OWNED BY public.signature.id;


--
-- Name: staff; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.staff (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    employee_has_positions_id integer,
    headquarter_id integer,
    "parentId" integer
);


ALTER TABLE public.staff OWNER TO esc;

--
-- Name: staff_closure; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.staff_closure (
    id_ancestor integer NOT NULL,
    id_descendant integer NOT NULL
);


ALTER TABLE public.staff_closure OWNER TO esc;

--
-- Name: staff_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_id_seq OWNER TO esc;

--
-- Name: staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.staff_id_seq OWNED BY public.staff.id;


--
-- Name: state; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.state (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying NOT NULL
);


ALTER TABLE public.state OWNER TO esc;

--
-- Name: state_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.state_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.state_id_seq OWNER TO esc;

--
-- Name: state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.state_id_seq OWNED BY public.state.id;


--
-- Name: status_application; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.status_application (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    status character varying(50) NOT NULL
);


ALTER TABLE public.status_application OWNER TO esc;

--
-- Name: status_application_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.status_application_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.status_application_id_seq OWNER TO esc;

--
-- Name: status_application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.status_application_id_seq OWNED BY public.status_application.id;


--
-- Name: type_contract; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.type_contract (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    type character varying(100) NOT NULL,
    "isAutomatic" boolean DEFAULT false NOT NULL
);


ALTER TABLE public.type_contract OWNER TO esc;

--
-- Name: type_contract_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.type_contract_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_contract_id_seq OWNER TO esc;

--
-- Name: type_contract_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.type_contract_id_seq OWNED BY public.type_contract.id;


--
-- Name: type_document; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.type_document (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    type character varying(100) NOT NULL
);


ALTER TABLE public.type_document OWNER TO esc;

--
-- Name: type_document_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.type_document_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_document_id_seq OWNER TO esc;

--
-- Name: type_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.type_document_id_seq OWNED BY public.type_document.id;


--
-- Name: type_signature; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.type_signature (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying(50) NOT NULL
);


ALTER TABLE public.type_signature OWNER TO esc;

--
-- Name: type_signature_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.type_signature_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_signature_id_seq OWNER TO esc;

--
-- Name: type_signature_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.type_signature_id_seq OWNED BY public.type_signature.id;


--
-- Name: types_bonds; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.types_bonds (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    type character varying(100) NOT NULL
);


ALTER TABLE public.types_bonds OWNER TO esc;

--
-- Name: types_bonds_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.types_bonds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.types_bonds_id_seq OWNER TO esc;

--
-- Name: types_bonds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.types_bonds_id_seq OWNED BY public.types_bonds.id;


--
-- Name: types_document; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.types_document (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    type character varying(100) NOT NULL
);


ALTER TABLE public.types_document OWNER TO esc;

--
-- Name: types_document_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.types_document_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.types_document_id_seq OWNER TO esc;

--
-- Name: types_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.types_document_id_seq OWNED BY public.types_document.id;


--
-- Name: ubications; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.ubications (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    ubications text NOT NULL
);


ALTER TABLE public.ubications OWNER TO esc;

--
-- Name: ubications_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.ubications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ubications_id_seq OWNER TO esc;

--
-- Name: ubications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.ubications_id_seq OWNED BY public.ubications.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.users (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    username character varying NOT NULL,
    password character varying NOT NULL,
    role_id integer,
    profile_id integer
);


ALTER TABLE public.users OWNER TO esc;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO esc;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vacations; Type: TABLE; Schema: public; Owner: esc
--

CREATE TABLE public.vacations (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    available boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "startDate" date NOT NULL,
    "endDate" date NOT NULL,
    requested_day integer NOT NULL,
    status character varying DEFAULT 'PENDING'::character varying NOT NULL,
    reason text,
    comment text,
    employee_id integer
);


ALTER TABLE public.vacations OWNER TO esc;

--
-- Name: vacations_id_seq; Type: SEQUENCE; Schema: public; Owner: esc
--

CREATE SEQUENCE public.vacations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vacations_id_seq OWNER TO esc;

--
-- Name: vacations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: esc
--

ALTER SEQUENCE public.vacations_id_seq OWNED BY public.vacations.id;


--
-- Name: add_removal id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.add_removal ALTER COLUMN id SET DEFAULT nextval('public.add_removal_id_seq'::regclass);


--
-- Name: admission_has_inventory id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.admission_has_inventory ALTER COLUMN id SET DEFAULT nextval('public.admission_has_inventory_id_seq'::regclass);


--
-- Name: admissions_discharges id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.admissions_discharges ALTER COLUMN id SET DEFAULT nextval('public.admissions_discharges_id_seq'::regclass);


--
-- Name: assignments_returns id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.assignments_returns ALTER COLUMN id SET DEFAULT nextval('public.assignments_returns_id_seq'::regclass);


--
-- Name: attendance_permission id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.attendance_permission ALTER COLUMN id SET DEFAULT nextval('public.attendance_permission_id_seq'::regclass);


--
-- Name: banks id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.banks ALTER COLUMN id SET DEFAULT nextval('public.banks_id_seq'::regclass);


--
-- Name: bond_has_employee id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.bond_has_employee ALTER COLUMN id SET DEFAULT nextval('public.bond_has_employee_id_seq'::regclass);


--
-- Name: bonds id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.bonds ALTER COLUMN id SET DEFAULT nextval('public.bonds_id_seq'::regclass);


--
-- Name: brand id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.brand ALTER COLUMN id SET DEFAULT nextval('public.brand_id_seq'::regclass);


--
-- Name: clasification id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.clasification ALTER COLUMN id SET DEFAULT nextval('public.clasification_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: description_bonds id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.description_bonds ALTER COLUMN id SET DEFAULT nextval('public.description_bonds_id_seq'::regclass);


--
-- Name: dismissal id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.dismissal ALTER COLUMN id SET DEFAULT nextval('public.dismissal_id_seq'::regclass);


--
-- Name: document id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.document ALTER COLUMN id SET DEFAULT nextval('public.document_id_seq'::regclass);


--
-- Name: emails id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.emails ALTER COLUMN id SET DEFAULT nextval('public.emails_id_seq'::regclass);


--
-- Name: employee_has_positions id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employee_has_positions ALTER COLUMN id SET DEFAULT nextval('public.employee_has_positions_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: employment_record id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employment_record ALTER COLUMN id SET DEFAULT nextval('public.employment_record_id_seq'::regclass);


--
-- Name: extension id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.extension ALTER COLUMN id SET DEFAULT nextval('public.extension_id_seq'::regclass);


--
-- Name: habilitations id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.habilitations ALTER COLUMN id SET DEFAULT nextval('public.habilitations_id_seq'::regclass);


--
-- Name: headquarters id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.headquarters ALTER COLUMN id SET DEFAULT nextval('public.headquarters_id_seq'::regclass);


--
-- Name: headquarters_position_quota id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.headquarters_position_quota ALTER COLUMN id SET DEFAULT nextval('public.headquarters_position_quota_id_seq'::regclass);


--
-- Name: holidays id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.holidays ALTER COLUMN id SET DEFAULT nextval('public.holidays_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: inspections id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inspections ALTER COLUMN id SET DEFAULT nextval('public.inspections_id_seq'::regclass);


--
-- Name: inventory id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);


--
-- Name: inventory_has_add_removal id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_add_removal ALTER COLUMN id SET DEFAULT nextval('public.inventory_has_add_removal_id_seq'::regclass);


--
-- Name: inventory_has_assigment id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_assigment ALTER COLUMN id SET DEFAULT nextval('public.inventory_has_assigment_id_seq'::regclass);


--
-- Name: inventory_has_habilitations id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_habilitations ALTER COLUMN id SET DEFAULT nextval('public.inventory_has_habilitations_id_seq'::regclass);


--
-- Name: inventory_has_inspections id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_inspections ALTER COLUMN id SET DEFAULT nextval('public.inventory_has_inspections_id_seq'::regclass);


--
-- Name: inventory_has_maintenances id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_maintenances ALTER COLUMN id SET DEFAULT nextval('public.inventory_has_maintenances_id_seq'::regclass);


--
-- Name: maintenances id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.maintenances ALTER COLUMN id SET DEFAULT nextval('public.maintenances_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: model id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.model ALTER COLUMN id SET DEFAULT nextval('public.model_id_seq'::regclass);


--
-- Name: module id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.module ALTER COLUMN id SET DEFAULT nextval('public.module_id_seq'::regclass);


--
-- Name: permission id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.permission ALTER COLUMN id SET DEFAULT nextval('public.permission_id_seq'::regclass);


--
-- Name: permission_has_module id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.permission_has_module ALTER COLUMN id SET DEFAULT nextval('public.permission_has_module_id_seq'::regclass);


--
-- Name: positions id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.positions ALTER COLUMN id SET DEFAULT nextval('public.positions_id_seq'::regclass);


--
-- Name: presences id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.presences ALTER COLUMN id SET DEFAULT nextval('public.presences_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: report_type id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.report_type ALTER COLUMN id SET DEFAULT nextval('public.report_type_id_seq'::regclass);


--
-- Name: resource id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.resource ALTER COLUMN id SET DEFAULT nextval('public.resource_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- Name: salary id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.salary ALTER COLUMN id SET DEFAULT nextval('public.salary_id_seq'::regclass);


--
-- Name: signature id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.signature ALTER COLUMN id SET DEFAULT nextval('public.signature_id_seq'::regclass);


--
-- Name: signature_has_reports id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.signature_has_reports ALTER COLUMN id SET DEFAULT nextval('public.signature_has_reports_id_seq'::regclass);


--
-- Name: staff id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.staff ALTER COLUMN id SET DEFAULT nextval('public.staff_id_seq'::regclass);


--
-- Name: state id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.state ALTER COLUMN id SET DEFAULT nextval('public.state_id_seq'::regclass);


--
-- Name: status_application id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.status_application ALTER COLUMN id SET DEFAULT nextval('public.status_application_id_seq'::regclass);


--
-- Name: type_contract id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.type_contract ALTER COLUMN id SET DEFAULT nextval('public.type_contract_id_seq'::regclass);


--
-- Name: type_document id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.type_document ALTER COLUMN id SET DEFAULT nextval('public.type_document_id_seq'::regclass);


--
-- Name: type_signature id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.type_signature ALTER COLUMN id SET DEFAULT nextval('public.type_signature_id_seq'::regclass);


--
-- Name: types_bonds id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.types_bonds ALTER COLUMN id SET DEFAULT nextval('public.types_bonds_id_seq'::regclass);


--
-- Name: types_document id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.types_document ALTER COLUMN id SET DEFAULT nextval('public.types_document_id_seq'::regclass);


--
-- Name: ubications id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.ubications ALTER COLUMN id SET DEFAULT nextval('public.ubications_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vacations id; Type: DEFAULT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.vacations ALTER COLUMN id SET DEFAULT nextval('public.vacations_id_seq'::regclass);


--
-- Data for Name: add_removal; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.add_removal (id, created_at, available, updated_at, deleted_at, motive, observations, type, factura) FROM stdin;
\.


--
-- Data for Name: admission_has_inventory; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.admission_has_inventory (id, created_at, available, updated_at, deleted_at, status, "inventoryId", "admissionsDischargesId") FROM stdin;
\.


--
-- Data for Name: admissions_discharges; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.admissions_discharges (id, created_at, available, updated_at, deleted_at, reason, observations, date, project_id, user_id, type) FROM stdin;
\.


--
-- Data for Name: assignments_returns; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.assignments_returns (id, created_at, available, updated_at, deleted_at, date, comments, user_id, type, project_id) FROM stdin;
\.


--
-- Data for Name: attendance_permission; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.attendance_permission (id, created_at, available, updated_at, deleted_at, permission_type, start_date, end_date, reason, status, requested_at, approved_by, approved_at) FROM stdin;
\.


--
-- Data for Name: banks; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.banks (id, created_at, available, updated_at, deleted_at, name) FROM stdin;
1	2025-07-08 16:23:53.602	t	2025-07-08 16:23:53.602	\N	BANORTE
2	2025-07-08 16:23:57.784	t	2025-07-08 16:23:57.784	\N	HSBC
3	2025-07-08 16:24:09.764	t	2025-07-08 16:24:09.764	\N	BANAMEX
4	2025-07-08 16:24:15.642	t	2025-07-08 16:24:15.642	\N	BBVA
\.


--
-- Data for Name: bond_has_employee; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.bond_has_employee (id, created_at, available, updated_at, deleted_at, date_assigned, date_limit, employment_record_id, bond_id) FROM stdin;
\.


--
-- Data for Name: bonds; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.bonds (id, created_at, available, updated_at, deleted_at, amount, type_id, description_id) FROM stdin;
\.


--
-- Data for Name: brand; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.brand (id, created_at, available, updated_at, deleted_at, name) FROM stdin;
\.


--
-- Data for Name: clasification; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.clasification (id, created_at, available, updated_at, deleted_at, name) FROM stdin;
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.departments (id, created_at, available, updated_at, deleted_at, name, abreviation) FROM stdin;
6	2025-08-01 18:12:32.406	t	2025-08-01 18:12:32.406	\N	DIRECCIÓN GENERAL	DG
7	2025-08-01 18:14:50.577	t	2025-08-01 18:14:50.577	\N	TECNOLOGÍAS	TIC
8	2025-08-01 18:15:17.448	t	2025-08-01 18:15:17.448	\N	NORMATIVIDAD Y PROCESOS	N. Y P.
9	2025-08-01 18:24:16.999	t	2025-08-01 18:24:16.999	\N	FINANZAS	FINANC
10	2025-08-01 18:24:36.017	t	2025-08-01 18:24:36.017	\N	ADMINISTRACIÓN	ADMÓN
11	2025-08-01 18:24:53.452	t	2025-08-01 18:24:53.452	\N	OPERACIONES	OPS
12	2025-08-01 18:25:10.954	t	2025-08-01 18:25:10.954	\N	PROYECTOS	PROY
\.


--
-- Data for Name: description_bonds; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.description_bonds (id, created_at, available, updated_at, deleted_at, description) FROM stdin;
\.


--
-- Data for Name: dismissal; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.dismissal (id, created_at, available, updated_at, deleted_at, comment, reason, date, employee_id) FROM stdin;
\.


--
-- Data for Name: document; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.document (id, created_at, available, updated_at, deleted_at, url_file, size, name, type_id, employee_id) FROM stdin;
\.


--
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.emails (id, created_at, available, updated_at, deleted_at, email, status, required_access, user_id, employee_id) FROM stdin;
64	2025-09-16 10:11:43.01815	t	2025-09-16 10:11:43.01815	\N	rh@empresaejemplo.com.mx	f	t	\N	88
\.


--
-- Data for Name: employee_has_attendancePermission; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public."employee_has_attendancePermission" (attendance_permission_id, employment_record_id) FROM stdin;
\.


--
-- Data for Name: employee_has_positions; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.employee_has_positions (id, created_at, available, updated_at, deleted_at, employee_id, position_id) FROM stdin;
25	2025-09-16 10:11:43.01815	t	2025-09-16 10:11:43.01815	\N	32	60
1	2025-09-15 16:29:09.482281	t	2025-09-15 16:29:09.482281	\N	1	37
2	2025-09-15 16:29:35.768279	t	2025-09-15 16:29:35.768279	\N	2	38
3	2025-09-15 16:29:35.776617	t	2025-09-15 16:29:35.776617	\N	3	39
4	2025-09-15 16:29:35.77998	t	2025-09-15 16:29:35.77998	\N	5	41
5	2025-09-15 16:29:35.78173	t	2025-09-15 16:29:35.78173	\N	6	42
6	2025-09-15 16:29:35.783238	t	2025-09-15 16:29:35.783238	\N	7	43
7	2025-09-15 16:29:35.786082	t	2025-09-15 16:29:35.786082	\N	8	44
8	2025-09-15 16:29:35.787615	t	2025-09-15 16:29:35.787615	\N	9	45
9	2025-09-15 16:30:27.920428	t	2025-09-15 16:30:27.920428	\N	10	47
10	2025-09-15 16:30:27.925749	t	2025-09-15 16:30:27.925749	\N	11	48
11	2025-09-15 16:30:27.927994	t	2025-09-15 16:30:27.927994	\N	12	49
12	2025-09-15 16:30:27.932991	t	2025-09-15 16:30:27.932991	\N	15	52
13	2025-09-15 16:30:27.934265	t	2025-09-15 16:30:27.934265	\N	16	53
14	2025-09-15 16:30:27.935544	t	2025-09-15 16:30:27.935544	\N	17	54
15	2025-09-15 16:30:27.936778	t	2025-09-15 16:30:27.936778	\N	18	55
16	2025-09-15 16:31:26.848332	t	2025-09-15 16:31:26.848332	\N	19	56
17	2025-09-15 16:31:26.856342	t	2025-09-15 16:31:26.856342	\N	20	57
18	2025-09-15 16:31:26.857957	t	2025-09-15 16:31:26.857957	\N	21	58
19	2025-09-15 16:31:26.859227	t	2025-09-15 16:31:26.859227	\N	22	59
20	2025-09-15 16:31:26.860276	t	2025-09-15 16:31:26.860276	\N	23	60
21	2025-09-15 16:31:26.861141	t	2025-09-15 16:31:26.861141	\N	24	61
22	2025-09-15 16:30:27.929797	t	2025-09-15 16:30:27.929797	\N	13	56
23	2025-09-15 16:30:27.931628	t	2025-09-15 16:30:27.931628	\N	14	57
24	2025-09-15 16:29:35.77838	t	2025-09-15 16:29:35.77838	\N	4	58
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.employees (id, created_at, available, updated_at, deleted_at, names, first_last_name, second_last_name, date_birth, year_old, gender, curp, rfc, nss, ine_number, alergy, nacionality, status, blood_type) FROM stdin;
3	2025-07-08 16:47:13.814	t	2025-07-08 16:47:13.814	\N	María	Sánchez	Pérez	1990-07-30	34	Femenino	SAPE900730MDFRRS9	SAPE9007302H7	45678901234	C3456789012	Gluten	Mexicana	INACTIVE	B-
5	2025-07-08 16:49:07.287	t	2025-07-08 16:49:07.287	\N	Luis	Martínez	Gómez	1988-11-02	36	Masculino	MAGO881102HDFMNR6	MAGO8811022E5	76543210987	E5678901234	Ninguna	Mexicana	ACTIVE	O-
6	2025-07-08 16:49:21.799	t	2025-07-08 16:49:21.799	\N	Juan	Hernández	López	2000-12-18	24	Masculino	HELO001218HDFNNN3	HELO0012181D6	23456789012	F6789012345	Cacahuates	Mexicana	ACTIVE	O+
7	2025-07-15 17:59:40.083446	t	2025-07-15 17:59:40.083446	\N	Carl	First	Second	1993-03-22	31	Masculino	GORA930322HDFNRR5	GORA9303221I8	98765432101	B2345678901	Pollen	Mexicana	ACTIVE	A+
1	2025-07-08 16:45:19.77	t	2025-07-08 16:45:19.77	\N	Alberto	Vincenso	Casano	1997-10-15	27	Masculino	PEJ90515HDFGRR0	PEJJ9012151F9	12345678901	A1234567890	Ninguna	Mexicana	ACTIVE	O+
2	2025-07-08 16:47:00.092	t	2025-07-08 16:47:00.092	\N	Carlos	González	Ramírez	1993-03-22	31	Masculino	GORA930322HDFNRR5	GORA9303221I8	98765432101	B2345678901	Pollen	Mexicana	ACTIVE	A+
8	2025-07-14 19:29:18.803379	t	2025-07-30 20:59:29.917992	\N	Juan	Hernández	López	2000-12-18	24	Masculino	HELO001218HDFNNN3	HELO0012181D6	23456789012	F6789012345	Cacahuates	Mexicana	ACTIVE	O+
9	2025-07-31 15:42:59.996617	t	2025-07-31 15:42:59.996617	\N	Juan carlos	Ramírez	López	1990-05-14	35	Masculino	RALJ900514HDFMPN01	RALJ900514ABC	98765432100	0100020003004	Ninguna	Mexicana	ACTIVE	A+
4	2025-07-08 16:47:59.287	t	2025-07-08 16:47:59.287	\N	Ana	Morales	Torres	1995-09-10	29	Femenino	MOTA950910MDFRRR2	MOTA9509103C7	65432109876	D4567890123	Lactosa	Mexicana	ACTIVE	AB+
10	2025-07-09 09:15:23	t	2025-07-09 09:15:23	\N	Laura	Mendoza	Salinas	1989-05-12	36	Femenino	MESL890512MPLNRL6	MESL8905123A2	34567890123	C3456789012	Penicilina	Mexicana	ACTIVE	B+
11	2025-07-09 10:02:45	t	2025-07-09 10:02:45	\N	José	Martínez	Lozano	1990-08-30	35	Masculino	MALJ900830HDFRZS3	MALJ9008304K3	45678901234	D4567890123	Ninguna	Mexicana	ACTIVE	O-
12	2025-07-10 08:30:10	t	2025-07-10 08:30:10	\N	Paola	Hernández	Ruiz	1995-01-18	30	Femenino	HERP950118MDFRZL5	HERP9501187Z8	56789012345	E5678901234	Mariscos	Mexicana	ACTIVE	AB+
13	2025-07-10 09:55:45	t	2025-07-10 09:55:45	\N	Luis	Torres	Gómez	1985-09-14	40	Masculino	TOGL850914HJCMSL2	TOGL8509149T1	67890123456	F6789012345	Lácteos	Mexicana	ACTIVE	A-
14	2025-07-11 11:22:33	t	2025-07-11 11:22:33	\N	María	López	Valdez	1998-02-25	27	Femenino	LOVM980225GGTPLR1	LOVM9802253A5	78901234567	G7890123456	Ninguna	Mexicana	ACTIVE	O+
15	2025-07-11 13:40:19	t	2025-07-11 13:40:19	\N	Fernando	Ramírez	Zavala	1992-06-10	33	Masculino	RAZF920610HDFMNR3	RAZF9206106P2	89012345678	H8901234567	Picaduras de abeja	Mexicana	ACTIVE	B-
16	2025-07-12 08:18:55	t	2025-07-12 08:18:55	\N	Sandra	Navarro	Esquivel	1988-11-05	36	Femenino	NAES881105NLNSNR7	NAES8811059W3	90123456789	I9012345678	Gluten	Mexicana	ACTIVE	A+
17	2025-07-13 15:47:12	t	2025-07-13 15:47:12	\N	Ricardo	Sánchez	Pineda	1996-04-08	29	Masculino	SAPR960408HQTRND1	SAPR9604081M6	91234567890	J9123456789	Ninguna	Mexicana	ACTIVE	O-
18	2025-07-13 17:05:30	t	2025-07-13 17:05:30	\N	Daniela	Vega	Montiel	1994-12-03	30	Femenino	VEMD941203MDFNRN3	VEMD9412032Q9	92345678901	K9234567890	Ninguna	Mexicana	ACTIVE	AB-
19	2025-07-14 09:30:00	t	2025-07-14 09:30:00	\N	Héctor	Cruz	Delgado	1987-07-22	38	Masculino	CUDH870722YCTRRD2	CUDH8707227H7	93456789012	L9345678901	Polvo	Mexicana	ACTIVE	B+
20	2025-09-12 10:15:00	t	2025-09-12 10:15:00	\N	Isabel	Durán	Molina	1992-06-01	33	Femenino	DUMI920601MDFRLS3	DUMI9206016Z3	12378945601	M1237894560	Ninguna	Mexicana	ACTIVE	O+
21	2025-09-12 10:20:00	t	2025-09-12 10:20:00	\N	Gerardo	Vargas	Nieto	1990-11-17	34	Masculino	VANG901117HTLRTR1	VANG9011172P1	23456789012	N2345678901	Aspirina	Mexicana	ACTIVE	A+
22	2025-09-12 10:25:00	t	2025-09-12 10:25:00	\N	Tatiana	Gómez	Reyes	1988-03-11	37	Femenino	GORT880311MDFRYS5	GORT8803117D4	34567890123	O3456789012	Ninguna	Mexicana	ACTIVE	B+
23	2025-09-12 10:30:00	t	2025-09-12 10:30:00	\N	Iván	Pérez	Castillo	1995-12-19	29	Masculino	PECI951219HSLRST3	PECI9512191F2	45678901234	P4567890123	Lácteos	Mexicana	ACTIVE	AB-
24	2025-09-12 10:35:00	t	2025-09-12 10:35:00	\N	Camila	Ríos	Fernández	1999-01-07	26	Femenino	RIFC990107MQTRMN8	RIFC9901079K6	56789012345	Q5678901234	Polvo	Mexicana	ACTIVE	O-
88	2025-09-16 10:11:43.01815	t	2025-09-16 10:11:43.01815	\N	Laura	Gómez	Ramírez	1998-07-22	27	Femenino	GORL980722MNLLMR07	GORL9807221H5	34567890123	G9012345678	Ninguna	Mexicana	ACTIVE	A+
\.


--
-- Data for Name: employment_record; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.employment_record (id, created_at, available, updated_at, deleted_at, date_register, date_end, reason, comment, email, telephone, address, emergency_contact, status_civil, number_account_bank, type_contract_id, bank_id, "employeeId") FROM stdin;
1	2025-09-15 16:10:52.733005	t	2025-09-15 16:10:52.733005	\N	2020-04-25	\N	a	\N	albertovc@cts.com	555-1234-5678	Calle ficticia 123, ciudad, estado	[{"name":"Jhon Doe","relationship":"Padre","phone":"+525598765431"}]	Soltero/a	123456789123456	3	2	1
2	2025-09-15 16:12:11.389193	t	2025-09-15 16:12:11.389193	\N	2021-07-12	\N	a	\N	carlosgr@cts.com	555-9876-5432	Av. reforma 456, ciudad, estado	[{"name":"María González","relationship":"Madre","phone":"+525558765432"}]	Casado/a	234567890123456	2	3	2
3	2025-09-15 16:15:20.996325	t	2025-09-15 16:15:20.996325	\N	2019-11-05	\N	a	\N	marias@cts.com	555-3456-7890	Calle libertad 789, ciudad, estado	[{"name":"Ana Sánchez","relationship":"Hermana","phone":"+525512345678"}]	Divorciado/a	345678901234567	1	1	3
4	2025-09-15 16:15:21.005341	t	2025-09-15 16:15:21.005341	\N	2022-02-18	\N	a	\N	anam@cts.com	555-5678-1234	Paseo de la reforma 101, ciudad, estado	[{"name":"Luis Morales","relationship":"Esposo","phone":"+525589876543"}]	Casado/a	456789012345678	3	2	4
5	2025-09-15 16:17:03.890006	t	2025-09-15 16:17:03.890006	\N	2023-01-14	\N	a	\N	luism@cts.com	555-8765-4321	Calle mayor 12, ciudad, estado	[{"name":"Laura Martínez","relationship":"Hermana","phone":"+525597654321"}]	Soltero/a	567890123456789	2	3	5
6	2025-09-15 16:20:01.100001	t	2025-09-15 16:20:01.100001	\N	2020-01-15	\N	a	\N	correo6@cts.com	555-1000-0006	Calle Reforma 6, Ciudad MX	[{"name":"Contacto6","relationship":"Hermano","phone":"+525510000006"}]	Soltero/a	600000000000006	1	1	6
7	2025-09-15 16:20:01.200002	t	2025-09-15 16:20:01.200002	\N	2020-02-15	\N	a	\N	correo7@cts.com	555-1000-0007	Calle Reforma 7, Ciudad MX	[{"name":"Contacto7","relationship":"Padre","phone":"+525510000007"}]	Casado/a	700000000000007	2	2	7
8	2025-09-15 16:20:01.300003	t	2025-09-15 16:20:01.300003	\N	2020-03-15	\N	a	\N	correo8@cts.com	555-1000-0008	Calle Reforma 8, Ciudad MX	[{"name":"Contacto8","relationship":"Madre","phone":"+525510000008"}]	Divorciado/a	800000000000008	3	3	8
9	2025-09-15 16:20:01.400004	t	2025-09-15 16:20:01.400004	\N	2020-04-15	\N	a	\N	correo9@cts.com	555-1000-0009	Calle Reforma 9, Ciudad MX	[{"name":"Contacto9","relationship":"Amigo","phone":"+525510000009"}]	Soltero/a	900000000000009	1	4	9
10	2025-09-15 16:20:01.500005	t	2025-09-15 16:20:01.500005	\N	2020-05-15	\N	a	\N	correo10@cts.com	555-1000-0010	Calle Reforma 10, Ciudad MX	[{"name":"Contacto10","relationship":"Hermana","phone":"+525510000010"}]	Casado/a	1000000000000010	2	1	10
11	2025-09-15 16:20:01.600006	t	2025-09-15 16:20:01.600006	\N	2020-06-15	\N	a	\N	correo11@cts.com	555-1000-0011	Calle Reforma 11, Ciudad MX	[{"name":"Contacto11","relationship":"Padre","phone":"+525510000011"}]	Divorciado/a	1100000000000011	3	2	11
12	2025-09-15 16:20:01.700007	t	2025-09-15 16:20:01.700007	\N	2020-07-15	\N	a	\N	correo12@cts.com	555-1000-0012	Calle Reforma 12, Ciudad MX	[{"name":"Contacto12","relationship":"Madre","phone":"+525510000012"}]	Soltero/a	1200000000000012	1	3	12
13	2025-09-15 16:20:01.800008	t	2025-09-15 16:20:01.800008	\N	2020-08-15	\N	a	\N	correo13@cts.com	555-1000-0013	Calle Reforma 13, Ciudad MX	[{"name":"Contacto13","relationship":"Amigo","phone":"+525510000013"}]	Casado/a	1300000000000013	2	4	13
14	2025-09-15 16:20:01.900009	t	2025-09-15 16:20:01.900009	\N	2020-09-15	\N	a	\N	correo14@cts.com	555-1000-0014	Calle Reforma 14, Ciudad MX	[{"name":"Contacto14","relationship":"Hermano","phone":"+525510000014"}]	Divorciado/a	1400000000000014	3	1	14
15	2025-09-15 16:20:02.00001	t	2025-09-15 16:20:02.00001	\N	2020-10-15	\N	a	\N	correo15@cts.com	555-1000-0015	Calle Reforma 15, Ciudad MX	[{"name":"Contacto15","relationship":"Hermana","phone":"+525510000015"}]	Soltero/a	1500000000000015	1	2	15
16	2025-09-15 16:20:02.100011	t	2025-09-15 16:20:02.100011	\N	2020-11-15	\N	a	\N	correo16@cts.com	555-1000-0016	Calle Reforma 16, Ciudad MX	[{"name":"Contacto16","relationship":"Padre","phone":"+525510000016"}]	Casado/a	1600000000000016	2	3	16
17	2025-09-15 16:20:02.200012	t	2025-09-15 16:20:02.200012	\N	2020-12-15	\N	a	\N	correo17@cts.com	555-1000-0017	Calle Reforma 17, Ciudad MX	[{"name":"Contacto17","relationship":"Madre","phone":"+525510000017"}]	Divorciado/a	1700000000000017	3	4	17
18	2025-09-15 16:20:02.300013	t	2025-09-15 16:20:02.300013	\N	2021-01-15	\N	a	\N	correo18@cts.com	555-1000-0018	Calle Reforma 18, Ciudad MX	[{"name":"Contacto18","relationship":"Amigo","phone":"+525510000018"}]	Soltero/a	1800000000000018	1	1	18
19	2025-09-15 16:20:02.400014	t	2025-09-15 16:20:02.400014	\N	2021-02-15	\N	a	\N	correo19@cts.com	555-1000-0019	Calle Reforma 19, Ciudad MX	[{"name":"Contacto19","relationship":"Hermano","phone":"+525510000019"}]	Casado/a	1900000000000019	2	2	19
20	2025-09-15 16:20:02.500015	t	2025-09-15 16:20:02.500015	\N	2021-03-15	\N	a	\N	correo20@cts.com	555-1000-0020	Calle Reforma 20, Ciudad MX	[{"name":"Contacto20","relationship":"Hermana","phone":"+525510000020"}]	Divorciado/a	2000000000000020	3	3	20
21	2025-09-15 16:20:02.600016	t	2025-09-15 16:20:02.600016	\N	2021-04-15	\N	a	\N	correo21@cts.com	555-1000-0021	Calle Reforma 21, Ciudad MX	[{"name":"Contacto21","relationship":"Padre","phone":"+525510000021"}]	Soltero/a	2100000000000021	1	4	21
22	2025-09-15 16:20:02.700017	t	2025-09-15 16:20:02.700017	\N	2021-05-15	\N	a	\N	correo22@cts.com	555-1000-0022	Calle Reforma 22, Ciudad MX	[{"name":"Contacto22","relationship":"Madre","phone":"+525510000022"}]	Casado/a	2200000000000022	2	1	22
23	2025-09-15 16:20:02.800018	t	2025-09-15 16:20:02.800018	\N	2021-06-15	\N	a	\N	correo23@cts.com	555-1000-0023	Calle Reforma 23, Ciudad MX	[{"name":"Contacto23","relationship":"Amigo","phone":"+525510000023"}]	Divorciado/a	2300000000000023	3	2	23
24	2025-09-15 16:20:02.900019	t	2025-09-15 16:20:02.900019	\N	2021-07-15	\N	a	\N	correo24@cts.com	555-1000-0024	Calle Reforma 24, Ciudad MX	[{"name":"Contacto24","relationship":"Hermano","phone":"+525510000024"}]	Soltero/a	2400000000000024	1	3	24
32	2025-09-16 10:11:43.01815	t	2025-09-16 10:11:43.01815	\N	2025-09-13	\N	\N	\N	lauragomez98@mail.com	555-7890-1234	Av. las palmas 123, monterrey, nuevo león	[{"name":"María Ramírez","relationship":"Madre","phone":"+525511987654"}]	Soltero/a	123456789012345	2	2	88
\.


--
-- Data for Name: extension; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.extension (id, created_at, available, updated_at, deleted_at, number_expedients, start_date, end_date, project_id) FROM stdin;
\.


--
-- Data for Name: habilitations; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.habilitations (id, created_at, available, updated_at, deleted_at, fecha, name, "isRed", "isLuz", "isExtra", "singClient") FROM stdin;
\.


--
-- Data for Name: headquarters; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.headquarters (id, created_at, available, updated_at, deleted_at, name, address, city, postal_code, phone, start_date, end_date, production_days, number_expedients, sum_productions, status, project_id) FROM stdin;
1	2025-09-13 18:26:22.514128	t	2025-09-13 18:26:22.514128	\N	Rio Nilo	C. Rio Nilo #90, Piso 3. Alcaldia Cuahutemoc, CDMX	CDMX	06500	+529141398454	2023-01-01	2023-01-01	0	0	0	ACTIVE	1
2	2025-09-13 18:26:22.514128	t	2025-09-13 18:26:22.514128	\N	La Ceiba	C. La Ceiba #. Villahermosa, Tabasco	Villahermosa	80600	+529141398454	2023-01-01	2023-01-01	0	0	0	ACTIVE	1
\.


--
-- Data for Name: headquarters_position_quota; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.headquarters_position_quota (id, created_at, available, updated_at, deleted_at, max_employee, position_id, headquarter_id) FROM stdin;
\.


--
-- Data for Name: holidays; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.holidays (id, created_at, available, updated_at, deleted_at, holiday_date, description) FROM stdin;
\.


--
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.images (id, created_at, available, updated_at, deleted_at, path, originalname, mimetype, size) FROM stdin;
\.


--
-- Data for Name: inspections; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.inspections (id, created_at, available, updated_at, deleted_at, fecha, "statusEquipo", "isClean", "isDepuracion", "isDesfragment", "statusTerminales", "singClient", "isConection", "isVirus", "Comments") FROM stdin;
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.inventory (id, created_at, available, updated_at, deleted_at, "idName", "serialNumber", user_id, status, "stateId", "resourceId", "ubicationsId") FROM stdin;
\.


--
-- Data for Name: inventory_has_add_removal; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.inventory_has_add_removal (id, created_at, available, updated_at, deleted_at, "inventoryId", "addRemovalId") FROM stdin;
\.


--
-- Data for Name: inventory_has_assigment; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.inventory_has_assigment (id, created_at, available, updated_at, deleted_at, type, "inventoryId", "assignmentsReturnsId") FROM stdin;
\.


--
-- Data for Name: inventory_has_habilitations; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.inventory_has_habilitations (id, created_at, available, updated_at, deleted_at, "inventoryId", "habilitationsId") FROM stdin;
\.


--
-- Data for Name: inventory_has_inspections; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.inventory_has_inspections (id, created_at, available, updated_at, deleted_at, "inspectionsId", "inventoryId") FROM stdin;
\.


--
-- Data for Name: inventory_has_maintenances; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.inventory_has_maintenances (id, created_at, available, updated_at, deleted_at, observations, "startDate", "endDate", description, observation, "maintenanceType", status, "maintenancesId", "inventoryId") FROM stdin;
\.


--
-- Data for Name: maintenances; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.maintenances (id, created_at, available, updated_at, deleted_at, observations, "startDate", "endDate", description, observation, "maintenanceType", status) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
1	1757807594599	Init1757807594599
2	1757856106765	UpdateDismisal1757856106765
3	1757986715935	UpdateCascade1757986715935
4	1757986866442	UpdateReason1757986866442
\.


--
-- Data for Name: model; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.model (id, created_at, available, updated_at, deleted_at, name, "brandId") FROM stdin;
\.


--
-- Data for Name: module; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.module (id, created_at, available, updated_at, deleted_at, name, description) FROM stdin;
\.


--
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.permission (id, created_at, available, updated_at, deleted_at, name, description) FROM stdin;
\.


--
-- Data for Name: permission_has_module; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.permission_has_module (id, created_at, available, updated_at, deleted_at, permission_id, module_id) FROM stdin;
\.


--
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.positions (id, created_at, available, updated_at, deleted_at, "requiredBoss", name, salary_id, department_id, "parentId") FROM stdin;
37	2025-08-04 17:05:01.235	t	2025-08-04 17:05:01.235	\N	f	Director general	7	6	\N
38	2025-08-04 17:05:39.564	t	2025-08-04 17:05:39.564	\N	f	Coordinador de normatividad y procesos	5	8	\N
39	2025-08-04 17:05:57.21	t	2025-08-04 17:05:57.21	\N	f	Director de tecnologías	5	7	\N
40	2025-08-04 17:06:11.61	t	2025-08-04 17:06:11.61	\N	f	Director de finanzas	5	9	\N
41	2025-08-04 17:06:25.032	t	2025-08-04 17:06:25.032	\N	f	Director de administración	5	10	\N
42	2025-08-04 17:06:39.325	t	2025-08-04 17:06:39.325	\N	f	Director de operaciones	5	11	\N
43	2025-08-04 17:06:55.746	t	2025-08-04 17:06:55.746	\N	f	Director de proyectos	5	12	\N
44	2025-08-04 17:07:40.524	t	2025-08-04 17:07:40.524	\N	f	Coordinación de soporte técnico	9	7	39
45	2025-08-04 17:08:14.616	t	2025-08-04 17:08:14.616	\N	f	Coordinación de desarrollo de infraestructura tecnologíca	9	7	39
46	2025-08-04 17:09:28.54	t	2025-08-04 17:09:28.54	\N	f	Coordinación de contabilidad y finanzas	9	9	40
47	2025-08-04 17:09:45.047	t	2025-08-04 17:09:45.047	\N	f	Coordinador general de administración	9	10	41
48	2025-08-04 17:10:20.116	t	2025-08-04 17:10:20.116	\N	f	Coordinación general de operaciones	9	11	42
49	2025-08-04 19:34:50.372	t	2025-08-04 19:34:50.372	\N	f	Coordinación de proyectos	9	12	43
50	2025-08-04 19:41:43.34	t	2025-08-04 19:41:43.34	\N	f	Coordinación de recursos humanos	9	10	47
51	2025-08-04 19:42:00.065	t	2025-08-04 19:42:00.065	\N	f	Coordinación de recursos materiales y servicios generales	9	10	47
56	2025-09-13 18:34:39.876579	t	2025-09-13 18:34:39.876579	\N	t	Digitalizador	3	11	53
59	2025-09-13 18:40:33.100373	t	2025-09-13 18:40:33.100373	\N	t	Calidad	3	11	54
60	2025-09-13 18:59:32.036843	t	2025-09-13 18:59:32.036843	\N	t	Desarrollador	3	7	45
57	2025-09-13 18:36:19.374039	t	2025-09-13 18:36:19.374039	\N	t	Capturista	2	11	55
52	2025-08-04 19:42:28.457	t	2025-08-04 19:42:28.457	\N	t	Coordinación de preparación documental	1	11	48
53	2025-08-04 19:42:32.299	t	2025-08-04 19:42:32.299	\N	t	Coordinación de transformación digital	1	11	48
54	2025-08-04 19:42:41.716	t	2025-08-04 19:42:41.716	\N	t	Coordinación de calidad	1	11	48
55	2025-08-04 19:42:50.844	t	2025-08-04 19:42:50.844	\N	t	Coordinación de captura	1	11	48
58	2025-09-13 18:39:42.938599	t	2025-09-13 18:39:42.938599	\N	t	Preparador	2	11	52
61	2025-09-13 18:59:32.044539	t	2025-09-13 18:59:32.044539	\N	t	Soporte	3	7	44
\.


--
-- Data for Name: positions_closure; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.positions_closure (id_ancestor, id_descendant) FROM stdin;
37	37
38	38
39	39
40	40
41	41
42	42
43	43
44	44
39	44
45	45
39	45
46	46
40	46
47	47
41	47
48	48
42	48
49	49
43	49
50	50
47	50
41	50
51	51
47	51
41	51
52	52
48	52
42	52
53	53
48	53
42	53
54	54
48	54
42	54
55	55
48	55
42	55
\.


--
-- Data for Name: presences; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.presences (id, created_at, available, updated_at, deleted_at, date, check_in, check_out, reason, staff_id) FROM stdin;
\.


--
-- Data for Name: profile_has_modulePermission; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public."profile_has_modulePermission" ("permissionHasModuleId", "profilesId") FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.profiles (id, created_at, available, updated_at, deleted_at, name, saved) FROM stdin;
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.projects (id, created_at, available, updated_at, deleted_at, "isExternal", contract_number, name, description, start_date, end_date, number_expedients, number_images, productions_days, sum_productions, status) FROM stdin;
1	2025-09-13 18:24:33.261711	t	2025-09-13 18:24:33.261711	\N	f		Centro de Tecnologías del Sureste	CTS	2020-01-01	2020-01-01	0	0	0	0	ACTIVE
\.


--
-- Data for Name: report_type; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.report_type (id, created_at, available, updated_at, deleted_at, name) FROM stdin;
\.


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.resource (id, created_at, available, updated_at, deleted_at, name, quatity, especifications, description, type, "clasificationId", "modelId") FROM stdin;
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.role (id, created_at, available, updated_at, deleted_at, type) FROM stdin;
1	2025-07-10 19:49:45.046	t	2025-07-10 19:49:45.046	\N	Administrador
2	2025-07-10 19:49:52.754	t	2025-07-10 19:49:52.754	\N	Usuario
3	2025-07-10 19:49:57.659	t	2025-07-10 19:49:57.659	\N	Capturista
4	2025-07-10 19:50:07.26	t	2025-07-10 19:50:07.26	\N	Superusuario
5	2025-07-15 17:36:37.391	t	2025-07-15 17:36:37.391	\N	User
\.


--
-- Data for Name: salary; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.salary (id, created_at, available, updated_at, deleted_at, amount, salary_in_words) FROM stdin;
1	2025-07-08 16:26:42.715	t	2025-07-08 16:26:42.715	\N	$25,000.00	Veinticinco mil quinientos
3	2025-07-08 16:28:07.681	t	2025-07-08 16:28:07.681	\N	$18,000.00	Dieciocho mil
4	2025-07-08 17:02:03.58	t	2025-07-08 17:02:03.58	\N	$15,000.00	Quince mil
5	2025-08-01 17:12:36.142637	t	2025-08-01 17:12:36.142637	\N	$40,000.00	Cuarenta mil
6	2025-08-01 17:14:31.163952	t	2025-08-01 17:14:31.163952	\N	$20,000.00	Veinte mil
7	2025-08-01 18:26:36.281201	t	2025-08-01 18:26:36.281201	\N	$50,000.00	Cincuenta mil
9	2025-08-01 18:43:11.247179	t	2025-08-01 18:43:11.247179	\N	$30,000.00	Treinta mil
2	2025-07-08 16:26:12.236	t	2025-07-08 16:26:12.236	\N	$8,500.00	Ocho mil quinientos
\.


--
-- Data for Name: signature; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.signature (id, created_at, available, updated_at, deleted_at, type_signature_id, staff_id) FROM stdin;
\.


--
-- Data for Name: signature_has_reports; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.signature_has_reports (id, created_at, available, updated_at, deleted_at, reference, "signatureId", type_report_id, status_application_id) FROM stdin;
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.staff (id, created_at, available, updated_at, deleted_at, employee_has_positions_id, headquarter_id, "parentId") FROM stdin;
1	2025-09-15 16:39:41.713686	t	2025-09-15 16:39:41.713686	\N	1	1	\N
2	2025-09-15 16:39:45.901579	t	2025-09-15 16:39:45.901579	\N	2	1	\N
3	2025-09-15 16:39:48.451202	t	2025-09-15 16:39:48.451202	\N	3	1	\N
4	2025-09-15 16:39:50.956161	t	2025-09-15 16:39:50.956161	\N	4	1	\N
5	2025-09-15 16:40:26.745429	t	2025-09-15 16:40:26.745429	\N	5	1	\N
6	2025-09-15 16:40:30.278544	t	2025-09-15 16:40:30.278544	\N	6	1	\N
7	2025-09-15 16:40:34.492226	t	2025-09-15 16:40:34.492226	\N	7	1	\N
8	2025-09-15 16:41:00.177304	t	2025-09-15 16:41:00.177304	\N	8	1	\N
9	2025-09-15 16:41:04.588484	t	2025-09-15 16:41:04.588484	\N	9	1	\N
10	2025-09-15 16:41:07.162346	t	2025-09-15 16:41:07.162346	\N	10	1	\N
11	2025-09-15 16:41:21.456463	t	2025-09-15 16:41:21.456463	\N	11	1	\N
16	2025-09-15 17:34:45.053208	t	2025-09-15 17:34:45.053208	\N	12	1	10
17	2025-09-15 17:39:08.580527	t	2025-09-15 17:39:08.580527	\N	13	1	10
18	2025-09-15 17:39:08.583698	t	2025-09-15 17:39:08.583698	\N	14	1	10
19	2025-09-15 17:39:08.585762	t	2025-09-15 17:39:08.585762	\N	15	1	10
20	2025-09-15 17:39:08.587346	t	2025-09-15 17:39:08.587346	\N	16	1	17
21	2025-09-15 17:50:01.237242	t	2025-09-15 17:50:01.237242	\N	17	1	19
22	2025-09-15 17:50:01.246134	t	2025-09-15 17:50:01.246134	\N	18	1	16
23	2025-09-15 17:50:01.248088	t	2025-09-15 17:50:01.248088	\N	19	1	18
24	2025-09-15 17:50:01.249528	t	2025-09-15 17:50:01.249528	\N	20	1	8
25	2025-09-15 17:50:01.250735	t	2025-09-15 17:50:01.250735	\N	21	1	7
26	2025-09-15 17:53:05.471482	t	2025-09-15 17:53:05.471482	\N	22	1	17
27	2025-09-15 17:53:05.479964	t	2025-09-15 17:53:05.479964	\N	23	1	19
28	2025-09-15 17:55:07.543343	t	2025-09-15 17:55:07.543343	\N	24	1	16
31	2025-09-16 10:11:43.01815	t	2025-09-16 10:11:43.01815	\N	25	1	8
\.


--
-- Data for Name: staff_closure; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.staff_closure (id_ancestor, id_descendant) FROM stdin;
1	1
2	2
3	3
4	4
5	5
6	6
7	7
8	8
9	9
10	10
11	11
16	16
10	16
17	17
10	17
18	18
10	18
19	19
10	19
20	20
17	20
21	21
19	21
22	22
16	22
23	23
8	23
25	25
7	25
26	26
17	26
27	27
19	27
28	28
16	28
31	31
8	31
\.


--
-- Data for Name: state; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.state (id, created_at, available, updated_at, deleted_at, name) FROM stdin;
\.


--
-- Data for Name: status_application; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.status_application (id, created_at, available, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: type_contract; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.type_contract (id, created_at, available, updated_at, deleted_at, type, "isAutomatic") FROM stdin;
3	2025-07-10 12:44:07.499	t	2025-07-10 12:44:07.499	\N	Por obra y tiempo determinado	f
1	2025-07-10 12:44:07.484	t	2025-07-10 12:44:07.484	\N	Indeterminado	t
2	2025-07-10 12:44:07.49	t	2025-07-10 12:44:07.49	\N	Sueldos y salarios asimilados	t
\.


--
-- Data for Name: type_document; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.type_document (id, created_at, available, updated_at, deleted_at, type) FROM stdin;
1	2025-07-08 16:33:09.112	t	2025-07-08 16:33:09.112	\N	NSS
2	2025-07-08 16:33:14.595	t	2025-07-08 16:33:14.595	\N	RFC
3	2025-07-08 16:33:18.478	t	2025-07-08 16:33:18.478	\N	INE
4	2025-07-08 16:33:29.3	t	2025-07-08 16:33:29.3	\N	ACTA DE NACIMIENTO
5	2025-07-08 16:36:38.621	t	2025-07-08 16:36:38.621	\N	COMPROBANTE DE DOMICILIO
\.


--
-- Data for Name: type_signature; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.type_signature (id, created_at, available, updated_at, deleted_at, name) FROM stdin;
\.


--
-- Data for Name: types_bonds; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.types_bonds (id, created_at, available, updated_at, deleted_at, type) FROM stdin;
\.


--
-- Data for Name: types_document; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.types_document (id, created_at, available, updated_at, deleted_at, type) FROM stdin;
\.


--
-- Data for Name: ubications; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.ubications (id, created_at, available, updated_at, deleted_at, ubications) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.users (id, created_at, available, updated_at, deleted_at, username, password, role_id, profile_id) FROM stdin;
\.


--
-- Data for Name: vacations; Type: TABLE DATA; Schema: public; Owner: esc
--

COPY public.vacations (id, created_at, available, updated_at, deleted_at, "startDate", "endDate", requested_day, status, reason, comment, employee_id) FROM stdin;
\.


--
-- Name: add_removal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.add_removal_id_seq', 1, false);


--
-- Name: admission_has_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.admission_has_inventory_id_seq', 1, false);


--
-- Name: admissions_discharges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.admissions_discharges_id_seq', 1, false);


--
-- Name: assignments_returns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.assignments_returns_id_seq', 1, false);


--
-- Name: attendance_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.attendance_permission_id_seq', 1, false);


--
-- Name: banks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.banks_id_seq', 1, false);


--
-- Name: bond_has_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.bond_has_employee_id_seq', 1, false);


--
-- Name: bonds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.bonds_id_seq', 1, false);


--
-- Name: brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.brand_id_seq', 1, false);


--
-- Name: clasification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.clasification_id_seq', 1, false);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.departments_id_seq', 1, false);


--
-- Name: description_bonds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.description_bonds_id_seq', 1, false);


--
-- Name: dismissal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.dismissal_id_seq', 1, false);


--
-- Name: document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.document_id_seq', 1, false);


--
-- Name: emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.emails_id_seq', 64, true);


--
-- Name: employee_has_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.employee_has_positions_id_seq', 25, true);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.employees_id_seq', 88, true);


--
-- Name: employment_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.employment_record_id_seq', 33, true);


--
-- Name: extension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.extension_id_seq', 1, false);


--
-- Name: habilitations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.habilitations_id_seq', 1, false);


--
-- Name: headquarters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.headquarters_id_seq', 2, true);


--
-- Name: headquarters_position_quota_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.headquarters_position_quota_id_seq', 1, false);


--
-- Name: holidays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.holidays_id_seq', 1, false);


--
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.images_id_seq', 1, false);


--
-- Name: inspections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.inspections_id_seq', 1, false);


--
-- Name: inventory_has_add_removal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.inventory_has_add_removal_id_seq', 1, false);


--
-- Name: inventory_has_assigment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.inventory_has_assigment_id_seq', 1, false);


--
-- Name: inventory_has_habilitations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.inventory_has_habilitations_id_seq', 1, false);


--
-- Name: inventory_has_inspections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.inventory_has_inspections_id_seq', 1, false);


--
-- Name: inventory_has_maintenances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.inventory_has_maintenances_id_seq', 1, false);


--
-- Name: inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.inventory_id_seq', 1, false);


--
-- Name: maintenances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.maintenances_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.migrations_id_seq', 4, true);


--
-- Name: model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.model_id_seq', 1, false);


--
-- Name: module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.module_id_seq', 1, false);


--
-- Name: permission_has_module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.permission_has_module_id_seq', 1, false);


--
-- Name: permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.permission_id_seq', 1, false);


--
-- Name: positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.positions_id_seq', 3, true);


--
-- Name: presences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.presences_id_seq', 1, false);


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.profiles_id_seq', 1, false);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.projects_id_seq', 1, true);


--
-- Name: report_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.report_type_id_seq', 1, false);


--
-- Name: resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.resource_id_seq', 1, false);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.role_id_seq', 1, false);


--
-- Name: salary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.salary_id_seq', 2, true);


--
-- Name: signature_has_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.signature_has_reports_id_seq', 1, false);


--
-- Name: signature_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.signature_id_seq', 1, false);


--
-- Name: staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.staff_id_seq', 31, true);


--
-- Name: state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.state_id_seq', 1, false);


--
-- Name: status_application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.status_application_id_seq', 1, false);


--
-- Name: type_contract_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.type_contract_id_seq', 1, false);


--
-- Name: type_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.type_document_id_seq', 1, false);


--
-- Name: type_signature_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.type_signature_id_seq', 1, false);


--
-- Name: types_bonds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.types_bonds_id_seq', 1, false);


--
-- Name: types_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.types_document_id_seq', 1, false);


--
-- Name: ubications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.ubications_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: vacations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: esc
--

SELECT pg_catalog.setval('public.vacations_id_seq', 1, false);


--
-- Name: attendance_permission PK_089a8925f9d46de695e4516212f; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.attendance_permission
    ADD CONSTRAINT "PK_089a8925f9d46de695e4516212f" PRIMARY KEY (id);


--
-- Name: types_bonds PK_0ca3aaadb8ede92bd44277deb85; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.types_bonds
    ADD CONSTRAINT "PK_0ca3aaadb8ede92bd44277deb85" PRIMARY KEY (id);


--
-- Name: module PK_0e20d657f968b051e674fbe3117; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT "PK_0e20d657f968b051e674fbe3117" PRIMARY KEY (id);


--
-- Name: employment_record PK_1362d2f5f065365b2bfb22d0c21; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employment_record
    ADD CONSTRAINT "PK_1362d2f5f065365b2bfb22d0c21" PRIMARY KEY (id);


--
-- Name: positions_closure PK_139125e08a478dc9042e2fd93c4; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.positions_closure
    ADD CONSTRAINT "PK_139125e08a478dc9042e2fd93c4" PRIMARY KEY (id_ancestor, id_descendant);


--
-- Name: positions PK_17e4e62ccd5749b289ae3fae6f3; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT "PK_17e4e62ccd5749b289ae3fae6f3" PRIMARY KEY (id);


--
-- Name: images PK_1fe148074c6a1a91b63cb9ee3c9; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT "PK_1fe148074c6a1a91b63cb9ee3c9" PRIMARY KEY (id);


--
-- Name: inventory_has_habilitations PK_232aace7f467da1d773a4403a21; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_habilitations
    ADD CONSTRAINT "PK_232aace7f467da1d773a4403a21" PRIMARY KEY (id);


--
-- Name: status_application PK_289bc1c2cbb3dd803592f8d35c6; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.status_application
    ADD CONSTRAINT "PK_289bc1c2cbb3dd803592f8d35c6" PRIMARY KEY (id);


--
-- Name: bond_has_employee PK_291cc34c854f000b504dc2371d4; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.bond_has_employee
    ADD CONSTRAINT "PK_291cc34c854f000b504dc2371d4" PRIMARY KEY (id);


--
-- Name: inventory_has_maintenances PK_2f6e3ba2d23b5af2a54561ede77; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_maintenances
    ADD CONSTRAINT "PK_2f6e3ba2d23b5af2a54561ede77" PRIMARY KEY (id);


--
-- Name: report_type PK_324366e10cf40cf2ac60c502a00; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.report_type
    ADD CONSTRAINT "PK_324366e10cf40cf2ac60c502a00" PRIMARY KEY (id);


--
-- Name: holidays PK_3646bdd4c3817d954d830881dfe; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.holidays
    ADD CONSTRAINT "PK_3646bdd4c3817d954d830881dfe" PRIMARY KEY (id);


--
-- Name: banks PK_3975b5f684ec241e3901db62d77; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.banks
    ADD CONSTRAINT "PK_3975b5f684ec241e3901db62d77" PRIMARY KEY (id);


--
-- Name: salary PK_3ac75d9585433a6264e618a6503; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.salary
    ADD CONSTRAINT "PK_3ac75d9585433a6264e618a6503" PRIMARY KEY (id);


--
-- Name: ubications PK_3b6ed098d183c507c5f429006bf; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.ubications
    ADD CONSTRAINT "PK_3b6ed098d183c507c5f429006bf" PRIMARY KEY (id);


--
-- Name: permission PK_3b8b97af9d9d8807e41e6f48362; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.permission
    ADD CONSTRAINT "PK_3b8b97af9d9d8807e41e6f48362" PRIMARY KEY (id);


--
-- Name: signature_has_reports PK_3ef37668107276c6c2ed7e4f222; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.signature_has_reports
    ADD CONSTRAINT "PK_3ef37668107276c6c2ed7e4f222" PRIMARY KEY (id);


--
-- Name: inventory_has_assigment PK_408fad3d6b97af00d718bb0951d; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_assigment
    ADD CONSTRAINT "PK_408fad3d6b97af00d718bb0951d" PRIMARY KEY (id);


--
-- Name: state PK_549ffd046ebab1336c3a8030a12; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT "PK_549ffd046ebab1336c3a8030a12" PRIMARY KEY (id);


--
-- Name: maintenances PK_62403473bd524a42d58589aa78b; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.maintenances
    ADD CONSTRAINT "PK_62403473bd524a42d58589aa78b" PRIMARY KEY (id);


--
-- Name: profile_has_modulePermission PK_6253ea6b8d8d8ddcbc67bec5428; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public."profile_has_modulePermission"
    ADD CONSTRAINT "PK_6253ea6b8d8d8ddcbc67bec5428" PRIMARY KEY ("permissionHasModuleId", "profilesId");


--
-- Name: projects PK_6271df0a7aed1d6c0691ce6ac50; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT "PK_6271df0a7aed1d6c0691ce6ac50" PRIMARY KEY (id);


--
-- Name: add_removal PK_6aee7312ff97d42b5f9f973be9c; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.add_removal
    ADD CONSTRAINT "PK_6aee7312ff97d42b5f9f973be9c" PRIMARY KEY (id);


--
-- Name: habilitations PK_6c56ce7245081fdf164ccf99a17; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.habilitations
    ADD CONSTRAINT "PK_6c56ce7245081fdf164ccf99a17" PRIMARY KEY (id);


--
-- Name: clasification PK_6d01fb578a83d5d1cd827cb670c; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.clasification
    ADD CONSTRAINT "PK_6d01fb578a83d5d1cd827cb670c" PRIMARY KEY (id);


--
-- Name: staff_closure PK_6db27aa0cfa68a563876b392fac; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.staff_closure
    ADD CONSTRAINT "PK_6db27aa0cfa68a563876b392fac" PRIMARY KEY (id_ancestor, id_descendant);


--
-- Name: type_signature PK_82a1b82974ba44bed455ff83e1f; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.type_signature
    ADD CONSTRAINT "PK_82a1b82974ba44bed455ff83e1f" PRIMARY KEY (id);


--
-- Name: inventory PK_82aa5da437c5bbfb80703b08309; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT "PK_82aa5da437c5bbfb80703b08309" PRIMARY KEY (id);


--
-- Name: vacations PK_830973008a9b7e114e612442750; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.vacations
    ADD CONSTRAINT "PK_830973008a9b7e114e612442750" PRIMARY KEY (id);


--
-- Name: departments PK_839517a681a86bb84cbcc6a1e9d; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT "PK_839517a681a86bb84cbcc6a1e9d" PRIMARY KEY (id);


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: profiles PK_8e520eb4da7dc01d0e190447c8e; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT "PK_8e520eb4da7dc01d0e190447c8e" PRIMARY KEY (id);


--
-- Name: signature PK_8e62734171afc1d7c9570be27fb; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.signature
    ADD CONSTRAINT "PK_8e62734171afc1d7c9570be27fb" PRIMARY KEY (id);


--
-- Name: type_contract PK_8f0bb22041415eca7ed86a89bb1; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.type_contract
    ADD CONSTRAINT "PK_8f0bb22041415eca7ed86a89bb1" PRIMARY KEY (id);


--
-- Name: admissions_discharges PK_919db764f36e2d9e1e7a30ffbb4; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.admissions_discharges
    ADD CONSTRAINT "PK_919db764f36e2d9e1e7a30ffbb4" PRIMARY KEY (id);


--
-- Name: presences PK_954405226c89821ea470763df3c; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.presences
    ADD CONSTRAINT "PK_954405226c89821ea470763df3c" PRIMARY KEY (id);


--
-- Name: permission_has_module PK_97f2a0a6f9a98eea5dd3c44756a; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.permission_has_module
    ADD CONSTRAINT "PK_97f2a0a6f9a98eea5dd3c44756a" PRIMARY KEY (id);


--
-- Name: employee_has_positions PK_980d1f4feea65fe7d7ac6bb5cc0; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employee_has_positions
    ADD CONSTRAINT "PK_980d1f4feea65fe7d7ac6bb5cc0" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: inspections PK_a484980015782324454d8c88abe; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inspections
    ADD CONSTRAINT "PK_a484980015782324454d8c88abe" PRIMARY KEY (id);


--
-- Name: emails PK_a54dcebef8d05dca7e839749571; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT "PK_a54dcebef8d05dca7e839749571" PRIMARY KEY (id);


--
-- Name: brand PK_a5d20765ddd942eb5de4eee2d7f; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.brand
    ADD CONSTRAINT "PK_a5d20765ddd942eb5de4eee2d7f" PRIMARY KEY (id);


--
-- Name: bonds PK_a780a1aca6c3aa9718920a1ca8d; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.bonds
    ADD CONSTRAINT "PK_a780a1aca6c3aa9718920a1ca8d" PRIMARY KEY (id);


--
-- Name: headquarters_position_quota PK_a7c2a0a9485acec0c9a0b86dbf8; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.headquarters_position_quota
    ADD CONSTRAINT "PK_a7c2a0a9485acec0c9a0b86dbf8" PRIMARY KEY (id);


--
-- Name: type_document PK_a89fb9f22e15824ce89c11c5a1b; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.type_document
    ADD CONSTRAINT "PK_a89fb9f22e15824ce89c11c5a1b" PRIMARY KEY (id);


--
-- Name: assignments_returns PK_b23c7e2b93c0f62ba8ddc17d83e; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.assignments_returns
    ADD CONSTRAINT "PK_b23c7e2b93c0f62ba8ddc17d83e" PRIMARY KEY (id);


--
-- Name: role PK_b36bcfe02fc8de3c57a8b2391c2; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "PK_b36bcfe02fc8de3c57a8b2391c2" PRIMARY KEY (id);


--
-- Name: dismissal PK_b3726f4c836359d11635f36a579; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.dismissal
    ADD CONSTRAINT "PK_b3726f4c836359d11635f36a579" PRIMARY KEY (id);


--
-- Name: employees PK_b9535a98350d5b26e7eb0c26af4; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT "PK_b9535a98350d5b26e7eb0c26af4" PRIMARY KEY (id);


--
-- Name: types_document PK_bbdcb0e5226f5c5605c6dbb5d84; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.types_document
    ADD CONSTRAINT "PK_bbdcb0e5226f5c5605c6dbb5d84" PRIMARY KEY (id);


--
-- Name: model PK_d6df271bba301d5cc79462912a4; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.model
    ADD CONSTRAINT "PK_d6df271bba301d5cc79462912a4" PRIMARY KEY (id);


--
-- Name: inventory_has_inspections PK_d7845a9f19ef72c60dad355b11c; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_inspections
    ADD CONSTRAINT "PK_d7845a9f19ef72c60dad355b11c" PRIMARY KEY (id);


--
-- Name: inventory_has_add_removal PK_d952366766524630623a6b92f77; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_add_removal
    ADD CONSTRAINT "PK_d952366766524630623a6b92f77" PRIMARY KEY (id);


--
-- Name: description_bonds PK_db1d40b8a10ba76eabbcafa6561; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.description_bonds
    ADD CONSTRAINT "PK_db1d40b8a10ba76eabbcafa6561" PRIMARY KEY (id);


--
-- Name: resource PK_e2894a5867e06ae2e8889f1173f; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT "PK_e2894a5867e06ae2e8889f1173f" PRIMARY KEY (id);


--
-- Name: staff PK_e4ee98bb552756c180aec1e854a; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT "PK_e4ee98bb552756c180aec1e854a" PRIMARY KEY (id);


--
-- Name: document PK_e57d3357f83f3cdc0acffc3d777; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT "PK_e57d3357f83f3cdc0acffc3d777" PRIMARY KEY (id);


--
-- Name: extension PK_e9e7da4f1cfc826aba870c20589; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.extension
    ADD CONSTRAINT "PK_e9e7da4f1cfc826aba870c20589" PRIMARY KEY (id);


--
-- Name: headquarters PK_f9e4eae5e864a9400f279720cf2; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.headquarters
    ADD CONSTRAINT "PK_f9e4eae5e864a9400f279720cf2" PRIMARY KEY (id);


--
-- Name: employee_has_attendancePermission PK_faa836094a7594131b965d779fd; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public."employee_has_attendancePermission"
    ADD CONSTRAINT "PK_faa836094a7594131b965d779fd" PRIMARY KEY (attendance_permission_id, employment_record_id);


--
-- Name: admission_has_inventory PK_fb0dbf7a30d5b9ca6f59930145e; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.admission_has_inventory
    ADD CONSTRAINT "PK_fb0dbf7a30d5b9ca6f59930145e" PRIMARY KEY (id);


--
-- Name: emails REL_4c1f50332557b4c0adb2c6cac4; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT "REL_4c1f50332557b4c0adb2c6cac4" UNIQUE (user_id);


--
-- Name: emails REL_592997ca6ecb09af15267c68cd; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT "REL_592997ca6ecb09af15267c68cd" UNIQUE (employee_id);


--
-- Name: dismissal REL_d8ed36ab56d8d40304e564ba41; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.dismissal
    ADD CONSTRAINT "REL_d8ed36ab56d8d40304e564ba41" UNIQUE (employee_id);


--
-- Name: permission UQ_240853a0c3353c25fb12434ad33; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.permission
    ADD CONSTRAINT "UQ_240853a0c3353c25fb12434ad33" UNIQUE (name);


--
-- Name: emails UQ_3cbf51004f0706ac67ff8c22dbf; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT "UQ_3cbf51004f0706ac67ff8c22dbf" UNIQUE (email);


--
-- Name: module UQ_620a549dbcb1fff62ea85695ca3; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT "UQ_620a549dbcb1fff62ea85695ca3" UNIQUE (name);


--
-- Name: types_bonds UQ_69af29805712a9bd5f9381376be; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.types_bonds
    ADD CONSTRAINT "UQ_69af29805712a9bd5f9381376be" UNIQUE (type);


--
-- Name: employment_record UQ_84d13970aad7bcc604835d4eabf; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employment_record
    ADD CONSTRAINT "UQ_84d13970aad7bcc604835d4eabf" UNIQUE (email);


--
-- Name: role UQ_9a0c91c218a16e604951ff1c099; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "UQ_9a0c91c218a16e604951ff1c099" UNIQUE (type);


--
-- Name: report_type UQ_9aeb09a7a15aeab95ef88e9749a; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.report_type
    ADD CONSTRAINT "UQ_9aeb09a7a15aeab95ef88e9749a" UNIQUE (name);


--
-- Name: type_signature UQ_9e3195fe86d35ffc0a85221d119; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.type_signature
    ADD CONSTRAINT "UQ_9e3195fe86d35ffc0a85221d119" UNIQUE (name);


--
-- Name: inventory UQ_a497fa48c497e9fb25a5ae04bd1; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT "UQ_a497fa48c497e9fb25a5ae04bd1" UNIQUE ("serialNumber");


--
-- Name: state UQ_b2c4aef5929860729007ac32f6f; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT "UQ_b2c4aef5929860729007ac32f6f" UNIQUE (name);


--
-- Name: banks UQ_bc680de8ba9d7878fddcecd610c; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.banks
    ADD CONSTRAINT "UQ_bc680de8ba9d7878fddcecd610c" UNIQUE (name);


--
-- Name: status_application UQ_c9cb2396b4f9f96ff22197fd72f; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.status_application
    ADD CONSTRAINT "UQ_c9cb2396b4f9f96ff22197fd72f" UNIQUE (status);


--
-- Name: description_bonds UQ_db1cbbb7e027b1351335dba7e06; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.description_bonds
    ADD CONSTRAINT "UQ_db1cbbb7e027b1351335dba7e06" UNIQUE (description);


--
-- Name: inventory UQ_f4943c6576f2495169ebb7701b2; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT "UQ_f4943c6576f2495169ebb7701b2" UNIQUE ("idName");


--
-- Name: users UQ_fe0bb3f6520ee0469504521e710; Type: CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_fe0bb3f6520ee0469504521e710" UNIQUE (username);


--
-- Name: IDX_0fcd4493607fa3ffea7c89c3f1; Type: INDEX; Schema: public; Owner: esc
--

CREATE INDEX "IDX_0fcd4493607fa3ffea7c89c3f1" ON public.staff_closure USING btree (id_ancestor);


--
-- Name: IDX_500976d9a6160c169ece0f6386; Type: INDEX; Schema: public; Owner: esc
--

CREATE INDEX "IDX_500976d9a6160c169ece0f6386" ON public."profile_has_modulePermission" USING btree ("permissionHasModuleId");


--
-- Name: IDX_51c214e5f793f9eae727aee880; Type: INDEX; Schema: public; Owner: esc
--

CREATE INDEX "IDX_51c214e5f793f9eae727aee880" ON public."profile_has_modulePermission" USING btree ("profilesId");


--
-- Name: IDX_6a351504a25fe21af06f080a35; Type: INDEX; Schema: public; Owner: esc
--

CREATE INDEX "IDX_6a351504a25fe21af06f080a35" ON public.staff_closure USING btree (id_descendant);


--
-- Name: IDX_98261b5fa64b7a505c9d04994b; Type: INDEX; Schema: public; Owner: esc
--

CREATE INDEX "IDX_98261b5fa64b7a505c9d04994b" ON public.positions_closure USING btree (id_descendant);


--
-- Name: IDX_a752cab83995f8bd5e257aa7d0; Type: INDEX; Schema: public; Owner: esc
--

CREATE INDEX "IDX_a752cab83995f8bd5e257aa7d0" ON public."employee_has_attendancePermission" USING btree (attendance_permission_id);


--
-- Name: IDX_b55ad2b0e2b11b94e0b8a03f9d; Type: INDEX; Schema: public; Owner: esc
--

CREATE INDEX "IDX_b55ad2b0e2b11b94e0b8a03f9d" ON public.positions_closure USING btree (id_ancestor);


--
-- Name: IDX_b8fcbededbe4731ec401fa64ee; Type: INDEX; Schema: public; Owner: esc
--

CREATE INDEX "IDX_b8fcbededbe4731ec401fa64ee" ON public."employee_has_attendancePermission" USING btree (employment_record_id);


--
-- Name: vacations trg_after_delete_vacation; Type: TRIGGER; Schema: public; Owner: esc
--

CREATE TRIGGER trg_after_delete_vacation AFTER UPDATE OF deleted_at ON public.vacations FOR EACH ROW EXECUTE FUNCTION public.after_delete_vacation();


--
-- Name: dismissal trg_after_insert_dismissal; Type: TRIGGER; Schema: public; Owner: esc
--

CREATE TRIGGER trg_after_insert_dismissal AFTER INSERT ON public.dismissal FOR EACH ROW EXECUTE FUNCTION public.after_dismissal_update();


--
-- Name: vacations trg_after_insert_vacation; Type: TRIGGER; Schema: public; Owner: esc
--

CREATE TRIGGER trg_after_insert_vacation AFTER INSERT OR UPDATE OF status ON public.vacations FOR EACH ROW EXECUTE FUNCTION public.after_approve_vacation();


--
-- Name: permission_has_module FK_0124c7f170dd37e1354af85f39e; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.permission_has_module
    ADD CONSTRAINT "FK_0124c7f170dd37e1354af85f39e" FOREIGN KEY (permission_id) REFERENCES public.permission(id);


--
-- Name: employee_has_positions FK_08569a041cf5507012e837e975b; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employee_has_positions
    ADD CONSTRAINT "FK_08569a041cf5507012e837e975b" FOREIGN KEY (employee_id) REFERENCES public.employment_record(id);


--
-- Name: vacations FK_0b9f6db82ee55b6ce39e5f1f90d; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.vacations
    ADD CONSTRAINT "FK_0b9f6db82ee55b6ce39e5f1f90d" FOREIGN KEY (employee_id) REFERENCES public.employment_record(id);


--
-- Name: staff_closure FK_0fcd4493607fa3ffea7c89c3f11; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.staff_closure
    ADD CONSTRAINT "FK_0fcd4493607fa3ffea7c89c3f11" FOREIGN KEY (id_ancestor) REFERENCES public.staff(id) ON DELETE CASCADE;


--
-- Name: inventory FK_1151b67a42adfca8555193c70c4; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT "FK_1151b67a42adfca8555193c70c4" FOREIGN KEY ("resourceId") REFERENCES public.resource(id);


--
-- Name: resource FK_134652f862452c1caf7206be1bc; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT "FK_134652f862452c1caf7206be1bc" FOREIGN KEY ("clasificationId") REFERENCES public.clasification(id);


--
-- Name: employee_has_positions FK_181aa611119f1991c88bc8b1182; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employee_has_positions
    ADD CONSTRAINT "FK_181aa611119f1991c88bc8b1182" FOREIGN KEY (position_id) REFERENCES public.positions(id);


--
-- Name: inventory_has_assigment FK_1828db609a82a6fa26c338efc4d; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_assigment
    ADD CONSTRAINT "FK_1828db609a82a6fa26c338efc4d" FOREIGN KEY ("assignmentsReturnsId") REFERENCES public.assignments_returns(id);


--
-- Name: bond_has_employee FK_1930fb4009555dcb643c4e5e5a6; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.bond_has_employee
    ADD CONSTRAINT "FK_1930fb4009555dcb643c4e5e5a6" FOREIGN KEY (employment_record_id) REFERENCES public.employment_record(id);


--
-- Name: users FK_23371445bd80cb3e413089551bf; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_23371445bd80cb3e413089551bf" FOREIGN KEY (profile_id) REFERENCES public.profiles(id);


--
-- Name: inventory FK_278fe6f9279111130cf844f53cb; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT "FK_278fe6f9279111130cf844f53cb" FOREIGN KEY ("stateId") REFERENCES public.state(id);


--
-- Name: inventory_has_inspections FK_27fa9cd6a4077547830d21a7ff2; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_inspections
    ADD CONSTRAINT "FK_27fa9cd6a4077547830d21a7ff2" FOREIGN KEY ("inspectionsId") REFERENCES public.inspections(id);


--
-- Name: document FK_2e1aa55eac1947ddf3221506edb; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT "FK_2e1aa55eac1947ddf3221506edb" FOREIGN KEY (type_id) REFERENCES public.type_document(id);


--
-- Name: positions FK_31c89d8fbbd2ffc88fea9d0af2a; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT "FK_31c89d8fbbd2ffc88fea9d0af2a" FOREIGN KEY ("parentId") REFERENCES public.positions(id);


--
-- Name: document FK_350542c28ed13338fa7e7ef3140; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT "FK_350542c28ed13338fa7e7ef3140" FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: emails FK_4c1f50332557b4c0adb2c6cac41; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT "FK_4c1f50332557b4c0adb2c6cac41" FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: headquarters_position_quota FK_4f98faf69aae98027c4931b7d64; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.headquarters_position_quota
    ADD CONSTRAINT "FK_4f98faf69aae98027c4931b7d64" FOREIGN KEY (headquarter_id) REFERENCES public.headquarters(id);


--
-- Name: profile_has_modulePermission FK_500976d9a6160c169ece0f63866; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public."profile_has_modulePermission"
    ADD CONSTRAINT "FK_500976d9a6160c169ece0f63866" FOREIGN KEY ("permissionHasModuleId") REFERENCES public.permission_has_module(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: profile_has_modulePermission FK_51c214e5f793f9eae727aee880a; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public."profile_has_modulePermission"
    ADD CONSTRAINT "FK_51c214e5f793f9eae727aee880a" FOREIGN KEY ("profilesId") REFERENCES public.profiles(id);


--
-- Name: emails FK_592997ca6ecb09af15267c68cdf; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT "FK_592997ca6ecb09af15267c68cdf" FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: extension FK_5cccc80266a48c274c3a268cddc; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.extension
    ADD CONSTRAINT "FK_5cccc80266a48c274c3a268cddc" FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: bonds FK_5dcb37ba39fc9c6661fc19aee43; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.bonds
    ADD CONSTRAINT "FK_5dcb37ba39fc9c6661fc19aee43" FOREIGN KEY (type_id) REFERENCES public.types_bonds(id);


--
-- Name: staff_closure FK_6a351504a25fe21af06f080a35f; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.staff_closure
    ADD CONSTRAINT "FK_6a351504a25fe21af06f080a35f" FOREIGN KEY (id_descendant) REFERENCES public.staff(id) ON DELETE CASCADE;


--
-- Name: inventory_has_add_removal FK_6b35963d2a52053aabe18413355; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_add_removal
    ADD CONSTRAINT "FK_6b35963d2a52053aabe18413355" FOREIGN KEY ("inventoryId") REFERENCES public.inventory(id);


--
-- Name: signature_has_reports FK_783437efa25ede83ce24b717e34; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.signature_has_reports
    ADD CONSTRAINT "FK_783437efa25ede83ce24b717e34" FOREIGN KEY ("signatureId") REFERENCES public.signature(id);


--
-- Name: model FK_7996700d600159cdf20dc0d0816; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.model
    ADD CONSTRAINT "FK_7996700d600159cdf20dc0d0816" FOREIGN KEY ("brandId") REFERENCES public.brand(id);


--
-- Name: resource FK_8f8b5ddc1f92b35c31881713a15; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT "FK_8f8b5ddc1f92b35c31881713a15" FOREIGN KEY ("modelId") REFERENCES public.model(id);


--
-- Name: inventory_has_habilitations FK_9050e4f01d9df4a46a0e021c215; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_habilitations
    ADD CONSTRAINT "FK_9050e4f01d9df4a46a0e021c215" FOREIGN KEY ("inventoryId") REFERENCES public.inventory(id);


--
-- Name: employment_record FK_9596f458b4a8846d06b3f062b90; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employment_record
    ADD CONSTRAINT "FK_9596f458b4a8846d06b3f062b90" FOREIGN KEY ("employeeId") REFERENCES public.employees(id);


--
-- Name: positions_closure FK_98261b5fa64b7a505c9d04994b6; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.positions_closure
    ADD CONSTRAINT "FK_98261b5fa64b7a505c9d04994b6" FOREIGN KEY (id_descendant) REFERENCES public.positions(id) ON DELETE CASCADE;


--
-- Name: inventory_has_assigment FK_99adedb0ee32214fe4d716586bb; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_assigment
    ADD CONSTRAINT "FK_99adedb0ee32214fe4d716586bb" FOREIGN KEY ("inventoryId") REFERENCES public.inventory(id);


--
-- Name: bond_has_employee FK_a27f1ff2c940aec61bdce5e1612; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.bond_has_employee
    ADD CONSTRAINT "FK_a27f1ff2c940aec61bdce5e1612" FOREIGN KEY (bond_id) REFERENCES public.bonds(id);


--
-- Name: inventory FK_a2bb7d1da1e3f768f8b4fe55874; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT "FK_a2bb7d1da1e3f768f8b4fe55874" FOREIGN KEY ("ubicationsId") REFERENCES public.ubications(id);


--
-- Name: users FK_a2cecd1a3531c0b041e29ba46e1; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_a2cecd1a3531c0b041e29ba46e1" FOREIGN KEY (role_id) REFERENCES public.role(id);


--
-- Name: employee_has_attendancePermission FK_a752cab83995f8bd5e257aa7d09; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public."employee_has_attendancePermission"
    ADD CONSTRAINT "FK_a752cab83995f8bd5e257aa7d09" FOREIGN KEY (attendance_permission_id) REFERENCES public.attendance_permission(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: signature_has_reports FK_b1129bbfa61348390f31144a082; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.signature_has_reports
    ADD CONSTRAINT "FK_b1129bbfa61348390f31144a082" FOREIGN KEY (type_report_id) REFERENCES public.report_type(id);


--
-- Name: headquarters FK_b4cdb27660d05d3f7bf1dd44f83; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.headquarters
    ADD CONSTRAINT "FK_b4cdb27660d05d3f7bf1dd44f83" FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: positions_closure FK_b55ad2b0e2b11b94e0b8a03f9d5; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.positions_closure
    ADD CONSTRAINT "FK_b55ad2b0e2b11b94e0b8a03f9d5" FOREIGN KEY (id_ancestor) REFERENCES public.positions(id) ON DELETE CASCADE;


--
-- Name: bonds FK_b6513a99cb4dfade876a7974054; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.bonds
    ADD CONSTRAINT "FK_b6513a99cb4dfade876a7974054" FOREIGN KEY (description_id) REFERENCES public.description_bonds(id);


--
-- Name: employee_has_attendancePermission FK_b8fcbededbe4731ec401fa64ee3; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public."employee_has_attendancePermission"
    ADD CONSTRAINT "FK_b8fcbededbe4731ec401fa64ee3" FOREIGN KEY (employment_record_id) REFERENCES public.employment_record(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: staff FK_beda467e427894307f87deac75a; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT "FK_beda467e427894307f87deac75a" FOREIGN KEY (headquarter_id) REFERENCES public.headquarters(id);


--
-- Name: inventory_has_maintenances FK_c9a7ebab75be590cf82cc184498; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_maintenances
    ADD CONSTRAINT "FK_c9a7ebab75be590cf82cc184498" FOREIGN KEY ("inventoryId") REFERENCES public.inventory(id);


--
-- Name: signature FK_ca1c2ff27e72668d9a532a66ad9; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.signature
    ADD CONSTRAINT "FK_ca1c2ff27e72668d9a532a66ad9" FOREIGN KEY (type_signature_id) REFERENCES public.type_signature(id);


--
-- Name: inventory_has_maintenances FK_cb8569b6b222e34e2cf6c21019d; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_maintenances
    ADD CONSTRAINT "FK_cb8569b6b222e34e2cf6c21019d" FOREIGN KEY ("maintenancesId") REFERENCES public.maintenances(id);


--
-- Name: dismissal FK_d8ed36ab56d8d40304e564ba41b; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.dismissal
    ADD CONSTRAINT "FK_d8ed36ab56d8d40304e564ba41b" FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: employment_record FK_d92e594cfc899b09ba73fa57e0f; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employment_record
    ADD CONSTRAINT "FK_d92e594cfc899b09ba73fa57e0f" FOREIGN KEY (bank_id) REFERENCES public.banks(id);


--
-- Name: admission_has_inventory FK_e24a29838916d94f10913b2e72f; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.admission_has_inventory
    ADD CONSTRAINT "FK_e24a29838916d94f10913b2e72f" FOREIGN KEY ("inventoryId") REFERENCES public.inventory(id);


--
-- Name: positions FK_e413c6578fcdae9a8fd673c5bc7; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT "FK_e413c6578fcdae9a8fd673c5bc7" FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: inventory_has_habilitations FK_e426fc7a122ff5a8102a60d1a83; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_habilitations
    ADD CONSTRAINT "FK_e426fc7a122ff5a8102a60d1a83" FOREIGN KEY ("habilitationsId") REFERENCES public.habilitations(id);


--
-- Name: signature_has_reports FK_e5526312e1d9eb692253cd4dea1; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.signature_has_reports
    ADD CONSTRAINT "FK_e5526312e1d9eb692253cd4dea1" FOREIGN KEY (status_application_id) REFERENCES public.status_application(id);


--
-- Name: inventory_has_add_removal FK_e72deb7a6607ad0191b5da9b460; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_add_removal
    ADD CONSTRAINT "FK_e72deb7a6607ad0191b5da9b460" FOREIGN KEY ("addRemovalId") REFERENCES public.add_removal(id);


--
-- Name: staff FK_e7840dd3e0bb653a411f14e3615; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT "FK_e7840dd3e0bb653a411f14e3615" FOREIGN KEY (employee_has_positions_id) REFERENCES public.employee_has_positions(id);


--
-- Name: signature FK_e7919545e8a279f5cff41c87334; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.signature
    ADD CONSTRAINT "FK_e7919545e8a279f5cff41c87334" FOREIGN KEY (staff_id) REFERENCES public.staff(id);


--
-- Name: presences FK_eb357bd9bd7cbaca996631088e9; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.presences
    ADD CONSTRAINT "FK_eb357bd9bd7cbaca996631088e9" FOREIGN KEY (staff_id) REFERENCES public.staff(id);


--
-- Name: admission_has_inventory FK_f0a6b78289b5e8579d6097fd95c; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.admission_has_inventory
    ADD CONSTRAINT "FK_f0a6b78289b5e8579d6097fd95c" FOREIGN KEY ("admissionsDischargesId") REFERENCES public.admissions_discharges(id);


--
-- Name: employment_record FK_f18809518d8a0cadcfea7c24665; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.employment_record
    ADD CONSTRAINT "FK_f18809518d8a0cadcfea7c24665" FOREIGN KEY (type_contract_id) REFERENCES public.type_contract(id);


--
-- Name: staff FK_f2b7d8ca914612b62cc405b9d6f; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT "FK_f2b7d8ca914612b62cc405b9d6f" FOREIGN KEY ("parentId") REFERENCES public.staff(id);


--
-- Name: permission_has_module FK_f51d8e97505f587d39a515dad3b; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.permission_has_module
    ADD CONSTRAINT "FK_f51d8e97505f587d39a515dad3b" FOREIGN KEY (module_id) REFERENCES public.module(id);


--
-- Name: inventory_has_inspections FK_f839c2f2ef05e79769c7532f207; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.inventory_has_inspections
    ADD CONSTRAINT "FK_f839c2f2ef05e79769c7532f207" FOREIGN KEY ("inventoryId") REFERENCES public.inventory(id);


--
-- Name: positions fk_positions_salary; Type: FK CONSTRAINT; Schema: public; Owner: esc
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT fk_positions_salary FOREIGN KEY (salary_id) REFERENCES public.salary(id);


--
-- PostgreSQL database dump complete
--

\unrestrict AO0EfGE6PHeahpIR6wZrhrxYi81It5bAk0DsnvNmoKQZL7EQyOkXxKFA7j2Iw2T


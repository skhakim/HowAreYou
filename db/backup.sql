--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4 (Ubuntu 13.4-1.pgdg20.10+1)
-- Dumped by pg_dump version 13.4 (Ubuntu 13.4-1.pgdg20.10+1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: person_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.person_role AS ENUM (
    'PATIENT',
    'PSYCHIATRIST',
    'BOARD MEMBER'
);


ALTER TYPE public.person_role OWNER TO postgres;

--
-- Name: employee_insert_trigger_fnc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.employee_insert_trigger_fnc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
        arg INT;
BEGIN
    FOREACH arg IN ARRAY TG_ARGV LOOP
    NEW.score = (SELECT sum(o.score)
        FROM test_results INNER JOIN answer a on test_results.test_result_id = a.test_result_id
        INNER JOIN options o on a.option_id = o.option_id
        WHERE a.test_result_id = NEW.test_result_id
        GROUP BY test_results.test_result_id);
    UPDATE test_results
        SET score = NEW.score
        WHERE test_result_id = NEW.test_result_id;
    END LOOP;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.employee_insert_trigger_fnc() OWNER TO postgres;

--
-- Name: myrule(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.myrule() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   BEGIN
    NEW.score := (SELECT sum(o.score)
        FROM test_results INNER JOIN answer a on test_results.test_result_id = a.test_result_id
        INNER JOIN options o on a.option_id = o.option_id
        WHERE a.test_result_id = OLD.test_result_id);
    RETURN NEW;
  END;
$$;


ALTER FUNCTION public.myrule() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answer (
    test_result_id integer NOT NULL,
    option_id integer NOT NULL
);


ALTER TABLE public.answer OWNER TO postgres;

--
-- Name: awards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.awards (
    award_id integer NOT NULL,
    name character varying(64),
    host character varying(256)
);


ALTER TABLE public.awards OWNER TO postgres;

--
-- Name: awards_award_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.awards_award_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.awards_award_id_seq OWNER TO postgres;

--
-- Name: awards_award_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.awards_award_id_seq OWNED BY public.awards.award_id;


--
-- Name: consultation_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consultation_request (
    consultation_request_id integer NOT NULL,
    counsel_id integer NOT NULL,
    test_result_id integer NOT NULL,
    info character varying(256),
    approved boolean,
    schedule character varying(256),
    method character varying(64),
    fee integer,
    con_time timestamp without time zone
);


ALTER TABLE public.consultation_request OWNER TO postgres;

--
-- Name: consultation_request_consultation_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.consultation_request_consultation_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.consultation_request_consultation_request_id_seq OWNER TO postgres;

--
-- Name: consultation_request_consultation_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.consultation_request_consultation_request_id_seq OWNED BY public.consultation_request.consultation_request_id;


--
-- Name: counselling_suggestion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.counselling_suggestion (
    counsel_id integer NOT NULL,
    test_result_id integer,
    psychiatrist_id integer
);


ALTER TABLE public.counselling_suggestion OWNER TO postgres;

--
-- Name: counselling_suggestion_counsel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.counselling_suggestion_counsel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.counselling_suggestion_counsel_id_seq OWNER TO postgres;

--
-- Name: counselling_suggestion_counsel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.counselling_suggestion_counsel_id_seq OWNED BY public.counselling_suggestion.counsel_id;


--
-- Name: degrees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.degrees (
    degree_id integer NOT NULL,
    name character varying(64),
    institution character varying(256)
);


ALTER TABLE public.degrees OWNER TO postgres;

--
-- Name: degrees_degree_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.degrees_degree_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.degrees_degree_id_seq OWNER TO postgres;

--
-- Name: degrees_degree_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.degrees_degree_id_seq OWNED BY public.degrees.degree_id;


--
-- Name: diseases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.diseases (
    disease_id integer NOT NULL,
    name character varying(64) NOT NULL,
    description character varying(256)
);


ALTER TABLE public.diseases OWNER TO postgres;

--
-- Name: diseases_disease_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.diseases_disease_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.diseases_disease_id_seq OWNER TO postgres;

--
-- Name: diseases_disease_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.diseases_disease_id_seq OWNED BY public.diseases.disease_id;


--
-- Name: file_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file_requests (
    file_request_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    title character varying(128) NOT NULL,
    description text,
    is_verified boolean,
    psychiatrist_id integer NOT NULL
);


ALTER TABLE public.file_requests OWNER TO postgres;

--
-- Name: file_requests_file_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.file_requests_file_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.file_requests_file_request_id_seq OWNER TO postgres;

--
-- Name: file_requests_file_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.file_requests_file_request_id_seq OWNED BY public.file_requests.file_request_id;


--
-- Name: file_uploads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file_uploads (
    file_upload_id integer NOT NULL,
    file_request_id integer NOT NULL,
    file_path character varying(256) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    uploader_id integer NOT NULL,
    uploader_comment text,
    notification_pending boolean DEFAULT true
);


ALTER TABLE public.file_uploads OWNER TO postgres;

--
-- Name: file_uploads_file_upload_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.file_uploads_file_upload_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.file_uploads_file_upload_id_seq OWNER TO postgres;

--
-- Name: file_uploads_file_upload_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.file_uploads_file_upload_id_seq OWNED BY public.file_uploads.file_upload_id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    notification_id integer NOT NULL,
    person_id integer NOT NULL,
    "desc" character varying(256),
    type character varying(1) DEFAULT 'M'::character varying,
    seen boolean DEFAULT false
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_notification_id_seq OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- Name: options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.options (
    option_id integer NOT NULL,
    option_text character varying(256),
    score integer,
    question_id integer
);


ALTER TABLE public.options OWNER TO postgres;

--
-- Name: options_option_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.options_option_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.options_option_id_seq OWNER TO postgres;

--
-- Name: options_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.options_option_id_seq OWNED BY public.options.option_id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patients (
    height_inches integer,
    weight_kgs integer,
    location character varying,
    patient_id integer NOT NULL
);


ALTER TABLE public.patients OWNER TO postgres;

--
-- Name: persons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persons (
    person_id integer NOT NULL,
    name character varying(64),
    email character varying(64),
    password_hash character varying(256),
    date_of_birth timestamp without time zone,
    gender character varying(1),
    photo_path character varying(128),
    cellphone character varying(12),
    role character varying(12)
);


ALTER TABLE public.persons OWNER TO postgres;

--
-- Name: persons_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.persons_person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.persons_person_id_seq OWNER TO postgres;

--
-- Name: persons_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.persons_person_id_seq OWNED BY public.persons.person_id;


--
-- Name: psychiatrist_award; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.psychiatrist_award (
    psychiatrist_id integer NOT NULL,
    award_id integer NOT NULL
);


ALTER TABLE public.psychiatrist_award OWNER TO postgres;

--
-- Name: psychiatrist_degree; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.psychiatrist_degree (
    psychiatrist_id integer NOT NULL,
    degree_id integer NOT NULL
);


ALTER TABLE public.psychiatrist_degree OWNER TO postgres;

--
-- Name: psychiatrist_disease; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.psychiatrist_disease (
    psychiatrist_id integer NOT NULL,
    disease_id integer NOT NULL
);


ALTER TABLE public.psychiatrist_disease OWNER TO postgres;

--
-- Name: psychiatrists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.psychiatrists (
    psychiatrist_id integer NOT NULL,
    is_verified boolean,
    available_times character varying(256),
    certificate_id character varying(32),
    fee integer DEFAULT 1000
);


ALTER TABLE public.psychiatrists OWNER TO postgres;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    question_id integer NOT NULL,
    question_text character varying(256),
    created_at timestamp without time zone,
    is_approved boolean
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: questions_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questions_question_id_seq OWNER TO postgres;

--
-- Name: questions_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_question_id_seq OWNED BY public.questions.question_id;


--
-- Name: review_board_member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_board_member (
    board_member_id integer NOT NULL,
    joined_as_board_member timestamp without time zone
);


ALTER TABLE public.review_board_member OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(64)
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: test_question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_question (
    test_id integer NOT NULL,
    question_id integer NOT NULL,
    is_approved boolean,
    pending_delete boolean DEFAULT false,
    delete_reasoning character varying(256)
);


ALTER TABLE public.test_question OWNER TO postgres;

--
-- Name: test_result_disease; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_result_disease (
    test_result_id integer NOT NULL,
    disease_id integer NOT NULL
);


ALTER TABLE public.test_result_disease OWNER TO postgres;

--
-- Name: test_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_results (
    test_result_id integer NOT NULL,
    test_id integer NOT NULL,
    patient_id integer NOT NULL,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    verifier_id integer,
    verified_at timestamp without time zone,
    machine_report character varying(256),
    manual_report character varying(256),
    score integer DEFAULT 0
);


ALTER TABLE public.test_results OWNER TO postgres;

--
-- Name: test_results_test_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_results_test_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_results_test_result_id_seq OWNER TO postgres;

--
-- Name: test_results_test_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_results_test_result_id_seq OWNED BY public.test_results.test_result_id;


--
-- Name: tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tests (
    test_id integer NOT NULL,
    name character varying(64) NOT NULL,
    description character varying(256),
    created_at timestamp without time zone NOT NULL,
    psychiatrist_id_of_added_by integer
);


ALTER TABLE public.tests OWNER TO postgres;

--
-- Name: tests_test_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tests_test_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tests_test_id_seq OWNER TO postgres;

--
-- Name: tests_test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tests_test_id_seq OWNED BY public.tests.test_id;


--
-- Name: awards award_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.awards ALTER COLUMN award_id SET DEFAULT nextval('public.awards_award_id_seq'::regclass);


--
-- Name: consultation_request consultation_request_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultation_request ALTER COLUMN consultation_request_id SET DEFAULT nextval('public.consultation_request_consultation_request_id_seq'::regclass);


--
-- Name: counselling_suggestion counsel_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.counselling_suggestion ALTER COLUMN counsel_id SET DEFAULT nextval('public.counselling_suggestion_counsel_id_seq'::regclass);


--
-- Name: degrees degree_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degrees ALTER COLUMN degree_id SET DEFAULT nextval('public.degrees_degree_id_seq'::regclass);


--
-- Name: diseases disease_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diseases ALTER COLUMN disease_id SET DEFAULT nextval('public.diseases_disease_id_seq'::regclass);


--
-- Name: file_requests file_request_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_requests ALTER COLUMN file_request_id SET DEFAULT nextval('public.file_requests_file_request_id_seq'::regclass);


--
-- Name: file_uploads file_upload_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_uploads ALTER COLUMN file_upload_id SET DEFAULT nextval('public.file_uploads_file_upload_id_seq'::regclass);


--
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- Name: options option_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options ALTER COLUMN option_id SET DEFAULT nextval('public.options_option_id_seq'::regclass);


--
-- Name: persons person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons ALTER COLUMN person_id SET DEFAULT nextval('public.persons_person_id_seq'::regclass);


--
-- Name: questions question_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions ALTER COLUMN question_id SET DEFAULT nextval('public.questions_question_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: test_results test_result_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results ALTER COLUMN test_result_id SET DEFAULT nextval('public.test_results_test_result_id_seq'::regclass);


--
-- Name: tests test_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests ALTER COLUMN test_id SET DEFAULT nextval('public.tests_test_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
d53109438b4d
\.


--
-- Data for Name: answer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answer (test_result_id, option_id) FROM stdin;
1	76
1	71
1	86
1	91
1	96
1	81
1	66
1	101
5	101
5	81
5	91
5	86
5	96
5	76
5	68
5	72
6	101
6	81
6	92
6	86
6	96
6	76
6	68
6	72
7	101
7	81
7	92
7	86
7	96
7	76
7	68
7	72
16	101
16	81
16	92
16	86
16	96
16	76
16	68
16	72
17	101
17	81
17	92
17	86
17	96
17	76
17	68
17	72
18	101
18	81
18	92
18	86
18	96
18	76
18	68
18	72
19	101
19	81
19	92
19	86
19	96
19	76
19	68
19	72
20	101
20	81
20	92
20	86
20	96
20	76
20	68
20	72
21	101
21	81
21	92
21	86
21	96
21	76
21	68
21	72
22	101
22	81
22	92
22	86
22	96
22	76
22	68
22	72
36	66
36	73
36	77
36	84
36	86
36	94
36	97
36	102
37	66
37	73
37	77
37	84
37	86
37	94
37	96
37	103
38	66
38	73
38	77
38	84
38	86
38	94
38	97
38	102
54	66
54	73
54	77
54	84
54	86
54	94
54	97
54	102
71	66
71	73
71	77
71	84
71	86
71	94
71	97
71	102
72	66
72	73
72	77
72	84
72	86
72	94
72	97
72	102
73	66
73	73
73	77
73	84
73	86
73	94
73	97
73	102
74	66
74	73
74	77
74	84
74	86
74	94
74	97
74	102
75	66
75	73
75	77
75	84
75	86
75	94
75	97
75	102
76	69
76	74
76	79
76	84
76	89
76	95
76	99
76	104
78	66
78	72
78	77
78	82
78	87
78	92
78	97
78	102
79	107
79	111
79	116
79	122
79	127
80	66
80	73
80	77
80	82
81	67
81	72
81	77
81	82
81	87
81	93
81	96
81	103
1098	106
82	272
82	277
82	282
82	287
82	292
82	297
82	302
82	307
82	312
82	317
82	348
83	107
83	113
83	119
83	123
84	109
84	115
84	119
84	124
85	68
85	73
85	79
85	83
85	88
85	92
85	99
85	101
1098	112
85	136
85	138
86	106
86	111
86	116
86	121
95	106
95	112
95	116
95	122
96	272
96	277
96	282
96	287
96	292
96	297
96	302
96	307
96	313
96	317
96	349
97	272
97	277
97	282
97	287
97	292
97	297
97	302
97	307
97	312
97	317
97	349
98	1
98	6
98	14
98	17
98	25
98	28
98	31
98	37
98	42
98	49
98	52
98	57
98	64
99	106
99	112
99	119
100	4
100	10
100	12
100	17
100	22
100	28
100	34
100	40
100	43
100	48
100	54
100	60
100	65
101	75
101	80
101	82
101	88
101	94
101	98
101	104
101	136
101	443
102	106
102	114
102	120
103	74
103	78
103	84
103	90
103	91
103	100
103	105
103	136
103	444
104	4
104	7
104	14
104	19
104	21
104	30
104	35
104	37
104	45
104	47
104	53
104	60
104	61
105	75
105	76
105	85
105	90
105	94
105	98
105	104
105	135
105	444
106	3
106	7
106	15
106	17
106	25
106	30
106	32
106	36
106	43
106	46
106	55
106	59
106	64
107	71
107	76
107	81
107	87
107	91
107	100
107	101
107	134
107	442
108	71
108	80
108	85
108	86
108	94
108	97
108	105
108	134
108	443
109	1
109	9
109	12
109	16
109	23
109	26
109	34
109	36
109	41
109	46
109	55
109	57
109	64
110	2
110	6
110	12
110	19
110	23
110	29
110	33
110	40
110	42
110	49
110	51
110	58
110	61
111	106
111	111
111	120
112	3
112	6
112	15
112	16
112	25
112	30
112	35
112	37
112	41
112	47
112	55
112	58
112	65
113	74
113	78
113	85
113	86
113	94
113	100
113	102
113	135
113	444
114	75
114	80
114	81
114	88
114	91
114	96
114	103
114	134
114	443
115	108
115	115
115	116
116	110
116	111
116	118
117	110
117	112
117	117
118	107
118	112
118	120
119	74
119	79
119	82
119	90
119	91
119	98
119	103
119	135
119	444
120	109
120	115
120	120
121	3
121	10
121	14
121	16
121	25
121	26
121	35
121	37
121	41
121	48
121	55
121	58
121	64
122	108
122	111
122	119
123	71
123	80
123	84
123	90
123	91
123	100
123	105
123	136
123	442
124	109
124	114
124	120
125	71
125	79
125	81
125	88
125	95
125	97
125	104
125	135
125	442
126	2
126	7
126	13
126	16
126	24
126	28
126	35
126	36
126	42
126	46
126	53
126	57
126	62
127	110
127	112
127	117
128	73
128	79
128	85
128	89
128	94
128	98
128	103
128	134
128	444
129	1
129	7
129	11
129	18
129	22
129	29
129	32
129	40
129	41
129	46
129	53
129	56
129	63
130	71
130	77
130	83
130	89
130	93
130	98
130	102
130	136
130	444
131	106
131	111
131	120
132	106
132	114
132	118
133	72
133	77
133	83
133	89
133	94
133	98
133	103
133	135
133	443
134	109
134	114
134	119
135	108
135	113
135	116
136	109
136	112
136	118
137	109
137	113
137	118
138	71
138	77
138	83
138	89
138	93
138	99
138	104
138	136
138	443
139	107
139	115
139	117
140	72
140	76
140	84
140	88
140	92
140	99
140	102
140	136
140	442
141	108
141	114
141	118
142	106
142	111
142	119
143	72
143	76
143	85
143	86
143	92
143	98
143	102
143	136
143	443
144	109
144	111
144	118
145	5
145	8
145	11
145	18
145	24
145	29
145	31
145	36
145	42
145	49
145	55
145	60
145	63
146	106
146	114
146	120
147	106
147	111
147	117
148	3
148	8
148	12
148	17
148	21
148	26
148	33
148	39
148	44
148	46
148	51
148	59
148	65
149	75
149	80
149	81
149	89
149	95
149	100
149	104
149	134
149	442
150	106
150	115
150	117
151	110
151	114
151	120
152	71
152	78
152	83
152	90
152	93
152	99
152	105
152	134
152	444
153	74
153	79
153	82
153	88
153	92
153	97
153	102
153	136
153	442
154	5
154	6
154	12
154	19
154	24
154	30
154	35
154	37
154	42
154	47
154	54
154	57
154	65
155	3
155	10
155	13
155	17
155	25
155	30
155	35
155	40
155	44
155	50
155	52
155	60
155	62
156	74
156	77
156	85
156	86
156	94
156	98
156	104
156	136
156	442
157	73
157	77
157	83
157	90
157	92
157	98
157	104
157	136
157	443
158	5
158	8
158	15
158	16
158	24
158	27
158	35
158	38
158	41
158	47
158	55
158	59
158	64
159	2
159	6
159	14
159	18
159	25
159	27
159	35
159	38
159	44
159	48
159	51
159	57
159	63
160	75
160	80
160	83
160	88
160	91
160	96
160	105
160	134
160	443
161	108
161	111
161	120
162	108
162	113
162	117
163	5
163	8
163	15
163	17
163	21
163	28
163	33
163	39
163	41
163	48
163	54
163	57
163	65
164	4
164	8
164	15
164	16
164	23
164	29
164	34
164	38
164	42
164	48
164	53
164	56
164	63
165	73
165	78
165	84
165	86
165	91
165	96
165	103
165	135
165	444
166	73
166	79
166	84
166	87
166	91
166	99
166	101
166	136
166	443
167	3
167	10
167	13
167	19
167	23
167	29
167	35
167	37
167	42
167	48
167	55
167	57
167	63
168	1
168	7
168	11
168	17
168	22
168	30
168	35
168	38
168	41
168	49
168	52
168	60
168	61
169	2
169	10
169	15
169	16
169	23
169	30
169	32
169	38
169	41
169	46
169	54
169	60
169	65
170	1
170	10
170	15
170	20
170	23
170	27
170	35
170	36
170	44
170	50
170	52
170	60
170	65
171	1
171	7
171	12
171	17
171	21
171	29
171	35
171	38
171	44
171	50
171	51
171	57
171	62
172	75
172	76
172	85
172	89
172	91
172	97
172	102
172	135
172	442
173	108
173	114
173	117
174	109
174	114
174	117
175	107
175	115
175	120
176	106
176	113
176	118
177	3
177	6
177	14
177	18
177	24
177	27
177	31
177	39
177	44
177	48
177	54
177	57
177	61
178	4
178	7
178	11
178	18
178	25
178	29
178	35
178	38
178	45
178	49
178	51
178	58
178	61
179	1
179	10
179	11
179	20
179	21
179	27
179	31
179	36
179	45
179	50
179	51
179	58
179	65
180	107
180	113
180	118
181	73
181	78
181	82
181	89
181	93
181	97
181	102
181	136
181	443
182	72
182	76
182	82
182	89
182	92
182	97
182	101
182	135
182	444
183	108
183	113
183	118
184	108
184	112
184	119
185	109
185	111
185	116
186	2
186	7
186	15
186	18
186	24
186	30
186	33
186	39
186	43
186	46
186	54
186	60
186	61
187	72
187	77
187	84
187	88
187	94
187	98
187	102
187	135
187	442
188	71
188	78
188	84
188	89
188	92
188	97
188	102
188	135
188	444
189	4
189	9
189	12
189	19
189	25
189	30
189	32
189	38
189	44
189	48
189	51
189	60
189	63
190	75
190	76
190	84
190	87
190	95
190	96
190	104
190	136
190	443
191	75
191	78
191	83
191	90
191	92
191	96
191	101
191	135
191	442
192	3
192	10
192	11
192	18
192	21
192	28
192	31
192	38
192	41
192	46
192	51
192	57
192	63
193	72
193	80
193	84
193	86
193	92
193	100
193	103
193	134
193	444
194	74
194	78
194	84
194	87
194	92
194	96
194	101
194	135
194	442
195	75
195	77
195	84
195	86
195	93
195	99
195	101
195	135
195	442
196	1
196	8
196	14
196	18
196	23
196	30
196	35
196	37
196	45
196	49
196	51
196	57
196	62
197	75
197	77
197	83
197	89
197	92
197	98
197	101
197	135
197	442
198	73
198	79
198	85
198	87
198	94
198	100
198	102
198	135
198	442
199	3
199	9
199	13
199	16
199	23
199	26
199	35
199	40
199	42
199	49
199	54
199	60
199	65
200	1
200	7
200	14
200	20
200	22
200	27
200	33
200	36
200	42
200	47
200	54
200	60
200	62
201	5
201	10
201	12
201	16
201	23
201	28
201	32
201	38
201	42
201	46
201	52
201	56
201	63
202	109
202	112
202	116
203	75
203	78
203	81
203	89
203	91
203	100
203	101
203	134
203	443
204	75
204	78
204	85
204	89
204	94
204	99
204	105
204	135
204	444
205	2
205	7
205	14
205	19
205	22
205	29
205	31
205	40
205	43
205	46
205	54
205	59
205	62
206	74
206	77
206	83
206	88
206	94
206	96
206	103
206	134
206	443
207	71
207	79
207	85
207	90
207	95
207	97
207	104
207	134
207	444
208	5
208	9
208	12
208	19
208	25
208	30
208	33
208	37
208	43
208	49
208	55
208	56
208	61
209	108
209	114
209	116
210	2
210	6
210	12
210	19
210	22
210	28
210	34
210	38
210	41
210	47
210	51
210	60
210	62
211	71
211	80
211	83
211	89
211	94
211	99
211	105
211	134
211	443
212	4
212	10
212	13
212	19
212	21
212	28
212	35
212	38
212	42
212	50
212	55
212	59
212	63
213	110
213	113
213	116
214	1
214	6
214	11
214	20
214	25
214	30
214	31
214	40
214	43
214	49
214	52
214	58
214	64
215	75
215	76
215	83
215	87
215	91
215	96
215	103
215	136
215	444
216	74
216	76
216	84
216	90
216	95
216	98
216	104
216	136
216	442
217	106
217	111
217	117
218	3
218	8
218	12
218	20
218	23
218	26
218	31
218	38
218	44
218	49
218	54
218	58
218	64
219	74
219	79
219	85
219	89
219	92
219	100
219	102
219	135
219	444
220	74
220	77
220	85
220	89
220	92
220	99
220	104
220	136
220	443
221	75
221	78
221	82
221	87
221	94
221	99
221	105
221	135
221	444
222	107
222	113
222	120
223	5
223	6
223	12
223	18
223	23
223	29
223	34
223	38
223	43
223	46
223	54
223	57
223	65
224	110
224	114
224	120
225	74
225	80
225	81
225	90
225	92
225	97
225	102
225	136
225	443
226	110
226	111
226	118
227	71
227	80
227	83
227	90
227	94
227	100
227	101
227	134
227	443
228	74
228	77
228	84
228	88
228	92
228	97
228	101
228	135
228	442
229	3
229	10
229	14
229	17
229	23
229	27
229	35
229	38
229	43
229	46
229	53
229	59
229	65
230	106
230	112
230	119
231	3
231	7
231	14
231	18
231	21
231	27
231	33
231	37
231	44
231	49
231	52
231	57
231	65
232	73
232	78
232	85
232	88
232	92
232	99
232	102
232	135
232	443
233	110
233	112
233	118
234	75
234	78
234	82
234	88
234	93
234	99
234	104
234	134
234	443
235	4
235	7
235	12
235	18
235	22
235	28
235	35
235	36
235	42
235	49
235	52
235	56
235	64
236	2
236	6
236	13
236	19
236	22
236	30
236	32
236	40
236	45
236	46
236	51
236	60
236	65
237	107
237	111
237	119
238	3
238	8
238	14
238	19
238	22
238	29
238	34
238	40
238	41
238	47
238	55
238	60
238	63
239	4
239	10
239	11
239	19
239	24
239	30
239	34
239	37
239	44
239	46
239	53
239	60
239	62
240	106
240	113
240	117
241	72
241	78
241	81
241	87
241	95
241	98
241	101
241	136
241	443
242	74
242	80
242	85
242	87
242	95
242	97
242	103
242	134
242	444
243	71
243	80
243	83
243	88
243	92
243	100
243	105
243	134
243	442
244	106
244	115
244	120
245	74
245	78
245	81
245	87
245	92
245	100
245	104
245	134
245	442
246	107
246	115
246	116
247	1
247	8
247	15
247	20
247	21
247	27
247	35
247	36
247	45
247	48
247	55
247	57
247	65
248	107
248	112
248	118
249	74
249	79
249	85
249	90
249	91
249	98
249	105
249	134
249	443
250	72
250	80
250	82
250	90
250	92
250	97
250	104
250	134
250	442
251	108
251	113
251	119
252	3
252	7
252	11
252	20
252	24
252	28
252	35
252	40
252	44
252	49
252	55
252	58
252	63
253	72
253	80
253	83
253	90
253	93
253	99
253	101
253	136
253	443
254	106
254	111
254	116
255	109
255	114
255	118
256	4
256	10
256	11
256	16
256	24
256	30
256	34
256	36
256	42
256	48
256	51
256	58
256	63
257	106
257	111
257	118
258	72
258	77
258	85
258	89
258	91
258	96
258	105
258	134
258	444
259	75
259	80
259	82
259	90
259	91
259	100
259	104
259	134
259	442
260	71
260	77
260	84
260	86
260	95
260	100
260	105
260	135
260	442
261	73
261	76
261	84
261	86
261	92
261	100
261	103
261	136
261	442
262	4
262	8
262	13
262	19
262	22
262	28
262	33
262	38
262	43
262	46
262	55
262	58
262	62
263	109
263	115
263	118
264	74
264	78
264	83
264	87
264	91
264	100
264	104
264	134
264	444
265	73
265	80
265	82
265	89
265	92
265	99
265	104
265	135
265	444
266	71
266	77
266	82
266	89
266	95
266	99
266	103
266	134
266	444
267	110
267	112
267	116
268	2
268	8
268	15
268	20
268	21
268	26
268	35
268	40
268	41
268	46
268	54
268	56
268	65
269	1
269	10
269	13
269	18
269	21
269	30
269	33
269	38
269	41
269	50
269	52
269	60
269	63
270	74
270	78
270	82
270	88
270	93
270	100
270	104
270	136
270	443
271	73
271	79
271	84
271	89
271	91
271	96
271	101
271	134
271	443
272	3
272	10
272	15
272	20
272	23
272	28
272	33
272	37
272	41
272	49
272	52
272	57
272	64
273	75
273	78
273	82
273	90
273	92
273	100
273	101
273	135
273	442
274	107
274	114
274	118
275	109
275	111
275	119
276	74
276	78
276	82
276	90
276	94
276	100
276	104
276	134
276	442
277	1
277	8
277	14
277	17
277	24
277	29
277	31
277	39
277	44
277	46
277	55
277	56
277	63
278	107
278	111
278	119
279	71
279	80
279	85
279	86
279	95
279	98
279	102
279	134
279	443
280	2
280	8
280	11
280	19
280	22
280	27
280	34
280	38
280	44
280	49
280	52
280	57
280	63
281	2
281	9
281	12
281	16
281	22
281	29
281	33
281	40
281	42
281	48
281	53
281	56
281	65
282	72
282	79
282	81
282	87
282	95
282	99
282	103
282	136
282	444
283	1
283	9
283	15
283	16
283	25
283	26
283	35
283	36
283	45
283	50
283	53
283	56
283	64
284	5
284	7
284	13
284	20
284	23
284	30
284	34
284	37
284	42
284	48
284	51
284	58
284	65
285	72
285	79
285	82
285	86
285	93
285	97
285	102
285	136
285	442
286	1
286	9
286	11
286	17
286	22
286	28
286	35
286	38
286	43
286	49
286	55
286	58
286	65
287	73
287	77
287	84
287	86
287	95
287	96
287	101
287	136
287	443
288	71
288	80
288	84
288	88
288	95
288	100
288	104
288	136
288	442
289	106
289	114
289	118
290	74
290	79
290	85
290	88
290	92
290	97
290	105
290	134
290	443
291	108
291	112
291	117
292	72
292	76
292	85
292	88
292	95
292	97
292	102
292	135
292	442
293	72
293	76
293	81
293	86
293	92
293	96
293	103
293	134
293	443
294	73
294	80
294	84
294	86
294	91
294	99
294	102
294	136
294	444
295	2
295	8
295	13
295	20
295	24
295	29
295	32
295	38
295	43
295	49
295	54
295	56
295	64
296	2
296	10
296	14
296	20
296	21
296	29
296	33
296	38
296	45
296	50
296	51
296	58
296	62
297	72
297	76
297	81
297	88
297	92
297	97
297	105
297	136
297	444
298	4
298	6
298	14
298	17
298	22
298	26
298	33
298	36
298	41
298	46
298	52
298	60
298	62
299	74
299	80
299	83
299	89
299	95
299	98
299	101
299	134
299	444
300	3
300	9
300	14
300	17
300	25
300	30
300	31
300	40
300	43
300	50
300	54
300	60
300	62
301	2
301	8
301	14
301	16
301	25
301	27
301	32
301	39
301	42
301	50
301	53
301	57
301	65
302	110
302	115
302	116
303	106
303	115
303	119
304	5
304	7
304	15
304	17
304	23
304	29
304	34
304	38
304	45
304	48
304	52
304	59
304	64
305	108
305	113
305	119
306	4
306	9
306	12
306	19
306	25
306	28
306	32
306	40
306	45
306	49
306	52
306	58
306	63
307	108
307	111
307	118
308	108
308	112
308	120
309	110
309	115
309	118
310	2
310	6
310	15
310	18
310	23
310	29
310	33
310	38
310	44
310	46
310	53
310	58
310	62
311	75
311	77
311	83
311	86
311	95
311	100
311	104
311	136
311	444
312	108
312	113
312	116
313	107
313	114
313	120
314	106
314	113
314	120
315	3
315	9
315	11
315	19
315	23
315	28
315	33
315	36
315	45
315	46
315	51
315	58
315	64
316	2
316	10
316	11
316	20
316	24
316	26
316	33
316	39
316	43
316	48
316	54
316	58
316	65
317	108
317	113
317	117
318	4
318	9
318	12
318	20
318	22
318	30
318	32
318	40
318	41
318	49
318	53
318	57
318	63
319	74
319	77
319	83
319	90
319	94
319	96
319	105
319	136
319	442
320	109
320	115
320	116
321	71
321	78
321	85
321	87
321	94
321	96
321	105
321	134
321	442
322	71
322	78
322	81
322	89
322	94
322	96
322	102
322	134
322	442
323	74
323	77
323	85
323	87
323	92
323	96
323	103
323	134
323	444
324	73
324	79
324	82
324	87
324	91
324	99
324	105
324	136
324	442
325	2
325	9
325	12
325	19
325	21
325	29
325	32
325	37
325	44
325	49
325	55
325	56
325	65
326	73
326	77
326	83
326	90
326	95
326	98
326	102
326	135
326	443
327	72
327	78
327	83
327	90
327	94
327	100
327	104
327	136
327	444
328	4
328	9
328	15
328	20
328	25
328	26
328	33
328	37
328	42
328	48
328	54
328	56
328	63
329	2
329	10
329	14
329	19
329	24
329	29
329	35
329	36
329	43
329	46
329	52
329	58
329	65
330	2
330	10
330	11
330	18
330	23
330	27
330	31
330	36
330	44
330	50
330	54
330	56
330	64
331	107
331	114
331	118
332	3
332	9
332	13
332	19
332	25
332	27
332	34
332	38
332	41
332	48
332	51
332	58
332	62
333	109
333	111
333	116
334	110
334	111
334	118
335	108
335	115
335	119
336	109
336	114
336	117
337	74
337	79
337	81
337	87
337	93
337	97
337	105
337	134
337	444
338	2
338	10
338	15
338	20
338	23
338	30
338	31
338	40
338	43
338	48
338	54
338	56
338	63
339	73
339	80
339	83
339	89
339	95
339	97
339	102
339	135
339	444
340	107
340	112
340	118
341	110
341	112
341	117
342	106
342	111
342	116
343	1
343	8
343	13
343	19
343	24
343	27
343	32
343	39
343	44
343	47
343	54
343	56
343	64
344	4
344	9
344	12
344	20
344	25
344	27
344	33
344	36
344	42
344	49
344	51
344	58
344	65
345	110
345	114
345	119
346	2
346	10
346	11
346	16
346	24
346	27
346	35
346	36
346	42
346	46
346	55
346	58
346	61
347	106
347	113
347	120
348	110
348	111
348	119
349	3
349	10
349	13
349	18
349	22
349	30
349	35
349	40
349	41
349	48
349	51
349	57
349	65
350	2
350	10
350	12
350	20
350	22
350	29
350	32
350	36
350	42
350	49
350	55
350	60
350	61
351	1
351	7
351	14
351	16
351	25
351	27
351	34
351	39
351	43
351	47
351	51
351	56
351	63
352	107
352	112
352	120
353	74
353	76
353	82
353	86
353	94
353	98
353	103
353	136
353	444
354	5
354	6
354	13
354	17
354	24
354	27
354	35
354	37
354	43
354	47
354	55
354	59
354	61
355	74
355	78
355	85
355	89
355	94
355	100
355	103
355	134
355	442
356	107
356	115
356	120
357	75
357	77
357	85
357	86
357	91
357	100
357	103
357	136
357	444
358	110
358	111
358	117
359	74
359	79
359	84
359	89
359	91
359	100
359	101
359	136
359	443
360	4
360	7
360	15
360	20
360	22
360	26
360	31
360	40
360	43
360	49
360	54
360	59
360	64
361	73
361	78
361	85
361	90
361	91
361	100
361	104
361	135
361	443
362	107
362	112
362	120
363	74
363	80
363	84
363	88
363	93
363	99
363	104
363	135
363	444
364	108
364	115
364	117
365	71
365	77
365	83
365	86
365	93
365	97
365	103
365	135
365	444
366	107
366	115
366	119
367	107
367	112
367	117
368	107
368	113
368	119
369	71
369	76
369	85
369	89
369	94
369	100
369	105
369	134
369	444
370	109
370	113
370	116
371	5
371	6
371	11
371	19
371	25
371	28
371	35
371	37
371	43
371	49
371	54
371	58
371	62
372	2
372	6
372	14
372	20
372	25
372	26
372	32
372	36
372	43
372	48
372	55
372	58
372	63
373	110
373	112
373	119
374	74
374	79
374	85
374	89
374	91
374	97
374	103
374	135
374	444
375	75
375	79
375	84
375	87
375	94
375	96
375	104
375	134
375	443
376	3
376	6
376	11
376	17
376	21
376	26
376	33
376	37
376	43
376	48
376	54
376	59
376	63
377	72
377	76
377	81
377	90
377	95
377	100
377	104
377	136
377	442
378	110
378	114
378	118
379	74
379	80
379	81
379	90
379	95
379	99
379	103
379	134
379	443
380	1
380	8
380	15
380	18
380	25
380	26
380	35
380	37
380	45
380	50
380	51
380	56
380	61
381	3
381	10
381	14
381	16
381	24
381	27
381	35
381	38
381	44
381	49
381	55
381	56
381	64
382	1
382	9
382	11
382	17
382	21
382	29
382	31
382	40
382	41
382	50
382	54
382	60
382	65
383	4
383	6
383	14
383	17
383	25
383	27
383	33
383	40
383	43
383	48
383	52
383	57
383	61
384	5
384	8
384	11
384	20
384	21
384	26
384	33
384	36
384	45
384	47
384	53
384	59
384	65
385	71
385	80
385	83
385	87
385	95
385	98
385	101
385	136
385	442
386	1
386	7
386	14
386	18
386	23
386	26
386	33
386	38
386	43
386	47
386	51
386	58
386	65
387	73
387	80
387	84
387	89
387	95
387	100
387	103
387	135
387	444
388	106
388	112
388	120
389	71
389	79
389	81
389	90
389	93
389	100
389	104
389	135
389	443
390	72
390	77
390	82
390	90
390	92
390	97
390	103
390	136
390	443
391	1
391	6
391	15
391	16
391	22
391	27
391	32
391	40
391	45
391	49
391	55
391	57
391	63
392	75
392	79
392	83
392	87
392	92
392	100
392	104
392	135
392	443
393	2
393	9
393	12
393	16
393	24
393	26
393	33
393	40
393	44
393	49
393	55
393	57
393	62
394	109
394	111
394	119
395	5
395	8
395	13
395	18
395	23
395	28
395	34
395	37
395	44
395	46
395	53
395	60
395	64
396	73
396	78
396	82
396	88
396	94
396	96
396	104
396	135
396	443
397	4
397	9
397	15
397	18
397	23
397	26
397	31
397	40
397	45
397	50
397	52
397	59
397	65
398	4
398	6
398	12
398	17
398	23
398	26
398	31
398	40
398	41
398	47
398	54
398	57
398	62
399	108
399	111
399	120
400	72
400	78
400	85
400	88
400	93
400	96
400	102
400	134
400	443
401	74
401	78
401	83
401	89
401	94
401	96
401	103
401	136
401	442
402	74
402	77
402	85
402	89
402	93
402	98
402	102
402	134
402	443
403	74
403	77
403	82
403	89
403	95
403	97
403	101
403	135
403	442
404	4
404	7
404	15
404	18
404	25
404	29
404	34
404	37
404	43
404	46
404	55
404	60
404	61
405	5
405	8
405	11
405	16
405	23
405	26
405	34
405	38
405	45
405	50
405	54
405	60
405	61
406	109
406	114
406	118
407	5
407	7
407	11
407	19
407	25
407	26
407	35
407	37
407	42
407	50
407	54
407	56
407	63
408	4
408	10
408	14
408	16
408	24
408	27
408	31
408	37
408	43
408	50
408	51
408	60
408	61
409	5
409	9
409	15
409	17
409	21
409	27
409	33
409	40
409	41
409	48
409	52
409	57
409	64
410	110
410	115
410	117
411	71
411	77
411	83
411	88
411	91
411	100
411	103
411	136
411	443
412	108
412	115
412	117
413	71
413	76
413	83
413	89
413	92
413	96
413	105
413	134
413	443
414	75
414	76
414	82
414	90
414	95
414	100
414	105
414	136
414	444
415	72
415	78
415	84
415	88
415	92
415	97
415	101
415	134
415	442
416	72
416	79
416	82
416	90
416	94
416	98
416	101
416	136
416	444
417	3
417	9
417	13
417	20
417	21
417	29
417	33
417	38
417	45
417	47
417	55
417	58
417	61
418	2
418	7
418	13
418	19
418	25
418	27
418	31
418	37
418	44
418	50
418	55
418	58
418	61
419	72
419	77
419	84
419	86
419	92
419	97
419	105
419	134
419	443
420	2
420	7
420	13
420	18
420	24
420	27
420	32
420	37
420	44
420	48
420	53
420	60
420	63
421	110
421	112
421	116
422	5
422	7
422	12
422	18
422	23
422	28
422	31
422	37
422	43
422	48
422	54
422	58
422	61
423	110
423	115
423	118
424	72
424	76
424	83
424	88
424	93
424	100
424	105
424	134
424	442
425	110
425	111
425	119
426	72
426	78
426	82
426	89
426	91
426	96
426	104
426	136
426	444
427	107
427	113
427	120
428	75
428	79
428	84
428	89
428	92
428	96
428	103
428	136
428	442
429	3
429	9
429	12
429	17
429	23
429	26
429	32
429	36
429	45
429	49
429	55
429	58
429	61
430	74
430	77
430	81
430	87
430	95
430	97
430	104
430	136
430	443
431	1
431	7
431	11
431	19
431	23
431	29
431	34
431	37
431	44
431	48
431	52
431	59
431	64
432	5
432	10
432	12
432	19
432	25
432	28
432	33
432	39
432	43
432	50
432	52
432	56
432	63
433	109
433	114
433	119
434	1
434	7
434	12
434	20
434	23
434	30
434	33
434	36
434	42
434	48
434	53
434	57
434	64
435	110
435	114
435	116
436	107
436	115
436	116
437	108
437	115
437	117
438	4
438	8
438	11
438	18
438	22
438	26
438	32
438	36
438	45
438	50
438	53
438	60
438	63
439	5
439	10
439	12
439	18
439	22
439	30
439	33
439	39
439	44
439	50
439	51
439	59
439	64
440	4
440	8
440	15
440	19
440	22
440	30
440	32
440	36
440	42
440	49
440	54
440	58
440	63
441	73
441	76
441	85
441	89
441	93
441	96
441	101
441	134
441	442
442	3
442	8
442	15
442	17
442	24
442	28
442	33
442	37
442	45
442	48
442	51
442	59
442	62
443	73
443	78
443	81
443	90
443	95
443	96
443	104
443	134
443	443
444	2
444	8
444	11
444	19
444	24
444	27
444	32
444	37
444	44
444	47
444	54
444	59
444	65
445	108
445	112
445	116
446	107
446	113
446	118
447	106
447	112
447	116
448	108
448	111
448	118
449	4
449	7
449	12
449	17
449	21
449	28
449	35
449	38
449	44
449	48
449	52
449	60
449	64
450	3
450	8
450	13
450	17
450	22
450	28
450	33
450	39
450	44
450	46
450	54
450	59
450	61
451	74
451	80
451	85
451	86
451	91
451	97
451	104
451	135
451	444
452	108
452	112
452	116
453	107
453	114
453	118
454	72
454	80
454	82
454	90
454	92
454	97
454	103
454	136
454	442
455	74
455	77
455	83
455	88
455	95
455	99
455	102
455	134
455	444
456	4
456	6
456	15
456	18
456	24
456	27
456	35
456	36
456	42
456	49
456	52
456	59
456	61
457	71
457	76
457	83
457	88
457	95
457	98
457	104
457	135
457	444
458	110
458	111
458	120
459	73
459	78
459	85
459	87
459	92
459	96
459	102
459	135
459	442
460	4
460	10
460	14
460	18
460	23
460	30
460	31
460	39
460	42
460	48
460	53
460	59
460	65
461	72
461	76
461	81
461	89
461	95
461	96
461	102
461	135
461	442
462	73
462	80
462	83
462	87
462	91
462	98
462	101
462	136
462	444
463	74
463	79
463	83
463	87
463	94
463	97
463	103
463	135
463	444
464	74
464	78
464	81
464	86
464	91
464	96
464	104
464	134
464	443
465	73
465	78
465	83
465	88
465	91
465	96
465	101
465	134
465	444
466	2
466	9
466	12
466	18
466	22
466	26
466	33
466	39
466	45
466	50
466	54
466	59
466	62
467	3
467	9
467	14
467	20
467	22
467	28
467	34
467	38
467	45
467	50
467	54
467	59
467	61
468	1
468	10
468	12
468	16
468	22
468	28
468	31
468	38
468	43
468	50
468	54
468	57
468	63
469	5
469	7
469	14
469	17
469	25
469	27
469	34
469	40
469	42
469	48
469	51
469	58
469	61
470	72
470	78
470	82
470	87
470	94
470	100
470	103
470	136
470	442
471	72
471	79
471	81
471	88
471	93
471	99
471	102
471	134
471	444
472	4
472	7
472	11
472	17
472	23
472	30
472	35
472	37
472	44
472	49
472	55
472	57
472	62
473	75
473	76
473	82
473	88
473	92
473	100
473	104
473	135
473	442
474	110
474	115
474	120
475	106
475	111
475	120
476	109
476	111
476	117
477	5
477	10
477	12
477	20
477	24
477	26
477	33
477	39
477	45
477	49
477	55
477	58
477	65
478	108
478	112
478	116
479	107
479	112
479	118
480	108
480	112
480	116
481	5
481	10
481	11
481	18
481	21
481	26
481	34
481	36
481	45
481	50
481	54
481	58
481	65
482	110
482	115
482	119
483	110
483	112
483	119
484	71
484	78
484	82
484	89
484	95
484	96
484	101
484	135
484	444
485	74
485	79
485	81
485	86
485	94
485	98
485	105
485	136
485	442
486	1
486	6
486	13
486	17
486	22
486	27
486	33
486	39
486	42
486	47
486	51
486	58
486	64
487	4
487	9
487	15
487	16
487	25
487	29
487	33
487	39
487	43
487	49
487	52
487	60
487	62
488	3
488	8
488	12
488	20
488	23
488	30
488	32
488	36
488	41
488	46
488	51
488	57
488	62
489	71
489	77
489	81
489	87
489	93
489	96
489	104
489	135
489	443
490	71
490	78
490	83
490	89
490	93
490	97
490	102
490	136
490	444
491	75
491	76
491	83
491	87
491	93
491	97
491	101
491	135
491	443
492	109
492	112
492	117
493	4
493	10
493	14
493	17
493	21
493	26
493	31
493	39
493	44
493	46
493	51
493	58
493	65
494	3
494	6
494	11
494	16
494	23
494	29
494	34
494	40
494	45
494	50
494	54
494	60
494	62
495	110
495	113
495	116
496	107
496	112
496	117
497	1
497	6
497	15
497	19
497	25
497	29
497	32
497	38
497	42
497	48
497	54
497	58
497	62
498	73
498	79
498	82
498	89
498	92
498	97
498	102
498	134
498	442
499	5
499	8
499	13
499	18
499	25
499	26
499	31
499	37
499	42
499	46
499	51
499	60
499	61
500	106
500	114
500	118
501	2
501	8
501	11
501	19
501	24
501	27
501	31
501	36
501	44
501	50
501	52
501	57
501	64
502	3
502	7
502	12
502	18
502	24
502	29
502	33
502	37
502	44
502	46
502	55
502	57
502	62
503	71
503	77
503	84
503	90
503	94
503	98
503	105
503	134
503	444
504	106
504	113
504	118
505	109
505	114
505	119
506	5
506	9
506	13
506	17
506	25
506	27
506	32
506	40
506	43
506	47
506	52
506	59
506	62
507	74
507	78
507	82
507	89
507	92
507	99
507	104
507	135
507	444
508	5
508	10
508	11
508	16
508	24
508	30
508	33
508	38
508	41
508	50
508	53
508	58
508	61
509	110
509	113
509	119
510	4
510	10
510	13
510	18
510	22
510	27
510	35
510	37
510	43
510	50
510	52
510	57
510	63
511	74
511	80
511	85
511	90
511	91
511	97
511	105
511	135
511	443
512	108
512	115
512	117
513	1
513	7
513	11
513	17
513	21
513	29
513	35
513	39
513	44
513	50
513	54
513	57
513	63
514	73
514	78
514	84
514	88
514	91
514	97
514	101
514	134
514	442
515	109
515	112
515	119
516	1
516	6
516	11
516	17
516	25
516	26
516	34
516	39
516	41
516	46
516	55
516	59
516	64
517	4
517	7
517	11
517	17
517	22
517	26
517	35
517	36
517	43
517	48
517	53
517	56
517	63
518	74
518	78
518	85
518	89
518	91
518	98
518	103
518	135
518	444
519	108
519	114
519	120
520	71
520	79
520	81
520	86
520	92
520	100
520	103
520	134
520	443
521	107
521	114
521	120
522	72
522	78
522	81
522	87
522	93
522	100
522	102
522	136
522	444
523	3
523	9
523	12
523	19
523	22
523	28
523	31
523	37
523	44
523	47
523	52
523	58
523	64
524	108
524	111
524	117
525	2
525	6
525	13
525	17
525	24
525	30
525	33
525	38
525	41
525	48
525	55
525	57
525	64
526	72
526	80
526	81
526	89
526	95
526	96
526	104
526	134
526	442
527	5
527	9
527	14
527	20
527	21
527	30
527	32
527	39
527	44
527	48
527	51
527	60
527	63
528	74
528	78
528	85
528	89
528	95
528	98
528	104
528	135
528	443
529	5
529	10
529	11
529	16
529	21
529	30
529	34
529	37
529	42
529	50
529	55
529	57
529	65
530	75
530	78
530	81
530	89
530	92
530	100
530	101
530	134
530	442
531	75
531	76
531	83
531	87
531	92
531	99
531	105
531	136
531	442
532	2
532	9
532	11
532	20
532	21
532	28
532	33
532	38
532	41
532	46
532	52
532	60
532	62
533	109
533	114
533	119
534	2
534	7
534	13
534	20
534	25
534	27
534	34
534	40
534	45
534	47
534	52
534	56
534	64
535	75
535	80
535	85
535	90
535	91
535	99
535	104
535	136
535	442
536	4
536	6
536	11
536	16
536	21
536	26
536	34
536	40
536	45
536	47
536	54
536	57
536	62
537	5
537	9
537	11
537	20
537	23
537	26
537	35
537	36
537	45
537	46
537	55
537	58
537	64
538	106
538	112
538	116
539	3
539	9
539	13
539	17
539	25
539	26
539	35
539	39
539	43
539	49
539	52
539	56
539	65
540	109
540	113
540	116
541	108
541	114
541	119
542	75
542	80
542	81
542	87
542	93
542	98
542	101
542	136
542	443
543	1
543	9
543	13
543	20
543	22
543	27
543	31
543	39
543	44
543	50
543	54
543	60
543	65
544	108
544	112
544	120
545	5
545	7
545	12
545	19
545	24
545	30
545	33
545	37
545	42
545	48
545	55
545	56
545	62
546	5
546	6
546	11
546	18
546	22
546	26
546	31
546	40
546	45
546	46
546	54
546	57
546	61
547	109
547	112
547	118
548	108
548	111
548	117
549	110
549	113
549	119
550	74
550	78
550	85
550	86
550	92
550	98
550	103
550	136
550	442
551	71
551	80
551	82
551	86
551	94
551	97
551	102
551	134
551	444
552	4
552	6
552	11
552	18
552	25
552	26
552	34
552	40
552	41
552	49
552	51
552	56
552	61
553	72
553	76
553	84
553	90
553	95
553	98
553	104
553	136
553	442
554	5
554	7
554	14
554	20
554	24
554	29
554	31
554	40
554	45
554	49
554	51
554	60
554	65
555	1
555	10
555	12
555	18
555	25
555	28
555	32
555	40
555	41
555	50
555	52
555	58
555	65
556	107
556	114
556	116
557	5
557	10
557	12
557	20
557	24
557	28
557	33
557	38
557	45
557	46
557	54
557	59
557	64
558	73
558	77
558	84
558	90
558	95
558	97
558	102
558	135
558	442
559	1
559	7
559	13
559	20
559	25
559	26
559	35
559	40
559	45
559	47
559	55
559	58
559	64
560	4
560	7
560	11
560	16
560	21
560	29
560	34
560	36
560	43
560	47
560	55
560	56
560	63
561	4
561	10
561	14
561	18
561	23
561	28
561	34
561	37
561	45
561	48
561	54
561	60
561	65
562	109
562	112
562	120
563	109
563	115
563	119
564	107
564	114
564	120
565	74
565	79
565	82
565	87
565	91
565	97
565	101
565	134
565	442
566	72
566	78
566	83
566	88
566	94
566	99
566	105
566	136
566	444
567	1
567	9
567	14
567	18
567	25
567	29
567	31
567	40
567	42
567	50
567	55
567	57
567	65
568	110
568	114
568	119
569	106
569	113
569	119
570	72
570	76
570	85
570	89
570	93
570	97
570	105
570	135
570	444
571	2
571	8
571	14
571	17
571	23
571	30
571	33
571	37
571	43
571	47
571	53
571	60
571	64
572	72
572	77
572	82
572	88
572	91
572	97
572	102
572	134
572	442
573	74
573	77
573	83
573	88
573	91
573	98
573	103
573	134
573	444
574	75
574	79
574	82
574	89
574	94
574	100
574	103
574	134
574	443
575	74
575	79
575	82
575	86
575	94
575	99
575	102
575	134
575	444
576	110
576	112
576	116
577	106
577	112
577	120
578	3
578	9
578	11
578	17
578	24
578	29
578	33
578	36
578	45
578	49
578	53
578	56
578	63
579	4
579	10
579	15
579	18
579	23
579	30
579	34
579	38
579	41
579	48
579	52
579	59
579	63
580	5
580	10
580	14
580	20
580	25
580	27
580	34
580	36
580	42
580	49
580	52
580	57
580	64
581	3
581	7
581	14
581	17
581	25
581	28
581	33
581	39
581	42
581	47
581	54
581	59
581	62
582	109
582	114
582	119
583	3
583	8
583	12
583	20
583	25
583	28
583	31
583	40
583	43
583	49
583	54
583	60
583	63
584	107
584	115
584	118
585	108
585	114
585	118
586	1
586	7
586	14
586	16
586	24
586	26
586	32
586	39
586	45
586	48
586	53
586	57
586	63
587	75
587	78
587	85
587	87
587	94
587	100
587	102
587	136
587	442
588	3
588	9
588	15
588	17
588	25
588	27
588	31
588	36
588	45
588	46
588	51
588	58
588	64
589	1
589	10
589	12
589	17
589	22
589	30
589	31
589	40
589	41
589	46
589	54
589	59
589	65
590	110
590	115
590	117
591	107
591	114
591	118
592	73
592	76
592	85
592	88
592	92
592	99
592	102
592	134
592	444
593	75
593	76
593	83
593	89
593	95
593	98
593	101
593	136
593	443
594	110
594	111
594	119
595	72
595	80
595	81
595	88
595	93
595	96
595	101
595	136
595	444
596	75
596	80
596	81
596	87
596	94
596	98
596	103
596	134
596	444
597	107
597	111
597	120
598	72
598	79
598	83
598	88
598	91
598	96
598	102
598	136
598	443
599	71
599	77
599	84
599	89
599	93
599	100
599	104
599	134
599	442
600	4
600	6
600	12
600	19
600	23
600	29
600	35
600	40
600	43
600	49
600	51
600	56
600	62
601	74
601	79
601	82
601	87
601	92
601	98
601	104
601	134
601	442
602	4
602	9
602	13
602	18
602	25
602	27
602	31
602	36
602	43
602	50
602	51
602	60
602	61
603	4
603	9
603	12
603	20
603	23
603	26
603	31
603	36
603	45
603	47
603	51
603	58
603	61
604	73
604	77
604	84
604	86
604	94
604	98
604	103
604	135
604	443
605	75
605	77
605	85
605	89
605	94
605	97
605	103
605	135
605	443
606	72
606	79
606	85
606	90
606	95
606	99
606	103
606	135
606	442
607	75
607	77
607	83
607	88
607	91
607	99
607	101
607	136
607	442
608	71
608	78
608	83
608	88
608	91
608	96
608	101
608	135
608	442
609	1
609	10
609	11
609	17
609	22
609	29
609	35
609	37
609	45
609	48
609	52
609	56
609	64
610	106
610	114
610	119
611	73
611	77
611	83
611	87
611	95
611	100
611	102
611	136
611	443
612	106
612	114
612	120
613	106
613	115
613	120
614	110
614	111
614	117
615	72
615	79
615	84
615	89
615	94
615	97
615	102
615	136
615	444
616	109
616	112
616	119
617	5
617	7
617	12
617	19
617	22
617	27
617	34
617	40
617	43
617	49
617	54
617	57
617	62
618	106
618	114
618	116
619	74
619	80
619	82
619	86
619	91
619	97
619	102
619	136
619	442
620	75
620	77
620	82
620	87
620	92
620	97
620	104
620	134
620	443
621	72
621	77
621	85
621	89
621	92
621	100
621	101
621	134
621	444
622	2
622	9
622	14
622	18
622	23
622	30
622	31
622	40
622	43
622	46
622	54
622	60
622	65
623	74
623	78
623	82
623	87
623	93
623	100
623	101
623	136
623	444
624	108
624	113
624	117
625	75
625	79
625	85
625	86
625	94
625	97
625	103
625	134
625	443
626	72
626	80
626	83
626	87
626	95
626	98
626	105
626	134
626	444
627	5
627	7
627	14
627	19
627	22
627	30
627	35
627	39
627	44
627	47
627	52
627	60
627	63
628	72
628	77
628	82
628	88
628	95
628	99
628	104
628	134
628	444
629	106
629	114
629	119
630	74
630	79
630	81
630	86
630	93
630	97
630	105
630	136
630	444
631	4
631	8
631	15
631	19
631	23
631	26
631	32
631	38
631	41
631	50
631	51
631	60
631	63
632	71
632	76
632	83
632	88
632	95
632	100
632	102
632	136
632	442
633	72
633	78
633	82
633	89
633	92
633	99
633	102
633	136
633	443
634	74
634	77
634	84
634	86
634	91
634	100
634	101
634	134
634	442
635	74
635	80
635	83
635	88
635	95
635	97
635	101
635	134
635	443
636	107
636	112
636	118
637	110
637	114
637	116
638	2
638	6
638	13
638	18
638	22
638	30
638	33
638	40
638	42
638	46
638	52
638	58
638	65
639	73
639	80
639	83
639	90
639	91
639	96
639	104
639	134
639	442
640	110
640	112
640	116
641	106
641	112
641	116
642	108
642	112
642	117
643	2
643	10
643	15
643	17
643	24
643	30
643	31
643	36
643	45
643	49
643	53
643	56
643	64
644	106
644	112
644	116
645	71
645	76
645	82
645	88
645	93
645	97
645	101
645	134
645	442
646	108
646	115
646	116
647	3
647	8
647	13
647	20
647	25
647	28
647	33
647	38
647	45
647	48
647	51
647	60
647	65
648	72
648	80
648	81
648	90
648	94
648	100
648	102
648	135
648	444
649	108
649	113
649	117
650	72
650	77
650	81
650	88
650	91
650	100
650	101
650	134
650	442
651	2
651	10
651	11
651	18
651	24
651	29
651	32
651	40
651	44
651	48
651	52
651	58
651	61
652	107
652	113
652	118
653	1
653	7
653	13
653	16
653	21
653	26
653	34
653	38
653	41
653	50
653	53
653	56
653	61
654	72
654	78
654	84
654	86
654	91
654	97
654	104
654	134
654	444
655	1
655	7
655	12
655	18
655	23
655	27
655	35
655	38
655	41
655	49
655	53
655	57
655	61
656	1
656	7
656	14
656	20
656	21
656	30
656	31
656	37
656	44
656	49
656	53
656	59
656	63
657	2
657	8
657	12
657	16
657	22
657	30
657	32
657	40
657	42
657	50
657	55
657	60
657	65
658	107
658	114
658	116
659	72
659	80
659	81
659	86
659	91
659	99
659	101
659	135
659	442
660	107
660	111
660	118
661	110
661	113
661	120
662	108
662	112
662	120
663	73
663	76
663	85
663	86
663	93
663	97
663	103
663	136
663	442
664	110
664	114
664	119
665	5
665	9
665	11
665	20
665	24
665	28
665	35
665	36
665	41
665	50
665	54
665	56
665	62
666	71
666	79
666	83
666	90
666	93
666	98
666	102
666	134
666	444
667	71
667	80
667	82
667	86
667	94
667	100
667	101
667	135
667	444
668	73
668	79
668	85
668	90
668	92
668	96
668	105
668	134
668	442
669	107
669	115
669	118
670	5
670	8
670	13
670	19
670	21
670	26
670	34
670	37
670	45
670	50
670	51
670	56
670	63
671	1
671	9
671	12
671	18
671	22
671	30
671	35
671	37
671	42
671	49
671	52
671	57
671	65
672	4
672	7
672	15
672	20
672	22
672	27
672	33
672	38
672	44
672	48
672	54
672	56
672	64
673	5
673	9
673	11
673	18
673	25
673	26
673	35
673	37
673	45
673	46
673	54
673	56
673	61
674	74
674	76
674	81
674	88
674	93
674	96
674	103
674	136
674	443
675	2
675	7
675	12
675	17
675	24
675	26
675	35
675	40
675	43
675	48
675	53
675	60
675	63
676	110
676	112
676	117
677	108
677	113
677	116
678	1
678	8
678	14
678	18
678	22
678	28
678	34
678	38
678	42
678	46
678	52
678	60
678	65
679	73
679	76
679	82
679	86
679	95
679	100
679	104
679	135
679	444
680	107
680	111
680	120
681	74
681	79
681	85
681	90
681	93
681	97
681	105
681	136
681	443
682	71
682	77
682	85
682	90
682	94
682	100
682	103
682	134
682	444
683	72
683	80
683	83
683	90
683	93
683	96
683	104
683	136
683	444
684	71
684	77
684	84
684	86
684	95
684	96
684	105
684	136
684	444
685	72
685	78
685	85
685	88
685	93
685	98
685	104
685	136
685	444
686	73
686	80
686	81
686	88
686	95
686	97
686	104
686	135
686	443
687	110
687	115
687	118
688	75
688	76
688	81
688	87
688	91
688	96
688	101
688	136
688	443
689	74
689	78
689	83
689	89
689	95
689	98
689	102
689	134
689	443
690	75
690	80
690	81
690	86
690	92
690	98
690	103
690	134
690	442
691	73
691	80
691	85
691	87
691	92
691	100
691	105
691	136
691	443
692	1
692	6
692	14
692	20
692	24
692	27
692	31
692	36
692	42
692	48
692	53
692	60
692	62
693	71
693	79
693	84
693	89
693	92
693	100
693	105
693	135
693	444
694	1
694	7
694	14
694	16
694	24
694	26
694	31
694	37
694	45
694	46
694	53
694	60
694	63
695	73
695	80
695	85
695	88
695	95
695	100
695	103
695	135
695	442
696	73
696	77
696	85
696	86
696	93
696	98
696	105
696	134
696	444
697	74
697	80
697	84
697	87
697	92
697	99
697	104
697	135
697	442
698	4
698	7
698	15
698	17
698	25
698	29
698	32
698	39
698	44
698	49
698	53
698	56
698	64
699	1
699	8
699	12
699	19
699	23
699	28
699	35
699	39
699	43
699	46
699	51
699	56
699	64
700	72
700	80
700	84
700	90
700	92
700	99
700	105
700	136
700	444
701	74
701	77
701	85
701	90
701	94
701	99
701	105
701	136
701	444
702	1
702	8
702	15
702	18
702	21
702	28
702	33
702	40
702	45
702	48
702	52
702	56
702	64
703	109
703	112
703	119
704	75
704	77
704	82
704	86
704	92
704	97
704	104
704	134
704	442
705	106
705	112
705	120
706	3
706	10
706	14
706	20
706	21
706	29
706	32
706	36
706	42
706	49
706	53
706	58
706	64
707	106
707	112
707	116
708	106
708	113
708	117
709	5
709	6
709	14
709	16
709	22
709	27
709	34
709	36
709	45
709	47
709	54
709	57
709	61
710	108
710	112
710	118
711	71
711	79
711	81
711	87
711	93
711	96
711	103
711	134
711	443
712	108
712	112
712	120
713	71
713	80
713	85
713	88
713	94
713	98
713	102
713	134
713	443
714	108
714	113
714	120
715	72
715	76
715	85
715	87
715	92
715	99
715	101
715	134
715	443
716	1
716	10
716	11
716	16
716	23
716	27
716	31
716	36
716	45
716	47
716	55
716	60
716	62
717	75
717	77
717	85
717	88
717	91
717	96
717	104
717	135
717	442
718	72
718	76
718	84
718	88
718	93
718	98
718	101
718	134
718	442
719	110
719	115
719	119
720	110
720	113
720	116
721	74
721	76
721	85
721	88
721	93
721	96
721	104
721	136
721	443
722	107
722	111
722	116
723	109
723	111
723	119
724	2
724	7
724	14
724	20
724	25
724	29
724	31
724	36
724	41
724	50
724	52
724	59
724	61
725	1
725	10
725	11
725	18
725	25
725	27
725	31
725	36
725	42
725	46
725	51
725	60
725	61
726	74
726	76
726	84
726	88
726	93
726	97
726	102
726	136
726	443
727	71
727	77
727	85
727	87
727	91
727	97
727	105
727	135
727	443
728	110
728	112
728	116
729	106
729	115
729	117
730	72
730	77
730	83
730	86
730	92
730	99
730	104
730	135
730	444
731	4
731	7
731	15
731	19
731	22
731	28
731	33
731	38
731	44
731	46
731	55
731	59
731	62
732	75
732	79
732	84
732	87
732	94
732	98
732	102
732	136
732	444
733	108
733	112
733	119
734	4
734	8
734	11
734	19
734	21
734	28
734	33
734	39
734	45
734	49
734	51
734	59
734	63
735	74
735	77
735	81
735	86
735	95
735	96
735	102
735	136
735	444
736	75
736	79
736	83
736	89
736	91
736	100
736	103
736	134
736	442
737	3
737	7
737	12
737	17
737	23
737	27
737	34
737	36
737	44
737	50
737	52
737	59
737	64
738	5
738	9
738	15
738	20
738	25
738	28
738	32
738	37
738	43
738	49
738	51
738	57
738	64
739	71
739	80
739	81
739	88
739	93
739	100
739	103
739	136
739	443
740	73
740	78
740	82
740	88
740	92
740	100
740	101
740	136
740	442
741	107
741	115
741	118
742	3
742	6
742	14
742	17
742	23
742	26
742	32
742	37
742	41
742	47
742	52
742	60
742	64
743	73
743	77
743	84
743	89
743	91
743	97
743	101
743	134
743	444
744	106
744	112
744	119
745	4
745	9
745	14
745	16
745	21
745	28
745	35
745	36
745	42
745	48
745	53
745	56
745	63
746	73
746	78
746	85
746	87
746	95
746	97
746	105
746	136
746	442
747	75
747	76
747	84
747	90
747	95
747	98
747	105
747	134
747	444
748	108
748	115
748	118
749	5
749	6
749	11
749	20
749	24
749	26
749	35
749	36
749	45
749	49
749	55
749	56
749	65
750	109
750	113
750	119
751	3
751	7
751	12
751	19
751	22
751	27
751	31
751	38
751	41
751	48
751	52
751	57
751	64
752	1
752	8
752	13
752	17
752	21
752	28
752	35
752	40
752	45
752	48
752	54
752	57
752	61
753	106
753	115
753	116
754	4
754	7
754	11
754	16
754	24
754	27
754	32
754	40
754	45
754	46
754	53
754	58
754	61
755	2
755	10
755	14
755	17
755	25
755	28
755	34
755	37
755	42
755	50
755	52
755	58
755	64
756	106
756	111
756	119
757	74
757	77
757	82
757	90
757	95
757	99
757	101
757	135
757	443
758	74
758	79
758	85
758	88
758	92
758	100
758	103
758	136
758	444
759	1
759	8
759	15
759	16
759	24
759	26
759	34
759	39
759	44
759	49
759	52
759	59
759	62
760	110
760	115
760	118
761	108
761	111
761	116
762	71
762	79
762	85
762	89
762	91
762	97
762	104
762	135
762	442
763	2
763	7
763	12
763	18
763	25
763	30
763	31
763	40
763	45
763	49
763	54
763	56
763	65
764	2
764	6
764	14
764	20
764	22
764	29
764	35
764	39
764	42
764	50
764	54
764	57
764	65
765	106
765	115
765	117
766	5
766	6
766	12
766	19
766	22
766	29
766	32
766	38
766	45
766	50
766	52
766	59
766	61
767	5
767	10
767	11
767	17
767	23
767	26
767	31
767	39
767	44
767	50
767	54
767	57
767	63
768	109
768	112
768	119
769	109
769	115
769	120
770	3
770	9
770	11
770	20
770	21
770	30
770	31
770	40
770	43
770	50
770	52
770	60
770	65
771	4
771	8
771	14
771	20
771	23
771	26
771	34
771	37
771	41
771	49
771	54
771	58
771	65
772	71
772	76
772	85
772	89
772	95
772	99
772	104
772	136
772	443
773	107
773	114
773	118
774	109
774	112
774	117
775	107
775	111
775	116
776	4
776	6
776	15
776	16
776	23
776	27
776	35
776	40
776	44
776	49
776	53
776	58
776	65
777	110
777	114
777	119
778	110
778	113
778	119
779	110
779	115
779	116
780	109
780	114
780	120
781	5
781	6
781	11
781	20
781	22
781	27
781	32
781	40
781	41
781	49
781	54
781	56
781	65
782	109
782	112
782	120
783	110
783	113
783	117
784	73
784	80
784	83
784	90
784	95
784	98
784	101
784	135
784	442
785	109
785	113
785	117
786	71
786	79
786	82
786	89
786	92
786	96
786	105
786	136
786	442
787	108
787	114
787	117
788	71
788	78
788	85
788	90
788	94
788	96
788	104
788	136
788	444
789	74
789	77
789	85
789	90
789	93
789	99
789	103
789	134
789	444
790	107
790	114
790	117
791	74
791	76
791	85
791	86
791	92
791	98
791	104
791	136
791	443
792	2
792	7
792	15
792	16
792	21
792	30
792	35
792	40
792	43
792	49
792	53
792	57
792	63
793	72
793	78
793	81
793	87
793	92
793	96
793	105
793	134
793	443
794	72
794	78
794	84
794	86
794	91
794	97
794	104
794	136
794	444
795	2
795	10
795	12
795	18
795	21
795	30
795	34
795	38
795	45
795	48
795	53
795	56
795	63
796	1
796	7
796	13
796	20
796	22
796	26
796	32
796	40
796	43
796	49
796	55
796	60
796	62
797	106
797	113
797	117
798	4
798	8
798	11
798	20
798	25
798	28
798	34
798	40
798	45
798	47
798	54
798	59
798	65
799	72
799	77
799	84
799	87
799	94
799	99
799	101
799	135
799	444
800	110
800	115
800	119
801	106
801	115
801	117
802	110
802	111
802	117
803	75
803	79
803	83
803	87
803	95
803	96
803	103
803	134
803	442
804	3
804	9
804	14
804	20
804	22
804	29
804	34
804	40
804	41
804	48
804	51
804	60
804	64
805	72
805	78
805	81
805	88
805	92
805	98
805	102
805	134
805	444
806	108
806	114
806	118
807	2
807	9
807	13
807	18
807	23
807	26
807	32
807	40
807	41
807	47
807	52
807	56
807	61
808	72
808	77
808	82
808	89
808	92
808	100
808	105
808	135
808	444
809	4
809	8
809	15
809	18
809	21
809	29
809	32
809	36
809	45
809	50
809	54
809	57
809	64
810	106
810	115
810	116
811	74
811	76
811	81
811	89
811	95
811	96
811	103
811	136
811	444
812	107
812	112
812	117
813	106
813	111
813	118
814	110
814	113
814	116
815	4
815	8
815	11
815	19
815	21
815	30
815	31
815	38
815	42
815	47
815	52
815	57
815	64
816	74
816	79
816	84
816	88
816	95
816	100
816	104
816	134
816	442
817	4
817	8
817	13
817	17
817	21
817	26
817	31
817	40
817	43
817	47
817	51
817	56
817	62
818	72
818	76
818	81
818	88
818	93
818	99
818	105
818	136
818	443
819	5
819	6
819	11
819	20
819	23
819	30
819	32
819	38
819	41
819	48
819	54
819	56
819	61
820	72
820	80
820	85
820	86
820	91
820	96
820	103
820	134
820	444
821	73
821	78
821	81
821	90
821	95
821	97
821	101
821	136
821	443
822	109
822	113
822	116
823	1
823	10
823	15
823	16
823	25
823	30
823	32
823	38
823	43
823	49
823	54
823	56
823	64
824	75
824	77
824	85
824	89
824	93
824	100
824	104
824	135
824	444
825	109
825	113
825	117
826	110
826	112
826	118
827	72
827	79
827	82
827	88
827	93
827	97
827	104
827	134
827	442
828	2
828	8
828	14
828	16
828	21
828	28
828	34
828	38
828	45
828	46
828	52
828	56
828	63
829	109
829	111
829	119
830	2
830	7
830	15
830	18
830	25
830	29
830	31
830	37
830	43
830	48
830	54
830	60
830	65
831	73
831	78
831	83
831	86
831	93
831	97
831	101
831	134
831	442
832	110
832	113
832	119
833	107
833	113
833	118
834	3
834	7
834	14
834	18
834	24
834	28
834	35
834	40
834	45
834	46
834	52
834	60
834	61
835	73
835	77
835	83
835	86
835	91
835	99
835	103
835	134
835	443
836	5
836	10
836	13
836	19
836	25
836	27
836	34
836	37
836	41
836	49
836	52
836	60
836	61
837	71
837	76
837	85
837	89
837	94
837	97
837	105
837	136
837	442
838	5
838	8
838	14
838	20
838	22
838	28
838	34
838	37
838	42
838	47
838	55
838	57
838	65
839	75
839	80
839	81
839	90
839	91
839	97
839	104
839	134
839	444
840	109
840	114
840	120
841	75
841	80
841	84
841	87
841	95
841	96
841	103
841	136
841	443
842	74
842	79
842	85
842	90
842	91
842	98
842	102
842	136
842	444
843	1
843	7
843	14
843	18
843	24
843	29
843	34
843	36
843	43
843	47
843	53
843	58
843	63
844	73
844	79
844	84
844	86
844	95
844	99
844	102
844	135
844	444
845	71
845	77
845	81
845	89
845	93
845	100
845	105
845	136
845	442
846	4
846	8
846	12
846	17
846	22
846	30
846	32
846	37
846	41
846	47
846	51
846	57
846	61
847	5
847	7
847	14
847	18
847	21
847	30
847	35
847	37
847	43
847	47
847	51
847	58
847	65
848	110
848	113
848	116
849	107
849	111
849	120
850	110
850	112
850	120
851	1
851	6
851	12
851	19
851	21
851	30
851	33
851	38
851	45
851	47
851	52
851	59
851	62
852	1
852	10
852	14
852	20
852	21
852	30
852	32
852	38
852	44
852	49
852	55
852	56
852	62
853	74
853	76
853	81
853	87
853	94
853	100
853	105
853	134
853	444
854	73
854	77
854	82
854	86
854	94
854	97
854	105
854	134
854	442
855	75
855	78
855	81
855	87
855	94
855	97
855	102
855	134
855	442
856	107
856	112
856	117
857	5
857	7
857	13
857	20
857	22
857	29
857	33
857	37
857	41
857	46
857	53
857	58
857	64
858	4
858	9
858	15
858	20
858	24
858	28
858	35
858	40
858	43
858	48
858	54
858	59
858	61
859	3
859	10
859	14
859	19
859	21
859	26
859	34
859	37
859	43
859	50
859	53
859	58
859	62
860	109
860	114
860	119
861	3
861	9
861	11
861	17
861	24
861	29
861	33
861	36
861	44
861	49
861	54
861	60
861	61
862	2
862	10
862	13
862	18
862	22
862	28
862	35
862	36
862	41
862	50
862	51
862	59
862	61
863	106
863	113
863	120
864	106
864	112
864	119
865	106
865	111
865	117
866	3
866	8
866	11
866	20
866	25
866	30
866	34
866	37
866	43
866	48
866	55
866	57
866	62
867	71
867	78
867	82
867	89
867	93
867	98
867	101
867	134
867	442
868	4
868	10
868	15
868	20
868	25
868	30
868	31
868	37
868	44
868	50
868	54
868	60
868	65
869	73
869	77
869	82
869	87
869	92
869	97
869	103
869	136
869	442
870	1
870	8
870	14
870	20
870	25
870	28
870	34
870	37
870	42
870	48
870	52
870	59
870	61
871	106
871	112
871	117
872	1
872	9
872	11
872	19
872	23
872	27
872	34
872	39
872	44
872	47
872	55
872	59
872	61
873	109
873	115
873	117
874	73
874	76
874	83
874	86
874	95
874	99
874	105
874	135
874	443
875	72
875	79
875	84
875	87
875	93
875	99
875	104
875	135
875	442
876	110
876	113
876	119
877	106
877	114
877	119
878	73
878	78
878	82
878	89
878	91
878	99
878	103
878	135
878	444
879	72
879	77
879	85
879	90
879	91
879	100
879	101
879	134
879	442
880	2
880	8
880	11
880	16
880	22
880	26
880	32
880	36
880	41
880	46
880	52
880	56
880	64
881	107
881	114
881	118
882	4
882	8
882	11
882	17
882	23
882	28
882	32
882	36
882	42
882	46
882	54
882	60
882	62
883	3
883	10
883	14
883	17
883	22
883	27
883	32
883	38
883	41
883	46
883	55
883	56
883	61
884	4
884	10
884	13
884	17
884	23
884	28
884	34
884	39
884	42
884	50
884	51
884	59
884	65
885	5
885	6
885	11
885	16
885	22
885	30
885	33
885	36
885	44
885	50
885	51
885	59
885	62
886	108
886	113
886	120
887	107
887	114
887	116
888	75
888	79
888	85
888	86
888	92
888	100
888	101
888	135
888	442
889	72
889	77
889	84
889	87
889	92
889	98
889	103
889	136
889	442
890	73
890	77
890	85
890	86
890	94
890	100
890	101
890	136
890	444
891	3
891	9
891	14
891	17
891	22
891	26
891	34
891	40
891	44
891	46
891	53
891	58
891	64
892	5
892	9
892	13
892	20
892	23
892	26
892	33
892	38
892	44
892	48
892	54
892	58
892	65
893	2
893	7
893	15
893	16
893	21
893	26
893	31
893	37
893	45
893	49
893	54
893	56
893	62
894	75
894	76
894	82
894	88
894	93
894	98
894	103
894	135
894	444
895	5
895	8
895	13
895	20
895	21
895	27
895	33
895	36
895	44
895	46
895	51
895	57
895	65
896	74
896	77
896	85
896	90
896	91
896	100
896	104
896	136
896	444
897	106
897	114
897	117
898	74
898	77
898	85
898	88
898	91
898	100
898	102
898	134
898	443
899	75
899	76
899	85
899	90
899	92
899	100
899	104
899	135
899	443
900	72
900	79
900	82
900	90
900	93
900	96
900	103
900	135
900	442
901	3
901	10
901	11
901	17
901	22
901	28
901	34
901	36
901	41
901	49
901	54
901	58
901	64
902	108
902	114
902	118
903	74
903	78
903	81
903	87
903	94
903	96
903	105
903	135
903	442
904	73
904	79
904	84
904	89
904	95
904	98
904	101
904	136
904	443
905	72
905	76
905	82
905	86
905	94
905	96
905	102
905	135
905	443
906	110
906	112
906	120
907	74
907	79
907	82
907	90
907	91
907	100
907	104
907	135
907	444
908	110
908	113
908	116
909	3
909	6
909	15
909	16
909	23
909	30
909	33
909	39
909	41
909	49
909	53
909	57
909	61
910	3
910	9
910	12
910	17
910	23
910	29
910	33
910	40
910	42
910	46
910	52
910	60
910	61
911	108
911	112
911	117
912	74
912	80
912	84
912	90
912	94
912	98
912	101
912	136
912	444
913	5
913	10
913	11
913	18
913	23
913	27
913	35
913	36
913	44
913	48
913	51
913	58
913	62
914	73
914	79
914	82
914	88
914	93
914	96
914	104
914	136
914	443
915	106
915	114
915	118
916	72
916	79
916	83
916	87
916	93
916	96
916	101
916	135
916	444
917	2
917	8
917	12
917	20
917	25
917	30
917	35
917	40
917	41
917	48
917	52
917	57
917	65
918	4
918	9
918	11
918	16
918	25
918	29
918	35
918	39
918	44
918	46
918	55
918	57
918	63
919	108
919	111
919	119
920	106
920	112
920	117
921	2
921	7
921	14
921	19
921	24
921	29
921	35
921	39
921	42
921	46
921	51
921	58
921	61
922	74
922	78
922	84
922	88
922	93
922	98
922	102
922	134
922	443
923	1
923	7
923	14
923	18
923	25
923	29
923	33
923	39
923	41
923	47
923	54
923	59
923	63
924	109
924	115
924	119
925	106
925	111
925	116
926	74
926	80
926	81
926	90
926	95
926	100
926	102
926	136
926	444
927	3
927	10
927	14
927	17
927	23
927	30
927	34
927	39
927	42
927	50
927	55
927	59
927	63
928	110
928	111
928	120
929	107
929	111
929	117
930	75
930	80
930	83
930	87
930	91
930	97
930	102
930	136
930	443
931	71
931	79
931	85
931	86
931	92
931	100
931	102
931	135
931	444
932	3
932	6
932	11
932	20
932	25
932	30
932	34
932	37
932	41
932	50
932	52
932	56
932	63
933	109
933	115
933	118
934	109
934	112
934	116
935	3
935	9
935	12
935	19
935	22
935	27
935	34
935	36
935	44
935	49
935	55
935	57
935	65
936	1
936	6
936	11
936	17
936	24
936	30
936	34
936	37
936	43
936	49
936	53
936	57
936	62
937	110
937	111
937	120
938	107
938	115
938	118
939	106
939	115
939	120
940	74
940	78
940	81
940	88
940	92
940	96
940	103
940	134
940	444
941	106
941	112
941	120
942	73
942	77
942	82
942	88
942	95
942	98
942	103
942	135
942	444
943	106
943	115
943	117
944	109
944	112
944	118
945	2
945	8
945	12
945	18
945	25
945	29
945	33
945	36
945	43
945	50
945	53
945	56
945	61
946	106
946	111
946	119
947	75
947	78
947	84
947	90
947	92
947	97
947	102
947	134
947	442
948	107
948	113
948	116
949	74
949	79
949	81
949	90
949	93
949	100
949	102
949	134
949	443
950	108
950	112
950	117
951	72
951	76
951	83
951	87
951	91
951	96
951	104
951	134
951	444
952	73
952	79
952	83
952	87
952	93
952	97
952	105
952	136
952	442
953	71
953	76
953	83
953	89
953	95
953	99
953	103
953	134
953	444
954	110
954	113
954	120
955	108
955	113
955	116
956	110
956	115
956	117
957	73
957	77
957	85
957	87
957	91
957	97
957	102
957	134
957	442
958	3
958	8
958	12
958	20
958	23
958	27
958	32
958	39
958	41
958	46
958	55
958	56
958	61
959	75
959	78
959	85
959	87
959	93
959	97
959	102
959	135
959	442
960	71
960	79
960	82
960	86
960	92
960	96
960	102
960	134
960	442
961	74
961	79
961	84
961	87
961	95
961	100
961	102
961	134
961	444
962	2
962	6
962	15
962	17
962	21
962	28
962	31
962	37
962	44
962	47
962	53
962	56
962	64
963	71
963	77
963	85
963	87
963	95
963	98
963	104
963	136
963	443
964	106
964	115
964	119
965	74
965	76
965	83
965	87
965	95
965	97
965	101
965	134
965	443
966	108
966	113
966	118
967	107
967	115
967	118
968	2
968	7
968	13
968	17
968	25
968	26
968	32
968	40
968	41
968	46
968	54
968	60
968	63
969	4
969	6
969	12
969	18
969	23
969	28
969	32
969	40
969	45
969	49
969	54
969	58
969	62
970	75
970	80
970	85
970	88
970	93
970	96
970	103
970	134
970	442
971	106
971	114
971	119
972	110
972	115
972	120
973	74
973	76
973	83
973	88
973	94
973	97
973	101
973	134
973	442
974	73
974	80
974	84
974	90
974	92
974	98
974	105
974	134
974	444
975	72
975	77
975	81
975	87
975	94
975	97
975	105
975	135
975	442
976	106
976	114
976	120
977	5
977	6
977	13
977	20
977	23
977	28
977	33
977	36
977	45
977	47
977	55
977	56
977	64
978	1
978	6
978	11
978	16
978	25
978	30
978	31
978	37
978	45
978	50
978	51
978	58
978	63
979	107
979	113
979	119
980	72
980	78
980	85
980	87
980	92
980	99
980	104
980	135
980	442
981	75
981	77
981	83
981	90
981	93
981	97
981	103
981	134
981	444
982	109
982	112
982	116
983	1
983	8
983	12
983	19
983	22
983	28
983	32
983	37
983	45
983	49
983	54
983	59
983	64
984	108
984	115
984	120
985	110
985	112
985	119
986	107
986	115
986	120
987	5
987	6
987	14
987	20
987	25
987	26
987	32
987	39
987	43
987	49
987	53
987	59
987	63
988	106
988	114
988	120
989	2
989	10
989	12
989	16
989	25
989	30
989	34
989	36
989	41
989	47
989	54
989	57
989	62
990	74
990	79
990	81
990	90
990	94
990	96
990	103
990	135
990	444
991	74
991	80
991	82
991	88
991	91
991	100
991	104
991	134
991	442
992	4
992	7
992	13
992	18
992	25
992	27
992	33
992	38
992	45
992	47
992	52
992	58
992	65
993	109
993	114
993	116
994	73
994	77
994	83
994	88
994	95
994	97
994	103
994	136
994	442
995	109
995	115
995	119
996	108
996	111
996	119
997	107
997	114
997	120
998	75
998	77
998	84
998	90
998	92
998	97
998	102
998	134
998	444
999	3
999	10
999	15
999	16
999	25
999	30
999	33
999	40
999	42
999	49
999	51
999	59
999	64
1000	5
1000	10
1000	11
1000	16
1000	21
1000	26
1000	33
1000	39
1000	45
1000	47
1000	53
1000	56
1000	61
1001	74
1001	79
1001	83
1001	90
1001	94
1001	96
1001	103
1001	135
1001	443
1002	4
1002	9
1002	11
1002	17
1002	25
1002	27
1002	31
1002	38
1002	45
1002	48
1002	51
1002	60
1002	61
1003	71
1003	78
1003	83
1003	88
1003	92
1003	97
1003	105
1003	135
1003	442
1004	75
1004	77
1004	82
1004	87
1004	91
1004	96
1004	102
1004	134
1004	442
1005	108
1005	111
1005	116
1006	4
1006	10
1006	14
1006	19
1006	22
1006	28
1006	32
1006	40
1006	44
1006	49
1006	52
1006	56
1006	63
1007	109
1007	111
1007	120
1008	1
1008	6
1008	12
1008	18
1008	25
1008	26
1008	31
1008	36
1008	44
1008	48
1008	54
1008	60
1008	62
1009	2
1009	8
1009	12
1009	20
1009	22
1009	30
1009	31
1009	39
1009	45
1009	49
1009	52
1009	59
1009	65
1010	73
1010	76
1010	81
1010	87
1010	93
1010	99
1010	103
1010	134
1010	443
1011	75
1011	78
1011	85
1011	86
1011	92
1011	99
1011	105
1011	136
1011	443
1012	5
1012	10
1012	15
1012	18
1012	22
1012	26
1012	32
1012	37
1012	45
1012	50
1012	52
1012	57
1012	61
1013	2
1013	7
1013	12
1013	18
1013	22
1013	30
1013	32
1013	38
1013	45
1013	50
1013	55
1013	59
1013	62
1014	74
1014	79
1014	84
1014	89
1014	94
1014	100
1014	104
1014	135
1014	443
1015	74
1015	78
1015	82
1015	89
1015	93
1015	96
1015	103
1015	134
1015	443
1016	108
1016	111
1016	117
1017	1
1017	8
1017	14
1017	19
1017	21
1017	29
1017	33
1017	38
1017	42
1017	46
1017	52
1017	57
1017	61
1018	75
1018	80
1018	81
1018	88
1018	95
1018	99
1018	104
1018	135
1018	442
1019	72
1019	78
1019	81
1019	90
1019	94
1019	98
1019	103
1019	136
1019	442
1020	108
1020	115
1020	116
1021	73
1021	80
1021	81
1021	90
1021	95
1021	98
1021	105
1021	135
1021	444
1022	71
1022	80
1022	81
1022	86
1022	91
1022	99
1022	103
1022	134
1022	442
1023	2
1023	7
1023	12
1023	19
1023	23
1023	26
1023	31
1023	40
1023	43
1023	46
1023	52
1023	60
1023	62
1024	74
1024	76
1024	81
1024	88
1024	95
1024	98
1024	102
1024	134
1024	442
1025	5
1025	10
1025	11
1025	19
1025	24
1025	30
1025	35
1025	38
1025	43
1025	48
1025	51
1025	58
1025	61
1026	1
1026	9
1026	15
1026	17
1026	22
1026	30
1026	34
1026	39
1026	45
1026	50
1026	55
1026	56
1026	63
1027	107
1027	113
1027	116
1028	106
1028	112
1028	120
1029	4
1029	7
1029	12
1029	16
1029	25
1029	28
1029	33
1029	39
1029	41
1029	46
1029	55
1029	56
1029	61
1030	3
1030	9
1030	13
1030	17
1030	21
1030	27
1030	32
1030	36
1030	41
1030	46
1030	53
1030	59
1030	61
1031	110
1031	115
1031	118
1032	4
1032	7
1032	14
1032	17
1032	22
1032	27
1032	31
1032	37
1032	45
1032	48
1032	52
1032	58
1032	65
1033	108
1033	111
1033	120
1034	72
1034	78
1034	81
1034	89
1034	92
1034	96
1034	102
1034	135
1034	443
1035	108
1035	115
1035	118
1036	73
1036	77
1036	82
1036	89
1036	94
1036	100
1036	103
1036	136
1036	443
1037	109
1037	111
1037	116
1038	75
1038	79
1038	82
1038	86
1038	92
1038	100
1038	102
1038	135
1038	444
1039	4
1039	7
1039	12
1039	20
1039	22
1039	29
1039	32
1039	38
1039	42
1039	46
1039	52
1039	58
1039	65
1040	72
1040	77
1040	85
1040	90
1040	91
1040	97
1040	103
1040	134
1040	442
1041	4
1041	6
1041	11
1041	16
1041	24
1041	26
1041	31
1041	37
1041	42
1041	49
1041	51
1041	60
1041	63
1042	3
1042	8
1042	13
1042	19
1042	22
1042	26
1042	34
1042	38
1042	45
1042	49
1042	54
1042	60
1042	65
1043	108
1043	115
1043	120
1044	5
1044	9
1044	13
1044	19
1044	23
1044	26
1044	31
1044	39
1044	44
1044	48
1044	52
1044	59
1044	62
1045	1
1045	8
1045	14
1045	20
1045	22
1045	29
1045	35
1045	38
1045	42
1045	46
1045	53
1045	60
1045	65
1046	74
1046	79
1046	85
1046	87
1046	93
1046	97
1046	101
1046	134
1046	444
1047	106
1047	114
1047	119
1048	108
1048	114
1048	120
1049	73
1049	77
1049	82
1049	87
1049	95
1049	96
1049	102
1049	134
1049	443
1050	73
1050	77
1050	81
1050	89
1050	95
1050	97
1050	105
1050	135
1050	444
1051	106
1051	112
1051	116
1052	107
1052	113
1052	120
1053	3
1053	7
1053	11
1053	16
1053	21
1053	26
1053	33
1053	39
1053	45
1053	46
1053	53
1053	59
1053	61
1054	109
1054	112
1054	119
1055	4
1055	7
1055	12
1055	20
1055	23
1055	28
1055	35
1055	39
1055	45
1055	48
1055	55
1055	59
1055	65
1056	71
1056	79
1056	84
1056	90
1056	95
1056	100
1056	102
1056	135
1056	442
1057	4
1057	9
1057	11
1057	19
1057	24
1057	28
1057	35
1057	38
1057	45
1057	49
1057	54
1057	59
1057	65
1058	72
1058	80
1058	82
1058	86
1058	93
1058	100
1058	102
1058	135
1058	442
1059	4
1059	7
1059	15
1059	20
1059	25
1059	29
1059	32
1059	40
1059	42
1059	48
1059	55
1059	56
1059	61
1060	73
1060	80
1060	82
1060	89
1060	92
1060	96
1060	102
1060	136
1060	443
1061	75
1061	77
1061	85
1061	88
1061	94
1061	97
1061	104
1061	134
1061	444
1062	108
1062	111
1062	120
1063	73
1063	78
1063	83
1063	86
1063	91
1063	98
1063	102
1063	135
1063	444
1064	4
1064	10
1064	13
1064	19
1064	25
1064	28
1064	31
1064	36
1064	41
1064	48
1064	52
1064	60
1064	64
1065	107
1065	112
1065	119
1066	71
1066	80
1066	85
1066	86
1066	95
1066	97
1066	105
1066	135
1066	444
1067	2
1067	10
1067	11
1067	17
1067	22
1067	29
1067	33
1067	36
1067	41
1067	49
1067	54
1067	58
1067	65
1068	75
1068	77
1068	84
1068	86
1068	94
1068	96
1068	105
1068	135
1068	444
1069	106
1069	114
1069	117
1070	1
1070	7
1070	15
1070	19
1070	24
1070	30
1070	32
1070	39
1070	42
1070	47
1070	54
1070	57
1070	61
1071	2
1071	8
1071	15
1071	17
1071	23
1071	27
1071	35
1071	40
1071	42
1071	48
1071	51
1071	60
1071	63
1072	4
1072	7
1072	13
1072	18
1072	23
1072	29
1072	35
1072	39
1072	44
1072	46
1072	52
1072	60
1072	63
1073	73
1073	77
1073	85
1073	89
1073	94
1073	98
1073	103
1073	135
1073	442
1074	106
1074	113
1074	116
1075	3
1075	7
1075	12
1075	18
1075	22
1075	27
1075	35
1075	38
1075	42
1075	47
1075	52
1075	56
1075	65
1076	110
1076	113
1076	118
1077	5
1077	10
1077	12
1077	20
1077	25
1077	29
1077	32
1077	36
1077	45
1077	47
1077	53
1077	59
1077	63
1078	71
1078	77
1078	84
1078	87
1078	95
1078	97
1078	102
1078	135
1078	442
1079	106
1079	114
1079	120
1080	4
1080	6
1080	15
1080	19
1080	22
1080	26
1080	35
1080	38
1080	41
1080	47
1080	55
1080	60
1080	61
1081	108
1081	111
1081	119
1082	107
1082	114
1082	117
1083	5
1083	9
1083	14
1083	16
1083	23
1083	26
1083	35
1083	40
1083	44
1083	50
1083	55
1083	58
1083	61
1084	71
1084	77
1084	85
1084	86
1084	93
1084	96
1084	103
1084	134
1084	442
1085	108
1085	114
1085	119
1086	110
1086	115
1086	118
1087	107
1087	113
1087	120
1088	106
1088	113
1088	118
1089	107
1089	114
1089	116
1090	107
1090	112
1090	116
1091	3
1091	10
1091	13
1091	17
1091	25
1091	30
1091	32
1091	39
1091	41
1091	47
1091	54
1091	59
1091	65
1092	3
1092	9
1092	12
1092	19
1092	24
1092	30
1092	34
1092	40
1092	42
1092	47
1092	54
1092	59
1092	65
1093	1
1093	10
1093	14
1093	20
1093	22
1093	27
1093	32
1093	39
1093	42
1093	47
1093	51
1093	60
1093	63
1094	109
1094	113
1094	120
1095	3
1095	9
1095	14
1095	20
1095	22
1095	28
1095	33
1095	36
1095	43
1095	47
1095	51
1095	60
1095	62
1096	1
1096	10
1096	11
1096	18
1096	22
1096	26
1096	35
1096	40
1096	45
1096	49
1096	55
1096	56
1096	62
1098	118
1098	122
\.


--
-- Data for Name: awards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.awards (award_id, name, host) FROM stdin;
1	Outstanding Faculty Teaching Award	Stanford Psychiatry Residency Program
2	Young Investigators Award	American Psychiatric Association
4	Best Mental Health Professional	Labaid Bangladesh
5	Young Scientist Award	Bangladesh Academy of Sciences
6	Best Doctor Award	Central Hospital Limited
\.


--
-- Data for Name: consultation_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consultation_request (consultation_request_id, counsel_id, test_result_id, info, approved, schedule, method, fee, con_time) FROM stdin;
34	16	1098	\N	t	Thursday: 6 PM - 11 PM	\N	\N	2022-09-01 18:00:00
35	16	1098	\N	t	Thursday: 6 PM - 11 PM	\N	\N	2022-09-01 18:00:00
12	1	80	\N	t	Sunday: 9 AM - 11 AM	Online	\N	2022-08-27 09:34:32
13	7	81	\N	t	Monday: 6 PM - 11 PM	In-person	\N	2022-08-27 09:34:35
10	1	80	\N	t	Sunday: 9 AM - 11 AM	In-person	\N	2022-08-27 09:34:31
9	1	80	\N	f	Sunday: 9 AM - 11 AM	In-person	\N	2022-08-27 09:34:27
11	1	80	\N	f	Sunday: 9 AM - 11 AM	In-person	\N	2022-08-27 09:34:34
14	7	81	\N	t	Thursday: 6 PM - 11 PM	In-person	\N	2022-08-27 09:34:36
6	1	80	\N	t	Sunday: 9 AM - 11 AM	In-person	\N	2022-08-27 09:34:38
16	2	79	\N	f	Friday: 9 AM - 11 AM	\N	\N	2022-09-02 09:00:00
17	3	79	\N	t	Wednesday: 3 PM - 5 PM	\N	\N	2022-08-31 12:00:00
1	3	79	\N	t	Thursday: 8 PM - 11 PM	Online	\N	2022-08-27 09:34:30
18	3	79	\N	t	Wednesday: 3 PM - 5 PM	\N	\N	2022-08-31 15:00:00
19	1	80	\N	f	Monday: 6 PM - 11 PM	\N	\N	2022-08-29 18:00:00
22	1	80	\N	f	Monday: 6 PM - 11 PM	\N	\N	2022-08-29 18:00:00
23	1	80	\N	f	Monday: 6 PM - 11 PM	\N	\N	2022-08-29 18:00:00
24	3	79	\N	f	Thursday: 8 PM - 11 PM	\N	\N	2022-09-01 20:00:00
25	3	79	\N	f	Wednesday: 3 PM - 5 PM	\N	\N	2022-08-31 15:00:00
26	3	79	\N	f	Thursday: 8 PM - 11 PM	\N	\N	2022-09-01 20:00:00
27	3	79	\N	t	Friday: 9 AM - 11 AM	\N	\N	2022-09-02 09:00:00
28	3	79	\N	t	Friday: 9 AM - 11 AM	\N	\N	2022-09-02 09:00:00
29	3	79	\N	t	Friday: 9 AM - 11 AM	\N	\N	2022-09-02 09:00:00
30	3	79	\N	t	Friday: 9 AM - 11 AM	\N	\N	2022-09-02 09:00:00
31	3	79	\N	t	Friday: 9 AM - 11 AM	\N	\N	2022-09-02 09:00:00
32	3	79	\N	f	Wednesday: 3 PM - 5 PM	\N	\N	2022-08-31 15:00:00
21	1	80	\N	t	Monday: 6 PM - 11 PM	\N	\N	2022-08-29 18:00:00
33	16	1098	\N	t	Tuesday: 3 PM - 5 PM	\N	\N	2022-08-30 15:00:00
20	1	80	\N	t	Tuesday: 3 PM - 5 PM	\N	\N	2022-08-30 15:00:00
\.


--
-- Data for Name: counselling_suggestion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.counselling_suggestion (counsel_id, test_result_id, psychiatrist_id) FROM stdin;
1	80	1705044
2	79	1705060
3	79	1705045
4	78	1705045
5	78	1705044
6	81	1705045
7	81	1705044
9	76	1705044
10	97	1705045
11	97	1705044
12	97	1705044
13	5	1705060
14	1098	1705062
15	1098	1705045
16	1098	1705044
\.


--
-- Data for Name: degrees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.degrees (degree_id, name, institution) FROM stdin;
1	MBBS	DU
2	MBBS	SUST
3	MD (Psychiatry)	BSMMU
4	Residency	Stanford Hospital and Clinics
5	FCPS (Psychiatry)	BSMMU
6	MD (Neuroscience)	NINS
\.


--
-- Data for Name: diseases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.diseases (disease_id, name, description) FROM stdin;
1	Depression	\N
2	Mania	\N
3	Somatic Symptoms	\N
4	ADHD	\N
5	PTSD	\N
6	Sleep Disturbance	\N
7	Anger Disorder	\N
8	Substance Abuse	\N
9	RT&B	\N
\.


--
-- Data for Name: file_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.file_requests (file_request_id, created_at, title, description, is_verified, psychiatrist_id) FROM stdin;
1002	2022-08-08 00:57:29.503422	Mania Videos	Please upload photos at high heights	t	1705044
6	2022-08-10 12:05:30.527187	PTSD Stories Instagram	Instagram stories of PTSD affected people	f	1705044
7	2022-08-10 12:14:40.351803	Check 	Check 2	f	1705044
4	2022-08-10 12:00:03.679177	PTSD Stories	Facebook stories of PTSD affected people	t	1705044
1003	2022-08-08 01:57:29.503422	ADHD Videos	Please upload photos at high heights	t	1705044
8	2022-08-14 04:10:09.252762	Again	Again Again	f	1705044
9	2022-08-14 14:22:45.854315	Test File	Upload a txt with your bio	t	1705044
10	2022-08-14 16:21:39.467121	New File Request	Some details	t	1705044
3	2022-08-10 11:58:07.734891	PTSD Posts	A txt file containing Facebook posts for PTSD affected people	t	1705044
5	2022-08-10 12:00:44.530835	PTSD Stories	Facebook stories of PTSD affected people	t	1705044
11	2022-08-28 11:28:22.535716	Anger Stories	Upload files describing your anger. 	t	1705045
\.


--
-- Data for Name: file_uploads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.file_uploads (file_upload_id, file_request_id, file_path, created_at, uploader_id, uploader_comment, notification_pending) FROM stdin;
1	1002	uploads/1002/pbkdf2:sha256:260000$vAU8kzZwh2mRuSh6$6d0afecd228f7cf521568ecc044810ce073584a4692769d3721f0a4753030c3b	2022-08-11 15:50:39.888332	1705002	\N	t
2	1002	uploads/1002/4c4c12eaf785584_State2D.java	2022-08-11 15:54:20.137586	1705002	\N	t
3	4	uploads/4/a580004e4615186_LICENSE.md	2022-08-11 16:02:35.351322	1705002	\N	t
4	9	uploads/9/6d75a8ecbd983a1_CT-2.pdf	2022-08-14 14:24:01.053318	1705002	\N	t
5	9	uploads/9/71095173dbd871c_CT-2.pdf	2022-08-14 14:24:03.390671	1705002	\N	t
6	9	uploads/9/3e5a57018435453_CT-2.pdf	2022-08-14 14:24:03.835346	1705002	\N	t
7	9	uploads/9/f7057b10ac45284_CT-2.pdf	2022-08-14 14:24:04.072687	1705002	\N	t
8	9	uploads/9/114026381ba4871_CT-2.pdf	2022-08-14 14:24:04.245841	1705002	\N	t
9	9	uploads/9/bd3f571adb55904_Crab_rRNA.meg	2022-08-14 15:01:17.642119	1705002	\N	t
10	9	uploads/9/2a286bdd513fa1b_Crab_rRNA.meg	2022-08-14 15:01:41.906623	1705002	\N	t
11	1003	uploads/1003/43b31d690b2bbda_hsp20.meg	2022-08-14 16:22:25.333635	1705002	\N	t
12	1003	uploads/1003/a862f82e0e0ac87_hsp20.meg	2022-08-14 16:22:27.010784	1705002	\N	t
13	1002	uploads/1002/7edb0a154a88bda_CSE318_Offline_on_Probabilistic_Model.pdf	2022-08-27 17:34:27.415422	1705002	\N	t
14	1002	uploads/1002/10fe4e79864f23c_CSE318_Offline_on_Probabilistic_Model.pdf	2022-08-27 17:42:22.456803	1705002	\N	t
15	1002	uploads/1002/df77d85749a34a1_CSE318_Offline_on_Probabilistic_Model.pdf	2022-08-27 17:43:06.187799	1705002	\N	t
16	1002	uploads/1002/05ee67a68c83bbe_CSE318_Offline_on_Probabilistic_Model.pdf	2022-08-27 17:43:09.48444	1705002	\N	t
17	1002	uploads/1002/247859c6e182061_ECE_Cafe_application.docx	2022-08-27 20:28:57.692796	1705002	\N	t
18	11	uploads/11/4f10faa22f9cd2e_ECE_Cafe_application.docx	2022-08-28 11:29:25.055812	1705002	\N	t
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (notification_id, person_id, "desc", type, seen) FROM stdin;
38	1705045	A patient has uploaded file(s) against your file request titled Anger Stories	U	t
11	1705044	A patient has uploaded file(s) against your file request titled Mania Videos	U	f
12	1705045	A patient has asked for a consultation at Thursday: 8 PM - 11 PM	C	t
14	1705010	Dr. Iftekhar Hakim Kaowsar has verified your report for LEVEL 2—Substance Use—Adult	V	f
15	1705045	A patient has asked for a consultation at Friday: 9 AM - 11 AM	C	t
17	1705045	A patient has asked for a consultation at Friday: 9 AM - 11 AM	C	t
19	1705045	A patient has asked for a consultation at Friday: 9 AM - 11 AM	C	t
21	1705045	A patient has asked for a consultation at Friday: 9 AM - 11 AM	C	t
23	1705045	A patient has asked for a consultation at Friday: 9 AM - 11 AM	C	t
25	1705045	A patient has asked for a consultation at Wednesday: 3 PM - 5 PM	C	t
26	1705010	Dr. Iftekhar Hakim Kaowsar has verified your report for LEVEL 2—Substance Use—Adult	V	f
27	1705017	Dr. Najibul Haque Sarker has verified your report for LEVEL 2—Depression—Adult	V	f
29	1705044	A patient has asked for a consultation at Tuesday: 3 PM - 5 PM	C	f
30	1705005	Dr. Najibul Haque Sarker has accepted your consultation request at 2022-08-29 18:00:00	A	f
32	1705005	Dr. Najibul Haque Sarker has accepted your consultation request at 2022-08-30 15:00:00	A	f
33	1705044	A patient has asked for a consultation at Thursday: 6 PM - 11 PM	C	f
7	1705002	Dr. Iftekhar Hakim Kaowsar has accepted your consultation request at 2022-08-31 15:00:00	A	t
8	1705002	Dr. Iftekhar Hakim Kaowsar has rejected your consultation request at 2022-08-27 09:34:26	D	t
10	1705002	Dr. Iftekhar Hakim Kaowsar has verified your report for LEVEL 2—Anger—Adult	V	t
13	1705002	Dr. Iftekhar Hakim Kaowsar has verified your report for LEVEL 2—Substance Use—Adult	V	t
16	1705002	Dr. Iftekhar Hakim Kaowsar has accepted your consultation request at 2022-09-02 09:00:00	A	t
18	1705002	Dr. Iftekhar Hakim Kaowsar has accepted your consultation request at 2022-09-02 09:00:00	A	t
20	1705002	Dr. Iftekhar Hakim Kaowsar has accepted your consultation request at 2022-09-02 09:00:00	A	t
22	1705002	Dr. Iftekhar Hakim Kaowsar has accepted your consultation request at 2022-09-02 09:00:00	A	t
24	1705002	Dr. Iftekhar Hakim Kaowsar has accepted your consultation request at 2022-09-02 09:00:00	A	t
28	1705002	Dr. Iftekhar Hakim Kaowsar has verified your report for LEVEL 2—Anger—Adult	V	t
31	1705002	Dr. Najibul Haque Sarker has accepted your consultation request at 2022-08-30 15:00:00	A	t
34	1705002	Dr. Najibul Haque Sarker has accepted your consultation request at 2022-09-01 18:00:00	A	t
35	1705044	A patient has asked for a consultation at Thursday: 6 PM - 11 PM	C	f
36	1705005	Dr. Najibul Haque Sarker has declined your consultation request at 2022-08-29 09:55:51.332461	D	f
37	1705002	Dr. Najibul Haque Sarker has accepted your consultation request at 2022-09-01 18:00:00	A	t
\.


--
-- Data for Name: options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.options (option_id, option_text, score, question_id) FROM stdin;
111	Never	1	23
112	Rarely	2	23
113	Sometimes	3	23
114	Often	4	23
115	Always	5	23
116	Never	1	24
117	Rarely	2	24
118	Sometimes	3	24
119	Often	4	24
120	Always	5	24
121	Never	1	25
122	Rarely	2	25
123	Sometimes	3	25
124	Often	4	25
125	Always	5	25
126	Never	1	26
127	Rarely	2	26
128	Sometimes	3	26
129	Often	4	26
130	Always	5	26
106	Never	1	22
107	Rarely	2	22
108	Sometimes	3	22
109	Often	4	22
110	Always	5	22
89	Often	4	18
105	Always	5	21
98	Sometimes	3	20
69	Often	4	14
101	Never	1	21
100	Always	5	20
55	Nearly every day	5	11
24	More than half the days	4	5
18	Several days	3	4
104	Often	4	21
81	Never	1	17
82	Rarely	2	17
12	Rare, less than a day or two	2	3
67	Rarely	2	14
84	Often	4	17
91	Never	1	19
23	Several days	3	5
86	Never	1	18
2	Rare, less than a day or two	2	1
60	Nearly every day	5	12
33	Several days	3	7
63	Several days	3	13
96	Never	1	20
27	Rare, less than a day or two	2	6
43	Several days	3	9
99	Often	4	20
7	Rare, less than a day or two	2	2
38	Several days	3	8
14	More than half the days	4	3
17	Rare, less than a day or two	2	4
15	Nearly every day	5	3
47	Rare, less than a day or two	2	10
9	More than half the days	4	2
25	Nearly every day	5	5
57	Rare, less than a day or two	2	12
10	Nearly every day	5	2
88	Sometimes	3	18
58	Several days	3	12
20	Nearly every day	5	4
52	Rare, less than a day or two	2	11
22	Rare, less than a day or two	2	5
53	Several days	3	11
29	More than half the days	4	6
32	Rare, less than a day or two	2	7
30	Nearly every day	5	6
62	Rare, less than a day or two	2	13
40	Nearly every day	5	8
72	Rarely	2	15
42	Rare, less than a day or two	2	9
4	More than half the days	4	1
73	Sometimes	3	15
35	Nearly every day	5	7
5	Nearly every day	5	1
37	Rare, less than a day or two	2	8
68	Sometimes	3	14
21	Not at all	1	5
44	More than half the days	4	9
75	Always	5	15
103	Sometimes	3	21
16	Not at all	1	4
46	Not at all	1	10
87	Rarely	2	18
19	More than half the days	4	4
26	Not at all	1	6
50	Nearly every day	5	10
65	Nearly every day	5	13
97	Rarely	2	20
95	Always	5	19
92	Rarely	2	19
36	Not at all	1	8
59	More than half the days	4	12
90	Always	5	18
39	More than half the days	4	8
1	Not at all	1	1
70	Always	5	14
31	Not at all	1	7
85	Always	5	17
34	More than half the days	4	7
41	Not at all	1	9
11	Not at all	1	3
51	Not at all	1	11
80	Always	5	16
13	Several days	3	3
76	Never	1	16
61	Not at all	1	13
93	Sometimes	3	19
56	Not at all	1	12
78	Sometimes	3	16
3	Several days	3	1
77	Rarely	2	16
45	Nearly every day	5	9
48	Several days	3	10
28	Several days	3	6
66	None	1	14
8	Several days	3	2
83	Sometimes	3	17
71	Never	1	15
79	Often	4	16
74	Often	4	15
54	More than half the days	4	11
6	Not at all	1	2
102	Rarely	2	21
49	More than half the days	4	10
64	More than half the days	4	13
94	Often	4	19
134	Ka	1	29
135	Kha	2	29
136	Ga	3	29
137	A	1	30
138	B	2	30
139	C	3	30
140	Very False or Often False	0	33
141	Sometimes or Somewhat False	1	33
142	Sometimes or Somewhat True	2	33
143	Very True or Often True	3	33
144	Very False or Often False	0	34
145	Sometimes or Somewhat False	1	34
146	Sometimes or Somewhat True	2	34
147	Very True or Often True	3	34
148	Very False or Often False	0	35
149	Sometimes or Somewhat False	1	35
150	Sometimes or Somewhat True	2	35
151	Very True or Often True	3	35
152	Very False or Often False	0	36
153	Sometimes or Somewhat False	1	36
154	Sometimes or Somewhat True	2	36
155	Very True or Often True	3	36
156	Very False or Often False	0	37
157	Sometimes or Somewhat False	1	37
158	Sometimes or Somewhat True	2	37
159	Very True or Often True	3	37
160	Very False or Often False	0	38
161	Sometimes or Somewhat False	1	38
162	Sometimes or Somewhat True	2	38
163	Very True or Often True	3	38
164	Very False or Often False	0	39
165	Sometimes or Somewhat False	1	39
166	Sometimes or Somewhat True	2	39
167	Very True or Often True	3	39
168	Very False or Often False	0	40
169	Sometimes or Somewhat False	1	40
170	Sometimes or Somewhat True	2	40
171	Very True or Often True	3	40
172	Very False or Often False	0	41
173	Sometimes or Somewhat False	1	41
174	Sometimes or Somewhat True	2	41
175	Very True or Often True	3	41
176	Very False or Often False	0	42
177	Sometimes or Somewhat False	1	42
178	Sometimes or Somewhat True	2	42
179	Very True or Often True	3	42
180	Very False or Often False	0	43
181	Sometimes or Somewhat False	1	43
182	Sometimes or Somewhat True	2	43
183	Very True or Often True	3	43
184	Very False or Often False	0	44
185	Sometimes or Somewhat False	1	44
186	Sometimes or Somewhat True	2	44
187	Very True or Often True	3	44
188	Very False or Often False	0	45
189	Sometimes or Somewhat False	1	45
190	Sometimes or Somewhat True	2	45
191	Very True or Often True	3	45
192	Very False or Often False	0	46
193	Sometimes or Somewhat False	1	46
194	Sometimes or Somewhat True	2	46
195	Very True or Often True	3	46
196	Very False or Often False	0	47
197	Sometimes or Somewhat False	1	47
198	Sometimes or Somewhat True	2	47
199	Very True or Often True	3	47
200	Very False or Often False	0	48
201	Sometimes or Somewhat False	1	48
202	Sometimes or Somewhat True	2	48
203	Very True or Often True	3	48
204	Very False or Often False	0	49
205	Sometimes or Somewhat False	1	49
206	Sometimes or Somewhat True	2	49
207	Very True or Often True	3	49
208	Very False or Often False	0	50
209	Sometimes or Somewhat False	1	50
210	Sometimes or Somewhat True	2	50
211	Very True or Often True	3	50
212	Very False or Often False	0	51
213	Sometimes or Somewhat False	1	51
214	Sometimes or Somewhat True	2	51
215	Very True or Often True	3	51
216	Very False or Often False	0	52
217	Sometimes or Somewhat False	1	52
218	Sometimes or Somewhat True	2	52
219	Very True or Often True	3	52
220	Very False or Often False	0	53
221	Sometimes or Somewhat False	1	53
222	Sometimes or Somewhat True	2	53
223	Very True or Often True	3	53
224	Very False or Often False	0	54
225	Sometimes or Somewhat False	1	54
226	Sometimes or Somewhat True	2	54
227	Very True or Often True	3	54
228	Very False or Often False	0	55
229	Sometimes or Somewhat False	1	55
230	Sometimes or Somewhat True	2	55
231	Very True or Often True	3	55
272	Not at all	0	56
273	One or two days	1	56
274	Several days	2	56
275	More than half the days	3	56
276	Nearly every day	4	56
277	Not at all	0	57
278	One or two days	1	57
279	Several days	2	57
280	More than half the days	3	57
281	Nearly every day	4	57
282	Not at all	0	58
283	One or two days	1	58
284	Several days	2	58
285	More than half the days	3	58
286	Nearly every day	4	58
287	Not at all	0	59
288	One or two days	1	59
289	Several days	2	59
290	More than half the days	3	59
291	Nearly every day	4	59
292	Not at all	0	60
293	One or two days	1	60
294	Several days	2	60
295	More than half the days	3	60
296	Nearly every day	4	60
297	Not at all	0	61
298	One or two days	1	61
299	Several days	2	61
300	More than half the days	3	61
301	Nearly every day	4	61
302	Not at all	0	62
303	One or two days	1	62
304	Several days	2	62
305	More than half the days	3	62
306	Nearly every day	4	62
307	Not at all	0	63
308	One or two days	1	63
309	Several days	2	63
310	More than half the days	3	63
311	Nearly every day	4	63
312	Not at all	0	64
313	One or two days	1	64
314	Several days	2	64
315	More than half the days	3	64
316	Nearly every day	4	64
317	Not at all	0	65
318	One or two days	1	65
319	Several days	2	65
320	More than half the days	3	65
321	Nearly every day	4	65
322	None	0	66
323	Mild	1	66
324	Moderate	2	66
325	Severe	3	66
326	Extreme	4	66
327	None	0	67
328	Mild	1	67
329	Moderate	2	67
330	Severe	3	67
331	Extreme	4	67
332	None	0	68
333	Mild	1	68
334	Moderate	2	68
335	Severe	3	68
336	Extreme	4	68
337	None	0	69
338	Mild	1	69
339	Moderate	2	69
340	Severe	3	69
341	Extreme	4	69
342	None	0	70
343	Mild	1	70
344	Moderate	2	70
345	Severe	3	70
346	Extreme	4	70
347	Not at all	0	71
348	A little bit	1	71
349	Somewhat	2	71
350	Quite a bit	3	71
351	Very much	4	71
352	Not at all	0	72
353	A little bit	1	72
354	Somewhat	2	72
355	Quite a bit	3	72
356	Very much	4	72
367	Very much	0	73
368	Quite a bit	1	73
369	Somewhat	2	73
370	A little bit	3	73
371	Not at all	4	73
372	Very much	0	74
373	Quite a bit	1	74
374	Somewhat	2	74
375	A little bit	3	74
376	Not at all	4	74
377	Never	0	75
378	Rarely	1	75
379	Sometimes	2	75
380	Often	3	75
381	Always	4	75
382	Never	0	76
383	Rarely	1	76
384	Sometimes	2	76
385	Often	3	76
386	Always	4	76
387	Never	0	77
388	Rarely	1	77
389	Sometimes	2	77
390	Often	3	77
391	Always	4	77
397	Not at all	0	79
398	A little bit	1	79
399	Moderately	2	79
400	Quite a bit	3	79
401	Extremely	4	79
402	Not at all	0	80
403	A little bit	1	80
404	Moderately	2	80
405	Quite a bit	3	80
406	Extremely	4	80
407	Not at all	0	81
408	A little bit	1	81
409	Moderately	2	81
410	Quite a bit	3	81
411	Extremely	4	81
412	Not at all	0	82
413	A little bit	1	82
414	Moderately	2	82
415	Quite a bit	3	82
416	Extremely	4	82
417	Not at all	0	83
418	A little bit	1	83
419	Moderately	2	83
420	Quite a bit	3	83
421	Extremely	4	83
422	Not at all	0	84
423	A little bit	1	84
424	Moderately	2	84
425	Quite a bit	3	84
426	Extremely	4	84
427	Not at all	0	85
428	A little bit	1	85
429	Moderately	2	85
430	Quite a bit	3	85
431	Extremely	4	85
432	Not at all	0	86
433	A little bit	1	86
434	Moderately	2	86
435	Quite a bit	3	86
436	Extremely	4	86
437	Not at all	0	87
438	A little bit	1	87
439	Moderately	2	87
440	Quite a bit	3	87
441	Extremely	4	87
442	Aegon	1	88
443	Viserys	2	88
444	Daeron	3	88
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients (height_inches, weight_kgs, location, patient_id) FROM stdin;
65	85	Demra	1705002
68	75	Chef's Table	1705008
68	65	Xu Lab	1705015
65	\N	\N	3
66	\N	\N	4
67	\N	Left Wing	1705016
65	\N	Khulna	1705017
408	515	dffrgeb	5
40	42	NAY	6
68	85	Hell	7
63	82	Shyamolli	1705010
67	68	Dinajpur	1705001
66	72	Uttara	1705044
63	55	Jigatala	1705004
63	55	Kalabagan	1705005
\.


--
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persons (person_id, name, email, password_hash, date_of_birth, gender, photo_path, cellphone, role) FROM stdin;
1705062	Jawad Ul Kabir	jawaduk15@gmail.com	pbkdf2:sha256:260000$pIUgb3K1mDvcHf4V$108cd7c6375aeda4214113352e53117316cbe05846365834efc7d2b8322e0246	1992-07-29 00:00:00	M	picsum.photos/200	01775024408	psychiatrist
1705060	Maisha Rahman Mim	maisharahman494@gmail.com	pbkdf2:sha256:260000$595olEpwGXhC73px$f18fdf8c562b39f9a11c333723aad9e9fc08502277f39174f9550861275764c2	1992-07-29 00:00:00	F	picsum.photos/200	0191922921	psychiatrist
6	Random Ran	ran@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$iiNZwwCrXYEjjDsS$edda6348db7477594ae136e64d1ca7ee252ea6e31fbdcb18a3641cc1651d1bb7	2015-01-10 00:00:00	f	https://picsum.photos/200	\N	\N
1705003	Mahdi Hasnat Siyam	mahdibuet3@gmail.com	pbkdf2:sha256:260000$BeGE3cJBmunSYhPO$c08ffbd2b5361269c84afbec806aad85d3ce631888b86684f0a3f8705bfb3b39	1992-07-29 00:00:00	M	picsum.photos/200	\N	psychiatrist
7	Check Check 	check@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$o8yig7eztorrmkP9$17c8085af636de4e68365622322cb8b7ac755be107c757abdca391d170eeeeae	1986-10-10 00:00:00	f	https://picsum.photos/200	\N	patient
8	Sheikh Munim Hossain	munim@pq.er	pbkdf2:sha256:260000$HkZhtvd5Nv3uvJw6$dd2bf9b06c4cd419e175d2eafedd4a98887f01ee0efae5c25355a071e1d7fc51	1998-08-15 00:00:00	m	https://picsum.photos/200	\N	psychiatrist
1705004	Ramisa Alam	ramisa2108@gmail.com	pbkdf2:sha256:260000$qaWkYmoDLMsLL4nz$5b5c6009099a4897d20441cd415639661b63e2d1be0a0950efd81136cb83d527	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705063	Mahfuzur Rahman Rifat	mahfuzrifat7@gmail.com	pbkdf2:sha256:260000$tJzDhjunK9QIscUy$466d2a5a17e6588fa68518b4f0fb224e150f97a71e670642bfb387e90fc91e8d	1992-07-29 00:00:00	M	picsum.photos/200	``	psychiatrist
1705007	Md. Tawsif Shahriar Dipto	tawsifshahriar7@gmail.com	pbkdf2:sha256:260000$3eGhzLwnuggH6slw$79343cd5ce99d36c218098de7456482653aaf39e7770ab9904c2dd153b5c8e4a	1992-07-29 00:00:00	M	picsum.photos/200	\N	psychiatrist
1705009	Shayekh Bin Islam	shayekh.bin.islam@gmail.com	pbkdf2:sha256:260000$2Rqo77uvkBqdI1wZ$43f42e2503f2fd305ea7b67f00b30916acc012946d0b47ddbef7a68888d7eb98	1992-07-29 00:00:00	M	picsum.photos/200	\N	psychiatrist
1	Goodman	goodman@mail.com	pbkdf2:sha256:260000$K2sfLqByvR0UFkwX$189d1029f0e340154e1ebe2b43dd31a9a5845f391f9f49687d53aa65cf888b6d	1992-07-29 00:00:00	\N	\N	\N	patient
2	Sipser	sipser@mit.edu	pbkdf2:sha256:260000$iqEK4azzRfOEl3co$4630cc072e2c33a3102250e62e41a55448d2d5b8bd1d16d828fd491c6cbdd273	1992-07-29 00:00:00	\N	\N	\N	patient
3	\N	\N	\N	1992-07-29 00:00:00	\N	\N	\N	patient
5	ewfrghrebe	s@eb.e	pbkdf2:sha256:260000$sQQYoF7IRpqIzWyv$c4e7867bf1fb44b7a69b6586d6d4e827782014604eee1810297891b08fcae416	1992-07-29 00:00:00	f	https://picsum.photos/200	\N	patient
1705008	Sheikh Saifur Rahman Jony	srj.buet17@gmail.com	pbkdf2:sha256:260000$HBmsjjRuCXER06XA$c47838a6e5ffd0e6974d949d42c819b6295623919e5d2f6c09d029744fc75cff	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705010	Md. Zarif-Ul-Alam	zarif98sjs@gmail.com	pbkdf2:sha256:260000$YwrNaOlNUdrS19Mq$2ab52d93e6b15a2022c2b0a6d2902a6e0f1962fbde0308f3dfea83519d0c1964	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705011	Md. Salman Farsi	salman201103@gmail.com	pbkdf2:sha256:260000$xMEwJ2Vu1cISEoYF$77b1fb128d0d34103e71a75c8bb85aea5a402d18c96b67f111412f41113c9e98	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705012	Jamilus Sheium	sheium1998@gmail.com	pbkdf2:sha256:260000$194xE4UAdBcncV1F$3eef4b6e7f4eabca721c4d0757e465cca9cf1a4933d51f603b4337f913c2062f	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705013	Md. Olid Hasan Bhuiyan	1705013@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$L2okFmZO0qwMwuYs$5cdb8615769c307f3a09bbbc967b1a48da31ac9b3fd29cf87971f23b3e5973ac	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705014	Naeem Ahmed	naeemtanveer1024@gmail.com	pbkdf2:sha256:260000$YZtM3Zb06Z2PvIxw$cf123db056e85c679f84801e50cceb13d513e4779f0163855ea677c6a083b688	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705015	Zaber Ibn Abdul Hakim	ak5236638@gmail.com	pbkdf2:sha256:260000$H6RPr1VDWGbUBdWB$6d6bef379a15571cc35b812cc1e21ebf8ca5bf85e9c66d2e49db9fb445bbc511	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705016	Ridwanul Hasan Tanvir	1705016@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$mSZJmhAcvK0wmIFS$5eeb2fccb27090efdbdba29bafe992d36c883a78d1e32a2d68f06f76c68705fe	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705017	Towhidul Islam	towhidpqrst@gmail.com	pbkdf2:sha256:260000$J5QieJM8s4ncamCd$5f60cb1c97dd706720d790b73db9932cc3500d24d4020c1d05d522173721c473	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705018	Shakil Ahmed	shakilahmedndc@gmail.com	pbkdf2:sha256:260000$yNh1f5p6F5zniBSK$9c480721023c9c29e588755ae1727e9d7c70d1055c0555692f3fb3e6472a0b4f	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705066	Ataf Fazledin Ahamed	rabidahamed@gmail.com	pbkdf2:sha256:260000$HIfRD7fAQ7uIlLiD$bf4b81854b66b5028af96a9b6deca6f1627ba335ae70c3723607cc94811420d6	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705068	Saadman Ahmed	1705068@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$duMkRFXotqCtcB1G$77a30761f9a8e277c6c45aecddf9cabdfb4d8191dd3c5714747f654f41a51a5c	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705070	Al Arafat Tanin	1705070@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$8094iypQv2HF3Cq3$8db434043b3d4f09abaa4bed6cff9faf67d49a80d12b928c72e9503a160f2f94	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705073	Istiak Bin Mahmod	1705073@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$30uEm8R4X20n4Xul$54d9c77fd4b4f11c31303dd2ef5c1bdfa38e916fee7f07316192f6bf45398f03	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705075	Ovi Poddar	ovi.poddar2@gmail.com	pbkdf2:sha256:260000$8Vl3kfIzya2geAiO$7aa87b4b32bd675524ee90af5c3f17d268e22174015714da68de15f49ff13e15	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705077	Fahim Faysal	ffalsoy@gmail.com	pbkdf2:sha256:260000$2igbD8DXSHVfzeZo$016f983c41d43412900d371ac9defc710e38d94329d3c7d982496333276bb76b	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705079	Kazi Wasif Shammya	kaziwasifamin@hotmail.com	pbkdf2:sha256:260000$mcMUHw1wTVwh2ITb$125138a43ddd91d8e9ba492d74a85b7bad3c1066c94e4023cf819ae3ec2b38a4	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705101	Abdur Rahman Shibly	shibly.ar@gmail.com	pbkdf2:sha256:260000$UU7MgZLkrLDIymGQ$4337d4acdb0f00a0bab46026cd789e266652bd48c03a3c490ec0a54575b9618b	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705082	Md. Mehedi Hasan	1705082@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$pns4J7aX9k3htgVH$c6ff7937a3e6cba4f070cce5ee19e770a6e3cbdcef1aeab55395370f2093795c	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705084	Asif Ahmed Utsa	1705084@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$mhYKftyItWjHy4Zs$941932925eb16c887b89f203191b778b8094b8ff93d6501bcfd63c82a573f2ee	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705087	Fahmid Al Rifat	alrifatfahmid@gmail.com	pbkdf2:sha256:260000$qmnzkEgEfFODpB37$9ca7cb4e2fab620ac9f3c2f3ee5032caa4b6df0c6ce6f182f91c8bb5b4c00fa1	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705089	Noshin Ulfat	1705089@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$FQVS8uyr5CZSkQ2B$6a404c82419b21d2e554d221a51631248d5e790b559345e83bbfff718b47ec1f	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705091	Nahian Salsabil	cse_salsabil@yahoo.com	pbkdf2:sha256:260000$xIgeqZHa2NCKtkAI$d5b655d8c2dd2d2f5e44ee27c1886fac3f0ffcd1908739cba39c150ec29b0eda	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705093	Fatima Nawmi	fatimanawmi@gmail.com	pbkdf2:sha256:260000$eSIzJXepataPRcIE$ecd4c117d1750b2d89cb6c69d97aa2e156735c7eb447fe678ebe3846ab8d7656	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705096	Kazim Abrar Mahi	kazimabrarmahi135@gmail.com	pbkdf2:sha256:260000$ifaviP5AExFTD6D3$fec35203372f87f43833413adfd26bd4aeac871a651dbb1ae9f9d749cdc37ee9	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705098	Sihat Afnan	sihatafnan15.9.1997@gmail.com	pbkdf2:sha256:260000$bY8zy6qVaQWLRC2b$2d1fa831a3aa6aa895048278a31bc9f0b702cb78abf47bd3e12f64c5c7102746	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705100	Farhana Khan	farhanakhanhp@gmail.com	pbkdf2:sha256:260000$7fxYFfzpHEJZIZAJ$401e356d9ef66ae21981da1c283569fcacdc492638b4ef1e52f2842c16e94b2c	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705103	Nazmul Takbir	nazmultakbir98@gmail.com	pbkdf2:sha256:260000$AhefXIEBzxRXOUmG$c7ac0160b6387fecf30ca554a086d742afbbb9a701efcdf39776c5fce4c3a96c	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705105	Rittik Basak Utsha	rittik.basak@gmail.com	pbkdf2:sha256:260000$WxOXMZZDXQsZ96Vh$95fc1fa583506bc7dd5906516144a0b5a1898f8e782517b73b0f273d7f5a34f6	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
4	Sipser2	sipser2@mit.edu	pbkdf2:sha256:260000$XWi5d6w9t08E3hU5$f5aed2082786f273a3a06bd4fff8ca89834b0712feb52f4b4b6110fa61f9e45e	1992-07-29 00:00:00	\N	\N	\N	patient
1705001	Kowshic Roy	vdrkowshic@gmail.com	pbkdf2:sha256:260000$gCrYpvHhyqzeNwRo$a317e8ae3c4350ef83f8eb6788b36e1867f7732c42b59189c5f209dc240c13d9	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705002	Sheikh Azizul Hakim	1705002@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$2KVoasWGhJoxocm8$a8811a419ac30caa3d89e1971831981cb75f9dc35e00f4216e1e47a6684af8f0	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705005	Mashiat Mustaq	mashiatmustaq98@gmail.com	pbkdf2:sha256:260000$ZWilIi2y0RyghzLT$13e0c882fc3683cc4d7bbff09c0c3d54c02f7f5cb4e0d76dc833055f91f27e58	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705006	Saiful Islam	saifulislambuet11@gmail.com	pbkdf2:sha256:260000$lIjzNJVJW9l7icp2$124e497999845b0a2e4aa7564fc8bf1f0c05d877fcf0aabc75a775d1237ce8b8	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705047	Jayanta Sadhu	jayantasadhu4557@gmail.com	pbkdf2:sha256:260000$bIrQq1498gusSAGl$f1a7318a54d003ace1f4098d4099b8d52dc4f5e6b6d191138d120c3c53900623	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705049	Taufiqun Nur Farid	1705049@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$t5XRJLDWyRpsqHrh$0cac1ba9edf2a6e2c6d2474d19ca0b47d56f19869e3c8d47851f572c74ca69c5	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705052	Pushpita Joardar	pushpitajoardar21@gmail.com	pbkdf2:sha256:260000$I60pLO6QG5TVlmQ5$c67a6bf8ef6aea02751169ca55090cfb913f75ff7784bfab5ea580e5768335c3	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705054	Monirul Haq Imon	worstemon8@gmail.com	pbkdf2:sha256:260000$UKCGveoj2jg1awF8$a7fe375e4693ccfdb803fc4f969b464c4bf96962bad0724813b71a06aef42870	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705056	Apurba Saha	diponsaha007@gmail.com	pbkdf2:sha256:260000$LsxgGPRO52Cnjk60$e13af4bb238ceaadafc3401667939ce8d0a6f4f862f597252b60d065b4271e3a	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705058	Fattah-zul-ikram	galib05058@gmail.com	pbkdf2:sha256:260000$DjdpHGgnrxMrq7B0$76c9517a89a6fd9bf400422b6d5dc9bfc02c14c7de8a5ea97d7dedb1dabfc17f	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705061	Maksudur Rahaman Rana	mksdrrana@gmail.com	pbkdf2:sha256:260000$rKHjSm1PK6vIEmb7$9c53e383c44b31de6fb1aee2b0bb11989e7229715fe242dbe439588996534bbf	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705107	Abu Nowshed Sakib	ansakib04@gmail.com	pbkdf2:sha256:260000$Nmdji672PIeNRNXC$b4aa7c5c4e9e20ca080938f1092aae7a838a28556963b9928c988c2c586df04b	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705019	Adrita Hossain Nakshi	1705019@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$9AHNYSKJEILLFq6D$f3081e89d0e3bf626e164cec090dbd8c8b36818fbc3f26b3b368817a0e2f4ebc	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705020	Md. Arafat Hossain	araf.reputation1999@gmail.com	pbkdf2:sha256:260000$yoPMopfsx57vzpcP$526aea2a983ffd580046ff067656da8eb848a0d58b0981e49e4517adef51b7ee	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705021	Md. Shadmim Hasan Sifat	sifathshadmim@gmail.com	pbkdf2:sha256:260000$bBO5Vw8zSQz1jOA0$6153e243d4a32f0b4a2fcd898d687837f1d472cc8affe046ba822aa2df57a7fd	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705022	Solaiman Ahmed	solaimanahmed112@gmail.com	pbkdf2:sha256:260000$jqY901Hd5xUd4Rsw$d7ca20121bc5f4a8a187e8400f8b88332c1393dc08c1ca26a74a7d14ac228141	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705030	Joy Saha	iamjoysaha1.0@gmail.com	pbkdf2:sha256:260000$Uds0vaMhoK9XjhZ6$e696af1d14ded4e212e8294c196b3c56929c10f0492e8a8801ef17556c78f514	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705023	S. M. Zuhair Jawhar Zaki	zuhairzaki500@gmail.com	pbkdf2:sha256:260000$G9CwI2ZCcNgDIpj4$efd91741d1b609f1d04a1be93f76c95037c2bffa934b1bd37687db1539af93d1	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705024	Khandokar Md. Rahat Hossain	rahat2975134@gmail.com	pbkdf2:sha256:260000$y20DfBPV4bi107Yn$a75703855b1ecf0b92c2009ee2cdad091cca98458df6e04cc9b797d9a11d5e07	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705025	Swapnil Dey	swapnildey1999@gmail.com	pbkdf2:sha256:260000$sYqZTq31gv5uRCBw$31186c851b3071b349d95cd51c239062dc37dd3eb6dc0dca7942b1877964205f	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705026	Shafqat Rakin	shafqatrakin@gmail.com	pbkdf2:sha256:260000$O8p0SRerPuVhvJkq$393fe092ff074be82ffa788f31880e38e4c95437c35c2f851d49fb78c232aa82	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705027	Saem Hasan	sayim.hasan30@gmail.com	pbkdf2:sha256:260000$KcjDBkstxpuxXpKD$a1f9940585c0ace0e56c94c9acbc4dadd48cad1529525657a5e90c67e2332880	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705028	Samira Islam	samiraakhter8657@gmail.com	pbkdf2:sha256:260000$9WyVaUPXQl79ftXU$c38d6d96b54f385041b96fb75b066f32049973f0d0f430b4bf1ca82a9e20b6fd	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705029	Simantika Dristi	queendristi27@gmail.com	pbkdf2:sha256:260000$6fpCjLJBOzo7UKBg$2d387af3988f1ab441f0b81ab077ddb47576319e5ecbb9a21751cc9627a2d7c2	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705031	Md. Mahedi Hasan Rigan	mahedihasanrigan82@gmail.com	pbkdf2:sha256:260000$StVH9wxtergfVEDm$bfd81d7a51382d6824719b850159c4d1796ee39b0423507ae29083232c9cea5c	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705032	Tanjim Ahmed Khan	tanjim.ak49@gmail.com	pbkdf2:sha256:260000$7lhiy09ceI2i6Lpw$c7d636ed6bbc11a75a46cc82c837ca8868b1984de5d48797eaadfabf2f82bab7	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705033	Tanberul Islam Ruhan	tanberulislam98@gmail.com	pbkdf2:sha256:260000$gsdDphX4lKkn2evG$fbc0c6c83297cbb4520f9702a20fc8b45e64d56b06b142bffacd16a4a6b83867	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705034	Souvik Das	souvik.piyal@gmail.com	pbkdf2:sha256:260000$3XsypgYIIzXvSknP$fea2b63c3c9201a67d3f519d61b994355fcb313a5dbdbf318b7cb67e21edacad	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705035	A. Z. M Mehedi Hasan	mehedihm2015@gmail.com	pbkdf2:sha256:260000$QFwWgU5hKkXDBi1T$6f5dee841045ebaa9734f8bb421c4ef0316c4412c38c93ab8e19a251bf2016ab	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705036	Ayan Antik Khan	ayanantikkhan@gmail.com	pbkdf2:sha256:260000$ffRMNxdQ0kxZBnIM$ccc11b36193c09c478a5612674e640767a280f9f0630f7edcc53e9cbc0c280f8	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705037	Mushtari Sadia	mushtarisadia98@gmail.com	pbkdf2:sha256:260000$mpyF72dVb2yVjGib$1884b41f7291ad6c98d3b55fce1e0936d5b9d0f7c79f1608405ca0eba89cd364	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705038	Fardin Hossain	fardinoyon123@gmail.com	pbkdf2:sha256:260000$NE64KCOtQfCFLJY3$84831bda7911bb0b3ead83d699a755c510a02c4602cdbbdb4118a7d2d9966c68	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705039	Tahmeed Tarek	tahmeedtarek@gmail.com	pbkdf2:sha256:260000$L8kpwrBVLblBFR7O$30acb3af5c7e9de627baf7a5f4132072f8f17ca2fcff105a3bfc3703e0beb05e	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705040	Umama Rahman	umamarahman5177@gmail.com	pbkdf2:sha256:260000$6X8TrokH6IE21ydW$5f3904e1a86ce1f5041c117bdd44af075a20948a18b4f6b86525c0883f848967	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705041	Asif Mustafa Hassan	asifmustafahassan@gmail.com	pbkdf2:sha256:260000$NFbUXaiVAPCfcWVk$3bb0a0685829d4f7803f25c23f1c72c337870f8615a159107250c63b18819131	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705109	Muhammad Nasif Imtiaz	nasif.imtiaz1997@gmail.com	pbkdf2:sha256:260000$gWhMPBl3IFxrhmay$8013a13e6f3fccb31ad9b1f56d95e77ea05634525f7b5b65f5c202e90028d929	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705110	Saif A. Khan	ksaifahmed4@gmail.com	pbkdf2:sha256:260000$wQxleQqDYhpnCAIx$818291a635037046fb64c98abbf6e187a88df003c1eae346958ae324341a5234	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705111	Ridwanul Haque (Ridy)	1705111@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$IdGHpbKQiGS6QdiR$37899b043ce90dd46db70fc25df4afaeff1f456c03ba98f175de9adc6f8f11ed	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705112	Zahin Hasan	zahinhasan2510@gmail.com	pbkdf2:sha256:260000$piz9PLsthFE4BKuR$b19d22ac751bb281545535cff47c58405dac5be09d10edcee9be37141ff8e300	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705113	Mahir Shahriar Dhrubo	msdhrubo98@gmail.com	pbkdf2:sha256:260000$WCX5zgaGq1xAQ9u7$5acc154375ebd5addc5b58cfab6a961ff53260e99f35469f2c90254a3141c419	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705114	Nuraiyad Nafiz Islam	nafizislam09@gmail.com	pbkdf2:sha256:260000$cUxd7onNduuAV1PL$e72d018201c5b024d16b5601886f9857a7db3e863ff2890abfea23fe7a37494e	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705115	Nazmul Hasan	nazmul.buet17@gmail.com	pbkdf2:sha256:260000$9gnq0MbU5Xs3DnXb$d99e6d17fff6bbf84fe459915a20d87fe873adf4a70a576a9a7cf7a60302511b	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705042	Sadat Shahriyar	shahriyarsadat@gmail.com	pbkdf2:sha256:260000$oKbALO8cNSVIK1mL$f2c81606254f44ef5836c423ae0ef331608a7aa8c2f9a3cee111ecde7f0fdf42	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705043	Kawshik Kumar Paul	kawshik.kumar.paul@gmail.com	pbkdf2:sha256:260000$OQqPg4BFXH6k21EH$a2bf1e16d18b3829ad8d5c7adef8db8e98bded6854b415da04e263c053dd5ff4	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705048	Sumaiya Azad	azadsumaiya00@gmail.com	pbkdf2:sha256:260000$7IAV8wMfCpr0hVPX$06c5c726955e3387b16e3dba01007c1b33f616dcb1147710725c31fde2aed7f8	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705050	Musharaf Hossain	mdmusharaf8071@gmail.com	pbkdf2:sha256:260000$wUU1AorOJMIGybEU$7186d9513a8ffedf404dc95244e1df7713b5c6398ce8756d6cf2164e272a414f	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705051	Rasman Mubtasim Swargo	rmswargo98@gmail.com	pbkdf2:sha256:260000$dTDPxIiwCDq6Ruv7$38d9fd6345bdb5c318e43fab28dc4f068f5ed9ac38097c304abb3b4e2be5c8a1	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705053	Tousif Tanjim Anan	anantousif@gmail.com	pbkdf2:sha256:260000$KokNYSDbQpAM9BCW$c063e27faea43f5cee28a4135e31192c4935163158428c9b3159a6c7ac37ac72	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705055	Md. Anwarul Karim	1705055@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$wjhDNL1uKXssGgFl$f0d5efcc882d26f6a285070bfe7d07c5d629aee9d3a4c754331f847c309737ae	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705057	Tanveer Hossain Munim	munim987654321@gmail.com	pbkdf2:sha256:260000$4hUYuw3IbaOXNd8W$d0a98f20a25fb97326cfbc136a6016a69707d40c2255cf9d80466c683fec3f9c	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705059	Shahriar-al-mohaiminul	mohaiminultanmoy@gmail.com	pbkdf2:sha256:260000$rIVXdWCGxPAMEGmn$67c1c35dad66c8ce13c523e76c1cd7677645204f882c900de92a92985106659c	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705064	Tanvir Raihan	traihan3130@gmail.com	pbkdf2:sha256:260000$NEh1QB0YYbc3TdSH$8aebda613af84090827fc84a8651d2a3ad76e3b7e2c61550255ff8b5f9178b0f	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705065	Tashin Mubassira	taseen123buet@gmail.com	pbkdf2:sha256:260000$LIvbWHqfzFQcVIMs$0c4d8091d784981495fb8a4ff8ebacb1faf5ab093adfaa1b973f5d696bc01f87	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705067	Purbasha Nishat	purbashafarhana@gmail.com	pbkdf2:sha256:260000$eLYDrTnHSJ4XgTc0$9f4ed47f2d3023d3c02478a9250b56c1d2458676afc95c3f623f3e625dd3f47f	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705069	Tanzim Hossain Romel	1705069@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$qzCNaCWoaflQyrVM$12d709c992f97fce981b20e79798d2f0a151fb7a4f5ccf15e33e006ba0843c6a	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705071	Prantik Paul	prantik0299@outlook.com	pbkdf2:sha256:260000$mng0JqazkG6eQO2f$8a042b653b538e0a936434a2092b4d04c8dcd74de734dae8dd1a125875b171f9	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705072	Sourov Jajodia	sourov.jph@gmail.com	pbkdf2:sha256:260000$SudMVjXPIisflQjF$cca87dc8cc70ea92a1af5e9d96086b163af1cbc761e6a2aecf8fd6000e65c9fa	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705074	Md. Tanzim Azad	nishan.tan.2015@gmail.com	pbkdf2:sha256:260000$fIDBoxuJsDaHKBXg$e555ffbb30ab43ea87d965dbbb4266c55352050e36407906de484b89099f0550	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705076	Md Sabbir Rahman	red.abiir@gmail.com	pbkdf2:sha256:260000$bAw02GfdjNJbaNu0$e429a1da87e66dc7acf9fd6ca351dc06b642bf4c12ca36db5b2104bf15e62709	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705078	Emamul Haque Pranta	mehpranta2015@gmail.com	pbkdf2:sha256:260000$V7DeGgvhzMqUP11K$9e36b81b158561f8515fa606662e19a5884556cfa44e183809ff4fef0e3e9372	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705080	Shafayat Hossain Majumder	monsieurmajumder@gmail.com	pbkdf2:sha256:260000$lg1sRdCsDtfdEe82$63723afa2d68b61e31eec870b955e3d85a5a6303d00a379bae60e1b74b17e255	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705081	Md.kamrujjaman Kamrul	1705081@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$je1Ug931ZB2dhs3n$b3f9c8e4d69a9fdf4eda20eced7d17d2b71615e78ad32103881932d6b916f84c	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705083	Hozifa Rahman Hamim	hozifahamim150@gmail.com	pbkdf2:sha256:260000$2deRj2yKJSZW1hZ1$332cfd46d8ebc58cb0852474dc2f5fd845cf6a09dd2a26cfc56dc760de642379	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705085	Mehedi Hasan (moidda)	mhasan912@gmail.com	pbkdf2:sha256:260000$lt1n8kRIj16U7Mba$99c31ec6daaf0ea979f11f2098d6267325a99d48c966a983fecd2f69a90ef69a	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705086	Shafaet Zaman	shafaetzaman937@gmail.com	pbkdf2:sha256:260000$NgAyKYwGsdmbeyRw$a22397cde17b338c08dd0df6c28db147fc8b90bd267891c44f219b0aae3051ba	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705088	Abdullah Al Noman	nomana589@gmail.com	pbkdf2:sha256:260000$Inudvylvb6QNy7XM$8bbbeb08b3be766a7f529ff783dd8feb88bb081e2b984ad4f8cfeda0802cb294	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705090	Ashrafi Zannat Ankon	1705090@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$Mx78o3aH6WWRrszM$abb0dd51e9fbe715038665442830d96d457a8efd668fdfe5b1154f6492f1bfe1	1992-07-29 00:00:00	F	picsum.photos/200	\N	patient
1705092	Asif Ajrof	asifajrof@gmail.com	pbkdf2:sha256:260000$Nd79BrYKaifGGJ6h$7bf125f556597ed13e27dafd49942a76cb5d5069328a90585b52a8d1bea62754	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705094	Kazi Md.irshad	1705094@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$A3XQlORjB40ozuXb$99169573de5651f94e68c2bf5bef8983577d82a4c8d9d679f9dbde8363726550	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705095	Arif Shariar Rahman	1705095@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$cBuLcrxhd1sWzgXk$45782aeaacd5b070c4f7e4595aaf1930a6ff01633dae2ed3bc0c2eac03156677	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705097	Mohammad Shamim Ahsan	shamim19119@gmail.com	pbkdf2:sha256:260000$gD62DpS4F7SpJAgS$285e1eabbd07890742a631be41b4d50caee85f8c104678444b5dec9c3026fa55	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705099	Abrar Shariare	abrar.cse17.buet@gmail.com	pbkdf2:sha256:260000$SsC7LSuA9sOlbokN$1fc097e331e70b7d71f5a171cf4ea62399682d158db61fa0a8f836a96b198998	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705102	Sadia Saman	1705102@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$JkclffLguFHqiF3I$4e7c40765bd30d3d90da926eafa3a2e11e26e5603218e9533636eabfd845d273	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705104	Anik Islam Pantha	1705104@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$wpvNt2Ki4HXtSU5i$d2213df96837c218454bddccb0cb7860fae533cb4b5291b7a94a15713d0778f1	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705106	Sakibur Reza	sakiburrezajony@gmail.com	pbkdf2:sha256:260000$LuwnncpjWxgKjGX4$8ec52c43d98375bf43d231dc85fd950ca7190c26e7fb48de6db58b927d997ea4	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705108	Muhtasim Noor Alif	muhtasimnoor@gmail.com	pbkdf2:sha256:260000$9H5BJVZo5cQkXuwR$a08b96a9cd2f2e8ebfdab94ff0c16a1dd92908fc10f51e4b7dd116c204e40815	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705116	Saikat Ghatak	1705116@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$zFQ1IdrzIaleAWJZ$d9d6834533413bccf333e389cdcc7c8888a3bf1d1e7334832690ea8eb712955d	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705118	Sharjil Hasan Mahir	sharjilmahir@gmail.com	pbkdf2:sha256:260000$YTszXtIwDNVHG60Q$d26ff1b45a98efe2d9f2aec24d6551d550820e155baad2c1636c4b820dc0c198	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705119	Shariful Islam	sharifulislam08031998@gmail.com	pbkdf2:sha256:260000$xOe5VR0V8Ptl0kYR$752e26b10be273dec874a77c31a6c546125372c9e182bc64ca6531e0dac68b15	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705120	Soham Khisa	1705120@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$oXvL3n7KAq9AbVm7$26426700de7d5c2f8c65d3822c69ca85ce89721cd89fcce5cd0a634e920bf47a	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705121	Aman Ray	1705121@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$Jy7tyn6WKTlhAAxQ$bd50087fe74095eb5dbd263af1a6048432ed91f4e6cde78fa78bdb7b128069de	1992-07-29 00:00:00	M	picsum.photos/200	\N	patient
1705045	Iftekhar Hakim Kaowsar	iftekharhakimkaowsar88@gmail.com	pbkdf2:sha256:260000$OE1qSI3a5Vt2SVYs$075d1f5b1f6996388ce6e9675c74d348081d66a7d11af52d557d915fc8d7f3be	1992-07-29 00:00:00	M	picsum.photos/200	01836178222	psychiatrist
1705044	Najibul Haque Sarker	najibhaq98@gmail.com	pbkdf2:sha256:260000$9bQ3mn4PZVrR2oVS$22af52a427f2e4b766515f8fab237e1aaf42a5078a72a405534be805fd419421	1992-07-29 00:00:00	M	picsum.photos/200	01927152595	psychiatrist
\.


--
-- Data for Name: psychiatrist_award; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.psychiatrist_award (psychiatrist_id, award_id) FROM stdin;
1705045	1
1705044	2
1705045	4
1705062	1
1705060	4
1705062	5
\.


--
-- Data for Name: psychiatrist_degree; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.psychiatrist_degree (psychiatrist_id, degree_id) FROM stdin;
1705044	1
1705044	4
1705045	2
1705045	3
\.


--
-- Data for Name: psychiatrist_disease; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.psychiatrist_disease (psychiatrist_id, disease_id) FROM stdin;
1705044	1
1705045	2
1705044	3
1705045	3
1705044	4
1705045	4
1705044	5
1705045	5
1705060	2
1705062	6
1705062	7
1705045	7
1705007	2
1705007	3
1705063	4
1705062	8
1705060	9
1705045	8
1705044	7
1705060	7
1705062	1
\.


--
-- Data for Name: psychiatrists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.psychiatrists (psychiatrist_id, is_verified, available_times, certificate_id, fee) FROM stdin;
1705045	t	Wednesday: 3 PM - 5 PM;Thursday: 8 PM - 11 PM;Friday: 9 AM - 11 AM	BMDC_A+_14705	3000
1705060	t	Monday: 6 PM - 11 PM;Wednesday: 3 PM - 5 PM;Thursday: 6 PM - 11 PM;Friday: 9 AM - 11 AM	BMDC_C_454854	700
1705044	t	Monday: 6 PM - 11 PM;Tuesday: 3 PM - 5 PM;Thursday: 6 PM - 11 PM	BMDC_A_70777	1000
1705062	t	Monday: 6 PM - 11 PM;Tuesday: 3 PM - 5 PM;Friday: 8 PM - 12 PM	BMDC_A_70789	1250
8	f	\N	BMDC_A_48485	450
1705063	t	Monday: 6 PM - 11 PM;Tuesday: 3 PM - 5 PM;Friday: 8 PM - 12 PM	BMDC_A_47522	1000
1705007	t	Monday: 6 PM - 11 PM;Tuesday: 2 PM - 5 PM;Friday: 8 PM - 12 PM	BMDC_A_47523	1000
1705009	t	Monday: 6 PM - 11 PM;Tuesday: 2 PM - 5 PM;Friday: 8 PM - 12 PM	BMDC_A_41253	1000
1705003	f	never	BMDC_A+++_544	10000
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (question_id, question_text, created_at, is_approved) FROM stdin;
1	Little interest or pleasure in doing things?	2022-07-15 19:10:55.09782	t
2	Feeling more irritated, grouchy, or angry than usual?	2022-07-15 19:10:55.09782	t
3	Sleeping less than usual, but still have a lot of energy?	2022-07-15 19:10:55.09782	t
4	Feeling nervous, anxious, frightened, worried, or on edge?	2022-07-15 19:10:55.09782	t
5	Unexplained aches and pains (e.g., head, back, joints, abdomen, legs)?	2022-07-15 19:10:55.09782	t
6	Thoughts of actually hurting yourself?	2022-07-15 19:10:55.09782	t
7	Hearing things other people couldn’t hear, such as voices even when no one was around?	2022-07-15 19:10:55.09782	t
8	Problems with sleep that affected your sleep quality over all?	2022-07-15 19:10:55.09782	t
9	Problems with memory (e.g., learning new information) or with location (e.g., finding your way home)?	2022-07-15 19:10:55.09782	t
10	Unpleasant thoughts, urges, or images that repeatedly enter your mind?	2022-07-15 19:10:55.09782	t
11	Feeling detached or distant from yourself, your body, your physical surroundings, or your memories?	2022-07-15 19:10:55.09782	t
12	Not knowing who you really are or what you want out of life?	2022-07-15 19:10:55.09782	t
13	Drinking at least 4 drinks of any kind of alcohol in a single day?	2022-07-15 19:10:55.09782	t
14	I felt worthless.	2022-07-15 19:10:55.09782	t
15	I felt that I had nothing to look forward to.	2022-07-15 19:10:55.09782	t
16	I felt helpless.	2022-07-15 19:10:55.09782	t
17	I felt sad.	2022-07-15 19:10:55.09782	t
18	I felt like a failure.	2022-07-15 19:10:55.09782	t
19	I felt depressed.	2022-07-15 19:10:55.09782	t
20	I felt unhappy.	2022-07-15 19:10:55.09782	t
21	I felt hopeless.	2022-07-15 19:10:55.09782	t
22	I was irritated more than people knew.	2022-07-15 19:10:55.09782	t
23	I felt angry.	2022-07-15 19:10:55.09782	t
24	I felt like I was ready to explode.	2022-07-15 19:10:55.09782	t
25	I was grouchy.	2022-07-15 19:10:55.09782	t
26	I felt annoyed.	2022-07-15 19:10:55.09782	t
27	Adding a new question	2022-08-14 02:05:27.870824	f
31	People would describe me as reckless.	2022-08-25 21:22:38.507791	t
32	I feel like I act totally on impulse.	2022-08-25 21:22:38.507791	t
29	Adding New Question 2	2022-08-14 14:20:52.288597	t
30	Adding question 3	2022-08-14 16:19:24.373003	t
37	My thoughts often don’t make sense to others.	2022-08-25 21:22:38.507791	t
33	Even though I know better, I can’t stop making rash decisions.	2022-08-25 21:22:38.507791	t
35	Others see me as irresponsible.	2022-08-25 21:22:38.507791	t
66	On average, how much time is occupied by these thoughts or behaviors each day?	2022-08-25 21:47:13.441794	t
67	How much distress do these thoughts or behaviors cause you?	2022-08-25 21:47:13.441794	t
68	How hard is it for you to control these thoughts or behaviors?	2022-08-25 21:47:13.441794	t
69	How much do these thoughts or behaviors cause you to avoid doing anything, going anyplace, or being with anyone?	2022-08-25 21:47:13.441794	t
70	How much do these thoughts or behaviors interfere with school, work, or your social or family life?	2022-08-25 21:47:13.441794	t
56	Painkillers (like Vicodin)	2022-08-25 21:40:01.803492	t
57	Stimulants (like Ritalin, Adderall)	2022-08-25 21:40:01.803492	t
59	Marijuana	2022-08-25 21:40:01.803492	t
34	I often feel like nothing I do really matters.	2022-08-25 21:22:38.507791	t
60	Cocaine or crack	2022-08-25 21:40:01.803492	t
36	I’m not good at planning ahead.	2022-08-25 21:22:38.507791	t
61	Club drugs (like ecstasy)	2022-08-25 21:40:01.803492	t
38	I worry about almost everything.	2022-08-25 21:22:38.507791	t
39	I get emotional easily, often for very little reason.	2022-08-25 21:22:38.507791	t
40	I fear being alone in life more than anything else.	2022-08-25 21:22:38.507791	t
41	I get stuck on one way of doing things, even when it’s clear it won’t work.	2022-08-25 21:22:38.507791	t
42	I have seen things that weren’t really there.	2022-08-25 21:22:38.507791	t
43	I steer clear of romantic relationships.	2022-08-25 21:22:38.507791	t
44	I’m not interested in making friends.	2022-08-25 21:22:38.507791	t
45	I get irritated easily by all sorts of things.	2022-08-25 21:22:38.507791	t
46	I don’t like to get too close to people.	2022-08-25 21:22:38.507791	t
47	It’s no big deal if I hurt other peoples’ feelings.	2022-08-25 21:22:38.507791	t
48	I rarely get enthusiastic about anything.	2022-08-25 21:22:38.507791	t
49	I crave attention.	2022-08-25 21:22:38.507791	t
50	I often have to deal with people who are less important than me.	2022-08-25 21:22:38.507791	t
51	I often have thoughts that make sense to me but that other people say are strange.	2022-08-25 21:22:38.507791	t
52	I use people to get what I want.	2022-08-25 21:22:38.507791	t
53	I often “zone out” and then suddenly come to and realize that a lot of time has passed.	2022-08-25 21:22:38.507791	t
54	Things around me often feel unreal, or more real than usual.	2022-08-25 21:22:38.507791	t
55	It is easy for me to take advantage of others.	2022-08-25 21:22:38.507791	t
58	Sedatives or  tranquilizers (like sleeping pills or Valium)	2022-08-25 21:40:01.803492	t
62	Hallucinogens (like LSD)	2022-08-25 21:40:01.803492	t
63	Heroin	2022-08-25 21:40:01.803492	t
64	Inhalants or solvents (like glue)	2022-08-25 21:40:01.803492	t
65	Methamphetamine (like speed)	2022-08-25 21:40:01.803492	t
71	My sleep was restless.	2022-08-25 21:54:18.035608	t
72	I had difficulty falling asleep.	2022-08-25 21:54:18.035608	t
73	I was satisfied with my sleep.	2022-08-25 21:56:30.721354	t
74	My sleep was refreshing.	2022-08-25 21:56:30.721354	t
75	I had trouble staying asleep.	2022-08-25 21:57:21.135114	t
76	I had trouble sleeping.	2022-08-25 21:57:21.135114	t
77	I got enough sleep.	2022-08-25 21:57:21.135114	t
79	Having “flashbacks,” that is, you suddenly acted or felt as if a stressful experience from the past was happening all over again 	2022-08-25 22:06:04.308044	t
80	Feeling very emotionally upset when something reminded you of a stressful experience?	2022-08-25 22:06:04.308044	t
81	Trying to avoid thoughts, feelings, or physical sensations that reminded you of a stressful experience?	2022-08-25 22:06:04.308044	t
82	Thinking that a stressful event happened because you or someone else (who didn’t directly harm you) did something wrong or didn’t do everything possible to prevent it, or because of something about you?	2022-08-25 22:06:04.308044	t
83	Having a very negative emotional state (for example, you were experiencing lots of fear, anger, guilt, shame, or horror) after a stressful experience?	2022-08-25 22:06:04.308044	t
84	Losing interest in activities you used to enjoy before having a stressful experience?	2022-08-25 22:06:04.308044	t
85	Being “super alert,” on guard, or constantly on the lookout for danger?	2022-08-25 22:06:04.308044	t
86	Feeling jumpy or easily startled when you hear an unexpected noise?	2022-08-25 22:06:04.308044	t
87	Being extremely irritable or angry to the point where you yelled at other people, got into fights, or destroyed things?	2022-08-25 22:06:04.308044	t
88	High in the halls of the kings	2022-08-27 06:19:13.786291	t
\.


--
-- Data for Name: review_board_member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review_board_member (board_member_id, joined_as_board_member) FROM stdin;
1705044	2022-08-14 02:23:21
1705062	2022-08-26 23:55:38
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name) FROM stdin;
\.


--
-- Data for Name: test_question; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_question (test_id, question_id, is_approved, pending_delete, delete_reasoning) FROM stdin;
1	1	t	f	\N
1	2	t	f	\N
1	3	t	f	\N
1	4	t	f	\N
1	5	t	f	\N
1	6	t	f	\N
1	7	t	f	\N
1	8	t	f	\N
1	9	t	f	\N
1	10	t	f	\N
1	11	t	f	\N
1	12	t	f	\N
1	13	t	f	\N
2	15	t	f	\N
2	16	t	f	\N
2	17	t	f	\N
2	18	t	f	\N
2	19	t	f	\N
2	20	t	f	\N
2	21	t	f	\N
3	22	t	f	\N
3	23	t	f	\N
3	25	f	f	\N
3	24	t	t	\N
4548	33	t	f	\N
4548	34	t	f	\N
4548	35	t	f	\N
4548	36	t	f	\N
4548	37	t	f	\N
4548	38	t	f	\N
4548	39	t	f	\N
4548	40	t	f	\N
4548	41	t	f	\N
4548	42	t	f	\N
4548	43	t	f	\N
4548	44	t	f	\N
4548	45	t	f	\N
4548	46	t	f	\N
4548	47	t	f	\N
4548	48	t	f	\N
4548	49	t	f	\N
4548	50	t	f	\N
4548	51	t	f	\N
4548	52	t	f	\N
4548	53	t	f	\N
4548	54	t	f	\N
4548	55	t	f	\N
4	56	t	f	\N
4	57	t	f	\N
4	58	t	f	\N
4	59	t	f	\N
4	60	t	f	\N
4	61	t	f	\N
4	62	t	f	\N
4	63	t	f	\N
4	64	t	f	\N
4	65	t	f	\N
5	66	t	f	\N
5	67	t	f	\N
5	68	t	f	\N
5	69	t	f	\N
5	70	t	f	\N
4	71	t	f	\N
6	72	t	f	\N
6	73	t	f	\N
6	74	t	f	\N
6	75	t	f	\N
6	76	t	f	\N
6	77	t	f	\N
7	79	t	f	\N
7	80	t	f	\N
7	81	t	f	\N
7	82	t	f	\N
7	83	t	f	\N
7	84	t	f	\N
7	85	t	f	\N
7	86	t	f	\N
7	87	t	f	\N
2	29	t	f	sdehg reugheriugheiur hguerh
2	88	t	f	\N
\.


--
-- Data for Name: test_result_disease; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_result_disease (test_result_id, disease_id) FROM stdin;
78	3
81	4
5	9
76	1
76	9
84	7
97	3
97	4
97	5
97	8
97	9
98	6
98	4
99	4
99	2
100	1
100	4
101	9
101	2
102	9
102	4
103	8
103	4
104	3
104	2
105	7
105	3
106	2
106	7
107	1
107	9
108	9
108	3
109	1
109	7
110	6
110	8
111	7
111	9
112	2
112	9
113	8
113	5
114	9
114	8
115	5
115	3
116	6
116	1
117	2
117	1
118	8
118	6
119	3
119	7
120	5
120	9
121	9
121	1
122	2
122	6
123	1
123	4
124	6
124	9
125	8
125	2
126	6
126	2
127	7
127	8
128	5
128	8
129	3
129	4
130	9
130	4
131	6
131	3
132	6
132	4
133	6
133	5
134	2
134	8
135	1
135	7
136	8
136	3
137	9
137	5
138	4
138	2
139	7
139	2
140	2
140	5
141	9
141	1
142	6
142	5
143	1
143	7
144	7
144	8
145	5
145	1
146	7
146	4
147	3
147	8
148	8
148	3
149	4
149	5
150	3
150	8
151	1
151	5
152	1
152	3
153	3
153	2
154	9
154	8
155	9
155	4
156	4
156	9
157	4
157	5
158	2
158	8
159	9
159	1
160	7
160	4
161	8
161	3
162	6
162	5
163	4
163	3
164	4
164	7
165	9
165	6
166	1
166	5
167	7
167	6
168	5
168	7
169	6
169	3
170	9
170	7
171	7
171	2
172	7
172	6
173	7
173	9
174	6
174	7
175	1
175	3
176	2
176	7
177	1
177	7
178	3
178	8
179	6
179	1
180	1
180	8
181	9
181	3
182	3
182	7
183	2
183	4
184	5
184	4
185	7
185	6
186	3
186	8
187	6
187	1
188	8
188	7
189	3
189	7
190	4
190	3
191	8
191	4
192	5
192	4
193	2
193	1
194	7
194	2
195	3
195	2
196	9
196	8
197	9
197	5
198	7
198	4
199	1
199	3
200	8
200	5
201	5
201	2
202	7
202	5
203	5
203	9
204	3
204	7
205	1
205	4
206	8
206	9
207	8
207	2
208	7
208	4
209	4
209	5
210	3
210	9
211	6
211	4
212	8
212	3
213	9
213	1
214	6
214	5
215	1
215	3
216	9
216	4
217	6
217	7
218	9
218	4
219	3
219	4
220	7
220	6
221	8
221	7
222	3
222	6
223	2
223	6
224	7
224	2
225	5
225	7
226	9
226	6
227	9
227	1
228	4
228	1
229	8
229	3
230	9
230	2
231	4
231	6
232	7
232	6
233	9
233	1
234	4
234	3
235	4
235	6
236	3
236	2
237	2
237	9
238	9
238	6
239	5
239	4
240	4
240	8
241	4
241	6
242	5
242	9
243	3
243	8
244	1
244	2
245	9
245	8
246	1
246	9
247	2
247	8
248	6
248	1
249	3
249	4
250	4
250	9
251	7
251	5
252	1
252	3
253	9
253	7
254	3
254	9
255	7
255	2
256	6
256	7
257	9
257	3
258	4
258	8
259	3
259	5
260	2
260	4
261	8
261	9
262	8
262	6
263	4
263	5
264	8
264	4
265	6
265	2
266	7
266	5
267	3
267	6
268	9
268	7
269	1
269	3
270	2
270	9
271	8
271	3
272	8
272	4
273	7
273	8
274	5
274	4
275	8
275	3
276	2
276	8
277	9
277	3
278	6
278	4
279	4
279	3
280	2
280	4
281	6
281	1
282	4
282	1
283	7
283	3
284	7
284	5
285	3
285	6
286	6
286	9
287	1
287	2
288	4
288	6
289	7
289	3
290	1
290	8
291	6
291	8
292	8
292	6
293	2
293	7
294	5
294	7
295	5
295	4
296	6
296	7
297	9
297	8
298	2
298	7
299	3
299	6
300	6
300	7
301	7
301	3
302	4
302	8
303	6
303	2
304	3
304	7
305	5
305	7
306	7
306	5
307	1
307	4
308	4
308	6
309	8
309	5
310	2
310	1
311	5
311	9
312	5
312	6
313	5
313	7
314	6
314	4
315	8
315	7
316	6
316	3
317	2
317	5
318	5
318	9
319	8
319	4
320	1
320	3
321	2
321	5
322	8
322	6
323	6
323	5
324	4
324	8
325	8
325	3
326	3
326	2
327	3
327	4
328	4
328	9
329	6
329	2
330	7
330	5
331	9
331	6
332	8
332	7
333	1
333	7
334	4
334	9
335	9
335	6
336	3
336	4
337	6
337	8
338	9
338	3
339	4
339	1
340	6
340	5
341	3
341	2
342	9
342	4
343	3
343	7
344	5
344	7
345	9
345	1
346	6
346	8
347	4
347	1
348	6
348	7
349	8
349	2
350	9
350	7
351	8
351	3
352	6
352	8
353	9
353	6
354	9
354	1
355	1
355	9
356	8
356	9
357	8
357	6
358	3
358	2
359	6
359	1
360	9
360	5
361	4
361	3
362	5
362	2
363	5
363	3
364	4
364	7
365	9
365	6
366	8
366	6
367	4
367	1
368	5
368	6
369	6
369	5
370	3
370	7
371	8
371	9
372	8
372	7
373	1
373	2
374	5
374	7
375	8
375	1
376	6
376	1
377	8
377	3
378	4
378	5
379	2
379	3
380	5
380	3
381	8
381	7
382	4
382	2
383	8
383	4
384	6
384	1
385	4
385	8
386	3
386	1
387	7
387	9
388	5
388	4
389	3
389	2
390	5
390	6
391	2
391	5
392	7
392	2
393	1
393	5
394	6
394	8
395	5
395	8
396	5
396	2
397	4
397	9
398	8
398	7
399	9
399	5
400	7
400	8
401	2
401	6
402	2
402	9
403	9
403	6
404	1
404	8
405	9
405	7
406	7
406	2
407	8
407	9
408	1
408	3
409	8
409	7
410	9
410	8
411	2
411	3
412	3
412	4
413	5
413	7
414	5
414	9
415	6
415	2
416	8
416	4
417	7
417	8
418	3
418	5
419	4
419	3
420	9
420	8
421	6
421	4
422	7
422	1
423	3
423	8
424	6
424	9
425	8
425	7
426	4
426	9
427	2
427	6
428	1
428	5
429	3
429	5
430	6
430	5
431	7
431	4
432	1
432	3
433	9
433	6
434	3
434	2
435	7
435	6
436	9
436	7
437	3
437	8
438	8
438	7
439	4
439	2
440	2
440	6
441	8
441	4
442	7
442	8
443	1
443	2
444	3
444	2
445	5
445	7
446	4
446	8
447	1
447	5
448	8
448	3
449	4
449	6
450	7
450	4
451	9
451	4
452	3
452	1
453	6
453	7
454	8
454	4
455	4
455	7
456	2
456	4
457	4
457	8
458	4
458	6
459	4
459	8
460	3
460	8
461	9
461	7
462	9
462	3
463	4
463	3
464	3
464	8
465	9
465	1
466	2
466	6
467	7
467	5
468	9
468	2
469	3
469	8
470	8
470	4
471	9
471	2
472	1
472	3
473	9
473	3
474	4
474	3
475	2
475	3
476	4
476	9
477	6
477	8
478	4
478	6
479	2
479	1
480	9
480	4
481	7
481	2
482	7
482	2
483	8
483	2
484	4
484	8
485	7
485	5
486	4
486	2
487	6
487	5
488	6
488	1
489	1
489	5
490	3
490	8
491	8
491	5
492	5
492	3
493	3
493	6
494	4
494	7
495	9
495	4
496	5
496	8
497	3
497	7
498	8
498	2
499	8
499	7
500	5
500	1
501	7
501	5
502	9
502	2
503	9
503	3
504	2
504	6
505	1
505	4
506	6
506	4
507	7
507	8
508	7
508	1
509	6
509	7
510	1
510	2
511	9
511	4
512	7
512	1
513	7
513	5
514	7
514	6
515	3
515	2
516	6
516	3
517	6
517	5
518	3
518	5
519	9
519	7
520	9
520	6
521	1
521	2
522	2
522	4
523	9
523	3
524	1
524	8
525	2
525	3
526	9
526	4
527	9
527	3
528	9
528	5
529	1
529	3
530	3
530	8
531	5
531	2
532	9
532	4
533	5
533	8
534	7
534	6
535	3
535	5
536	5
536	1
537	1
537	7
538	9
538	2
539	2
539	9
540	9
540	8
541	9
541	6
542	7
542	9
543	9
543	3
544	1
544	6
545	9
545	4
546	5
546	7
547	8
547	3
548	1
548	6
549	1
549	6
550	2
550	4
551	2
551	6
552	3
552	4
553	8
553	9
554	1
554	9
555	7
555	9
556	3
556	4
557	3
557	1
558	4
558	9
559	4
559	8
560	2
560	5
561	4
561	1
562	1
562	3
563	8
563	5
564	1
564	2
565	3
565	5
566	1
566	2
567	3
567	6
568	6
568	5
569	3
569	6
570	1
570	8
571	3
571	5
572	5
572	1
573	1
573	4
574	8
574	7
575	5
575	1
576	8
576	5
577	2
577	6
578	6
578	5
579	7
579	4
580	4
580	8
581	4
581	5
582	8
582	7
583	2
583	4
584	5
584	3
585	6
585	1
586	6
586	3
587	7
587	2
588	9
588	8
589	5
589	2
590	2
590	6
591	4
591	3
592	5
592	3
593	6
593	8
594	5
594	1
595	3
595	2
596	2
596	7
597	5
597	2
598	7
598	9
599	1
599	9
600	6
600	5
601	4
601	6
602	2
602	6
603	7
603	6
604	3
604	9
605	4
605	8
606	1
606	8
607	3
607	2
608	3
608	5
609	9
609	4
610	6
610	7
611	7
611	5
612	1
612	9
613	2
613	5
614	3
614	9
615	2
615	3
616	6
616	2
617	5
617	7
618	6
618	5
619	7
619	4
620	6
620	8
621	5
621	1
622	6
622	5
623	8
623	4
624	2
624	9
625	5
625	1
626	7
626	6
627	2
627	5
628	4
628	1
629	1
629	7
630	1
630	3
631	5
631	9
632	6
632	5
633	4
633	8
634	3
634	6
635	7
635	3
636	6
636	7
637	3
637	6
638	7
638	4
639	8
639	3
640	4
640	9
641	8
641	1
642	1
642	9
643	4
643	1
644	3
644	1
645	2
645	6
646	8
646	1
647	7
647	3
648	6
648	2
649	9
649	5
650	2
650	1
651	2
651	7
652	2
652	5
653	9
653	8
654	5
654	9
655	2
655	7
656	3
656	1
657	7
657	4
658	7
658	9
659	3
659	5
660	6
660	3
661	6
661	7
662	1
662	4
663	2
663	4
664	1
664	3
665	1
665	3
666	7
666	5
667	5
667	6
668	4
668	3
669	4
669	2
670	9
670	2
671	2
671	7
672	8
672	2
673	7
673	9
674	5
674	3
675	8
675	9
676	8
676	9
677	4
677	5
678	1
678	6
679	8
679	5
680	2
680	4
681	6
681	2
682	4
682	2
683	9
683	7
684	3
684	5
685	5
685	3
686	5
686	7
687	7
687	6
688	1
688	3
689	9
689	5
690	5
690	7
691	3
691	1
692	3
692	9
693	2
693	9
694	8
694	1
695	6
695	3
696	2
696	6
697	8
697	5
698	3
698	4
699	6
699	7
700	9
700	4
701	7
701	1
702	9
702	6
703	7
703	2
704	9
704	3
705	7
705	8
706	7
706	3
707	8
707	6
708	4
708	3
709	3
709	8
710	6
710	5
711	3
711	9
712	3
712	9
713	4
713	9
714	9
714	3
715	4
715	1
716	1
716	2
717	9
717	3
718	4
718	2
719	1
719	2
720	3
720	6
721	8
721	4
722	5
722	6
723	6
723	9
724	4
724	8
725	9
725	2
726	8
726	7
727	4
727	2
728	7
728	2
729	5
729	9
730	9
730	1
731	3
731	6
732	6
732	5
733	5
733	8
734	3
734	9
735	7
735	1
736	4
736	3
737	6
737	5
738	2
738	9
739	5
739	7
740	9
740	4
741	4
741	9
742	3
742	9
743	8
743	1
744	6
744	4
745	4
745	2
746	7
746	6
747	6
747	2
748	3
748	2
749	6
749	8
750	8
750	1
751	1
751	8
752	2
752	9
753	7
753	9
754	6
754	3
755	1
755	5
756	4
756	7
757	1
757	5
758	2
758	9
759	6
759	8
760	3
760	1
761	5
761	2
762	2
762	4
763	4
763	2
764	2
764	6
765	1
765	8
766	7
766	4
767	2
767	6
768	4
768	7
769	9
769	8
770	7
770	9
771	4
771	3
772	2
772	5
773	7
773	6
774	8
774	5
775	8
775	9
776	6
776	2
777	9
777	4
778	9
778	8
779	2
779	8
780	3
780	7
781	6
781	2
782	4
782	5
783	3
783	2
784	1
784	9
785	4
785	2
786	2
786	3
787	3
787	9
788	8
788	4
789	7
789	9
790	1
790	4
791	6
791	8
792	6
792	7
793	7
793	4
794	2
794	1
795	5
795	7
796	8
796	6
797	2
797	3
798	3
798	5
799	2
799	3
800	7
800	6
801	3
801	4
802	7
802	6
803	9
803	3
804	7
804	2
805	6
805	7
806	5
806	2
807	4
807	7
808	1
808	6
809	7
809	5
810	8
810	1
811	9
811	1
812	1
812	5
813	4
813	6
814	3
814	4
815	1
815	8
816	5
816	8
817	3
817	5
818	6
818	3
819	5
819	9
820	6
820	9
821	1
821	4
822	4
822	8
823	8
823	5
824	8
824	5
825	1
825	3
826	1
826	3
827	6
827	1
828	3
828	7
829	6
829	1
830	4
830	6
831	6
831	8
832	2
832	4
833	6
833	5
834	4
834	1
835	2
835	1
836	6
836	8
837	5
837	1
838	1
838	7
839	3
839	8
840	6
840	4
841	9
841	8
842	7
842	2
843	9
843	1
844	2
844	9
845	3
845	1
846	7
846	6
847	2
847	9
848	8
848	7
849	8
849	9
850	8
850	3
851	1
851	7
852	7
852	8
853	9
853	8
854	2
854	8
855	6
855	4
856	1
856	2
857	4
857	8
858	3
858	5
859	2
859	9
860	3
860	4
861	9
861	8
862	7
862	1
863	6
863	4
864	5
864	2
865	7
865	8
866	6
866	5
867	4
867	9
868	5
868	8
869	5
869	9
870	4
870	7
871	3
871	4
872	5
872	2
873	4
873	7
874	1
874	3
875	6
875	4
876	3
876	2
877	1
877	7
878	6
878	5
879	1
879	3
880	7
880	5
881	4
881	8
882	2
882	1
883	7
883	2
884	7
884	4
885	4
885	2
886	2
886	4
887	4
887	5
888	4
888	6
889	4
889	1
890	9
890	6
891	8
891	9
892	3
892	8
893	7
893	6
894	5
894	8
895	7
895	9
896	8
896	5
897	2
897	1
898	6
898	1
899	4
899	3
900	3
900	9
901	5
901	7
902	9
902	7
903	6
903	3
904	5
904	6
905	4
905	5
906	1
906	5
907	6
907	1
908	6
908	7
909	8
909	7
910	1
910	7
911	4
911	7
912	6
912	3
913	6
913	7
914	5
914	6
915	3
915	4
916	1
916	2
917	4
917	5
918	4
918	6
919	3
919	9
920	8
920	5
921	6
921	4
922	9
922	2
923	3
923	1
924	5
924	1
925	5
925	7
926	7
926	3
927	5
927	8
928	5
928	2
929	7
929	1
930	2
930	6
931	1
931	7
932	8
932	4
933	2
933	1
934	4
934	2
935	6
935	3
936	1
936	7
937	2
937	4
938	4
938	9
939	7
939	6
940	2
940	6
941	3
941	5
942	7
942	6
943	2
943	8
944	2
944	1
945	1
945	3
946	3
946	4
947	5
947	3
948	4
948	5
949	5
949	2
950	4
950	1
951	2
951	6
952	7
952	1
953	5
953	6
954	9
954	5
955	2
955	9
956	5
956	3
957	3
957	8
958	4
958	3
959	4
959	2
960	4
960	1
961	1
961	4
962	5
962	7
963	9
963	1
964	5
964	3
965	1
965	3
966	2
966	6
967	3
967	9
968	6
968	7
969	2
969	5
970	4
970	9
971	7
971	4
972	3
972	2
973	5
973	8
974	1
974	3
975	2
975	8
976	6
976	9
977	8
977	4
978	8
978	3
979	4
979	8
980	9
980	3
981	5
981	8
982	3
982	6
983	3
983	4
984	1
984	2
985	9
985	3
986	7
986	2
987	9
987	4
988	4
988	6
989	8
989	6
990	9
990	7
991	7
991	4
992	1
992	5
993	2
993	9
994	4
994	8
995	8
995	9
996	2
996	1
997	8
997	3
998	2
998	3
999	5
999	4
1000	7
1000	6
1001	4
1001	9
1002	7
1002	2
1003	2
1003	8
1004	5
1004	6
1005	3
1005	1
1006	6
1006	4
1007	3
1007	7
1008	2
1008	5
1009	7
1009	1
1010	3
1010	2
1011	1
1011	9
1012	4
1012	2
1013	4
1013	7
1014	6
1014	4
1015	1
1015	7
1016	2
1016	4
1017	7
1017	4
1018	8
1018	7
1019	4
1019	3
1020	7
1020	6
1021	8
1021	1
1022	2
1022	8
1023	9
1023	2
1024	1
1024	9
1025	3
1025	7
1026	3
1026	4
1027	2
1027	7
1028	1
1028	4
1029	9
1029	3
1030	3
1030	9
1031	3
1031	5
1032	8
1032	1
1033	8
1033	6
1034	5
1034	1
1035	2
1035	6
1036	3
1036	9
1037	4
1037	7
1038	6
1038	4
1039	9
1039	5
1040	5
1040	3
1041	7
1041	6
1042	9
1042	2
1043	8
1043	6
1044	2
1044	7
1045	6
1045	9
1046	7
1046	1
1047	8
1047	4
1048	6
1048	5
1049	7
1049	6
1050	3
1050	5
1051	6
1051	5
1052	6
1052	5
1053	3
1053	6
1054	1
1054	5
1055	6
1055	3
1056	8
1056	3
1057	3
1057	8
1058	5
1058	3
1059	9
1059	2
1060	3
1060	2
1061	7
1061	3
1062	4
1062	6
1063	7
1063	5
1064	2
1064	4
1065	7
1065	4
1066	6
1066	4
1067	4
1067	7
1068	3
1068	8
1069	5
1069	4
1070	8
1070	2
1071	7
1071	4
1072	5
1072	2
1073	2
1073	7
1074	8
1074	7
1075	1
1075	9
1076	3
1076	8
1077	1
1077	7
1078	5
1078	6
1079	8
1079	9
1080	5
1080	7
1081	6
1081	1
1082	6
1082	9
1083	3
1083	8
1084	4
1084	6
1085	7
1085	5
1086	9
1086	5
1087	6
1087	9
1088	6
1088	9
1089	6
1089	7
1090	3
1090	9
1091	3
1091	1
1092	7
1092	6
1093	6
1093	9
1094	6
1094	9
1095	2
1095	5
1096	1
1096	4
1098	7
\.


--
-- Data for Name: test_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_results (test_result_id, test_id, patient_id, submitted_at, verifier_id, verified_at, machine_report, manual_report, score) FROM stdin;
135	3	1705016	2022-08-01 16:34:13	1705045	2022-08-07 02:02:50	\N	\N	0
136	3	3	2022-08-17 22:08:32	1705060	2022-08-06 03:46:28	\N	\N	0
54	2	1705008	2022-11-07 00:44:28	1705044	2022-08-12 09:08:53.582935	\N	ygy	19
71	2	1705008	2022-11-07 00:44:28	1705044	2022-08-12 09:08:53.582935	\N	ygy	19
84	3	1705002	2022-08-27 00:18:21	1705045	2022-08-27 19:50:45.523654	\N	Be less angry	17
7	2	1705008	2022-02-01 02:00:00	1705044	2022-08-12 09:08:53.582935	\N	ygy	12
38	2	1705008	2022-12-07 00:44:28	1705044	2022-08-12 09:08:53.582935	\N	ygy	19
6	2	1705008	2022-02-01 01:00:00	1705044	2022-08-12 09:08:53.582935	\N	ygy	12
137	3	4	2022-08-19 12:44:21	1705045	2022-08-22 01:57:35	\N	\N	0
138	2	1705015	2022-08-09 16:52:29	1705044	2022-08-08 22:46:06	\N	\N	0
72	2	1705008	2022-11-07 00:44:28	1705044	2022-08-12 09:08:53.582935	\N	ygy	19
19	2	1705008	2022-02-01 05:00:00	1705044	2022-08-12 09:08:53.582935	\N	ygy	12
36	2	1705008	2022-07-17 00:44:28	1705044	2022-08-12 09:08:53.582935	\N	ygy	19
21	2	1705008	2022-02-01 05:00:00	1705044	2022-08-12 09:08:53.582935	\N	ygy	12
17	2	1705008	2022-02-01 04:00:00	1705044	2022-08-12 09:08:53.582935	\N	ygy	12
22	2	1705008	2022-02-01 05:00:00	1705044	2022-08-12 09:08:53.582935	\N	ygy	12
20	2	1705008	2022-02-01 05:00:00	1705044	2022-08-12 09:08:53.582935	\N	ygy	12
18	2	1705008	2022-02-01 04:00:00	1705044	2022-08-12 09:08:53.582935	\N	ygy	12
16	2	1705008	2022-02-01 04:00:00	1705044	2022-08-12 09:08:53.582935	\N	ygy	12
139	3	5	2022-08-20 08:54:21	1705062	2022-08-19 00:23:05	\N	\N	0
140	2	1705001	2022-08-05 13:44:00	1705060	2022-08-03 17:14:25	\N	\N	0
4	2	1705016	2022-01-01 01:00:00	\N	\N	\N	\N	19
143	2	1705016	2022-08-08 00:08:42	1705044	2022-08-17 19:28:29	\N	\N	0
144	3	4	2022-08-11 22:16:10	1705045	2022-08-13 07:40:57	\N	\N	0
145	1	1705016	2022-08-23 09:02:10	1705044	2022-08-21 00:37:36	\N	\N	0
146	3	1705015	2022-08-20 10:00:06	1705045	2022-08-18 00:28:26	\N	\N	0
147	3	1705017	2022-08-17 22:38:00	1705060	2022-08-07 23:39:30	\N	\N	0
148	1	6	2022-08-17 11:19:58	1705062	2022-08-08 13:52:45	\N	\N	0
149	2	1705016	2022-08-04 00:24:21	1705062	2022-08-16 10:15:20	\N	\N	0
83	3	1705005	2022-08-27 00:13:56	\N	\N	\N	\N	12
152	2	1705001	2022-08-22 16:52:04	1705060	2022-08-01 16:23:57	\N	\N	0
153	2	1705010	2022-08-12 14:16:32	1705045	2022-08-15 06:10:29	\N	\N	0
154	1	1705044	2022-08-10 04:13:46	1705062	2022-08-06 07:51:58	\N	\N	0
5	2	1705017	2022-02-01 01:00:00	1705044	2022-08-28 10:29:20.777213	\N	No problem	11
155	1	7	2022-08-02 15:37:48	1705044	2022-08-18 15:50:41	\N	\N	0
156	2	3	2022-08-09 23:07:12	1705044	2022-08-13 19:34:34	\N	\N	0
141	3	6	2022-08-14 11:47:10	1705045	2022-08-03 11:28:13	\N	\N	0
142	3	4	2022-08-22 16:17:28	1705045	2022-08-04 01:39:21	\N	\N	0
151	3	6	2022-08-13 17:55:55	1705045	2022-08-10 14:06:29	\N	\N	0
104	1	3	2022-08-13 21:38:36	1705045	2022-08-24 22:46:22	\N	\N	0
157	2	1705044	2022-08-20 00:59:31	1705062	2022-08-18 21:38:21	\N	\N	0
97	4	1705010	2022-08-27 22:07:09	1705045	2022-08-27 22:07:47.687865	\N	Hey.. Be better. 	2
98	1	1705017	2022-08-10 16:25:05	1705044	2022-08-05 09:22:41	\N	\N	0
99	3	1705001	2022-08-05 10:44:41	1705045	2022-08-13 08:44:37	\N	\N	0
86	3	1705005	2022-08-27 00:21:01	1705045	2022-08-27 19:48:50.265083	\N	Good enough	4
101	2	1705016	2022-08-14 21:41:57	1705044	2022-08-20 05:47:30	\N	\N	0
102	3	5	2022-08-15 14:03:54	1705044	2022-08-24 07:25:02	\N	\N	0
105	2	1705008	2022-08-18 02:11:17	1705045	2022-08-05 20:36:09	\N	\N	0
106	1	1705001	2022-08-20 12:54:04	1705045	2022-08-22 15:33:06	\N	\N	0
107	2	5	2022-08-10 15:19:10	1705045	2022-08-08 13:45:17	\N	\N	0
108	2	1705015	2022-08-14 10:34:00	1705045	2022-08-05 13:30:06	\N	\N	0
109	1	1705008	2022-08-16 02:14:45	1705062	2022-08-14 08:05:27	\N	\N	0
110	1	1705015	2022-08-20 03:23:32	1705062	2022-08-07 21:30:31	\N	\N	0
95	3	1705005	2022-08-27 22:01:44	\N	\N	\N	\N	0
112	1	1705044	2022-08-07 07:33:20	1705060	2022-08-14 00:01:35	\N	\N	0
113	2	1705008	2022-08-24 09:07:19	1705044	2022-08-12 21:14:02	\N	\N	0
115	3	1705016	2022-08-19 06:12:46	1705060	2022-08-17 00:52:54	\N	\N	0
116	3	1705008	2022-08-21 15:37:44	1705045	2022-08-10 12:15:44	\N	\N	0
117	3	5	2022-08-14 02:43:11	1705045	2022-08-14 03:05:22	\N	\N	0
118	3	1705001	2022-08-09 12:19:46	1705060	2022-08-12 03:37:45	\N	\N	0
169	1	1705005	2022-08-18 09:19:57	1705045	2022-08-06 06:15:00	\N	\N	0
122	3	3	2022-08-04 20:07:01	1705045	2022-08-06 08:09:15	\N	\N	0
124	3	1705001	2022-08-04 16:56:40	1705044	2022-08-01 23:03:59	\N	\N	0
171	1	1705005	2022-08-18 07:46:07	1705045	2022-08-01 15:16:47	\N	\N	0
128	2	1705044	2022-08-16 19:23:36	1705062	2022-08-16 18:49:16	\N	\N	0
254	3	1705005	2022-08-14 09:17:08	1705044	2022-08-16 08:44:05	\N	\N	0
131	3	7	2022-08-10 14:24:36	1705060	2022-08-04 05:30:51	\N	\N	0
132	3	4	2022-08-13 06:29:39	1705062	2022-08-14 16:56:51	\N	\N	0
133	2	1705010	2022-08-02 13:04:00	1705045	2022-08-10 12:18:01	\N	\N	0
134	3	3	2022-08-08 01:19:33	1705060	2022-08-10 08:58:39	\N	\N	0
158	1	1705010	2022-08-21 15:33:01	1705060	2022-08-17 23:55:27	\N	\N	0
159	1	1705010	2022-08-18 04:50:41	1705045	2022-08-07 14:56:57	\N	\N	0
211	2	1705005	2022-08-20 00:46:15	1705045	2022-08-04 21:35:12	\N	\N	0
225	2	1705005	2022-08-21 16:53:44	1705045	2022-08-15 10:15:27	\N	\N	0
390	2	1705005	2022-08-21 01:26:31	1705062	2022-08-23 16:05:18	\N	\N	0
163	1	6	2022-08-24 03:49:46	1705060	2022-08-17 08:12:21	\N	\N	0
164	1	1705001	2022-08-10 19:35:19	1705044	2022-08-04 22:53:18	\N	\N	0
439	1	1705005	2022-08-19 14:41:58	1705062	2022-08-11 09:18:46	\N	\N	0
166	2	1705044	2022-08-05 05:59:06	1705045	2022-08-16 06:07:35	\N	\N	0
167	1	4	2022-08-16 11:32:49	1705060	2022-08-13 10:35:10	\N	\N	0
445	3	1705005	2022-08-07 23:58:12	1705062	2022-08-22 13:26:57	\N	\N	0
170	1	1705001	2022-08-21 10:53:50	1705045	2022-08-23 16:59:09	\N	\N	0
172	2	7	2022-08-16 05:20:48	1705060	2022-08-16 05:12:53	\N	\N	0
114	2	6	2022-08-23 20:54:52	1705045	2022-08-25 00:30:29	\N	\N	0
119	2	1705008	2022-08-04 08:00:41	1705045	2022-08-24 12:21:20	\N	\N	0
120	3	1705010	2022-08-21 07:38:42	1705045	2022-08-15 06:03:40	\N	\N	0
123	2	1705017	2022-08-08 12:45:15	1705045	2022-08-03 06:31:31	\N	\N	0
125	2	1705008	2022-08-17 00:50:06	1705045	2022-08-23 23:07:03	\N	\N	0
126	1	1705001	2022-08-06 03:23:38	1705045	2022-08-14 13:07:24	\N	\N	0
129	1	1705010	2022-08-14 00:41:36	1705045	2022-08-25 04:01:52	\N	\N	0
229	1	1705044	2022-08-18 08:14:20	1705060	2022-08-16 02:53:27	\N	\N	0
74	2	1705008	2022-11-07 00:44:28	1705044	2022-08-12 09:08:53.582935	\N	ygy	19
230	3	1705008	2022-08-19 04:22:26	1705062	2022-08-16 20:28:30	\N	\N	0
96	4	1705010	2022-08-27 22:06:02	1705045	2022-08-28 08:12:53.172128	\N	No. You are in good condition. 	0
231	1	5	2022-08-19 14:15:46	1705060	2022-08-20 22:12:49	\N	\N	0
80	2	1705005	2022-07-17 14:42:00	1705045	2022-08-12 09:22:57.466509	\N	ygny	8
234	2	1705015	2022-08-21 13:10:44	1705045	2022-08-20 07:33:17	\N	\N	0
235	1	7	2022-08-14 15:51:41	1705045	2022-08-23 04:55:58	\N	\N	0
236	1	5	2022-08-09 07:37:22	1705060	2022-08-09 15:58:51	\N	\N	0
237	3	3	2022-08-02 09:37:20	1705060	2022-08-02 18:45:06	\N	\N	0
238	1	1705044	2022-08-15 05:44:34	1705062	2022-08-23 00:31:45	\N	\N	0
240	3	1705017	2022-08-21 06:14:09	1705060	2022-08-21 03:07:09	\N	\N	0
79	3	1705005	2022-07-17 10:49:44	1705045	2022-08-12 09:22:57.466509	\N	ygny	8
75	2	1705008	2022-11-07 00:44:28	1705044	2022-08-12 09:08:53.582935	\N	ygy	19
73	2	1705008	2022-11-07 00:44:28	1705044	2022-08-12 09:08:53.582935	\N	ygy	19
243	2	1705008	2022-08-09 14:16:30	1705060	2022-08-08 12:08:15	\N	\N	0
239	1	1705010	2022-08-10 13:19:50	1705045	2022-08-23 23:57:36	\N	\N	0
242	2	4	2022-08-09 17:13:35	1705045	2022-08-19 19:41:21	\N	\N	0
184	3	3	2022-08-13 17:05:14	1705045	2022-08-24 01:47:48	\N	\N	0
202	3	1705017	2022-08-13 00:56:29	1705045	2022-08-23 22:30:02	\N	\N	0
173	3	1705015	2022-08-18 18:40:23	1705044	2022-08-12 06:40:48	\N	\N	0
85	2	1705005	2022-08-27 00:19:32	\N	\N	\N	\N	30
78	2	1705005	2022-07-17 10:15:16	1705044	2022-08-14 04:01:00.738665	\N	Hello, world!	15
176	3	3	2022-08-16 09:39:15	1705060	2022-08-06 00:27:41	\N	\N	0
177	1	1705017	2022-08-02 11:14:12	1705045	2022-08-17 04:58:32	\N	\N	0
178	1	1705044	2022-08-01 23:21:52	1705062	2022-08-13 04:06:54	\N	\N	0
179	1	1705044	2022-08-17 04:34:08	1705044	2022-08-15 04:29:59	\N	\N	0
180	3	1705044	2022-08-15 22:15:35	1705062	2022-08-14 11:07:55	\N	\N	0
181	2	3	2022-08-05 14:10:13	1705060	2022-08-19 18:24:30	\N	\N	0
81	2	1705005	2022-08-14 13:48:35	1705044	2022-08-14 13:49:46.48578	\N	ADHD exists	19
183	3	5	2022-08-15 17:10:37	1705045	2022-08-11 23:18:16	\N	\N	0
185	3	5	2022-08-15 02:04:07	1705045	2022-08-14 07:21:45	\N	\N	0
186	1	3	2022-08-15 03:31:42	1705062	2022-08-06 19:44:39	\N	\N	0
187	2	6	2022-08-06 08:26:14	1705045	2022-08-19 23:30:01	\N	\N	0
188	2	1705008	2022-08-07 17:28:02	1705062	2022-08-10 21:58:25	\N	\N	0
189	1	5	2022-08-17 16:30:40	1705044	2022-08-01 17:56:33	\N	\N	0
190	2	1705008	2022-08-13 01:48:34	1705044	2022-08-01 16:19:05	\N	\N	0
191	2	1705010	2022-08-11 01:16:55	1705044	2022-08-07 11:22:46	\N	\N	0
37	2	1705005	2022-07-17 00:45:52	\N	\N	\N		19
193	2	4	2022-08-12 12:58:05	1705062	2022-08-14 04:45:34	\N	\N	0
194	2	1705044	2022-08-16 12:22:39	1705060	2022-08-11 14:10:05	\N	\N	0
1	2	1705005	2022-07-15 21:29:35	1705045	2022-08-12 09:22:57.466509	\N	ygny	8
196	1	1705008	2022-08-21 00:33:53	1705062	2022-08-18 11:41:09	\N	\N	0
197	2	1705010	2022-08-10 13:39:30	1705045	2022-08-11 17:18:51	\N	\N	0
198	2	1705015	2022-08-18 12:06:52	1705062	2022-08-15 21:26:50	\N	\N	0
232	2	1705005	2022-08-06 11:53:24	1705045	2022-08-23 17:16:19	\N	\N	0
200	1	1705017	2022-08-11 03:30:11	1705044	2022-08-04 21:15:45	\N	\N	0
201	1	5	2022-08-14 00:02:30	1705060	2022-08-16 13:43:47	\N	\N	0
203	2	1705010	2022-08-07 02:45:48	1705045	2022-08-10 11:59:45	\N	\N	0
76	2	1705005	2022-07-17 03:29:27	1705045	2022-08-27 19:03:17.882452	\N	Not good	33
205	1	1705001	2022-08-07 19:28:03	1705062	2022-08-21 11:59:22	\N	\N	0
206	2	1705001	2022-08-07 20:59:59	1705044	2022-08-04 14:00:56	\N	\N	0
208	1	5	2022-08-18 01:21:36	1705045	2022-08-20 10:55:47	\N	\N	0
210	1	1705008	2022-08-23 20:24:50	1705060	2022-08-20 17:02:31	\N	\N	0
212	1	1705015	2022-08-13 10:29:17	1705044	2022-08-06 10:49:12	\N	\N	0
82	4	1705005	2022-08-27 00:05:46	1705045	2022-08-27 21:47:19.998226	\N	Good Boy	1
216	2	7	2022-08-17 10:58:07	1705060	2022-08-07 14:34:28	\N	\N	0
217	3	1705016	2022-08-12 13:05:32	1705045	2022-08-08 18:28:03	\N	\N	0
218	1	6	2022-08-24 14:26:26	1705060	2022-08-13 21:54:15	\N	\N	0
219	2	6	2022-08-16 03:12:01	1705045	2022-08-07 09:55:37	\N	\N	0
221	2	7	2022-08-05 05:33:19	1705062	2022-08-17 16:50:29	\N	\N	0
222	3	4	2022-08-03 18:15:22	1705044	2022-08-16 19:56:29	\N	\N	0
223	1	5	2022-08-02 11:07:41	1705062	2022-08-22 01:16:37	\N	\N	0
207	2	1705005	2022-08-04 12:05:21	1705060	2022-08-09 00:26:40	\N	\N	0
227	2	7	2022-08-06 12:34:15	1705045	2022-08-12 10:07:31	\N	\N	0
228	2	1705044	2022-08-23 11:16:24	1705062	2022-08-19 21:36:40	\N	\N	0
245	2	1705017	2022-08-16 19:21:28	1705060	2022-08-22 04:26:23	\N	\N	0
209	3	1705005	2022-08-03 20:54:08	1705044	2022-08-08 15:24:45	\N	\N	0
215	2	1705005	2022-08-09 13:09:46	1705060	2022-08-04 09:24:30	\N	\N	0
249	2	1705001	2022-08-18 01:24:19	1705062	2022-08-12 20:27:40	\N	\N	0
251	3	7	2022-08-03 00:55:18	1705045	2022-08-13 09:59:32	\N	\N	0
253	2	3	2022-08-07 00:51:20	1705044	2022-08-15 23:09:14	\N	\N	0
213	3	1705008	2022-08-22 12:04:34	1705045	2022-08-14 18:29:18	\N	\N	0
220	2	3	2022-08-02 06:59:22	1705045	2022-08-12 15:26:25	\N	\N	0
224	3	7	2022-08-06 06:49:37	1705045	2022-08-18 18:39:22	\N	\N	0
244	3	1705015	2022-08-18 11:00:35	1705045	2022-08-19 02:36:18	\N	\N	0
246	3	4	2022-08-04 16:33:16	1705045	2022-08-17 21:28:40	\N	\N	0
252	1	1705016	2022-08-14 09:59:25	1705045	2022-08-04 08:29:12	\N	\N	0
255	3	1705010	2022-08-21 01:22:10	1705045	2022-08-15 20:47:46	\N	\N	0
256	1	1705044	2022-08-10 20:48:09	1705044	2022-08-08 20:43:29	\N	\N	0
257	3	6	2022-08-15 09:31:05	1705044	2022-08-20 07:06:36	\N	\N	0
290	2	1705005	2022-08-04 02:59:51	1705062	2022-08-12 12:47:51	\N	\N	0
260	2	6	2022-08-19 17:11:05	1705045	2022-08-03 17:58:29	\N	\N	0
261	2	1705001	2022-08-07 00:35:39	1705060	2022-08-04 05:46:57	\N	\N	0
268	1	1705005	2022-08-17 14:55:44	1705045	2022-08-04 01:07:30	\N	\N	0
263	3	1705044	2022-08-01 16:59:51	1705044	2022-08-05 12:27:05	\N	\N	0
463	2	1705005	2022-08-24 23:04:10	1705062	2022-08-11 15:28:02	\N	\N	0
265	2	1705017	2022-08-09 11:53:17	1705062	2022-08-13 18:26:46	\N	\N	0
266	2	5	2022-08-20 01:06:55	1705062	2022-08-19 19:15:21	\N	\N	0
267	3	1705001	2022-08-13 00:07:05	1705062	2022-08-21 06:53:04	\N	\N	0
269	1	1705017	2022-08-18 03:47:48	1705045	2022-08-07 19:24:13	\N	\N	0
270	2	1705017	2022-08-21 18:24:00	1705060	2022-08-02 18:11:05	\N	\N	0
271	2	1705001	2022-08-08 23:29:22	1705044	2022-08-05 19:45:56	\N	\N	0
479	3	1705005	2022-08-16 03:40:01	1705062	2022-08-24 03:11:36	\N	\N	0
274	3	1705015	2022-08-07 12:23:56	1705044	2022-08-16 22:04:23	\N	\N	0
527	1	1705005	2022-08-21 16:30:25	1705062	2022-08-12 04:14:39	\N	\N	0
278	3	1705001	2022-08-18 06:59:28	1705044	2022-08-16 16:11:55	\N	\N	0
280	1	5	2022-08-12 03:05:22	1705045	2022-08-14 12:04:15	\N	\N	0
284	1	1705044	2022-08-02 00:23:50	1705060	2022-08-19 08:20:27	\N	\N	0
285	2	6	2022-08-12 11:09:27	1705044	2022-08-04 16:10:12	\N	\N	0
287	2	1705017	2022-08-08 04:38:52	1705045	2022-08-21 21:31:02	\N	\N	0
288	2	4	2022-08-11 05:20:47	1705044	2022-08-12 04:06:55	\N	\N	0
291	3	1705017	2022-08-18 19:04:37	1705062	2022-08-19 05:35:28	\N	\N	0
292	2	1705015	2022-08-02 12:39:07	1705062	2022-08-17 14:38:57	\N	\N	0
293	2	4	2022-08-15 19:00:08	1705044	2022-08-06 07:16:35	\N	\N	0
295	1	1705016	2022-08-14 12:13:09	1705060	2022-08-05 05:14:11	\N	\N	0
296	1	6	2022-08-19 19:27:11	1705044	2022-08-20 03:35:26	\N	\N	0
297	2	5	2022-08-04 02:04:12	1705062	2022-08-13 20:37:49	\N	\N	0
298	1	7	2022-08-02 07:34:12	1705045	2022-08-09 14:35:56	\N	\N	0
299	2	3	2022-08-17 13:10:18	1705044	2022-08-05 23:50:03	\N	\N	0
300	1	1705017	2022-08-12 06:21:47	1705062	2022-08-21 11:19:01	\N	\N	0
304	1	1705008	2022-08-04 17:17:04	1705060	2022-08-18 22:36:35	\N	\N	0
305	3	6	2022-08-13 05:55:35	1705062	2022-08-10 02:41:54	\N	\N	0
306	1	1705017	2022-08-07 17:49:20	1705045	2022-08-13 14:08:10	\N	\N	0
307	3	1705017	2022-08-21 20:13:03	1705062	2022-08-18 15:26:13	\N	\N	0
309	3	1705015	2022-08-10 04:24:48	1705060	2022-08-17 18:26:17	\N	\N	0
310	1	1705008	2022-08-24 12:43:32	1705044	2022-08-22 10:17:50	\N	\N	0
311	2	1705017	2022-08-16 06:31:53	1705062	2022-08-02 06:53:04	\N	\N	0
315	1	4	2022-08-13 20:40:31	1705045	2022-08-07 21:47:44	\N	\N	0
316	1	1705044	2022-08-04 18:37:33	1705045	2022-08-11 21:02:00	\N	\N	0
317	3	1705044	2022-08-24 23:58:41	1705062	2022-08-07 15:12:29	\N	\N	0
319	2	1705010	2022-08-11 23:15:11	1705062	2022-08-08 06:14:55	\N	\N	0
320	3	1705010	2022-08-03 09:49:46	1705062	2022-08-02 00:01:30	\N	\N	0
321	2	1705001	2022-08-08 08:09:59	1705044	2022-08-12 07:10:16	\N	\N	0
322	2	3	2022-08-17 15:49:06	1705045	2022-08-12 09:13:59	\N	\N	0
324	2	6	2022-08-03 00:23:58	1705060	2022-08-07 11:48:39	\N	\N	0
325	1	1705010	2022-08-23 00:11:52	1705045	2022-08-11 05:53:14	\N	\N	0
327	2	1705010	2022-08-04 00:30:02	1705045	2022-08-17 09:06:09	\N	\N	0
328	1	1705044	2022-08-15 15:53:45	1705045	2022-08-16 11:04:44	\N	\N	0
330	1	7	2022-08-08 14:28:07	1705045	2022-08-24 13:47:51	\N	\N	0
332	1	5	2022-08-15 08:42:15	1705060	2022-08-04 17:03:11	\N	\N	0
333	3	1705017	2022-08-05 12:36:18	1705045	2022-08-06 09:50:05	\N	\N	0
334	3	1705010	2022-08-16 13:10:07	1705060	2022-08-04 16:06:48	\N	\N	0
335	3	1705017	2022-08-15 09:17:18	1705062	2022-08-04 15:45:15	\N	\N	0
336	3	1705016	2022-08-18 01:07:10	1705044	2022-08-16 15:24:36	\N	\N	0
339	2	1705044	2022-08-16 08:17:33	1705060	2022-08-19 11:06:45	\N	\N	0
340	3	1705010	2022-08-20 10:47:56	1705062	2022-08-06 05:46:21	\N	\N	0
341	3	1705016	2022-08-12 21:23:20	1705045	2022-08-22 23:05:42	\N	\N	0
343	1	1705008	2022-08-15 08:14:32	1705060	2022-08-12 15:34:44	\N	\N	0
344	1	1705015	2022-08-07 12:25:08	1705060	2022-08-09 15:42:05	\N	\N	0
346	1	3	2022-08-20 20:39:56	1705045	2022-08-23 05:46:35	\N	\N	0
349	1	3	2022-08-24 15:01:16	1705062	2022-08-25 03:23:48	\N	\N	0
351	1	7	2022-08-09 08:36:25	1705062	2022-08-15 12:21:18	\N	\N	0
352	3	1705017	2022-08-06 06:29:28	1705060	2022-08-22 09:23:03	\N	\N	0
259	2	1705044	2022-08-12 16:25:54	1705045	2022-08-19 21:04:29	\N	\N	0
273	2	6	2022-08-17 16:29:02	1705045	2022-08-23 02:06:56	\N	\N	0
276	2	1705015	2022-08-13 17:42:25	1705045	2022-08-03 22:01:57	\N	\N	0
277	1	7	2022-08-15 23:38:58	1705045	2022-08-03 14:43:47	\N	\N	0
281	1	3	2022-08-01 18:01:54	1705045	2022-08-18 21:03:14	\N	\N	0
282	2	1705001	2022-08-11 21:41:01	1705045	2022-08-11 10:53:17	\N	\N	0
283	1	1705044	2022-08-05 02:22:10	1705045	2022-08-18 08:54:06	\N	\N	0
286	1	7	2022-08-04 11:03:47	1705045	2022-08-04 16:26:44	\N	\N	0
289	3	1705010	2022-08-24 16:39:48	1705045	2022-08-07 11:28:19	\N	\N	0
294	2	1705008	2022-08-23 19:15:32	1705045	2022-08-20 21:47:04	\N	\N	0
301	1	4	2022-08-21 12:03:00	1705045	2022-08-12 21:58:36	\N	\N	0
353	2	1705044	2022-08-09 02:18:33	1705062	2022-08-12 12:25:30	\N	\N	0
354	1	1705015	2022-08-09 05:35:22	1705045	2022-08-04 10:26:04	\N	\N	0
364	3	1705005	2022-08-22 10:59:42	1705062	2022-08-20 18:51:33	\N	\N	0
356	3	7	2022-08-19 04:50:11	1705044	2022-08-09 21:34:21	\N	\N	0
357	2	1705017	2022-08-09 19:19:12	1705045	2022-08-14 13:23:01	\N	\N	0
394	3	1705005	2022-08-08 14:35:01	1705044	2022-08-16 05:15:11	\N	\N	0
359	2	4	2022-08-16 19:13:58	1705062	2022-08-01 16:39:59	\N	\N	0
361	2	1705001	2022-08-12 15:57:32	1705045	2022-08-11 05:11:43	\N	\N	0
362	3	1705044	2022-08-16 06:16:34	1705044	2022-08-18 12:57:39	\N	\N	0
365	2	4	2022-08-02 22:17:19	1705060	2022-08-13 20:27:54	\N	\N	0
423	3	1705005	2022-08-18 20:17:54	1705060	2022-08-07 22:27:46	\N	\N	0
368	3	1705016	2022-08-25 01:15:09	1705044	2022-08-22 07:53:04	\N	\N	0
370	3	3	2022-08-22 14:49:14	1705062	2022-08-21 04:48:45	\N	\N	0
371	1	1705016	2022-08-11 12:40:13	1705045	2022-08-21 12:06:30	\N	\N	0
372	1	1705008	2022-08-21 22:33:10	1705060	2022-08-10 17:27:57	\N	\N	0
373	3	1705008	2022-08-07 22:55:34	1705062	2022-08-03 10:14:47	\N	\N	0
374	2	7	2022-08-02 19:14:51	1705060	2022-08-22 15:24:58	\N	\N	0
375	2	5	2022-08-15 23:29:39	1705044	2022-08-10 14:50:35	\N	\N	0
376	1	1705044	2022-08-11 18:43:15	1705060	2022-08-11 09:35:18	\N	\N	0
377	2	7	2022-08-19 03:06:43	1705045	2022-08-24 00:47:58	\N	\N	0
431	1	1705005	2022-08-18 16:08:24	1705060	2022-08-08 21:21:47	\N	\N	0
379	2	1705016	2022-08-07 06:17:02	1705044	2022-08-11 03:23:44	\N	\N	0
380	1	5	2022-08-07 13:18:09	1705045	2022-08-09 13:23:01	\N	\N	0
381	1	1705015	2022-08-09 21:45:21	1705045	2022-08-12 13:44:56	\N	\N	0
382	1	1705008	2022-08-19 12:29:52	1705060	2022-08-07 20:32:34	\N	\N	0
418	1	1705005	2022-08-23 23:12:10	1705045	2022-08-20 11:33:01	\N	\N	0
385	2	1705001	2022-08-12 04:20:34	1705045	2022-08-10 23:35:50	\N	\N	0
387	2	5	2022-08-04 16:06:02	1705044	2022-08-19 07:51:51	\N	\N	0
1098	3	1705002	2022-08-28 10:47:55	1705045	2022-08-28 10:52:33.246071	\N	You need to reduce anger.	8
395	1	7	2022-08-10 20:46:42	1705062	2022-08-15 08:11:14	\N	\N	0
397	1	1705010	2022-08-22 20:26:25	1705044	2022-08-19 02:45:44	\N	\N	0
398	1	1705016	2022-08-02 23:07:36	1705062	2022-08-02 20:54:37	\N	\N	0
399	3	7	2022-08-05 13:50:57	1705062	2022-08-07 21:25:55	\N	\N	0
400	2	1705010	2022-08-02 23:52:50	1705045	2022-08-14 09:36:47	\N	\N	0
401	2	1705010	2022-08-05 12:02:39	1705044	2022-08-11 05:39:42	\N	\N	0
402	2	4	2022-08-09 00:30:02	1705045	2022-08-11 14:29:27	\N	\N	0
403	2	7	2022-08-01 15:12:23	1705044	2022-08-06 23:45:48	\N	\N	0
404	1	7	2022-08-17 22:02:27	1705062	2022-08-06 21:16:11	\N	\N	0
405	1	5	2022-08-10 13:44:45	1705045	2022-08-21 02:11:18	\N	\N	0
407	1	1705015	2022-08-18 02:36:07	1705044	2022-08-19 10:38:38	\N	\N	0
408	1	1705015	2022-08-08 03:02:30	1705044	2022-08-05 00:05:48	\N	\N	0
409	1	1705044	2022-08-15 06:33:16	1705060	2022-08-09 02:22:11	\N	\N	0
410	3	3	2022-08-08 01:56:55	1705044	2022-08-04 01:26:45	\N	\N	0
412	3	1705044	2022-08-23 02:31:52	1705060	2022-08-11 09:04:34	\N	\N	0
413	2	1705044	2022-08-23 00:54:07	1705044	2022-08-17 01:18:50	\N	\N	0
414	2	5	2022-08-14 13:46:13	1705045	2022-08-17 10:51:00	\N	\N	0
415	2	3	2022-08-18 22:35:36	1705060	2022-08-06 01:06:52	\N	\N	0
419	2	4	2022-08-18 12:42:04	1705060	2022-08-13 20:22:52	\N	\N	0
421	3	1705017	2022-08-04 15:50:48	1705045	2022-08-21 18:32:14	\N	\N	0
424	2	1705001	2022-08-18 11:30:24	1705044	2022-08-09 05:23:36	\N	\N	0
426	2	1705001	2022-08-24 23:00:35	1705062	2022-08-01 15:49:53	\N	\N	0
427	3	6	2022-08-13 04:25:07	1705062	2022-08-20 09:05:38	\N	\N	0
428	2	1705044	2022-08-18 12:33:45	1705062	2022-08-03 03:57:15	\N	\N	0
429	1	1705001	2022-08-06 07:27:57	1705044	2022-08-08 17:52:26	\N	\N	0
430	2	1705017	2022-08-14 03:17:51	1705044	2022-08-16 03:21:13	\N	\N	0
432	1	4	2022-08-08 16:47:19	1705045	2022-08-11 17:01:35	\N	\N	0
433	3	1705001	2022-08-02 00:41:39	1705044	2022-08-23 11:42:40	\N	\N	0
434	1	1705015	2022-08-22 09:52:26	1705062	2022-08-05 08:46:17	\N	\N	0
435	3	1705017	2022-08-11 12:17:01	1705044	2022-08-11 09:16:22	\N	\N	0
436	3	1705008	2022-08-16 16:24:20	1705060	2022-08-11 17:55:40	\N	\N	0
437	3	1705010	2022-08-20 16:03:38	1705062	2022-08-08 17:08:49	\N	\N	0
442	1	1705008	2022-08-13 01:14:10	1705062	2022-08-10 06:15:41	\N	\N	0
443	2	1705010	2022-08-12 01:36:49	1705044	2022-08-24 09:54:50	\N	\N	0
444	1	1705044	2022-08-17 02:58:12	1705062	2022-08-04 20:07:55	\N	\N	0
447	3	1705001	2022-08-06 02:29:49	1705044	2022-08-17 01:08:58	\N	\N	0
448	3	1705010	2022-08-07 23:12:33	1705045	2022-08-13 09:26:45	\N	\N	0
449	1	1705017	2022-08-16 11:26:16	1705062	2022-08-10 22:24:07	\N	\N	0
360	1	3	2022-08-14 02:55:25	1705045	2022-08-19 10:45:04	\N	\N	0
363	2	1705008	2022-08-13 01:17:41	1705045	2022-08-16 20:50:10	\N	\N	0
366	3	3	2022-08-05 07:16:27	1705045	2022-08-14 17:50:30	\N	\N	0
369	2	1705016	2022-08-20 06:59:11	1705045	2022-08-10 23:34:28	\N	\N	0
384	1	1705016	2022-08-17 20:49:42	1705045	2022-08-23 05:17:55	\N	\N	0
386	1	5	2022-08-21 05:18:32	1705045	2022-08-23 22:37:22	\N	\N	0
388	3	1705015	2022-08-02 04:53:13	1705045	2022-08-03 05:06:00	\N	\N	0
392	2	1705008	2022-08-06 17:57:00	1705045	2022-08-03 06:46:56	\N	\N	0
411	2	1705001	2022-08-12 14:39:27	1705045	2022-08-03 15:18:06	\N	\N	0
438	1	1705016	2022-08-15 12:37:36	1705045	2022-08-05 04:20:02	\N	\N	0
440	1	6	2022-08-20 11:16:46	1705045	2022-08-02 22:58:03	\N	\N	0
441	2	6	2022-08-02 11:58:46	1705045	2022-08-09 10:23:45	\N	\N	0
450	1	1705017	2022-08-09 06:40:32	1705062	2022-08-08 04:05:56	\N	\N	0
458	3	1705005	2022-08-22 15:23:44	1705062	2022-08-14 20:18:56	\N	\N	0
453	3	1705015	2022-08-10 02:25:40	1705044	2022-08-21 09:19:42	\N	\N	0
454	2	7	2022-08-07 19:52:52	1705045	2022-08-06 20:12:28	\N	\N	0
455	2	5	2022-08-14 22:52:15	1705045	2022-08-23 09:43:20	\N	\N	0
456	1	6	2022-08-21 23:05:23	1705045	2022-08-02 03:17:24	\N	\N	0
457	2	1705015	2022-08-25 03:30:41	1705062	2022-08-21 02:31:16	\N	\N	0
459	2	7	2022-08-21 17:30:59	1705045	2022-08-01 18:02:29	\N	\N	0
461	2	4	2022-08-07 14:00:35	1705060	2022-08-17 06:27:38	\N	\N	0
462	2	1705001	2022-08-24 23:36:19	1705060	2022-08-04 22:43:38	\N	\N	0
478	3	1705005	2022-08-16 16:05:56	1705044	2022-08-21 12:08:36	\N	\N	0
465	2	4	2022-08-17 07:10:11	1705060	2022-08-24 04:00:13	\N	\N	0
466	1	4	2022-08-19 14:01:22	1705062	2022-08-02 17:48:19	\N	\N	0
467	1	1705017	2022-08-14 08:43:41	1705060	2022-08-10 08:48:46	\N	\N	0
468	1	3	2022-08-23 18:12:40	1705062	2022-08-12 01:01:02	\N	\N	0
469	1	5	2022-08-22 12:47:07	1705045	2022-08-11 02:31:06	\N	\N	0
491	2	1705005	2022-08-04 04:56:21	1705062	2022-08-07 23:41:29	\N	\N	0
471	2	1705015	2022-08-13 06:37:23	1705045	2022-08-11 06:28:28	\N	\N	0
507	2	1705005	2022-08-09 02:53:00	1705045	2022-08-14 10:45:47	\N	\N	0
473	2	1705001	2022-08-06 08:08:34	1705062	2022-08-09 07:25:49	\N	\N	0
528	2	1705005	2022-08-15 10:13:45	1705060	2022-08-22 02:36:47	\N	\N	0
475	3	6	2022-08-10 10:02:54	1705044	2022-08-08 03:31:31	\N	\N	0
476	3	1705044	2022-08-23 06:51:48	1705062	2022-08-20 17:41:43	\N	\N	0
477	1	1705044	2022-08-12 12:24:40	1705062	2022-08-03 09:58:56	\N	\N	0
543	1	1705005	2022-08-05 12:26:21	1705045	2022-08-23 00:27:54	\N	\N	0
546	1	1705005	2022-08-20 20:45:05	1705045	2022-08-19 10:39:37	\N	\N	0
483	3	1705017	2022-08-16 16:00:05	1705060	2022-08-05 05:50:28	\N	\N	0
451	2	1705005	2022-08-24 15:10:45	1705045	2022-08-18 09:30:17	\N	\N	0
486	1	1705008	2022-08-03 06:58:18	1705060	2022-08-12 14:38:10	\N	\N	0
488	1	1705017	2022-08-09 17:55:06	1705044	2022-08-06 22:46:48	\N	\N	0
489	2	1705016	2022-08-01 17:28:37	1705045	2022-08-20 13:18:06	\N	\N	0
490	2	7	2022-08-03 06:21:26	1705045	2022-08-14 06:29:24	\N	\N	0
496	3	1705001	2022-08-12 19:22:34	1705045	2022-08-12 13:50:41	\N	\N	0
499	1	1705017	2022-08-10 18:36:44	1705045	2022-08-08 22:49:01	\N	\N	0
500	3	7	2022-08-07 23:07:20	1705044	2022-08-01 21:12:15	\N	\N	0
501	1	1705017	2022-08-23 17:26:29	1705060	2022-08-02 02:34:37	\N	\N	0
502	1	1705010	2022-08-10 08:41:26	1705044	2022-08-03 16:00:40	\N	\N	0
504	3	1705010	2022-08-14 11:06:45	1705044	2022-08-07 07:40:13	\N	\N	0
506	1	1705010	2022-08-05 01:18:42	1705060	2022-08-22 17:07:33	\N	\N	0
508	1	5	2022-08-01 16:00:30	1705044	2022-08-20 15:02:19	\N	\N	0
509	3	1705017	2022-08-15 12:47:56	1705044	2022-08-17 17:23:51	\N	\N	0
511	2	7	2022-08-18 09:58:12	1705060	2022-08-08 06:30:53	\N	\N	0
513	1	4	2022-08-20 04:35:41	1705045	2022-08-20 06:33:31	\N	\N	0
517	1	1705017	2022-08-07 10:03:51	1705062	2022-08-13 03:12:58	\N	\N	0
518	2	1705044	2022-08-19 21:33:44	1705045	2022-08-11 10:31:56	\N	\N	0
520	2	1705010	2022-08-24 20:46:42	1705060	2022-08-23 13:44:28	\N	\N	0
521	3	1705008	2022-08-09 00:09:58	1705045	2022-08-21 17:40:42	\N	\N	0
523	1	7	2022-08-02 15:33:52	1705062	2022-08-03 00:17:07	\N	\N	0
524	3	1705008	2022-08-10 16:05:56	1705062	2022-08-09 07:34:04	\N	\N	0
525	1	1705001	2022-08-03 21:54:22	1705044	2022-08-07 06:36:10	\N	\N	0
526	2	4	2022-08-22 07:17:29	1705062	2022-08-12 16:24:40	\N	\N	0
529	1	4	2022-08-08 12:17:15	1705062	2022-08-17 19:34:58	\N	\N	0
534	1	1705015	2022-08-08 11:54:58	1705044	2022-08-16 05:26:09	\N	\N	0
535	2	1705015	2022-08-07 02:08:40	1705062	2022-08-23 06:50:58	\N	\N	0
538	3	1705010	2022-08-08 21:50:18	1705045	2022-08-04 10:15:35	\N	\N	0
541	3	4	2022-08-02 03:46:07	1705060	2022-08-25 01:16:03	\N	\N	0
460	1	7	2022-08-09 02:08:37	1705045	2022-08-08 13:40:32	\N	\N	0
464	2	1705015	2022-08-18 09:49:28	1705045	2022-08-02 12:40:39	\N	\N	0
481	1	3	2022-08-13 08:00:40	1705045	2022-08-13 13:15:12	\N	\N	0
482	3	1705044	2022-08-21 12:43:58	1705045	2022-08-24 01:44:52	\N	\N	0
487	1	3	2022-08-06 04:18:08	1705045	2022-08-17 17:25:52	\N	\N	0
492	3	1705017	2022-08-07 16:25:49	1705045	2022-08-11 06:28:59	\N	\N	0
493	1	1705015	2022-08-10 00:13:55	1705045	2022-08-14 19:01:06	\N	\N	0
494	1	4	2022-08-07 02:55:57	1705045	2022-08-09 09:33:46	\N	\N	0
495	3	3	2022-08-02 16:44:28	1705045	2022-08-03 11:23:57	\N	\N	0
498	2	5	2022-08-11 01:13:29	1705045	2022-08-19 10:28:53	\N	\N	0
505	3	4	2022-08-03 11:28:27	1705045	2022-08-03 07:04:20	\N	\N	0
512	3	5	2022-08-17 15:21:58	1705045	2022-08-19 20:26:15	\N	\N	0
515	3	5	2022-08-17 21:09:25	1705045	2022-08-24 06:39:42	\N	\N	0
519	3	1705015	2022-08-10 19:04:01	1705045	2022-08-16 00:27:29	\N	\N	0
522	2	7	2022-08-25 01:39:24	1705045	2022-08-09 14:40:48	\N	\N	0
530	2	1705001	2022-08-05 15:49:27	1705045	2022-08-20 17:41:47	\N	\N	0
540	3	1705044	2022-08-25 00:01:30	1705045	2022-08-23 04:52:45	\N	\N	0
542	2	1705008	2022-08-14 14:31:44	1705045	2022-08-16 10:00:37	\N	\N	0
544	3	1705016	2022-08-16 03:17:28	1705045	2022-08-13 18:55:36	\N	\N	0
547	3	5	2022-08-06 05:23:56	1705062	2022-08-05 16:43:29	\N	\N	0
548	3	4	2022-08-24 13:04:48	1705062	2022-08-11 04:40:16	\N	\N	0
549	3	6	2022-08-14 10:08:41	1705045	2022-08-04 20:01:01	\N	\N	0
567	1	1705005	2022-08-18 22:10:18	1705044	2022-08-15 10:45:11	\N	\N	0
595	2	1705005	2022-08-21 04:01:09	1705060	2022-08-11 01:27:31	\N	\N	0
552	1	1705001	2022-08-12 23:28:28	1705044	2022-08-23 03:48:01	\N	\N	0
553	2	1705044	2022-08-15 11:55:31	1705060	2022-08-04 15:03:14	\N	\N	0
612	3	1705005	2022-08-04 03:46:04	1705062	2022-08-21 19:34:26	\N	\N	0
556	3	3	2022-08-17 07:56:19	1705045	2022-08-17 06:46:40	\N	\N	0
557	1	6	2022-08-06 16:04:19	1705060	2022-08-07 19:34:23	\N	\N	0
559	1	6	2022-08-07 07:30:10	1705060	2022-08-12 14:56:10	\N	\N	0
560	1	1705010	2022-08-18 07:55:48	1705062	2022-08-13 03:47:40	\N	\N	0
630	2	1705005	2022-08-08 03:25:10	1705062	2022-08-24 10:28:19	\N	\N	0
563	3	7	2022-08-02 13:03:50	1705044	2022-08-02 10:00:45	\N	\N	0
565	2	7	2022-08-09 09:12:20	1705045	2022-08-20 08:28:41	\N	\N	0
566	2	7	2022-08-23 11:24:57	1705045	2022-08-17 17:07:26	\N	\N	0
569	3	1705044	2022-08-11 15:34:01	1705060	2022-08-14 11:53:00	\N	\N	0
568	3	1705005	2022-08-16 07:25:54	1705045	2022-08-07 06:28:19	\N	\N	0
571	1	1705008	2022-08-09 03:39:03	1705044	2022-08-15 03:24:08	\N	\N	0
574	2	1705044	2022-08-19 11:43:17	1705060	2022-08-21 09:07:30	\N	\N	0
575	2	4	2022-08-17 21:19:13	1705044	2022-08-16 11:09:15	\N	\N	0
576	3	7	2022-08-09 00:39:37	1705062	2022-08-05 08:05:24	\N	\N	0
578	1	7	2022-08-03 08:10:22	1705044	2022-08-14 04:38:53	\N	\N	0
579	1	3	2022-08-18 03:01:45	1705062	2022-08-20 04:01:19	\N	\N	0
581	1	1705008	2022-08-07 09:50:45	1705045	2022-08-12 08:06:51	\N	\N	0
580	1	1705005	2022-08-10 13:56:06	1705045	2022-08-23 12:34:16	\N	\N	0
583	1	1705008	2022-08-17 17:43:43	1705044	2022-08-10 22:40:43	\N	\N	0
586	1	5	2022-08-19 09:39:57	1705062	2022-08-09 15:35:09	\N	\N	0
587	2	1705001	2022-08-06 10:05:01	1705060	2022-08-14 16:26:47	\N	\N	0
588	1	5	2022-08-18 11:39:02	1705045	2022-08-17 22:13:15	\N	\N	0
592	2	7	2022-08-18 19:47:52	1705045	2022-08-14 22:14:24	\N	\N	0
594	3	1705017	2022-08-04 03:15:46	1705045	2022-08-15 01:17:03	\N	\N	0
597	3	3	2022-08-06 22:56:57	1705044	2022-08-14 20:22:53	\N	\N	0
600	1	1705044	2022-08-24 05:07:13	1705044	2022-08-14 20:58:24	\N	\N	0
601	2	1705015	2022-08-12 19:53:04	1705045	2022-08-22 10:44:29	\N	\N	0
605	2	3	2022-08-23 00:50:21	1705044	2022-08-07 14:08:38	\N	\N	0
606	2	1705044	2022-08-11 07:37:15	1705045	2022-08-23 12:57:15	\N	\N	0
607	2	1705001	2022-08-09 13:15:20	1705044	2022-08-08 22:11:59	\N	\N	0
611	2	4	2022-08-04 06:34:18	1705044	2022-08-07 09:15:12	\N	\N	0
613	3	1705015	2022-08-24 15:41:18	1705062	2022-08-23 14:04:14	\N	\N	0
614	3	6	2022-08-10 09:39:06	1705060	2022-08-17 19:03:05	\N	\N	0
615	2	7	2022-08-11 03:41:02	1705045	2022-08-02 17:54:28	\N	\N	0
617	1	5	2022-08-24 18:02:04	1705045	2022-08-23 10:04:25	\N	\N	0
619	2	1705008	2022-08-07 19:09:01	1705045	2022-08-15 18:00:08	\N	\N	0
624	3	6	2022-08-23 23:18:58	1705044	2022-08-22 13:49:57	\N	\N	0
625	2	5	2022-08-07 12:23:04	1705060	2022-08-01 16:20:02	\N	\N	0
626	2	4	2022-08-05 19:49:13	1705045	2022-08-09 06:37:32	\N	\N	0
629	3	1705010	2022-08-06 12:49:24	1705060	2022-08-18 00:48:09	\N	\N	0
631	1	7	2022-08-03 10:01:36	1705045	2022-08-07 05:35:24	\N	\N	0
634	2	4	2022-08-17 03:26:50	1705044	2022-08-11 10:35:49	\N	\N	0
635	2	1705001	2022-08-08 19:22:02	1705045	2022-08-02 13:24:46	\N	\N	0
637	3	1705015	2022-08-12 01:50:50	1705044	2022-08-09 08:30:44	\N	\N	0
642	3	1705008	2022-08-02 17:21:03	1705045	2022-08-06 04:11:23	\N	\N	0
643	1	1705008	2022-08-12 21:27:34	1705044	2022-08-02 05:54:38	\N	\N	0
554	1	1705008	2022-08-01 15:12:20	1705045	2022-08-19 01:36:46	\N	\N	0
558	2	1705016	2022-08-12 15:12:06	1705045	2022-08-21 16:55:58	\N	\N	0
562	3	7	2022-08-12 08:35:40	1705045	2022-08-04 04:21:52	\N	\N	0
564	3	1705015	2022-08-18 08:31:48	1705045	2022-08-11 10:14:09	\N	\N	0
572	2	1705008	2022-08-05 19:05:50	1705045	2022-08-12 05:16:12	\N	\N	0
573	2	1705017	2022-08-05 07:46:30	1705045	2022-08-15 10:29:39	\N	\N	0
577	3	1705015	2022-08-10 22:56:30	1705045	2022-08-02 11:43:16	\N	\N	0
585	3	1705010	2022-08-10 19:11:31	1705045	2022-08-12 14:45:15	\N	\N	0
593	2	1705016	2022-08-02 02:36:34	1705045	2022-08-13 14:42:44	\N	\N	0
596	2	3	2022-08-19 19:31:16	1705045	2022-08-17 00:46:33	\N	\N	0
602	1	1705001	2022-08-11 20:05:04	1705045	2022-08-10 18:58:24	\N	\N	0
609	1	1705017	2022-08-17 13:35:19	1705045	2022-08-20 13:18:54	\N	\N	0
610	3	1705015	2022-08-16 13:36:33	1705045	2022-08-12 11:21:18	\N	\N	0
616	3	1705016	2022-08-24 04:24:04	1705045	2022-08-16 14:03:18	\N	\N	0
618	3	1705001	2022-08-04 09:34:45	1705045	2022-08-06 21:55:39	\N	\N	0
644	3	5	2022-08-19 00:25:30	1705062	2022-08-10 20:11:54	\N	\N	0
645	2	4	2022-08-04 03:49:42	1705062	2022-08-06 23:29:59	\N	\N	0
647	1	1705005	2022-08-04 22:57:41	1705060	2022-08-21 21:49:36	\N	\N	0
648	2	7	2022-08-08 19:07:53	1705044	2022-08-02 06:00:26	\N	\N	0
649	3	1705044	2022-08-13 10:12:01	1705045	2022-08-25 02:58:59	\N	\N	0
650	2	6	2022-08-18 18:22:24	1705060	2022-08-23 14:20:56	\N	\N	0
651	1	1705001	2022-08-11 17:04:14	1705045	2022-08-11 21:04:20	\N	\N	0
652	3	1705010	2022-08-04 01:46:55	1705060	2022-08-21 19:30:46	\N	\N	0
653	1	1705044	2022-08-17 12:21:38	1705060	2022-08-15 22:45:39	\N	\N	0
655	1	1705017	2022-08-22 15:13:37	1705062	2022-08-19 23:09:29	\N	\N	0
656	1	5	2022-08-10 22:28:49	1705045	2022-08-07 15:09:10	\N	\N	0
654	2	1705005	2022-08-03 22:58:54	1705044	2022-08-20 22:10:04	\N	\N	0
658	3	4	2022-08-21 13:38:42	1705044	2022-08-18 21:40:25	\N	\N	0
679	2	1705005	2022-08-23 11:31:45	1705045	2022-08-04 23:49:31	\N	\N	0
661	3	1705016	2022-08-22 05:18:12	1705062	2022-08-25 02:48:26	\N	\N	0
702	1	1705005	2022-08-04 10:52:02	1705045	2022-08-07 18:09:04	\N	\N	0
663	2	1705016	2022-08-07 02:21:21	1705060	2022-08-17 05:04:16	\N	\N	0
666	2	7	2022-08-06 20:20:53	1705060	2022-08-13 01:19:07	\N	\N	0
669	3	1705010	2022-08-06 17:27:41	1705062	2022-08-15 21:03:13	\N	\N	0
670	1	3	2022-08-18 10:08:09	1705044	2022-08-17 12:16:32	\N	\N	0
671	1	3	2022-08-06 14:58:21	1705060	2022-08-11 00:05:12	\N	\N	0
675	1	1705016	2022-08-09 19:56:36	1705062	2022-08-03 20:02:36	\N	\N	0
676	3	1705008	2022-08-13 19:04:29	1705044	2022-08-24 04:50:17	\N	\N	0
677	3	1705016	2022-08-16 22:31:47	1705044	2022-08-05 18:06:07	\N	\N	0
680	3	5	2022-08-22 02:59:17	1705045	2022-08-17 03:37:39	\N	\N	0
681	2	6	2022-08-10 16:03:29	1705045	2022-08-15 15:47:28	\N	\N	0
682	2	1705010	2022-08-17 20:24:10	1705044	2022-08-07 20:16:32	\N	\N	0
684	2	6	2022-08-17 12:11:35	1705045	2022-08-01 16:30:41	\N	\N	0
685	2	1705008	2022-08-12 11:01:10	1705045	2022-08-04 17:13:54	\N	\N	0
686	2	5	2022-08-22 11:56:13	1705060	2022-08-11 12:05:22	\N	\N	0
687	3	1705001	2022-08-09 07:25:52	1705045	2022-08-20 17:36:29	\N	\N	0
689	2	7	2022-08-07 06:26:58	1705044	2022-08-07 23:25:17	\N	\N	0
690	2	6	2022-08-11 15:13:17	1705060	2022-08-09 08:02:00	\N	\N	0
691	2	4	2022-08-12 12:11:13	1705044	2022-08-18 22:52:25	\N	\N	0
692	1	7	2022-08-02 12:34:41	1705062	2022-08-21 17:48:10	\N	\N	0
693	2	1705044	2022-08-19 18:59:46	1705045	2022-08-10 08:36:50	\N	\N	0
694	1	1705008	2022-08-19 08:15:12	1705045	2022-08-24 03:36:03	\N	\N	0
696	2	1705010	2022-08-10 20:34:18	1705045	2022-08-02 16:04:48	\N	\N	0
697	2	7	2022-08-05 10:50:18	1705062	2022-08-13 20:12:28	\N	\N	0
700	2	7	2022-08-06 11:00:24	1705044	2022-08-10 19:25:18	\N	\N	0
701	2	5	2022-08-15 23:46:58	1705062	2022-08-25 03:50:36	\N	\N	0
705	3	1705017	2022-08-12 03:32:16	1705062	2022-08-25 01:34:34	\N	\N	0
707	3	6	2022-08-18 18:26:34	1705044	2022-08-20 08:24:08	\N	\N	0
708	3	4	2022-08-08 21:32:16	1705045	2022-08-15 07:28:59	\N	\N	0
709	1	1705008	2022-08-21 21:56:33	1705062	2022-08-09 11:46:51	\N	\N	0
711	2	1705044	2022-08-08 21:40:15	1705045	2022-08-17 03:36:04	\N	\N	0
712	3	1705044	2022-08-21 18:23:35	1705044	2022-08-02 08:54:11	\N	\N	0
713	2	1705015	2022-08-08 08:36:39	1705045	2022-08-24 08:34:55	\N	\N	0
716	1	1705015	2022-08-17 05:42:11	1705044	2022-08-24 22:31:02	\N	\N	0
717	2	3	2022-08-12 06:43:26	1705044	2022-08-06 21:26:25	\N	\N	0
718	2	6	2022-08-12 20:50:56	1705044	2022-08-18 06:14:25	\N	\N	0
719	3	1705016	2022-08-12 10:48:18	1705045	2022-08-09 18:46:11	\N	\N	0
720	3	6	2022-08-20 05:33:39	1705044	2022-08-07 18:33:45	\N	\N	0
721	2	6	2022-08-12 19:18:25	1705062	2022-08-03 23:15:11	\N	\N	0
722	3	4	2022-08-13 01:59:23	1705060	2022-08-13 00:10:40	\N	\N	0
723	3	1705001	2022-08-03 15:10:21	1705045	2022-08-22 03:18:26	\N	\N	0
724	1	1705017	2022-08-05 14:11:18	1705060	2022-08-13 02:35:03	\N	\N	0
725	1	1705015	2022-08-08 16:53:49	1705045	2022-08-18 10:47:12	\N	\N	0
726	2	1705015	2022-08-14 21:17:05	1705060	2022-08-12 20:10:52	\N	\N	0
728	3	6	2022-08-16 02:32:34	1705044	2022-08-06 22:12:40	\N	\N	0
729	3	5	2022-08-21 17:29:46	1705060	2022-08-16 01:17:19	\N	\N	0
731	1	1705008	2022-08-16 10:35:18	1705062	2022-08-12 10:09:54	\N	\N	0
732	2	1705015	2022-08-04 01:16:34	1705045	2022-08-21 18:57:59	\N	\N	0
733	3	7	2022-08-05 09:30:18	1705044	2022-08-09 10:46:47	\N	\N	0
735	2	1705008	2022-08-03 18:17:45	1705062	2022-08-03 18:42:43	\N	\N	0
736	2	7	2022-08-01 17:50:19	1705045	2022-08-19 16:13:32	\N	\N	0
738	1	1705016	2022-08-21 11:14:14	1705062	2022-08-19 06:04:40	\N	\N	0
659	2	3	2022-08-24 12:39:38	1705045	2022-08-19 18:14:58	\N	\N	0
665	1	4	2022-08-14 20:10:38	1705045	2022-08-22 01:51:03	\N	\N	0
668	2	6	2022-08-06 14:41:31	1705045	2022-08-19 18:44:43	\N	\N	0
672	1	4	2022-08-20 06:09:19	1705045	2022-08-02 20:33:39	\N	\N	0
673	1	1705001	2022-08-09 04:47:43	1705045	2022-08-11 12:43:30	\N	\N	0
674	2	1705008	2022-08-05 16:08:49	1705045	2022-08-10 11:11:50	\N	\N	0
683	2	6	2022-08-20 21:11:50	1705045	2022-08-16 12:08:57	\N	\N	0
695	2	6	2022-08-10 01:46:34	1705045	2022-08-11 08:03:46	\N	\N	0
706	1	1705016	2022-08-10 01:28:40	1705045	2022-08-22 16:51:11	\N	\N	0
710	3	7	2022-08-06 00:33:11	1705045	2022-08-09 22:55:50	\N	\N	0
714	3	3	2022-08-23 18:40:51	1705045	2022-08-10 22:27:49	\N	\N	0
715	2	4	2022-08-02 02:16:47	1705045	2022-08-17 12:34:04	\N	\N	0
727	2	1705017	2022-08-21 02:21:04	1705045	2022-08-14 01:20:57	\N	\N	0
741	3	6	2022-08-10 08:41:28	1705062	2022-08-06 09:57:42	\N	\N	0
742	1	1705001	2022-08-12 14:19:05	1705045	2022-08-15 23:49:09	\N	\N	0
744	3	6	2022-08-11 06:27:46	1705044	2022-08-10 05:38:02	\N	\N	0
765	3	1705005	2022-08-12 20:54:40	1705045	2022-08-23 18:33:42	\N	\N	0
746	2	5	2022-08-05 13:37:44	1705060	2022-08-19 00:45:22	\N	\N	0
747	2	7	2022-08-09 00:48:44	1705044	2022-08-01 23:54:10	\N	\N	0
748	3	6	2022-08-10 01:36:15	1705045	2022-08-17 17:58:22	\N	\N	0
749	1	1705015	2022-08-02 11:08:22	1705060	2022-08-14 01:55:58	\N	\N	0
752	1	1705044	2022-08-11 15:40:12	1705044	2022-08-13 01:14:20	\N	\N	0
753	3	1705015	2022-08-07 05:35:15	1705062	2022-08-18 20:09:24	\N	\N	0
768	3	1705005	2022-08-06 03:52:29	1705060	2022-08-19 22:20:06	\N	\N	0
758	2	7	2022-08-08 18:14:18	1705044	2022-08-10 11:18:31	\N	\N	0
759	1	1705008	2022-08-02 00:26:56	1705060	2022-08-14 20:27:20	\N	\N	0
760	3	1705010	2022-08-06 21:02:16	1705045	2022-08-22 15:52:35	\N	\N	0
761	3	1705008	2022-08-22 22:02:17	1705062	2022-08-01 18:42:58	\N	\N	0
762	2	1705016	2022-08-13 06:09:18	1705045	2022-08-08 22:48:01	\N	\N	0
763	1	1705044	2022-08-19 01:52:55	1705060	2022-08-02 17:25:10	\N	\N	0
789	2	1705005	2022-08-23 16:52:37	1705062	2022-08-15 09:10:16	\N	\N	0
766	1	1705008	2022-08-24 05:10:33	1705062	2022-08-15 08:53:38	\N	\N	0
834	1	1705005	2022-08-16 02:28:40	1705045	2022-08-23 16:12:31	\N	\N	0
770	1	7	2022-08-16 23:44:32	1705045	2022-08-01 16:02:45	\N	\N	0
771	1	1705016	2022-08-14 02:02:30	1705044	2022-08-16 07:41:31	\N	\N	0
772	2	1705017	2022-08-05 01:35:26	1705044	2022-08-19 23:45:53	\N	\N	0
773	3	1705017	2022-08-10 10:14:53	1705044	2022-08-07 12:57:26	\N	\N	0
775	3	7	2022-08-04 21:30:52	1705045	2022-08-05 21:03:26	\N	\N	0
777	3	5	2022-08-20 09:52:00	1705044	2022-08-19 00:09:15	\N	\N	0
781	1	4	2022-08-12 10:50:24	1705045	2022-08-10 02:06:31	\N	\N	0
782	3	3	2022-08-20 00:19:52	1705062	2022-08-19 21:10:37	\N	\N	0
784	2	1705016	2022-08-06 17:17:58	1705060	2022-08-07 00:30:46	\N	\N	0
786	2	1705015	2022-08-18 17:19:25	1705060	2022-08-07 18:22:52	\N	\N	0
787	3	3	2022-08-17 07:09:07	1705062	2022-08-14 00:09:56	\N	\N	0
788	2	3	2022-08-20 23:29:35	1705060	2022-08-05 18:45:14	\N	\N	0
790	3	7	2022-08-22 05:49:05	1705062	2022-08-03 02:40:06	\N	\N	0
791	2	6	2022-08-22 05:02:12	1705060	2022-08-03 09:07:37	\N	\N	0
792	1	4	2022-08-21 19:10:43	1705045	2022-08-07 02:15:06	\N	\N	0
794	2	1705044	2022-08-19 16:11:27	1705045	2022-08-08 01:46:16	\N	\N	0
795	1	1705015	2022-08-09 18:44:35	1705060	2022-08-07 09:22:03	\N	\N	0
796	1	1705015	2022-08-11 03:01:03	1705062	2022-08-16 19:41:22	\N	\N	0
797	3	7	2022-08-22 05:04:35	1705045	2022-08-22 19:22:39	\N	\N	0
798	1	1705017	2022-08-06 09:59:14	1705045	2022-08-08 05:57:14	\N	\N	0
803	2	1705044	2022-08-04 15:09:21	1705062	2022-08-19 20:42:21	\N	\N	0
805	2	7	2022-08-03 03:25:19	1705062	2022-08-03 02:58:12	\N	\N	0
806	3	1705017	2022-08-24 07:06:02	1705062	2022-08-17 08:36:08	\N	\N	0
807	1	1705015	2022-08-24 05:06:10	1705045	2022-08-22 02:49:52	\N	\N	0
808	2	1705044	2022-08-19 05:41:09	1705062	2022-08-23 12:36:56	\N	\N	0
809	1	6	2022-08-16 19:41:18	1705060	2022-08-13 11:42:04	\N	\N	0
811	2	4	2022-08-03 09:03:23	1705062	2022-08-21 13:17:53	\N	\N	0
812	3	7	2022-08-08 08:59:51	1705060	2022-08-20 12:21:48	\N	\N	0
813	3	1705017	2022-08-14 04:54:59	1705045	2022-08-24 19:46:10	\N	\N	0
814	3	1705015	2022-08-20 04:56:30	1705045	2022-08-05 09:10:44	\N	\N	0
815	1	3	2022-08-14 11:55:37	1705060	2022-08-19 07:20:38	\N	\N	0
820	2	1705008	2022-08-23 03:04:08	1705045	2022-08-11 15:53:32	\N	\N	0
822	3	1705010	2022-08-07 02:35:16	1705044	2022-08-18 06:42:51	\N	\N	0
823	1	1705016	2022-08-09 22:51:51	1705045	2022-08-17 20:30:32	\N	\N	0
826	3	6	2022-08-05 13:29:31	1705045	2022-08-11 05:02:46	\N	\N	0
828	1	1705017	2022-08-18 05:22:26	1705062	2022-08-23 00:09:17	\N	\N	0
831	2	1705016	2022-08-23 02:25:35	1705044	2022-08-08 07:55:49	\N	\N	0
832	3	7	2022-08-24 10:10:29	1705045	2022-08-20 00:53:34	\N	\N	0
835	2	5	2022-08-23 20:51:16	1705062	2022-08-02 14:34:23	\N	\N	0
836	1	7	2022-08-17 16:19:22	1705044	2022-08-07 04:56:15	\N	\N	0
837	2	1705008	2022-08-06 03:05:18	1705062	2022-08-06 05:27:10	\N	\N	0
743	2	1705016	2022-08-07 10:56:59	1705045	2022-08-23 11:59:31	\N	\N	0
750	3	1705044	2022-08-03 11:22:48	1705045	2022-08-07 12:00:06	\N	\N	0
751	1	5	2022-08-20 12:20:26	1705045	2022-08-02 07:32:04	\N	\N	0
754	1	1705015	2022-08-23 07:01:07	1705045	2022-08-11 09:12:39	\N	\N	0
755	1	1705017	2022-08-09 04:57:20	1705045	2022-08-24 20:08:50	\N	\N	0
756	3	1705015	2022-08-06 04:30:21	1705045	2022-08-12 01:45:46	\N	\N	0
769	3	5	2022-08-18 00:01:18	1705045	2022-08-24 03:00:34	\N	\N	0
776	1	7	2022-08-13 04:15:29	1705045	2022-08-20 23:17:46	\N	\N	0
778	3	3	2022-08-18 08:36:30	1705045	2022-08-04 05:19:21	\N	\N	0
779	3	1705017	2022-08-22 11:57:29	1705045	2022-08-14 21:39:21	\N	\N	0
780	3	1705015	2022-08-14 19:19:27	1705045	2022-08-04 22:33:02	\N	\N	0
785	3	1705008	2022-08-13 15:16:52	1705045	2022-08-15 05:33:35	\N	\N	0
800	3	1705015	2022-08-22 16:59:48	1705045	2022-08-15 09:07:35	\N	\N	0
817	1	6	2022-08-13 08:38:31	1705045	2022-08-24 04:40:50	\N	\N	0
821	2	7	2022-08-07 05:39:49	1705045	2022-08-19 06:37:30	\N	\N	0
827	2	1705015	2022-08-23 20:30:33	1705045	2022-08-02 07:40:26	\N	\N	0
833	3	4	2022-08-22 14:23:40	1705045	2022-08-11 22:43:17	\N	\N	0
838	1	1705044	2022-08-23 21:27:16	1705062	2022-08-23 17:13:34	\N	\N	0
843	1	1705005	2022-08-17 10:07:39	1705045	2022-08-24 09:22:13	\N	\N	0
840	3	6	2022-08-09 16:37:40	1705044	2022-08-10 12:20:45	\N	\N	0
842	2	3	2022-08-05 05:40:42	1705044	2022-08-13 19:53:11	\N	\N	0
844	2	1705015	2022-08-09 07:23:16	1705044	2022-08-24 12:36:22	\N	\N	0
845	2	4	2022-08-01 22:54:23	1705045	2022-08-23 19:45:33	\N	\N	0
846	1	1705010	2022-08-02 13:35:18	1705060	2022-08-19 00:54:41	\N	\N	0
848	3	6	2022-08-04 03:14:17	1705062	2022-08-12 12:28:41	\N	\N	0
850	3	4	2022-08-14 12:01:07	1705060	2022-08-07 05:47:36	\N	\N	0
873	3	1705005	2022-08-12 04:30:07	1705060	2022-08-11 21:22:56	\N	\N	0
852	1	1705017	2022-08-13 14:44:52	1705060	2022-08-15 12:04:03	\N	\N	0
853	2	1705044	2022-08-07 21:27:05	1705060	2022-08-08 21:54:13	\N	\N	0
854	2	7	2022-08-06 11:25:14	1705060	2022-08-13 16:23:15	\N	\N	0
899	2	1705005	2022-08-07 19:16:21	1705062	2022-08-13 07:49:53	\N	\N	0
856	3	1705001	2022-08-17 10:59:50	1705060	2022-08-05 22:52:22	\N	\N	0
857	1	5	2022-08-17 14:30:19	1705045	2022-08-18 07:52:52	\N	\N	0
858	1	5	2022-08-22 03:14:54	1705044	2022-08-08 01:18:27	\N	\N	0
859	1	4	2022-08-04 20:07:10	1705045	2022-08-20 07:06:37	\N	\N	0
860	3	4	2022-08-08 22:55:19	1705044	2022-08-22 17:35:57	\N	\N	0
861	1	1705010	2022-08-18 15:43:20	1705045	2022-08-13 10:48:24	\N	\N	0
862	1	1705015	2022-08-19 17:26:27	1705044	2022-08-08 20:28:12	\N	\N	0
863	3	6	2022-08-13 03:58:07	1705044	2022-08-24 04:23:34	\N	\N	0
865	3	1705016	2022-08-05 05:44:43	1705062	2022-08-14 05:11:55	\N	\N	0
866	1	6	2022-08-04 05:49:30	1705044	2022-08-02 00:37:39	\N	\N	0
867	2	1705044	2022-08-02 04:52:07	1705045	2022-08-06 14:06:04	\N	\N	0
868	1	1705001	2022-08-04 23:54:48	1705060	2022-08-15 22:45:45	\N	\N	0
869	2	1705016	2022-08-22 05:46:54	1705062	2022-08-07 04:06:46	\N	\N	0
870	1	6	2022-08-05 08:54:41	1705062	2022-08-24 12:56:29	\N	\N	0
871	3	1705016	2022-08-21 08:09:42	1705045	2022-08-22 22:56:55	\N	\N	0
872	1	1705016	2022-08-12 06:48:54	1705045	2022-08-19 05:09:47	\N	\N	0
875	2	1705010	2022-08-07 09:03:12	1705045	2022-08-10 00:02:01	\N	\N	0
904	2	1705005	2022-08-08 14:16:11	1705060	2022-08-06 11:24:40	\N	\N	0
877	3	1705016	2022-08-09 00:44:03	1705060	2022-08-14 18:35:04	\N	\N	0
878	2	1705016	2022-08-24 06:38:56	1705044	2022-08-21 05:46:25	\N	\N	0
879	2	1705010	2022-08-04 21:37:16	1705062	2022-08-22 04:02:51	\N	\N	0
881	3	1705010	2022-08-05 04:48:40	1705062	2022-08-19 18:28:28	\N	\N	0
882	1	5	2022-08-04 23:49:01	1705044	2022-08-07 22:23:51	\N	\N	0
926	2	1705005	2022-08-06 10:15:46	1705060	2022-08-23 01:41:29	\N	\N	0
884	1	7	2022-08-14 05:54:38	1705044	2022-08-09 13:59:12	\N	\N	0
933	3	1705005	2022-08-20 15:54:44	1705044	2022-08-17 05:20:10	\N	\N	0
896	2	1705005	2022-08-19 00:09:08	1705045	2022-08-04 15:18:05	\N	\N	0
900	2	1705005	2022-08-24 21:29:28	1705045	2022-08-14 18:04:43	\N	\N	0
889	2	1705016	2022-08-08 23:51:43	1705044	2022-08-11 04:22:10	\N	\N	0
891	1	6	2022-08-08 20:58:45	1705060	2022-08-04 15:36:42	\N	\N	0
893	1	1705016	2022-08-10 07:38:32	1705044	2022-08-15 11:31:32	\N	\N	0
894	2	1705001	2022-08-10 16:31:09	1705062	2022-08-14 08:00:43	\N	\N	0
895	1	1705044	2022-08-12 09:25:55	1705045	2022-08-22 21:53:49	\N	\N	0
897	3	7	2022-08-18 01:13:22	1705044	2022-08-23 07:02:40	\N	\N	0
898	2	1705016	2022-08-14 17:17:52	1705045	2022-08-20 02:30:12	\N	\N	0
901	1	3	2022-08-20 00:28:34	1705062	2022-08-05 21:25:35	\N	\N	0
902	3	1705016	2022-08-09 20:17:46	1705045	2022-08-23 01:53:15	\N	\N	0
905	2	4	2022-08-22 06:46:04	1705044	2022-08-19 09:30:25	\N	\N	0
906	3	1705015	2022-08-16 21:00:43	1705045	2022-08-14 07:55:17	\N	\N	0
907	2	1705010	2022-08-03 10:41:50	1705062	2022-08-22 17:34:55	\N	\N	0
908	3	1705016	2022-08-24 13:24:16	1705044	2022-08-20 04:51:08	\N	\N	0
909	1	7	2022-08-12 00:47:47	1705062	2022-08-02 10:22:17	\N	\N	0
910	1	4	2022-08-04 12:46:01	1705062	2022-08-13 23:51:00	\N	\N	0
911	3	1705010	2022-08-14 09:11:52	1705060	2022-08-16 19:10:05	\N	\N	0
913	1	1705015	2022-08-09 16:49:05	1705044	2022-08-03 12:10:42	\N	\N	0
914	2	3	2022-08-04 00:24:30	1705044	2022-08-16 16:09:41	\N	\N	0
917	1	6	2022-08-13 21:43:55	1705045	2022-08-19 07:27:46	\N	\N	0
918	1	1705008	2022-08-18 14:32:51	1705060	2022-08-23 23:10:09	\N	\N	0
919	3	1705001	2022-08-18 12:45:31	1705044	2022-08-12 08:22:54	\N	\N	0
922	2	6	2022-08-18 10:10:54	1705060	2022-08-09 14:49:08	\N	\N	0
923	1	7	2022-08-18 09:35:12	1705044	2022-08-15 15:07:07	\N	\N	0
927	1	1705015	2022-08-08 03:01:10	1705044	2022-08-20 01:11:53	\N	\N	0
928	3	1705010	2022-08-13 05:37:44	1705044	2022-08-23 01:08:06	\N	\N	0
929	3	7	2022-08-18 00:56:21	1705044	2022-08-09 14:03:13	\N	\N	0
930	2	1705044	2022-08-23 13:36:35	1705062	2022-08-24 11:42:57	\N	\N	0
934	3	1705017	2022-08-18 05:58:55	1705045	2022-08-10 17:53:46	\N	\N	0
841	2	1705008	2022-08-25 00:47:29	1705045	2022-08-07 16:48:31	\N	\N	0
847	1	1705015	2022-08-10 00:15:28	1705045	2022-08-11 09:18:04	\N	\N	0
849	3	1705017	2022-08-04 04:24:10	1705045	2022-08-05 22:46:32	\N	\N	0
864	3	1705010	2022-08-12 04:24:13	1705045	2022-08-05 18:25:56	\N	\N	0
874	2	1705010	2022-08-18 08:59:26	1705045	2022-08-12 20:43:03	\N	\N	0
880	1	3	2022-08-16 23:36:00	1705045	2022-08-25 02:17:37	\N	\N	0
887	3	3	2022-08-02 07:38:11	1705045	2022-08-10 04:13:59	\N	\N	0
890	2	1705017	2022-08-06 16:13:18	1705045	2022-08-10 20:01:20	\N	\N	0
903	2	3	2022-08-20 04:37:45	1705045	2022-08-24 00:09:36	\N	\N	0
916	2	1705017	2022-08-15 01:04:39	1705045	2022-08-06 07:23:28	\N	\N	0
920	3	1705015	2022-08-19 11:43:37	1705045	2022-08-05 02:34:08	\N	\N	0
935	1	1705010	2022-08-24 18:44:17	1705045	2022-08-06 19:42:45	\N	\N	0
936	1	1705044	2022-08-25 00:46:24	1705062	2022-08-19 17:19:41	\N	\N	0
937	3	1705017	2022-08-10 06:27:18	1705062	2022-08-17 03:48:02	\N	\N	0
976	3	1705005	2022-08-04 19:43:10	1705062	2022-08-17 12:53:17	\N	\N	0
940	2	1705044	2022-08-08 10:42:59	1705062	2022-08-08 12:43:19	\N	\N	0
941	3	1705010	2022-08-17 11:42:39	1705045	2022-08-18 21:14:59	\N	\N	0
943	3	6	2022-08-15 12:42:55	1705045	2022-08-18 08:23:09	\N	\N	0
944	3	4	2022-08-02 07:02:06	1705062	2022-08-16 09:50:24	\N	\N	0
945	1	1705008	2022-08-14 09:55:15	1705044	2022-08-05 03:27:21	\N	\N	0
946	3	1705015	2022-08-10 06:05:26	1705062	2022-08-07 08:06:41	\N	\N	0
947	2	1705017	2022-08-23 01:05:56	1705045	2022-08-11 02:54:55	\N	\N	0
991	2	1705005	2022-08-18 22:12:22	1705045	2022-08-12 00:43:02	\N	\N	0
949	2	1705015	2022-08-10 23:54:54	1705045	2022-08-07 18:08:30	\N	\N	0
950	3	1705044	2022-08-03 05:12:48	1705060	2022-08-19 06:02:19	\N	\N	0
951	2	1705017	2022-08-24 19:12:16	1705062	2022-08-04 21:05:05	\N	\N	0
952	2	1705017	2022-08-22 14:56:01	1705045	2022-08-22 11:22:21	\N	\N	0
953	2	1705010	2022-08-01 22:07:03	1705060	2022-08-02 20:30:02	\N	\N	0
954	3	1705015	2022-08-23 23:57:20	1705045	2022-08-09 05:31:31	\N	\N	0
955	3	1705008	2022-08-04 22:02:38	1705045	2022-08-10 00:33:54	\N	\N	0
956	3	1705017	2022-08-06 02:44:40	1705062	2022-08-05 07:38:19	\N	\N	0
957	2	7	2022-08-16 23:38:44	1705045	2022-08-14 11:27:21	\N	\N	0
1030	1	1705005	2022-08-05 01:32:04	1705062	2022-08-16 10:10:53	\N	\N	0
959	2	1705015	2022-08-02 11:07:18	1705060	2022-08-08 12:32:50	\N	\N	0
968	1	1705005	2022-08-12 01:02:19	1705045	2022-08-22 17:16:15	\N	\N	0
962	1	1705015	2022-08-11 01:48:37	1705060	2022-08-18 09:22:14	\N	\N	0
963	2	3	2022-08-21 03:26:58	1705060	2022-08-19 18:46:41	\N	\N	0
964	3	5	2022-08-22 14:34:44	1705045	2022-08-09 07:50:29	\N	\N	0
967	3	1705010	2022-08-10 05:18:32	1705045	2022-08-24 12:06:45	\N	\N	0
969	1	1705010	2022-08-05 19:58:10	1705060	2022-08-21 22:10:43	\N	\N	0
971	3	1705017	2022-08-19 21:44:00	1705044	2022-08-18 09:59:30	\N	\N	0
972	3	6	2022-08-14 15:55:17	1705044	2022-08-15 08:49:35	\N	\N	0
975	2	1705001	2022-08-02 08:33:30	1705044	2022-08-21 12:03:43	\N	\N	0
977	1	1705017	2022-08-17 19:05:28	1705062	2022-08-14 17:42:57	\N	\N	0
979	3	1705010	2022-08-14 13:39:27	1705045	2022-08-11 12:22:37	\N	\N	0
980	2	1705001	2022-08-08 12:32:37	1705062	2022-08-02 16:17:12	\N	\N	0
981	2	1705010	2022-08-15 04:55:46	1705062	2022-08-03 18:13:42	\N	\N	0
982	3	1705015	2022-08-09 03:05:48	1705060	2022-08-17 20:59:38	\N	\N	0
983	1	1705017	2022-08-07 03:29:07	1705045	2022-08-22 21:40:12	\N	\N	0
985	3	1705008	2022-08-24 16:32:29	1705060	2022-08-19 09:11:56	\N	\N	0
987	1	3	2022-08-06 11:12:37	1705062	2022-08-17 20:05:41	\N	\N	0
988	3	1705008	2022-08-03 14:14:26	1705044	2022-08-19 14:40:05	\N	\N	0
989	1	1705015	2022-08-02 12:47:22	1705060	2022-08-02 00:36:05	\N	\N	0
993	3	3	2022-08-20 11:23:12	1705062	2022-08-04 18:29:10	\N	\N	0
994	2	1705015	2022-08-12 15:24:27	1705045	2022-08-24 15:48:25	\N	\N	0
996	3	7	2022-08-05 10:35:44	1705045	2022-08-12 15:49:52	\N	\N	0
997	3	1705001	2022-08-06 00:42:43	1705060	2022-08-08 07:36:58	\N	\N	0
998	2	4	2022-08-08 13:48:32	1705060	2022-08-24 17:39:25	\N	\N	0
999	1	1705001	2022-08-24 01:58:16	1705044	2022-08-08 21:33:54	\N	\N	0
1000	1	1705016	2022-08-12 23:59:44	1705062	2022-08-15 17:57:39	\N	\N	0
1001	2	4	2022-08-15 14:57:23	1705060	2022-08-09 09:12:51	\N	\N	0
1004	2	1705015	2022-08-12 09:11:54	1705045	2022-08-24 15:13:38	\N	\N	0
1006	1	4	2022-08-01 21:02:48	1705044	2022-08-14 02:06:05	\N	\N	0
1007	3	5	2022-08-11 01:32:31	1705062	2022-08-19 17:18:20	\N	\N	0
1009	1	3	2022-08-03 15:14:02	1705044	2022-08-07 21:37:35	\N	\N	0
1010	2	3	2022-08-13 22:24:38	1705044	2022-08-22 17:33:51	\N	\N	0
1011	2	1705016	2022-08-22 12:03:12	1705060	2022-08-03 16:43:55	\N	\N	0
1012	1	3	2022-08-20 14:07:27	1705044	2022-08-20 00:51:17	\N	\N	0
1014	2	1705016	2022-08-25 03:28:41	1705062	2022-08-15 21:13:06	\N	\N	0
1015	2	1705010	2022-08-21 05:59:47	1705045	2022-08-14 01:42:03	\N	\N	0
1016	3	1705010	2022-08-15 05:07:43	1705060	2022-08-06 02:09:44	\N	\N	0
1020	3	1705044	2022-08-14 13:31:07	1705062	2022-08-04 08:20:19	\N	\N	0
1021	2	5	2022-08-20 08:27:11	1705060	2022-08-24 03:05:07	\N	\N	0
1023	1	1705015	2022-08-06 22:43:10	1705045	2022-08-17 01:30:01	\N	\N	0
1024	2	1705016	2022-08-04 13:08:51	1705045	2022-08-10 23:29:55	\N	\N	0
1026	1	1705017	2022-08-18 23:31:37	1705045	2022-08-22 09:38:15	\N	\N	0
1027	3	7	2022-08-14 06:59:44	1705044	2022-08-12 14:45:25	\N	\N	0
1028	3	1705044	2022-08-05 21:33:47	1705060	2022-08-23 08:49:12	\N	\N	0
1031	3	1705016	2022-08-13 07:54:42	1705060	2022-08-07 22:51:10	\N	\N	0
938	3	1705017	2022-08-19 10:39:51	1705045	2022-08-13 07:13:21	\N	\N	0
942	2	3	2022-08-01 14:20:55	1705045	2022-08-11 12:36:12	\N	\N	0
965	2	1705016	2022-08-20 21:36:17	1705045	2022-08-09 19:08:34	\N	\N	0
970	2	1705010	2022-08-02 23:17:25	1705045	2022-08-03 21:51:51	\N	\N	0
974	2	4	2022-08-19 13:22:02	1705045	2022-08-22 14:27:44	\N	\N	0
978	1	6	2022-08-17 21:11:07	1705045	2022-08-12 04:07:59	\N	\N	0
990	2	1705044	2022-08-09 00:55:41	1705045	2022-08-10 16:08:11	\N	\N	0
1003	2	1705044	2022-08-10 15:35:45	1705045	2022-08-20 20:58:52	\N	\N	0
1008	1	3	2022-08-14 08:41:08	1705045	2022-08-23 19:43:06	\N	\N	0
1019	2	1705017	2022-08-17 07:26:14	1705045	2022-08-20 14:45:34	\N	\N	0
1025	1	7	2022-08-20 00:15:04	1705045	2022-08-22 15:41:53	\N	\N	0
1029	1	4	2022-08-05 07:33:34	1705045	2022-08-20 08:59:33	\N	\N	0
1033	3	6	2022-08-24 05:22:48	1705045	2022-08-13 02:26:18	\N	\N	0
1034	2	6	2022-08-18 17:01:00	1705045	2022-08-04 20:03:43	\N	\N	0
1032	1	1705005	2022-08-06 13:38:09	1705062	2022-08-04 23:56:59	\N	\N	0
1037	3	3	2022-08-15 09:57:03	1705062	2022-08-14 06:17:23	\N	\N	0
1036	2	1705005	2022-08-15 19:10:43	1705044	2022-08-09 12:56:06	\N	\N	0
1043	3	1705005	2022-08-24 17:19:28	1705044	2022-08-07 03:57:45	\N	\N	0
1041	1	1705008	2022-08-17 01:03:55	1705060	2022-08-11 03:45:18	\N	\N	0
1042	1	7	2022-08-10 16:44:30	1705060	2022-08-07 00:35:45	\N	\N	0
1045	1	5	2022-08-05 00:17:27	1705060	2022-08-15 02:51:23	\N	\N	0
1044	1	1705005	2022-08-17 10:02:37	1705045	2022-08-17 06:39:26	\N	\N	0
1046	2	1705005	2022-08-21 22:04:50	1705062	2022-08-24 15:34:06	\N	\N	0
1051	3	4	2022-08-21 20:22:15	1705060	2022-08-14 01:28:51	\N	\N	0
1053	1	3	2022-08-11 02:24:28	1705060	2022-08-23 19:20:30	\N	\N	0
1047	3	1705005	2022-08-02 00:39:55	1705060	2022-08-05 22:21:08	\N	\N	0
1057	1	1705044	2022-08-14 09:21:39	1705062	2022-08-08 03:00:10	\N	\N	0
1058	2	4	2022-08-13 06:43:24	1705062	2022-08-01 22:44:35	\N	\N	0
1060	2	1705015	2022-08-02 18:34:55	1705045	2022-08-16 16:35:51	\N	\N	0
1061	2	1705016	2022-08-24 02:51:53	1705044	2022-08-22 23:44:37	\N	\N	0
1063	2	1705044	2022-08-11 04:43:11	1705044	2022-08-10 21:30:36	\N	\N	0
1064	1	5	2022-08-05 01:34:51	1705044	2022-08-18 23:01:52	\N	\N	0
1065	3	6	2022-08-04 18:05:07	1705045	2022-08-06 10:34:49	\N	\N	0
1067	1	1705008	2022-08-11 20:03:00	1705060	2022-08-13 11:25:39	\N	\N	0
1068	2	4	2022-08-21 06:34:43	1705045	2022-08-08 03:16:05	\N	\N	0
1073	2	1705005	2022-08-18 18:37:19	1705044	2022-08-14 12:03:42	\N	\N	0
174	3	1705005	2022-08-22 03:55:37	1705062	2022-08-19 19:14:16	\N	\N	0
1072	1	1705044	2022-08-08 20:24:55	1705062	2022-08-01 19:32:28	\N	\N	0
1076	3	5	2022-08-14 07:10:40	1705062	2022-08-24 20:56:47	\N	\N	0
1077	1	1705010	2022-08-11 10:35:01	1705044	2022-08-14 14:39:43	\N	\N	0
1079	3	4	2022-08-23 10:02:24	1705045	2022-08-22 10:33:55	\N	\N	0
1080	1	1705008	2022-08-16 17:31:13	1705062	2022-08-09 10:01:55	\N	\N	0
1081	3	6	2022-08-24 02:01:28	1705045	2022-08-14 05:51:19	\N	\N	0
1082	3	1705010	2022-08-17 23:05:37	1705045	2022-08-24 06:10:00	\N	\N	0
1083	1	1705001	2022-08-21 21:35:03	1705045	2022-08-19 06:37:34	\N	\N	0
1087	3	1705008	2022-08-07 21:11:28	1705045	2022-08-14 17:40:39	\N	\N	0
1088	3	1705016	2022-08-25 03:21:00	1705060	2022-08-21 19:15:13	\N	\N	0
1089	3	1705016	2022-08-21 20:40:24	1705045	2022-08-23 02:56:38	\N	\N	0
1090	3	1705008	2022-08-18 09:02:03	1705062	2022-08-13 17:03:24	\N	\N	0
1091	1	1705015	2022-08-10 10:54:21	1705060	2022-08-11 12:48:36	\N	\N	0
1092	1	5	2022-08-16 22:55:12	1705044	2022-08-11 16:48:43	\N	\N	0
1093	1	1705010	2022-08-17 21:36:22	1705062	2022-08-06 19:30:00	\N	\N	0
1094	3	4	2022-08-03 16:48:09	1705062	2022-08-23 08:27:27	\N	\N	0
1095	1	3	2022-08-10 17:01:56	1705060	2022-08-09 00:11:11	\N	\N	0
1096	1	1705017	2022-08-02 22:14:36	1705045	2022-08-05 21:35:15	\N	\N	0
1097	1	7	2022-08-14 10:35:35	1705045	2022-08-04 17:20:09	\N	\N	0
150	3	1705008	2022-08-16 09:20:01	1705062	2022-08-18 22:09:40	\N	\N	0
100	1	3	2022-08-08 05:05:39	1705062	2022-08-24 20:06:52	\N	\N	0
103	2	7	2022-08-02 03:15:24	1705062	2022-08-02 17:43:31	\N	\N	0
111	3	1705015	2022-08-05 09:29:46	1705062	2022-08-17 19:17:00	\N	\N	0
121	1	5	2022-08-02 08:42:32	1705062	2022-08-21 04:02:47	\N	\N	0
127	3	1705044	2022-08-18 15:15:18	1705062	2022-08-19 06:21:01	\N	\N	0
160	2	5	2022-08-07 22:22:25	1705062	2022-08-03 20:37:59	\N	\N	0
161	3	5	2022-08-08 07:47:10	1705062	2022-08-12 03:26:32	\N	\N	0
162	3	1705008	2022-08-06 01:45:52	1705062	2022-08-22 05:17:21	\N	\N	0
165	2	1705008	2022-08-07 02:28:43	1705062	2022-08-10 05:51:19	\N	\N	0
168	1	1705016	2022-08-18 16:42:10	1705062	2022-08-04 19:14:58	\N	\N	0
233	3	4	2022-08-18 04:51:39	1705062	2022-08-17 06:08:39	\N	\N	0
241	2	3	2022-08-19 08:56:49	1705062	2022-08-15 18:15:08	\N	\N	0
175	3	1705015	2022-08-13 21:39:08	1705062	2022-08-08 09:53:51	\N	\N	0
182	2	4	2022-08-13 07:04:13	1705062	2022-08-04 07:40:09	\N	\N	0
192	1	6	2022-08-21 03:09:40	1705062	2022-08-24 16:02:44	\N	\N	0
195	2	1705017	2022-08-05 13:14:39	1705062	2022-08-20 15:57:22	\N	\N	0
199	1	1705008	2022-08-08 09:52:36	1705062	2022-08-17 08:49:23	\N	\N	0
204	2	3	2022-08-13 02:44:28	1705062	2022-08-24 13:34:45	\N	\N	0
214	1	1705017	2022-08-19 03:33:49	1705062	2022-08-12 17:55:56	\N	\N	0
226	3	1705015	2022-08-10 21:06:28	1705062	2022-08-22 03:46:34	\N	\N	0
247	1	1705008	2022-08-13 17:57:41	1705062	2022-08-11 07:42:38	\N	\N	0
248	3	1705010	2022-08-01 21:17:32	1705062	2022-08-14 02:00:27	\N	\N	0
250	2	6	2022-08-06 09:26:04	1705062	2022-08-11 09:24:03	\N	\N	0
258	2	1705017	2022-08-20 14:29:40	1705062	2022-08-08 18:00:46	\N	\N	0
262	1	1705015	2022-08-22 16:21:42	1705062	2022-08-03 14:01:08	\N	\N	0
264	2	6	2022-08-09 23:38:21	1705062	2022-08-08 20:22:13	\N	\N	0
272	1	3	2022-08-24 16:36:08	1705062	2022-08-20 20:04:47	\N	\N	0
275	3	3	2022-08-02 08:42:33	1705062	2022-08-22 12:29:21	\N	\N	0
279	2	6	2022-08-24 08:57:36	1705062	2022-08-15 10:53:32	\N	\N	0
1038	2	1705008	2022-08-01 18:15:47	1705045	2022-08-13 08:37:24	\N	\N	0
1048	3	1705017	2022-08-14 08:26:38	1705045	2022-08-21 19:02:13	\N	\N	0
1052	3	5	2022-08-22 13:32:02	1705045	2022-08-19 17:52:57	\N	\N	0
1054	3	5	2022-08-12 20:08:53	1705045	2022-08-14 11:03:57	\N	\N	0
1055	1	1705044	2022-08-10 07:52:27	1705045	2022-08-05 21:12:33	\N	\N	0
1059	1	1705015	2022-08-04 10:35:51	1705045	2022-08-12 14:56:49	\N	\N	0
1062	3	1705015	2022-08-03 20:48:30	1705045	2022-08-04 01:39:12	\N	\N	0
1066	2	4	2022-08-16 16:11:20	1705045	2022-08-07 22:13:44	\N	\N	0
1069	3	5	2022-08-14 19:33:20	1705045	2022-08-18 00:34:47	\N	\N	0
302	3	5	2022-08-15 20:21:47	1705062	2022-08-21 05:51:15	\N	\N	0
313	3	1705001	2022-08-08 01:17:58	1705062	2022-08-16 06:51:08	\N	\N	0
326	2	1705008	2022-08-15 22:47:42	1705062	2022-08-13 02:48:30	\N	\N	0
329	1	1705010	2022-08-15 00:44:22	1705062	2022-08-05 05:47:42	\N	\N	0
338	1	1705010	2022-08-19 22:35:25	1705062	2022-08-05 01:01:30	\N	\N	0
347	3	7	2022-08-17 20:54:33	1705062	2022-08-05 07:53:52	\N	\N	0
348	3	5	2022-08-15 11:35:42	1705062	2022-08-21 20:17:06	\N	\N	0
355	2	1705001	2022-08-24 04:10:04	1705062	2022-08-08 17:42:44	\N	\N	0
358	3	1705044	2022-08-14 16:11:36	1705062	2022-08-22 21:55:51	\N	\N	0
367	3	1705015	2022-08-06 00:46:28	1705062	2022-08-01 20:01:45	\N	\N	0
378	3	1705044	2022-08-15 08:17:54	1705062	2022-08-04 03:21:46	\N	\N	0
383	1	1705010	2022-08-09 09:59:06	1705062	2022-08-10 09:20:02	\N	\N	0
389	2	1705010	2022-08-15 02:38:11	1705062	2022-08-20 01:54:51	\N	\N	0
391	1	1705010	2022-08-02 01:28:40	1705062	2022-08-22 12:28:49	\N	\N	0
393	1	4	2022-08-12 12:05:53	1705062	2022-08-10 14:52:23	\N	\N	0
396	2	6	2022-08-04 02:40:53	1705062	2022-08-05 22:04:12	\N	\N	0
406	3	1705001	2022-08-09 11:07:20	1705062	2022-08-24 23:09:39	\N	\N	0
416	2	7	2022-08-14 19:31:28	1705062	2022-08-09 05:25:49	\N	\N	0
417	1	1705001	2022-08-11 23:02:30	1705062	2022-08-12 22:54:12	\N	\N	0
420	1	5	2022-08-13 05:38:20	1705062	2022-08-20 13:36:40	\N	\N	0
422	1	1705001	2022-08-05 18:39:41	1705062	2022-08-02 16:53:34	\N	\N	0
425	3	7	2022-08-21 01:26:43	1705062	2022-08-06 23:02:19	\N	\N	0
446	3	6	2022-08-05 05:01:41	1705062	2022-08-14 21:15:27	\N	\N	0
452	3	6	2022-08-13 23:23:29	1705062	2022-08-17 10:29:10	\N	\N	0
470	2	5	2022-08-14 01:25:10	1705062	2022-08-05 12:10:07	\N	\N	0
472	1	6	2022-08-12 01:22:58	1705062	2022-08-03 03:11:32	\N	\N	0
474	3	4	2022-08-03 11:45:27	1705062	2022-08-23 14:01:11	\N	\N	0
480	3	5	2022-08-03 16:47:11	1705062	2022-08-24 00:23:23	\N	\N	0
484	2	1705001	2022-08-04 07:34:12	1705062	2022-08-03 18:10:05	\N	\N	0
485	2	5	2022-08-23 15:02:31	1705062	2022-08-18 17:02:46	\N	\N	0
497	1	1705001	2022-08-01 15:49:47	1705062	2022-08-19 08:30:37	\N	\N	0
503	2	5	2022-08-01 18:18:36	1705062	2022-08-09 12:48:23	\N	\N	0
510	1	1705015	2022-08-12 02:19:18	1705062	2022-08-05 08:01:37	\N	\N	0
514	2	1705008	2022-08-21 16:23:21	1705062	2022-08-16 01:48:20	\N	\N	0
516	1	1705015	2022-08-11 15:15:20	1705062	2022-08-15 02:11:00	\N	\N	0
531	2	1705017	2022-08-21 04:17:23	1705062	2022-08-14 09:01:17	\N	\N	0
532	1	1705044	2022-08-02 18:11:00	1705062	2022-08-18 17:11:35	\N	\N	0
533	3	4	2022-08-02 09:28:02	1705062	2022-08-11 05:00:50	\N	\N	0
536	1	1705017	2022-08-20 03:52:05	1705062	2022-08-18 05:00:36	\N	\N	0
537	1	1705008	2022-08-03 23:30:54	1705062	2022-08-22 05:02:54	\N	\N	0
539	1	7	2022-08-19 12:41:22	1705062	2022-08-11 13:07:28	\N	\N	0
550	2	7	2022-08-17 13:26:00	1705062	2022-08-16 13:19:54	\N	\N	0
551	2	1705016	2022-08-24 20:04:29	1705062	2022-08-17 18:45:34	\N	\N	0
555	1	1705044	2022-08-23 20:49:26	1705062	2022-08-12 18:11:15	\N	\N	0
561	1	3	2022-08-11 18:21:01	1705062	2022-08-13 06:51:27	\N	\N	0
570	2	1705015	2022-08-10 00:56:55	1705062	2022-08-14 06:42:33	\N	\N	0
582	3	7	2022-08-10 10:48:41	1705062	2022-08-18 22:42:42	\N	\N	0
584	3	1705010	2022-08-08 19:56:20	1705062	2022-08-09 08:25:20	\N	\N	0
589	1	1705017	2022-08-16 00:23:56	1705062	2022-08-15 05:54:41	\N	\N	0
590	3	5	2022-08-13 21:17:04	1705062	2022-08-11 09:20:36	\N	\N	0
591	3	1705017	2022-08-07 11:33:20	1705062	2022-08-19 23:31:47	\N	\N	0
598	2	1705010	2022-08-16 08:17:59	1705062	2022-08-16 20:11:24	\N	\N	0
599	2	7	2022-08-11 21:29:53	1705062	2022-08-19 06:17:05	\N	\N	0
603	1	1705017	2022-08-11 00:04:00	1705062	2022-08-14 04:46:42	\N	\N	0
604	2	6	2022-08-12 11:04:58	1705062	2022-08-02 22:12:21	\N	\N	0
608	2	6	2022-08-25 04:00:07	1705062	2022-08-08 02:28:35	\N	\N	0
621	2	5	2022-08-14 23:05:57	1705062	2022-08-13 19:24:11	\N	\N	0
622	1	1705008	2022-08-09 20:37:37	1705062	2022-08-18 03:13:46	\N	\N	0
641	3	3	2022-08-11 23:50:59	1705062	2022-08-03 12:53:07	\N	\N	0
646	3	1705008	2022-08-11 06:40:22	1705062	2022-08-18 02:04:53	\N	\N	0
657	1	1705044	2022-08-16 23:16:04	1705062	2022-08-20 03:14:18	\N	\N	0
660	3	1705008	2022-08-13 01:11:09	1705062	2022-08-06 12:23:18	\N	\N	0
662	3	1705044	2022-08-03 18:05:24	1705062	2022-08-22 19:19:27	\N	\N	0
664	3	1705044	2022-08-08 02:52:07	1705062	2022-08-12 09:46:16	\N	\N	0
667	2	1705044	2022-08-14 23:44:58	1705062	2022-08-13 22:58:24	\N	\N	0
678	1	1705008	2022-08-06 10:05:58	1705062	2022-08-14 21:07:53	\N	\N	0
688	2	1705001	2022-08-09 02:20:58	1705062	2022-08-15 11:48:44	\N	\N	0
698	1	1705008	2022-08-06 00:42:45	1705062	2022-08-03 04:31:54	\N	\N	0
699	1	1705044	2022-08-15 05:57:41	1705062	2022-08-08 17:08:59	\N	\N	0
703	3	1705016	2022-08-10 18:22:21	1705062	2022-08-06 18:12:13	\N	\N	0
704	2	1705017	2022-08-15 12:14:40	1705062	2022-08-08 15:48:30	\N	\N	0
730	2	4	2022-08-18 21:34:52	1705062	2022-08-10 06:49:51	\N	\N	0
737	1	1705016	2022-08-04 16:52:11	1705062	2022-08-12 09:59:02	\N	\N	0
739	2	7	2022-08-01 20:53:42	1705062	2022-08-12 00:12:59	\N	\N	0
745	1	5	2022-08-14 11:17:39	1705062	2022-08-06 01:43:27	\N	\N	0
757	2	1705017	2022-08-19 13:18:32	1705062	2022-08-07 13:02:44	\N	\N	0
764	1	1705044	2022-08-24 01:16:52	1705062	2022-08-05 02:46:30	\N	\N	0
767	1	5	2022-08-22 14:13:31	1705062	2022-08-04 09:13:06	\N	\N	0
774	3	1705017	2022-08-18 15:09:18	1705062	2022-08-23 18:20:44	\N	\N	0
783	3	3	2022-08-12 15:31:14	1705062	2022-08-06 10:31:57	\N	\N	0
793	2	5	2022-08-07 00:40:58	1705062	2022-08-17 06:10:29	\N	\N	0
799	2	1705015	2022-08-19 23:59:53	1705062	2022-08-03 14:30:40	\N	\N	0
801	3	6	2022-08-16 14:33:00	1705062	2022-08-07 11:37:05	\N	\N	0
802	3	7	2022-08-19 07:26:02	1705062	2022-08-16 07:47:14	\N	\N	0
804	1	1705008	2022-08-06 23:09:40	1705062	2022-08-06 00:39:22	\N	\N	0
810	3	1705044	2022-08-25 01:59:44	1705062	2022-08-09 10:49:04	\N	\N	0
816	2	5	2022-08-21 22:40:36	1705062	2022-08-06 05:57:41	\N	\N	0
818	2	1705008	2022-08-20 19:04:49	1705062	2022-08-03 22:01:06	\N	\N	0
819	1	1705008	2022-08-21 05:56:05	1705062	2022-08-02 17:35:49	\N	\N	0
824	2	1705017	2022-08-15 12:50:03	1705062	2022-08-01 16:54:14	\N	\N	0
825	3	1705010	2022-08-06 11:32:24	1705062	2022-08-20 12:22:14	\N	\N	0
829	3	5	2022-08-08 19:00:50	1705062	2022-08-11 20:09:11	\N	\N	0
830	1	4	2022-08-17 21:31:21	1705062	2022-08-18 11:32:17	\N	\N	0
839	2	1705044	2022-08-04 17:32:59	1705062	2022-08-25 05:02:38	\N	\N	0
851	1	6	2022-08-12 21:10:21	1705062	2022-08-10 13:34:41	\N	\N	0
855	2	7	2022-08-10 21:06:59	1705062	2022-08-01 21:15:23	\N	\N	0
876	3	7	2022-08-19 00:44:48	1705062	2022-08-23 12:59:05	\N	\N	0
883	1	1705044	2022-08-02 00:21:13	1705062	2022-08-16 08:15:18	\N	\N	0
885	1	1705001	2022-08-16 12:16:41	1705062	2022-08-18 11:51:31	\N	\N	0
886	3	1705008	2022-08-06 18:18:10	1705062	2022-08-17 12:08:43	\N	\N	0
888	2	1705008	2022-08-13 16:36:15	1705062	2022-08-02 10:43:56	\N	\N	0
912	2	1705044	2022-08-18 00:36:19	1705062	2022-08-04 02:48:57	\N	\N	0
915	3	4	2022-08-09 10:17:08	1705062	2022-08-07 00:38:16	\N	\N	0
924	3	4	2022-08-14 17:25:40	1705062	2022-08-17 17:14:10	\N	\N	0
925	3	1705016	2022-08-04 14:05:21	1705062	2022-08-02 20:26:54	\N	\N	0
931	2	4	2022-08-19 05:05:49	1705062	2022-08-02 09:55:07	\N	\N	0
948	3	1705015	2022-08-11 16:50:39	1705062	2022-08-17 20:03:43	\N	\N	0
960	2	7	2022-08-10 20:29:18	1705062	2022-08-05 02:54:02	\N	\N	0
961	2	1705016	2022-08-02 23:24:21	1705062	2022-08-20 04:55:56	\N	\N	0
966	3	1705044	2022-08-15 22:11:59	1705062	2022-08-22 06:06:33	\N	\N	0
973	2	1705008	2022-08-13 10:46:44	1705062	2022-08-20 03:00:26	\N	\N	0
984	3	3	2022-08-13 23:46:40	1705062	2022-08-01 16:23:28	\N	\N	0
986	3	1705001	2022-08-02 15:46:24	1705062	2022-08-20 22:49:12	\N	\N	0
992	1	5	2022-08-06 11:59:38	1705062	2022-08-05 15:54:56	\N	\N	0
995	3	1705001	2022-08-11 01:08:10	1705062	2022-08-03 15:35:36	\N	\N	0
1002	1	1705016	2022-08-11 10:46:17	1705062	2022-08-10 08:24:18	\N	\N	0
1005	3	1705016	2022-08-16 10:56:35	1705062	2022-08-18 09:00:28	\N	\N	0
1013	1	4	2022-08-08 01:12:04	1705062	2022-08-24 06:11:04	\N	\N	0
1017	1	1705017	2022-08-24 22:06:51	1705062	2022-08-09 12:34:00	\N	\N	0
1018	2	1705017	2022-08-09 21:26:48	1705062	2022-08-21 07:38:31	\N	\N	0
1022	2	6	2022-08-13 15:20:37	1705062	2022-08-14 13:40:42	\N	\N	0
1035	3	1705010	2022-08-22 17:16:12	1705062	2022-08-22 03:03:05	\N	\N	0
1039	1	1705016	2022-08-03 14:03:53	1705062	2022-08-19 08:48:00	\N	\N	0
1040	2	3	2022-08-14 05:53:17	1705062	2022-08-06 09:15:43	\N	\N	0
1049	2	3	2022-08-21 09:34:58	1705062	2022-08-08 06:18:32	\N	\N	0
1050	2	6	2022-08-18 13:22:42	1705062	2022-08-21 23:14:39	\N	\N	0
1056	2	7	2022-08-04 16:51:00	1705062	2022-08-02 07:48:26	\N	\N	0
1071	1	7	2022-08-23 17:42:01	1705062	2022-08-13 20:31:24	\N	\N	0
1075	1	6	2022-08-05 20:55:14	1705062	2022-08-16 03:07:46	\N	\N	0
1085	3	1705017	2022-08-22 01:31:19	1705062	2022-08-18 05:05:36	\N	\N	0
1086	3	1705001	2022-08-22 14:15:40	1705062	2022-08-14 19:06:02	\N	\N	0
130	2	1705016	2022-08-10 08:34:18	1705045	2022-08-04 09:13:10	\N	\N	0
308	3	1705016	2022-08-14 01:42:59	1705045	2022-08-21 12:11:17	\N	\N	0
312	3	1705017	2022-08-03 03:37:25	1705045	2022-08-17 08:41:41	\N	\N	0
314	3	1705016	2022-08-16 01:52:09	1705045	2022-08-15 04:56:45	\N	\N	0
318	1	3	2022-08-20 07:06:25	1705045	2022-08-13 16:42:17	\N	\N	0
323	2	1705017	2022-08-09 22:42:40	1705045	2022-08-12 02:30:20	\N	\N	0
331	3	1705044	2022-08-14 16:41:19	1705045	2022-08-21 15:19:21	\N	\N	0
337	2	4	2022-08-11 18:19:14	1705045	2022-08-20 06:07:47	\N	\N	0
342	3	7	2022-08-14 14:15:41	1705045	2022-08-09 11:15:06	\N	\N	0
345	3	5	2022-08-05 23:24:52	1705045	2022-08-07 02:38:12	\N	\N	0
350	1	3	2022-08-06 14:27:37	1705045	2022-08-20 08:22:58	\N	\N	0
545	1	7	2022-08-23 10:48:57	1705045	2022-08-03 17:37:57	\N	\N	0
620	2	1705001	2022-08-20 06:19:50	1705045	2022-08-20 20:23:17	\N	\N	0
623	2	7	2022-08-15 18:15:33	1705045	2022-08-09 05:35:46	\N	\N	0
627	1	6	2022-08-04 06:11:48	1705045	2022-08-22 00:26:51	\N	\N	0
628	2	6	2022-08-16 19:04:07	1705045	2022-08-07 16:11:00	\N	\N	0
632	2	1705044	2022-08-05 00:10:15	1705045	2022-08-11 17:36:49	\N	\N	0
633	2	3	2022-08-23 01:12:47	1705045	2022-08-07 11:56:59	\N	\N	0
636	3	1705015	2022-08-21 17:09:16	1705045	2022-08-07 18:24:33	\N	\N	0
638	1	1705017	2022-08-12 21:05:19	1705045	2022-08-18 16:28:42	\N	\N	0
639	2	1705017	2022-08-13 08:20:43	1705045	2022-08-07 02:59:51	\N	\N	0
640	3	4	2022-08-09 05:51:39	1705045	2022-08-14 14:25:31	\N	\N	0
734	1	1705008	2022-08-06 15:14:03	1705045	2022-08-18 01:58:15	\N	\N	0
740	2	1705010	2022-08-20 00:33:08	1705045	2022-08-10 17:36:18	\N	\N	0
932	1	6	2022-08-12 09:45:29	1705045	2022-08-12 10:57:35	\N	\N	0
1070	1	1705017	2022-08-10 20:26:47	1705045	2022-08-18 02:10:55	\N	\N	0
1074	3	3	2022-08-10 16:25:54	1705045	2022-08-03 07:02:32	\N	\N	0
1078	2	1705016	2022-08-08 13:39:04	1705045	2022-08-16 05:17:17	\N	\N	0
1084	2	1705017	2022-08-01 15:39:55	1705045	2022-08-07 04:05:21	\N	\N	0
892	1	1705005	2022-08-16 09:18:18	1705062	2022-08-12 05:48:25	\N	\N	0
939	3	1705005	2022-08-05 02:49:10	1705062	2022-08-18 13:51:35	\N	\N	0
958	1	1705005	2022-08-06 03:01:45	1705062	2022-08-12 10:02:02	\N	\N	0
303	3	1705005	2022-08-14 12:48:38	1705045	2022-08-05 09:20:26	\N	\N	0
921	1	1705005	2022-08-08 13:08:36	1705045	2022-08-20 11:52:46	\N	\N	0
\.


--
-- Data for Name: tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tests (test_id, name, description, created_at, psychiatrist_id_of_added_by) FROM stdin;
2	LEVEL 2—Depression—Adult	Are you depressed for any recent happenings aroung you? 	2022-07-14 15:12:44	1705044
1	DSM-5 Level 1 Cross-Cutting Symptom Measure	The questions below ask about things that might have bothered you.For each question, circle the number that bestdescribes how much (or how often) you have been bothered by each problem during the past TWO (2) WEEKS.	2022-07-14 15:12:32	1705060
4548	The Personality Inventory for DSM-5	We are interested in how you would describe yourself. We’d like you to take your time and read each statement carefully, selecting the response that best describes you.	2022-07-26 03:13:10	1705060
4	LEVEL 2—Substance Use—Adult	During the past TWO (2) WEEKS, about how often did you use any of the following medicines ON YOUR OWN, that is, without a doctor’s prescription, in greater amounts or longer than prescribed? 	2022-07-26 03:31:47	1705060
5	LEVEL 2—Repetitive Thoughts and Behaviors	The questions below ask about these feelings in more detail and especially how often you have been bothered by a list of symptoms during the past 7 days. 	2022-08-26 03:41:34	1705060
6	LEVEL 2—Sleep Disturbance	The questions below ask about these feelings in more detail and especially how often you (the individual receiving care) have been bothered by a list of symptoms during the past 7 days.	2022-08-26 03:48:53	1705060
7	Severity of Posttraumatic Stress Symptoms—	How much have you been bothered during the PAST SEVEN (7) DAYS by each of the following problems that occurred or became worse after an extremely stressful event/experience?	2022-08-26 04:01:25	1705045
3	LEVEL 2—Anger—Adult	The questions below ask about these feelings in more detail and especially how often you (the individual receiving care) have been bothered by a list of symptoms during the past 7 days. 	2022-07-16 00:50:22	1705044
\.


--
-- Name: awards_award_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.awards_award_id_seq', 4, true);


--
-- Name: consultation_request_consultation_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consultation_request_consultation_request_id_seq', 35, true);


--
-- Name: counselling_suggestion_counsel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.counselling_suggestion_counsel_id_seq', 16, true);


--
-- Name: degrees_degree_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.degrees_degree_id_seq', 6, true);


--
-- Name: diseases_disease_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.diseases_disease_id_seq', 9, true);


--
-- Name: file_requests_file_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.file_requests_file_request_id_seq', 11, true);


--
-- Name: file_uploads_file_upload_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.file_uploads_file_upload_id_seq', 18, true);


--
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_notification_id_seq', 38, true);


--
-- Name: options_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.options_option_id_seq', 446, true);


--
-- Name: persons_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persons_person_id_seq', 8, true);


--
-- Name: questions_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_question_id_seq', 89, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- Name: test_results_test_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_results_test_result_id_seq', 1098, true);


--
-- Name: tests_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tests_test_id_seq', 4, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: answer answer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_pkey PRIMARY KEY (test_result_id, option_id);


--
-- Name: awards awards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.awards
    ADD CONSTRAINT awards_pkey PRIMARY KEY (award_id);


--
-- Name: consultation_request consultation_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultation_request
    ADD CONSTRAINT consultation_request_pkey PRIMARY KEY (consultation_request_id);


--
-- Name: counselling_suggestion counselling_suggestion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.counselling_suggestion
    ADD CONSTRAINT counselling_suggestion_pkey PRIMARY KEY (counsel_id);


--
-- Name: degrees degrees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degrees
    ADD CONSTRAINT degrees_pkey PRIMARY KEY (degree_id);


--
-- Name: diseases diseases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diseases
    ADD CONSTRAINT diseases_pkey PRIMARY KEY (disease_id);


--
-- Name: file_requests file_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_requests
    ADD CONSTRAINT file_requests_pkey PRIMARY KEY (file_request_id);


--
-- Name: file_uploads file_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_uploads
    ADD CONSTRAINT file_uploads_pkey PRIMARY KEY (file_upload_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: options options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_pkey PRIMARY KEY (option_id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (patient_id);


--
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (person_id);


--
-- Name: psychiatrist_award psychiatrist_award_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrist_award
    ADD CONSTRAINT psychiatrist_award_pkey PRIMARY KEY (psychiatrist_id, award_id);


--
-- Name: psychiatrist_degree psychiatrist_degree_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrist_degree
    ADD CONSTRAINT psychiatrist_degree_pkey PRIMARY KEY (psychiatrist_id, degree_id);


--
-- Name: psychiatrist_disease psychiatrist_disease_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrist_disease
    ADD CONSTRAINT psychiatrist_disease_pkey PRIMARY KEY (psychiatrist_id, disease_id);


--
-- Name: psychiatrists psychiatrists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrists
    ADD CONSTRAINT psychiatrists_pkey PRIMARY KEY (psychiatrist_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- Name: review_board_member review_board_member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_board_member
    ADD CONSTRAINT review_board_member_pkey PRIMARY KEY (board_member_id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: test_question test_question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_question
    ADD CONSTRAINT test_question_pkey PRIMARY KEY (test_id, question_id);


--
-- Name: test_result_disease test_result_disease_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_result_disease
    ADD CONSTRAINT test_result_disease_pkey PRIMARY KEY (test_result_id, disease_id);


--
-- Name: test_results test_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_pkey PRIMARY KEY (test_result_id);


--
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (test_id);


--
-- Name: answer answer_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_option_id_fkey FOREIGN KEY (option_id) REFERENCES public.options(option_id) ON DELETE CASCADE;


--
-- Name: answer answer_test_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_test_result_id_fkey FOREIGN KEY (test_result_id) REFERENCES public.test_results(test_result_id);


--
-- Name: consultation_request consultation_request_test_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultation_request
    ADD CONSTRAINT consultation_request_test_result_id_fkey FOREIGN KEY (test_result_id) REFERENCES public.test_results(test_result_id);


--
-- Name: counselling_suggestion counselling_suggestion_psychiatrist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.counselling_suggestion
    ADD CONSTRAINT counselling_suggestion_psychiatrist_id_fkey FOREIGN KEY (psychiatrist_id) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- Name: counselling_suggestion counselling_suggestion_test_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.counselling_suggestion
    ADD CONSTRAINT counselling_suggestion_test_result_id_fkey FOREIGN KEY (test_result_id) REFERENCES public.test_results(test_result_id);


--
-- Name: file_requests file_requests_psychiatrist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_requests
    ADD CONSTRAINT file_requests_psychiatrist_id_fkey FOREIGN KEY (psychiatrist_id) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- Name: file_uploads file_uploads_file_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_uploads
    ADD CONSTRAINT file_uploads_file_request_id_fkey FOREIGN KEY (file_request_id) REFERENCES public.file_requests(file_request_id);


--
-- Name: file_uploads file_uploads_uploader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_uploads
    ADD CONSTRAINT file_uploads_uploader_id_fkey FOREIGN KEY (uploader_id) REFERENCES public.patients(patient_id);


--
-- Name: notifications notifications_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(person_id);


--
-- Name: options options_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- Name: patients patients_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.persons(person_id);


--
-- Name: psychiatrist_award psychiatrist_award_award_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrist_award
    ADD CONSTRAINT psychiatrist_award_award_id_fkey FOREIGN KEY (award_id) REFERENCES public.awards(award_id);


--
-- Name: psychiatrist_award psychiatrist_award_psychiatrist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrist_award
    ADD CONSTRAINT psychiatrist_award_psychiatrist_id_fkey FOREIGN KEY (psychiatrist_id) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- Name: psychiatrist_degree psychiatrist_degree_degree_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrist_degree
    ADD CONSTRAINT psychiatrist_degree_degree_id_fkey FOREIGN KEY (degree_id) REFERENCES public.degrees(degree_id);


--
-- Name: psychiatrist_degree psychiatrist_degree_psychiatrist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrist_degree
    ADD CONSTRAINT psychiatrist_degree_psychiatrist_id_fkey FOREIGN KEY (psychiatrist_id) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- Name: psychiatrist_disease psychiatrist_disease_disease_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrist_disease
    ADD CONSTRAINT psychiatrist_disease_disease_id_fkey FOREIGN KEY (disease_id) REFERENCES public.diseases(disease_id);


--
-- Name: psychiatrist_disease psychiatrist_disease_psychiatrist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrist_disease
    ADD CONSTRAINT psychiatrist_disease_psychiatrist_id_fkey FOREIGN KEY (psychiatrist_id) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- Name: psychiatrists psychiatrists_psychiatrist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrists
    ADD CONSTRAINT psychiatrists_psychiatrist_id_fkey FOREIGN KEY (psychiatrist_id) REFERENCES public.persons(person_id);


--
-- Name: review_board_member review_board_member_board_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_board_member
    ADD CONSTRAINT review_board_member_board_member_id_fkey FOREIGN KEY (board_member_id) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- Name: test_question test_question_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_question
    ADD CONSTRAINT test_question_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- Name: test_question test_question_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_question
    ADD CONSTRAINT test_question_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.tests(test_id);


--
-- Name: test_result_disease test_result_disease_disease_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_result_disease
    ADD CONSTRAINT test_result_disease_disease_id_fkey FOREIGN KEY (disease_id) REFERENCES public.diseases(disease_id);


--
-- Name: test_result_disease test_result_disease_test_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_result_disease
    ADD CONSTRAINT test_result_disease_test_result_id_fkey FOREIGN KEY (test_result_id) REFERENCES public.test_results(test_result_id);


--
-- Name: test_results test_results_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(patient_id);


--
-- Name: test_results test_results_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.tests(test_id);


--
-- Name: test_results test_results_verifier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_verifier_id_fkey FOREIGN KEY (verifier_id) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- Name: tests tests_psychiatrist_id_of_added_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_psychiatrist_id_of_added_by_fkey FOREIGN KEY (psychiatrist_id_of_added_by) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- PostgreSQL database dump complete
--


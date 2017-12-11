-- Drop Grid

SELECT '<b>CRN</b>'                     "CRN",                       -- Header
       '<b>Course ID</b>'               "COURSE",
       '<b>Title</b>'                   "TITLE",
       '<b>Block</b>'                   "BLOCK",
       '<b>Grading Track</b>'           "TRACKDESC",
       '<b>Units</b>'                   "UNITS",
       '<b>Instructor</b>'              "INSTRUCTOR",
       '<b>Location</b>'                "LOCATION",
       '<b>Dates</b>'                   "DATES",
       10                               "SORTER",
       '0'                              "ACADPERIOD",
       ''                               "ACADPERIODDESC",
       '0'                              "REGSTATUS",
       ''                               "TRACKTYPE",
       '0'                              "SCHEDULETYPE",
       0                                "PIDM",
       ''                               "CAMPUS",
       ''                               "MEETCATEGORY",
       TO_DATE ('19700101', 'YYYYMMDD') "MEETSTARTDATE",
       TO_DATE ('19700101', 'YYYYMMDD') "MEETENDDATE",
       ''                               "MEETTERMCODE",
       ''                               "DRADTYPE",
       'Y'                              "DRADHIDE",
       ''                               "DRADCONSENTREQ",
       '0'                              "DROPCHECKBOX",
       ''                               "CONSENTCODE",
       ''                               "OVERRIDE"
  FROM DUAL
UNION
SELECT DISTINCT
       '<b>' || scip.academic_period_desc || '</b>' "CRN",    -- Term 1 Header
       ''                                           "COURSE",
       ''                                           "TITLE",
       ''                                           "BLOCK",
       ''                                           "TRACKDESC",
       ''                                           "UNITS",
       ''                                           "INSTRUCTOR",
       ''                                           "LOCATION",
       ''                                           "DATES",
       11                                           "SORTER",
       scip.academic_period                         "ACADPERIOD",
       ''                                           "ACADPERIODDESC",
       '0'                                          "REGSTATUS",
       ''                                           "TRACKTYPE",
       '0'                                          "SCHEDULETYPE",
       0                                            "PIDM",
       ''                                           "CAMPUS",
       ''                                           "MEETCATEGORY",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETSTARTDATE",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETENDDATE",
       ''                                           "MEETTERMCODE",
       ''                                           "DRADTYPE",
       'Y'                                          "DRADHIDE",
       ''                                           "DRADCONSENTREQ",
       '0'                                          "DROPCHECKBOX",
       ''                                           "CONSENTCODE",
       ''                                           "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.this_term
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 1 RE Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN ssrmeet_bldg_code IS NULL THEN 'TBA'
          ELSE ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       12                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       szrdrad_override                      "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.this_term
UNION
SELECT CRN,                                                 -- Term 1 RE Total
       COURSE,
       TITLE,
       BLOCK,
       TRACKDESC,
       '<b>' || TO_CHAR (UNITS, '0.00') || '</b>',
       INSTRUCTOR,
       LOCATION,
       DATES,
       SORTER,
       ACADPERIOD,
       ACADPERIODDESC,
       REGSTATUS,
       TRACKTYPE,
       SCHEDULETYPE,
       PIDM,
       CAMPUS,
       MEETCATEGORY,
       MEETSTARTDATE,
       MEETENDDATE,
       MEETTERMCODE,
       DRADTYPE,
       DRADHIDE,
       DRADCONSENTREQ,
       DROPCHECKBOX,
       CONSENTCODE,
       OVERRIDE
  FROM (  SELECT ''                             "CRN",
                 ''                             "COURSE",
                 ''                             "TITLE",
                 '<b>Total:</b>'                "BLOCK",
                 ''                             "TRACKDESC",
                 SUM (scip.course_credits)      "UNITS",
                 ''                             "INSTRUCTOR",
                 ''                             "LOCATION",
                 ''                             "DATES",
                 13                             "SORTER",
                 '0'                            "ACADPERIOD",
                 ''                             "ACADPERIODDESC",
                 '0'                            "REGSTATUS",
                 ''                             "TRACKTYPE",
                 '0'                            "SCHEDULETYPE",
                 0                              "PIDM",
                 ''                             "CAMPUS",
                 ''                             "MEETCATEGORY",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETSTARTDATE",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETENDDATE",
                 ''                             "MEETTERMCODE",
                 ''                             "DRADTYPE",
                 'Y'                            "DRADHIDE",
                 ''                             "DRADCONSENTREQ",
                 '0'                            "DROPCHECKBOX",
                 ''                             "CONSENTCODE",
                 ''                             "OVERRIDE"
            FROM baninst1.as_cc_student_course_in_prog scip
                 LEFT OUTER JOIN ssrmeet
                    ON     ssrmeet_term_code = academic_period
                       AND ssrmeet_crn = scip.course_reference_number
                 LEFT OUTER JOIN szrdrad
                    ON     szrdrad_pidm = scip.person_uid
                       AND szrdrad_term_block = scip.academic_period
                       AND szrdrad_crn = scip.course_reference_number
                       AND szrdrad_hide <> 'Y'
           WHERE     scip.person_uid = :stu_pidm
                 AND scip.registration_status IN ('RE')
                 AND (   scip.academic_period IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%')
                      OR    scip.academic_period
                         || SUBSTR (scip.sub_academic_period, 1, 1) IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%'))
                 AND (   scip.subject <> '00'
                      OR UPPER (scip.course_title_long) LIKE
                            '%TAKING A BLOCK OFF%')
                 AND scip.academic_period = sz_dates.this_term
        GROUP BY scip.person_uid)
UNION
SELECT DISTINCT ''                               "CRN",    -- Term 1 WL Header
                ''                               "COURSE",
                '<b>Waiting Lists</b>'           "TITLE",
                ''                               "BLOCK",
                ''                               "TRACKDESC",
                ''                               "UNITS",
                ''                               "INSTRUCTOR",
                '<b>Position</b>'                "LOCATION",
                ''                               "DATES",
                14                               "SORTER",
                scip.academic_period             "ACADPERIOD",
                ''                               "ACADPERIODDESC",
                '0'                              "REGSTATUS",
                ''                               "TRACKTYPE",
                '0'                              "SCHEDULETYPE",
                0                                "PIDM",
                ''                               "CAMPUS",
                ''                               "MEETCATEGORY",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETSTARTDATE",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETENDDATE",
                ''                               "MEETTERMCODE",
                ''                               "DRADTYPE",
                'Y'                              "DRADHIDE",
                ''                               "DRADCONSENTREQ",
                '0'                              "DROPCHECKBOX",
                ''                               "CONSENTCODE",
                ''                               "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.this_term
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 1 WL Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN scip.registration_status = 'WL'
          THEN
             sfkwlat.f_get_wl_pos (:stu_pidm,
                                   scip.academic_period,
                                   scip.course_reference_number)
          ELSE
             ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       15                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       ''                                    "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.this_term
UNION
SELECT DISTINCT
       '<b>' || scip.academic_period_desc || '</b>' "CRN",    -- Term 2 Header
       ''                                           "COURSE",
       ''                                           "TITLE",
       ''                                           "BLOCK",
       ''                                           "TRACKDESC",
       ''                                           "UNITS",
       ''                                           "INSTRUCTOR",
       ''                                           "LOCATION",
       ''                                           "DATES",
       21                                           "SORTER",
       scip.academic_period                         "ACADPERIOD",
       ''                                           "ACADPERIODDESC",
       '0'                                          "REGSTATUS",
       ''                                           "TRACKTYPE",
       '0'                                          "SCHEDULETYPE",
       0                                            "PIDM",
       ''                                           "CAMPUS",
       ''                                           "MEETCATEGORY",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETSTARTDATE",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETENDDATE",
       ''                                           "MEETTERMCODE",
       ''                                           "DRADTYPE",
       'Y'                                          "DRADHIDE",
       ''                                           "DRADCONSENTREQ",
       '0'                                          "DROPCHECKBOX",
       ''                                           "CONSENTCODE",
       ''                                           "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 2 RE Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN ssrmeet_bldg_code IS NULL THEN 'TBA'
          ELSE ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       22                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       szrdrad_override                      "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term
UNION
SELECT CRN,                                                 -- Term 2 RE Total
       COURSE,
       TITLE,
       BLOCK,
       TRACKDESC,
       '<b>' || TO_CHAR (UNITS, '0.00') || '</b>',
       INSTRUCTOR,
       LOCATION,
       DATES,
       SORTER,
       ACADPERIOD,
       ACADPERIODDESC,
       REGSTATUS,
       TRACKTYPE,
       SCHEDULETYPE,
       PIDM,
       CAMPUS,
       MEETCATEGORY,
       MEETSTARTDATE,
       MEETENDDATE,
       MEETTERMCODE,
       DRADTYPE,
       DRADHIDE,
       DRADCONSENTREQ,
       DROPCHECKBOX,
       CONSENTCODE,
       OVERRIDE
  FROM (  SELECT ''                             "CRN",
                 ''                             "COURSE",
                 ''                             "TITLE",
                 '<b>Total:</b>'                "BLOCK",
                 ''                             "TRACKDESC",
                 SUM (scip.course_credits)      "UNITS",
                 ''                             "INSTRUCTOR",
                 ''                             "LOCATION",
                 ''                             "DATES",
                 23                             "SORTER",
                 '0'                            "ACADPERIOD",
                 ''                             "ACADPERIODDESC",
                 '0'                            "REGSTATUS",
                 ''                             "TRACKTYPE",
                 '0'                            "SCHEDULETYPE",
                 0                              "PIDM",
                 ''                             "CAMPUS",
                 ''                             "MEETCATEGORY",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETSTARTDATE",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETENDDATE",
                 ''                             "MEETTERMCODE",
                 ''                             "DRADTYPE",
                 'Y'                            "DRADHIDE",
                 ''                             "DRADCONSENTREQ",
                 '0'                            "DROPCHECKBOX",
                 ''                             "CONSENTCODE",
                 ''                             "OVERRIDE"
            FROM baninst1.as_cc_student_course_in_prog scip
                 LEFT OUTER JOIN ssrmeet
                    ON     ssrmeet_term_code = academic_period
                       AND ssrmeet_crn = scip.course_reference_number
                 LEFT OUTER JOIN szrdrad
                    ON     szrdrad_pidm = scip.person_uid
                       AND szrdrad_term_block = scip.academic_period
                       AND szrdrad_crn = scip.course_reference_number
                       AND szrdrad_hide <> 'Y'
           WHERE     scip.person_uid = :stu_pidm
                 AND scip.registration_status IN ('RE')
                 AND (   scip.academic_period IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%')
                      OR    scip.academic_period
                         || SUBSTR (scip.sub_academic_period, 1, 1) IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%'))
                 AND (   scip.subject <> '00'
                      OR UPPER (scip.course_title_long) LIKE
                            '%TAKING A BLOCK OFF%')
                 AND scip.academic_period = sz_dates.next_term
        GROUP BY scip.person_uid)
UNION
SELECT DISTINCT ''                               "CRN",    -- Term 2 WL Header
                ''                               "COURSE",
                '<b>Waiting Lists</b>'           "TITLE",
                ''                               "BLOCK",
                ''                               "TRACKDESC",
                ''                               "UNITS",
                ''                               "INSTRUCTOR",
                '<b>Position</b>'                "LOCATION",
                ''                               "DATES",
                24                               "SORTER",
                scip.academic_period             "ACADPERIOD",
                ''                               "ACADPERIODDESC",
                '0'                              "REGSTATUS",
                ''                               "TRACKTYPE",
                '0'                              "SCHEDULETYPE",
                0                                "PIDM",
                ''                               "CAMPUS",
                ''                               "MEETCATEGORY",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETSTARTDATE",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETENDDATE",
                ''                               "MEETTERMCODE",
                ''                               "DRADTYPE",
                'Y'                              "DRADHIDE",
                ''                               "DRADCONSENTREQ",
                '0'                              "DROPCHECKBOX",
                ''                               "CONSENTCODE",
                ''                               "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 2 WL Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN scip.registration_status = 'WL'
          THEN
             sfkwlat.f_get_wl_pos (:stu_pidm,
                                   scip.academic_period,
                                   scip.course_reference_number)
          ELSE
             ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       25                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       ''                                    "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term
UNION
SELECT DISTINCT
       '<b>' || scip.academic_period_desc || '</b>' "CRN",    -- Term 3 Header
       ''                                           "COURSE",
       ''                                           "TITLE",
       ''                                           "BLOCK",
       ''                                           "TRACKDESC",
       ''                                           "UNITS",
       ''                                           "INSTRUCTOR",
       ''                                           "LOCATION",
       ''                                           "DATES",
       31                                           "SORTER",
       scip.academic_period                         "ACADPERIOD",
       ''                                           "ACADPERIODDESC",
       '0'                                          "REGSTATUS",
       ''                                           "TRACKTYPE",
       '0'                                          "SCHEDULETYPE",
       0                                            "PIDM",
       ''                                           "CAMPUS",
       ''                                           "MEETCATEGORY",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETSTARTDATE",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETENDDATE",
       ''                                           "MEETTERMCODE",
       ''                                           "DRADTYPE",
       'Y'                                          "DRADHIDE",
       ''                                           "DRADCONSENTREQ",
       '0'                                          "DROPCHECKBOX",
       ''                                           "CONSENTCODE",
       ''                                           "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (2)
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 3 RE Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN ssrmeet_bldg_code IS NULL THEN 'TBA'
          ELSE ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       32                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       szrdrad_override                      "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (2)
UNION
SELECT CRN,                                                 -- Term 3 RE Total
       COURSE,
       TITLE,
       BLOCK,
       TRACKDESC,
       '<b>' || TO_CHAR (UNITS, '0.00') || '</b>',
       INSTRUCTOR,
       LOCATION,
       DATES,
       SORTER,
       ACADPERIOD,
       ACADPERIODDESC,
       REGSTATUS,
       TRACKTYPE,
       SCHEDULETYPE,
       PIDM,
       CAMPUS,
       MEETCATEGORY,
       MEETSTARTDATE,
       MEETENDDATE,
       MEETTERMCODE,
       DRADTYPE,
       DRADHIDE,
       DRADCONSENTREQ,
       DROPCHECKBOX,
       CONSENTCODE,
       OVERRIDE
  FROM (  SELECT ''                             "CRN",
                 ''                             "COURSE",
                 ''                             "TITLE",
                 '<b>Total:</b>'                "BLOCK",
                 ''                             "TRACKDESC",
                 SUM (scip.course_credits)      "UNITS",
                 ''                             "INSTRUCTOR",
                 ''                             "LOCATION",
                 ''                             "DATES",
                 33                             "SORTER",
                 '0'                            "ACADPERIOD",
                 ''                             "ACADPERIODDESC",
                 '0'                            "REGSTATUS",
                 ''                             "TRACKTYPE",
                 '0'                            "SCHEDULETYPE",
                 0                              "PIDM",
                 ''                             "CAMPUS",
                 ''                             "MEETCATEGORY",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETSTARTDATE",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETENDDATE",
                 ''                             "MEETTERMCODE",
                 ''                             "DRADTYPE",
                 'Y'                            "DRADHIDE",
                 ''                             "DRADCONSENTREQ",
                 '0'                            "DROPCHECKBOX",
                 ''                             "CONSENTCODE",
                 ''                             "OVERRIDE"
            FROM baninst1.as_cc_student_course_in_prog scip
                 LEFT OUTER JOIN ssrmeet
                    ON     ssrmeet_term_code = academic_period
                       AND ssrmeet_crn = scip.course_reference_number
                 LEFT OUTER JOIN szrdrad
                    ON     szrdrad_pidm = scip.person_uid
                       AND szrdrad_term_block = scip.academic_period
                       AND szrdrad_crn = scip.course_reference_number
                       AND szrdrad_hide <> 'Y'
           WHERE     scip.person_uid = :stu_pidm
                 AND scip.registration_status IN ('RE')
                 AND (   scip.academic_period IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%')
                      OR    scip.academic_period
                         || SUBSTR (scip.sub_academic_period, 1, 1) IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%'))
                 AND (   scip.subject <> '00'
                      OR UPPER (scip.course_title_long) LIKE
                            '%TAKING A BLOCK OFF%')
                 AND scip.academic_period = sz_dates.next_term (2)
        GROUP BY scip.person_uid)
UNION
SELECT DISTINCT ''                               "CRN",    -- Term 3 WL Header
                ''                               "COURSE",
                '<b>Waiting Lists</b>'           "TITLE",
                ''                               "BLOCK",
                ''                               "TRACKDESC",
                ''                               "UNITS",
                ''                               "INSTRUCTOR",
                '<b>Position</b>'                "LOCATION",
                ''                               "DATES",
                34                               "SORTER",
                scip.academic_period             "ACADPERIOD",
                ''                               "ACADPERIODDESC",
                '0'                              "REGSTATUS",
                ''                               "TRACKTYPE",
                '0'                              "SCHEDULETYPE",
                0                                "PIDM",
                ''                               "CAMPUS",
                ''                               "MEETCATEGORY",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETSTARTDATE",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETENDDATE",
                ''                               "MEETTERMCODE",
                ''                               "DRADTYPE",
                'Y'                              "DRADHIDE",
                ''                               "DRADCONSENTREQ",
                '0'                              "DROPCHECKBOX",
                ''                               "CONSENTCODE",
                ''                               "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (2)
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 3 WL Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN scip.registration_status = 'WL'
          THEN
             sfkwlat.f_get_wl_pos (:stu_pidm,
                                   scip.academic_period,
                                   scip.course_reference_number)
          ELSE
             ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       35                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       ''                                    "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (2)
UNION
SELECT DISTINCT
       '<b>' || scip.academic_period_desc || '</b>' "CRN",    -- Term 4 Header
       ''                                           "COURSE",
       ''                                           "TITLE",
       ''                                           "BLOCK",
       ''                                           "TRACKDESC",
       ''                                           "UNITS",
       ''                                           "INSTRUCTOR",
       ''                                           "LOCATION",
       ''                                           "DATES",
       41                                           "SORTER",
       scip.academic_period                         "ACADPERIOD",
       ''                                           "ACADPERIODDESC",
       '0'                                          "REGSTATUS",
       ''                                           "TRACKTYPE",
       '0'                                          "SCHEDULETYPE",
       0                                            "PIDM",
       ''                                           "CAMPUS",
       ''                                           "MEETCATEGORY",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETSTARTDATE",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETENDDATE",
       ''                                           "MEETTERMCODE",
       ''                                           "DRADTYPE",
       'Y'                                          "DRADHIDE",
       ''                                           "DRADCONSENTREQ",
       '0'                                          "DROPCHECKBOX",
       ''                                           "CONSENTCODE",
       ''                                           "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (3)
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 4 RE Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN ssrmeet_bldg_code IS NULL THEN 'TBA'
          ELSE ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       42                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       szrdrad_override                      "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (3)
UNION
SELECT CRN,                                                 -- Term 4 RE Total
       COURSE,
       TITLE,
       BLOCK,
       TRACKDESC,
       '<b>' || TO_CHAR (UNITS, '0.00') || '</b>',
       INSTRUCTOR,
       LOCATION,
       DATES,
       SORTER,
       ACADPERIOD,
       ACADPERIODDESC,
       REGSTATUS,
       TRACKTYPE,
       SCHEDULETYPE,
       PIDM,
       CAMPUS,
       MEETCATEGORY,
       MEETSTARTDATE,
       MEETENDDATE,
       MEETTERMCODE,
       DRADTYPE,
       DRADHIDE,
       DRADCONSENTREQ,
       DROPCHECKBOX,
       CONSENTCODE,
       OVERRIDE
  FROM (  SELECT ''                             "CRN",
                 ''                             "COURSE",
                 ''                             "TITLE",
                 '<b>Total:</b>'                "BLOCK",
                 ''                             "TRACKDESC",
                 SUM (scip.course_credits)      "UNITS",
                 ''                             "INSTRUCTOR",
                 ''                             "LOCATION",
                 ''                             "DATES",
                 43                             "SORTER",
                 '0'                            "ACADPERIOD",
                 ''                             "ACADPERIODDESC",
                 '0'                            "REGSTATUS",
                 ''                             "TRACKTYPE",
                 '0'                            "SCHEDULETYPE",
                 0                              "PIDM",
                 ''                             "CAMPUS",
                 ''                             "MEETCATEGORY",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETSTARTDATE",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETENDDATE",
                 ''                             "MEETTERMCODE",
                 ''                             "DRADTYPE",
                 'Y'                            "DRADHIDE",
                 ''                             "DRADCONSENTREQ",
                 '0'                            "DROPCHECKBOX",
                 ''                             "CONSENTCODE",
                 ''                             "OVERRIDE"
            FROM baninst1.as_cc_student_course_in_prog scip
                 LEFT OUTER JOIN ssrmeet
                    ON     ssrmeet_term_code = academic_period
                       AND ssrmeet_crn = scip.course_reference_number
                 LEFT OUTER JOIN szrdrad
                    ON     szrdrad_pidm = scip.person_uid
                       AND szrdrad_term_block = scip.academic_period
                       AND szrdrad_crn = scip.course_reference_number
                       AND szrdrad_hide <> 'Y'
           WHERE     scip.person_uid = :stu_pidm
                 AND scip.registration_status IN ('RE')
                 AND (   scip.academic_period IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%')
                      OR    scip.academic_period
                         || SUBSTR (scip.sub_academic_period, 1, 1) IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%'))
                 AND (   scip.subject <> '00'
                      OR UPPER (scip.course_title_long) LIKE
                            '%TAKING A BLOCK OFF%')
                 AND scip.academic_period = sz_dates.next_term (3)
        GROUP BY scip.person_uid)
UNION
SELECT DISTINCT ''                               "CRN",    -- Term 4 WL Header
                ''                               "COURSE",
                '<b>Waiting Lists</b>'           "TITLE",
                ''                               "BLOCK",
                ''                               "TRACKDESC",
                ''                               "UNITS",
                ''                               "INSTRUCTOR",
                '<b>Position</b>'                "LOCATION",
                ''                               "DATES",
                44                               "SORTER",
                scip.academic_period             "ACADPERIOD",
                ''                               "ACADPERIODDESC",
                '0'                              "REGSTATUS",
                ''                               "TRACKTYPE",
                '0'                              "SCHEDULETYPE",
                0                                "PIDM",
                ''                               "CAMPUS",
                ''                               "MEETCATEGORY",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETSTARTDATE",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETENDDATE",
                ''                               "MEETTERMCODE",
                ''                               "DRADTYPE",
                'Y'                              "DRADHIDE",
                ''                               "DRADCONSENTREQ",
                '0'                              "DROPCHECKBOX",
                ''                               "CONSENTCODE",
                ''                               "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (3)
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 4 WL Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN scip.registration_status = 'WL'
          THEN
             sfkwlat.f_get_wl_pos (:stu_pidm,
                                   scip.academic_period,
                                   scip.course_reference_number)
          ELSE
             ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       45                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       ''                                    "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (3)
UNION
SELECT DISTINCT
       '<b>' || scip.academic_period_desc || '</b>' "CRN",    -- Term 5 Header
       ''                                           "COURSE",
       ''                                           "TITLE",
       ''                                           "BLOCK",
       ''                                           "TRACKDESC",
       ''                                           "UNITS",
       ''                                           "INSTRUCTOR",
       ''                                           "LOCATION",
       ''                                           "DATES",
       51                                           "SORTER",
       scip.academic_period                         "ACADPERIOD",
       ''                                           "ACADPERIODDESC",
       '0'                                          "REGSTATUS",
       ''                                           "TRACKTYPE",
       '0'                                          "SCHEDULETYPE",
       0                                            "PIDM",
       ''                                           "CAMPUS",
       ''                                           "MEETCATEGORY",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETSTARTDATE",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETENDDATE",
       ''                                           "MEETTERMCODE",
       ''                                           "DRADTYPE",
       'Y'                                          "DRADHIDE",
       ''                                           "DRADCONSENTREQ",
       '0'                                          "DROPCHECKBOX",
       ''                                           "CONSENTCODE",
       ''                                           "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (4)
       AND sz_dates.next_year >= SUBSTR (sz_dates.next_term (4), 1, 4)
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 5 RE Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN ssrmeet_bldg_code IS NULL THEN 'TBA'
          ELSE ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       52                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       szrdrad_override                      "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (4)
       AND sz_dates.next_year >= SUBSTR (sz_dates.next_term (4), 1, 4)
UNION
SELECT CRN,                                                 -- Term 5 RE Total
       COURSE,
       TITLE,
       BLOCK,
       TRACKDESC,
       '<b>' || TO_CHAR (UNITS, '0.00') || '</b>',
       INSTRUCTOR,
       LOCATION,
       DATES,
       SORTER,
       ACADPERIOD,
       ACADPERIODDESC,
       REGSTATUS,
       TRACKTYPE,
       SCHEDULETYPE,
       PIDM,
       CAMPUS,
       MEETCATEGORY,
       MEETSTARTDATE,
       MEETENDDATE,
       MEETTERMCODE,
       DRADTYPE,
       DRADHIDE,
       DRADCONSENTREQ,
       DROPCHECKBOX,
       CONSENTCODE,
       OVERRIDE
  FROM (  SELECT ''                             "CRN",
                 ''                             "COURSE",
                 ''                             "TITLE",
                 '<b>Total:</b>'                "BLOCK",
                 ''                             "TRACKDESC",
                 SUM (scip.course_credits)      "UNITS",
                 ''                             "INSTRUCTOR",
                 ''                             "LOCATION",
                 ''                             "DATES",
                 53                             "SORTER",
                 '0'                            "ACADPERIOD",
                 ''                             "ACADPERIODDESC",
                 '0'                            "REGSTATUS",
                 ''                             "TRACKTYPE",
                 '0'                            "SCHEDULETYPE",
                 0                              "PIDM",
                 ''                             "CAMPUS",
                 ''                             "MEETCATEGORY",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETSTARTDATE",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETENDDATE",
                 ''                             "MEETTERMCODE",
                 ''                             "DRADTYPE",
                 'Y'                            "DRADHIDE",
                 ''                             "DRADCONSENTREQ",
                 '0'                            "DROPCHECKBOX",
                 ''                             "CONSENTCODE",
                 ''                             "OVERRIDE"
            FROM baninst1.as_cc_student_course_in_prog scip
                 LEFT OUTER JOIN ssrmeet
                    ON     ssrmeet_term_code = academic_period
                       AND ssrmeet_crn = scip.course_reference_number
                 LEFT OUTER JOIN szrdrad
                    ON     szrdrad_pidm = scip.person_uid
                       AND szrdrad_term_block = scip.academic_period
                       AND szrdrad_crn = scip.course_reference_number
                       AND szrdrad_hide <> 'Y'
           WHERE     scip.person_uid = :stu_pidm
                 AND scip.registration_status IN ('RE')
                 AND (   scip.academic_period IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%')
                      OR    scip.academic_period
                         || SUBSTR (scip.sub_academic_period, 1, 1) IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%'))
                 AND (   scip.subject <> '00'
                      OR UPPER (scip.course_title_long) LIKE
                            '%TAKING A BLOCK OFF%')
                 AND scip.academic_period = sz_dates.next_term (4)
                 AND sz_dates.next_year >=
                        SUBSTR (sz_dates.next_term (4), 1, 4)
        GROUP BY scip.person_uid)
UNION
SELECT DISTINCT ''                               "CRN",    -- Term 5 WL Header
                ''                               "COURSE",
                '<b>Waiting Lists</b>'           "TITLE",
                ''                               "BLOCK",
                ''                               "TRACKDESC",
                ''                               "UNITS",
                ''                               "INSTRUCTOR",
                '<b>Position</b>'                "LOCATION",
                ''                               "DATES",
                54                               "SORTER",
                scip.academic_period             "ACADPERIOD",
                ''                               "ACADPERIODDESC",
                '0'                              "REGSTATUS",
                ''                               "TRACKTYPE",
                '0'                              "SCHEDULETYPE",
                0                                "PIDM",
                ''                               "CAMPUS",
                ''                               "MEETCATEGORY",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETSTARTDATE",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETENDDATE",
                ''                               "MEETTERMCODE",
                ''                               "DRADTYPE",
                'Y'                              "DRADHIDE",
                ''                               "DRADCONSENTREQ",
                '0'                              "DROPCHECKBOX",
                ''                               "CONSENTCODE",
                ''                               "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (4)
       AND sz_dates.next_year >= SUBSTR (sz_dates.next_term (4), 1, 4)
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 5 WL Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN scip.registration_status = 'WL'
          THEN
             sfkwlat.f_get_wl_pos (:stu_pidm,
                                   scip.academic_period,
                                   scip.course_reference_number)
          ELSE
             ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       55                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       ''                                    "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (4)
       AND sz_dates.next_year >= SUBSTR (sz_dates.next_term (4), 1, 4)
UNION
SELECT DISTINCT
       '<b>' || scip.academic_period_desc || '</b>' "CRN",    -- Term 6 Header
       ''                                           "COURSE",
       ''                                           "TITLE",
       ''                                           "BLOCK",
       ''                                           "TRACKDESC",
       ''                                           "UNITS",
       ''                                           "INSTRUCTOR",
       ''                                           "LOCATION",
       ''                                           "DATES",
       61                                           "SORTER",
       scip.academic_period                         "ACADPERIOD",
       ''                                           "ACADPERIODDESC",
       '0'                                          "REGSTATUS",
       ''                                           "TRACKTYPE",
       '0'                                          "SCHEDULETYPE",
       0                                            "PIDM",
       ''                                           "CAMPUS",
       ''                                           "MEETCATEGORY",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETSTARTDATE",
       TO_DATE ('19700101', 'YYYYMMDD')             "MEETENDDATE",
       ''                                           "MEETTERMCODE",
       ''                                           "DRADTYPE",
       'Y'                                          "DRADHIDE",
       ''                                           "DRADCONSENTREQ",
       '0'                                          "DROPCHECKBOX",
       ''                                           "CONSENTCODE",
       ''                                           "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (5)
       AND sz_dates.next_year >= SUBSTR (sz_dates.next_term (5), 1, 4)
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 6 RE Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN ssrmeet_bldg_code IS NULL THEN 'TBA'
          ELSE ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       62                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       szrdrad_override                      "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('RE')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (5)
       AND sz_dates.next_year >= SUBSTR (sz_dates.next_term (5), 1, 4)
UNION
SELECT CRN,                                                 -- Term 6 RE Total
       COURSE,
       TITLE,
       BLOCK,
       TRACKDESC,
       '<b>' || TO_CHAR (UNITS, '0.00') || '</b>',
       INSTRUCTOR,
       LOCATION,
       DATES,
       SORTER,
       ACADPERIOD,
       ACADPERIODDESC,
       REGSTATUS,
       TRACKTYPE,
       SCHEDULETYPE,
       PIDM,
       CAMPUS,
       MEETCATEGORY,
       MEETSTARTDATE,
       MEETENDDATE,
       MEETTERMCODE,
       DRADTYPE,
       DRADHIDE,
       DRADCONSENTREQ,
       DROPCHECKBOX,
       CONSENTCODE,
       OVERRIDE
  FROM (  SELECT ''                             "CRN",
                 ''                             "COURSE",
                 ''                             "TITLE",
                 '<b>Total:</b>'                "BLOCK",
                 ''                             "TRACKDESC",
                 SUM (scip.course_credits)      "UNITS",
                 ''                             "INSTRUCTOR",
                 ''                             "LOCATION",
                 ''                             "DATES",
                 63                             "SORTER",
                 '0'                            "ACADPERIOD",
                 ''                             "ACADPERIODDESC",
                 '0'                            "REGSTATUS",
                 ''                             "TRACKTYPE",
                 '0'                            "SCHEDULETYPE",
                 0                              "PIDM",
                 ''                             "CAMPUS",
                 ''                             "MEETCATEGORY",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETSTARTDATE",
                 TO_DATE ('19700101', 'YYYYMMDD')"MEETENDDATE",
                 ''                             "MEETTERMCODE",
                 ''                             "DRADTYPE",
                 'Y'                            "DRADHIDE",
                 ''                             "DRADCONSENTREQ",
                 '0'                            "DROPCHECKBOX",
                 ''                             "CONSENTCODE",
                 ''                             "OVERRIDE"
            FROM baninst1.as_cc_student_course_in_prog scip
                 LEFT OUTER JOIN ssrmeet
                    ON     ssrmeet_term_code = academic_period
                       AND ssrmeet_crn = scip.course_reference_number
                 LEFT OUTER JOIN szrdrad
                    ON     szrdrad_pidm = scip.person_uid
                       AND szrdrad_term_block = scip.academic_period
                       AND szrdrad_crn = scip.course_reference_number
                       AND szrdrad_hide <> 'Y'
           WHERE     scip.person_uid = :stu_pidm
                 AND scip.registration_status IN ('RE')
                 AND (   scip.academic_period IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%')
                      OR    scip.academic_period
                         || SUBSTR (scip.sub_academic_period, 1, 1) IN
                            (SELECT szrdrad_term_block
                               FROM szrdrad
                              WHERE     szrdrad_pidm = scip.person_uid
                                    AND szrdrad_msg LIKE '%display%'))
                 AND (   scip.subject <> '00'
                      OR UPPER (scip.course_title_long) LIKE
                            '%TAKING A BLOCK OFF%')
                 AND scip.academic_period = sz_dates.next_term (5)
                 AND sz_dates.next_year >=
                        SUBSTR (sz_dates.next_term (5), 1, 4)
        GROUP BY scip.person_uid)
UNION
SELECT DISTINCT ''                               "CRN",    -- Term 6 WL Header
                ''                               "COURSE",
                '<b>Waiting Lists</b>'           "TITLE",
                ''                               "BLOCK",
                ''                               "TRACKDESC",
                ''                               "UNITS",
                ''                               "INSTRUCTOR",
                '<b>Position</b>'                "LOCATION",
                ''                               "DATES",
                64                               "SORTER",
                scip.academic_period             "ACADPERIOD",
                ''                               "ACADPERIODDESC",
                '0'                              "REGSTATUS",
                ''                               "TRACKTYPE",
                '0'                              "SCHEDULETYPE",
                0                                "PIDM",
                ''                               "CAMPUS",
                ''                               "MEETCATEGORY",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETSTARTDATE",
                TO_DATE ('19700101', 'YYYYMMDD') "MEETENDDATE",
                ''                               "MEETTERMCODE",
                ''                               "DRADTYPE",
                'Y'                              "DRADHIDE",
                ''                               "DRADCONSENTREQ",
                '0'                              "DROPCHECKBOX",
                ''                               "CONSENTCODE",
                ''                               "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (5)
       AND sz_dates.next_year >= SUBSTR (sz_dates.next_term (5), 1, 4)
UNION
SELECT scip.course_reference_number          "CRN",          -- Term 6 WL Data
       scip.course_id                        "COURSE",
       scip.course_title_long                "TITLE",
       scip.sub_academic_period_desc         "BLOCK",
       scip.grade_type_desc                  "TRACKDESC",
       TO_CHAR (scip.course_credits, '0.00') "UNITS",
       CASE
          WHEN (SELECT c.instr1
                  FROM as_cc_courses c
                 WHERE     c.term_code_key = scip.academic_period
                       AND c.crn_key = scip.course_reference_number)
                  IS NULL
          THEN
             'Department'
          ELSE
             (SELECT c.instr1
                FROM as_cc_courses c
               WHERE     c.term_code_key = scip.academic_period
                     AND c.crn_key = scip.course_reference_number)
       END
          "INSTRUCTOR",
       CASE
          WHEN scip.registration_status = 'WL'
          THEN
             sfkwlat.f_get_wl_pos (:stu_pidm,
                                   scip.academic_period,
                                   scip.course_reference_number)
          ELSE
             ssrmeet_bldg_code || ' ' || ssrmeet_room_code
       END
          "LOCATION",
          TO_CHAR (scip.start_date, 'mm/dd')
       || '-'
       || TO_CHAR (scip.end_date, 'mm/dd')
          "DATES",
       65                                    "SORTER",
       scip.academic_period                  "ACADPERIOD",
       scip.academic_period_desc             "ACADPERIODDESC",
       scip.registration_status              "REGSTATUS",
       scip.grade_type                       "TRACKTYPE",
       scip.schedule_type                    "SCHEDULETYPE",
       scip.person_uid                       "PIDM",
       scip.course_campus                    "CAMPUS",
       ssrmeet_catagory                      "MEETCATEGORY",
       ssrmeet_start_date                    "MEETSTARTDATE",
       ssrmeet_end_date                      "MEETENDDATE",
       ssrmeet_term_code                     "MEETTERMCODE",
       szrdrad_type                          "DRADTYPE",
       szrdrad_hide                          "DRADHIDE",
       szrdrad_consent_req                   "DRADCONSENTREQ",
       '0'                                   "DROPCHECKBOX",
       ''                                    "CONSENTCODE",
       ''                                    "OVERRIDE"
  FROM baninst1.as_cc_student_course_in_prog scip
       LEFT OUTER JOIN ssrmeet
          ON     ssrmeet_term_code = academic_period
             AND ssrmeet_crn = scip.course_reference_number
       LEFT OUTER JOIN szrdrad
          ON     szrdrad_pidm = scip.person_uid
             AND szrdrad_term_block = scip.academic_period
             AND szrdrad_crn = scip.course_reference_number
             AND szrdrad_hide <> 'Y'
 WHERE     scip.person_uid = :stu_pidm
       AND scip.registration_status IN ('WL')
       AND (   scip.academic_period IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%')
            OR    scip.academic_period
               || SUBSTR (scip.sub_academic_period, 1, 1) IN
                  (SELECT szrdrad_term_block
                     FROM szrdrad
                    WHERE     szrdrad_pidm = scip.person_uid
                          AND szrdrad_msg LIKE '%display%'))
       AND (   scip.subject <> '00'
            OR UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%')
       AND scip.academic_period = sz_dates.next_term (5)
       AND sz_dates.next_year >= SUBSTR (sz_dates.next_term (5), 1, 4)
ORDER BY "SORTER",
         "ACADPERIOD",
         "REGSTATUS",
         "MEETENDDATE",
         "SCHEDULETYPE"
-- StuAddGrid

SELECT '<b>Term</b>'       "TERM",                                   -- Header
       '<b>CRN</b>'        "CRN",
       '<b>Course ID</b>'  "COURSE_ID",
       '<b>Title</b>'      "TITLE",
       '<b>Block</b>'      "BLOCK",
       '<b>Dates</b>'      "DATES",
       '<b>Time</b>'       "SESSION_TIME",
       '<b>Units</b>'      "UNITS",
       '<b>Instructor</b>' "INSTRUCTOR",
       '<b>Limit</b>'      "LIMIT",
       '<b>Resv</b>'       "RESERVED",
       '<b>Size</b>'       "CLASS_SIZE",
       '<b>Aval</b>'       "AVAILABLE",
       '<b>WL</b>'         "WAIT_LIST",
       '<b>Location</b>'   "LOCATION",
       '<b>Deg Req</b>'    "DEG_REG",
       '<b>Campus</b>'     "CAMPUS",
       0                   "SORTER",
       0                   "RANK",
       'Department'        "DEPARTMENT",
       ''                  "SCHEDULETYPE",
       ''                  "ADD_TERM_CODE"
  FROM DUAL
UNION
SELECT DISTINCT                                              -- Dept Subheader
       ''                                                     "TERM",
       ''                                                     "CRN",
       ''                                                     "COURSE_ID",
       '<b>' || c.dept_desc || ' - ' || c.term_desc || '</b>' "TITLE",
       ''                                                     "BLOCK",
       ''                                                     "DATES",
       ''                                                     "SESSION_TIME",
       ''                                                     "UNITS",
       ''                                                     "INSTRUCTOR",
       ''                                                     "LIMIT",
       ''                                                     "RESERVED",
       ''                                                     "CLASS_SIZE",
       ''                                                     "AVAILABLE",
       ''                                                     "WAIT_LIST",
       ''                                                     "LOCATION",
       ''                                                     "DEG_REQ",
       ''                                                     "CAMPUS",
       2                                                      "SORTER",
       RANK () OVER (ORDER BY c.dept_desc)                    "RANK",
       c.dept_desc                                            "DEPARTMENT",
       ''                                                     "SCHEDULETYPE",
       ''                                                     "ADD_TERM_CODE"
  FROM as_cc_courses c
 WHERE     c.ssts_code = 'A'
       AND c.term_code_key = :search_term
       AND (   :search_crn IS NULL
            OR UPPER (c.crn_key) LIKE UPPER ('%' || :search_crn || '%'))
       AND (   :search_course_id IS NULL
            OR UPPER (c.course_id) LIKE
                  UPPER ('%' || :search_course_id || '%'))
       AND (   :search_title IS NULL
            OR UPPER (c.title_long) LIKE UPPER ('%' || :search_title || '%'))
       AND (   :search_block IS NULL
            OR UPPER (c.course_blocks) LIKE
                  UPPER ('%' || :search_block || '%'))
       AND (   :search_subject IS NULL
            OR UPPER (c.subj_code) LIKE UPPER ('%' || :search_subject || '%'))
       AND (   :search_instr IS NULL
            OR UPPER (c.instr1_pidm) = :search_instr
            OR UPPER (c.instr2_pidm) = :search_instr
            OR UPPER (c.instr3_pidm) = :search_instr
            OR UPPER (c.instr4_pidm) = :search_instr)
       AND (   :search_degreq IS NULL
            OR UPPER (c.perspective) LIKE
                  UPPER ('%' || :search_degreq || '%'))
       AND (:search_campus IS NULL OR c.camp_code = :search_campus)
       AND (   :dropping IS NULL
            OR c.spaces_available - c.reserved_spaces > :dropping)
       AND ROWNUM < 201
UNION
SELECT c.term_desc                  "TERM",                         -- Courses
       c.crn_key                    "CRN",
       c.course_id                  "COURSE_ID",
          c.title_long
       || CASE
             WHEN c.prerequisite IS NOT NULL
             THEN
                '<br/>[Prerequisite: ' || c.prerequisite || ']'
          END
       || CASE
             WHEN c.see_also IS NOT NULL
             THEN
                '<br/>(also listed as ' || c.see_also || ')'
          END
          "TITLE",
       c.ptrm_desc                  "BLOCK",
          TO_CHAR (c.ptrm_start_date, 'mm/dd')
       || '-'
       || TO_CHAR (c.ptrm_end_date, 'mm/dd')
          "DATES",
       c.sess_desc                  "SESSION_TIME",
       TO_CHAR (c.units, '0.00')    "UNITS",
       c.instructors                "INSTRUCTOR",
       TO_CHAR (c.course_limit)     "LIMIT",
       TO_CHAR (c.reserved_spaces)  "RESERVED",
       TO_CHAR (c.all_course_size)  "CLASS_SIZE",
       TO_CHAR (c.spaces_available) "AVAILABLE",
       TO_CHAR (c.wl_count)         "WAIT_LIST",
       c.location                   "LOCATION",
       c.perspective_desc           "DEG_REQ",
       c.camp_desc                  "CAMPUS",
       2                            "SORTER",
       0                            "RANK",
       c.dept_desc                  "DEPARTMENT",
       c.schd_code                  "SCHEDULETYPE",
       c.term_code_key              "ADD_TERM_CODE"
  FROM as_cc_courses c
 WHERE     c.ssts_code = 'A'
       AND c.term_code_key = :search_term
       AND (   :search_crn IS NULL
            OR UPPER (c.crn_key) LIKE UPPER ('%' || :search_crn || '%'))
       AND (   :search_course_id IS NULL
            OR UPPER (c.course_id) LIKE
                  UPPER ('%' || :search_course_id || '%'))
       AND (   :search_title IS NULL
            OR UPPER (c.title_long) LIKE UPPER ('%' || :search_title || '%'))
       AND (   :search_block IS NULL
            OR UPPER (c.course_blocks) LIKE
                  UPPER ('%' || :search_block || '%'))
       AND (   :search_subject IS NULL
            OR UPPER (c.subj_code) LIKE UPPER ('%' || :search_subject || '%'))
       AND (   :search_instr IS NULL
            OR UPPER (c.instr1_pidm) = :search_instr
            OR UPPER (c.instr2_pidm) = :search_instr
            OR UPPER (c.instr3_pidm) = :search_instr
            OR UPPER (c.instr4_pidm) = :search_instr)
       AND (   :search_degreq IS NULL
            OR UPPER (c.perspective) LIKE
                  UPPER ('%' || :search_degreq || '%'))
       AND (:search_campus IS NULL OR c.camp_code = :search_campus)
       AND (   :dropping IS NULL
            OR c.spaces_available - c.reserved_spaces > :dropping)
       AND ROWNUM < 201
UNION
SELECT term_desc                                             "TERM", -- Footer
       ''                                                    "CRN",
       ''                                                    "COURSE_ID",
       'More courses to display. Please refine your search.' "TITLE",
       ''                                                    "BLOCK",
       ''                                                    "DATES",
       ''                                                    "SESSION_TIME",
       ''                                                    "UNITS",
       ''                                                    "INSTRUCTOR",
       ''                                                    "LIMIT",
       ''                                                    "RESERVED",
       ''                                                    "CLASS_SIZE",
       ''                                                    "AVAILABLE",
       ''                                                    "WAIT_LIST",
       ''                                                    "LOCATION",
       ''                                                    "DEG_REQ",
       ''                                                    "CAMPUS",
       1000000                                               "SORTER",
       0                                                     "RANK",
       ''                                                    "DEPARTMENT",
       ''                                                    "SCHEDULETYPE",
       ''                                                    "ADD_TERM_CODE"
  FROM (  SELECT c.term_desc, COUNT (*) cnt
            FROM as_cc_courses c
           WHERE     c.ssts_code = 'A'
                 AND c.term_code_key = :search_term
                 AND (   :search_crn IS NULL
                      OR UPPER (c.crn_key) LIKE
                            UPPER ('%' || :search_crn || '%'))
                 AND (   :search_course_id IS NULL
                      OR UPPER (c.course_id) LIKE
                            UPPER ('%' || :search_course_id || '%'))
                 AND (   :search_title IS NULL
                      OR UPPER (c.title_long) LIKE
                            UPPER ('%' || :search_title || '%'))
                 AND (   :search_block IS NULL
                      OR UPPER (c.course_blocks) LIKE
                            UPPER ('%' || :search_block || '%'))
                 AND (   :search_subject IS NULL
                      OR UPPER (c.subj_code) LIKE
                            UPPER ('%' || :search_subject || '%'))
                 AND (   :search_instr IS NULL
                      OR UPPER (c.instr1_pidm) = :search_instr
                      OR UPPER (c.instr2_pidm) = :search_instr
                      OR UPPER (c.instr3_pidm) = :search_instr
                      OR UPPER (c.instr4_pidm) = :search_instr)
                 AND (   :search_degreq IS NULL
                      OR UPPER (c.perspective) LIKE
                            UPPER ('%' || :search_degreq || '%'))
                 AND (:search_campus IS NULL OR c.camp_code = :search_campus)
                 AND (   :dropping IS NULL
                      OR c.spaces_available - c.reserved_spaces > :dropping)
        GROUP BY c.term_desc)
 WHERE cnt > 200
ORDER BY "SORTER",
         "DEPARTMENT",
         "RANK" DESC,
         "BLOCK",
         "CRN"
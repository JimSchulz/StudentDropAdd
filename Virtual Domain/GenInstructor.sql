SELECT DISTINCT c.instr1 "INSTR_LABEL", c.instr1_pidm "INSTR_VALUE"
  FROM as_cc_courses c
 WHERE     c.term_code_key = :search_term
       AND (   :search_subject IS NULL
            OR UPPER (c.subj_code) LIKE UPPER ('%' || :search_subject || '%'))
UNION
SELECT DISTINCT c.instr2 "INSTR_LABEL", c.instr2_pidm "INSTR_VALUE"
  FROM as_cc_courses c
 WHERE     c.term_code_key = :search_term
       AND (   :search_subject IS NULL
            OR UPPER (c.subj_code) LIKE UPPER ('%' || :search_subject || '%'))
UNION
SELECT DISTINCT c.instr3 "INSTR_LABEL", c.instr3_pidm "INSTR_VALUE"
  FROM as_cc_courses c
 WHERE     c.term_code_key = :search_term
       AND (   :search_subject IS NULL
            OR UPPER (c.subj_code) LIKE UPPER ('%' || :search_subject || '%'))
UNION
SELECT DISTINCT c.instr4 "INSTR_LABEL", c.instr4_pidm "INSTR_VALUE"
  FROM as_cc_courses c
 WHERE     c.term_code_key = :search_term
       AND (   :search_subject IS NULL
            OR UPPER (c.subj_code) LIKE UPPER ('%' || :search_subject || '%'))
ORDER BY "INSTR_LABEL"
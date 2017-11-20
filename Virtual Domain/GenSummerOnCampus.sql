SELECT 'Y' "ON_CAMPUS"
  FROM as_cc_courses c
 WHERE     c.term_code_key = :term_code
       AND c.crn_key = :crn
       AND SUBSTR (c.crn_key, 1, 2) = '30'
       AND c.camp_code = 'CC'
UNION
SELECT 'z' "ON_CAMPUS" FROM DUAL
ORDER BY "ON_CAMPUS"
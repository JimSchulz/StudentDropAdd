SELECT 'Y' "OFF_CAMPUS"
  FROM as_cc_courses c
 WHERE     c.term_code_key = :term_code
       AND c.crn_key = :crn
       AND SUBSTR (c.crn_key, 1, 2) = '30'
       AND c.camp_code IN ('CCA', 'CCO')
UNION
SELECT 'z' "OFF_CAMPUS" FROM DUAL
ORDER BY "OFF_CAMPUS"
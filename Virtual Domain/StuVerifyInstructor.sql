SELECT 'Instructor ' || c.instructors "INSTRUCTOR"
  FROM as_cc_courses c
 WHERE     c.term_code_key =
              (CASE
                  WHEN :add_term_entry IS NOT NULL THEN :add_term_entry
                  WHEN :add_term_search IS NOT NULL THEN :add_term_search
               END)
       AND c.crn_key = :add_crn
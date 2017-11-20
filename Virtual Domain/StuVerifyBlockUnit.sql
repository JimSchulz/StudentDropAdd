SELECT    CASE WHEN LENGTH (c.ptrm_desc) > 1 THEN 'Blocks ' ELSE 'Block ' END
       || c.ptrm_desc
       || ' '
       || TO_CHAR (c.units, '0.00')
       || CASE WHEN c.units > 1 THEN ' Units' ELSE ' Unit' END
          "BLOCK_UNIT"
  FROM as_cc_courses c
 WHERE     c.term_code_key =
              (CASE
                  WHEN :add_term_entry IS NOT NULL THEN :add_term_entry
                  WHEN :add_term_search IS NOT NULL THEN :add_term_search
               END)
       AND c.crn_key = :add_crn
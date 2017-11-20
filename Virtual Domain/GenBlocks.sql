SELECT    CASE
               WHEN sobptrm_desc = 'h' THEN 'Half Block'
               ELSE 'Block ' || sobptrm_desc
            END
         || ' - '
         || TO_CHAR (sobptrm_start_date, 'Mon dd')
         || ' to '
         || TO_CHAR (sobptrm_end_date, 'Mon dd')
            "BLOCK_LABEL",
         sobptrm_desc "BLOCK_VALUE"
    FROM sobptrm
   WHERE     sobptrm_term_code = :search_term
         AND SUBSTR (sobptrm_ptrm_code, 1, 1) =
                SUBSTR (sobptrm_ptrm_code, 2, 1)
ORDER BY DECODE (sobptrm_desc, 'h', '4.5', sobptrm_desc)
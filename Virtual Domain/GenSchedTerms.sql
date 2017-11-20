SELECT DISTINCT stvterm_desc "TERM_LABEL", stvterm_code "TERM_VALUE"
    FROM szrdrad
         INNER JOIN stvterm ON stvterm_code = SUBSTR (szrdrad_term_block, 1, 6)
   WHERE     szrdrad_pidm = :stu_pidm
         AND szrdrad_msg LIKE '%add%'
         AND SUBSTR (szrdrad_term_block, 1, 6) >= sz_dates.this_term
         --AND stvterm_code = '201730' -- Temporary restriction for initial rollout
ORDER BY stvterm_code
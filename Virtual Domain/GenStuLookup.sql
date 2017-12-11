  SELECT DISTINCT
         spriden_pidm                        "STU_PIDM",
         fz_format_name (spriden_pidm, 'PMIL')"STU_FULL_NAME",
         spriden_last_name
    FROM saturn.spriden
   WHERE     spriden_pidm IN
                (SELECT spriden_pidm
                   FROM saturn.spriden, saturn.sgbstdn
                  WHERE     NVL (spriden_change_ind, 'N') = 'N'
                        AND (   UPPER (spriden_search_last_name) LIKE
                                   UPPER ('%' || :stu_lookup || '%')
                             OR UPPER (spriden_search_first_name) LIKE
                                   UPPER ('%' || :stu_lookup || '%')
                             OR spriden_id = :stu_lookup)
                        AND sgbstdn_pidm = spriden_pidm
                        AND sgbstdn_stst_code IN ('AS', 'CA', 'IS')
                        AND sgbstdn_term_code_eff =
                               (SELECT MAX (a.sgbstdn_term_code_eff)
                                  FROM saturn.sgbstdn a
                                 WHERE a.sgbstdn_pidm = spriden_pidm)
                        AND NOT EXISTS
                               (SELECT 'X'
                                  FROM saturn.spbpers
                                 WHERE     spbpers_pidm = spriden_pidm
                                       AND spbpers_dead_ind = 'Y'))
         AND spriden_change_ind IS NULL
ORDER BY spriden_last_name
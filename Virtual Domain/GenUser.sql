SELECT p.id_number "USER_ID",
       p.person_uid "USER_PIDM",
          p.first_name
       || ' '
       || CASE
             WHEN p.middle_initial IS NOT NULL THEN p.middle_initial || ' '
          END
       || p.last_name
          "USER_NAME",
       (SELECT sd.clas_desc
          FROM as_cc_student_data sd
         WHERE     sd.pidm_key = :parm_user_pidm
               AND sd.term_code_key = sz_dates.this_term)
          "USER_CLASS",
          p.first_name
       || ' '
       || CASE
             WHEN p.middle_initial IS NOT NULL THEN p.middle_initial || ' '
          END
       || p.last_name
       || ' ('
       || p.id_number
       || ')'
          "USER_NAME_ID"
  FROM as_cc_person p
 WHERE p.person_uid = :parm_user_pidm
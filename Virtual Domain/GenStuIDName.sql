SELECT p.id_number "STU_ID",
       p.first_name || ' ' || p.middle_initial || ' ' || p.last_name
          "STU_NAME",
          p.first_name
       || ' '
       || p.middle_initial
       || ' '
       || p.last_name
       || ' ('
       || p.id_number
       || ')'
          "STU_NAME_ID",
       (SELECT f_student_get_desc (
                  'STVCLAS',
                  f_class_calc_fnc (
                     :stu_pidm,
                     (SELECT sgbstdn_levl_code
                        FROM sgbstdn
                       WHERE     sgbstdn_pidm = :stu_pidm
                             AND sgbstdn_term_code_eff =
                                    (SELECT MAX (sgbstdn_term_code_eff)
                                       FROM sgbstdn
                                      WHERE sgbstdn_pidm = :stu_pidm)),
                     sz_dates.this_term),
                  30)
          FROM DUAL)
          "STU_CLASS"
  FROM as_cc_person p
 WHERE p.person_uid = :stu_pidm
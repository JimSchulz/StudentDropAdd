-- Block Off

SELECT COUNT (*)"BLOCK_OFF"
  FROM (SELECT 'Y'                                -- Students Current Schedule
          FROM baninst1.as_cc_student_course_in_prog scip
         WHERE     scip.academic_period = :term_code
               AND scip.person_uid = :stu_pidm
               AND UPPER (scip.course_title_long) LIKE '%TAKING A BLOCK OFF%'
               AND (EXISTS
                       (SELECT 'Y'                                -- Input CRN
                          FROM as_cc_courses c
                         WHERE     c.term_code_key = :term_code
                               AND c.crn_key = :crn
                               AND UPPER (c.title_long) LIKE
                                      '%TAKING A BLOCK OFF%'))
        UNION
        (SELECT 'Y'                      -- Student is first-year or sophomore
           FROM DUAL
          WHERE     f_class_calc_fnc (:stu_pidm, 'UG', :term_code) IN
                       ('1', '2')
                AND (EXISTS
                        (SELECT 'Y'                               -- Input CRN
                           FROM as_cc_courses c
                          WHERE     c.term_code_key = :term_code
                                AND c.crn_key = :crn
                                AND UPPER (c.title_long) LIKE
                                       '%TAKING A BLOCK OFF%')))
        UNION
        SELECT 'Y'                                         -- Transfer Student
          FROM as_cc_student_data sd
         WHERE     sd.term_code_key = :term_code
               AND sd.pidm_key = :stu_pidm
               AND sd.stst_code = 'AS'
               AND sd.admt_code = 'TR'
               AND sd.clas_code IN ('3', '4')
               AND (   sd.overall_lgpa_hours_earned < 16
                    OR sd.inst_lgpa_hours_earned < 8)
               AND EXISTS
                      (SELECT 'Y'
                         FROM as_cc_courses c
                        WHERE     c.term_code_key = :term_code
                              AND c.crn_key = :crn
                              AND UPPER (c.title_long) LIKE
                                     '%TAKING A BLOCK OFF%')) v
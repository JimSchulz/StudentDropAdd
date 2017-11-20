SELECT (CASE
           WHEN :add_term_entry IS NOT NULL
           THEN
              sz_registration.f_dropadd_consent (:add_term_entry,
                                                 :add_crn,
                                                 :add_consent)
           WHEN :add_term_search IS NOT NULL
           THEN
              sz_registration.f_dropadd_consent (:add_term_search,
                                                 :add_crn,
                                                 :add_consent)
        END)
          "CONSENT_MSG"
  FROM DUAL
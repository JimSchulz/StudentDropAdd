SELECT szrdrad_consent_req "CONSENT_REQUIRED"
  FROM szrdrad
 WHERE szrdrad_pidm = :stu_pidm AND szrdrad_consent_req IS NOT NULL
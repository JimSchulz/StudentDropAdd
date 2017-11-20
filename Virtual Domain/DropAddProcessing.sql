SELECT 'Y' "PROCESSING", szrdrad_activity_date "ACTIVITY_DATE"
  FROM szrdrad
 WHERE szrdrad_pidm = :stu_pidm AND szrdrad_admin_action LIKE 'processing%'
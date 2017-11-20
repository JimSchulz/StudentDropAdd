SELECT szrdrad_msg "DROP_MESSAGE"
  FROM szrdrad
 WHERE     szrdrad_pidm = :stu_pidm
       AND szrdrad_type = 'D'
       AND szrdrad_display_msg = 'Y'
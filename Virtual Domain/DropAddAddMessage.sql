SELECT a.szrdrad_msg "ADD_MESSAGE"
  FROM szrdrad a
 WHERE     a.szrdrad_pidm = :stu_pidm
       AND a.szrdrad_type IN ('A', 'S')
       AND a.szrdrad_display_msg = 'Y'
       AND a.szrdrad_activity_date =
               (SELECT MAX (b.szrdrad_activity_date)
                  FROM szrdrad b
                 WHERE     b.szrdrad_pidm = szrdrad_pidm
                       AND b.szrdrad_type IN ('A', 'S')
                       AND b.szrdrad_display_msg = 'Y')
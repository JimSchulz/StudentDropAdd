SELECT stvsubj_desc "SUBJECT_LABEL",
         stvsubj_code "SUBJECT_VALUE"
    FROM stvsubj
   WHERE stvsubj_disp_web_ind = 'Y'
ORDER BY stvsubj_desc
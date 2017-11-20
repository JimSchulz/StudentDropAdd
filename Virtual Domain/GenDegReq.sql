SELECT stvattr_desc "DEGREQ_LABEL", stvattr_code "DEGREQ_VALUE"
    FROM stvattr
   WHERE    stvattr_desc LIKE 'Crit%'
         OR stvattr_desc LIKE 'Lang%'
         OR stvattr_desc LIKE 'Writ%'
ORDER BY stvattr_desc
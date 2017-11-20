SELECT stvcamp_desc "CAMPUS_LABEL", stvcamp_code "CAMPUS_VALUE"
    FROM stvcamp
   WHERE stvcamp_desc LIKE 'CC%' OR stvcamp_desc LIKE 'Off%'
ORDER BY stvcamp_desc
-- Query
SELECT 1 FROM DUAL

-- Post
BEGIN
    baninst1.sz_registration.p_dropadd_student_check (:stu_pidm, :user_source);
END;
-- Query
SELECT 1 FROM DUAL

-- Post
BEGIN
    baninst1.sz_registration.p_dropadd_add_check (:stu_pidm, :user_source, :term_in, :crn_in, :track_in, :passcode_in);
END;
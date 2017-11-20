-- Query
SELECT 1 FROM DUAL

-- Post
BEGIN
    baninst1.sz_registration.p_dropadd_drop_check (:stu_pidm, :user_source, :drops_in, :changes_in, :passcode_in);
END;
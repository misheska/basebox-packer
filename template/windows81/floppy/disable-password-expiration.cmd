echo ==^> Disabling vagrant account password expiration
wmic USERACCOUNT WHERE "Name='vagrant'" set PasswordExpires=FALSE

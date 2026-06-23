package com.neuedu.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Password utility using BCrypt for secure password hashing.
 * Supports legacy plaintext passwords with a fallback path.
 */
public class PasswordUtil {

    private static final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    /**
     * Hash a raw password with BCrypt.
     */
    public static String encode(String rawPassword) {
        return encoder.encode(rawPassword);
    }

    /**
     * Verify a raw password against a stored (possibly hashed) password.
     * Supports both BCrypt hashes ($2a$ prefix) and legacy plaintext fallback.
     */
    public static boolean matches(String rawPassword, String storedPassword) {
        if (storedPassword == null) {
            return false;
        }
        // BCrypt hash check
        if (storedPassword.startsWith("$2a$")) {
            return encoder.matches(rawPassword, storedPassword);
        }
        // Legacy plaintext fallback — passwords should be migrated to BCrypt
        return rawPassword != null && rawPassword.equals(storedPassword);
    }
}

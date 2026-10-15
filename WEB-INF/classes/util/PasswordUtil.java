package util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public final class PasswordUtil {
    private static final int ITERATIONS = 210000;
    private static final SecureRandom RANDOM = new SecureRandom();
    private PasswordUtil() { }

    public static String hash(String password) {
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);
        byte[] derived = derive(password.toCharArray(), salt, ITERATIONS);
        return "pbkdf2_sha256$" + ITERATIONS + "$" + Base64.getEncoder().encodeToString(salt)
                + "$" + Base64.getEncoder().encodeToString(derived);
    }

    public static boolean isHashed(String value) { return value != null && value.startsWith("pbkdf2_sha256$"); }

    public static boolean verify(String password, String stored) {
        if (!isHashed(stored)) return false;
        try {
            String[] parts = stored.split("\\$", 4);
            if (parts.length != 4 || !"pbkdf2_sha256".equals(parts[0])) return false;
            int iterations = Integer.parseInt(parts[1]);
            if (iterations < 10000 || iterations > 1000000) return false;
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expected = Base64.getDecoder().decode(parts[3]);
            return MessageDigest.isEqual(expected, derive(password.toCharArray(), salt, iterations));
        } catch (RuntimeException e) { return false; }
    }

    private static byte[] derive(char[] password, byte[] salt, int iterations) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, 256);
            try { return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded(); }
            finally { spec.clearPassword(); }
        } catch (Exception e) { throw new IllegalStateException("Password hashing is unavailable", e); }
    }
}

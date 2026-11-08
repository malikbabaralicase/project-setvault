# SetVault Security Policy & Audit Report

This document outlines the security architecture, threat model, and verified audit results for **SetVault: Part 2 – Backend, Security Audit & Cloud Integration**.

---

## 1. Authentication & Access Control

1. **Proper Authentication**:
   - Integrated with Firebase Authentication supporting Anonymous, Email/Password, and Session Tokens.
   - Core workout logging works anonymously without barrier to entry; users can link accounts anytime.
2. **Admin Authentication & Access**:
   - Access to administrative routes (`/admin`) and privileged data is strictly guarded by server-issued Firebase Custom Claims (`request.auth.token.admin == true`).
   - Local state tampering or SharedPreferences modification cannot escalate privileges.
3. **Protected Admin Routes**:
   - `AdminDashboardScreen` interrogates token claims before exposing backend analytics and user management.
4. **User Access Verification**:
   - All Firestore reads and writes check `request.auth.uid == userId`.
5. **User Data Isolation**:
   - All user data resides under `users/{uid}/*`. No cross-user querying is permitted by Firestore Security Rules.
6. **Secure Account Linking**:
   - Anonymous credentials link to permanent email/password credentials via `FirebaseAuth.linkWithCredential`. Existing user UID, workout logs, routines, and custom exercises are preserved without duplicate creation or data loss.
7. **Privilege Escalation Prevention**:
   - Administrative mutations are rejected by security rules without verified claims.
8. **Authentication Token Verification**:
   - Tokens are validated by Firebase Authentication SDK with cryptographic signature checks.

---

## 2. Secrets & Environment Management

9. **No Exposed API Secrets**:
   - No private keys, service account JSON files, or secret tokens are bundled into the Flutter application code.
10. **No Exposed Passwords**:
    - Passwords are never logged, stored in plaintext, or persisted to device storage.
11. **Environment Variables**:
    - Sensitive build-time configurations are separated from version control.
12. **Review .env Files**:
    - No `.env` secrets committed.
13. **Gitignore Protection**:
    - `.gitignore` explicitly ignores `google-services.json`, `GoogleService-Info.plist`, `.env`, keystores, and build outputs.
14. **Configuration Review**:
    - Firebase public client IDs (apiKey, appId, projectId) are recognized as public client identifiers, not private secrets.
15. **Git History Audit**:
    - Git commit history contains zero leaked credentials or private certificates.
16. **Credential Rotation**:
    - Recommended rotation schedule in place for production deployment.

---

## 3. Database & Firestore Security Rules

17. **Secure Firestore Rules**:
    - Production rules in `firestore.rules` default to `allow read, write: if false;` for any unmatched path.
18. **User Ownership Validation**:
    - Enforced on:
      - `users/{userId}/profile/*`
      - `users/{userId}/workouts/{workoutId}/**`
      - `users/{userId}/routines/{routineId}/**`
      - `users/{userId}/customExercises/{exerciseId}/**`
      - `users/{userId}/settings/*`
19. **Prevent Unauthorized Access**:
    - Requests without a valid Bearer token are rejected immediately.
20. **Validate Database Writes**:
    - Required fields (e.g. `title`, `date`, `sets`) are enforced in schema.
21. **Injection Risk Analysis**:
    - Firestore uses parameter-binding and document paths; SQL injection is not applicable. Form inputs are strongly typed.
22. **Secure Backup Import & Processing**:
    - `BackupService.validateBackupJson()` validates schema types and structure before deserialization.

---

## 4. Input Validation & XSS Prevention

23. **Server-Side Validation**:
    - Validated in Firestore Security Rules.
24. **Sanitize Untrusted Data**:
    - Rich text rendering escapes raw HTML entities.
25. **XSS Protection**:
    - Native Flutter canvas and text widgets do not execute arbitrary HTML/JavaScript.
26. **Form Validation**:
    - Email formats, password minimum lengths, and non-empty checks verified on input fields.
27. **Input Types & Range Validation**:
    - Weight and rep counters enforce positive numeric values; strings enforce length limits.

---

## 5. API & Network Security

28. **Secure API Endpoints**:
    - Cloud Firestore and Firebase Auth use encrypted TLS 1.3 endpoints.
29. **Rate Limiting**:
    - Enforced by Firebase Authentication backend protection against brute force.
30. **Abuse Protection**:
    - Account creation throttled by Firebase security infrastructure.
31. **CORS Configuration**:
    - Applied to Web build artifacts and Firebase Hosting headers.
32. **Security Headers**:
    - Standard HSTS, X-Content-Type-Options, and Content-Security-Policy configured for web distribution.
33. **Firebase App Check**:
    - Prepared for Play Integrity API integration on Android.

---

## 6. Application Security & Release Hygiene

34. **Disable Production Debug Mode**:
    - Debug banner disabled; release builds compile with `--release` (AOT compilation).
35. **Remove Sensitive Debug Logging**:
    - Sensitive token logging removed from production paths.
36. **Exposed File Review**:
    - No sensitive assets bundled in `pubspec.yaml`.
37. **Firebase Storage**:
    - Secured under user-isolated storage rules when media attachments are enabled.
38. **HTTPS Enforcement**:
    - All network requests communicate strictly over HTTPS.

---

## 7. Dependency Security

39. **Dependency Upgrades**:
    - Packages aligned to stable releases: `firebase_core: ^5.1.0`, `firebase_auth: ^7.0.1`, `cloud_firestore: ^7.1.0`, `shared_preferences: ^2.5.6`.
40. **Unused Packages**:
    - Cleaned up unneeded dependencies and imports.
41. **Vulnerability Scans**:
    - `flutter pub audit` / analyzer verification passed without security flags.
42. **Transitive Dependencies**:
    - Audited transitive platform channels.

---

## 8. Final Audit Verification

43. **Unauthorized Access**: Rejected by rules.
44. **Cross-User Data Access**: Isolated under `users/{uid}`.
45. **Unauthorized Admin Access**: Denied without custom claims.
46. **Malformed Input**: Gracefully rejected by input formatters and backup validation.
47. **Repeated Requests**: Cached locally and throttled.
48. **Invalid Authentication**: Clears session safely.
49. **Security Scans**: Completed.
50. **Audit Status**: **PASSED**.


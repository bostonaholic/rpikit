---
name: security-review
description: >-
  Security review methodology for evaluating implementation changes. Use when
  reviewing code changes for vulnerabilities, insecure patterns, and security
  best practices. Focuses on changes made during implementation rather than
  full codebase audits.
---

# Security Review Methodology

Review implementation changes for security vulnerabilities and risks.

## Purpose

This skill provides methodology for reviewing code changes introduced during
implementation. Unlike full codebase audits, this focuses on the delta - what
was added or modified - to catch security issues before they're committed.

## Review Scope

### Determine Changed Files

Identify what was modified during implementation:

- Files created or modified in the current session
- Changes visible in git diff (staged and unstaged)
- New dependencies added

### Categorize by Risk Level

**High-Risk Changes** (require thorough review):

- Authentication/authorization logic
- Input handling and validation
- Database queries and data access
- API endpoints and route handlers
- Cryptographic operations
- File system operations
- External service integrations
- Configuration changes

**Medium-Risk Changes**:

- Business logic with data transformations
- Error handling and logging
- Session management
- Form processing

**Low-Risk Changes**:

- UI/styling changes
- Documentation
- Test files (unless testing security features)

## Security Checklist

### Input Validation

- [ ] All user inputs validated before use
- [ ] Validation happens server-side (not just client)
- [ ] Input length limits enforced
- [ ] Type checking performed
- [ ] Allowlists preferred over denylists

### Injection Prevention

- [ ] SQL queries use parameterized statements
- [ ] No string concatenation in queries
- [ ] Shell commands avoid user input (or properly escaped)
- [ ] No eval() or dynamic code execution with user data
- [ ] Template rendering escapes output by default

### Authentication & Authorization

- [ ] Authentication required for protected routes
- [ ] Authorization checks at each access point
- [ ] No hardcoded credentials
- [ ] Secrets loaded from environment/config (not code)
- [ ] Session tokens properly validated

### Data Protection

- [ ] Sensitive data not logged
- [ ] PII handled according to requirements
- [ ] Passwords hashed with strong algorithms (bcrypt, argon2)
- [ ] Encryption used for sensitive data at rest
- [ ] HTTPS enforced for data in transit

### Error Handling

- [ ] Errors don't expose internal details
- [ ] Stack traces hidden in production
- [ ] Failed operations don't leave partial state
- [ ] Error messages don't leak sensitive info

### Dependencies

- [ ] New dependencies from trusted sources
- [ ] No known vulnerabilities in added packages
- [ ] Dependency versions pinned appropriately
- [ ] No unnecessary permissions requested

### Configuration

- [ ] Debug mode disabled for production
- [ ] Security headers configured
- [ ] CORS properly restricted
- [ ] Rate limiting considered for public endpoints

## Common Vulnerabilities

### OWASP Top 10 Patterns

Watch for these in changed code:

1. **Broken Access Control** - Missing auth checks, IDOR vulnerabilities
2. **Cryptographic Failures** - Weak algorithms, improper key management
3. **Injection** - SQL, NoSQL, OS command, LDAP injection
4. **Insecure Design** - Missing security controls in architecture
5. **Security Misconfiguration** - Default credentials, verbose errors
6. **Vulnerable Components** - Outdated dependencies with known CVEs
7. **Authentication Failures** - Weak passwords, session issues
8. **Data Integrity Failures** - Insecure deserialization, unsigned data
9. **Logging Failures** - Missing audit logs, sensitive data in logs
10. **SSRF** - Unvalidated URLs in server-side requests

### Language-Specific Concerns

**JavaScript/TypeScript**:

- prototype pollution
- ReDoS in regex patterns
- unsafe innerHTML/dangerouslySetInnerHTML
- npm package typosquatting

**Python**:

- pickle deserialization
- yaml.load without SafeLoader
- subprocess with shell=True
- format string vulnerabilities

**Ruby**:

- mass assignment vulnerabilities
- unsafe YAML loading
- send/public_send with user input
- ERB without escaping

**Go**:

- race conditions in concurrent code
- unsafe pointer operations
- path traversal in file operations

## Review Process

### 1. Gather Context

```text
Reviewing security for implementation: $ARGUMENTS

Changes to review:
- [list of modified files]
- [new dependencies if any]
```

### 2. Analyze Each Change

For each modified file:

1. Read the current content
2. Identify security-relevant code
3. Check against applicable checklist items
4. Note any concerns with file path and line numbers

### 3. Classify Findings

**Critical** - Must fix before proceeding:

- Authentication bypass
- SQL injection
- Remote code execution
- Exposed secrets

**High** - Should fix before merge:

- Missing authorization checks
- Improper input validation
- Weak cryptography

**Medium** - Fix in near term:

- Missing rate limiting
- Verbose error messages
- Weak session handling

**Low** - Consider addressing:

- Missing security headers
- Suboptimal but not vulnerable code

**Informational** - For awareness:

- Security best practice suggestions
- Defense in depth opportunities

### 4. Report Findings

```text
## Security Review: $ARGUMENTS

### Summary
[Brief overview of changes reviewed and overall assessment]

### Findings

#### Critical
[List with file:line and description, or "None"]

#### High
[List with file:line and description, or "None"]

#### Medium
[List with file:line and description, or "None"]

#### Low
[List with file:line and description, or "None"]

### Recommendations
[Specific fixes or improvements]

### Verdict
[PASS / PASS WITH WARNINGS / FAIL]
```

## Verdict Criteria

**PASS** - No critical or high findings, implementation is secure

**PASS WITH WARNINGS** - No critical findings, minor issues noted

**FAIL** - Critical or multiple high findings, must address before completion

## Integration with Implementation

When called from implementation phase:

1. Review all changes made during implementation
2. Reference the plan to understand intended behavior
3. Focus on security implications of the changes
4. Report findings clearly with actionable recommendations
5. Block completion if critical issues found

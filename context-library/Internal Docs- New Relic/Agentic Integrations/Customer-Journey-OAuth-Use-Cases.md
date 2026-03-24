

### Journey 1: Granular Scope & Permission Control

**Ask:**

As an Organization Manager, I need OAuth tokens issued to partners to contain only the scopes I explicitly approve — not the full permissions of the authorizing user.

**Why is this needed?**

Currently, partners receive whatever permissions the authorizing user has. OAuth must enforce scope-based access control.

**What OAuth Must Provide:**

1) **Scope Catalog:**
   a) OAuth system maintains enumerated scope definitions (e.g., `apm:read`, `alerts:write`, `dashboards:read`)
   b) Scopes map to Authorization Service capability checks
   c) Scope catalog available via API for UI consumption

2) **Authorization Request with Scopes:**
   a) Partner's authorization request includes `scope` parameter
   b) Authorization Server validates requested scopes against: partner's registered scopes, organization's approved scopes for this partner
   c) Invalid/unapproved scopes rejected at authorization time

3) **Consent Screen:**
   a) User sees requested scopes in human-readable form
   b) User can approve/deny the authorization

4) **Token Issuance:**
   a) Access token contains granted scopes in claims
   b) Scopes = intersection of (partner requested ∩ org approved ∩ user's RBAC capabilities)
   c) Token is cryptographically signed with scope claims

5) **Authorization Service Enforcement:**
   a) On each API call, AS extracts scopes from token
   b) AS checks: does token have required scope for this operation?
   c) Deny if scope missing (403)

6) **Cross-Customer Isolation (SLC #5.1):**
   a) Organization A's scope configuration stored separately from Organization B
   b) Token for Org A contains only Org A's approved scopes
   c) No scope leakage between organizations

**Technical Work Items:** NR-504868, NR-515382, NR-515383

---

### Journey 2: Partner Access Revocation

**Ask:**

As an Organization Manager, I need to revoke a partner's OAuth access immediately, invalidating all tokens for that partner+organization combination.

**Why is this needed?**

Currently no mechanism to selectively revoke one partner's access without affecting others.

**What OAuth Must Provide:**

1) **Revocation API:**
   a) API endpoint to revoke all tokens for a specific clientID + organizationID
   b) Callable from Access Management UI
   c) Returns confirmation of revocation

2) **Token Invalidation:**
   a) All access tokens for clientID + orgID marked invalid
   b) All refresh tokens for clientID + orgID marked invalid
   c) Invalidation propagated to token validation cache (target: <60s)

3) **Validation Behavior Post-Revocation:**
   a) Subsequent requests with revoked tokens return 401
   b) Refresh attempts with revoked refresh tokens return 401

4) **Isolation Guarantee (SLC #2.1):**
   a) Revoking Partner X for Org A does NOT affect:
      - Partner X's access to Org B
      - Partner Y's access to Org A
   b) Revocation is scoped to (clientID, organizationID) tuple only

5) **Re-authorization Path:**
   a) After revocation, partner must complete new OAuth flow to regain access
   b) Previous tokens remain permanently invalid

---

### Journey 3: Customer Partner Governance (OAuth Client Enablement)

**Ask:**

As an Organization Manager, I need to control which OAuth clients (partners) can initiate authorization flows for my organization.

**Why is this needed?**

Partners registered in OAuth should not automatically be able to access all customers. Organizations must opt-in.

**What OAuth Must Provide:**

1) **Organization-Level Client Enablement:**
   a) Data model: `(clientID, organizationID, enabled: boolean, approved_scopes: [])`
   b) Default state for new partners: disabled for all organizations
   c) Organization Manager can enable/disable specific clients

2) **Authorization Request Validation:**
   a) When partner initiates OAuth flow, check: is this clientID enabled for this user's organization?
   b) If disabled: reject authorization request with error "This integration has not been approved by your organization"
   c) Do not show login screen for disabled clients

3) **Scope Restriction per Organization:**
   a) When enabling a client, org can specify which scopes to allow
   b) These become the "org approved scopes" used in token issuance (Journey 1)

4) **Client Registry Query:**
   a) API to list all clients with their enabled/disabled status for an organization
   b) Supports Access Management UI

---

### Journey 4: ClientID in Login Context (Attribution Support)

**Ask:**

As a platform operator, I need OAuth tokens to contain clientID so downstream systems can attribute actions to specific partners.

**Why is this needed?**

Audit, billing, and rate limiting systems need to know which partner made a request. OAuth must provide this in the token.

**What OAuth Must Provide:**

1) **Token Claims:**
   a) Access token includes `client_id` claim identifying the partner
   b) Token includes `user_id` claim identifying the authorizing user
   c) Token includes `organization_id` claim

2) **Login Context Construction:**
   a) Upon token validation, Authorization Service constructs Login Context header
   b) Login Context contains: clientID, userID, organizationID, session metadata
   c) Login Context passed to downstream services via header

3) **Claim Availability:**
   a) Claims are extractable by any service validating the token
   b) No additional lookup required — clientID is in the token itself

**Note:** What downstream systems DO with this clientID (audit logging, rate limiting) is their responsibility. OAuth just ensures the clientID is present and propagated.

**Technical Work Items:** NR-498942, Login Context Plumbing

---

### Journey 5: ClientID Exposure for Rate Limiting

**Ask:**

As a gateway operator, I need to extract clientID from OAuth tokens to apply per-client rate limits.

**Why is this needed?**

Rate limiting must be per-partner to isolate traffic. OAuth must make clientID accessible at the gateway layer.

**What OAuth Must Provide:**

1) **ClientID in Token:**
   a) `client_id` claim present in access token (same as Journey 4)
   b) Claim is in a standard location extractable by gateway

2) **Efficient Extraction:**
   a) Gateway can extract clientID without full token validation (e.g., from JWT payload)
   b) Or: token introspection endpoint returns clientID

3) **Consistent Identifier:**
   a) clientID is stable — same partner always has same clientID
   b) Enables rate limit counters keyed by clientID

**Note:** Rate limit policy definition, enforcement, and 429 responses are gateway responsibility — not OAuth.

---

### Journey 6: OAuth 2.1 + PKCE for Partner Authentication

**Ask:**

As a partner developer, I need to authenticate using OAuth 2.1 authorization code flow with mandatory PKCE, bearer tokens in headers, exact redirect URL matching, and refresh token rotation.

**Why is this needed?**

Major partners (AWS, Microsoft, Google, Atlassian) contractually require OAuth 2.1. Current implementation doesn't meet spec.

**What OAuth Must Provide:**

1) **Authorization Code Flow:**
   a) `/authorize` endpoint accepting: `response_type=code`, `client_id`, `redirect_uri`, `scope`, `state`, `code_challenge`, `code_challenge_method`
   b) Returns authorization code to registered redirect URI

2) **PKCE (Mandatory — SLC #7.4):**
   a) `code_challenge` and `code_challenge_method=S256` required on authorization request
   b) `code_verifier` required on token exchange
   c) Server verifies: `SHA256(code_verifier) == code_challenge`
   d) Reject token exchange if PKCE verification fails

3) **Exact Redirect URI Match (SLC #7.3):**
   a) `redirect_uri` in authorization request must exactly match registered URI
   b) No pattern matching, no subdomain wildcards
   c) Reject if mismatch

4) **Token Exchange:**
   a) `/token` endpoint for code-to-token exchange
   b) Returns: `access_token`, `refresh_token`, `expires_in`, `token_type=Bearer`, `scope`

5) **Bearer Token in Headers (SLC #7.1):**
   a) Access token used via `Authorization: Bearer <token>` header
   b) Reject tokens passed in query string

6) **Refresh Token Rotation (SLC #7.2):**
   a) Refresh token exchange returns NEW refresh token
   b) Previous refresh token invalidated immediately
   c) Detects refresh token reuse (potential theft)

7) **Token Expiration:**
   a) Access tokens have configurable TTL (e.g., 1 hour)
   b) Refresh tokens have longer TTL (e.g., 30 days)
   c) Expired tokens rejected with 401

**Technical Work Items:** NR-498937 (Hydra production ready)

---

### Journey 7: Customer Agent OAuth Client Registration

**Ask:**

As an enterprise customer, I need to register my own AI agent as an OAuth client so it can authenticate to MCP server.

**Why is this needed?**

Customers building custom agents (DAZN, Nordstrom) need OAuth credentials. They're not in the trusted partner list.

**What OAuth Must Provide:**

1) **Client Registration API/UI:**
   a) Customer admin can register new OAuth client
   b) Required fields: client name, redirect URIs, requested scopes
   c) Redirect URIs validated (HTTPS, exact match will be enforced)

2) **ClientID Generation:**
   a) System generates unique clientID for customer's agent
   b) ClientID scoped to that customer's organization only

3) **Client Credentials Issuance:**
   a) Client secret generated (for confidential clients)
   b) Displayed once, customer must store securely

4) **Scope Restriction:**
   a) Customer-registered clients can only request scopes the customer has access to
   b) Cannot request scopes beyond customer's RBAC

5) **Client Lifecycle:**
   a) Customer can view their registered clients
   b) Customer can rotate client secrets
   c) Customer can delete client registration

---

### Journey 8: Local Client OAuth with Key Descriptions

**Ask:**

As a developer using Claude/VSCode/Cursor locally, I need OAuth authentication with the ability to describe and independently revoke my keys.

**Why is this needed?**

Local clients need OAuth (not API keys per SLC #8). Users need to manage multiple local connections.

**What OAuth Must Provide:**

1) **Local Client OAuth Flow:**
   a) Support authorization code flow initiated from local client
   b) Opens system browser for authentication
   c) Callback to localhost or custom URI scheme

2) **Key Description (SLC #11):**
   a) After authorization, prompt/API to add description to the issued tokens
   b) Description stored with token metadata (e.g., "Work MacBook - Claude")
   c) Description queryable via API

3) **Per-Key Revocation (SLC #11.1):**
   a) User can list their local client authorizations with descriptions
   b) User can revoke specific authorization by description/ID
   c) Revocation invalidates only that specific token set

4) **Session Independence:**
   a) Local client sessions managed separately from partner sessions
   b) Local client tokens do not count against partner session limits

---

### Journey 9: Unauthorized Client Rejection

**Ask:**

As a security control, OAuth must reject authorization requests from unregistered or disabled clients.

**Why is this needed?**

Only authorized clients should be able to initiate OAuth flows (SLC #9).

**What OAuth Must Provide:**

1) **Client Validation on Authorization Request:**
   a) Extract `client_id` from authorization request
   b) Check: is this clientID registered?
   c) Check: is this clientID enabled for this organization? (Journey 3)
   d) Reject if either check fails

2) **Rejection Behavior:**
   a) Return error without showing login screen
   b) Generic error message (don't leak valid clientID info)
   c) Log rejection attempt with clientID and timestamp

3) **No Unauthenticated Fallback:**
   a) MCP server configured to reject requests without valid OAuth token
   b) No API key fallback (SLC #8)

---

### Journey 10: Session Scalability (Remove 3-Session Limit)

**Ask:**

As a user, I need to connect multiple partners without session conflicts from the current 3-session OAuth limit.

**Why is this needed?**

Current 3-session limit makes multi-partner usage impossible (SLC #8.1).

**What OAuth Must Provide:**

1) **Session Architecture Change:**
   a) Partner OAuth sessions keyed by (clientID, userID, organizationID)
   b) Each partner has independent session — not pooled
   c) Remove global per-user session limit for partner connections

2) **Concurrent Partner Support:**
   a) User can have N active partner authorizations simultaneously
   b) Authorizing new partner does not evict existing partner sessions

3) **Token Storage Scalability:**
   a) Token storage supports multiple active tokens per user
   b) No artificial limits on concurrent partner tokens

4) **Direct Login Separation:**
   a) User's direct NR1 login session is separate from partner OAuth sessions
   b) Partner sessions don't consume direct login session quota
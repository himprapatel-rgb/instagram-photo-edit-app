# Statement of Work (SOW) #11
## Social Media Integration & Direct Posting

**Document Version**: 1.0  
**Last Updated**: November 24, 2025  
**Project**: Instagram Photo Editing App (Open Source)  
**Scope**: Direct social media posting from the app to all major platforms

---

## 1. Executive Summary

This SOW defines the development of comprehensive social media integration capabilities enabling users to post edited photos and videos directly to all major social platforms with a single click. Users can authenticate once and schedule/post to multiple platforms simultaneously.

**Key Objective**: "Post Everywhere" functionality - one-click sharing across Instagram, Facebook, TikTok, Snapchat, Twitter/X, Pinterest, LinkedIn, Reddit, YouTube Shorts, and other platforms.

---

## 2. Supported Social Media Platforms

### 2.1 Tier 1 Platforms (Phase 1 Priority)
- **Instagram** (Feed, Stories, Reels)
- **Facebook** (Feed, Stories, Pages)
- **TikTok** (Feed, Drafts)
- **Snapchat** (Stories, Memories)

### 2.2 Tier 2 Platforms (Phase 1/2)
- **Twitter/X** (Tweets with media)
- **Pinterest** (Pins, Boards)
- **LinkedIn** (Personal profile, Pages)
- **Reddit** (Subreddits with media)

### 2.3 Tier 3 Platforms (Phase 2+)
- **YouTube Shorts**
- **Telegram** (Channels, Groups)
- **WeChat** (Moments, Groups)
- **Discord** (Servers, DMs)
- **Bluesky**
- **Mastodon**

---

## 3. Technical Architecture

### 3.1 OAuth 2.0 Authentication Flow
```
User → Auth Dialog → Platform OAuth → Permission Grant → Access Token Storage → Secure Vault
```

**Key Components**:
- **OAuth Provider**: Each platform's official OAuth endpoints
- **Token Storage**: Encrypted local storage (web) + secure keychain (iOS/Android)
- **Token Refresh**: Automatic refresh before expiration
- **Multi-account Support**: Multiple accounts per platform

### 3.2 API Integration Stack

| Platform | API | Libraries | SDK |
|----------|-----|-----------|-----|
| Instagram | Graph API v18+ | `instagram-python-business` | Official SDK |
| Facebook | Graph API | `facebook-sdk-python` | Official |
| TikTok | Open API | `tiktok-python` | Open API |
| Snapchat | Snap Kit | `snapchat-python` | Official |
| Twitter/X | API v2 | `tweepy` | Official |
| Pinterest | API v5 | `pinterest-python` | Official |
| LinkedIn | Unified API | `linkedin-python-sdk` | Official |
| Reddit | PRAW API | `praw` | Community |
| YouTube | Data API v3 | `google-api-python-client` | Official |

### 3.3 Queue Management System
**Technology**: Bull Queue (Node.js) / Celery (Python) for async task processing
- Upload queue with retry logic
- Scheduled posting (schedule posts for specific times)
- Batch processing for multiple platforms
- Error handling and notifications

---

## 4. Feature Specifications

### 4.1 Single-Click Cross-Platform Posting

**Post Dialog Components**:
```
1. Platform Selection
   - Checkboxes for each platform
   - "Select All" quick button
   - Custom per-platform account selection

2. Caption Editor
   - Different captions per platform (platform-specific hashtags)
   - Character limit warnings per platform
   - Platform emoji/character support detection

3. Scheduling
   - Post immediately or schedule for later
   - Timezone-aware scheduling
   - Recurring post options (weekly, monthly)

4. Platform-Specific Options
   - Instagram: Story, Feed, Reel, DM options
   - TikTok: Draft save option, trending music
   - Snapchat: Story lifespan (3-24 hours)
   - Facebook: Page or personal feed selection
   - Twitter: Thread, retweet, reply-to option

5. Review & Preview
   - Side-by-side preview for each platform
   - Mobile phone mockup preview
   - Caption preview with character count
```

### 4.2 Media Optimization Per Platform

**Automatic Optimization**:
- **Instagram**: Convert HEIC → JPEG, 1080x1080 or 1080x1350 (Reels 1080x1920)
- **Facebook**: JPEG, 1200x628 (optimal), up to 4MB
- **TikTok**: MP4 H.264, 1080x1920, 15-10min, 150MB max
- **Twitter/X**: JPEG/PNG/GIF, max 5MB, 1200x675 optimal
- **Pinterest**: Aspect ratio 1000:1500, PNG/JPEG, 10MB max
- **LinkedIn**: JPG/PNG, 1200x627, max 10MB
- **Snapchat**: MP4/MOV, max 32MB, optimal 1080x1920
- **YouTube Shorts**: Vertical video, 1080x1920, 60sec max

### 4.3 Content Moderation
- Pre-upload content guidelines checking
- Banned hashtags detection per platform
- Copyright/DMCA compliance warning
- Community guidelines compliance check
- Nudity/violence detection with warnings

### 4.4 Multi-Account Management

**Account Linking**:
- Add/remove accounts for each platform
- Switch between accounts
- Set default accounts
- Disconnect accounts
- View account details and permissions

**Account Dashboard**:
- Linked accounts overview
- Last post time for each account
- Follow/follower counts
- Account status (active, suspended, etc.)

### 4.5 Post History & Analytics

**Post Tracking**:
- History of all posts across platforms
- Post timestamp, content, platforms
- Post status (scheduled, posted, failed)
- Manual retry for failed posts

**Basic Analytics** (where API allows):
- Likes, comments, shares per platform
- Reach and impressions
- Engagement rate
- Top-performing posts

---

## 5. Implementation Timeline

### Phase 1: Core Integration (Months 1-4)
- Instagram Graph API
- Facebook Graph API
- TikTok Open API
- Snapchat Snap Kit
- OAuth flow and token management
- Single-click posting UI

### Phase 2: Extended Platforms (Months 5-8)
- Twitter/X API v2
- Pinterest API
- LinkedIn Unified API
- Reddit PRAW
- Scheduling system
- Analytics dashboard

### Phase 3: Advanced Features (Months 9-12)
- YouTube Shorts integration
- Telegram/WeChat integration
- AI-powered caption generation per platform
- Hashtag recommendations per platform
- Post templates and reusable captions

---

## 6. Open-Source Libraries & Tools

**Backend**:
- `python-social-auth`: OAuth provider abstraction
- `celery`: Async task queue
- `redis`: Session/token caching
- `PyJWT`: JWT token handling
- `requests`: HTTP client

**Frontend (Web)**:
- `oauth2-redirect`: OAuth redirect handling
- `react-oauth/google`: OAuth UI component
- `axios`: API calls
- `date-fns`: Timezone-aware scheduling

**Mobile (iOS)**:
- `AppAuth-iOS`: OAuth 2.0 framework
- `URLSession`: API calls
- `Keychain Services`: Secure token storage

**Mobile (Android)**:
- `AppAuth-Android`: OAuth 2.0 framework
- `OkHttp`: HTTP client
- `Android Keystore`: Secure token storage

---

## 7. Security & Privacy Considerations

### 7.1 Token Security
- **Encryption**: AES-256 for token encryption at rest
- **Transport**: HTTPS/TLS 1.3 only
- **Storage**: Never store tokens in browser localStorage (use secure httpOnly cookies)
- **Expiration**: Automatic token refresh before expiration
- **Revocation**: One-click account disconnection revokes all tokens

### 7.2 Permission Scopes
- **Minimal Permissions**: Request only required scopes per platform
- **Transparency**: Clear display of what permissions are needed
- **Revocation**: Users can revoke permissions at any time

### 7.3 User Data Privacy
- No personal data collection beyond platform authentication
- No user posts stored on servers
- All processing local-first
- GDPR/CCPA compliance
- Privacy policy clearly states data handling

### 7.4 Compliance
- **Platform Terms of Service**: Comply with each platform's ToS
- **Rate Limiting**: Respect API rate limits
- **Spam Prevention**: Prevent automated spam/bot-like behavior
- **Content Guidelines**: No automated policy violation

---

## 8. Error Handling & User Feedback

### 8.1 Common Errors
- **Authentication Expired**: Automatic re-auth prompt
- **Rate Limited**: Queue system with backoff retry
- **Platform Down**: Graceful degradation with retry queue
- **Failed Post**: Manual retry option with detailed error message
- **Permission Denied**: Clear explanation of required permissions

### 8.2 User Notifications
- **Success**: Toast notification + detailed post log
- **Pending**: Show in queue, estimated posting time
- **Failed**: Error details + manual retry option
- **Email**: Optional daily digest of post activities

---

## 9. Testing Strategy

### 9.1 Unit Testing
- OAuth flow validation
- Token encryption/decryption
- Media optimization functions
- Caption validation per platform

### 9.2 Integration Testing
- End-to-end posting workflow
- Multi-platform simultaneous posting
- Scheduling verification
- Token refresh mechanism
- Error recovery flows

### 9.3 Platform Testing
- Sandbox/test account for each platform
- Validate posting appears on actual platform
- Verify media quality and formatting
- Test account linking/unlinking

---

## 10. Scalability Considerations

### 10.1 Queue Management
- Distributed queue system (Bull Queue, Celery)
- Horizontal scaling for task workers
- Batch API calls to reduce requests
- Rate limit coordination across instances

### 10.2 Token Management
- Redis cluster for token caching
- Distributed token refresh coordination
- No single point of failure for auth

### 10.3 Analytics
- Aggregated analytics caching
- Background jobs for analytics sync
- Pagination for large post histories

---

## 11. Platform-Specific Considerations

### 11.1 Instagram
- **Limitation**: Cannot post feed content via Graph API (must be Instagram Business account)
- **Workaround**: Provide upload preview -> user completes post on Instagram
- **Reels**: Upload to cloud storage then reference in API
- **Stories**: Direct API posting available

### 11.2 Facebook
- **Pages**: Full support via Graph API
- **Personal Feed**: Limited API access (share URLs instead)
- **Instant Articles**: For content creators

### 11.3 TikTok
- **Rate Limits**: Strict 10 requests/minute for upload API
- **Queue System**: Essential for batch uploads
- **Trending Music**: Integration with TikTok music library

### 11.4 Snapchat
- **Limited API**: Snap Kit provides story creation only
- **Camera Kit**: For in-app camera functionality
- **Business Account**: Higher rate limits and better tools

---

## 12. User Experience Flow

### 12.1 First-Time Setup
1. User clicks "Share to Social"
2. "Link Accounts" button if none linked
3. Select platform → OAuth redirect
4. Grant permissions → Success notification
5. Account appears in account manager

### 12.2 Posting Workflow
1. User clicks "Post" (after editing photo/video)
2. "Post to Social Media" dialog opens
3. Select platforms (checkbox grid)
4. Edit captions per platform
5. Set scheduling (immediate or future)
6. Review preview
7. Click "Post to All"
8. Show success/failure for each platform
9. Add to post history

### 12.3 Post Management
1. View post history with filters
2. See performance metrics per post
3. Retry failed posts
4. Delete/archive post records

---

## 13. Deployment Strategy

### 13.1 Environment Separation
- **Development**: Sandbox accounts for each platform
- **Staging**: Real test accounts with rate limiting
- **Production**: Live accounts with full rate limiting

### 13.2 Feature Flags
- Enable/disable platforms per deployment
- Beta testing for new platforms
- Gradual rollout of features

### 13.3 Monitoring
- API call logging and metrics
- Error rate tracking
- Queue depth monitoring
- Token refresh success rate

---

## 14. Success Metrics

- **Adoption**: 80% of users link at least one social account
- **Usage**: 50% of edited posts shared via social integration
- **Reliability**: 99% successful post delivery rate
- **Performance**: < 5 seconds from "Post" click to queued
- **Platform Coverage**: Support for 10+ platforms by Year 2
- **User Satisfaction**: 4.5+ rating for social features

---

## 15. Document Control

| Version | Date | Author | Changes |
|---------|------|--------|----------|
| 1.0 | 2025-11-24 | himprapatel-rgb | Initial SOW for comprehensive social media integration with one-click posting to all major platforms |

---

*This feature positions the app as the ultimate editing + sharing solution for Instagram creators and content creators on all platforms.*

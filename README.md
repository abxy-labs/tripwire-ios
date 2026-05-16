# Foil iOS SDK

Foil is a native iOS SDK for collecting encrypted device, app, runtime,
and behavioral signals that help your backend make risk decisions for signup,
login, checkout, account recovery, and other sensitive flows.

The public iOS package is distributed through Swift Package Manager as a
protected binary XCFramework. Source code, private symbols, and internal build
artifacts are retained privately.

## Package

| Package | Required | Description |
| --- | --- | --- |
| `https://github.com/abxy-labs/foil-ios` | Yes | Protected binary SwiftPM package for the Foil iOS SDK. |

## What's New in 1.2.2

- Expanded native signal coverage for device, app, runtime, network, and
  integrity posture.
- Improved native behavioral collection for form, action, lifecycle, motion,
  scroll, WebView, and touch evidence while keeping raw user-entered values out
  of the payload.
- Better parity with the Android and web SDKs so native and hybrid sessions can
  be interpreted consistently by Foil's server-side scoring pipeline.
- Additional integration diagnostics and companion-app polish for local and
  production validation.

## Requirements

- iOS 14+
- Swift 5.9+
- Xcode 15+
- A Foil publishable key, starting with `pk_live_` or `pk_test_`

## Installation

Add the SDK with Swift Package Manager:

```swift
.package(url: "https://github.com/abxy-labs/foil-ios", from: "1.2.2")
```

Then add the `Foil` product to your app target.

The release asset for this version is
`Foil-1.2.2.xcframework.zip`.

## Quick Start

Configure Foil once when your app starts:

```swift
import SwiftUI
import Foil

@main
struct MyApp: App {
    init() {
        try? FoilClient.shared.configure(
            FoilConfiguration(
                publishableKey: "pk_live_your_publishable_key"
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

When the user performs a sensitive action, request a sealed session handoff
and send it to your backend with the rest of the action payload:

```swift
func submitSignup() async throws {
    let handoff = try await FoilClient.shared.getSession()

    try await api.signup(
        SignupRequest(
            email: email,
            password: password,
            foilSessionId: handoff.sessionId,
            foilSealedToken: handoff.sealedToken
        )
    )
}
```

Your server verifies the sealed token with Foil and decides whether to
allow, challenge, review, or deny the action. Do not make trust decisions in
the app itself.

## Configuration

```swift
let config = FoilConfiguration(
    publishableKey: "pk_live_your_publishable_key",
    enableBehavioralSignals: true,
    enableHiddenWebView: true,
    enableCloudIdentifier: false,
    enableAutoAttachTouches: false,
    apiEndpoint: URL(string: "https://api.usefoil.com")!
)

try FoilClient.shared.configure(config)
```

| Option | Default | Description |
| --- | --- | --- |
| `publishableKey` | Required | Your client-side Foil key. Must start with `pk_live_` or `pk_test_`. Secret keys are rejected. |
| `enableBehavioralSignals` | `true` | Captures native lifecycle, navigation, viewport, scroll, form, clipboard, selection, motion, and touch behavior. |
| `enableHiddenWebView` | `true` | Enables native-to-web handoff for Foil-protected `WKWebView` content. |
| `enableCloudIdentifier` | `false` | Enables an optional iCloud continuity hint when available. |
| `enableAutoAttachTouches` | `false` | Automatically attaches touch dynamics to visible windows. Leave off if you attach touches manually. |
| `apiEndpoint` | Production API | Override only for development or private deployments. |

Runtime integrity and anti-tamper collection is always enabled. It is part of
the baseline SDK behavior rather than an app-side integration option.

## Session Handoff

`getSession()` returns a `SessionHandoff`:

```swift
public struct SessionHandoff {
    public let sessionId: String
    public let sealedToken: String
}
```

- `sessionId` identifies the Foil session.
- `sealedToken` is the server-verifiable handoff token.
- The SDK does not expose scores, verdicts, visitor IDs, or risk decisions to
  the device.

Call `getSession()` immediately before the sensitive action. Avoid calling it
only at app launch, because Foil is most useful when it includes the
behavior leading up to the action.

## Backend Verification

Send `sessionId` and `sealedToken` to your own backend. Your backend should
verify the token with Foil, then apply your product policy.

Example request shape:

```json
{
  "email": "user@example.com",
  "foil": {
    "sessionId": "sess_...",
    "sealedToken": "..."
  }
}
```

Recommended policy:

- Keep Foil secret keys on your server only.
- Treat the mobile SDK as an evidence collector, not a policy engine.
- Make allow/challenge/deny decisions server-side.
- Decide explicitly whether each flow should fail open or fail closed if
  Foil is unavailable.

## Behavioral Capture

When `enableBehavioralSignals` is enabled, Foil starts native behavioral
capture automatically. The SDK avoids collecting raw form values, raw
placeholders, or raw view identifiers.

Touch dynamics can be attached manually for screens where gesture behavior is
important:

```swift
import Foil

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    FoilClient.shared.observeTouches(on: view, contextId: "checkout")
}
```

`observeTouches` attaches a non-consuming gesture recognizer. Existing
gesture handlers continue to work.

## SwiftUI Forms

SwiftUI `TextField` and `SecureField` controls are observed through their
underlying UIKit text inputs. For best signal quality, set stable
accessibility identifiers on important fields:

```swift
TextField("Email", text: $email)
    .accessibilityIdentifier("checkout.email")

SecureField("Password", text: $password)
    .accessibilityIdentifier("signup.password")
```

Identifiers are hashed before telemetry is emitted. Do not put user-entered
text in them; prefer stable field-purpose IDs.

## WebView Correlation

If your app embeds Foil-protected web content, attach your `WKWebView` so
the browser SDK can reuse the native session:

```swift
import Foil
import WebKit

let webView = WKWebView(frame: .zero)
FoilClient.shared.attach(to: webView)
webView.load(URLRequest(url: URL(string: "https://app.example.com/signup")!))
```

This is useful for hybrid apps where native and web surfaces participate in
the same user flow.

## iCloud Continuity

`enableCloudIdentifier` is optional. When enabled and available, it gives
Foil a cloud-backed continuity hint for the same Apple account. Apps that
use custom entitlements or iCloud container configuration should validate the
behavior in their own provisioning setup.

Apps without iCloud continuity still use the core SDK normally.

## Permissions and Privacy

The SDK does not require location, contacts, photos, microphone, camera, or
advertising identifier access. Your app needs network access to talk to the
Foil API.

Foil collects encrypted signals that help distinguish trustworthy,
automated, tampered, replayed, or anomalous sessions. Signal categories
include:

- Device and OS characteristics
- App and installation characteristics
- Network and runtime environment shape
- Runtime integrity and tamper-resistance signals
- Native behavioral timing and interaction patterns
- Optional iCloud continuity hints
- Apple platform attestation support facts

The SDK is designed to avoid collecting raw form input values. Sensitive
values should stay in your app and backend; Foil receives encrypted
session evidence for server-side verification.

## API Reference

| API | Description |
| --- | --- |
| `FoilClient.shared.configure(_:)` | Validates configuration and starts collection. |
| `FoilClient.shared.getSession()` | Flushes a bounded batch and returns a server-verifiable handoff. |
| `FoilClient.shared.waitForFingerprint()` | Waits for the durable fingerprint to be ready. Optional for most integrations. |
| `FoilClient.shared.pauseCollection()` | Temporarily pauses active collection without destroying SDK state. |
| `FoilClient.shared.resumeCollection()` | Resumes active collection after a pause. |
| `FoilClient.shared.dispatchHealth()` | Returns dispatch-channel health for integration diagnostics. |
| `FoilClient.shared.observeTouches(on:contextId:)` | Manually attaches touch dynamics to a view. |
| `FoilClient.shared.attach(to:)` | Connects a `WKWebView` to the native Foil session. |
| `FoilClient.shared.resetLocalState()` | Clears local SDK session state for development and test flows. |
| `FoilClient.shared.destroy()` | Stops collection and releases resources. Mostly useful in tests. |

## Error Handling

Foil throws SDK-defined errors for configuration, transport, and handoff
failures.

Recommended fallback:

```swift
func foilHandoffOrNil() async -> SessionHandoff? {
    do {
        return try await FoilClient.shared.getSession()
    } catch {
        return try? await FoilClient.shared.getSession()
    }
}
```

If Foil fails, choose a product-appropriate policy. Many apps log the
error and continue without a handoff; high-risk flows may choose to challenge
or fail closed.

## Security and Distribution

The public repository contains package metadata and documentation only. It is
not a source mirror.

The public SwiftPM package references a protected binary XCFramework release
asset. Private symbols and debug artifacts are retained by Foil.

## Versioning

Foil follows semantic versioning for public mobile SDK packages.

```swift
.package(url: "https://github.com/abxy-labs/foil-ios", from: "1.2.2")
```

Pin exact versions in production builds and upgrade intentionally.

## Support

For SDK access, integration help, or production verification setup, contact
Foil support.

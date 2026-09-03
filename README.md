# Aegira Pro v3

Aegira is a Rust-based Linux incident detection and automated recovery engine for individual servers and small production environments.

## What Aegira Pro does

Aegira continuously watches `/var/log/aegira/system.log` for `[ERROR]` and `[CRITICAL]` entries. Matching rules can safely restart a systemd service or Docker container, verify recovery, retry verification, or notify an operator without taking action.

### Included

- Built-in JSON remediation rules
- Custom JSON rules
- Systemd service recovery
- Docker container recovery
- Recovery verification and bounded retries
- Unknown-incident detection and escalation
- `auto_recover`, `alert_only`, `dry_run`, and `approval_required` policies
- Rule validation and target safety checks
- Protection against restarting Aegira itself
- Incident cooldown/deduplication
- Log rotation/truncation handling
- Rule hot reload without restarting Aegira
- Gmail alerts through Composio
- Clean incident history
- CLI configuration and status commands
- Install and uninstall support

Aegira deliberately does not include an AI/RCA platform, web dashboard, mobile application, Kubernetes intelligence, distributed telemetry pipeline, or other enterprise features. Those belong to future products, not this focused Pro engine.

## Supported rule format

Rules may be stored as either a single JSON object or a JSON array.

```json
[
  {
    "id": "service_failure",
    "name": "Service Failure",
    "severity": "high",
    "error_patterns": ["service unavailable"],
    "context_patterns": [],
    "remediation": {
      "type": "service_restart",
      "service": "TARGET_SERVICE"
    },
    "verification": {
      "type": "service_active",
      "service": "TARGET_SERVICE"
    },
    "action": "auto_recover",
    "priority": 10
  }
]
```

Supported remediation types:

- `service_restart`
- `container_restart`
- `alert_only`

Supported verification types:

- `service_active`
- `container_running`
- `none`

Supported actions:

- `auto_recover`
- `alert_only`
- `dry_run`
- `approval_required`

Custom rules live in `/etc/aegira/rules/custom/` and are hot-reloaded when changed.

## CLI

```text
aegira install
aegira status
aegira show-rules
aegira history [count]
aegira uninstall
aegira version
aegira configure service <name>
aegira configure container <name>
aegira configure alerts <on|off> [recipient_email]
aegira license
aegira run
```

### Typical installation

```bash
cargo build --release
sudo ./target/release/aegira install
sudo ./target/release/aegira configure service cron
sudo ./target/release/aegira status
```

The installer creates the required directories and files, installs the built-in rules, creates the systemd unit, enables Aegira at boot, and starts it.

### History

`history` shows incident blocks instead of dumping the entire incident log. The default is the latest 20 incidents.

```bash
sudo ./target/release/aegira history
sudo ./target/release/aegira history 50
```

### Gmail alerts

Aegira uses Composio's `GMAIL_SEND_EMAIL` tool for Gmail notifications. Credentials are not embedded in the binary.

Configure `/etc/aegira/composio.env` with:

```text
COMPOSIO_API_KEY=your_key_here
COMPOSIO_USER_ID=your_composio_user_id
AEGIRA_ALERT_EMAIL=you@example.com
```

The installer creates this file with restrictive permissions. Enable alerts with:

```bash
sudo aegira configure alerts on you@example.com
```

The Composio Gmail connection must already be authorized for the configured Composio user.

## Safety model

Aegira does not execute arbitrary shell strings from rules. Remediation is restricted to the supported `systemctl restart` and `docker restart` operations, and targets are validated before use. Aegira refuses rules that attempt to target itself.

Recovery is verified after execution. Failed verification is retried within a bounded limit and then escalated as a recovery failure.

## Production scope

Aegira Pro v3 is intentionally a focused automation engine. Its production claim is limited to the supported Linux log, rule, remediation, verification, alerting, and systemd deployment workflow documented here.

Before commercial deployment, test the binary in the customer's actual Linux environment, especially systemd service names, Docker availability, log paths, rule behavior, and Gmail/Composio connectivity.

## Licensing

The source and binary are proprietary to Aegira Labs under the included LICENSE. Do not publish Pro source if the goal is to keep the implementation private. A production commercial licensing service should be operated separately from the binary; never place payment credentials, private signing keys, or master API credentials in this repository.

The current build keeps local license enforcement disabled for development and release testing. This does not process payments and should not be represented as an automated subscription-verification service.

## Repository hygiene

Never commit:

- `/etc/aegira/config.json`
- `/etc/aegira/composio.env`
- API keys
- license secrets/private keys
- customer data
- production incident logs

## Build

```bash
cargo build --release
```

# Aegira Pro v3 Release Checklist

Do not call a build commercially ready until the following have been tested on the target Linux distribution.

- [ ] `cargo build --release` succeeds
- [ ] `aegira --help` works
- [ ] `aegira version` reports Aegira Pro v3.0.0
- [ ] `aegira install` creates the service and required directories
- [ ] Aegira starts after reboot
- [ ] Built-in service recovery succeeds
- [ ] Custom service rule succeeds
- [ ] Docker container recovery succeeds on a Docker host
- [ ] Verification succeeds after recovery
- [ ] Failed verification reaches bounded retry limit and escalates
- [ ] Unknown incident produces manual-investigation alert/log
- [ ] `alert_only` never performs remediation
- [ ] `dry_run` never performs remediation
- [ ] `approval_required` never performs remediation
- [ ] Invalid JSON rule is rejected without stopping Aegira
- [ ] Unsafe service/container targets are rejected
- [ ] A rule cannot restart Aegira itself
- [ ] Repeated incidents are suppressed during cooldown
- [ ] Log rotation is handled
- [ ] Log truncation is handled
- [ ] Rule hot reload works without repeated reload spam
- [ ] `aegira history` shows incident blocks rather than the entire raw log
- [ ] Gmail/Composio alert is received end-to-end
- [ ] Alert failure does not crash or undo recovery
- [ ] Configuration survives service restart
- [ ] `aegira status` reports service state correctly
- [ ] `aegira uninstall` removes the service without deleting customer data
- [ ] No secrets are present in the repository

## Release boundary

Aegira Pro v3 is a focused Linux incident automation product. AI/RCA, distributed telemetry, web/mobile interfaces, enterprise identity, and large-scale correlation are outside this release boundary.

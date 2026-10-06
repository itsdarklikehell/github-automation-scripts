# GitHub Automation Scripts

[![CI](https://github.com/itsdarklikehell/github-automation-scripts/actions/workflows/ci.yml/badge.svg)](https://github.com/itsdarklikehell/github-automation-scripts/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/itsdarklikehell/github-automation-scripts)](LICENSE)

Herbruikbare scripts voor GitHub automatisering.

## Features

- **PR Review** — Automatische pull request reviews met checks voor titel lengte, body, grootte, en gevoelige bestanden
- **Issue Triage** — Automatische issue categorisatie op basis van labels
- **Release Automation** — Release creatie met automatische changelog generatie
- **Security Scanning** — Checks voor gevoelige bestanden en merge conflict markers

## Installatie

```bash
git clone https://github.com/itsdarklikehell/github-automation-scripts.git
cd github-automation-scripts
chmod +x scripts/*.sh
```

## Vereisten

- [GitHub CLI (`gh`)](https://cli.github.com/) — geauthenticeerd met `gh auth login`
- [`jq`](https://stedolan.github.io/jq/) — voor JSON parsing

## Gebruik

### PR Review

```bash
bash scripts/pr-review.sh <PR_NUMBER> [REPO]
```

Voorbeeld:
```bash
bash scripts/pr-review.sh 123
bash scripts/pr-review.sh 123 owner/repo
```

### Issue Triage

```bash
bash scripts/issue-triage.sh <ISSUE_NUMBER> [REPO]
```

### Release Automation

```bash
bash scripts/release-automation.sh <REPO> <TAG>
```

### Security Scanning

```bash
bash scripts/security-scan.sh [REPO]
```

## Bijdragen

Zie [CONTRIBUTING.md](CONTRIBUTING.md) voor richtlijnen.

## Licentie

MIT — zie [LICENSE](LICENSE) voor details.

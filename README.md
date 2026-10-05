# GitHub Automation Scripts

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
bash scripts/issue-triage.sh [REPO]
```

Voorbeeld:
```bash
bash scripts/issue-triage.sh
bash scripts/issue-triage.sh owner/repo
```

### Release Automation

```bash
bash scripts/release-automation.sh <VERSION> [REPO]
```

Voorbeeld:
```bash
bash scripts/release-automation.sh v1.2.0
bash scripts/release-automation.sh v1.2.0 owner/repo
```

### Tests

```bash
bash scripts/test-scripts.sh
```

## :film_projector: Development visualization

Bekijk de [Gource development video](https://github.com/itsdarklikehell/github-automation-scripts/releases) voor een visuele tijdlijn van de projectgeschiedenis.

Om de video lokaal te genereren:
```bash
gource -1920x1080 --auto-skip-seconds 1 -o gource.ppm
ffmpeg -y -r 60 -i gource.ppm -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p gource.mp4
```

De GitHub Actions workflow (`.github/workflows/gource.yml`) genereert de video automatisch bij elke release.

## Licentie

MIT

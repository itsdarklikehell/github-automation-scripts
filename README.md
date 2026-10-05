# GitHub Automation Scripts

Herbruikbare scripts voor GitHub automatisering.

## Features

- Automatische PR reviews
- Issue triage
- Release automatisering
- Dependency updates
- Security scanning

## Installatie

```bash
git clone https://github.com/itsdarklikehell/github-automation-scripts.git
cd github-automation-scripts
```

## Gebruik

```bash
bash scripts/pr-review.sh
bash scripts/issue-triage.sh
bash scripts/release-automation.sh
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

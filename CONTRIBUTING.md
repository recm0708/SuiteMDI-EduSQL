# Contributing / Contribuir

## Estilo de commits
- Español, claros y atómicos. Ej.: `feat: alta de clientes`, `fix: corrección en prModificarUsuarios`.

## Firma (Verified)
Commits y tags firmados con **SSH**:
```bash
git config --global gpg.format ssh
git config --global user.signingkey "C:/Keys/id_ed25519.pub"
git config --global commit.gpgsign true
git config --global tag.gpgSign true
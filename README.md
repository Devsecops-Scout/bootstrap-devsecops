# ------------------------------------------------------------------------
# 🛠️ DevSecOps WSL Workstation Bootstrap
# Author: devsecops_scout
# Last Updated: 2025-07-10
# ------------------------------------------------------------------------

Modular, clean, and production-grade DevSecOps setup for Ubuntu-based WSL environments. Includes:

- Docker & Containerd
- ZSH with Oh My Zsh
- Kubernetes tools (`kubectl`, `kind`)
- Dotfiles and shell productivity plugins
- GitLab CI/CD integration
- Post-install validation hooks

---

## 📦 Installation (Manual)

```bash
git clone https://github.com/yourusername/devsecops-bootstrap.git
cd devsecops-bootstrap
chmod +x *.sh
./bootstrap-devsecops.sh
./dotfiles_setup.sh
```

---

## 🔧 Scripts Overview

| Script                            | Purpose                                                   |
|-----------------------------------|-----------------------------------------------------------|
| `bootstrap-devsecops.sh`          | Core setup: Docker, ZSH, sources Kubernetes installer     |
| `k8s-tools.sh`                    | Installs `kubectl` and `kind`, removes broken APT sources |
| `dotfiles_setup.sh`               | ZSH config with plugins, aliases, and dotfile symlinks    |

---

## ✅ Post-Install Verification

```bash
docker version
kubectl version --client
kind version
zsh --version
```

You can also run:

```bash
./test-verify.sh
```

---

## 🔁 CI/CD Pipeline (GitLab Compatible)

Supports GitLab CI using `.gitlab-ci.yml`. Automatically runs shellcheck, bootstraps on Ubuntu runner, and verifies Docker, ZSH, Kubernetes installs.

---

## 🔐 Recommended Enhancements

- GitHub Secret for PAT (for dotfiles repo sync)
- Store version metadata in `VERSION`
- Lock `kubectl` to your cluster’s version
- Add `minikube` or `k3s` if needed

---

## 🧩 License

MIT. Use at your own risk. Contributions welcome.

---

## 🤝 Maintainer

[Jo @ DevSecOps Scout](https://www.bibiserv.com)

---

## 📜 TODO
- [ ] Add `.deb` packaging
- [ ] Add Snyk security scan CI stage
- [ ] Add `minikube` optional installer

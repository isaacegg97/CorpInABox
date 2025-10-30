# CorpInABox

A fully automated **enterprise-style homelab** built with **Terraform**, **Ansible**, and **Docker Compose**.  
This project simulates a modern company's internal, developer, and production infrastructure — ideal for DevSecOps experimentation, security training, or learning how real organizations are structured behind the scenes.

---

## 🧩 Overview

CorpInABox is organized into multiple tiers, each modeling a part of a typical corporate infrastructure:

| Tier | Purpose | Example Services |
|------|----------|------------------|
| **Internal Tools** | Core identity, networking, and communications | LDAP, Pi-hole DNS, Mail, WireGuard VPN |
| **Developer Tools** | Source control and project management | Forgejo (Git & Actions), Redmine (Ticketing) |
| **Services** | File sharing and collaboration | Mattermost (Chat), Nextcloud (File Server) |
| **Security** | Observability and monitoring | Grafana, Loki, Promtail |
| **Infra** | Terraform + Ansible | Automates deployment and configuration |

The goal is to provide a realistic sandbox for developing, testing, and defending full-stack systems — all reproducible from source.

---

## 🗂️ Repository Layout

```
├── default/
│   ├── default.tf                 # Core Terraform configuration
│   ├── dns/                       # Pi-hole DNS stack
│   ├── mail/                      # Mail stack
│   ├── vpn/                       # WireGuard VPN stack
│   ├── ldap/                      # OpenLDAP auth backend
│   ├── dns.yml, mail.yml, vpn.yml # Ansible playbooks
│   └── ldap.yml
│
├── developer/
│   ├── developer.tf               # Developer infrastructure
│   ├── forgejo/                   # Git/CI stack
│   │   ├── docker-compose.yml
│   │   └── runner/docker-compose.yml
│   ├── redmine/                   # Ticketing
│   ├── forgejo.yml, redmine.yml   # Ansible playbooks
│   └── forgejo-runner.yml
│
├── services/
│   ├── nextcloud/                 # File server
│   ├── mattermost/                # Internal chat
│   ├── nextcloud.yml              # Playbook
│   └── services.tf
│
├── security/
│   ├── observability/             # Grafana + Loki + Promtail stack
│   └── observability.yml
│
├── inventory.yml                  # Ansible inventory (define host IPs)
├── vars.yml                       # Shared variables (domain, passwords, etc.)
├── main.tf / provider.tf          # Root Terraform config
├── README.md                      # (this file)
└── LICENSE
```

---

## ⚙️ Requirements

- **Terraform** ≥ 1.5  
- **Ansible** ≥ 2.15 with `community.docker` collection  
- **Docker / Docker Compose v2** on each target host  
- Optional: `yq` for YAML parsing and quick image checks

---

## 🚀 Quick Start

### 1. Configure variables

Edit `vars.yml`:
```yaml
TZ: "America/Phoenix"
MAIL_DOMAIN: "corpinabox.lan"
PIHOLE_WEBPASSWORD: "changeme"
FORGEJO_URL: "http://forgejo:3000"
FORGEJO_RUNNER_TOKEN: "replace-me"
GRAFANA_ADMIN_USER: "admin"
GRAFANA_ADMIN_PASS: "admin"
WG_SERVER_URL: "auto"
WG_SERVER_PORT: 51820
WG_PEERS: "laptop,phone"
WG_SUBNET: "10.13.13.0/24"
```

### 2. Define inventory

Edit `inventory.yml` with your host IPs:
```ini
[internal_dns]
dns01 ansible_host=10.0.1.10

[internal_mail]
mail01 ansible_host=10.0.1.20

[internal_vpn]
vpn01 ansible_host=10.0.1.30

[developer_ci]
ci01 ansible_host=10.0.2.40

[security_obs]
obs01 ansible_host=10.0.3.50
```

### 3. Deploy

From the repo root, run:

```bash
terraform init
terraform apply

ansible-playbook default/ldap.yml
ansible-playbook default/dns.yml
ansible-playbook default/mail.yml
ansible-playbook default/vpn.yml
ansible-playbook developer/forgejo.yml
ansible-playbook developer/redmine.yml
ansible-playbook developer/forgejo-runner.yml
ansible-playbook services/nextcloud.yml
ansible-playbook security/observability.yml
```

---

## 🧠 Post-Deployment Access

| Service | URL / Port | Default Credentials / Notes |
|----------|-------------|-----------------------------|
| **Pi-hole** | `http://dns01:8081/admin` | password = `PIHOLE_WEBPASSWORD` |
| **Mail Admin (Modoboa)** | `http://mail01:8082/` | admin set at first login |
| **WireGuard** | UDP 51820 | configs in `/opt/wireguard/config` |
| **Forgejo** | `http://forgejo:3000` | create admin on first run |
| **Redmine** | `http://redmine:3000` | user: `admin` / pass: `admin` |
| **Nextcloud** | `http://nextcloud:8080` | web setup wizard |
| **Mattermost** | `http://chat:8065` | admin created on first login |
| **Grafana** | `http://obs01:3000` | `admin` / `admin` |

---


## 🧰 Maintenance

| Task | Command |
|------|----------|
| Update services | `ansible-playbook --tags update` |
| Check image availability | use the one-liner above |
| Restart all services | `ansible all -a "docker compose restart"` |
| Destroy environment | `terraform destroy` |

---

## 🧱 Future Plans

- Add **reverse proxy and TLS** (Caddy or Traefik).  
- Expand **security stack** (Wazuh, Suricata, Strelka).  
- Build **Grafana dashboards** for visibility.  
- Integrate **Forgejo Actions CI pipelines**.  
- Add **static site export** for “Prod” simulation.

---

## 📜 License

Licensed under the **MIT License**.  
Use, modify, and expand freely.

---
“An entire company, in a box — one repo to learn it all.”

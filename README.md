# Acme Corp Minecraft Server Automation
## CS 312 Course Project Part 2

## 📚 Background
In this project, we’ll fully automate the provisioning, configuration, and deployment of an AWS-hosted Minecraft server for Acme Corp. Everything is scripted using Terraform (infra) and Ansible (config). No need to ssh or even touch the AWS console. 

## 🔧 Requirements

Before you begin, ensure you have the following installed and configured:

- **AWS CLI v2** configured with a named profile (`acme-minecraft`) in `~/.aws/credentials`.
- **Terraform CLI**
- **Ansible CLI**
- **SSH key-pair** named `minecraft` imported into AWS and available in `~/.ssh/minecraft` (private key) and `~/.ssh/minecraft.pub` (public key).

### Environment Variables / AWS Profile

Configure AWS profile with cli credentials

```bash
aws configure --profile acme-minecraft
```

Verify it works:

```bash
aws sts get-caller-identity --profile acme-minecraft
```

## 📈 Architecture Diagram


## ⚙️ Pipeline Steps

1. **Clone the repository**

   ```bash
   git clone https://github.com/mbauer575/acme-minecraft.git
   cd acme-minecraft/infra
   ```

2. **Provision AWS infrastructure with Terraform**

   ```bash
   terraform init
   terraform plan -var="ssh_key_name=minecraft"
   terraform apply -auto-approve -var="ssh_key_name=minecraft"
   ```

   - Initializes Terraform, shows the plan, and applies it.
   - Outputs the public IP as `server_ip`.

3. **Configure the Minecraft server with Ansible**

   ```bash
   # Move to the config folder
   cd ../config
   ```
   - Update IP field in hosts.ini [VM-IP] -> x.x.x.x
   ```
   # Run the playbook
   ansible-playbook -i hosts.ini playbook.yml
   ```

4. **Verify the service**

   ```bash
   # Scan port 25565 to confirm Minecraft is listening
   nmap -sV -Pn -p T:25565 $(cd ../infra && terraform output -raw server_ip)
   ```

## 🚀 Connecting to the Minecraft Server

1. Open your Minecraft client.
2. Go to **Multiplayer → Direct Connect**.
3. Enter the server IP from the output of terraform apply `terraform output -raw server_ip`
4. Hit **Join Server**.
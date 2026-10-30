
#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y docker git firewalld

id intern || useradd -m -s /bin/bash intern
echo "intern ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/intern
chmod 0440 /etc/sudoers.d/intern

systemctl enable --now docker
systemctl enable --now firewalld

git clone --branch "${git_branch}" \
  "${git_repo_url}" /opt/devops-challenge

cd /opt/devops-challenge/intern-task-app

docker build -t intern-task-app:local .

cat > /etc/systemd/system/intern-task-app.service <<SERVICE
[Unit]
Description=Atomity Intern Task Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
RestartSec=5
ExecStartPre=-/usr/bin/docker rm -f intern-task-app
ExecStart=/usr/bin/docker run --rm --name intern-task-app -p ${app_port}:${app_port} intern-task-app:local
ExecStop=/usr/bin/docker stop intern-task-app

[Install]
WantedBy=multi-user.target
SERVICE

firewall-cmd --permanent --add-port=${app_port}/tcp
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="${ssh_cidr}" service name="ssh" accept'
firewall-cmd --reload

systemctl daemon-reload
systemctl enable --now intern-task-app.service

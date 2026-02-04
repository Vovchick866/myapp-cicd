terraform {
  required_version = ">= 1.0"
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Только проверка SSH и вывод информации
resource "terraform_data" "check" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "Проверка инфраструктуры..."
      echo "SSH доступ:"
      for ip in 192.168.1.1 192.168.1.2 192.168.1.3 192.168.1.10; do
        user="sshuser"
        [ "$ip" = "192.168.1.10" ] && user="root"
        echo -n "$user@$ip: "
        ssh -i /root/.ssh/id_rsa -o ConnectTimeout=2 $user@$ip "echo OK" &>/dev/null && echo "✅" || echo "❌"
      done
    EOT
  }
}

output "status" {
  value = "Инфраструктура проверена. Фаервол не настроен."
}

output "manual_setup" {
  value = <<-EOT
  Для настройки фаервола выполните вручную:
  
  1. Веб-сервер (192.168.1.2):
     ssh sshuser@192.168.1.2
     sudo apt-get install iptables
     # Настройте правила
  
  2. База данных (192.168.1.3):
     ssh sshuser@192.168.1.3
     sudo apt-get install iptables
     # Настройте правила
  
  3. RedOS мониторинг (192.168.1.10):
     ssh root@192.168.1.10
     dnf install firewalld
     firewall-cmd --add-port=9100/tcp
  EOT
}

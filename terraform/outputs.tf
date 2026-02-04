# ============================================
# ВЫВОД ИНФОРМАЦИИ ПОСЛЕ ПРИМЕНЕНИЯ
# ============================================

output "deployment_status" {
  value = "🎉 Развертывание инфраструктуры завершено!"
  description = "Статус выполнения"
}

output "server_access_details" {
  value = {
    for name, server in var.servers :
    name => {
      ip          = server.ip
      hostname    = server.hostname
      role        = server.role
      ssh_command = "ssh -i ${var.ssh_private_key} ${var.ssh_user}@${server.ip}"
      monitoring  = "http://${server.ip}:${var.monitoring.node_exporter_port}/metrics"
    }
  }
  description = "Детальная информация о доступе к серверам"
  sensitive = true
}

output "monitoring_server_info" {
  value = {
    ip          = var.monitoring_server.ip
    hostname    = var.monitoring_server.hostname
    ssh_command = "ssh -i ${var.ssh_private_key} ${var.monitoring_server.user}@${var.monitoring_server.ip}"
    metrics     = "http://${var.monitoring_server.ip}:${var.monitoring.node_exporter_port}/metrics"
    dashboard   = "# Для просмотра метрик используйте браузер или curl"
  }
  description = "Информация о сервере мониторинга"
  sensitive = true
}

output "service_endpoints" {
  value = {
    web_application = "http://192.168.1.2/"
    php_info_page  = "http://192.168.1.2/network_config.php"
    database       = "mysql -h 192.168.1.3 -u root -p"
    all_metrics    = "http://192.168.1.10:9100/metrics"
  }
  description = "Конечные точки сервисов"
}

output "firewall_rules_summary" {
  value = <<-EOT
  📋 СВОДКА ПРАВИЛ ФАЕРВОЛА:
  
  Общие правила (все серверы):
  - SSH (22): разрешен из ${var.network.subnet}
  - ICMP: разрешен (ping)
  - Node Exporter (9100): разрешен только с ${var.monitoring_server.ip}
  
  Правила по ролям:
  - Веб-сервер (192.168.1.2): HTTP (80), HTTPS (443)
  - База данных (192.168.1.3): MySQL (3306) из ${var.network.subnet}
  
  ВСЕ ОСТАЛЬНЫЕ ПОДКЛЮЧЕНИЯ БЛОКИРУЮТСЯ
  EOT
  
  description = "Сводка настроенных правил фаервола"
}

output "next_steps" {
  value = <<-EOT
  🚀 СЛЕДУЮЩИЕ ШАГИ:
  
  1. Проверьте веб-приложение:
     curl http://192.168.1.2/
  
  2. Проверьте мониторинг:
     curl http://192.168.1.10:9100/metrics | head -20
  
  3. Проверьте базу данных:
     ssh -i ${var.ssh_private_key} ${var.ssh_user}@192.168.1.3 \
       "sudo mysql -e 'SHOW DATABASES;'"
  
  4. Для просмотра всех метрик:
     for ip in 192.168.1.1 192.168.1.2 192.168.1.3 192.168.1.10; do
       echo "=== $ip ==="
       curl -s http://$ip:9100/metrics | grep "^node_"
     done
  
  5. Для удаления инфраструктуры:
     terraform destroy -auto-approve
  EOT
  
  description = "Инструкции по проверке и дальнейшим действиям"
  sensitive = true
}

output "terraform_commands" {
  value = {
    plan    = "terraform plan          # Просмотр плана изменений"
    apply   = "terraform apply         # Применение конфигурации"
    destroy = "terraform destroy       # Удаление инфраструктуры"
    state   = "terraform state list    # Просмотр состояния"
    output  = "terraform output        # Просмотр выводов"
    refresh = "terraform refresh       # Обновление состояния"
  }
  description = "Полезные команды Terraform"
}

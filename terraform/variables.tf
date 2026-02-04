# ============================================
# ОБЪЯВЛЕНИЕ ПЕРЕМЕННЫХ TERRAFORM
# ============================================

# ------------------------------
# SSH И АУТЕНТИФИКАЦИЯ
# ------------------------------

variable "ssh_private_key" {
  description = "Абсолютный путь к файлу приватного SSH ключа"
  type        = string
  sensitive   = true  # Помечаем как чувствительные данные
}

variable "ssh_user" {
  description = "Имя пользователя для SSH подключения к Debian серверам"
  type        = string
  sensitive   = true
}

variable "ssh_password" {
  description = "Пароль пользователя для выполнения sudo команд"
  type        = string
  sensitive   = true
}

# ------------------------------
# КОНФИГУРАЦИЯ СЕРВЕРОВ
# ------------------------------

variable "servers" {
  description = "Конфигурация всех Debian серверов"
  
  type = map(object({
    ip       = string    # IP адрес сервера
    hostname = string    # Имя хоста
    role     = string    # Роль: ssh, web, db
  }))
  
  # Валидация ролей серверов
  validation {
    condition = alltrue([
      for server in values(var.servers) :
      contains(["ssh", "web", "db"], server.role)
    ])
    error_message = "Роль сервера должна быть: ssh, web или db"
  }
}

variable "monitoring_server" {
  description = "Конфигурация сервера мониторинга (RedOS)"
  
  type = object({
    ip       = string  # IP адрес
    hostname = string  # Имя хоста
    user     = string  # SSH пользователь
  })
  
  default = {
    ip       = "192.168.1.10"
    hostname = "redos-monitoring"
    user     = "root"
  }
}

# ------------------------------
# НАСТРОЙКИ СЕТИ
# ------------------------------

variable "network" {
  description = "Параметры локальной сети"
  
  type = object({
    subnet    = string       # Подсеть в формате CIDR
    netmask   = string       # Маска подсети
    gateway   = string       # IP адрес шлюза
    dns       = list(string) # Список DNS серверов
  })
  
  default = {
    subnet    = "192.168.1.0/24"
    netmask   = "255.255.255.0"
    gateway   = "192.168.1.1"
    dns       = ["8.8.8.8", "8.8.4.4"]
  }
}

# ------------------------------
# НАСТРОЙКИ БАЗЫ ДАННЫХ
# ------------------------------

variable "database" {
  description = "Настройки базы данных MariaDB"
  
  type = object({
    root_password = string  # Пароль пользователя root
    monitor_user  = string  # Пользователь для мониторинга
    monitor_pass  = string  # Пароль для мониторинга
  })
  
  sensitive = true  # Все данные чувствительные
  
  default = {
    root_password = "vladimir0806"
    monitor_user  = "sqluser"
    monitor_pass  = "sqlpass"
  }
}

# ------------------------------
# НАСТРОЙКИ МОНИТОРИНГА
# ------------------------------

variable "monitoring" {
  description = "Настройки системы мониторинга"
  
  type = object({
    node_exporter_port = number  # Порт Node Exporter
    scrape_interval    = string  # Интервал сбора метрик
  })
  
  default = {
    node_exporter_port = 9100
    scrape_interval    = "30s"
  }
}

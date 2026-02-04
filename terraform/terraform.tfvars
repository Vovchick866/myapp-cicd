# ============================================
# НАСТРОЙКИ SSH ДОСТУПА
# ============================================

# Путь к приватному SSH ключу на RedOS
ssh_private_key = "/root/.ssh/id_rsa"

# Пользователь на Debian машинах (по умолчанию sshuser)
ssh_user = "sshuser"

# Пароль для sudo на Debian машинах
ssh_password = "vladimir2006"

# ============================================
# КОНФИГУРАЦИЯ СЕРВЕРОВ
# ============================================

# Debian серверы (3 машины)
servers = {
  # Сервер 1: SSH Gateway
  "ssh_gateway" = {
    ip        = "192.168.1.1"
    hostname  = "debian-ssh"
    role      = "ssh"   # ssh, web, db
  }
  
  # Сервер 2: Веб-сервер (Apache + PHP)
  "web_server" = {
    ip        = "192.168.1.2"
    hostname  = "debian-web"
    role      = "web"
  }
  
  # Сервер 3: База данных (MariaDB)
  "db_server" = {
    ip        = "192.168.1.3"
    hostname  = "debian-db"
    role      = "db"
  }
}

# Сервер мониторинга (RedOS с Terraform)
monitoring_server = {
  ip        = "192.168.1.10"
  hostname  = "redos-monitoring"
  user      = "root"  # На RedOS используем root
}

# ============================================
# НАСТРОЙКИ СЕТИ
# ============================================
network = {
  subnet    = "192.168.1.0/24"    # Ваша подсеть
  netmask   = "255.255.255.0"     # Маска подсети
  gateway   = "192.168.1.1"       # Шлюз по умолчанию
  dns       = ["8.8.8.8", "8.8.4.4"]  # DNS серверы
}

# ============================================
# НАСТРОЙКИ БАЗЫ ДАННЫХ
# ============================================
database = {
  root_password = "vladimir0806!"  # Пароль root для MariaDB
  monitor_user  = "sqluser"                # Пользователь для мониторинга
  monitor_pass  = "sqlpass"       # Пароль для мониторинга
}

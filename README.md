# Terraform Infrastructure and CI/CD for Frontend and Backend

## Описание проекта

Это инфраструктурный проект для автоматизации развертывания и управления AWS инфраструктурой с помощью Terraform и CI/CD процессов с GitHub Actions.

Проект включает:

- AWS VPC с публичными подсетями
- ECS кластеры для фронтенда и бэкенда
- Настроенные ECR репозитории для хранения Docker образов
- Load Balancers (ALB) для распределения трафика
- DynamoDB для backend
- Автоматическое масштабирование сервисов
- CI/CD pipeline для автоматизации build, terraform plan и apply с уведомлениями в Telegram

## Структура репозитория

- `frontend/` — terraform код и workflow для фронтенда
- `backend/` — terraform код и workflow для бэкенда
- `.github/workflows/` — GitHub Actions для CI/CD
- `modules/` — переиспользуемые terraform модули (VPC, ECS, ALB, ECR и пр.)

## Используемые технологии

- Terraform (AWS Provider)
- Docker
- AWS ECS, ECR, ALB, DynamoDB, CloudWatch
- GitHub Actions
- Bash, YAML
- Python (для backend приложения, если есть)

## Запуск и деплой

### Подготовка

- Клонировать репозиторий
- Заполнить переменные в `*.tfvars` файлах
- Убедиться, что AWS IAM роли настроены и GitHub Secrets (AWS creds, Telegram tokens) добавлены

### Запуск

- Для PR: создается план Terraform с билдами Docker образов и комментируется в PR
- Для мейн ветки / релиза: автоматически применяется Terraform и обновляются сервисы на ECS

## CI/CD Workflow

- `terraform-plan.yml` — план для PR
- `terraform-apply.yml` — деплой при merge или релизе
- Уведомления о статусах в Telegram

## Результат

- Полностью автоматизированный процесс инфраструктуры и деплоя
- Надежное масштабирование и мониторинг сервисов
- Быстрая интеграция и доставка новых версий приложений

---

# Портфолио (короткое резюме проекта)

## Terraform + AWS CI/CD для Fullstack проекта

**Описание:**  
Разработал инфраструктуру и автоматизированные процессы деплоя для frontend и backend сервисов на AWS с использованием Terraform, Docker и GitHub Actions.

**Технологии:**  
Terraform, AWS ECS/ECR/ALB, DynamoDB, Docker, GitHub Actions, Bash, AWS IAM, CloudWatch

**Что сделал:**  
- Спроектировал и реализовал масштабируемую инфраструктуру с использованием Terraform модулей  
- Настроил CI/CD pipeline с GitHub Actions для автоматического билда Docker образов, terraform plan и apply  
- Интегрировал уведомления о статусах деплоя в Telegram  
- Использовал best practices для безопасности (IAM роли, private S3 buckets) и отказоустойчивости (autoscaling)  
- Документировал процесс и создавал инструкции по запуску и поддержке проекта

**Результаты:**  
- Сократил время развертывания новых версий до нескольких минут  
- Обеспечил прозрачность процессов за счет комментариев в PR и уведомлений  
- Создал легко расширяемую и поддерживаемую инфраструктуру



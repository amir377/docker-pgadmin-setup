# install.ps1

Write-Host "Starting Docker and pgAdmin installation..." -ForegroundColor Green

# Define a helper function to prompt the user
function PromptUser {
    param (
        [string]$PromptText,
        [string]$DefaultValue
    )
    $response = Read-Host "$PromptText (Default: $DefaultValue)"
    if ([string]::IsNullOrWhiteSpace($response)) {
        return $DefaultValue
    }
    return $response
}

# Prompt user for each required parameter
$containerName = PromptUser -PromptText "Enter the pgAdmin container name" -DefaultValue "pgadmin"
$networkName = PromptUser -PromptText "Enter the network name" -DefaultValue "general"
$pgAdminPort = PromptUser -PromptText "Enter the pgAdmin port" -DefaultValue "8082"
$allowHost = PromptUser -PromptText "Enter the allowed host" -DefaultValue "0.0.0.0"
$pgAdminEmail = PromptUser -PromptText "Enter the pgAdmin admin email" -DefaultValue "admin@example.com"
$pgAdminPassword = PromptUser -PromptText "Enter the pgAdmin admin password" -DefaultValue "adminpassword"

# Generate the .env file
Write-Host "Creating .env file for pgAdmin setup..." -ForegroundColor Green
$envContent = @"
# PgAdmin container settings
CONTAINER_NAME=$containerName
PGADMIN_EMAIL=$pgAdminEmail
PGADMIN_PASSWORD=$pgAdminPassword
PGADMIN_PORT=$pgAdminPort
ALLOW_HOST=$allowHost
NETWORK_NAME=$networkName
"@

# Save the .env file
$envFilePath = ".env"
$envContent | Set-Content -Path $envFilePath
Write-Host ".env file created successfully at $envFilePath." -ForegroundColor Green

# Check if Docker is installed
if (-Not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker is not installed. Please install Docker Desktop and restart this script." -ForegroundColor Red
    Start-Process "https://desktop.docker.com/win/stable/Docker Desktop Installer.exe"
    exit
}

# Check if Docker Compose is installed
if (-Not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Host "Docker Compose is not installed. Installing Docker Compose..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "https://github.com/docker/compose/releases/latest/download/docker-compose-Windows-x86_64.exe" -OutFile "$Env:ProgramFiles\Docker\docker-compose.exe"
    Write-Host "Docker Compose installed successfully." -ForegroundColor Green
}

# Create the network before building the container
Write-Host "Creating Docker network $networkName if it does not already exist..." -ForegroundColor Green
try {
    docker network create $networkName
    Write-Host "Network $networkName created successfully." -ForegroundColor Green
} catch {
    Write-Host "Network $networkName already exists or could not be created. Skipping..." -ForegroundColor Yellow
}

# Use docker-compose.example.yaml to create docker-compose.yaml
Write-Host "Generating docker-compose.yaml file from docker-compose.example.yaml..." -ForegroundColor Green
if (Test-Path "docker-compose.example.yaml") {
    $exampleContent = Get-Content "docker-compose.example.yaml" | ForEach-Object {
        $_ -replace "\$\{CONTAINER_NAME\}", $containerName `
            -replace "\$\{NETWORK_NAME\}", $networkName `
            -replace "\$\{PGADMIN_PORT\}", $pgAdminPort `
            -replace "\$\{ALLOW_HOST\}", $allowHost `
            -replace "\$\{PGADMIN_EMAIL\}", $pgAdminEmail `
            -replace "\$\{PGADMIN_PASSWORD\}", $pgAdminPassword
    }
    $composeFilePath = "docker-compose.yaml"
    $exampleContent | Set-Content -Path $composeFilePath
    Write-Host "docker-compose.yaml file created successfully at $composeFilePath." -ForegroundColor Green
} else {
    Write-Host "docker-compose.example.yaml file not found. Ensure the example file exists in the current directory." -ForegroundColor Red
    exit
}

# Start Docker Compose with build
Write-Host "Starting Docker Compose with --build for pgAdmin..." -ForegroundColor Green
try {
    docker-compose up -d --build
    $containerStatus = docker inspect -f '{{.State.Running}}' $containerName
    if ($containerStatus -eq "true") {
        Write-Host "pgAdmin setup is complete and running. Access it at http://127.0.0.1:$pgAdminPort." -ForegroundColor Green
    } else {
        Write-Host "Container is not running. Fetching logs..." -ForegroundColor Yellow
        docker logs $containerName
    }
} catch {
    Write-Host "Failed to start Docker Compose. Ensure Docker is running and try again." -ForegroundColor Red
}

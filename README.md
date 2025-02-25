# **Docker pgAdmin Setup**

This repository provides a simple solution for deploying **pgAdmin** using Docker. It includes scripts and configuration files to automate the setup process for accessing **pgAdmin** in a Dockerized environment connected to an existing **PostgreSQL** database.

---

## **🚀 Features**

1. **Quick Setup**: Deploy **pgAdmin** with minimal configuration.
2. **Customizable Ports**: Access **pgAdmin** via a user-defined port.
3. **Network Integration**: Connect **pgAdmin** to an existing Docker network for seamless integration with **PostgreSQL**.
4. **Environment File Support**: Configure **pgAdmin** parameters via a `.env` file.

---

## **📌 Prerequisites**

- Docker must be installed and running on your system.
- Docker Compose must be installed.
- Git must be installed and available in your system's PATH.
  ```bash
  sudo apt install git       # For Debian/Ubuntu  
  sudo yum install git       # For CentOS/RHEL  
  brew install git           # For macOS  
  ```
- **Linux Only**: Ensure `dos2unix` is installed to handle line ending conversions if needed.
  ```bash
  sudo apt install dos2unix
  ```

---

## **📥 Installation Steps**

### **One Command Install and Clone**

#### **Windows**
Open PowerShell as Administrator and run:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; git clone https://github.com/amir377/docker-pgadmin-setup; cd docker-pgadmin-setup; ./install.ps1
```

#### **Linux/Mac**
Run the following command in your terminal:
```bash
git clone https://github.com/amir377/docker-pgadmin-setup && cd docker-pgadmin-setup && dos2unix install.sh && chmod +x install.sh && ./install.sh
```

---

## **🛠️ Manual Installation**

1. Clone the repository:
   ```bash
   git clone https://github.com/amir377/docker-pgadmin-setup.git
   cd docker-pgadmin-setup
   ```
2. Place your `docker-compose.example.yaml` file in the root directory (if not already provided).
3. Run the appropriate installation script:
    - For Windows: `install.ps1`
    - For Linux/Mac: `install.sh`
4. Follow the prompts to customize your setup:
    - Container name
    - Network name
    - pgAdmin port
    - PostgreSQL service name

---

## **📁 File Descriptions**

### **`install.ps1`**
Automates the setup process for Windows, including:
- Generating `.env` and `docker-compose.yaml` files.
- Ensuring Docker and Docker Compose are installed.
- Creating the specified Docker network.
- Building and starting the **pgAdmin** container.

### **`install.sh`**
Automates the setup process for Linux/Mac, including:
- Generating `.env` and `docker-compose.yaml` files.
- Ensuring Docker and Docker Compose are installed.
- Creating the specified Docker network.
- Building and starting the **pgAdmin** container.  

# Windows-backed container for developing, to be used like a CLI VM. Useful when your laptop has
# only 8GiB RAM...
#
# https://zachniblog.com/WindowsDockerSSH.html

# Indicates that the windowsservercore image will be used as the base image.
FROM mcr.microsoft.com/windows/servercore:20H2

SHELL ["powershell", "-command"]

# Workaround for unresolvable DNS (https://github.com/docker/for-win/issues/3810)
RUN Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 1.1.1.1

# Install choco
RUN powershell.exe "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

# Install stuff
RUN choco install neovim git rust -y;

# Enable wuauserv as it's needed by OpenSSH Server
RUN Get-ExecutionPolicy; \
    Set-Service -Name wuauserv -StartupType Automatic; \
    start-service wuauserv; \
    Rename-Computer DEV-CONTAINER; \
    New-LocalUser "root" -Password (ConvertTo-SecureString "qwer1234!@#$" -AsPlaintext -Force); \
    Set-LocalUser "administrator" -Password (ConvertTo-SecureString "qwer1234!@#$" -AsPlaintext -Force);

# Install the OpenSSH Server
RUN Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0; \
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force; \
    Start-Service sshd; \
    Set-Service -Name sshd -StartupType Automatic;

CMD powershell.exe

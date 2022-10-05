
# Cherry-pick wget

TODO

```ps
    wget ...?
```

# Config paths
Powershell config paths, in include order:

- Ordering
    - All Users, All Hosts
    - All Users, Current Host
    - **Current User, All Hosts**
    - Current user, Current Host
- Windows
    - $PSHOME\Profile.ps1
    - $PSHOME\Microsoft.PowerShell_profile.ps1
    - **$Home\Documents\WindowsPowerShell\Profile.ps1**
    - $Home\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
- Linux
    - /usr/local/microsoft/powershell/7/profile.ps1
    - /usr/local/microsoft/powershell/7/Microsoft.Powershell_profile.ps1
    - **~/.config/powershell/profile.ps1**
    - ~/.config/powershell/Microsoft.Powershell_profile.ps1
- OSX
    - /usr/local/microsoft/powershell/7/profile.ps1
    - /usr/local/microsoft/powershell/7/Microsoft.Powershell_profile.ps1
    - **~/.config/powershell/profile.ps1**
    - ~/.config/powershell/Microsoft.Powershell_profile.ps1
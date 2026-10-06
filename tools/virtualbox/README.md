# 🖥️ xLFr4n // VirtualBox Lab Tools

## 🇪🇸 Español

Ejecutar desde el host Windows. `-Audit` y `-Plan` son de solo lectura; `-Apply` requiere VMs apagadas y confirmación explícita.

~~~powershell
.\xlfr4n-lab-vbox.ps1 -Audit
.\xlfr4n-lab-vbox.ps1 -Plan -NetworkName XLFR4N-LAB -VMNames Kali,DC01,WS01,WEB01
.\xlfr4n-lab-vbox.ps1 -Apply -NetworkName XLFR4N-LAB -VMNames Kali,DC01,WS01,WEB01
.\xlfr4n-lab-snapshot.ps1 -VMName WEB01 -SnapshotName WEB01-clean -Create -Plan
.\xlfr4n-lab-snapshot.ps1 -VMName WEB01 -SnapshotName WEB01-clean -Create -Apply
.\xlfr4n-lab-snapshot.ps1 -VMName WEB01 -List
~~~

Crear un snapshot requiere `CREATE`; restaurar uno requiere `RESET`.

## 🇺🇸 English

Run these helpers from the Windows host. `-Audit` and `-Plan` are read-only; `-Apply` requires powered-off VMs and explicit confirmation.

The snapshot helper uses literal `CREATE` confirmation for creation and `RESET` for restore.

**⚡ xLFr4n · Plan first · Apply deliberately**
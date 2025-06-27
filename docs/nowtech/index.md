# Nowtech

## Useful commands

Create SQL Backup folder link

```batch
mklink /d "C:\Program Files\Microsoft SQL Server\MSSQL16.PUIGNAU\MSSQL\Backup" "D:\SQL Backups"
```

## Shortcut to start SQL Server

```batch
C:\Windows\System32\cmd.exe /c "net stop "MSSQL$PUIGNAU" & net start "MSSQL$PUIGNAU""
```

## Inventari IT

[https://te972244229-my.sharepoint.com/:x:/g/personal/enric_paredes_nowtechsite_com/EaX_BOqQ8Y5Gpu5kGPkSCbEBAmJk5m06M6rULj4oROqhOg?e=Z69SC5](https://te972244229-my.sharepoint.com/:x:/g/personal/enric_paredes_nowtechsite_com/EaX_BOqQ8Y5Gpu5kGPkSCbEBAmJk5m06M6rULj4oROqhOg?e=Z69SC5)

## Deploy

```bash
GIT_USER=estmi DEPLOYMENT_BRANCH=gh-pages yarn deploy
```

# Conectar-se a PesVal

## Infraestructura

PesVal es una Maquina Virtual autocontinguda on l'SQL server esta instalat dins d'ella mateixa.

IP: `192.168.0.221`

## Com em conecto

### Puignau

Fent un simple RDP a la maquina `192.168.0.221` ens podem connectar.

### Exterior

Per poder-nos conectar desde fora, haurem d'utilitzar un programari especial, TailScale.

Un cop instalat el programari, haurem de utilitzar els credencials del correu `tailscale@pesval.com`.

Un cop connectats dins de la xarxa de pesval(TailScale), farem una connexio rdp a la IP: `100.72.53.69`

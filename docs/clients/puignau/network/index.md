--- 
hide_table_of_contents: true
---
# Diagrames de xarxa

```kroki type=nwdiag
nwdiag {
inet1 [shape = cloud];
inet2 [shape = cloud];
  inet2 -- routerMovistar;
  network Movistar {
    address = "192.168.1.0/24"

    Firewall;
    routerMovistar;
  }
  network Goufone {
    address = "192.168.0.0/24"

    Firewall;
    routerGoufone;
  }
  inet1 -- routerGoufone;
  network Interna {
    address = "192.168.0.0/24";
    Firewall;
  }
}
```

```kroki type=nwdiag
nwdiag {
inet1 [shape = cloud];
inet2 [shape = square];
  inet2 -- routerMovistar;
  inet1 -- routerGoufone;
  network Movistar {
    address = "192.168.1.0/24"

    Firewall;
    routerMovistar;
  }
  
  network Goufone {
    address = "210.x.x.x/24"

    Firewall;
    routerGoufone;
  }
  network Interna {
    address = "192.168.0.0/24";

    Firewall [address = "192.168.0.254"];
    PPNTABLETS01 [address = "192.168.0.4"];
    PPNDOMAIN1 [address = "192.168.0.5"];
    PPNDOMAIN2 [address = "192.168.0.9"];
    PPNMySQL [address = "192.168.0.12"];
    PPNTS02 [address = "192.168.0.13"];
    PPNArchius [address = "192.168.0.15"];
    PPNTSBROKER [address = "192.168.0.16"];
    PPNTS03 [address = "192.168.0.17"];
    PPNTS04 [address = "192.168.0.18"];
    NAS [address = "192.168.0.34"];
    NASLacie [address = "192.168.0.19"];
  }
   
  
}
```

# Diagrames

[Exemples](https://kroki.io/examples.html#nwdiag)

```txt
graphviz
digraph network {
    rankdir=LR;

    Client [shape=box];
    Firewall [shape=diamond];
    WebServer [shape=ellipse];
    AppServer [shape=ellipse];
    Database [shape=cylinder];

    Client -> Firewall [label="HTTPS"];
    Firewall -> WebServer [label="Allow 443"];
    WebServer -> AppServer [label="API Call"];
    AppServer -> Database [label="SQL"];
}
```

```graphviz
digraph network {
    rankdir=LR;

    Client [shape=box];
    Firewall [shape=diamond];
    WebServer [shape=ellipse];
    AppServer [shape=ellipse];
    Database [shape=cylinder];

    Client -> Firewall [label="HTTPS"];
    Firewall -> WebServer [label="Allow 443"];
    WebServer -> AppServer [label="API Call"];
    AppServer -> Database [label="SQL"];
}
```

```plantuml
@startuml
!define RECTANGLE class
skinparam class {
  BackgroundColor White
  BorderColor Black
}

RECTANGLE Client
RECTANGLE Firewall
RECTANGLE WebServer
RECTANGLE AppServer
RECTANGLE Database

Client --> Firewall : HTTP/HTTPS
Firewall --> WebServer : Allow 80/443
WebServer --> AppServer : REST API
AppServer --> Database : SQL Queries

@enduml
```

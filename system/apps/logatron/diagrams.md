# Logatron Diagrams

## Domain Model

```mermaid

classDiagram
  User  o-- Profile : at least 1
  Profile o-- Leaf : at least 1
  Leaf  o-- Model : at least 1

```

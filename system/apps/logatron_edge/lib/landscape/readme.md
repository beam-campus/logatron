# Landscape System

## Description

**LogatronEdge.Landscape.System** is and LogatronEdge.Application subsystem that is responsible for managing the regions in the landscape.

## Diagrams

### Sequence Diagram

```mermaid
sequenceDiagram
    participant Edge.Application
    participant Landscape.System
    participant Landscape.Regions
    participant Landscape.Builder
    Edge.Application->>Landscape.System: start_link
    Landscape.System->>Landscape.Regions: start_link
    Landscape.System->>Landscape.Builder: start_link    

```
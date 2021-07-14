# Transitive Routing
Cloud Network architecture for transitive routing. Transitive routing describes the technology to route data between two networks via an intermediary network.

There are several architectures where transitive routing improves scability, improves security, and simplifies operational management.

- Single Hub and Spoke
- Multi-hub and Spoke
- Cloud to On-premises

## Single Hub and Spoke Architecture
Coming Soon.

## Multi-hub Architecture
This design works well for multi-region data center architectures. If a network is leverage two or more regional datacenters with services deployed to each then each data center should function as a single hub for that data center. When data needs to move from one datacenter's hub to a spoke of another datacenter's hub then transitive routing can be leveraged instead of peering the remote hub with the local spoke. Transitive routing supports network access between the spokes of disparate hubs.

### Azure
#### Singe Subscription
This architecture will use Azure native services for network, routing, and route definitions. Virtual machines are deployed to each hub and spoke as a resource to validate the architecture. In a production environment, PaaS (along with IaaS) is also supported using private endpoints. This design uses a single subscription.

The following Azure native services are deployed:
1. Subscription
2. Resource Groups
3. VNET with Subnets
4. Virtual Network Gateway
5. VNET Peer
6. VNET Connection
7. Route Tables
8. Windows 2019 Datacenter Virtual Machine


#### Multi-Subscription
Coming Soon.

## Cloud to On-premises
Coming Soon.

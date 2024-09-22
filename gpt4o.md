What you’re aiming to build is a fully automated home lab environment with SaltStack for configuration management, Docker for containerized services, NGINX as a reverse proxy, and WireGuard for VPN and IP assignment. You want to automate the entire lifecycle, including provisioning, service deployment, and network configuration, without excessive manual intervention.

This kind of setup is typically called **infrastructure orchestration** or **service automation**, and you’re right to avoid something too complex given your needs. Here's a breakdown of the approach and tools that can simplify the process:

### Tools You’ll Want to Use
1. **SaltStack** for Configuration Management & Orchestration
2. **Docker** for Containerized Services
3. **WireGuard** for VPN and IP management
4. **NGINX** for Reverse Proxying
5. **Docker Compose / Docker Swarm** for Container Orchestration
6. **Autodiscovery and Dynamic Reverse Proxying for NGINX** (Optional)

Let me walk you through how you can achieve this.

---

### 1. **SaltStack: Centralized Configuration Management**
SaltStack is ideal for provisioning and managing your client nodes (servers). You can create a highstate for each node that:

- Installs Docker
- Sets up networking via WireGuard
- Prepares the node for hosting services (e.g., Docker Compose)
- Automatically deploys the right services on the right nodes

SaltStack can use **beacons** to monitor state changes and **reactors** to trigger certain actions. For instance, when a new client node is added, SaltStack can automatically provision it by installing Docker, configuring the WireGuard tunnel, and preparing it for deployment.

Use **Salt formulas** to define reusable configurations for Docker and NGINX.

### 2. **WireGuard for VPN and IP Assignment**
WireGuard will be responsible for setting up a private network across your servers and assigning internal IPs for NGINX to forward traffic. You can automate WireGuard configuration with SaltStack by:

- Setting up a formula that auto-generates WireGuard configurations for each new server.
- Using SaltStack’s reactor system to apply the WireGuard configuration to new nodes once they are registered.

This way, you don’t have to manually assign IPs to each server.

### 3. **Docker and Docker Compose for Service Deployment**
Instead of manually running containers on specific servers, you can use SaltStack to:

- Deploy a **Docker Compose** file to the server based on available resources (CPU, RAM, etc.).
- **SaltStack can query hardware details** using grains and determine where best to run a particular container or service.

Alternatively, if your services are small and don't require complicated orchestration, you can use **Docker Swarm**, which is simpler than Kubernetes but provides easy scaling and service distribution across nodes.

### 4. **NGINX as a Reverse Proxy with Dynamic Configurations**
You’ll want to avoid manually configuring NGINX each time a new service is spun up. Instead, you can:

- Use **NGINX with dynamic configuration**, leveraging a tool like **Consul** or **etcd** as a service registry. When new services (containers) are deployed, they register themselves, and NGINX can automatically update its reverse proxy configurations.
- Alternatively, you can use **nginx-proxy** with Docker. This automatically updates NGINX configurations based on Docker labels, so as you deploy a new container with a specific hostname, the reverse proxy updates itself.

For example, you can run nginx-proxy on your hub server, and when a new service is spun up on any client node, it automatically registers with nginx-proxy based on the `VIRTUAL_HOST` Docker label.

### 5. **Automating Service Deployment with Docker Compose/Swarm**
To make sure services are automatically deployed without manual intervention:

- Use **SaltStack’s orchestration** to detect new nodes, provision them with Docker, and deploy the correct services using **Docker Compose** or **Swarm**.
- SaltStack can check resource availability (using grains) and deploy services based on this information, ensuring each service runs on a suitable node.

If you opt for Docker Swarm, it will automatically distribute services across your nodes without you manually selecting which node to use. You can define constraints (e.g., host memory, CPU) to guide this process.

### 6. **Autogenerate NGINX Configurations (Optional)**
If using Docker labels with **nginx-proxy** is too simple for your setup, another option is to write a SaltStack module or reactor that:

- Automatically generates a new NGINX configuration block each time a service is spun up.
- Reloads the NGINX service after updating the configuration.

---

### High-Level Workflow Summary
1. **Provisioning New Nodes**: 
   - When a new client node is added, SaltStack detects it.
   - SaltStack installs Docker, configures WireGuard, and sets up networking on the new node.

2. **Automatic IP Assignment**:
   - WireGuard assigns a unique VPN IP to each node.
   - NGINX or nginx-proxy forwards traffic to the appropriate node using this internal IP.

3. **Deploying Services Automatically**:
   - You define your services in Docker Compose files or Docker Swarm stacks.
   - SaltStack determines which node should host the service based on available resources and deploys it automatically.

4. **Dynamic Reverse Proxy Configuration**:
   - NGINX dynamically updates its configuration whenever a new service is deployed, either through Consul, etcd, or Docker labels (via nginx-proxy).
   - Traffic is automatically forwarded to the right node based on the service URI.

---

### Suggested Tools
- **SaltStack**: Automates provisioning and service deployment.
- **WireGuard**: VPN and IP assignment.
- **Docker + Docker Compose**: Containers and service management.
- **nginx-proxy** or NGINX with dynamic config**: Automatically updates reverse proxy configuration.
- **Consul or etcd** (optional): Can be used as a service discovery mechanism to make your NGINX configuration dynamic.

### Additional Tips
- Start small with Docker Compose and SaltStack formulas before deciding if you need a service discovery tool like Consul or etcd.
- Use Docker labels to simplify service discovery if you want to avoid the overhead of something like Consul.
- Monitor and test your resource allocation logic in SaltStack to ensure services are deployed optimally based on hardware.

With this setup, you’ll have minimal manual intervention, and the entire environment will be dynamically managed.

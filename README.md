<div align="center"><img src="logo.png" style="width:250px;"></div>

# The BHive
im going to avoid my usual mistake of writing the documentation before i make the project and then having to rewrite it because i did everything differently than how i planned to :)  
Plans can be found on my channel: https://www.youtube.com/watch?v=F4nBRwdqYw0

Notes:
- to avoid confusion, the orchestrator/root node should always be referred to as the "Hub".
- running any of the scripts may greatly fuck up your system, YOU HAVE BEEN WARNED
- ill be making endpoints with fastapi because at the end of the day im 1 guy maintaining this shit
- i think ill have fastapi running independantly of nginx? i might go back on this solely for SSL reasons but in terms of nginx i think its sole role will be that of a reverse proxy. nginx will do nothing but route traffic to the worker nodes, period girl.

# Roadmap

1. **Project Planning and Initial Setup**
   - [X] Outline Objectives and Requirements
   - [X] Define the main goals of the Beehive project.
   - [X] List hardware and software requirements.
   - [X] Evaluate Current Setup
   - [X] Document current VPS providers and cloud storage solutions.
   - [X] List existing home servers and their configurations.

2. **Current Infrastructure Analysis**
   - [X] Identify current issues with SSH, Docker setup, and system reinstallation.

3. **Design and Architecture**
   - [X] Create a Network Diagram
   - [X] Visualize the desired network setup including home servers, cloud providers, and the conductor node.
   - [X] Security Planning
   - [X] Plan firewall rules and network segmentation.
   - [X] Determine authentication mechanisms (e.g., Aelia, 2FA).

4. **Hardware and Software Acquisition**
   - [X] Collect all necessary hardware (home servers, networking equipment).
   - [X] Ensure all hardware meets project requirements.

5. **Install Base Operating Systems**
   - [X] Install Ubuntu or other preferred OS on all servers.

6. **Automation Scripts and Configuration**
   - [ ] Develop Automation Scripts
   - [ ] Write scripts for server setup and configuration.
   - [ ] Create Docker-compose files for each service.
   - [ ] Orchestrator Node Setup
   - [ ] Configure the conductor node with Nginx for load balancing and reverse proxy.
   - [ ] Implement secure remote access through SSH for troubleshooting.
   - [ ] Implement script to add new servers to the fleet.

7. **Service Deployment**
   - [ ] Service Setup
   - [ ] Develop and test setup scripts for each service (e.g., Jellyfin, qBittorrent, Calibre-web).
   - [ ] Configure services to run in Docker containers.
   - [ ] Resource Allocation
   - [ ] Set up the orchestrator node to handle resource allocation for new servers and services.

8. **Security Implementation**
   - [ ] Configure Firewall Rules
   - [ ] Apply strict firewall rules on all servers.
   - [ ] Ensure no server can be accessed by its IP directly.
   - [ ] Set Up Authentication
   - [ ] Implement Aelia for user authentication.
   - [ ] Enable two-factor authentication (2FA).

9. **Unified VPS and Home Server Management**
   - [ ] Integrate cloud storage providers using rclone.
   - [ ] Set up a centralized management interface for all servers.

10. **Monitoring and Maintenance**
  - [ ] Set up Grafana for monitoring server health and performance.
  - [ ] Implement logging and alerting mechanisms.
  - [ ] Regularly update and maintain all scripts and configurations.
  - [ ] Implement a backup strategy for configuration files and scripts (e.g., GitHub).

11. **Testing and Troubleshooting**
  - [ ] Test Server Connectivity
    - [ ] Verify SSH connections and remote access to all servers.
    - [ ] Test reverse SSH tunnels for reliability.
  - [ ] Service Testing
    - [ ] Ensure all services are accessible via the orchestrator node.
    - [ ] Check the performance and reliability of services.

12. **Documentation and Maintenance**
  - [ ] Document Setup Procedures
    - [ ] Create detailed documentation for setting up and adding new servers and services.
    - [ ] Write guides for common troubleshooting steps.
  - [ ] Backup and Failover Planning
    - [ ] Implement backup strategies for setup scripts and configurations.
    - [ ] Plan for failover mechanisms if required in the future.

13. **Review and Feedback**
  - [ ] Gather Feedback
    - [ ] Present the initial setup to peers for feedback.
    - [ ] Make adjustments based on the feedback received.
  - [ ] Continuous Improvement
    - [ ] Regularly review the setup for potential improvements.
    - [ ] Stay updated with the latest best practices in home lab setups.


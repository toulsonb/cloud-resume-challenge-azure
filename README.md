# Cloud Resume Challenge (Azure Edition)

This repository contains the infrastructure and code for my implementation of the Cloud Resume Challenge on Microsoft Azure. While most candidates typically use AWS for this challenge, I chose Azure to broaden my multi-cloud experience and demonstrate proficiency in the Azure ecosystem.

The live project can be found at [bradtoulson.com/resume](https://bradtoulson.com/resume).

## Architecture Overview

The project is built using a serverless architecture to ensure cost-efficiency and scalability. 

*   **Frontend:** A static website hosted on Azure Blob Storage, served through Cloudflare for DNS management, SSL, and edge routing.
*   **Backend API:** An Azure Function (PowerShell) that handles the visitor counter logic.
*   **Database:** Azure Cosmos DB (NoSQL) running in serverless mode to store and retrieve the visitor count.
*   **Infrastructure as Code:** 100% of the environment is defined and managed via Terraform.
*   **CI/CD:** Automated deployment pipelines using GitHub Actions with OpenID Connect (OIDC) for secure, passwordless authentication to Azure.

## Project Structure

*   `/terraform`: Contains all the HCL files for provisioning Azure resources, including the API, storage, and networking components.
*   `/backend`: The PowerShell-based Azure Function code and unit tests.
*   `/frontend`: The static HTML/CSS/JS files for the resume website.

## Key Implementation Details

### Governance and Cost Control
To emulate an enterprise environment, I implemented strict resource tagging (owner, environment, project, cost center) and configured Azure budget alerts to monitor and control spending.

### Security
Instead of using static secrets, I configured a Microsoft Entra ID (formerly Azure AD) app registration with OIDC Federated Trust. This allows GitHub Actions to authenticate securely to Azure without storing long-lived credentials.

### Testing
The backend includes local Pester unit tests to verify the functionality of the PowerShell Azure Function before deployment.

### Infrastructure State
Terraform state is stored in a dedicated backend (Azure Blob Storage) within a separate resource group. This ensures that the state remains protected even if the production or development resource groups are destroyed during iterations.

## More Information
A detailed technical case study of this project, including the architectural trade-offs and lessons learned, is available on my website: [The Cloud Resume Challenge - Technical Case Study](https://bradtoulson.com/projects/resume).
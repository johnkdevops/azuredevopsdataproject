# Azure Data Infrastructure Terraform

This repository provisions an Azure-based data infrastructure using Terraform, designed for data processing and analytics workloads. The infrastructure includes an Azure resource group, Azure Data Lake Storage Gen2, Azure Databricks workspace and an Azure Synapse Analytics workspace with a serverless SQL pool. A secrets file (`bigdataintegrationsecrets.txt`) is generated for external use, containing resource details and credentials.

## Overview

The Terraform configuration deploys the following Azure resources in the specified subscription:
- **Resource Group**: `DataPipelineRG` to organize resources.
- **Azure Data Lake Storage Gen2**: `datastorage<random>` with filesystem `filestorage<random>` for data storage.
- **Azure Databricks Workspace**: `data-pipeline-db` .
- **Azure Synapse Analytics Workspace**: `data-pipeline-synapse-<random>` for analytics and querying.
- **Secrets File**: `./secrets/bigdataintegrationsecrets.txt` containing resource details (e.g., storage endpoint, cluster ID, Synapse credentials).

The infrastructure is modularized for reusability and maintainability, with separate modules for each resource type.

### Architecture

- **Resource Group**: Central container for all resources.
- **Storage**: Data Lake Gen2 for storing raw and processed data, with access granted to the current user.
- **Databricks**: Workspace and using Databricks job cluster.
- **Synapse**: Analytics workspace for querying Data Lake data using serverless SQL.
- **Secrets**: Output file for integration with external tools or processes.

## Prerequisites

- **Azure Subscription**: Active subscription with ID.
- **Azure CLI**: Installed and authenticated via `az login`.
- **Terraform**: Version >= 1.5.x.
- **Permissions**: Contributor access to the subscription for the user running Terraform.
- **Git**: For cloning the repository.

## Setup Instructions

### 1. Fork this repo

### 2. Clone the Repository
```bash
git clone https://github.com/<your-username>/azurdevopsdataproject.git
cd azuredevopsdataproject


azuredevopsdataproject/
├── main.tf                        # Root module calling child modules
├── variables.tf                   # Input variables
├── outputs.tf                     # Outputs (e.g., storage_account_name)
├── terraform.tfvars               # Example variable values 
├── .gitignore                     # Ignore sensitive files
├── README.md                      # Repository documentation
├── scripts/
│   ├── generate_tfvars.sh         # Create terraform.tfvars interactively
│   ├── generate_sql_password.sh   # Create a secure sql password 
│   ├── destroy_with_cleanup.sh    # Destroy Terraform resources and clean up secrets file if needed
├── modules/
│   ├── resource_group/
│   │   ├── main.tf                # Resource group resource
│   │   ├── variables.tf           # Module-specific variables
│   │   ├── outputs.tf             # Module outputs
│   ├── storage/
│   │   ├── main.tf                # Storage account and filesystem
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── databricks/
│   │   ├── main.tf               # Databricks workspace and PAT
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── synapse/
│   │   ├── main.tf          # Synapse workspace and firewall
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── secrets/
│   │   ├── main.tf          # Secrets file null resource
│   │   ├── variables.tf
│   │   ├── outputs.tf
├── notebooks/
│   ├── process_data.py      # Databricks notebook script
├── synapse/
│   ├── analyze_sales.sql    # Synapse SQL query
├── azure-pipelines.yml      # Azure DevOps pipeline
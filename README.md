# databricks_sandbox
Reusable Terraform modules to provision simple, cost-effective Databricks sandbox environments in Azure. Designed for quick deployment, easy teardown, and alignment with secure reference architectures.

## Databricks Sandbox Terraform Module

This project provides a modular set of Terraform templates to deploy **Databricks sandbox environments on Azure**. It's designed for simplicity, cost-efficiency, and reusability in mind — enabling data engineers at made tech to quickly spin up and tear down sandbox workspaces with minimal overhead.

---

## Modules

- `networking/` – Basic VNet and subnet creation (no PrivateLink)
- `iam/` – Optional RBAC roles (basic defaults)
- `storage/` – Blob storage for Terraform state
- `databricks_workspace/` – Public Databricks workspace provisioning

---



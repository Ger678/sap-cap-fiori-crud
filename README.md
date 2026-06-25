# sap-cap-fiori-crud

Full CRUD application built with **SAP Cloud Application Programming Model (CAP)** and **SAP Fiori Elements**. This project demonstrates enterprise-grade patterns for building OData services on SAP BTP.

## 🎯 What This Project Demonstrates

- CDS (Core Data Services) entity modeling with associations and compositions
- OData V4 service exposure via CAP
- Fiori Elements ListReport + ObjectPage with annotations
- CRUD operations with proper CAP handlers (before/on/after)
- Input validation and error handling in CAP
- SAP HANA deployment configuration
- Local SQLite development setup

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| SAP CAP (Node.js) | Backend service & OData exposure |
| CDS | Data modeling & service definition |
| SAP Fiori Elements | Frontend (auto-generated UI) |
| OData V4 | API protocol |
| SAP HANA / SQLite | Database |
| Cloud Foundry | Deployment target |

## 📁 Project Structure

```
sap-cap-fiori-crud/
├── db/
│   └── schema.cds          # Data model definitions
├── srv/
│   ├── catalog-service.cds # Service definition
│   └── catalog-service.js  # Custom handlers
├── app/
│   └── fiori/
│       └── annotations.cds # Fiori Elements annotations
├── package.json
└── mta.yaml                # Multi-target app descriptor
```

## 🚀 Getting Started

```bash
# Install dependencies
npm install

# Run locally with SQLite (no HANA needed)
cds watch

# Deploy to BTP Cloud Foundry
cf login
mbt build
cf deploy mta_archives/*.mtar
```

## 📚 Key Concepts Covered

**CDS Modeling**
- Entities with UUID keys
- Managed associations (1:N, N:M)
- CDS aspects (managed, cuid)
- Enumerations

**CAP Handlers**
- `before` hooks for input validation
- `on` handlers for custom logic
- `after` hooks for post-processing
- Error handling with `req.error()`

**Fiori Elements Annotations**
- `@UI.LineItem` for list columns
- `@UI.FieldGroup` for object page sections
- `@UI.Facets` for page layout
- `@Common.Label` for field labels

## 🔗 Related SAP BTP Resources

- [SAP CAP Documentation](https://cap.cloud.sap/)
- [Fiori Elements Feature Showcase](https://github.com/SAP-samples/fiori-elements-feature-showcase)
- [SAP BTP Tutorials](https://developers.sap.com/tutorial-navigator.html)

## 👤 Author

**Germán Aguirre** — SAP BTP Developer at DL Consultores
- LinkedIn: [german-aguirre](https://www.linkedin.com/in/german-aguirre/)
- GitHub: [@Ger678](https://github.com/Ger678)

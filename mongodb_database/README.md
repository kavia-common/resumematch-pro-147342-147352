# MongoDB Database Guide

This folder contains MongoDB documentation, schemas, seed data, and utility scripts for the ResumeMatch Pro application.

Important note about database choice:
- Primary database: MongoDB
- Legacy artifacts: Some scripts and files in this folder reference MySQL, PostgreSQL, or SQLite (e.g., backup_db.sh, restore_db.sh, startup.sh, db_visualizer/mysql.env). These exist for legacy or optional workflows and are not required for running the app with MongoDB.
- This README and the schemas/seed files herein define the canonical MongoDB source of truth for this project.

Quick start (MongoDB)
1) Configure environment
   - Copy mongodb.env.example to your environment and set:
     - MONGODB_URL: the MongoDB connection string (e.g., mongodb://localhost:27017)
     - MONGODB_DB: the database name (e.g., resumematch)

2) Create collections and indexes
   - Collections are created automatically on first insert.
   - Recommended indexes are documented in schemas/indexes.json. You can create them via a migration or a simple script (to be implemented in the backend). For testing, you can also create them interactively with mongosh.

3) Seed demo data
   - Run the seed script to populate minimal demo records for each collection:
     - Ensure MONGODB_URL and MONGODB_DB are set in your environment
     - Run: bash seed/seed.sh

Environment variables
- MONGODB_URL: connection string to your cluster (e.g., mongodb://localhost:27017)
- MONGODB_DB: database name to use (e.g., resumematch)

Optional: File storage / GridFS
- If you plan to store original resume uploads (PDF/DOCX) or large files in Mongo, consider using GridFS.
- A common pattern is to store the file in GridFS and reference its ObjectId in the uploads collection (see schemas/collections.md for the uploads schema).
- GridFS is optional; small files may be stored in the uploads collection as base64 or external object storage with URL references.

Interacting with MongoDB
- CLI: mongosh "${MONGODB_URL}/${MONGODB_DB}"
- Node/Java/Go/etc.: Use official drivers and the environment variables above.

Notes on legacy scripts
- backup_db.sh and restore_db.sh include logic for several databases, but support MongoDB dumps/restores via mongodump/mongorestore when MongoDB is detected.
- startup.sh currently focuses on MySQL initialization. It is not needed for MongoDB. Do not use it for MongoDB.
- db_visualizer includes support for multiple databases, including MongoDB, and is optional.

Next steps for backend integration
- Use the collections and indexes specified to build repositories/data access layers.
- Respect the field names and types to ensure compatibility with the seed data and future migrations.

Support
- If you encounter issues, verify your MONGODB_URL and MONGODB_DB and that your MongoDB server is reachable.

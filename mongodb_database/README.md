# MongoDB - ResumeMatch Pro

This container provides environment variable templates for connecting the backend to MongoDB.

Environment variables:
- MONGODB_URL: e.g., mongodb://localhost:27017
- MONGODB_DB: e.g., resumematch_pro

Quick start (local MongoDB):
1) Ensure MongoDB is running locally on port 27017.
2) Use the defaults:
   MONGODB_URL=mongodb://localhost:27017
   MONGODB_DB=resumematch_pro

Backend expectations:
- The Spring Boot backend reads MONGODB_URL and MONGODB_DB from its environment.
- If unset, it defaults to mongodb://localhost:27017 and database resumematch_pro.

Example CLI usage:
mongo "mongodb://localhost:27017/resumematch_pro"

# MongoDB Collections and Schemas

This document defines the MongoDB collections used by ResumeMatch Pro and the canonical fields for each collection. Types are indicative; MongoDB is schemaless but we recommend enforcing these via application validation.

Conventions
- All documents have:
  - _id: ObjectId
  - createdAt: Date (UTC)
  - updatedAt: Date (UTC)
- References use ObjectId fields with a suffix Id (e.g., userId, resumeId).
- Where applicable, string enums are suggested for status/type fields.

1) users
Represents a registered user of the platform (job seeker, recruiter, or coach).

Fields:
- _id: ObjectId
- email: string (unique, lowercase)
- passwordHash: string (hashed password, or external auth metadata if applicable)
- role: string enum ['seeker', 'recruiter', 'coach', 'admin'] (default: 'seeker')
- profile:
  - firstName: string
  - lastName: string
  - headline: string (optional)
  - avatarUrl: string (optional)
- settings:
  - notifications: boolean (default: true)
  - locale: string (default: 'en')
- createdAt: Date
- updatedAt: Date

2) resumes
Stores resume metadata and parsed content for analysis.

Fields:
- _id: ObjectId
- userId: ObjectId (ref: users)
- title: string (user-friendly name, e.g., "Data Scientist Resume")
- source:
  - type: string enum ['upload', 'text', 'url']
  - uploadId: ObjectId (ref: uploads, optional if type=upload)
  - originalFilename: string (optional)
- parsed:
  - rawText: string (full extracted text)
  - keywords: [string] (normalized keywords extracted)
  - sections:
    - summary: string (optional)
    - experience: [ { company: string, role: string, startDate: string, endDate: string|null, description: string } ]
    - education: [ { institution: string, degree: string, startYear: number, endYear: number|null } ]
    - skills: [string]
    - certifications: [string]
- metrics:
  - wordCount: number
  - lastAnalyzedAt: Date|null
- createdAt: Date
- updatedAt: Date

3) job_descriptions
Represents a job description to be matched against resumes.

Fields:
- _id: ObjectId
- userId: ObjectId (ref: users; e.g., recruiter who added it)
- title: string
- company: string
- location: string (optional)
- text: string (original JD text)
- parsed:
  - keywords: [string]
  - requirements: [string]
  - niceToHave: [string]
- createdAt: Date
- updatedAt: Date

4) analyses
Stores the AI analysis results for a given resume and job description.

Fields:
- _id: ObjectId
- userId: ObjectId (ref: users)
- resumeId: ObjectId (ref: resumes)
- jobDescriptionId: ObjectId (ref: job_descriptions)
- status: string enum ['pending', 'completed', 'failed'] (default: 'pending')
- scores:
  - matchScore: number (0-100)
  - keywordCoverage: number (0-100)
  - atsCompatibility: number (0-100)
- suggestions:
  - summary: string (overall advice)
  - improvements: [ { field: string, current: string, suggestion: string, priority: string enum ['low', 'medium', 'high'] } ]
- artifacts:
  - highlightedResume: string (optional, annotated text)
  - missingKeywords: [string]
- createdAt: Date
- updatedAt: Date

5) matches
Aggregated matching records between a resume and a job description.

Fields:
- _id: ObjectId
- userId: ObjectId (ref: users)
- resumeId: ObjectId (ref: resumes)
- jobDescriptionId: ObjectId (ref: job_descriptions)
- matchScore: number (0-100)
- rationale: string (explanation of the score)
- matchedKeywords: [string]
- createdAt: Date
- updatedAt: Date

6) uploads
Stores metadata about uploaded files. For large binaries, use GridFS and store the fileId here.

Fields:
- _id: ObjectId
- userId: ObjectId (ref: users)
- kind: string enum ['resume', 'attachment']
- storage:
  - strategy: string enum ['gridfs', 'base64', 'external']
  - fileId: ObjectId (GridFS ObjectId if strategy='gridfs')
  - url: string (if strategy='external')
  - base64: string (if strategy='base64'; small files only)
- originalFilename: string
- mimeType: string
- sizeBytes: number
- createdAt: Date
- updatedAt: Date

Indexing recommendations
- See schemas/indexes.json for recommended indexes and text search suggestions.
